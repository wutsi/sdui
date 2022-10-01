import 'package:flutter/material.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import 'package:flutter_chat_ui/flutter_chat_ui.dart';
import 'package:sdui/sdui.dart';
import 'package:uuid/uuid.dart';

/// Chat widget based on [flutter_chat_ui](https://pub.dev/packages/flutter_chat_ui)
class SDUIChat extends SDUIWidget {
  String? sendMessageUrl;
  String? userId;
  String? userFirstName;
  String? userLastName;
  String? userPictureUrl;

  @override
  SDUIWidget fromJson(Map<String, dynamic>? json) {
    sendMessageUrl = json?["sendMessageUrl"];
    userId = json?["userId"];
    userFirstName = json?["userFirstName"];
    userLastName = json?["userLastName"];
    userPictureUrl = json?["userPictureUrl"];
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
  final SDUIChat _delegate;
  List<types.Message> _messages = [];
  types.User _user = const types.User(id: '');

  _ChatWidgetState(this._delegate);

  @override
  void initState() {
    super.initState();

    _messages = [];
    _user = types.User(
        id: _delegate.userId ?? "",
        firstName: _delegate.userFirstName,
        lastName: _delegate.userLastName,
        imageUrl: _delegate.userPictureUrl);
  }

  @override
  Widget build(BuildContext context) => Chat(
      showUserAvatars: true,
      showUserNames: true,
      messages: _messages,
      user: _user,
      onSendPressed: (message) => _onSend(message));

  void _onSend(types.PartialText message) {
    final msg = types.TextMessage(
      author: _user,
      createdAt: DateTime.now().millisecondsSinceEpoch,
      id: const Uuid().v4(),
      text: message.text,
    );

    setState(() {
      _messages.insert(0, msg);
    });
  }
}
