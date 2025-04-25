import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: HomePage(),
    ); //MeterialApp
  }
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 181, 146, 202),
      body: Center(
        child: AspectRatio(aspectRatio: 2.0,
         child: LineChart(
          LineChartData(
            lineBarsData: [
              LineChartBarData(
                spots: const [
                  FlSpot(0, 0),
                  FlSpot(1, 3),
                  FlSpot(2, 6),
                  FlSpot(3, 4),
                  FlSpot(4, 8),
                  FlSpot(5, 12)
                ],
                color: Colors.amber,
                isCurved: true,
              )
            ]
          )
          ),
        ),
      ),
    );
  }
}