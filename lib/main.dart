import 'package:flutter/material.dart';
import 'sanjeevani_screen.dart';
import 'settings_screen.dart';
import 'evidence_log_screen.dart';

void main() {
  runApp(const CyberKavachApp());
}

class CyberKavachApp extends StatelessWidget {
  const CyberKavachApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Cyber-Kavach',
      theme: ThemeData(
        primarySwatch: Colors.green,
        useMaterial3: true,
        brightness: Brightness.dark,
        scaffoldBackgroundColor: Colors.black,
      ),
      home: const HomeScreen(),
    );
  }
}

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

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
            tooltip: 'Settings',
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const SettingsScreen()),
            ),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          _StatusCard(
            icon: Icons.shield_outlined,
            title: 'Digital Suraksha',
            subtitle: 'Cyber-Kavach aapke phone ki suraksha ke liye tayyar hai.',
            color: Colors.green[900]!,
          ),
          const SizedBox(height: 20),
          _FeatureTile(
            icon: Icons.emergency_share,
            title: 'Sanjeevani Panic Button',
            subtitle: 'Fraud hone par 2 second dabakar madad bulayein.',
            color: Colors.red,
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const SanjeevaniScreen()),
            ),
          ),
          _FeatureTile(
            icon: Icons.desktop_access_disabled,
            title: 'Screen-Share Suraksha Chalu Karein',
            subtitle:
                'AnyDesk/TeamViewer jaisi apps ko detect karke turant band karta hai. Isko activate karna zaroori hai (Accessibility Settings mein).',
            color: Colors.blueAccent,
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const SettingsScreen()),
            ),
          ),
          _FeatureTile(
            icon: Icons.history,
            title: 'Evidence Log Dekhein',
            subtitle: 'Sanjeevani button kab-kab dabaya gaya, uski list.',
            color: Colors.orange,
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const EvidenceLogScreen()),
            ),
          ),
          const SizedBox(height: 12),
          Text(
            'Note: Screen-share aur call-blocking features ko kaam karne ke liye '
            'Android Accessibility permission on karni hogi — Settings screen se seedha wahan ja sakte hain.',
            style: TextStyle(color: Colors.grey[500], fontSize: 12),
          ),
        ],
      ),
    );
  }
}

class _StatusCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final Color color;

  const _StatusCard({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(14)),
      child: Row(
        children: [
          Icon(icon, color: Colors.white, size: 36),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(color: Colors.white, fontSize: 17, fontWeight: FontWeight.bold)),
                const SizedBox(height: 4),
                Text(subtitle, style: const TextStyle(color: Colors.white70, fontSize: 13)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _FeatureTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final Color color;
  final VoidCallback onTap;

  const _FeatureTile({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: const Color(0xFF141414),
      margin: const EdgeInsets.only(bottom: 14),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        contentPadding: const EdgeInsets.all(14),
        leading: CircleAvatar(backgroundColor: color, child: Icon(icon, color: Colors.white)),
        title: Text(title, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        subtitle: Padding(
          padding: const EdgeInsets.only(top: 6),
          child: Text(subtitle, style: TextStyle(color: Colors.grey[400], fontSize: 12.5)),
        ),
        trailing: const Icon(Icons.chevron_right, color: Colors.grey),
        onTap: onTap,
      ),
    );
  }
}
