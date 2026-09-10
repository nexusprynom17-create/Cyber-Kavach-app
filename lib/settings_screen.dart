import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  static const _accessibilityChannel = MethodChannel('com.omhari.cyberkavach/system');
  final TextEditingController _bankController = TextEditingController();
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final prefs = await SharedPreferences.getInstance();
    _bankController.text = prefs.getString('bank_helpline_number') ?? '';
    setState(() => _loading = false);
  }

  Future<void> _saveBankNumber() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('bank_helpline_number', _bankController.text.trim());
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Bank number save ho gaya.')),
      );
    }
  }

  Future<void> _openAccessibilitySettings() async {
    try {
      await _accessibilityChannel.invokeMethod('openAccessibilitySettings');
    } on PlatformException {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              'Manually kholein: Phone Settings → Accessibility → Downloaded apps → Cyber-Kavach → On karein.',
            ),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
        backgroundColor: Colors.green[800],
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : ListView(
              padding: const EdgeInsets.all(20),
              children: [
                const Text(
                  'Bank Fraud Helpline Number',
                  style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                Text(
                  'Yeh number Sanjeevani button dabane par call karne ke liye dikhega.',
                  style: TextStyle(color: Colors.grey[400], fontSize: 12.5),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: _bankController,
                  keyboardType: TextInputType.phone,
                  style: const TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    hintText: 'e.g. 18001234567',
                    hintStyle: const TextStyle(color: Colors.grey),
                    filled: true,
                    fillColor: const Color(0xFF1E1E1E),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide.none),
                  ),
                ),
                const SizedBox(height: 12),
                FilledButton(
                  onPressed: _saveBankNumber,
                  child: const Text('Save Number'),
                ),
                const Divider(height: 40, color: Colors.grey),
                const Text(
                  'Screen-Share Suraksha (Accessibility)',
                  style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                Text(
                  'AnyDesk/TeamViewer jaisi apps ko detect karke automatically band karne ke liye, '
                  'Android ki Accessibility permission on karni hogi. Yeh permission sirf user khud de sakta hai — '
                  'koi app apne aap yeh on nahi kar sakti (Android security rule hai).',
                  style: TextStyle(color: Colors.grey[400], fontSize: 12.5),
                ),
                const SizedBox(height: 12),
                OutlinedButton.icon(
                  onPressed: _openAccessibilitySettings,
                  icon: const Icon(Icons.open_in_new),
                  label: const Text('Accessibility Settings Kholein'),
                ),
              ],
            ),
    );
  }
}
