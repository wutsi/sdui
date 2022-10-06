import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import 'package:flutter_chat_ui/flutter_chat_ui.dart';
import 'package:logger/logger.dart';
import 'package:sdui/sdui.dart';
import 'package:uuid/uuid.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

/// Chat widget based on [flutter_chat_ui](https://pub.dev/packages/flutter_chat_ui)
class SDUIChat extends SDUIWidget {
  String? fetchMessageUrl;
  String? rtmUrl;
  String? roomId;
  String? userId;
  String? userFirstName;
  String? userLastName;
  String? userPictureUrl;
  String? recipientUserId;
  String? language;
  double? fontSize;
  String? receivedMessageBackground;
  String? receivedMessageTextColor;
  String? sentMessageBackground;
  String? sentMessageTextColor;
  bool? showUserNames;
  bool? showUserAvatars;
  String? tenantId;
  String? deviceId;

  @override
  SDUIWidget fromJson(Map<String, dynamic>? json) {
    rtmUrl = json?["rtmUrl"];
    fetchMessageUrl = json?["fetchMessageUrl"];
    userId = json?["userId"];
    roomId = json?["roomId"];
    userFirstName = json?["userFirstName"];
    userLastName = json?["userLastName"];
    userPictureUrl = json?["userPictureUrl"];
    recipientUserId = json?["recipientUserId"];
    language = json?["language"];
    fontSize = json?["fontSize"];
    receivedMessageBackground = json?["receivedMessageBackground"];
    receivedMessageTextColor = json?["receivedMessageTextColor"];
    sentMessageBackground = json?["sentMessageBackground"];
    sentMessageTextColor = json?["sentMessageTextColor"];
    showUserNames = json?["showUserNames"];
    showUserAvatars = json?["showUserAvatars"];
    tenantId = json?["tenantId"];
    deviceId = json?["deviceId"];
    return super.fromJson(json);
  }

  @override
  Widget toWidget(BuildContext context) => _ChatWidgetStateful(this);
}

class _ChatWidgetStateful extends StatefulWidget {
  final SDUIChat delegate;

  const _ChatWidgetStateful(this.delegate, {Key? key}) : super(key: key);

  @override
  // ignore: no_logic_in_create_state
  State<StatefulWidget> createState() => _ChatWidgetState(delegate);
}

class _ChatWidgetState extends State<_ChatWidgetStateful> {
  final Logger _logger = LoggerFactory.create('_ChatWidgetState');
  final SDUIChat _delegate;
  List<types.Message> _messages = [];
  types.User _user = const types.User(id: '');
  RTM? _rtm;
  int _page = 0;

  _ChatWidgetState(this._delegate);

  @override
  void initState() {
    super.initState();

    // Current user
    _user = types.User(
        id: _delegate.userId ?? "",
        firstName: _delegate.userFirstName,
        lastName: _delegate.userLastName,
        imageUrl: _delegate.userPictureUrl);

    // Fetch messages
    _fetchMessages(0);

    // Connect to RTM API
    if (_delegate.rtmUrl != null) {
      _rtm = RTM(
          roomId: _delegate.roomId ?? const Uuid().toString(),
          url: _delegate.rtmUrl!,
          messageHandler: (message) => _handleRTMMessage(message));
    }
  }

  @override
  void dispose() {
    _rtm?.bye();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Chat(
        showUserAvatars: _delegate.showUserAvatars ?? true,
        showUserNames: _delegate.showUserNames ?? true,
        messages: _messages,
        user: _user,
        l10n: _toL10(),
        theme: DefaultChatTheme(
          primaryColor: _primaryColor(),
          secondaryColor: _secondaryColor(),
          dateDividerMargin: const EdgeInsets.only(bottom: 5.0, top: 5),
          dateDividerTextStyle:
              TextStyle(fontSize: _fontSize(), fontWeight: FontWeight.bold),
          errorColor: Colors.red,
          inputPadding: const EdgeInsets.all(5.0),
          inputMargin: const EdgeInsets.all(1.0),
          inputBorderRadius: BorderRadius.zero,
          inputTextStyle: TextStyle(
              fontFamily: null,
              fontWeight: FontWeight.normal,
              fontSize: _fontSize()),
          messageBorderRadius: 5.0,
          messageInsetsHorizontal: 5.0,
          messageInsetsVertical: 5.0,
          receivedEmojiMessageTextStyle: TextStyle(fontSize: _fontSize()),
          receivedMessageBodyTextStyle: TextStyle(
            color: _delegate.toColor(_delegate.receivedMessageTextColor) ??
                Colors.black,
            fontSize: _fontSize(),
          ),
          sentEmojiMessageTextStyle: TextStyle(fontSize: _fontSize()),
          sentMessageBodyTextStyle: TextStyle(
            color: _delegate.toColor(_delegate.sentMessageTextColor) ??
                Colors.white,
            fontSize: _fontSize(),
          ),
        ),
        onSendPressed: (message) => _onSend(message),
        onEndReached: () => _fetchMessages(_page + 1),
      );

  double _fontSize() => _delegate.fontSize ?? 12.0;

  Color _primaryColor() =>
      _delegate.toColor(_delegate.sentMessageBackground) ??
      Color(int.parse('FF1D7EDF', radix: 16));

  Color _secondaryColor() =>
      _delegate.toColor(_delegate.receivedMessageBackground) ??
      Color(int.parse('FFe4edf7', radix: 16));

  ChatL10n _toL10() {
    switch (_delegate.language?.toLowerCase()) {
      case 'fr':
        return const ChatL10nFr();
      case 'de':
        return const ChatL10nDe();
      case 'es':
        return const ChatL10nEs();
      default:
        return const ChatL10nEn();
    }
  }

  void _onSend(types.PartialText message) {
    _logger.i('_onSend $message');

    // Create the message
    final msg = types.TextMessage(
        author: _user,
        createdAt: DateTime.now().millisecondsSinceEpoch,
        id: const Uuid().v4(),
        text: message.text,
        roomId: _delegate.roomId,
        showStatus: true,
        status: types.Status.sending,
        metadata: {
          'recipientId': _delegate.recipientUserId,
          'tenantId': _delegate.tenantId,
          'deviceId': _delegate.deviceId
        });

    // Add on the UI
    setState(() {
      _messages.insert(0, msg);
    });

    // Send to backend
    try {
      if (_rtm?.send(msg) == true) {
        _updateStatus(msg, types.Status.sent);
      } else {
        _updateStatus(msg, types.Status.error);
      }
    } catch (e) {
      _logger.e('Unable to send the message', e);
      _updateStatus(msg, types.Status.error);
    }
  }

  void _updateStatus(types.Message msg, types.Status status) {
    setState(() {
      var i = _messages.indexOf(msg);
      if (i >= 0) {
        _messages.remove(msg);
        _messages.insert(i, msg.copyWith(status: status));
      }
    });
  }

  Future<void> _fetchMessages(int page) {
    if (_delegate.fetchMessageUrl == null) return Future.value();

    var url = _fetchUrl(page);
    _logger.i('Loading messages: $url');
    return Http.getInstance().post(url, {}).then((value) {
      final messages = (jsonDecode(value) as List)
          .map((e) => types.Message.fromJson(e as Map<String, dynamic>))
          .toList();
      if (messages.isNotEmpty) {
        setState(() {
          _page = page;
          if (_page == 0) {
            _messages = messages;
          } else {
            _messages.addAll(messages);
          }
        });
      }
    });
  }

  String _fetchUrl(int page) {
    var buff = StringBuffer();
    buff.write(_delegate.fetchMessageUrl);
    buff.write(_delegate.fetchMessageUrl?.contains('?') == true ? '&' : '?');
    buff.write("page=$page");
    return buff.toString();
  }

  void _handleRTMMessage(dynamic message) {
    _logger.i('_handleRTMMessage $message');
  }
}

@immutable
class ChatL10nFr extends ChatL10n {
  const ChatL10nFr()
      : super(
            attachmentButtonAccessibilityLabel: 'Envoyez media',
            emptyChatPlaceholder: 'Aucun message',
            fileButtonAccessibilityLabel: 'Fichier',
            inputPlaceholder: 'Message',
            sendButtonAccessibilityLabel: 'Envoyez',
            unreadMessagesLabel: 'Messages non lus');
}

enum MessageType { hello, send, bye }

typedef MessageHandler = void Function(dynamic message);

class RTM {
  final Logger _logger = LoggerFactory.create('RTM');
  final String roomId;
  final String url;
  final MessageHandler messageHandler;
  bool _connected = false;
  WebSocketChannel? _channel;
  Timer? _timer;

  RTM({required this.roomId, required this.url, required this.messageHandler}) {
    // Connect
    _connect();

    // Reconnect if needed every 30 seconds
    _timer =
        Timer.periodic(const Duration(seconds: 30), (timer) => _reconnect());
  }

  void hello() {
    var data = {'type': MessageType.hello.name, 'roomId': roomId};
    _logger.i('hello - $data');

    _channel?.sink.add(jsonEncode(data));
  }

  bool send(types.Message message) {
    var data = {
      'type': MessageType.send.name,
      'roomId': roomId,
      'chatMessage': message.toJson()
    };
    _logger.i('send - $data');

    if (!_connected) {
      _logger.i('Not connected to server');
      return false;
    }

    _channel?.sink.add(jsonEncode(data));
    return true;
  }

  void bye() {
    // Send message
    var data = {'type': MessageType.bye.name, 'roomId': roomId};
    _logger.i('bye - $data');
    _channel?.sink.add(jsonEncode(data));

    // Close the channel
    _channel?.sink.close();

    // Stop the timer
    _timer?.cancel();
  }

  void _onError(error) {
    _logger.i('onError $error');
  }

  void _onDone() {
    _logger.i('Server disconnected');
    _connected = false;
  }

  void _connect() {
    // Connect
    _logger.i('Connecting to $url');
    _channel = WebSocketChannel.connect(Uri.parse(url));
    _channel?.stream.listen((message) => messageHandler(message),
        onDone: () => _onDone(), onError: (error) => _onError(error));
    _connected = true;

    // Hello
    hello();
  }

  void _reconnect() {
    if (!_connected) {
      _connect();
    }
  }
}
