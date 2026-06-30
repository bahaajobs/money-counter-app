import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../main.dart';

class DenominationRowWidget extends StatefulWidget {
  final String label;
  final double denominationValue;
  final String currency;
  final double initialCount;
  final bool isLast;
  final bool canDelete;
  final ValueChanged<double> onCountChanged;
  final VoidCallback onAddBundle;
  final VoidCallback onDelete;

  const DenominationRowWidget({
    super.key,
    required this.label,
    required this.denominationValue,
    required this.currency,
    required this.initialCount,
    required this.isLast,
    required this.canDelete,
    required this.onCountChanged,
    required this.onAddBundle,
    required this.onDelete,
  });

  @override
  State<DenominationRowWidget> createState() => _DenominationRowWidgetState();
}

class _DenominationRowWidgetState extends State<DenominationRowWidget> {
  late TextEditingController _ctrl;
  late FocusNode _focus;

  @override
  void initState() {
    super.initState();
    _ctrl = TextEditingController(
        text: widget.initialCount > 0 ? _fmt(widget.initialCount) : '');
    _focus = FocusNode();
    _focus.addListener(() {
      if (!_focus.hasFocus) _parse();
    });
  }

  @override
  void didUpdateWidget(DenominationRowWidget old) {
    super.didUpdateWidget(old);
    if (old.initialCount != widget.initialCount && !_focus.hasFocus) {
      _ctrl.text = widget.initialCount > 0 ? _fmt(widget.initialCount) : '';
    }
  }

  String _fmt(double v) =>
      v == v.truncateToDouble() ? v.toInt().toString() : v.toStringAsFixed(2);

  void _parse() {
    final val = double.tryParse(_ctrl.text.replaceAll(',', '')) ?? 0;
    widget.onCountChanged(val);
  }

  double get _total {
    final val = double.tryParse(_ctrl.text.replaceAll(',', '')) ?? 0;
    return val * widget.denominationValue;
  }

  String _bundleInfo(BuildContext context) {
    final val = double.tryParse(_ctrl.text.replaceAll(',', '')) ?? 0;
    if (val <= 0) return '';
    final bundles = (val / 100).floor();
    final rem = (val % 100).toInt();
    if (bundles == 0) return '';
    if (rem == 0) return context.l10n.bundleInfoCompact(bundles);
    return context.l10n.bundleInfoWithRemainder(bundles, rem);
  }

  @override
  void dispose() {
    _ctrl.dispose();
    _focus.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;
    final l10n = context.l10n;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          SizedBox(
            width: 90,
            child: Text(
              widget.label,
              style: theme.textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.bold,
                color: cs.primary,
              ),
              textAlign: TextAlign.right,
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: TextField(
              controller: _ctrl,
              focusNode: _focus,
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              inputFormatters: [
                FilteringTextInputFormatter.allow(RegExp(r'[\d.,]'))
              ],
              textAlign: TextAlign.center,
              decoration: InputDecoration(
                isDense: true,
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
                border:
                    OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                hintText: l10n.notesInputHint,
                hintStyle: TextStyle(
                    fontSize: 12, color: cs.onSurface.withValues(alpha: 0.4)),
                suffixText: _bundleInfo(context),
                suffixStyle:
                    TextStyle(fontSize: 10, color: cs.secondary),
              ),
              onChanged: (_) {
                setState(() {});
                _parse();
              },
            ),
          ),
          const SizedBox(width: 6),
          SizedBox(
            width: 76,
            child: Text(
              _total > 0 ? _fmtTotal(_total) : '',
              style: theme.textTheme.bodySmall?.copyWith(color: cs.secondary),
              textAlign: TextAlign.center,
            ),
          ),
          if (widget.canDelete)
            IconButton(
              icon: const Icon(Icons.remove_circle_outline, size: 20),
              color: cs.error,
              onPressed: widget.onDelete,
              visualDensity: VisualDensity.compact,
            )
          else
            const SizedBox(width: 40),
          if (widget.isLast)
            IconButton(
              icon: const Icon(Icons.add_circle, size: 24),
              color: cs.primary,
              onPressed: widget.onAddBundle,
              visualDensity: VisualDensity.compact,
            )
          else
            const SizedBox(width: 40),
        ],
      ),
    );
  }

  String _fmtTotal(double v) => v >= 1000000
      ? '${(v / 1000000).toStringAsFixed(1)}M'
      : v >= 1000
          ? '${(v / 1000).toStringAsFixed(1)}K'
          : v == v.truncateToDouble()
              ? v.toInt().toString()
              : v.toStringAsFixed(1);
}
