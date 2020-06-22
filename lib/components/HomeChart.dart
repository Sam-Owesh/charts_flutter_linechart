import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import '../models/resource.dart';
import '../common/http.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:flustars/flustars.dart';

import 'dart:math' show Rectangle;
import "package:charts_flutter/src/text_element.dart" as chartsTextElement;
import 'package:charts_flutter/src/text_style.dart' as chartsTextStyle;
import 'package:charts_common/common.dart' as common show BasicDateTimeTickFormatterSpec;

import '../common/extends.dart';

String globalChartsTextSelected;
bool globalShouldRebuildCharts;

class HomeLineChart extends StatefulWidget {
  @override
  _HomeLineChart createState() => _HomeLineChart();
}

class _HomeLineChart extends State<HomeLineChart> {
  List spotMarketList;

  String _showType = '1';
  String _type = '1';

  httpData() async {
    var response = await GlgwangApis()
        .spotMarket(data: {"platform": 1, "showType": _showType, "type": _type});
    setState(() {
      spotMarketList = response['data']['list'];
      globalShouldRebuildCharts = true;
    });
  }

  @override
  void initState() {
    super.initState();
    httpData();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Container(
          decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(
            color: Color(0xffeeeeee),
          ))),
          padding: EdgeInsets.only(bottom: 0),
          child: _TypeTabs(
              lineWidth: 32.0,
              lineHeight: 3.0,
              labelBottomPadding: 8.0,
              dataList: steelTypes,
              tapFn: (index){
                setState(() {
                  _type = index;
                });
                httpData();
              },),
        ),
        Container(
          margin: EdgeInsets.only(top: 5.0),
          height: 130.0,
          child: spotMarketList!=null
            ? SimpleLineChart(
              spotMarketList: spotMarketList
            )
            : Center(child: CircularProgressIndicator(),),
        ),
        Container(
          margin: EdgeInsets.only(top: 6.0),
          child: _TypeTabs(
            lineWidth: 32.0,
            lineHeight: 3.0,
            labelBottomPadding: 8.0,
            dataList: timeTypes,
            tapFn: (index){
              setState(() {
                _showType = index;                
              });
              httpData();
            },),
        )
      ],
    );
  }
}

class _TypeTabs extends StatefulWidget {
  _TypeTabs(
      {Key key,
      this.lineWidth,
      this.lineHeight,
      this.labelBottomPadding,
      this.dataList,
      this.tapFn});
  final double lineWidth;
  final double lineHeight;
  final double labelBottomPadding;
  final List dataList;
  final Function tapFn;
  @override
  _TypeTabsState createState() => _TypeTabsState();
}

class _TypeTabsState extends State<_TypeTabs> {
  String _currentIndex = '1';
  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: widget.dataList.map((item) {
            return GestureDetector(
              onTap: () {
                setState(() {
                  _currentIndex = item['type'];
                  widget.tapFn(_currentIndex);
                });
              },
              child: Column(
                children: <Widget>[
                  Container(
                      padding:
                          EdgeInsets.only(bottom: widget.labelBottomPadding),
                      child: Text(
                        item['tab'],
                        style: TextStyle(
                            color: _currentIndex == item['type']
                                ? Color(0xffA89A60)
                                : Color(0xff666666)),
                      )),
                  Container(
                    child: ConstrainedBox(
                      constraints: BoxConstraints.tightFor(
                          width: widget.lineWidth, height: widget.lineHeight),
                      child: DecoratedBox(
                        decoration: BoxDecoration(
                            color: _currentIndex == item['type']
                                ? Color(0xffA89A60)
                                : Color(0xffffffff)),
                      ),
                    ),
                  )
                ],
              ),
            );
          }).toList(),
        )
      ],
    );
  }
}

class SimpleLineChart extends StatefulWidget {
  final spotMarketList;
  final shouldRebuildCharts;
  SimpleLineChart({this.spotMarketList,this.shouldRebuildCharts});

  @override
  State<StatefulWidget> createState() => new _SimpleLineChart();
}

class _SimpleLineChart extends State<SimpleLineChart> {
  charts.TimeSeriesChart chart;

  List<charts.Series<MyRow, DateTime>> _createSampleData(chartsData) {
       
    return [
      new charts.Series<MyRow, DateTime>(
          id: 'Headcount',
          colorFn: (_, __) => charts.MaterialPalette.blue.shadeDefault,
          domainFn: (MyRow row, _) => row.timeStamp,
          measureFn: (MyRow row, _) => row.headcount,
          dashPatternFn: (_, __) => null,
          strokeWidthPxFn: (_, __) => 1.0,
          radiusPxFn: (_, __) => 1.5,
          insideLabelStyleAccessorFn: (_, __) => charts.TextStyleSpec(),
          data: chartsData,
          overlaySeries: false)
    ];
  }

  _onSelectionUpdated(charts.SelectionModel model) {
    var selectedDatum = model.selectedDatum;
    String time;
    double price;
    if(selectedDatum.isNotEmpty){
      time = DateUtil.formatDate(selectedDatum.first.datum.timeStamp, format: 'yyyy-MM-dd');
      price = selectedDatum.first.datum.headcount;
      setState(() {
        globalChartsTextSelected = ' $time\n价格：$price';
      });
    }
  }
  
  charts.TimeSeriesChart _buildChart(BuildContext context){
    int length = widget.spotMarketList.length;
    List<MyRow> chartsData = [];
    List<charts.TickSpec<DateTime>> tickSpecs = [];    
    DateTime start = DateTime.now().subtract(new Duration(days: 7));
    DateTime end =  DateTime.now().subtract(new Duration(days: 1));
    if(length < 8){
      start = DateTime.fromMillisecondsSinceEpoch(widget.spotMarketList[0]['createTime']);
      end =  DateTime.fromMillisecondsSinceEpoch(widget.spotMarketList[length-1]['createTime']);
    }else{
      start = DateTime.fromMillisecondsSinceEpoch(widget.spotMarketList[0]['createTime']);
      end =  DateTime.fromMillisecondsSinceEpoch(widget.spotMarketList[5]['createTime']);
    }  
    widget.spotMarketList.forEach((item){
      if(item['createTime']!=null){
        chartsData.add(new MyRow(DateTime.fromMillisecondsSinceEpoch(item['createTime']), item['price']));
        tickSpecs.add(charts.TickSpec(
            DateTime.fromMillisecondsSinceEpoch(item['createTime']),
            style: charts.TextStyleSpec(fontSize: 10)
          )
        );
      }
    });

    var seriesList = _createSampleData(chartsData);
   
    return new charts.TimeSeriesChart(
        seriesList,
        defaultRenderer: new charts.LineRendererConfig(
          includePoints: true,
          includeArea: true,
          radiusPx: 1.5,
          strokeWidthPx: 1.0
        ),
        dateTimeFactory: const charts.LocalDateTimeFactory(),
        behaviors: [
          charts.LinePointHighlighter(
            showHorizontalFollowLine:
                charts.LinePointHighlighterFollowLineType.none,
            showVerticalFollowLine:
                charts.LinePointHighlighterFollowLineType.nearest,
            symbolRenderer: CustomCircleSymbolRenderer()
          ),
          // new charts.SlidingViewport(),
          new charts.PanAndZoomBehavior(),
        ],
        primaryMeasureAxis: new charts.NumericAxisSpec(
          // tickFormatterSpec: new charts.BasicNumericTickFormatterSpec.fromNumberFormat(new NumberFormat.simpleCurrency()),
          tickProviderSpec: new charts.BasicNumericTickProviderSpec(
              desiredMaxTickCount: 7,
              desiredMinTickCount: 4,
              zeroBound: false),
          renderSpec: new charts.GridlineRendererSpec(
              lineStyle: new charts.LineStyleSpec(dashPattern: [4, 4])
            )
          ),
        domainAxis: DateTimeAxisSpecWorkaround(
          viewport: charts.DateTimeExtents(
            start: start, 
            end: end
          ),
          tickFormatterSpec: common.BasicDateTimeTickFormatterSpec(
            (value){
              String timeStr = DateUtil.getDateStrByDateTime(value);
              return DateUtil.formatDateTime(timeStr,DateFormat.MONTH_DAY,'-','-');
            }
          ),
          tickProviderSpec:charts.StaticDateTimeTickProviderSpec(tickSpecs)
          // tickProviderSpec: charts.DayTickProviderSpec(increments: [1])
        ),
        selectionModels: [
          charts.SelectionModelConfig(
            updatedListener: _onSelectionUpdated
          )
        ],
        animate: false,
      );
  }

  @override
  Widget build(BuildContext context) {
    if (chart == null || globalShouldRebuildCharts) {
      chart = _buildChart(context);
      globalShouldRebuildCharts = false;
    }
    return Stack(
      alignment: Alignment.topCenter,
      textDirection: TextDirection.ltr,
      children: <Widget>[
        SizedBox(
          height: 130.0,
          child: Padding(
            padding: EdgeInsets.only(top: 15.0),
            child: chart,
          ),
        )
      ],
    );
  }
}

class CustomCircleSymbolRenderer extends charts.CircleSymbolRenderer {
  @override
  void paint(charts.ChartCanvas canvas, Rectangle<num> bounds,
      {List<int> dashPattern,
      charts.Color fillColor,
      charts.Color strokeColor,
      double strokeWidthPx}) {

    super.paint(canvas, bounds,
        dashPattern: dashPattern,
        fillColor: charts.Color.white,
        // strokeColor: charts.Color.black,
        strokeColor: charts.Color(r: 21,g: 123,b: 243),
        strokeWidthPx: 2);

    // Draw a bubble

    final num bubbleHight = 36;
    final num bubbleWidth = 81;
    // final num bubbleRadius = bubbleHight / 2.0;
    final num bubbleRadius = 2.0;
    final num bubbleBoundLeft = bounds.left;
    final num bubbleBoundTop = bounds.top - bubbleHight;

    canvas.drawRRect(
      Rectangle(bubbleBoundLeft, bubbleBoundTop, bubbleWidth, bubbleHight),
      fill: charts.Color(r: 47,g: 178,b: 250),
      stroke: charts.Color(r: 47,g: 178,b: 250),
      radius: bubbleRadius,
      roundTopLeft: true,
      roundBottomLeft: true,
      roundBottomRight: true,
      roundTopRight: true,
    );

    // Add text inside the bubble

    final textStyle = chartsTextStyle.TextStyle();
    textStyle.color = charts.Color.white;
    textStyle.fontSize = 12;

    final chartsTextElement.TextElement textElement =
        chartsTextElement.TextElement(globalChartsTextSelected, style: textStyle);

    final num textElementBoundsLeft = ((bounds.left +
            (bubbleWidth - textElement.measurement.horizontalSliceWidth) / 2))
        .round();
    final num textElementBoundsTop = (bounds.top - 30).round();

    canvas.drawText(textElement, textElementBoundsLeft, textElementBoundsTop);
  }
}

class MyRow {
  final DateTime timeStamp;
  final double headcount;
  MyRow(this.timeStamp, this.headcount);
}