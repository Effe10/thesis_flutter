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

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int selectedChart = 0;

  Widget _buildChart() {
    switch (selectedChart) {
      case 0:
        return LineChart(
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
                color: const Color.fromARGB(153, 103, 187, 255),
                isCurved: true,
                belowBarData: BarAreaData(
                  color: const Color.fromARGB(110, 103, 187, 255),
                  show: true,
                ),
              ),
            ],
          ),
        );
      case 1:
        return BarChart(
          BarChartData(
            barGroups: [
              BarChartGroupData(x: 0, barRods: [
                BarChartRodData(toY: 8, color: Colors.blue)
              ]),
              BarChartGroupData(x: 1, barRods: [
                BarChartRodData(toY: 10, color: Colors.blue)
              ]),
              BarChartGroupData(x: 2, barRods: [
                BarChartRodData(toY: 14, color: Colors.blue)
              ]),
              BarChartGroupData(x: 3, barRods: [
                BarChartRodData(toY: 15, color: Colors.blue)
              ]),
            ],
          ),
        );
      case 2:
        return PieChart(
          PieChartData(
            sections: [
              PieChartSectionData(value: 40, color: Colors.blue, title: '40%'),
              PieChartSectionData(value: 30, color: Colors.red, title: '30%'),
              PieChartSectionData(value: 15, color: Colors.green, title: '15%'),
              PieChartSectionData(value: 15, color: Colors.orange, title: '15%'),
            ],
          ),
        );
      case 3:
        return LineChart(
          LineChartData(
            lineBarsData: [
              LineChartBarData(
                spots: const [
                  FlSpot(0, 5),
                  FlSpot(1, 2),
                  FlSpot(2, 8),
                  FlSpot(3, 6),
                  FlSpot(4, 7),
                  FlSpot(5, 3)
                ],
                barWidth: 5,
                color: Colors.red,
                isCurved: false,
                belowBarData: BarAreaData(
                  color: const Color.fromARGB(80, 244, 67, 54),
                  show: true,
                ),
              ),
            ],
          ),
        );
      default:
        return const SizedBox.shrink();
    }
  }

  @override
  Widget build(BuildContext context) {
    const String appTitle = 'Flutter fl_chart Demo';
    return Scaffold(
      appBar: AppBar(title: const Text(appTitle)),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: () => setState(() => selectedChart = 0),
                  child: const Text('Line 1'),
                ),
                ElevatedButton(
                  onPressed: () => setState(() => selectedChart = 1),
                  child: const Text('Bar'),
                ),
                ElevatedButton(
                  onPressed: () => setState(() => selectedChart = 2),
                  child: const Text('Pie'),
                ),
                ElevatedButton(
                  onPressed: () => setState(() => selectedChart = 3),
                  child: const Text('Line 2'),
                ),
              ],
            ),
          ),
          Expanded(
            child: Center(
              child: AspectRatio(
                aspectRatio: 2.0,
                child: _buildChart(),
              ),
            ),
          ),
        ],
      ),
    );
  }
}