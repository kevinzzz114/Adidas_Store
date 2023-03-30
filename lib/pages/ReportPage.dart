import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:charts_flutter/flutter.dart' as charts;

import '../dataFetcher.dart';

class ReportPage extends StatefulWidget {
  @override
  _ReportPageState createState() => _ReportPageState();
}

class _ReportPageState extends State<ReportPage> {
  List<SalesData> _data = [];

  @override
  void initState() {
    super.initState();
    _fetchData();
  }

  Future<void> _fetchData() async {
    final monthlyResponse = await http.get(Uri.parse(
        '${DataFetcher.databaseUrl}/fetch_data.php?action=getMonthlySales'));
    final yearlyResponse = await http.get(Uri.parse(
        '${DataFetcher.databaseUrl}/fetch_data.php?action=getYearlySales'));

    if (monthlyResponse.statusCode == 200 && yearlyResponse.statusCode == 200) {
      final monthlyJsonData = jsonDecode(monthlyResponse.body) as List<dynamic>;
      final monthlyData = monthlyJsonData
          .map((item) => SalesData(item['month'], double.parse(item['sales'])))
          .toList();
    

      final yearlyJsonData = jsonDecode(yearlyResponse.body) as List<dynamic>;
      final yearlyData = yearlyJsonData
          .map((item) => SalesData(item['year'], double.parse(item['sales'])))
          .toList();

      _data = [...monthlyData, ...yearlyData];

      setState(() {});
    } else {
      throw Exception('Failed to load sales data');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Sales Chart'),
      ),
      body: _data.isEmpty
          ? Center(child: CircularProgressIndicator())
          : charts.BarChart(
              [
                charts.Series<SalesData, String>(
                  id: 'Sales',
                  colorFn: (_, __) => charts.MaterialPalette.blue.shadeDefault,
                  domainFn: (sales, _) => sales.time,
                  measureFn: (sales, _) => sales.sales,
                  data: _data.where((sales) => sales.time.length == 7).toList(),
                ),
                charts.Series<SalesData, String>(
                  id: 'Yearly Sales',
                  colorFn: (_, __) => charts.MaterialPalette.red.shadeDefault,
                  domainFn: (sales, _) => sales.time,
                  measureFn: (sales, _) => sales.sales,
                  data: _data.where((sales) => sales.time.length == 4).toList(),
                ),
              ],
              animate: true,
              vertical: false,
              barRendererDecorator: charts.BarLabelDecorator<String>(),
              domainAxis: charts.OrdinalAxisSpec(
                renderSpec: charts.SmallTickRendererSpec(labelRotation: 60),
              ),
            ),
    );
  }
}

class SalesData {
  final String time;
  final double sales;

  SalesData(this.time, this.sales);
}
