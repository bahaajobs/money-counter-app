# التعدد اللغوي (i18n) — عداد النقود

**الإصدار:** 1.1  
**التاريخ:** 2026-06-30

---

## اللغات المدعومة

| الكود | اللغة | الاتجاه | الحالة |
|-------|-------|---------|--------|
| `en` | English | LTR | افتراضي ✅ |
| `ar` | العربية | RTL | مدعوم ✅ |

> اللغة الافتراضية عند التثبيت الأول: **English**  
> يمكن التغيير من: الإعدادات → Language / اللغة

---

## آلية التطبيق في Flutter

### الحزم المضافة للـ pubspec.yaml
```yaml
dependencies:
  flutter_localizations:
    sdk: flutter
  intl: ^0.19.0          # موجود مسبقاً

flutter:
  generate: true          # مطلوب لتوليد كود الترجمة
```

### هيكل ملفات الترجمة
```
lib/
└── l10n/
    ├── app_en.arb    ← النصوص الإنجليزية (الأساس)
    └── app_ar.arb    ← النصوص العربية
```

### ملف الإعداد: l10n.yaml (في جذر المشروع)
```yaml
arb-dir: lib/l10n
template-arb-file: app_en.arb
output-localization-file: app_localizations.dart
```

---

## ملف app_en.arb — النصوص الإنجليزية

```json
{
  "@@locale": "en",

  "appTitle": "Money Counter",
  "total": "Total",
  "fullBundles": "{count} full bundles",
  "@fullBundles": {"placeholders": {"count": {"type": "int"}}},

  "profiles": "Profiles",
  "activeProfile": "Active",
  "addProfile": "Add profile",
  "editProfile": "Edit profile",
  "newProfile": "New profile",
  "deleteProfile": "Delete profile",
  "profileName": "Profile name",
  "currencyCode": "Currency code",
  "denominations": "Denominations",
  "addDenomination": "Add denomination",
  "dragToReorder": "Drag to reorder",

  "notes": "notes",
  "bundle": "bundle",
  "bundles": "bundles",
  "bundleSummary": "{bundles} bundle + {remainder}",
  "@bundleSummary": {"placeholders": {"bundles": {"type": "int"}, "remainder": {"type": "int"}}},
  "incompleteBundleSummary": "{count} notes",
  "@incompleteBundleSummary": {"placeholders": {"count": {"type": "int"}}},

  "addExtraDenomination": "Add denomination",
  "extraDenominationHint": "Emergency — adds to current session only",
  "denominationValue": "Value",
  "denominationLabel": "Label (optional)",

  "reset": "Reset",
  "resetTitle": "Reset profile",
  "resetConfirm": "All entered values will be cleared. Emergency denominations you added will remain.",
  "save": "Save",
  "cancel": "Cancel",
  "delete": "Delete",
  "confirm": "Confirm",

  "saveToHistory": "Save to history",
  "noteOptional": "Note (optional)",
  "savedToHistory": "Saved to history",

  "history": "History",
  "historyEmpty": "No history yet",
  "historyEmptyHint": "Save a session to see it here",
  "deleteEntry": "Delete entry",
  "deleteEntryConfirm": "Delete this history entry?",

  "share": "Share",
  "shareTitle": "Money Counter",
  "fullBundlesCount": "Full bundles: {count}",
  "@fullBundlesCount": {"placeholders": {"count": {"type": "int"}}},

  "settings": "Settings",
  "language": "Language",
  "languageSubtitle": "App display language",
  "about": "About",
  "version": "Version",

  "denominationGroup": "Denomination subtotal: {amount} {currency}",
  "@denominationGroup": {"placeholders": {"amount": {"type": "String"}, "currency": {"type": "String"}}},

  "notesInputHint": "notes",
  "valueMustBePositive": "Value must be greater than zero",
  "nameRequired": "Name is required",
  "currencyRequired": "Currency code is required",
  "atLeastOneDenomination": "Add at least one denomination",
  "denominationAlreadyExists": "This denomination already exists in the profile",

  "defaultProfileEGP": "Egyptian Pound",
  "defaultProfileUSD": "US Dollar"
}
```

---

## ملف app_ar.arb — النصوص العربية

```json
{
  "@@locale": "ar",

  "appTitle": "عداد النقود",
  "total": "الإجمالي",
  "fullBundles": "{count} رزمة كاملة",
  "@fullBundles": {"placeholders": {"count": {"type": "int"}}},

  "profiles": "البروفايلات",
  "activeProfile": "نشط",
  "addProfile": "إضافة بروفايل",
  "editProfile": "تعديل البروفايل",
  "newProfile": "بروفايل جديد",
  "deleteProfile": "حذف البروفايل",
  "profileName": "اسم البروفايل",
  "currencyCode": "رمز العملة",
  "denominations": "الفئات",
  "addDenomination": "إضافة فئة",
  "dragToReorder": "اسحب لإعادة الترتيب",

  "notes": "ورقة",
  "bundle": "رزمة",
  "bundles": "رزم",
  "bundleSummary": "{bundles} رزمة + {remainder} ورقة",
  "@bundleSummary": {"placeholders": {"bundles": {"type": "int"}, "remainder": {"type": "int"}}},
  "incompleteBundleSummary": "{count} ورقة",
  "@incompleteBundleSummary": {"placeholders": {"count": {"type": "int"}}},

  "addExtraDenomination": "إضافة فئة",
  "extraDenominationHint": "طارئة — تُضاف للجلسة الحالية فقط",
  "denominationValue": "القيمة",
  "denominationLabel": "الاسم (اختياري)",

  "reset": "إعادة ضبط",
  "resetTitle": "إعادة ضبط البروفايل",
  "resetConfirm": "سيتم مسح جميع الأرقام المدخلة. الفئات الطارئة التي أضفتها ستبقى موجودة.",
  "save": "حفظ",
  "cancel": "إلغاء",
  "delete": "حذف",
  "confirm": "تأكيد",

  "saveToHistory": "حفظ في السجل",
  "noteOptional": "ملاحظة (اختياري)",
  "savedToHistory": "تم الحفظ في السجل",

  "history": "السجل",
  "historyEmpty": "لا يوجد سجل بعد",
  "historyEmptyHint": "احفظ جلسة لتظهر هنا",
  "deleteEntry": "حذف السجل",
  "deleteEntryConfirm": "هل تريد حذف هذا السجل؟",

  "share": "مشاركة",
  "shareTitle": "عداد النقود",
  "fullBundlesCount": "الرزم الكاملة: {count}",
  "@fullBundlesCount": {"placeholders": {"count": {"type": "int"}}},

  "settings": "الإعدادات",
  "language": "اللغة",
  "languageSubtitle": "لغة عرض التطبيق",
  "about": "حول التطبيق",
  "version": "الإصدار",

  "denominationGroup": "مجموع الفئة: {amount} {currency}",
  "@denominationGroup": {"placeholders": {"amount": {"type": "String"}, "currency": {"type": "String"}}},

  "notesInputHint": "أوراق",
  "valueMustBePositive": "القيمة يجب أن تكون أكبر من صفر",
  "nameRequired": "الاسم مطلوب",
  "currencyRequired": "رمز العملة مطلوب",
  "atLeastOneDenomination": "أضف فئة واحدة على الأقل",
  "denominationAlreadyExists": "هذه الفئة موجودة مسبقاً في البروفايل",

  "defaultProfileEGP": "جنيه مصري",
  "defaultProfileUSD": "دولار أمريكي"
}
```

---

## إدارة اللغة في AppProvider

```dart
// في AppProvider:
Locale _locale = const Locale('en');  // افتراضي

Locale get locale => _locale;

void setLocale(Locale locale) {
  _locale = locale;
  _prefs.setString('locale', locale.languageCode);
  notifyListeners();
}

void _loadLocale() {
  final code = _prefs.getString('locale') ?? 'en';
  _locale = Locale(code);
}
```

## تطبيق اللغة في main.dart

```dart
MaterialApp(
  locale: provider.locale,
  supportedLocales: const [
    Locale('en'),
    Locale('ar'),
  ],
  localizationsDelegates: const [
    AppLocalizations.delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
  ],
  // RTL/LTR تلقائي بناءً على اللغة المختارة
  // لا حاجة لـ Directionality wrapper يدوي
)
```

## استخدام النصوص في الواجهة

```dart
// بدلاً من:
Text('الإجمالي')

// نستخدم:
Text(AppLocalizations.of(context)!.total)
// أو الاختصار:
Text(context.l10n.total)

// extension مساعد:
extension L10nExt on BuildContext {
  AppLocalizations get l10n => AppLocalizations.of(this)!;
}
```

---

## سلوك RTL/LTR

| اللغة | اتجاه النص | موضع الأيقونات | موضع زر الرجوع |
|-------|-----------|---------------|----------------|
| English | LTR | يسار | يسار |
| العربية | RTL | يمين | يمين |

Flutter يتعامل مع هذا **تلقائياً** عبر `Directionality` المرتبط بـ `locale` — لا حاجة لكود إضافي في كل Widget.

---

## شاشة اختيار اللغة (في الإعدادات)

```dart
// قائمة اللغات المدعومة
const supportedLanguages = [
  (code: 'en', name: 'English',  nativeName: 'English',  flag: '🇺🇸'),
  (code: 'ar', name: 'Arabic',   nativeName: 'العربية',  flag: '🇸🇦'),
];
```

### السلوك عند التغيير:
1. المستخدم يختار اللغة
2. `provider.setLocale(Locale('ar'))` يُستدعى
3. `MaterialApp` يُعيد البناء بالـ `locale` الجديدة
4. الاتجاه (RTL/LTR) يتغير تلقائياً
5. جميع النصوص تتغير فوراً **بدون إعادة تشغيل**
6. يُحفظ الاختيار في SharedPreferences

---

## ما لا يتأثر باللغة

- **أسماء البروفايلات**: يُدخلها المستخدم، تُحفظ كما هي
- **أسماء الفئات**: يُدخلها المستخدم، تُحفظ كما هي
- **صيغة المشاركة** `NxDxC`: ثابتة في كل اللغات (أرقام فقط)
- **التواريخ**: تتبع تنسيق اللغة المختارة (en: MM/DD/YYYY, ar: DD/MM/YYYY)
