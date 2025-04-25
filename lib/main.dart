import 'package:flutter/material.dart';

void main() {
  runApp(WordleApp());
}

class WordleApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Wordle',
      theme: ThemeData.dark(),
      home: WordleHomePage(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class WordleHomePage extends StatefulWidget {
  @override
  _WordleHomePageState createState() => _WordleHomePageState();
}

class _WordleHomePageState extends State<WordleHomePage> {
  final int rows = 6;
  final int columns = 5;
  int currentRow = 0;
  int currentCol = 0;

  List<List<String>> board = List.generate(
    6,
    (_) => List.generate(5, (_) => ''),
  );
  List<List<Color>> boardColors = List.generate(
    6,
    (_) => List.generate(5, (_) => Colors.grey[850]!),
  );

  String secretWord = "KAVUN"; // 5 harfli gizli kelime (büyük harf olmalı)

  void checkGuess() {
    String guess = board[currentRow].join();
    List<bool> secretUsed = List.filled(5, false);

    // Tüm kutuları önce gri yap (eşleşme olmazsa gri kalacak)
    for (int i = 0; i < 5; i++) {
      boardColors[currentRow][i] = Colors.grey;
    }

    //Yeşil renk (doğru harf ve doğru konum)
    for (int i = 0; i < 5; i++) {
      if (guess[i] == secretWord[i]) {
        boardColors[currentRow][i] = Colors.green;
        secretUsed[i] = true;
      }
    }

    //Sarı renk (doğru harf ama yanlış konum)
    for (int i = 0; i < 5; i++) {
      if (boardColors[currentRow][i] != Colors.green) {
        for (int j = 0; j < 5; j++) {
          if (!secretUsed[j] && guess[j] == secretWord[j]) {
            boardColors[currentRow][i] = Colors.amber;
            secretUsed[j] = true;
            break;
          }
        }
      }
    }
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
          currentRow++;
          currentCol = 0;
        } else {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text("5 harf girilmedi!")));
        }
      } else {
        if (currentCol < columns && currentRow < rows) {
          board[currentRow][currentCol] = key;
          currentCol++;
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Wordle Oyunu'), centerTitle: true),
      body: Column(
        children: [
          SizedBox(height: 20),
          _buildGrid(),
          SizedBox(height: 20),
          _buildKeyboard(),
        ],
      ),
    );
  }

  Widget _buildGrid() {
    return Expanded(
      flex: 2,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: GridView.builder(
          physics: NeverScrollableScrollPhysics(),
          itemCount: rows * columns,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: columns,
            mainAxisSpacing: 8,
            crossAxisSpacing: 8,
          ),
          itemBuilder: (context, index) {
            final row = index ~/ columns;
            final col = index % columns;
            return Container(
              decoration: BoxDecoration(
                color: boardColors[row][col],
                border: Border.all(color: Colors.white),
                borderRadius: BorderRadius.circular(6),
              ),
              alignment: Alignment.center,
              child: Text(
                board[row][col],
                style: TextStyle(fontSize: 24, color: Colors.white),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildKeyboard() {
    const letters = [
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
      'A',
      'S',
      'D',
      'F',
      'G',
      'H',
      'J',
      'K',
      'L',
      'ENTER',
      'Z',
      'X',
      'C',
      'V',
      'B',
      'N',
      'M',
      'DEL',
    ];

    return Expanded(
      flex: 1,
      child: GridView.builder(
        physics: NeverScrollableScrollPhysics(),
        padding: EdgeInsets.symmetric(horizontal: 10),
        itemCount: letters.length,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 10,
          mainAxisSpacing: 6,
          crossAxisSpacing: 6,
        ),
        itemBuilder: (context, index) {
          final key = letters[index];
          return ElevatedButton(
            onPressed: () => onKeyTap(key),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.grey[700],
              padding: EdgeInsets.zero,
            ),
            child: Text(key, style: TextStyle(fontSize: 14)),
          );
        },
      ),
    );
  }
}
