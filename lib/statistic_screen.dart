import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:shared_preferences/shared_preferences.dart';

class StatisticScreen extends StatefulWidget {
  @override
  _StatisticScreenState createState() => _StatisticScreenState();
}

class _StatisticScreenState extends State<StatisticScreen> {
  int gamesPlayed = 0;
  int wins = 0;
  int bestTry = 0;
  List<int> tryDistribution = List.filled(6, 0);

  @override
  void initState() {
    super.initState();
    loadStats();
  }

  Future<void> loadStats() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      gamesPlayed = prefs.getInt('gamesPlayed') ?? 0;
      wins = prefs.getInt('wins') ?? 0;
      bestTry = prefs.getInt('bestTry') ?? 0;
      tryDistribution = List.generate(
        6,
        (index) => prefs.getInt('try_$index') ?? 0,
      );
    });
  }

  double get winPercentage =>
      (gamesPlayed > 0) ? (wins / gamesPlayed) * 100 : 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('İstatistik'), centerTitle: true),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Stat kartları için yatay scroll
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      _buildStatCard(
                        'Oynanan',
                        gamesPlayed.toString(),
                        Icons.sports_esports,
                      ),
                      SizedBox(width: 12),
                      _buildStatCard(
                        'Galibiyet',
                        wins.toString(),
                        Icons.emoji_events,
                      ),
                      SizedBox(width: 12),
                      _buildStatCard(
                        'Galibiyet %',
                        winPercentage.toStringAsFixed(2),
                        Icons.bar_chart,
                      ),
                      SizedBox(width: 12),
                      _buildStatCard(
                        'En İyi Deneme',
                        bestTry != 0 ? '#$bestTry' : '-',
                        Icons.grade,
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 30),
                Text(
                  'En İyi Deneme Dağıtımı',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 20),
                ...List.generate(tryDistribution.length, (index) {
                  int count = tryDistribution[index];
                  double percentage =
                      (gamesPlayed > 0) ? (count / gamesPlayed) : 0;

                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 6.0),
                    child: Row(
                      children: [
                        SizedBox(width: 30, child: Text('#${index + 1}')),
                        Expanded(
                          child: LinearProgressIndicator(
                            value: percentage,
                            minHeight: 20,
                            backgroundColor: Colors.grey.shade300,
                            valueColor: AlwaysStoppedAnimation<Color>(
                              Colors.green,
                            ),
                          ),
                        ),
                        SizedBox(width: 10),
                        Text('$count'),
                      ],
                    ),
                  );
                }),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildStatCard(String title, String value, IconData icon) {
    return Card(
      elevation: 4,
      child: Container(
        height: 100,
        padding: EdgeInsets.all(8),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 24),
            SizedBox(height: 8),
            Text(value, style: TextStyle(fontWeight: FontWeight.bold)),
            SizedBox(height: 4),
            Text(
              title,
              style: TextStyle(fontSize: 10),
              textAlign: TextAlign.center,
              overflow: TextOverflow.ellipsis,
              maxLines: 2,
            ),
          ],
        ),
      ),
    );
  }
}
