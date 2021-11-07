import 'package:logger/logger.dart';

class LoggerFactory {
  static Logger create(String name) => Logger(printer: LogPrinterImpl(name));
}

class LogPrinterImpl extends LogPrinter {
  final String _name;

  LogPrinterImpl(this._name);

  @override
  List<String> log(LogEvent event) {
    DateTime now = DateTime.now();
    List<String> result = [];

    result.add(
        "$now - Name=$_name Level=${event.level.toString().toUpperCase()} : ${event.message}");
    if (event.error != null) {
      result.add('Error:\n:${event.error}');
    }
    if (event.stackTrace != null) {
      result.add('Cause:\n${event.stackTrace!}');
    }
    return result;
  }
}
