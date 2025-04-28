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
                barWidth: 5,
                color: const Color.fromARGB(139, 255, 193, 7),
                isCurved: true,
                belowBarData: BarAreaData(
                  gradient: LinearGradient(
                    colors: [const Color.fromARGB(110, 255, 193, 7), const Color.fromARGB(110, 244, 67, 54), const Color.fromARGB(110, 76, 175, 79)],
                    begin: Alignment.bottomCenter,
                    end: Alignment.topCenter,
                    ),
                  show: true,
                ),
              ),

            ],
          ),
          ),
        ),
      ),
    );
  }
}