import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/app_provider.dart';
import '../models/models.dart';
import '../widgets/denomination_row_widget.dart';
import '../main.dart';
import 'settings_screen.dart';
import 'history_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    final provider = context.watch<AppProvider>();
    final theme = Theme.of(context);
    final cs = theme.colorScheme;
    final l10n = context.l10n;

    if (!provider.ready) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    final session = provider.activeSession;
    final profile = provider.activeProfile;
    final total = provider.total;

    return Scaffold(
      backgroundColor: cs.surface,
      appBar: AppBar(
        title: Text(l10n.appTitle, style: const TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.history),
            onPressed: () => Navigator.push(
                context, MaterialPageRoute(builder: (_) => const HistoryScreen())),
          ),
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () => Navigator.push(
                context, MaterialPageRoute(builder: (_) => const SettingsScreen())),
          ),
        ],
      ),
      body: Column(
        children: [
          _TotalCard(total: total, currency: profile.currency),
          _ProfileSelector(
            profiles: provider.profiles,
            activeId: provider.activeProfileId,
            onSelect: provider.selectProfile,
          ),
          Expanded(
            child: ListView.separated(
              padding: const EdgeInsets.fromLTRB(12, 8, 12, 8),
              itemCount: session.groups.length,
              separatorBuilder: (_, __) => const Divider(height: 1),
              itemBuilder: (ctx, gIdx) {
                final group = session.groups[gIdx];
                return _GroupSection(
                  group: group,
                  currency: profile.currency,
                  groupIdx: gIdx,
                  onCountChanged: (bIdx, val) => provider.updateCount(gIdx, bIdx, val),
                  onAddBundle: () => provider.addBundle(gIdx),
                  onDeleteBundle: (bIdx) => provider.removeBundle(gIdx, bIdx),
                );
              },
            ),
          ),
          Container(
            decoration: BoxDecoration(
              color: cs.surface,
              border: Border(top: BorderSide(color: cs.outlineVariant, width: 0.5)),
            ),
            child: SafeArea(
              top: false,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
                child: Row(
                  children: [
                    Expanded(
                      child: ElevatedButton.icon(
                        icon: const Icon(Icons.add),
                        label: Text(l10n.addExtraDenomination),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: cs.secondaryContainer,
                          foregroundColor: cs.onSecondaryContainer,
                        ),
                        onPressed: () => _showAddDenominationDialog(context, provider),
                      ),
                    ),
                    const SizedBox(width: 8),
                    OutlinedButton.icon(
                      icon: const Icon(Icons.refresh),
                      label: Text(l10n.reset),
                      onPressed: () => _confirmReset(context, provider),
                    ),
                    const SizedBox(width: 8),
                    FilledButton.icon(
                      icon: const Icon(Icons.save),
                      label: Text(l10n.save),
                      onPressed: () => _saveHistory(context, provider),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showAddDenominationDialog(BuildContext context, AppProvider provider) {
    final l10n = context.l10n;
    final valueCtrl = TextEditingController();
    final labelCtrl = TextEditingController();
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(l10n.addDenominationTitle),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: valueCtrl,
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              decoration: InputDecoration(
                  labelText: l10n.denominationValue,
                  hintText: l10n.denominationValueHint),
              autofocus: true,
            ),
            const SizedBox(height: 8),
            TextField(
              controller: labelCtrl,
              decoration: InputDecoration(
                  labelText: l10n.denominationLabel,
                  hintText: l10n.denominationLabelHint),
            ),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: Text(l10n.cancel)),
          FilledButton(
            onPressed: () {
              final val = double.tryParse(valueCtrl.text);
              if (val != null && val > 0) {
                provider.addExtraDenomination(val, labelCtrl.text.trim());
                Navigator.pop(ctx);
              }
            },
            child: Text(l10n.add),
          ),
        ],
      ),
    );
  }

  void _confirmReset(BuildContext context, AppProvider provider) {
    final l10n = context.l10n;
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(l10n.resetTitle),
        content: Text(l10n.resetConfirm),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: Text(l10n.cancel)),
          FilledButton(
            style: FilledButton.styleFrom(
                backgroundColor: Theme.of(context).colorScheme.error),
            onPressed: () {
              provider.resetSession();
              Navigator.pop(ctx);
            },
            child: Text(l10n.reset),
          ),
        ],
      ),
    );
  }

  void _saveHistory(BuildContext context, AppProvider provider) {
    final l10n = context.l10n;
    final noteCtrl = TextEditingController();
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(l10n.saveToHistory),
        content: TextField(
          controller: noteCtrl,
          decoration: InputDecoration(labelText: l10n.noteOptional),
          autofocus: true,
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: Text(l10n.cancel)),
          FilledButton(
            onPressed: () {
              provider.saveHistory(note: noteCtrl.text.trim());
              Navigator.pop(ctx);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                    content: Text(l10n.savedToHistory),
                    duration: const Duration(seconds: 2)),
              );
            },
            child: Text(l10n.save),
          ),
        ],
      ),
    );
  }
}

// ── Total Card ────────────────────────────────────────────────────────────────
class _TotalCard extends StatelessWidget {
  final double total;
  final String currency;

  const _TotalCard({required this.total, required this.currency});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final l10n = context.l10n;
    final bundleCount = (total / 100).floor();
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.all(12),
      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [cs.primary, cs.primaryContainer],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
              color: cs.primary.withValues(alpha: 0.3),
              blurRadius: 12,
              offset: const Offset(0, 4))
        ],
      ),
      child: Column(
        children: [
          Text(l10n.total,
              style: TextStyle(color: cs.onPrimary.withValues(alpha: 0.8), fontSize: 14)),
          const SizedBox(height: 4),
          FittedBox(
            child: Text(
              '${_fmt(total)} $currency',
              style: TextStyle(
                color: cs.onPrimary,
                fontSize: 36,
                fontWeight: FontWeight.bold,
                letterSpacing: 1,
              ),
            ),
          ),
          if (total > 0)
            Text(
              l10n.fullBundles(bundleCount),
              style: TextStyle(color: cs.onPrimary.withValues(alpha: 0.7), fontSize: 12),
            ),
        ],
      ),
    );
  }

  String _fmt(double v) {
    if (v >= 1000000) return '${(v / 1000000).toStringAsFixed(2)}M';
    if (v >= 1000) return '${(v / 1000).toStringAsFixed(2)}K';
    return v == v.truncateToDouble() ? v.toInt().toString() : v.toStringAsFixed(2);
  }
}

// ── Profile Selector ──────────────────────────────────────────────────────────
class _ProfileSelector extends StatelessWidget {
  final List<Profile> profiles;
  final String activeId;
  final ValueChanged<String> onSelect;

  const _ProfileSelector(
      {required this.profiles, required this.activeId, required this.onSelect});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return SizedBox(
      height: 42,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 12),
        itemCount: profiles.length,
        separatorBuilder: (_, __) => const SizedBox(width: 8),
        itemBuilder: (ctx, i) {
          final p = profiles[i];
          final isActive = p.id == activeId;
          return ChoiceChip(
            label: Text(p.name),
            selected: isActive,
            onSelected: (_) => onSelect(p.id),
            selectedColor: cs.primaryContainer,
            labelStyle: TextStyle(
              color: isActive ? cs.onPrimaryContainer : null,
              fontWeight: isActive ? FontWeight.bold : null,
            ),
          );
        },
      ),
    );
  }
}

// ── Group Section ─────────────────────────────────────────────────────────────
class _GroupSection extends StatelessWidget {
  final DenominationGroup group;
  final String currency;
  final int groupIdx;
  final void Function(int bIdx, double val) onCountChanged;
  final VoidCallback onAddBundle;
  final void Function(int bIdx) onDeleteBundle;

  const _GroupSection({
    required this.group,
    required this.currency,
    required this.groupIdx,
    required this.onCountChanged,
    required this.onAddBundle,
    required this.onDeleteBundle,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final l10n = context.l10n;
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 4),
      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
      decoration: BoxDecoration(
        color: group.groupTotal > 0 ? cs.surfaceContainerHighest : null,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          for (int bIdx = 0; bIdx < group.bundles.length; bIdx++)
            DenominationRowWidget(
              key: ValueKey('$groupIdx-$bIdx'),
              label: group.denomination.label,
              denominationValue: group.denomination.value,
              currency: currency,
              initialCount: group.bundles[bIdx].count,
              isLast: bIdx == group.bundles.length - 1,
              canDelete: group.bundles.length > 1,
              onCountChanged: (val) => onCountChanged(bIdx, val),
              onAddBundle: onAddBundle,
              onDelete: () => onDeleteBundle(bIdx),
            ),
          if (group.groupTotal > 0)
            Padding(
              padding: const EdgeInsets.only(right: 12, bottom: 4),
              child: Text(
                l10n.groupSubtotalLabel(_fmt(group.groupTotal), currency),
                style: TextStyle(
                    fontSize: 11, color: cs.primary, fontWeight: FontWeight.w600),
                textAlign: TextAlign.right,
              ),
            ),
        ],
      ),
    );
  }

  String _fmt(double v) =>
      v == v.truncateToDouble() ? v.toInt().toString() : v.toStringAsFixed(2);
}
