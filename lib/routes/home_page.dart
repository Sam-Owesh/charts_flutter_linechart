import 'package:flutter/material.dart';
import '../components/HomeChart.dart';
import '../components/BarCharts.dart';
class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: EdgeInsets.all(15.0),
      children: <Widget>[
        Container(
          child: HomeLineChart(),
        ),
        Container(
          margin: EdgeInsets.only(top: 15.0),
          child: SlidingViewportOnSelection.withSampleData(),
        )
      ],
    );
  }
}