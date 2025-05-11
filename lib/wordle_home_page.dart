import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wordle/custom_keyboard.dart';
import 'package:wordle/home_page.dart';
import 'package:wordle/how_to_play.dart';
import 'package:wordle/settings_page.dart';
import 'package:wordle/statistic_screen.dart';
import 'package:wordle/turkce_kelimeler.dart';
import 'wordle_grid.dart';

class WordleHomePage extends StatefulWidget {
  final bool shouldReset;
  const WordleHomePage({Key? key, this.shouldReset = false}) : super(key: key);
  @override
  _WordleHomePageState createState() => _WordleHomePageState();
}

class _WordleHomePageState extends State<WordleHomePage> {
  final int rows = 6;
  final int columns = 5;
  int currentRow = 0;
  int currentCol = 0;
  int maxAttempts = 6;
  int score = 0;
  int totalGames = 0;
  int gamesWon = 0;
  int highestScore = 0;
  bool playSounds = true;

  FocusNode focusNode = FocusNode();
  final AudioPlayer _audioPlayer = AudioPlayer();

  List<List<String>> board = List.generate(
    6,
    (_) => List.generate(5, (_) => ''),
  );
  List<List<Color>> boardColors = List.generate(
    6,
    (_) => List.generate(5, (_) => Colors.grey[850]!),
  );

  Map<String, Color> keyColors = {};
  String secretWord = "KAVUN";

  @override
  void initState() {
    super.initState();
    if (widget.shouldReset) {
      resetGame();
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Navigator.pop(context, true);
      });
    } else {
      _initializeKeyboardColors();
      startNewGame();
      focusNode.requestFocus();
    }
  }

  void _initializeKeyboardColors() {
    final allLetters = <String>{
      'Q',
      'W',
      'E',
      'R',
      'T',
      'Y',
      'U',
      'I',
      'O',
      'P',
      'Ğ',
      'Ü',
      'A',
      'S',
      'D',
      'F',
      'G',
      'H',
      'J',
      'K',
      'L',
      'Ş',
      'İ',
      'Z',
      'X',
      'C',
      'V',
      'B',
      'N',
      'M',
      'Ö',
      'Ç',
    };
    for (final letter in allLetters) {
      keyColors[letter] = Colors.grey[800]!;
    }
    keyColors['ENTER'] = Colors.grey[800]!;
    keyColors['DEL'] = Colors.grey[800]!;
  }

  @override
  void dispose() {
    focusNode.dispose();
    super.dispose();
  }

  void startNewGame() async {
    setState(() {
      secretWord = (turkceKelimeler..shuffle()).first;
      currentRow = 0;
      currentCol = 0;
      board = List.generate(
        maxAttempts,
        (_) => List.generate(columns, (_) => ''),
      );
      boardColors = List.generate(
        maxAttempts,
        (_) => List.generate(columns, (_) => Colors.grey[850]!),
      );
      _initializeKeyboardColors();
    });
  }

  Future<void> checkGuess() async {
    String guess = board[currentRow].join();

    if (!turkceKelimeler.contains(guess)) {
      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(SnackBar(content: Text("Geçersiz Kelime!")));
      return;
    }

    List<bool> secretUsed = List.filled(5, false);

    // Tüm kutuları önce gri yap (eşleşme olmazsa gri kalacak)
    for (int i = 0; i < 5; i++) {
      boardColors[currentRow][i] = Colors.grey;
    }

    //Yeşil renk (doğru harf ve doğru konum)
    for (int i = 0; i < 5; i++) {
      if (guess[i] == secretWord[i]) {
        boardColors[currentRow][i] = Colors.green;
        keyColors[guess[i]] = Colors.green;
        secretUsed[i] = true;
      }
    }

    //Sarı renk (doğru harf ama yanlış konum)
    for (int i = 0; i < 5; i++) {
      if (boardColors[currentRow][i] != Colors.green) {
        for (int j = 0; j < 5; j++) {
          if (!secretUsed[j] && guess[i] == secretWord[j]) {
            boardColors[currentRow][i] = Colors.amber;
            if (keyColors[guess[i]] != Colors.green) {
              keyColors[guess[i]] = Colors.amber;
            }
            secretUsed[j] = true;
            break;
          }
        }
      }
    }

    for (int i = 0; i < 5; i++) {
      String guessedLetter = guess[i];
      if (!secretWord.contains(guessedLetter) &&
          keyColors[guessedLetter] != Colors.green &&
          keyColors[guessedLetter] != Colors.amber) {
        keyColors[guessedLetter] = Colors.grey;
      }
    }
    setState(() {
      //boardColors[currentRow] = rowColors;
    });

    if (guess == secretWord) {
      score += (maxAttempts - currentRow) * 10;
      final prefs = await SharedPreferences.getInstance();
      int storedHighScore = prefs.getInt('highestScore') ?? 0;
      if (score > storedHighScore) {
        await prefs.setInt('highestScore', score);
      }
      //istatistikleri kaydet
      _updateStatistics(true);
      showEndDialog(true);
    } else if (currentRow == maxAttempts - 1) {
      score = 0;
      _updateStatistics(false);
      showEndDialog(false);
    } else {
      currentRow++;
      currentCol = 0;
    }
  }

  Future<void> _updateStatistics(bool won) async {
    final prefs = await SharedPreferences.getInstance();
    int gamesPlayed = prefs.getInt('gamesPlayed') ?? 0;
    int wins = prefs.getInt('wins') ?? 0;
    List<int> tryDistribution = List.generate(
      6,
      (index) => prefs.getInt('try_$index') ?? 0,
    );

    gamesPlayed++;
    if (won) {
      wins++;
      tryDistribution[currentRow]++;
    }

    await prefs.setInt('gamesPlayed', gamesPlayed);
    await prefs.setInt('wins', wins);
    for (int i = 0; i < tryDistribution.length; i++) {
      await prefs.setInt('try_$i', tryDistribution[i]);
    }
  }

  void showEndDialog(bool hasWon) async {
    if (playSounds) {
      await _audioPlayer.play(
        AssetSource(hasWon ? 'audios/successful.mp3' : 'audios/game_over.mp3'),
      );
    }

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(hasWon ? 'Tebrikler 🎉' : 'Oyun Bitti 😢'),
          content: Text(
            hasWon
                ? "Doğru kelimeyi buldun! \nSkor: $score"
                : "Doğru kelime: $secretWord. \nSkor: $score",
          ),
          actions: [
            TextButton(
              child: Text(hasWon ? 'Devam Et' : 'Tekrar Oyna'),
              onPressed: () {
                Navigator.of(context).pop();
                if (hasWon) {
                  startNewRound();
                } else {
                  startNewGame();
                }
              },
            ),
          ],
        );
      },
    );
  }

  void startNewRound() async {
    setState(() {
      currentRow = 0;
      board = List.generate(rows, (_) => List.filled(columns, ''));
      boardColors = List.generate(
        rows,
        (_) => List.filled(columns, Colors.grey),
      );
      _initializeKeyboardColors();
      secretWord = (turkceKelimeler..shuffle()).first;
    });
  }

  void resetGame() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('gamesPlayed', 0);
    await prefs.setInt('wins', 0);
    await prefs.setInt('bestTry', 0);
    for (int i = 0; i < 6; i++) {
      await prefs.setInt('try_$i', 0);
    }
    board = List.generate(
      maxAttempts,
      (index) => List.generate(5, (index) => ''),
    );
    boardColors = List.generate(
      maxAttempts,
      (index) => List.generate(5, (index) => Colors.white),
    );
    currentRow = 0;
    currentCol = 0;
    startNewGame();
    _initializeKeyboardColors();
    setState(() {});
  }

  void onKeyTap(String key) {
    setState(() {
      if (key == 'DEL') {
        if (currentCol > 0) {
          currentCol--;
          board[currentRow][currentCol] = '';
        }
      } else if (key == 'ENTER') {
        if (currentCol == columns) {
          checkGuess();
        } else {
          ScaffoldMessenger.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(
              SnackBar(content: Text("Lütfen 5 harfli bir kelime girin.")),
            );
        }
      } else {
        if (currentCol < columns) {
          board[currentRow][currentCol] = key;
          currentCol++;
        }
      }
    });
  }

  void handleKeyEvent(RawKeyEvent event) {
    if (event is RawKeyDownEvent) {
      String keyLabel = event.logicalKey.keyLabel.toUpperCase();

      if (keyLabel == 'ENTER') {
        onKeyTap('ENTER');
      } else if (event.logicalKey == LogicalKeyboardKey.backspace) {
        onKeyTap('DEL');
      } else if (keyLabel.length == 1 &&
          RegExp(r'^[A-ZÇĞİÖŞÜa-zçğıöşü]$').hasMatch(keyLabel)) {
        onKeyTap(keyLabel);
      }
    }
  }

  void _loadPreferences() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      playSounds = prefs.getBool('playSounds') ?? true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return RawKeyboardListener(
      focusNode: focusNode,
      onKey: handleKeyEvent,
      child: Scaffold(
        //backgroundColor: theme.colorScheme.onPrimary,
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 2,
          title: Text(
            'Wordle - Skor: $score',
            style: const TextStyle(color: Colors.black),
          ),
          leading: IconButton(
            icon: const Icon(Icons.home, color: Colors.black),
            onPressed: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => HomePage()),
              );
            },
          ),
          centerTitle: true,
          actions: [
            IconButton(
              icon: const Icon(Icons.bar_chart, color: Colors.black),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => StatisticScreen()),
                );
              },
            ),
            IconButton(
              icon: const Icon(Icons.settings, color: Colors.black),
              onPressed: () async {
                await Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const SettingsPage()),
                );
                _loadPreferences();
              },
            ),
            IconButton(
              icon: const Icon(Icons.help_outline, color: Colors.black),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => HowToPlay()),
                );
              },
            ),
          ],
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              const SizedBox(height: 20),
              WordleGrid(
                board: board,
                boardColors: boardColors,
                rows: rows,
                columns: columns,
              ),
              const SizedBox(height: 20),
              CustomKeyboard(onKeyTap: onKeyTap, keyboardColors: keyColors),
            ],
          ),
        ),
      ),
    );
  }
}
