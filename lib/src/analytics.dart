/// Class for handling the analytics.
/// This class does nothing. It's up the the application using this library
/// to provide it's own implementation and set the global variable [sduiAnalytics].
class SDUIAnalytics {
  /// This method will be called when user navigate to a route
  void onRoute(String id) {}

  /// Start a trace
  dynamic startTace(String id) {}

  /// End a trace
  void endTrace(dynamic trace) {}

  /// This method will be called when button is clicked
  void onClick(String id) {}
}

/// Analytics global variable
SDUIAnalytics sduiAnalytics = SDUIAnalytics();
