import 'package:firebase_messaging/firebase_messaging.dart';

typedef FirebaseMessagingHandler = void Function(RemoteMessage);

///
/// Handle remote message
///
FirebaseMessagingHandler sduiFirebaseMessagingBackgroundHandler = (msg) {};
FirebaseMessagingHandler sduiFirebaseMessagingForegroundHandler = (msg) {};
