/// Class for handling the analytics.
/// This class does nothing. It's up the the application using this library
/// to provide it's own implementation and set the global variable [sduiAnalytics].
class SDUIAnalytics {
  /// This method will be called when user navigate to a route
  void onRoute(String screenId) {}

  /// This method will be called when action is executed
  void onAction(String screenId, String event, String? productId) {}
}

/// Analytics global variable
SDUIAnalytics sduiAnalytics = SDUIAnalytics();
