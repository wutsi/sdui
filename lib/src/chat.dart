import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import 'package:flutter_chat_ui/flutter_chat_ui.dart';
import 'package:logger/logger.dart';
import 'package:sdui/sdui.dart';
import 'package:uuid/uuid.dart';

/// Chat widget based on [flutter_chat_ui](https://pub.dev/packages/flutter_chat_ui)
class SDUIChat extends SDUIWidget {
  String? sendMessageUrl;
  String? fetchMessageUrl;
  String? roomId;
  String? userId;
  String? userFirstName;
  String? userLastName;
  String? userPictureUrl;
  String? language;
  double? fontSize;
  String? receivedMessageBackground;
  String? receivedMessageTextColor;
  String? sentMessageBackground;
  String? sentMessageTextColor;
  bool? showUserNames;
  bool? showUserAvatars;

  @override
  SDUIWidget fromJson(Map<String, dynamic>? json) {
    sendMessageUrl = json?["sendMessageUrl"];
    fetchMessageUrl = json?["fetchMessageUrl"];
    userId = json?["userId"];
    roomId = json?["roomId"];
    userFirstName = json?["userFirstName"];
    userLastName = json?["userLastName"];
    userPictureUrl = json?["userPictureUrl"];
    language = json?["language"];
    fontSize = json?["fontSize"];
    receivedMessageBackground = json?["receivedMessageBackground"];
    receivedMessageTextColor = json?["receivedMessageTextColor"];
    sentMessageBackground = json?["sentMessageBackground"];
    sentMessageTextColor = json?["sentMessageTextColor"];
    showUserNames = json?["showUserNames"];
    showUserAvatars = json?["showUserAvatars"];
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

  _ChatWidgetState(this._delegate);

  @override
  void initState() {
    super.initState();

    _user = types.User(
        id: _delegate.userId ?? "",
        firstName: _delegate.userFirstName,
        lastName: _delegate.userLastName,
        imageUrl: _delegate.userPictureUrl);
    _fetchMessages();
  }

  @override
  Widget build(BuildContext context) =>
      Chat(
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
            errorIcon: const Icon(Icons.error, size: 8.0, color: Colors.red),
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
            seenIcon: const Icon(Icons.check, size: 8.0),
            sentEmojiMessageTextStyle: TextStyle(fontSize: _fontSize()),
            sentMessageBodyTextStyle: TextStyle(
              color: _delegate.toColor(_delegate.sentMessageTextColor) ??
                  Colors.white,
              fontSize: _fontSize(),
            ),
          ),
          onSendPressed: (message) => _onSend(message));

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
    _logger.i('_onSend');

    final msg = types.TextMessage(
        author: _user,
        createdAt: DateTime
            .now()
            .millisecondsSinceEpoch,
        id: const Uuid().v4(),
        text: message.text,
        roomId: _delegate.roomId,
        showStatus: true,
        status: types.Status.sending);

    setState(() {
      _messages.insert(0, msg);
    });

    if (_delegate.sendMessageUrl != null) {
      Http.getInstance().post(_delegate.sendMessageUrl!, {
        'author': _user,
        'createdAt': msg.createdAt,
        'id': msg.id,
        'text': msg.text,
        'roomId': msg.roomId
      }).then((value) {
        setState(() {
          _messages.remove(msg);
          _messages.insert(0, msg.copyWith(status: types.Status.sent));
        });
      }).onError((error, stackTrace) {
        setState(() {
          _messages.remove(msg);
          _messages.insert(0, msg.copyWith(status: types.Status.error));
        });
      });
    }
  }

  void _fetchMessages() {
    if (_delegate.fetchMessageUrl == null) return;

    Http.getInstance().post(_delegate.fetchMessageUrl!, {}).then((value) {
      final messages = (jsonDecode(value) as List)
          .map((e) => types.Message.fromJson(e as Map<String, dynamic>))
          .toList();
      setState(() {
        _messages = messages;
      });
    });
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
  );
}
