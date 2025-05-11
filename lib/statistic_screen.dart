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
  int highestScore = 0;
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
      highestScore = prefs.getInt('highestScore') ?? 0;
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
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.colorScheme.onPrimary,
      appBar: AppBar(
        title: Text('İstatistik'),
        centerTitle: true,
        backgroundColor: theme.colorScheme.onPrimary,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Stat kartları için yatay scroll
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
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
                      ],
                    ),
                    SizedBox(width: 12),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        _buildStatCard(
                          'En İyi Deneme',
                          bestTry != 0 ? '#$bestTry' : '-',
                          Icons.grade,
                        ),
                        SizedBox(width: 12),
                        _buildStatCard(
                          'En Yüksek Skor',
                          highestScore.toString(),
                          Icons.star,
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              SizedBox(height: 30),
              Text(
                'En İyi Deneme Dağıtımı',
                style: theme.textTheme.headlineSmall?.copyWith(
                  color: theme.colorScheme.primary,
                ),
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
                          backgroundColor: theme.colorScheme.surface
                              .withOpacity(0.3),
                          valueColor: AlwaysStoppedAnimation<Color>(
                            theme.colorScheme.secondary,
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
    );
  }

  Widget _buildStatCard(String title, String value, IconData icon) {
    final theme = Theme.of(context);

    return Card(
      elevation: 6,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      color: theme.colorScheme.primary,
      child: Container(
        height: 120,
        width: 105,
        padding: const EdgeInsets.all(8),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Icon(icon, size: 30, color: theme.colorScheme.onPrimary),
            SizedBox(height: 8),
            Text(
              value,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
                color: theme.colorScheme.onPrimary,
              ),
            ),
            SizedBox(height: 4),
            Text(
              title,
              style: TextStyle(
                fontSize: 12,
                color: theme.colorScheme.onPrimary,
              ),
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
