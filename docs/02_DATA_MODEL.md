# نموذج البيانات — عداد النقود

**الإصدار:** 1.0  
**التاريخ:** 2026-06-30

---

## الكيانات الأساسية

### 1. `Denomination` — الفئة النقدية
```dart
class Denomination {
  double value;   // القيمة الرقمية (200.0)
  String label;   // النص المعروض ("200 جنيه")
}
```

### 2. `Profile` — البروفايل
```dart
class Profile {
  String id;                    // معرّف فريد
  String name;                  // "جنيه مصري"
  String currency;              // "EGP"
  List<Denomination> denominations; // الفئات المرتبة تنازلياً
}
```

### 3. `Bundle` — الرزمة (وحدة الإدخال)
```dart
class Bundle {
  double denominationValue;  // 200.0
  String label;              // "200 جنيه"
  int noteCount;             // عدد الأوراق (0–999)
}
```

**قواعد الرزمة:**
- `noteCount == 100` → رزمة كاملة
- `noteCount < 100 && noteCount > 0` → رزمة ناقصة
- `noteCount > 100` → مسموح (رزم متعددة في خانة واحدة مثلاً 250 ورقة)
- `مجموع الرزمة = denominationValue × noteCount`

### 4. `DenominationGroup` — مجموعة الفئة
```dart
class DenominationGroup {
  Denomination denomination;  // الفئة
  List<Bundle> bundles;       // قائمة الرزم لهذه الفئة
  bool isExtra;               // هل أُضيفت كفئة طارئة؟
}
```

**قاعدة:** كل ضغطة على `+` تضيف `Bundle` جديد في نفس المجموعة.

### 5. `ProfileSession` — جلسة البروفايل
```dart
class ProfileSession {
  String profileId;
  List<DenominationGroup> groups;  // الفئات + رزمها
  DateTime lastModified;
}
```

**تُحفظ في SharedPreferences وتبقى بعد إغلاق التطبيق.**

### 6. `HistoryEntry` — سجل العملية
```dart
class HistoryEntry {
  String id;
  String profileId;
  String profileName;
  String currency;
  DateTime timestamp;
  List<DenominationGroup> groups;  // نسخة مجمّدة
  double total;
  String? note;
  String shareText;  // النص المُصدَّر جاهز
}
```

---

## العلاقات بين الكيانات

```
Profile (1) ──────────── (1) ProfileSession
    │                            │
    │                            └── List<DenominationGroup>
    │                                      │
    └── List<Denomination>                 └── List<Bundle>
                                                    │
                                                    └── noteCount (int)

HistoryEntry ──── snapshot من ProfileSession
```

---

## صيغة التصدير والمشاركة

### الخوارزمية:
```
لكل DenominationGroup:
  لكل Bundle في المجموعة:
    إذا noteCount > 0:
      إذا noteCount % 100 == 0:
        أضف سطر: "{noteCount/100}x{denomination}x100"
      وإلا:
        أضف الرزم الكاملة إن وجدت: "{floor(noteCount/100)}x{denomination}x100"
        أضف الباقي: "1x{denomination}x{noteCount % 100}"
```

### مثال:
Bundle: denomination=200, noteCount=250
```
2x200x100   ← رزمتان كاملتان
1x200x50    ← رزمة ناقصة (50 ورقة)
```

Bundle: denomination=100, noteCount=100
```
1x100x100   ← رزمة كاملة
```

### النص الكامل للمشاركة:
```
💰 عداد النقود — جنيه مصري (EGP)
📅 30/06/2026 14:35
──────────────────
5x200x100
1x200x70
3x100x100
1x100x20
──────────────────
💵 الإجمالي: 146,000 EGP
📦 عدد الرزم الكاملة: 9
```

---

## التخزين المحلي (SharedPreferences)

| المفتاح | النوع | المحتوى |
|---------|-------|---------|
| `profiles` | JSON String | `List<Profile>` |
| `sessions` | JSON String | `Map<profileId, ProfileSession>` |
| `history` | JSON String | `List<HistoryEntry>` |
| `activeProfileId` | String | معرّف البروفايل النشط |

---

## حالات الحافة

| الحالة | السلوك |
|--------|--------|
| `noteCount = 0` | لا يُدرج في التصدير، لا يؤثر على الإجمالي |
| فئة طارئة | تظهر في آخر القائمة، علامة مميزة، لا تُحذف بـ Reset |
| بروفايل محذوف له session | تُحذف الـ session معه |
| قيمة فئة مكررة | تُجمع في نفس المجموعة |
