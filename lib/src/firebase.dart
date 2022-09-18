import 'package:firebase_messaging/firebase_messaging.dart';

typedef FirebaseMessageHandler = void Function(RemoteMessage);
typedef FirebaseTokenHandler = void Function(String?);

///
/// Handle remote message
///
FirebaseMessageHandler sduiFirebaseBackgroundMessageHandler = (msg) {};
FirebaseMessageHandler sduiFirebaseForegroundMessageHandler = (msg) {};
FirebaseTokenHandler sduiFirebaseTokenHandler = (token) {};
