import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/providers/history_provider.dart';
import 'widgets/history_card.dart';

class HistoryPage extends StatefulWidget {
  const HistoryPage({super.key});

  @override
  State<HistoryPage> createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<HistoryProvider>().loadHistory();
    });
  }

  bool _isSameDay(DateTime a, DateTime b) {
    return a.year == b.year && a.month == b.month && a.day == b.day;
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<HistoryProvider>();
    final histories = provider.historyItems;
    final now = DateTime.now();

    final today = histories
        .where((e) => e.createdAt != null && _isSameDay(e.createdAt!, now))
        .toList();

    final earlier = histories.where((e) {
      if (e.createdAt == null) return false;
      return !_isSameDay(e.createdAt!, now);
    }).toList();

    today.sort((a, b) => b.createdAt!.compareTo(a.createdAt!));
    earlier.sort((a, b) => b.createdAt!.compareTo(a.createdAt!));

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: const Text('History Scan'),
        actions: [
          if (histories.isNotEmpty)
            IconButton(
              icon: const Icon(Icons.delete_outline),
              onPressed: () async {
                final confirm = await showDialog<bool>(
                  context: context,
                  builder: (_) => AlertDialog(
                    title: const Text('Clear history'),
                    content: const Text(
                      'Are you sure you want to delete all history?',
                    ),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(context, false),
                        child: const Text('Cancel'),
                      ),
                      TextButton(
                        onPressed: () => Navigator.pop(context, true),
                        child: const Text('Delete'),
                      ),
                    ],
                  ),
                );

                if (confirm == true) {
                  provider.clearHistory();
                }
              },
            ),
        ],
      ),
      body: histories.isEmpty
          ? const Center(child: Text('No history yet'))
          : ListView(
              padding: const EdgeInsets.all(16),
              children: [
                if (today.isNotEmpty) ...[
                  const Text(
                    'Today',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 12),
                  ...today.map((e) => HistoryCard(history: e)),
                  const SizedBox(height: 24),
                ],
                if (earlier.isNotEmpty) ...[
                  const Text(
                    'Earlier',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 12),
                  ...earlier.map((e) => HistoryCard(history: e)),
                ],
              ],
            ),
    );
  }
}
