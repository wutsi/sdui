import 'package:logger/logger.dart';

import 'logger.dart';
import 'widget.dart';

typedef SDUIWidgetFactory = SDUIWidget Function();

/// Registry for 3rd party widgets
class SDUIWidgetRegistry {
  static final SDUIWidgetRegistry _singleton = SDUIWidgetRegistry._internal();
  final Map<String, SDUIWidgetFactory> _factories = {};
  final Logger _logger = LoggerFactory.create('SDUIWidgetRegistry');

  SDUIWidgetRegistry._internal();

  factory SDUIWidgetRegistry() {
    return _singleton;
  }

  static SDUIWidgetRegistry getInstance() => _singleton;

  bool register(String type, SDUIWidgetFactory factory) {
    String key = type.toLowerCase();
    if (_factories.containsKey(key)) {
      _logger.w('Widget already registered, registration skipped: $type');
      return false;
    } else {
      _logger.i('Registering widget: $type');
      _factories[key] = factory;
      return true;
    }
  }

  SDUIWidget? create(String type) {
    SDUIWidgetFactory? factory = _factories[type.toLowerCase()];
    return factory?.call();
  }
}
