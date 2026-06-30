import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';
import '../providers/app_provider.dart';
import '../models/models.dart';
import '../main.dart';

const _uuid = Uuid();

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<AppProvider>();
    final l10n = context.l10n;

    return Scaffold(
      appBar: AppBar(title: Text(l10n.settings)),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // ── Language Section ────────────────────────────────────────────
          _SectionHeader(label: l10n.language),
          _LanguageSelector(currentLocale: provider.locale),
          const SizedBox(height: 16),

          // ── Profiles Section ────────────────────────────────────────────
          _SectionHeader(label: l10n.profiles),
          ...provider.profiles.map((p) => _ProfileTile(profile: p)),
          const SizedBox(height: 8),
          FilledButton.icon(
            icon: const Icon(Icons.add),
            label: Text(l10n.addProfile),
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const ProfileEditorScreen()),
            ),
          ),
          const SizedBox(height: 16),

          // ── About Section ───────────────────────────────────────────────
          _SectionHeader(label: l10n.about),
          Card(
            child: Column(
              children: [
                ListTile(
                  leading: const Icon(Icons.info_outline),
                  title: Text(l10n.version),
                  trailing: const Text('1.0.3',
                      style: TextStyle(color: Colors.grey)),
                ),
                const Divider(height: 1, indent: 56),
                ListTile(
                  leading: const Icon(Icons.person_outline),
                  title: Text(l10n.aboutCredit),
                  dense: true,
                ),
                const Divider(height: 1, indent: 56),
                ListTile(
                  leading: const Icon(Icons.copyright_outlined),
                  title: Text(l10n.aboutCopyright),
                  dense: true,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ── Section Header ────────────────────────────────────────────────────────────
class _SectionHeader extends StatelessWidget {
  final String label;
  const _SectionHeader({required this.label});

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.only(bottom: 8),
        child: Text(
          label.toUpperCase(),
          style: TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.w600,
            letterSpacing: .8,
            color: Theme.of(context).colorScheme.primary,
          ),
        ),
      );
}

// ── Language Selector ─────────────────────────────────────────────────────────
class _LanguageSelector extends StatelessWidget {
  final Locale currentLocale;
  const _LanguageSelector({required this.currentLocale});

  @override
  Widget build(BuildContext context) {
    final provider = context.read<AppProvider>();

    return Card(
      margin: EdgeInsets.zero,
      child: Column(
        children: [
          for (int i = 0; i < AppProvider.supportedLocales.length; i++) ...[
            if (i > 0)
              Divider(height: 1, indent: 56, endIndent: 0,
                  color: Theme.of(context).dividerColor),
            _LanguageRow(
              lang: AppProvider.supportedLocales[i],
              isSelected: currentLocale.languageCode ==
                  AppProvider.supportedLocales[i].code,
              isDefault: i == 0,
              onTap: () => provider.setLocale(AppProvider.supportedLocales[i].code),
            ),
          ],
        ],
      ),
    );
  }
}

class _LanguageRow extends StatelessWidget {
  final ({String code, String name, String nativeName, String flag}) lang;
  final bool isSelected;
  final bool isDefault;
  final VoidCallback onTap;

  const _LanguageRow({
    required this.lang,
    required this.isSelected,
    required this.isDefault,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Row(
          children: [
            // Flag
            Text(lang.flag, style: const TextStyle(fontSize: 24)),
            const SizedBox(width: 12),
            // Names
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(lang.name,
                          style: TextStyle(
                              fontSize: 14,
                              fontWeight: isSelected
                                  ? FontWeight.w600
                                  : FontWeight.normal)),
                      if (isDefault) ...[
                        const SizedBox(width: 6),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(
                            color: cs.primaryContainer,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text('Default',
                              style: TextStyle(
                                  fontSize: 9,
                                  color: cs.onPrimaryContainer,
                                  fontWeight: FontWeight.w600)),
                        ),
                      ],
                    ],
                  ),
                  Text(lang.nativeName,
                      style: TextStyle(
                          fontSize: 11, color: cs.onSurface.withValues(alpha:.5))),
                ],
              ),
            ),
            // Radio indicator
            AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              width: 22,
              height: 22,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: isSelected ? cs.primary : cs.outline,
                  width: isSelected ? 6 : 1.5,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Profile Tile ──────────────────────────────────────────────────────────────
class _ProfileTile extends StatelessWidget {
  final Profile profile;
  const _ProfileTile({required this.profile});

  @override
  Widget build(BuildContext context) {
    final provider = context.read<AppProvider>();
    final cs = Theme.of(context).colorScheme;
    final l10n = context.l10n;
    final isActive = provider.activeProfileId == profile.id;

    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      color: isActive ? cs.primaryContainer.withValues(alpha:.4) : null,
      child: ListTile(
        title: Text(profile.name,
            style: const TextStyle(fontWeight: FontWeight.w600)),
        subtitle: Text(
            '${profile.currency} • ${profile.denominations.length} ${l10n.denominations.toLowerCase()}'),
        leading: CircleAvatar(
          backgroundColor: cs.primaryContainer,
          child: Text(
            profile.currency.substring(0, 1),
            style: TextStyle(
                color: cs.onPrimaryContainer, fontWeight: FontWeight.bold),
          ),
        ),
        trailing: PopupMenuButton<String>(
          onSelected: (val) {
            if (val == 'edit') {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (_) => ProfileEditorScreen(profile: profile)),
              );
            } else if (val == 'delete') {
              _confirmDelete(context, provider, profile, l10n);
            }
          },
          itemBuilder: (_) => [
            PopupMenuItem(value: 'edit', child: Text(l10n.editProfile)),
            if (provider.profiles.length > 1)
              PopupMenuItem(value: 'delete', child: Text(l10n.deleteProfile)),
          ],
        ),
      ),
    );
  }

  void _confirmDelete(
      BuildContext context, AppProvider provider, Profile p, l10n) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(l10n.deleteProfile),
        content: Text(l10n.confirmDeleteProfile(p.name)),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: Text(l10n.cancel)),
          FilledButton(
            style: FilledButton.styleFrom(
                backgroundColor: Theme.of(context).colorScheme.error),
            onPressed: () {
              provider.deleteProfile(p.id);
              Navigator.pop(ctx);
            },
            child: Text(l10n.delete),
          ),
        ],
      ),
    );
  }
}

// ── Profile Editor Screen ─────────────────────────────────────────────────────
class ProfileEditorScreen extends StatefulWidget {
  final Profile? profile;
  const ProfileEditorScreen({super.key, this.profile});

  @override
  State<ProfileEditorScreen> createState() => _ProfileEditorScreenState();
}

class _ProfileEditorScreenState extends State<ProfileEditorScreen> {
  late TextEditingController _nameCtrl;
  late TextEditingController _currencyCtrl;
  late List<_DenomEdit> _dens;

  @override
  void initState() {
    super.initState();
    final p = widget.profile;
    _nameCtrl = TextEditingController(text: p?.name ?? '');
    _currencyCtrl = TextEditingController(text: p?.currency ?? '');
    _dens = (p?.denominations ?? [])
        .map((d) => _DenomEdit(d.value, d.label))
        .toList();
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    _currencyCtrl.dispose();
    super.dispose();
  }

  void _save() {
    final l10n = context.l10n;
    final name = _nameCtrl.text.trim();
    final currency = _currencyCtrl.text.trim().toUpperCase();

    if (name.isEmpty) {
      _showError(l10n.nameRequired);
      return;
    }
    if (currency.isEmpty) {
      _showError(l10n.currencyRequired);
      return;
    }

    final dens = _dens
        .where((d) => d.value > 0)
        .map((d) => Denomination(
            value: d.value,
            label: d.label.isEmpty ? '${d.value}' : d.label))
        .toList();

    if (dens.isEmpty) {
      _showError(l10n.atLeastOneDenomination);
      return;
    }

    final provider = context.read<AppProvider>();
    if (widget.profile != null) {
      provider.updateProfile(widget.profile!
          .copyWith(name: name, currency: currency, denominations: dens));
    } else {
      provider.addProfile(Profile(
          id: _uuid.v4(),
          name: name,
          currency: currency,
          denominations: dens));
    }
    Navigator.pop(context);
  }

  void _showError(String msg) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(msg)));
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.profile == null ? l10n.newProfile : l10n.editProfile),
        actions: [
          TextButton(
            onPressed: _save,
            child: Text(l10n.save,
                style: const TextStyle(color: Colors.white, fontSize: 15)),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          TextField(
            controller: _nameCtrl,
            decoration: InputDecoration(
                labelText: l10n.profileName,
                border: const OutlineInputBorder()),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _currencyCtrl,
            decoration: InputDecoration(
                labelText: l10n.currencyCode,
                border: const OutlineInputBorder()),
            inputFormatters: [
              FilteringTextInputFormatter.allow(RegExp(r'[A-Za-z]'))
            ],
            maxLength: 5,
          ),
          const SizedBox(height: 8),
          Text(l10n.denominations,
              style: Theme.of(context).textTheme.titleMedium),
          Text(l10n.dragToReorder,
              style: TextStyle(
                  fontSize: 11,
                  color: Theme.of(context).colorScheme.onSurface.withValues(alpha:.5))),
          const SizedBox(height: 8),
          ReorderableListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: _dens.length,
            onReorder: (old, neo) {
              setState(() {
                if (neo > old) neo--;
                final item = _dens.removeAt(old);
                _dens.insert(neo, item);
              });
            },
            itemBuilder: (ctx, i) => _DenomRow(
              key: ValueKey(i),
              den: _dens[i],
              valueHint: l10n.denominationValue,
              labelHint: l10n.denominationLabel,
              onRemove: () => setState(() => _dens.removeAt(i)),
            ),
          ),
          const SizedBox(height: 8),
          OutlinedButton.icon(
            icon: const Icon(Icons.add),
            label: Text(l10n.addDenomination),
            onPressed: () => setState(() => _dens.add(_DenomEdit(0, ''))),
          ),
          const SizedBox(height: 24),
          FilledButton(onPressed: _save, child: Text(l10n.saveProfile)),
        ],
      ),
    );
  }
}

// ── Denomination Edit Helpers ─────────────────────────────────────────────────
class _DenomEdit {
  double value;
  String label;
  final TextEditingController valueCtrl;
  final TextEditingController labelCtrl;

  _DenomEdit(this.value, this.label)
      : valueCtrl = TextEditingController(
            text: value > 0 ? value.toInt().toString() : ''),
        labelCtrl = TextEditingController(text: label);
}

class _DenomRow extends StatelessWidget {
  final _DenomEdit den;
  final String valueHint;
  final String labelHint;
  final VoidCallback onRemove;

  const _DenomRow({
    super.key,
    required this.den,
    required this.valueHint,
    required this.labelHint,
    required this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          const Icon(Icons.drag_handle, color: Colors.grey),
          const SizedBox(width: 8),
          SizedBox(
            width: 80,
            child: TextField(
              controller: den.valueCtrl,
              keyboardType: TextInputType.number,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              decoration: InputDecoration(
                  labelText: valueHint,
                  isDense: true,
                  border: const OutlineInputBorder()),
              onChanged: (v) => den.value = double.tryParse(v) ?? 0,
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: TextField(
              controller: den.labelCtrl,
              decoration: InputDecoration(
                  labelText: labelHint,
                  isDense: true,
                  border: const OutlineInputBorder()),
              onChanged: (v) => den.label = v,
            ),
          ),
          IconButton(
            icon: const Icon(Icons.delete_outline, color: Colors.red),
            onPressed: onRemove,
          ),
        ],
      ),
    );
  }
}
