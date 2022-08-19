typedef DeelinkHandler = String? Function(Uri);

///
/// This method convert a deeplink URI to an internal URL.
/// If the deeplink URI is not recognize, this method should return null
///
DeelinkHandler sduiDeeplinkHandler = (uri) => null;
