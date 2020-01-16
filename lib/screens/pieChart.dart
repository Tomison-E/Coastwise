import 'package:charts_flutter/flutter.dart' as charts;
import 'package:flutter/material.dart';
import 'package:leeway/models/chart.dart';



class PieCharts extends StatelessWidget {
  final List<charts.Series> seriesList;
  final bool animate;
  static List<Chart> chart;

  PieCharts({@required this.seriesList,this.animate});


  /// Creates a [PieChart] with sample data and no transition.
  factory PieCharts.withSampleData() {
    return new PieCharts(
      seriesList: _createSampleData(),
      // Disable animations for image tests.
      animate: false,
    );
  }


  @override
  Widget build(BuildContext context) {
    return new charts.PieChart(seriesList,
        animate: animate,
        defaultRenderer: new charts.ArcRendererConfig(arcRendererDecorators: [
          new charts.ArcLabelDecorator(
              labelPosition: charts.ArcLabelPosition.outside)
        ]));
  }

  /// Create one series with sample hard coded data.
  static List<charts.Series<Chart, int>> _createSampleData() {
    final data = chart;

    return [
      new charts.Series<Chart, int>(
        id: 'Sales',
        domainFn: (Chart sales, _) => sales.variable,
        measureFn: (Chart sales, _) => sales.value,
        data: data,
        // Set a label accessor to control the text of the arc label.
        labelAccessorFn: (Chart row, _) => '${row.variable}: ${row.value}',
      )
    ];
  }
}
