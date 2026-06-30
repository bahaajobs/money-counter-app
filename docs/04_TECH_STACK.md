# التقنيات والأدوات — عداد النقود

**الإصدار:** 1.0  
**التاريخ:** 2026-06-30

---

## الإطار الأساسي: Flutter

### لماذا Flutter؟
- كتابة واحدة تعمل على Android (وiOS مستقبلاً)
- أداء native حقيقي — لا WebView
- دعم ممتاز للغة العربية وRTL
- Material Design 3 جاهز
- مجتمع كبير وحزم مكتملة

### الإصدار المطلوب
```yaml
environment:
  sdk: '>=3.0.0 <4.0.0'
  flutter: '>=3.16.0'
```

---

## الحزم المستخدمة

| الحزمة | الإصدار | الغرض |
|--------|---------|-------|
| `provider` | ^6.1.2 | إدارة الحالة |
| `shared_preferences` | ^2.2.3 | التخزين المحلي |
| `share_plus` | ^9.0.0 | مشاركة النص |
| `uuid` | ^4.4.2 | إنشاء معرفات فريدة |
| `intl` | ^0.19.0 | تنسيق التواريخ والأرقام |

### لماذا `provider` وليس `riverpod` أو `bloc`؟
- المشروع صغير ومتوسط الحجم
- لا يحتاج لـ boilerplate معقد
- سهل القراءة والتعديل
- كافٍ تماماً للحالة المطلوبة

---

## هيكل ملفات المشروع

```
money_counter/
│
├── lib/
│   ├── main.dart                    # نقطة الدخول + MaterialApp + الثيم
│   │
│   ├── models/
│   │   └── models.dart              # Denomination, Profile, Bundle,
│   │                                # DenominationGroup, ProfileSession,
│   │                                # HistoryEntry
│   │
│   ├── providers/
│   │   └── app_provider.dart        # AppProvider (ChangeNotifier)
│   │                                # كل منطق العمل + الحفظ
│   │
│   ├── screens/
│   │   ├── home_screen.dart         # الشاشة الرئيسية
│   │   ├── settings_screen.dart     # قائمة البروفايلات
│   │   ├── profile_editor_screen.dart # إنشاء/تعديل بروفايل
│   │   └── history_screen.dart      # سجل العمليات
│   │
│   └── widgets/
│       ├── total_card.dart          # بطاقة الإجمالي
│       ├── profile_chips.dart       # شريط البروفايلات
│       ├── denomination_group.dart  # مجموعة الفئة (يحتوي bundle rows)
│       ├── bundle_row.dart          # صف الرزمة الواحدة
│       └── bottom_actions.dart      # أزرار الأسفل
│
├── android/                         # إعدادات Android
├── pubspec.yaml                     # تعريف الحزم
│
└── docs/                            # التوثيق (هذه الملفات)
    ├── 01_VISION.md
    ├── 02_DATA_MODEL.md
    ├── 03_UI_SCREENS.md
    ├── 04_TECH_STACK.md
    ├── 05_DEVELOPMENT_LOG.md
    └── 06_TESTING.md
```

---

## AppProvider — واجهة برمجية داخلية

```dart
class AppProvider extends ChangeNotifier {
  // ── State ──────────────────────────────────────
  List<Profile> get profiles
  String get activeProfileId
  Profile get activeProfile
  ProfileSession get activeSession
  double get total
  List<HistoryEntry> get history
  bool get ready

  // ── Profile Management ─────────────────────────
  void selectProfile(String id)
  void addProfile(Profile p)
  void updateProfile(Profile p)
  void deleteProfile(String id)

  // ── Session Actions ────────────────────────────
  void updateBundleCount(int groupIdx, int bundleIdx, int count)
  void addBundle(int groupIdx)
  void removeBundle(int groupIdx, int bundleIdx)
  void addExtraDenomination(double value, String label)
  void resetSession()          // يصفر الأرقام، يحتفظ بالفئات الطارئة

  // ── History ────────────────────────────────────
  HistoryEntry saveToHistory({String? note})
  void deleteHistory(String id)
  String buildShareText(HistoryEntry entry)
  Future<void> shareEntry(HistoryEntry entry)  // يحفظ ثم يشارك
}
```

---

## خوارزمية بناء نص المشاركة

```dart
String buildShareText(HistoryEntry entry) {
  final lines = <String>[];
  
  for (final group in entry.groups) {
    for (final bundle in group.bundles) {
      if (bundle.noteCount <= 0) continue;
      
      final fullBundles = bundle.noteCount ~/ 100;
      final remainder = bundle.noteCount % 100;
      
      if (fullBundles > 0) {
        lines.add('${fullBundles}x${denomination}x100');
      }
      if (remainder > 0) {
        lines.add('1x${denomination}x${remainder}');
      }
    }
  }
  
  return '''
💰 عداد النقود — ${entry.profileName} (${entry.currency})
📅 ${formatDate(entry.timestamp)}
${entry.note != null ? '📝 ${entry.note}\n' : ''}──────────────────
${lines.join('\n')}
──────────────────
💵 الإجمالي: ${formatNumber(entry.total)} ${entry.currency}
📦 الرزم الكاملة: ${countFullBundles(entry)}
''';
}
```

---

## بيئة التطوير المطلوبة

```
Windows 11
├── Flutter SDK  ≥ 3.16  → https://docs.flutter.dev/get-started/install/windows
├── Android Studio        → لإعداد Android SDK + Emulator
├── JDK 17+              → مطلوب لبناء Android
└── VS Code (اختياري)    → مع إضافة Flutter
```

### أوامر البدء:
```powershell
flutter doctor -v           # تحقق من البيئة
flutter pub get             # تحميل الحزم
flutter run                 # تشغيل على جهاز/محاكي
flutter build apk --release # بناء APK للتوزيع
```

### تشغيل بدون جهاز (محاكي):
```powershell
# في Android Studio:
# Tools → AVD Manager → Create Virtual Device → Pixel 6 → API 34
flutter emulators --launch <emulator_id>
flutter run
```
