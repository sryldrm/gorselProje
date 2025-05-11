import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wordle/wordle_home_page.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  bool _playSounds = true;

  @override
  void initState() {
    super.initState();
    _loadSettings();
  }

  void _loadSettings() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _playSounds = prefs.getBool('playSounds') ?? true;
    });
  }

  void _toggleSound(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('playSounds', value);
    setState(() {
      _playSounds = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Ayarlar')),
      body: ListView(
        children: [
          SwitchListTile(
            title: const Text('Ses Efektleri'),
            value: _playSounds,
            onChanged: _toggleSound,
          ),
          const Divider(),
          ListTile(
            title: const Text('Oyunu Sıfırla'),
            trailing: const Icon(Icons.refresh),
            onTap: () async {
              final confirm = await showDialog<bool>(
                context: context,
                builder:
                    (_) => AlertDialog(
                      title: const Text('Emin misiniz?'),
                      content: const Text(
                        'Oyun ve istatistikler sıfırlanacak.',
                      ),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(context, false),
                          child: const Text('İptal'),
                        ),
                        TextButton(
                          onPressed: () => Navigator.pop(context, true),
                          child: const Text('Evet'),
                        ),
                      ],
                    ),
              );
              if (confirm == true) {
                // Burada wordle_home_page'e gitmeli ve bir sonuç beklemeliyiz.
                final shouldReset = await Navigator.push<bool>(
                  context,
                  MaterialPageRoute(
                    builder: (context) => WordleHomePage(shouldReset: true),
                  ), // shouldReset bilgisini gönderiyoruz
                );

                // Eğer WordleHomePage'den true değeri döndüyse (oyun sıfırlandıysa) bir işlem yapabilirsiniz.
                if (shouldReset == true) {
                  // İsteğe bağlı: Kullanıcıya geri bildirim verebilirsiniz.
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Oyun ve istatistikler sıfırlandı.'),
                    ),
                  );
                }
              }
            },
          ),
        ],
      ),
    );
  }
}
