import 'package:flutter/material.dart';

class OfflineBanner extends StatefulWidget {
  const OfflineBanner({super.key});

  @override
  State<OfflineBanner> createState() => _OfflineBannerState();
}

class _OfflineBannerState extends State<OfflineBanner> {
  bool _isSyncing = false;

  void _triggerSync() async {
    setState(() => _isSyncing = true);

    // Simulierter Server-Ping & Sync (2 Sekunden)
    await Future.delayed(const Duration(seconds: 2));

    if (mounted) {
      setState(() => _isSyncing = false);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Daten erfolgreich mit dem Schulserver synchronisiert!'),
          backgroundColor: Colors.green,
          duration: Duration(seconds: 2),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.orange[800],
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          const Icon(Icons.wifi_off, color: Colors.white, size: 18),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              _isSyncing
                  ? 'Synchronisiere mit Server...'
                  : 'Offline-Modus – Änderungen lokal gesichert',
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 13,
              ),
            ),
          ),
          _isSyncing
              ? const SizedBox(
            width: 20,
            height: 20,
            child: CircularProgressIndicator(
              color: Colors.white,
              strokeWidth: 2,
            ),
          )
              : TextButton.icon(
            onPressed: _triggerSync,
            icon: const Icon(Icons.sync, color: Colors.white, size: 16),
            label: const Text(
              'Sync',
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }
}