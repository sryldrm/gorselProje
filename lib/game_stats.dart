class GameStats {
  int gamesPlayed = 0;
  int gamesWon = 0;
  int currentStreak = 0;
  int bestAttempt = 6;

  List<int> attemptDistribution = List.filled(6, 0);
  int totalAttempts = 0;

  void addGame({required bool won, int? attemptNumber}) {
    gamesPlayed++;
    if (won) {
      gamesWon++;
      currentStreak++;
      if (attemptNumber != null) {
        attemptDistribution[attemptNumber - 1]++;
        if (attemptNumber < bestAttempt) {
          bestAttempt = attemptNumber;
        }
        totalAttempts += attemptNumber;
      }
    } else {
      currentStreak = 0;
    }
  }

  double get winPercentage =>
      gamesPlayed == 0 ? 0 : (gamesWon / gamesPlayed) * 100;
  double get averageAttempts => gamesWon == 0 ? 0 : totalAttempts / gamesWon;
}
