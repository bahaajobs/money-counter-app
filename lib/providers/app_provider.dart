import 'dart:convert';
import 'package:flutter/widgets.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';
import '../models/models.dart';

const _uuid = Uuid();

// Default profile names use keys resolved at runtime via l10n.
// Labels here are English fallbacks used before locale loads.
List<Profile> _defaultProfiles() => [
      Profile(
        id: 'egp',
        name: 'Egyptian Pound',
        currency: 'EGP',
        initialRows: 1,
        denominations: [
          Denomination(value: 200, label: '200'),
          Denomination(value: 100, label: '100'),
          Denomination(value: 50, label: '50'),
          Denomination(value: 20, label: '20'),
          Denomination(value: 10, label: '10'),
          Denomination(value: 5, label: '5'),
          Denomination(value: 1, label: '1'),
        ],
      ),
      Profile(
        id: 'usd',
        name: 'US Dollar',
        currency: 'USD',
        initialRows: 1,
        denominations: [
          Denomination(value: 100, label: '100'),
          Denomination(value: 50, label: '50'),
          Denomination(value: 20, label: '20'),
          Denomination(value: 10, label: '10'),
          Denomination(value: 5, label: '5'),
          Denomination(value: 1, label: '1'),
        ],
      ),
    ];

class AppProvider extends ChangeNotifier {
  late SharedPreferences _prefs;
  bool _ready = false;

  // ── Locale ────────────────────────────────────────────────────────────────
  Locale _locale = const Locale('en');
  Locale get locale => _locale;

  static const supportedLocales = [
    (code: 'en', name: 'English',  nativeName: 'English',  flag: '🇺🇸'),
    (code: 'ar', name: 'Arabic',   nativeName: 'العربية',  flag: '🇸🇦'),
  ];

  void setLocale(String languageCode) {
    _locale = Locale(languageCode);
    _prefs.setString('locale', languageCode);
    notifyListeners();
  }

  void _loadLocale() {
    final code = _prefs.getString('locale') ?? 'en';
    _locale = Locale(code);
  }

  List<Profile> _profiles = [];
  String _activeProfileId = '';

  // sessions keyed by profileId
  final Map<String, ProfileSession> _sessions = {};

  List<HistoryEntry> _history = [];

  // ── getters ──────────────────────────────────────────────────────────────
  bool get ready => _ready;
  List<Profile> get profiles => _profiles;
  String get activeProfileId => _activeProfileId;
  List<HistoryEntry> get history => List.unmodifiable(_history);

  Profile get activeProfile =>
      _profiles.firstWhere((p) => p.id == _activeProfileId,
          orElse: () => _profiles.first);

  ProfileSession get activeSession {
    _sessions.putIfAbsent(_activeProfileId, () => _buildFreshSession(activeProfile));
    return _sessions[_activeProfileId]!;
  }

  double get total => activeSession.total;

  // ── init ─────────────────────────────────────────────────────────────────
  Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
    _loadLocale();
    _loadProfiles();
    _loadSessions();
    _loadHistory();
    _activeProfileId = _prefs.getString('activeProfileId') ?? _profiles.first.id;
    _ready = true;
    notifyListeners();
  }

  // ── profile management ────────────────────────────────────────────────────
  void selectProfile(String id) {
    _activeProfileId = id;
    _prefs.setString('activeProfileId', id);
    notifyListeners();
  }

  void addProfile(Profile p) {
    _profiles.add(p);
    _saveProfiles();
    notifyListeners();
  }

  void updateProfile(Profile p) {
    final idx = _profiles.indexWhere((x) => x.id == p.id);
    if (idx >= 0) {
      _profiles[idx] = p;
      _saveProfiles();
      notifyListeners();
    }
  }

  void deleteProfile(String id) {
    if (_profiles.length <= 1) return;
    _profiles.removeWhere((p) => p.id == id);
    _sessions.remove(id);
    if (_activeProfileId == id) _activeProfileId = _profiles.first.id;
    _saveProfiles();
    _saveSessions();
    notifyListeners();
  }

  // ── session actions ───────────────────────────────────────────────────────
  void updateCount(int groupIdx, int bundleIdx, double value) {
    activeSession.groups[groupIdx].bundles[bundleIdx].count = value;
    _saveSessions();
    notifyListeners();
  }

  void addBundle(int groupIdx) {
    activeSession.groups[groupIdx].addBundle();
    _saveSessions();
    notifyListeners();
  }

  void removeBundle(int groupIdx, int bundleIdx) {
    final group = activeSession.groups[groupIdx];
    if (group.bundles.length > 1) {
      group.bundles.removeAt(bundleIdx);
    } else {
      group.bundles[0].count = 0;
    }
    _saveSessions();
    notifyListeners();
  }

  void addExtraDenomination(double value, String label) {
    final session = activeSession;
    final alreadyExists = session.groups.any((g) => g.denomination.value == value);
    if (alreadyExists) return;
    final den = Denomination(value: value, label: label.isEmpty ? '$value' : label);
    session.groups.add(DenominationGroup(denomination: den));
    _saveSessions();
    notifyListeners();
  }

  void resetSession() {
    _sessions[_activeProfileId] = _buildFreshSession(activeProfile);
    _saveSessions();
    notifyListeners();
  }

  // ── history ───────────────────────────────────────────────────────────────
  HistoryEntry saveHistory({String? note}) {
    final session = activeSession;
    final profile = activeProfile;

    // deep-clone groups
    final clonedGroups = session.groups
        .map((g) => DenominationGroup(
              denomination: g.denomination,
              bundles: g.bundles.map((b) => b.clone()).toList(),
            ))
        .toList();

    final entry = HistoryEntry(
      id: _uuid.v4(),
      profileId: profile.id,
      profileName: profile.name,
      currency: profile.currency,
      timestamp: DateTime.now(),
      groups: clonedGroups,
      total: session.total,
      note: note,
    );
    _history.insert(0, entry);
    _saveHistory();
    notifyListeners();
    return entry;
  }

  void deleteHistory(String id) {
    _history.removeWhere((e) => e.id == id);
    _saveHistory();
    notifyListeners();
  }

  String buildShareText(HistoryEntry entry) {
    final buf = StringBuffer();
    buf.writeln('💰 ${entry.profileName} — ${entry.currency}');
    buf.writeln('📅 ${_formatDateTime(entry.timestamp)}');
    if (entry.note != null && entry.note!.isNotEmpty) {
      buf.writeln('📝 ${entry.note}');
    }
    buf.writeln('─────────────────');
    for (final g in entry.groups) {
      for (final b in g.bundles) {
        if (b.count <= 0) continue;
        final bundles = (b.count / 100).floor();
        final remainder = (b.count % 100).toInt();
        final bundleStr =
            bundles > 0 ? '$bundles رزمة${remainder > 0 ? ' + $remainder ورقة' : ''}' : '${b.count.toInt()} ورقة';
        buf.writeln('${b.label}: $bundleStr = ${_fmt(b.total)} ${entry.currency}');
      }
    }
    buf.writeln('─────────────────');
    buf.writeln('الإجمالي: ${_fmt(entry.total)} ${entry.currency}');
    return buf.toString();
  }

  // ── helpers ───────────────────────────────────────────────────────────────
  ProfileSession _buildFreshSession(Profile profile) => ProfileSession(
        profileId: profile.id,
        groups: profile.denominations
            .map((d) => DenominationGroup(denomination: d))
            .toList(),
      );

  String _fmt(double v) =>
      v == v.truncateToDouble() ? v.toInt().toString() : v.toStringAsFixed(2);

  String _formatDateTime(DateTime dt) {
    final d = '${dt.day.toString().padLeft(2, '0')}/${dt.month.toString().padLeft(2, '0')}/${dt.year}';
    final t = '${dt.hour.toString().padLeft(2, '0')}:${dt.minute.toString().padLeft(2, '0')}';
    return '$d $t';
  }

  // ── persistence ───────────────────────────────────────────────────────────
  void _loadProfiles() {
    final raw = _prefs.getString('profiles');
    if (raw != null) {
      final list = jsonDecode(raw) as List;
      _profiles = list.map((e) => Profile.fromJson(e as Map<String, dynamic>)).toList();
    } else {
      _profiles = _defaultProfiles();
      _saveProfiles();
    }
  }

  void _saveProfiles() {
    _prefs.setString('profiles', jsonEncode(_profiles.map((p) => p.toJson()).toList()));
  }

  void _loadSessions() {
    final raw = _prefs.getString('sessions');
    if (raw == null) return;
    final map = jsonDecode(raw) as Map<String, dynamic>;
    map.forEach((key, value) {
      _sessions[key] = ProfileSession.fromJson(value as Map<String, dynamic>);
    });
  }

  void _saveSessions() {
    final map = <String, dynamic>{};
    _sessions.forEach((key, s) => map[key] = s.toJson());
    _prefs.setString('sessions', jsonEncode(map));
  }

  void _loadHistory() {
    final raw = _prefs.getString('history');
    if (raw == null) return;
    final list = jsonDecode(raw) as List;
    _history = list.map((e) => HistoryEntry.fromJson(e as Map<String, dynamic>)).toList();
  }

  void _saveHistory() {
    _prefs.setString('history', jsonEncode(_history.map((e) => e.toJson()).toList()));
  }
}
