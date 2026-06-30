class Denomination {
  final double value;
  final String label;

  Denomination({required this.value, required this.label});

  Map<String, dynamic> toJson() => {'value': value, 'label': label};

  factory Denomination.fromJson(Map<String, dynamic> j) =>
      Denomination(value: (j['value'] as num).toDouble(), label: j['label'] as String);

  @override
  bool operator ==(Object other) => other is Denomination && other.value == value;

  @override
  int get hashCode => value.hashCode;
}

class Profile {
  final String id;
  String name;
  String currency;
  List<Denomination> denominations;
  int initialRows;

  Profile({
    required this.id,
    required this.name,
    required this.currency,
    required this.denominations,
    this.initialRows = 1,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'currency': currency,
        'denominations': denominations.map((d) => d.toJson()).toList(),
        'initialRows': initialRows,
      };

  factory Profile.fromJson(Map<String, dynamic> j) => Profile(
        id: j['id'] as String,
        name: j['name'] as String,
        currency: j['currency'] as String,
        denominations: (j['denominations'] as List)
            .map((d) => Denomination.fromJson(d as Map<String, dynamic>))
            .toList(),
        initialRows: (j['initialRows'] as int?) ?? 1,
      );

  Profile copyWith({
    String? name,
    String? currency,
    List<Denomination>? denominations,
    int? initialRows,
  }) =>
      Profile(
        id: id,
        name: name ?? this.name,
        currency: currency ?? this.currency,
        denominations: denominations ?? this.denominations,
        initialRows: initialRows ?? this.initialRows,
      );
}

/// A single bundle entry: denomination value + count entered by user
class BundleEntry {
  double denominationValue;
  String label;
  double count; // number of notes

  BundleEntry({required this.denominationValue, required this.label, this.count = 0});

  double get total => denominationValue * count;

  Map<String, dynamic> toJson() =>
      {'denominationValue': denominationValue, 'label': label, 'count': count};

  factory BundleEntry.fromJson(Map<String, dynamic> j) => BundleEntry(
        denominationValue: (j['denominationValue'] as num).toDouble(),
        label: j['label'] as String,
        count: (j['count'] as num).toDouble(),
      );

  BundleEntry clone() =>
      BundleEntry(denominationValue: denominationValue, label: label, count: count);
}

/// A denomination group: one denomination with possibly multiple bundles (rows)
class DenominationGroup {
  Denomination denomination;
  List<BundleEntry> bundles; // each bundle is one row

  DenominationGroup({required this.denomination, List<BundleEntry>? bundles})
      : bundles = bundles ?? [BundleEntry(denominationValue: denomination.value, label: denomination.label)];

  double get groupTotal => bundles.fold(0, (sum, b) => sum + b.total);

  void addBundle() {
    bundles.add(BundleEntry(denominationValue: denomination.value, label: denomination.label));
  }

  Map<String, dynamic> toJson() => {
        'denomination': denomination.toJson(),
        'bundles': bundles.map((b) => b.toJson()).toList(),
      };

  factory DenominationGroup.fromJson(Map<String, dynamic> j) => DenominationGroup(
        denomination: Denomination.fromJson(j['denomination'] as Map<String, dynamic>),
        bundles: (j['bundles'] as List)
            .map((b) => BundleEntry.fromJson(b as Map<String, dynamic>))
            .toList(),
      );
}

/// Saved session state per profile
class ProfileSession {
  final String profileId;
  List<DenominationGroup> groups;

  ProfileSession({required this.profileId, required this.groups});

  double get total => groups.fold(0, (sum, g) => sum + g.groupTotal);

  Map<String, dynamic> toJson() => {
        'profileId': profileId,
        'groups': groups.map((g) => g.toJson()).toList(),
      };

  factory ProfileSession.fromJson(Map<String, dynamic> j) => ProfileSession(
        profileId: j['profileId'] as String,
        groups: (j['groups'] as List)
            .map((g) => DenominationGroup.fromJson(g as Map<String, dynamic>))
            .toList(),
      );
}

class HistoryEntry {
  final String id;
  final String profileId;
  final String profileName;
  final String currency;
  final DateTime timestamp;
  final List<DenominationGroup> groups;
  final double total;
  String? note;

  HistoryEntry({
    required this.id,
    required this.profileId,
    required this.profileName,
    required this.currency,
    required this.timestamp,
    required this.groups,
    required this.total,
    this.note,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'profileId': profileId,
        'profileName': profileName,
        'currency': currency,
        'timestamp': timestamp.toIso8601String(),
        'groups': groups.map((g) => g.toJson()).toList(),
        'total': total,
        'note': note,
      };

  factory HistoryEntry.fromJson(Map<String, dynamic> j) => HistoryEntry(
        id: j['id'] as String,
        profileId: j['profileId'] as String,
        profileName: j['profileName'] as String,
        currency: j['currency'] as String,
        timestamp: DateTime.parse(j['timestamp'] as String),
        groups: (j['groups'] as List)
            .map((g) => DenominationGroup.fromJson(g as Map<String, dynamic>))
            .toList(),
        total: (j['total'] as num).toDouble(),
        note: j['note'] as String?,
      );
}
