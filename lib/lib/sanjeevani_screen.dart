import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';

class SanjeevaniScreen extends StatefulWidget {
  const SanjeevaniScreen({super.key});

  @override
  State<SanjeevaniScreen> createState() => _SanjeevaniScreenState();
}

class _SanjeevaniScreenState extends State<SanjeevaniScreen> {
  final FlutterTts _tts = FlutterTts();
  bool _isActivating = false;
  String? _lastEvidenceNote;

  @override
  void initState() {
    super.initState();
    _tts.setLanguage("hi-IN");
    _tts.setSpeechRate(0.45);
  }

  Future<void> _speak(String text) async {
    await _tts.stop();
    await _tts.speak(text);
  }

  Future<void> _saveEvidenceLog() async {
    final prefs = await SharedPreferences.getInstance();
    final logs = prefs.getStringList('evidence_logs') ?? [];
    final timestamp = DateFormat('dd MMM yyyy, hh:mm a').format(DateTime.now());
    final entry = '$timestamp — Sanjeevani button dabaya gaya';
    logs.add(entry);
    await prefs.setStringList('evidence_logs', logs);
    setState(() => _lastEvidenceNote = entry);
  }

  Future<String?> _getBankHelpline() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('bank_helpline_number');
  }

  Future<void> _callNumber(String number) async {
    final uri = Uri(scheme: 'tel', path: number);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    } else if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Call nahi kar paaye: $number')),
      );
    }
  }

  Future<void> _onSanjeevaniActivated() async {
    setState(() => _isActivating = true);

    await _speak('Sanjeevani mode chalu ho gaya hai. Ghabraiye nahi. Aapki madad ho rahi hai.');
    await _saveEvidenceLog();

    if (!mounted) return;
    setState(() => _isActivating = false);

    final bankNumber = await _getBankHelpline();

    if (!mounted) return;
    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xFF141414),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) => _SanjeevaniActionSheet(
        bankNumber: bankNumber,
        onCall1930: () => _callNumber('1930'),
        onCallBank: bankNumber == null ? null : () => _callNumber(bankNumber),
        onSetBankNumber: () => _showSetBankNumberDialog(),
      ),
    );
  }

  Future<void> _showSetBankNumberDialog() async {
    final controller = TextEditingController();
    final result = await showDialog<String>(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: const Color(0xFF1E1E1E),
        title: const Text('Bank Helpline Number', style: TextStyle(color: Colors.white)),
        content: TextField(
          controller: controller,
          keyboardType: TextInputType.phone,
          style: const TextStyle(color: Colors.white),
          decoration: const InputDecoration(
            hintText: 'e.g. 18001234567',
            hintStyle: TextStyle(color: Colors.grey),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(ctx, controller.text.trim()),
            child: const Text('Save'),
          ),
        ],
      ),
    );
    if (result != null && result.isNotEmpty) {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('bank_helpline_number', result);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Bank number save ho gaya.')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Cyber-Kavach 🛡️', style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.green[800],
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: _showSetBankNumberDialog,
            tooltip: 'Bank number set karein',
          ),
        ],
      ),
      body: Column(
        children: [
          if (_lastEvidenceNote != null)
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(12),
              margin: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.green[900],
                borderRadius: BorderRadius.circular(10),
              ),
              child: Text(
                'Log saved: $_lastEvidenceNote',
                style: const TextStyle(color: Colors.white, fontSize: 13),
              ),
            ),
          const Spacer(),
          Center(
            child: GestureDetector(
              onLongPress: _isActivating ? null : _onSanjeevaniActivated,
              child: Container(
                height: 240,
                width: 240,
                decoration: BoxDecoration(
                  color: _isActivating ? Colors.orange : Colors.red,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.redAccent.withOpacity(0.5),
                      blurRadius: 30,
                      spreadRadius: 8,
                    ),
                  ],
                ),
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        _isActivating ? Icons.hourglass_top : Icons.shield,
                        color: Colors.white,
                        size: 70,
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        'SANJEEVANI\n(2 SEC DABAKAR RAKHEIN)',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          const Spacer(),
          Padding(
            padding: const EdgeInsets.only(bottom: 32),
            child: Text(
              'Long-press isliye rakha hai ki galti se button na dab jaaye.',
              style: TextStyle(color: Colors.grey[500], fontSize: 12),
            ),
          ),
        ],
      ),
    );
  }
}

class _SanjeevaniActionSheet extends StatelessWidget {
  final String? bankNumber;
  final VoidCallback onCall1930;
  final VoidCallback? onCallBank;
  final VoidCallback onSetBankNumber;

  const _SanjeevaniActionSheet({
    required this.bankNumber,
    required this.onCall1930,
    required this.onCallBank,
    required this.onSetBankNumber,
  });

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              'Ab Kya Karein?',
              style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            FilledButton.icon(
              style: FilledButton.styleFrom(
                backgroundColor: Colors.redAccent,
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
              onPressed: () {
                Navigator.pop(context);
                onCall1930();
              },
              icon: const Icon(Icons.phone_in_talk),
              label: const Text('1930 Cyber Crime Helpline Call Karein', style: TextStyle(fontSize: 15)),
            ),
            const SizedBox(height: 12),
            if (onCallBank != null)
              FilledButton.icon(
                style: FilledButton.styleFrom(
                  backgroundColor: Colors.blueAccent,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                onPressed: () {
                  Navigator.pop(context);
                  onCallBank!();
                },
                icon: const Icon(Icons.account_balance),
                label: Text('Bank Helpline Call Karein ($bankNumber)', style: const TextStyle(fontSize: 15)),
              )
            else
              OutlinedButton.icon(
                onPressed: () {
                  Navigator.pop(context);
                  onSetBankNumber();
                },
                icon: const Icon(Icons.add),
                label: const Text('Bank Helpline Number Set Karein'),
              ),
          ],
        ),
      ),
    );
  }
}
