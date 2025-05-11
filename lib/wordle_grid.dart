import 'package:flutter/material.dart';

class WordleGrid extends StatelessWidget {
  final List<List<String>> board;
  final List<List<Color>> boardColors;
  final int rows;
  final int columns;

  const WordleGrid({
    required this.board,
    required this.boardColors,
    required this.rows,
    required this.columns,
  });

  @override
  Widget build(BuildContext context) {
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
}
