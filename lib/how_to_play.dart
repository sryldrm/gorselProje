import 'package:flutter/material.dart';

class HowToPlay extends StatelessWidget {
  const HowToPlay({Key? key}) : super(key: key);

  Widget buildLetterBox(String letter, Color color) {
    return Container(
      width: 48,
      height: 48,
      alignment: Alignment.center,
      margin: const EdgeInsets.symmetric(horizontal: 2),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        letter,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 24,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Nasıl Oynanır?'), centerTitle: true),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '6 denemede gizli kelimeyi tahmin et.\n'
              'Her tahmin 5 harfli geçerli bir kelime olmalı.\n'
              'Her tahminden sonra, ne kadar yakın olduğunuzu göstermek için renkler değişiyor.',
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 20),
            const Text(
              'Oyuna başlamak için herhangi bir kelime girin, örneğin:',
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                buildLetterBox('N', Colors.grey),
                buildLetterBox('E', Colors.green),
                buildLetterBox('H', Colors.grey),
                buildLetterBox('İ', Colors.green),
                buildLetterBox('R', Colors.yellow),
              ],
            ),
            const SizedBox(height: 20),
            Container(
              padding: const EdgeInsets.all(12),
              margin: EdgeInsets.symmetric(vertical: 8),
              decoration: BoxDecoration(
                color: Colors.grey[800],
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Row(
                    children: [
                      Text(
                        '⬜ N, H: ',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      Text(
                        'hedef kelimede hiç yok.',
                        style: TextStyle(color: Colors.white),
                      ),
                    ],
                  ),
                  SizedBox(height: 4),
                  Row(
                    children: [
                      Text(
                        '🟨 R: ',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      Text(
                        'kelimede ama yanlış yerde.',
                        style: TextStyle(color: Colors.white),
                      ),
                    ],
                  ),
                  SizedBox(height: 4),
                  Row(
                    children: [
                      Text(
                        '🟩 E, I: ',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      Text(
                        'kelimede ve doğru yerde.',
                        style: TextStyle(color: Colors.white),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'Hedef kelimede eşleşen harfleri bulmak için başka bir deneme.',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                buildLetterBox('B', Colors.grey),
                buildLetterBox('E', Colors.green),
                buildLetterBox('N', Colors.grey),
                buildLetterBox('İ', Colors.green),
                buildLetterBox('M', Colors.green),
              ],
            ),
            const SizedBox(height: 10),
            Center(
              child: Text(
                'Çok yakın!',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                buildLetterBox('R', Colors.green),
                buildLetterBox('E', Colors.green),
                buildLetterBox('S', Colors.green),
                buildLetterBox('İ', Colors.green),
                buildLetterBox('M', Colors.green),
              ],
            ),
            const SizedBox(height: 10),
            Center(
              child: const Text(
                'Doğru tahmin! 🏆',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
