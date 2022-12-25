import 'package:flutter/cupertino.dart';
import 'package:sdui/src/widget.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

/// Class for handling the analytics.
/// This class does nothing. It's up the the application using this library
/// to provide it's own implementation and set the global variable [sduiAnalytics].
class SDUIChart extends SDUIWidget {
  String? _title;
  final List<List<ChartData>> _series = [];

  @override
  SDUIWidget fromJson(Map<String, dynamic>? json) {
    _title = json?["title"];

    var series = json?["series"];
    if (series is List<dynamic>) {
      List<ChartData> list = [];
      for (var element in series) {
        if (element is Map<String, dynamic>) {
          list.add(ChartData.fromJson(element));
        }
      }
      _series.add(list);
    }
    return super.fromJson(json);
  }

  @override
  Widget toWidget(BuildContext context) {
    return SfCartesianChart(
        title: _title == null ? null : ChartTitle(text: _title!),
        primaryXAxis: CategoryAxis(),
        series: _series.map((e) => LineSeries<ChartData, String>(
              dataSource: e,
              xValueMapper: (ChartData data, _) => data.x,
              yValueMapper: (ChartData data, _) => data.y,
            )));
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
}
