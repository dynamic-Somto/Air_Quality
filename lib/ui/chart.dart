import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import '../data/model/api/thingspeak.dart';

class Chart extends StatelessWidget {
  final ValueNotifier<List<ThingSpeakData>> dataList;
  const Chart({Key? key, required this.dataList}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: dataList,
      builder: (context, value, _) {
        return LineChart(
          sampleData2,
          swapAnimationDuration: const Duration(milliseconds: 250),
        );
      }
    );
  }

  LineChartData get sampleData2 => LineChartData(
    lineTouchData: lineTouchData2,
    gridData: gridData,
    titlesData: titlesData2,
    borderData: borderData,
    lineBarsData: lineBarsData2,
    minX: 0,
    maxX: 10,
    maxY: 1000,
    minY: 0,
  );

  LineTouchData get lineTouchData2 => LineTouchData(
    enabled: false,
  );

  FlTitlesData get titlesData2 => FlTitlesData(
    bottomTitles: AxisTitles(
      sideTitles: bottomTitles,
    ),
    rightTitles: AxisTitles(
      sideTitles: SideTitles(showTitles: false),
    ),
    topTitles: AxisTitles(
      sideTitles: SideTitles(showTitles: false),
    ),
    leftTitles: AxisTitles(
      sideTitles: leftTitles(),
    ),
  );

  List<LineChartBarData> get lineBarsData2 => [
    lineChartBarData2_2,
  ];

  Widget leftTitleWidgets(double value, TitleMeta meta) {
    return Text('${value.toInt()}', style: const TextStyle(
      color: Color(0xff75729e),
      fontWeight: FontWeight.bold,
      fontSize: 12,
    ), textAlign: TextAlign.center);
  }

  SideTitles leftTitles() => SideTitles(
    getTitlesWidget: leftTitleWidgets,
    showTitles: true,
    interval: 200,
    reservedSize: 40,
  );

  SideTitles get bottomTitles => SideTitles(
    showTitles: true,
    reservedSize: 50,
    interval: 1,
    getTitlesWidget: (value, meta)=> const Text(''),
  );

  FlGridData get gridData => FlGridData(show: false);

  FlBorderData get borderData => FlBorderData(
    show: true,
    border: const Border(
      bottom: BorderSide(color: Color(0xff4e4965), width: 1),
      left: BorderSide(color: Color(0xff4e4965), width: 1),
      right: BorderSide(color: Colors.transparent),
      top: BorderSide(color: Colors.transparent),
    ),
  );

  LineChartBarData get lineChartBarData2_2 => LineChartBarData(
    isCurved: true,
    curveSmoothness: 0,
    color: const Color(0x99aa4cfc),
    barWidth: 2,
    isStrokeCapRound: true,
    dotData: FlDotData(show: true),
    belowBarData: BarAreaData(
      show: true,
      color: const Color(0x33aa4cfc),
    ),
    spots: List.generate(dataList.value.length, (index) => FlSpot(index.toDouble(), dataList.value[index].entryId.toDouble()))
  );
}