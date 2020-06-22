import 'package:charts_flutter/flutter.dart' as charts;
import 'package:charts_flutter/flutter.dart';
class DateTimeAxisSpecWorkaround extends charts.DateTimeAxisSpec {
  const DateTimeAxisSpecWorkaround({
    RenderSpec<DateTime> renderSpec,
    DateTimeTickProviderSpec tickProviderSpec,
    DateTimeTickFormatterSpec tickFormatterSpec,
    bool showAxisLine,
    DateTimeExtents viewport
  }) : super(
            renderSpec: renderSpec,
            tickProviderSpec: tickProviderSpec,
            tickFormatterSpec: tickFormatterSpec,
            showAxisLine: showAxisLine,
            viewport:viewport);
  @override
  configure(Axis<DateTime> axis, ChartContext context,
      GraphicsFactory graphicsFactory) {
    super.configure(axis, context, graphicsFactory);
    axis.autoViewport = false;
  }
}