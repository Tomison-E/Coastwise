import 'package:charts_flutter/flutter.dart' as charts;
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:leeway/models/chart.dart';

class VerticalBarLabelChart extends StatelessWidget {
  final List<charts.Series> seriesList ;
  final bool animate;
  static  final currency = new  NumberFormat('#,##0.00','en_NG');
  static  List<Bar> chart;

  VerticalBarLabelChart({this.seriesList,this.animate});

  /// Creates a [BarChart] with sample data and no transition.
  factory VerticalBarLabelChart.withSampleData() {
    return new VerticalBarLabelChart(
      seriesList: _createSampleData(),
      // Disable animations for image tests.
      animate: false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return new charts.BarChart(
      seriesList,
      animate: animate,
      barRendererDecorator: new charts.BarLabelDecorator<String>(),
      domainAxis: new charts.OrdinalAxisSpec(),
    );
  }

  /// Create one series with sample hard coded data.
  static List<charts.Series<Bar, String>> _createSampleData() {
    final data = chart;

    return [
      new charts.Series<Bar, String>(
          id: 'Sales',
          domainFn: (Bar sales, _) => sales.variable,
          measureFn: (Bar sales, _) => sales.value,
          data: data,
          // Set a label accessor to control the text of the bar label.
          labelAccessorFn: (Bar sales, _) =>
          '₦ ${currency.format(sales.value)}')
    ];
  }
}
