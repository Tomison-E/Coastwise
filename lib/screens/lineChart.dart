import 'package:charts_flutter/flutter.dart' as charts;
import 'package:flutter/material.dart';
import 'package:leeway/models/chart.dart';


class PointsLineChart extends StatelessWidget {
  static List<charts.Series> seriesList;
  final bool animate;
  final  List<Chart> profits;

  PointsLineChart(this.profits,{this.animate});

  /// Creates a [LineChart] with sample data and no transition.
  factory PointsLineChart.withSampleData() {
    return new PointsLineChart(
      [], // Disable animations for image tests.
      animate: false,
    );
  }


  @override
  Widget build(BuildContext context) {
    seriesList = _createSampleData();
    return new charts.LineChart(seriesList,
        animate: animate,
        defaultRenderer: new charts.LineRendererConfig(includePoints: true));
  }

  /// Create one series with sample hard coded data.
   List<charts.Series<Chart, int>> _createSampleData() {
    final data = profits;

    return [
      new charts.Series<Chart, int>(
        id: 'Sales',
        colorFn: (_, __) => charts.MaterialPalette.blue.shadeDefault,
        domainFn: (Chart sales, _) => sales.variable,
        measureFn: (Chart sales, _) => sales.value,
        data: data,
      )
    ];
  }
}

