import 'package:firebase_messaging/firebase_messaging.dart';

typedef FirebaseTokenHandler = void Function(String?);
typedef FirebaseMessageHandler = void Function(RemoteMessage);

/// Method called when the token is resolved
FirebaseTokenHandler sduiFirebaseTokenHandler = (token) {};

/// Method called to handle the
FirebaseMessageHandler sduiFirebaseMessageHandler = (message) {};

/// Reference to the icon
String sduiFirebaseIconAndroid = '@mipmap/ic_launcher';
