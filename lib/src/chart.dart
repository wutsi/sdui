import 'package:flutter/cupertino.dart';
import 'package:sdui/src/logger.dart';
import 'package:sdui/src/widget.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

/// Class for handling the analytics.
/// This class does nothing. It's up the the application using this library
/// to provide it's own implementation and set the global variable [sduiAnalytics].
class SDUIChart extends SDUIWidget {
  final _logger = LoggerFactory.create("SDUIChart");
  String? _title;
  final List<List<ChartData>> _series = [];

  @override
  SDUIWidget fromJson(Map<String, dynamic>? json) {
    _title = json?["title"];

    var series = json?["series"];

    if (series is List<dynamic>) {
      for (var element in series) {
        if (element is List<dynamic>) {
          List<ChartData> serie = [];

          for (var data in element) {
            if (data is Map<String, dynamic>) {
              _logger.i('Adding data: $data');
              serie.add(ChartData.fromJson(data));
            } else {
              _logger.i('Not data: $data');
            }
          }

          _logger.i('serie= $serie');
          _series.add(serie);
        }
      }
    }
    return super.fromJson(json);
  }

  @override
  Widget toWidget(BuildContext context) {
    return SfCartesianChart(
        title: _title == null ? null : ChartTitle(text: _title!),
        primaryXAxis: CategoryAxis(),
        series: _toSeries());
  }

  List<LineSeries> _toSeries() {
    var result = <LineSeries>[];
    for (var element in _series) {
      result.add(LineSeries<ChartData, String>(
        dataSource: element,
        xValueMapper: (ChartData data, _) => data.x,
        yValueMapper: (ChartData data, _) => data.y,
      ));
    }

    return result;
  }
}

class ChartData {
  String? x;
  double? y;

  static ChartData fromJson(Map<String, dynamic> json) {
    var data = ChartData();
    data.x = json["x"];
    data.y = json["y"];

    return data;
  }

  @override
  String toString() => "ChartData($x = $y)";
}
