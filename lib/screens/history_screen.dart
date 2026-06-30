import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';
import '../providers/app_provider.dart';
import '../models/models.dart';
import '../main.dart';

class HistoryScreen extends StatelessWidget {
  const HistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<AppProvider>();
    final history = provider.history;
    final l10n = context.l10n;

    return Scaffold(
      appBar: AppBar(title: Text(l10n.history)),
      body: history.isEmpty
          ? Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.history, size: 64, color: Colors.grey),
                  const SizedBox(height: 16),
                  Text(l10n.historyEmpty,
                      style: const TextStyle(color: Colors.grey)),
                ],
              ),
            )
          : ListView.separated(
              padding: const EdgeInsets.all(12),
              itemCount: history.length,
              separatorBuilder: (_, __) => const SizedBox(height: 8),
              itemBuilder: (ctx, i) => _HistoryCard(entry: history[i]),
            ),
    );
  }
}

class _HistoryCard extends StatelessWidget {
  final HistoryEntry entry;
  const _HistoryCard({required this.entry});

  @override
  Widget build(BuildContext context) {
    final provider = context.read<AppProvider>();
    final cs = Theme.of(context).colorScheme;
    final theme = Theme.of(context);
    final l10n = context.l10n;

    return Card(
      elevation: 2,
      child: ExpansionTile(
        leading: CircleAvatar(
          backgroundColor: cs.primaryContainer,
          child: Text(entry.currency.substring(0, 1),
              style: TextStyle(
                  color: cs.onPrimaryContainer, fontWeight: FontWeight.bold)),
        ),
        title: Text(
          '${_fmt(entry.total)} ${entry.currency}',
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(entry.profileName,
                style: TextStyle(color: cs.primary, fontSize: 12)),
            Text(_formatDate(entry.timestamp),
                style: const TextStyle(fontSize: 11, color: Colors.grey)),
            if (entry.note != null && entry.note!.isNotEmpty)
              Text(entry.note!,
                  style: TextStyle(fontSize: 12, color: cs.secondary)),
          ],
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: const Icon(Icons.share),
              onPressed: () {
                final text = provider.buildShareText(entry);
                Share.share(text,
                    subject: '${l10n.appTitle} — ${entry.profileName}');
              },
            ),
            IconButton(
              icon: const Icon(Icons.delete_outline, color: Colors.red),
              onPressed: () => _confirmDelete(context, provider),
            ),
          ],
        ),
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Divider(),
                Row(
                  children: [
                    Expanded(
                        child: Text(l10n.columnDenomination,
                            style:
                                const TextStyle(fontWeight: FontWeight.bold),
                            textAlign: TextAlign.right)),
                    const SizedBox(width: 8),
                    SizedBox(
                        width: 80,
                        child: Text(l10n.columnNotes,
                            style:
                                const TextStyle(fontWeight: FontWeight.bold),
                            textAlign: TextAlign.center)),
                    SizedBox(
                        width: 80,
                        child: Text(l10n.columnBundles,
                            style:
                                const TextStyle(fontWeight: FontWeight.bold),
                            textAlign: TextAlign.center)),
                    SizedBox(
                        width: 90,
                        child: Text(l10n.columnAmount,
                            style:
                                const TextStyle(fontWeight: FontWeight.bold),
                            textAlign: TextAlign.center)),
                  ],
                ),
                const Divider(),
                for (final g in entry.groups)
                  for (final b in g.bundles)
                    if (b.count > 0)
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 3),
                        child: Row(
                          children: [
                            Expanded(
                                child: Text(b.label,
                                    textAlign: TextAlign.right)),
                            const SizedBox(width: 8),
                            SizedBox(
                                width: 80,
                                child: Text('${b.count.toInt()}',
                                    textAlign: TextAlign.center)),
                            SizedBox(
                              width: 80,
                              child: Text(
                                _bundleText(context, b.count),
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    color: cs.secondary, fontSize: 12),
                              ),
                            ),
                            SizedBox(
                              width: 90,
                              child: Text(
                                '${_fmt(b.total)} ${entry.currency}',
                                textAlign: TextAlign.center,
                                style: const TextStyle(
                                    fontWeight: FontWeight.w600),
                              ),
                            ),
                          ],
                        ),
                      ),
                const Divider(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(l10n.total, style: theme.textTheme.titleSmall),
                    Text('${_fmt(entry.total)} ${entry.currency}',
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: cs.primary,
                            fontSize: 16)),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _bundleText(BuildContext context, double count) {
    final b = (count / 100).floor();
    final r = (count % 100).toInt();
    if (b == 0) return '-';
    if (r == 0) return context.l10n.bundleSummaryOnly(b);
    return '$b+$r';
  }

  String _fmt(double v) =>
      v == v.truncateToDouble() ? v.toInt().toString() : v.toStringAsFixed(2);

  String _formatDate(DateTime dt) {
    final d =
        '${dt.day.toString().padLeft(2, '0')}/${dt.month.toString().padLeft(2, '0')}/${dt.year}';
    final t =
        '${dt.hour.toString().padLeft(2, '0')}:${dt.minute.toString().padLeft(2, '0')}';
    return '$d $t';
  }

  void _confirmDelete(BuildContext context, AppProvider provider) {
    final l10n = context.l10n;
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(l10n.deleteEntry),
        content: Text(l10n.deleteEntryConfirm),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: Text(l10n.cancel)),
          FilledButton(
            style: FilledButton.styleFrom(backgroundColor: Colors.red),
            onPressed: () {
              provider.deleteHistory(entry.id);
              Navigator.pop(ctx);
            },
            child: Text(l10n.delete),
          ),
        ],
      ),
    );
  }
}
