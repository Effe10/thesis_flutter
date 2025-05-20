import 'package:fl_chart/fl_chart.dart';
import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;
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
      theme: ThemeData.dark().copyWith(
        colorScheme: ColorScheme.dark(
          primary: Colors.blue,
          secondary: Colors.blueAccent,
        ),
        scaffoldBackgroundColor: const Color(0xFF181818),
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFF222222),
        ),
        cardColor: const Color(0xFF232323),
      ),
      darkTheme: ThemeData.dark(),
      themeMode: ThemeMode.dark,
      home: HomePage(),
    ); //MeterialApp
  }
}

class PredictionEntry {
  final int personId;
  final String date;
  final double predictionProbability;
  final int actualOutcome;
  final double stress;
  final double physical;
  final double sleep;

  PredictionEntry({
    required this.personId,
    required this.date,
    required this.predictionProbability,
    required this.actualOutcome, 
    required this.stress,
    required this.physical,
    required this.sleep,
  });

  factory PredictionEntry.fromJson(Map<String, dynamic> json) {
    return PredictionEntry(
      personId: json['person_id'],
      date: json['date'],
      predictionProbability: (json['prediction_probability'] as num).toDouble(),
      actualOutcome: json['actual_outcome'] as int,
      stress: (json['stress_value'] as num).toDouble(),
      physical: (json['physical_value'] as num).toDouble(),
      sleep: (json['sleep_value'] as num).toDouble(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int selectedChart = 0;
  List<PredictionEntry> allEntries = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    loadData();
  }

  Future<void> loadData() async {
    final String jsonString = await rootBundle.loadString('assets/test_predictions_history.json');
    final List<dynamic> jsonData = json.decode(jsonString);
    setState(() {
      allEntries = jsonData.map((e) => PredictionEntry.fromJson(e)).toList();
      isLoading = false;
    });
  }

  List<PredictionEntry> entriesForPerson(int personId) {
    return allEntries
        .where((e) => e.personId == personId)
        .toList()
      ..sort((a, b) => DateTime.parse(a.date).compareTo(DateTime.parse(b.date)));
  }

  Widget _buildChart() {
    if (isLoading) {
      return const Center(child: CircularProgressIndicator());
    }
    final personIds = [1, 2, 3, 4];
    final entries = entriesForPerson(personIds[selectedChart]);
    if (entries.isEmpty) return const Text('No data for this person');

    // Convert date strings to DateTime and sort
    final sortedEntries = entries
      .map((e) => MapEntry(DateTime.parse(e.date), e))
      .toList()
      ..sort((a, b) => a.key.compareTo(b.key));

    // Map dates to x values (0, 1, 2, ...)
    final dateList = sortedEntries.map((e) => e.key).toList();

    return LineChart(
      LineChartData(
        minY: 0,
        maxY: 1,
        lineBarsData: [
          LineChartBarData(
            preventCurveOverShooting: true,
            preventCurveOvershootingThreshold: 25,
            spots: List.generate(
              sortedEntries.length,
              (i) => FlSpot(
                i.toDouble(),
                sortedEntries[i].value.predictionProbability,
              ),
            ),
            barWidth: 4,
            color: Colors.blue,
            isCurved: true,
            belowBarData: BarAreaData(
              color: const Color.fromARGB(62, 33, 149, 243),
              show: true,
            ),
            dotData: FlDotData(
              show: true,
              getDotPainter: (spot, percent, barData, index) {
                return FlDotCirclePainter(
                  radius: 4,
                  color: Colors.blue,
                  strokeWidth: 2,
                  strokeColor: const Color.fromARGB(255, 209, 209, 209),
                );
              },
            ),
          ),
        ],
        titlesData: FlTitlesData(
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
                getTitlesWidget: (value, meta) {
                int idx = value.toInt();
                if (idx < 0 || idx >= dateList.length) return const SizedBox.shrink();
                final date = dateList[idx];
                // Show as yyyy-MM-dd
                return Text('${date.year.toString()}\n${date.month.toString().padLeft(2, '0')}/${date.day.toString().padLeft(2, '0')}');
              },
              interval: 2,
              maxIncluded: false,
              minIncluded: true,
              reservedSize: 40,
            ),
          ),
          leftTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              interval: 0.2,
              reservedSize: 38,
              maxIncluded: true,
              minIncluded: false,
              getTitlesWidget: (value, meta) {
                return Text(
                  '${(value * 100).toStringAsFixed(0)}%'
                );
              },
            ),
          ),
          rightTitles: AxisTitles(
            sideTitles: SideTitles(showTitles: false),
          ),
          topTitles: AxisTitles(
            sideTitles: SideTitles(showTitles: false),
          ),
        ),
        gridData: FlGridData(
          horizontalInterval: 0.2,
          verticalInterval: 1,
          getDrawingHorizontalLine: (value) {
            return FlLine(
              color: const Color.fromARGB(255, 224, 224, 224),
              strokeWidth: 1,
            );
          },
        ),
        lineTouchData: LineTouchData(
          touchTooltipData: LineTouchTooltipData(
            fitInsideHorizontally: true,
            fitInsideVertically: true,
            tooltipRoundedRadius: 8,
            getTooltipItems: (List<LineBarSpot> touchedSpots) {
              return touchedSpots.map((spot) {
                final entry = sortedEntries[spot.x.toInt()].value;
                final sleep = ((entry.sleep / 60)/7);
                final physical = ((entry.physical / 60)/7);
                final stress = ((entry.stress / 60)/7);

                String buildBar(double value, {double maxValue = 8.0, int length = 10}) {
                  final normalized = value.clamp(0, maxValue) / maxValue;
                  final filled = (normalized * length).round();
                  return '█' * filled + '⠀' * (length - filled);
                }

                return LineTooltipItem(
                  '',
                  const TextStyle(),
                  children: [
                    TextSpan(text: '${entry.date}\n\n'),
                    TextSpan(text: 'Sleep:\n'),
                    TextSpan(text: buildBar(sleep, maxValue: 8.0),style: const TextStyle(color: Colors.deepPurple)),
                    TextSpan(text: '\n${sleep.toStringAsFixed(1)}h\n'),
                    TextSpan(text: 'Physical:\n'),
                    TextSpan(text: buildBar(physical, maxValue: 1.0), style: const TextStyle(color: Colors.yellow)),
                    TextSpan(text: '\n${physical.toStringAsFixed(1)}h\n'),
                    TextSpan(text: 'Stress:\n'),
                    TextSpan(text: buildBar(stress, maxValue: 1.0), style: const TextStyle(color: Colors.red)),
                    TextSpan(text: '\n${stress.toStringAsFixed(1)}h\n'),
                    TextSpan(text: '\nPrediction Probability:\n${(entry.predictionProbability * 100).toStringAsFixed(1)}%\n'),
                  ],
                );
              }).toList();
            },
          ),
        ),
      ),
    );
  }

  Widget _buildPieChart() {
    if (isLoading) {
      return const Center(child: CircularProgressIndicator());
    }
    final personIds = [1, 2, 3, 4];
    final entries = entriesForPerson(personIds[selectedChart]);
    if (entries.isEmpty) return const Text('No data for this person');
    final lastValue = entries.last.predictionProbability.clamp(0.0, 1.0);

    // Function to determine color based on value
    Color getPieColor(double value) {
      if (value >= 0.8) {
        return Colors.red;
      } else if (value >= 0.5) {
        return Colors.orange;
      } else {
        return Colors.green;
      }
    }

    final pieColor = getPieColor(lastValue);

    return Column(
      children: [
        SizedBox(
          height: 100,
          child: Stack(
            alignment: Alignment.center,
            children: [
              PieChart(
                PieChartData(
                  startDegreeOffset: 270,
                  sections: [
                    PieChartSectionData(
                      value: lastValue * 100,
                      color: pieColor,
                      title: '',
                      radius: 50,
                    ),
                    PieChartSectionData(
                      value: (1 - lastValue) * 100,
                      color: const Color(0xFF222222),
                      title: '',
                      radius: 50,
                    ),
                  ],
                  sectionsSpace: 0,
                  centerSpaceRadius: 30,
                ),
              ),
              Text(
                '${(lastValue * 100).toStringAsFixed(1)}%',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: pieColor,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 40),
        const Text('Prediction Probability'),
      ],
    );
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
            child: Wrap(
              spacing: 8.0,
              runSpacing: 8.0,
              alignment: WrapAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: () => setState(() => selectedChart = 0),
                  child: const Text('Person 1'),
                ),
                ElevatedButton(
                  onPressed: () => setState(() => selectedChart = 1),
                  child: const Text('Person 2'),
                ),
                ElevatedButton(
                  onPressed: () => setState(() => selectedChart = 2),
                  child: const Text('Person 3'),
                ),
                ElevatedButton(
                  onPressed: () => setState(() => selectedChart = 3),
                  child: const Text('Person 4'),
                ),
              ],
            ),
          ),
          Expanded(
            child: Center(
              child: AspectRatio(
                aspectRatio: 0.75,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _buildPieChart(),
                    const SizedBox(height: 24),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.only(right: 15.0, left: 5),
                        child: _buildChart(),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}