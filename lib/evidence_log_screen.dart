import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class EvidenceLogScreen extends StatefulWidget {
  const EvidenceLogScreen({super.key});

  @override
  State<EvidenceLogScreen> createState() => _EvidenceLogScreenState();
}

class _EvidenceLogScreenState extends State<EvidenceLogScreen> {
  List<String> _logs = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _logs = (prefs.getStringList('evidence_logs') ?? []).reversed.toList();
      _loading = false;
    });
  }

  Future<void> _clearLogs() async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: const Color(0xFF1E1E1E),
        title: const Text('Sab logs mitayein?', style: TextStyle(color: Colors.white)),
        content: const Text('Yeh wapas nahi aayega.', style: TextStyle(color: Colors.grey)),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text('Cancel')),
          TextButton(onPressed: () => Navigator.pop(ctx, true), child: const Text('Delete')),
        ],
      ),
    );
    if (confirm == true) {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove('evidence_logs');
      _load();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Evidence Log'),
        backgroundColor: Colors.green[800],
        actions: [
          if (_logs.isNotEmpty)
            IconButton(icon: const Icon(Icons.delete_outline), onPressed: _clearLogs),
        ],
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : _logs.isEmpty
              ? Center(
                  child: Text(
                    'Abhi tak koi log nahi hai.\nSanjeevani button dabane par yahan dikhega.',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.grey[500]),
                  ),
                )
              : ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: _logs.length,
                  itemBuilder: (ctx, i) => Card(
                    color: const Color(0xFF141414),
                    margin: const EdgeInsets.only(bottom: 10),
                    child: ListTile(
                      leading: const Icon(Icons.shield, color: Colors.redAccent),
                      title: Text(_logs[i], style: const TextStyle(color: Colors.white, fontSize: 13)),
                    ),
                  ),
                ),
    );
  }
}
