# سجل التطوير — عداد النقود

---

## المرحلة 0: التصور والتصميم ✅
**التاريخ:** 2026-06-30  
**الحالة:** مكتملة

### ما تم:
- تحديد متطلبات التطبيق الكاملة مع المستخدم
- توضيح صيغة المشاركة: `[رزم]x[فئة]x[أوراق]`
- تحديد قاعدة: المشاركة = حفظ تلقائي في السجل
- إضافة دعم تعدد اللغات: English (افتراضي) + العربية، يختار المستخدم من الإعدادات
- إنشاء وثائق التصميم: 01–04, 07

### قرارات التصميم:
| القرار | البديل المرفوض | السبب |
|--------|---------------|-------|
| `provider` للحالة | `riverpod`, `bloc` | بساطة + مناسب للحجم |
| `shared_preferences` للتخزين | `hive`, `sqflite` | لا يحتاج DB معقد |
| `share_plus` للمشاركة | `flutter_share` | أكثر صيانة وتوافقاً |
| RTL على مستوى التطبيق | RTL على مستوى Widget | تجربة أفضل وأقل أخطاء |
| حفظ تلقائي عند المشاركة | حفظ يدوي فقط | راحة المستخدم |
| `intl: ^0.20.2` | `^0.19.0` | مطلوب من `flutter_localizations` |

---

## تثبيت Flutter — سجل المحاولات

| المحاولة | الطريقة | النتيجة |
|---------|---------|---------|
| 1 | `winget install Google.Flutter` | فشل — اسم الحزمة غير صحيح |
| 2 | تحميل ZIP إلى `C:\flutter_sdk.zip` | فشل — لا صلاحيات كتابة في C:\ |
| 3 | تحميل ZIP إلى `%USERPROFILE%\flutter_sdk.zip` | نجح ✅ |
| 4 | فك الضغط إلى `%USERPROFILE%\flutter\` | نجح ✅ |

**مسار التثبيت:** `C:\Users\A\flutter\bin`  
**الإصدار:** Flutter 3.32.4 • Dart 3.8.1  

---

## تثبيت Android SDK — سجل المحاولات

| المحاولة | المشكلة | الحل |
|---------|--------|------|
| sdkmanager بدون JAVA_HOME | `ERROR: JAVA_HOME is not set` | تثبيت Microsoft OpenJDK 21 عبر winget |
| قبول الرخص بـ pipe | interactive prompt لا يقبل stdin | استخدام `cmd /c type file \| sdkmanager` |
| تحميل build-tools فشل | network error | إعادة المحاولة — نجح ✅ |

**الحزم المثبتة:**
- `platform-tools` (adb, fastboot)
- `platforms;android-34`
- `platforms;android-35` (حُمّل تلقائياً من Gradle)
- `build-tools;34.0.0`
- `NDK 26.3.11579264` (حُمّل تلقائياً)
- `NDK 27.0.12077973` (مطلوب من plugins)
- `CMake 3.22.1` (مطلوب من NDK)

---

## المرحلة 1: البنية الأساسية ✅
**التاريخ:** 2026-06-30

- `flutter create money_counter_app`
- كتابة: `models.dart`, `app_provider.dart`, `main.dart`
- إضافة الحزم في `pubspec.yaml`
- `flutter pub get` ✅

---

## المرحلة 2: الشاشة الرئيسية ✅
**التاريخ:** 2026-06-30

- `home_screen.dart`: بطاقة الإجمالي، شريط البروفايلات، قائمة الفئات
- `denomination_row_widget.dart`: صف رزمة واحدة (label | input | subtotal | - | +)
- حساب الرزم الكاملة والناقصة في الـ suffix text

---

## المرحلة 3: الأزرار والديالوجات ✅
**التاريخ:** 2026-06-30

- زر `+` (إضافة صف رزمة جديدة لنفس الفئة)
- زر `-` (حذف صف رزمة)
- زر "إضافة فئة طارئة" + Dialog
- زر "إعادة ضبط" + تأكيد
- زر "حفظ" + Dialog ملاحظة

---

## المرحلة 4: الإعدادات والبروفايلات ✅
**التاريخ:** 2026-06-30

- `settings_screen.dart`: Language selector + قائمة البروفايلات
- `ProfileEditorScreen`: إنشاء/تعديل بروفايل مع Drag-to-reorder للفئات
- حذف بروفايل مع تأكيد (محمي من حذف الأخير)

---

## المرحلة 5: السجل والمشاركة ✅
**التاريخ:** 2026-06-30

- `history_screen.dart`: قائمة السجل مع بطاقات expandable
- بناء نص المشاركة بصيغة `NxDxC`
- المشاركة تحفظ تلقائياً في السجل
- حذف من السجل مع تأكيد

---

## المرحلة 6: الترجمة (i18n) ✅
**التاريخ:** 2026-06-30

- `app_en.arb` + `app_ar.arb`: 40+ مفتاح لكل شاشة
- L10nExt على BuildContext: `context.l10n.xxx`
- جميع الشاشات تستخدم l10n — لا نصوص مضمّنة (hardcoded)
- RTL تلقائي عند اختيار العربية

---

## المرحلة 7: البناء والـ APK ✅
**التاريخ:** 2026-06-30

- `flutter build apk --debug` — نجح ✅
- **APK:** `build/app/outputs/flutter-apk/app-debug.apk`
- `flutter analyze` — No issues found ✅
- نشر على GitHub: https://github.com/bahaajobs/money-counter-app — tag `v1.0.0`

---

## المرحلة 8: تقوية الأمان ✅
**التاريخ:** 2026-06-30

### نتائج المراجعة الأمنية:
- ✅ التطبيق offline بالكامل — لا requests، لا بيانات ترسل لأي خادم
- ✅ صفر أذونات خطيرة في AndroidManifest
- ✅ لا أسرار أو credentials مضمّنة في الكود
- ✅ التحقق من المدخلات مضبوط في جميع الحقول
- ⚠️ **نقطة تحسين:** دوال تحميل البيانات بدون `try/catch`

### الإصلاح المُطبَّق في `app_provider.dart`:
الدوال الثلاث `_loadProfiles` و`_loadSessions` و`_loadHistory` أُضيف لها `try/catch`:

| البيانات التالفة | السلوك قبل | السلوك بعد |
|----------------|-----------|-----------|
| profiles | تعطّل عند الفتح | استعادة البروفايلات الافتراضية |
| sessions | تعطّل عند الفتح | بداية جلسة جديدة فارغة |
| history | تعطّل عند الفتح | سجل فارغ |

- tag النسخة الأصلية (قبل الإصلاح): `v1.0.0`
- commit هذا الإصلاح: `v1.0.1`

---

## المرحلة 9: تحسينات UX وهوية التطبيق ✅
**التاريخ:** 2026-06-30

### ما تم:

#### 1. إضافة الكريدت وحقوق الملكية
- قسم "حول التطبيق" في الإعدادات أصبح 3 بنود: الإصدار + فكرة وتصميم + الحقوق
- مفاتيح ARB جديدة: `aboutCredit` و`aboutCopyright` في كلا الملفين EN + AR
- العربية: `فكرة وتصميم: بهاء الدين محمد` / الإنجليزية: `Concept & Design: Bahaa Al-Din Muhammad`

#### 2. أيقونة تطبيق مخصصة (الجيل الأول)
- أُضيفت `flutter_launcher_icons: ^0.14.3` إلى dev_dependencies
- صُمِّمت أيقونة 1024×1024 برمجياً عبر .NET GDI+
- `flutter pub run flutter_launcher_icons` — ولّد جميع كثافات mipmap ✅

- tag هذه التحسينات: `v1.0.2`

---

## المرحلة 10: إصلاح التداخل النهائي + أيقونة جديدة ✅
**التاريخ:** 2026-06-30

### ما تم:

#### 1. إصلاح تداخل الأزرار السفلية (النهائي)
- **المشكلة:** أزرار "إضافة فئة / إعادة ضبط / حفظ" كانت `floatingActionButton` تطفو فوق القائمة
- **المحاولة الأولى (لم تنجح على بعض الأجهزة):** نقلها إلى `bottomNavigationBar` — بعض الأجهزة كانت لا تزال تُظهر z-ordering خاطئاً
- **الإصلاح النهائي:** إدراج الأزرار داخل `Column` نفسه **بعد** الـ `Expanded(ListView)` مباشرةً:

```
Column
├── TotalCard           ← ثابت
├── ProfileSelector     ← ثابت
├── Expanded(ListView)  ← يأخذ كل المساحة المتبقية
└── Container(buttons)  ← ثابت، مستحيل هيكلياً أن يتداخل مع ما فوقه
```

- خلفية الـ Container: `cs.surface` صلبة + خط فاصل علوي
- `SafeArea(top: false)` داخله لاحترام شريط التنقل السفلي

#### 2. أيقونة التطبيق النهائية
- استُبدلت الأيقونة المولّدة برمجياً بتصميم 3D احترافي (رزم نقود isometric)
- الصورة الأصلية: 2074×2048 → قُصّت إلى 1024×1024 (center crop)
- Foreground للـ adaptive icon: نفس الصورة بحجم 80% على خلفية شفافة
- لون الخلفية للـ adaptive icon: `#1E6EB5` (يطابق تدرج الأزرق في الصورة)
- `flutter pub run flutter_launcher_icons` → ولّد جميع الكثافات ✅

- tag هذه التحسينات: `v1.0.3`

---

## المرحلة 11: دعم الـ Landscape + تصحيح اسم المطور ✅
**التاريخ:** 2026-07-01

### ما تم:

#### 1. دعم الاتجاهين Portrait & Landscape
- أُضيف `OrientationBuilder` في body الشاشة الرئيسية
- **Portrait:** تخطيط Column الحالي بدون تغيير
- **Landscape:** تخطيط `Row` بلوحتين:
  - **اللوحة اليسرى** (عرض 180dp): `_TotalCard(compact: true)` + `_ProfileSelector(axis: Axis.vertical)`
  - **اللوحة اليمنى** (Expanded): قائمة الفئات + `_BottomBar`
- أُضيف `compact` parameter لـ `_TotalCard` (حشو وخط أصغر عند `compact: true`)
- أُضيف `axis` parameter لـ `_ProfileSelector` (عمودي في Landscape، أفقي في Portrait)

#### 2. تصحيح اسم المطور بالإنجليزية
- `app_en.arb` → `"aboutCredit": "Concept & Design: BahaaEldin Ghazzaly"`

- رقم الإصدار: `1.0.4+5`
- tag: `v1.0.4`

---

## مشكلات موثقة وحلولها

| # | المشكلة | الحل |
|---|---------|------|
| 1 | `intl: ^0.19.0` يتعارض مع `flutter_localizations` | تغيير إلى `^0.20.2` |
| 2 | `import 'package:flutter_gen/...'` لا يعمل | الملفات تُولَّد في `lib/l10n/` → استخدام `import 'l10n/app_localizations.dart'` |
| 3 | `widget_test.dart` يرجع إلى `MyApp` | إعادة كتابته ليستخدم `MoneyCounterApp` مع Provider |
| 4 | `.withOpacity()` deprecated في Flutter 3.32.4 | استبدال بـ `.withValues(alpha: x)` في جميع الشاشات |
| 5 | import غير مستخدم `dart:convert` في models.dart | حذفه |
| 6 | import غير مستخدم `flutter/foundation.dart` في provider | حذفه |
| 7 | متغير `cs` غير مستخدم في `_LanguageSelector` | حذفه |
| 8 | `Row` ليس `const` في history_screen | إضافة `const` |
| 9 | `JAVA_HOME` غير مضبوط → sdkmanager يفشل | `winget install Microsoft.OpenJDK.21` |
| 10 | قبول رخص SDK interactively | `cmd /c type yes_file.txt \| sdkmanager --licenses` |
| 11 | plugins تتطلب NDK 27 لكن build.gradle.kts يستخدم `flutter.ndkVersion` (26) | تثبيت `ndkVersion = "27.0.12077973"` في build.gradle.kts |
| 12 | تلف بيانات SharedPreferences يتسبب في تعطّل التطبيق | إضافة `try/catch` في `_loadProfiles`, `_loadSessions`, `_loadHistory` |
| 13 | الأزرار السفلية (FAB) تتداخل مع محتوى القائمة — المحاولة الأولى | نقلها إلى `bottomNavigationBar` — لم تُحل على جميع الأجهزة بسبب z-ordering |
| 14 | التداخل استمر مع `bottomNavigationBar` على بعض الأجهزة | نقل الأزرار داخل `Column` بعد `Expanded(ListView)` — حل هيكلي لا يعتمد على z-ordering |
| 15 | build artifacts قديمة تمنع ظهور الإصلاح | `flutter clean` قبل إعادة البناء عند الاشتباه بمشكلة cache |
| 16 | `_TotalCard` بدون `compact` يستهلك مساحة كبيرة في Landscape | إضافة `compact: true` تُقلِّص الحشو والخط تلقائياً |
| 17 | `_ProfileSelector` أفقي لا يناسب اللوحة الجانبية الضيقة | إضافة `axis: Axis.vertical` لعرض Chips عمودياً في Landscape |
