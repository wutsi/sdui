import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';

typedef FirebaseMessageHandler = void Function(RemoteMessage, bool);
typedef FirebaseTokenHandler = void Function(String?);
typedef FirebaseSelectionHandler = void Function(String?, BuildContext);

/// Method called when a background message is received
FirebaseMessageHandler sduiFirebaseMessageHandler = (msg, foreground) {};

/// Method called when the token is resolved
FirebaseTokenHandler sduiFirebaseTokenHandler = (token) {};

/// Method called when a message is selected
FirebaseSelectionHandler sduiSelectionHandler = (payload, context) {};

/// Reference to the icon
String sduiFirebaseIconAndroid = '@mipmap/ic_launcher';
