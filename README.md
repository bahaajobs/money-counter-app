# عداد النقود — Money Counter

تطبيق أندرويد لعد النقود وتنظيمها في رزم، مع دعم كامل للغتين العربية والإنجليزية.

An Android app for counting cash and organizing it into bundles, with full Arabic/English bilingual support.

---

## المميزات | Features

- **رزم تلقائية** — كل رزمة = 100 ورقة، يحسب التطبيق الرزم الكاملة والناقصة تلقائياً
- **بروفايلات متعددة** — إنشاء بروفايل لكل عملة (جنيه مصري، دولار، ...) مع الفئات المناسبة
- **صفوف رزم متعددة** — زر `+` يضيف صف جديد لنفس الفئة (رزمة ثانية أو رزمة ناقصة)
- **فئة طارئة** — إضافة فئة مؤقتة في أي وقت دون تعديل البروفايل
- **حفظ تلقائي** — يُحفظ كل شيء في SharedPreferences فور الإدخال
- **سجل العمليات** — حفظ يدوي في السجل مع ملاحظة اختيارية
- **مشاركة** — تصدير النتيجة بصيغة `NxDxC` جاهزة للمشاركة (واتساب، إلخ)
- **ثنائي اللغة** — عربي / إنجليزي، يختار المستخدم من الإعدادات، RTL/LTR تلقائي

---

## صيغة المشاركة | Share Format

```
5x200x100   → 5 رزم كاملة من فئة 200
1x200x70    → رزمة ناقصة (70 ورقة) من فئة 200
3x100x100   → 3 رزم كاملة من فئة 100
1x100x20    → رزمة ناقصة (20 ورقة) من فئة 100
```

الصيغة: `[عدد الرزم]x[الفئة]x[أوراق في الرزمة]`

---

## التقنيات | Tech Stack

| المكون | التقنية |
|--------|---------|
| Framework | Flutter 3.32.4 |
| Language | Dart 3.8.1 |
| State Management | Provider ^6.1.2 |
| Persistence | shared_preferences ^2.2.3 |
| Sharing | share_plus ^9.0.0 |
| i18n | flutter_localizations (SDK) + intl ^0.20.2 |
| IDs | uuid ^4.4.2 |

---

## هيكل المشروع | Project Structure

```
lib/
├── main.dart                    # App entry + L10nExt extension
├── models/
│   └── models.dart              # Denomination, Profile, BundleEntry, HistoryEntry ...
├── providers/
│   └── app_provider.dart        # State + persistence logic
├── screens/
│   ├── home_screen.dart         # Main counting screen
│   ├── history_screen.dart      # History list
│   └── settings_screen.dart     # Language + profile management
├── widgets/
│   └── denomination_row_widget.dart
└── l10n/
    ├── app_en.arb               # English strings
    └── app_ar.arb               # Arabic strings

docs/
├── 01_VISION.md                 # App vision & concepts
├── 02_DATA_MODEL.md             # Data model design
├── 03_UI_SCREENS.md             # UI wireframes (ASCII)
├── 04_TECH_STACK.md             # Tech decisions
├── 05_DEVELOPMENT_LOG.md        # Development history
├── 06_TESTING.md                # Test cases
└── 07_LOCALIZATION.md           # i18n design
```

---

## البناء | Build

```bash
# المتطلبات
# - Flutter 3.32.4+
# - Android SDK (API 34+)
# - Java JDK 21+

flutter pub get
flutter build apk --debug

# الـ APK في:
# build/app/outputs/flutter-apk/app-debug.apk
```

---

## الترخيص | License

للاستخدام الشخصي. Personal use.
