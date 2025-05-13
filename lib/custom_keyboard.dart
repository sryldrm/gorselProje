import 'package:flutter/material.dart';

class CustomKeyboard extends StatelessWidget {
  final void Function(String) onKeyTap;
  final Map<String, Color>? keyboardColors;

  const CustomKeyboard({Key? key, required this.onKeyTap, this.keyboardColors})
    : super(key: key);

  @override
  Widget build(BuildContext context) {
    final List<String> firstRow = [
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
    ];
    final List<String> secondRow = [
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
    ];
    final List<String> thirdRow = [
      'ENTER',
      'Z',
      'X',
      'C',
      'V',
      'B',
      'N',
      'M',
      'Ö',
      'Ç',
      'DEL',
    ];

    return Container(
      color: Theme.of(context).colorScheme.onPrimary, // Klavye arka planı siyah
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          buildRow(firstRow),
          const SizedBox(height: 8),
          buildRow(secondRow),
          const SizedBox(height: 8),
          buildRow(thirdRow),
        ],
      ),
    );
  }

  Widget buildRow(List<String> letters) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children:
          letters.map((letter) {
            final bool isSpecialKey = (letter == 'ENTER' || letter == 'DEL');
            final int flex = isSpecialKey ? 15 : 10;
            final buttonColor = keyboardColors?[letter] ?? Colors.white;

            return Expanded(
              flex: flex,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 2.0),
                child: ElevatedButton(
                  onPressed: () => onKeyTap(letter),
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size(40, 58),
                    backgroundColor: buttonColor, // Tuş rengi
                    foregroundColor: Colors.black, // Yazı rengi
                    padding: EdgeInsets.zero,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(6),
                    ),
                    elevation: 3,
                    shadowColor: Colors.black54,
                  ),
                  child: FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Text(
                      letter,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1.5,
                      ),
                    ),
                  ),
                ),
              ),
            );
          }).toList(),
    );
  }
}
