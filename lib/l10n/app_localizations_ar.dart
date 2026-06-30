// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Arabic (`ar`).
class AppLocalizationsAr extends AppLocalizations {
  AppLocalizationsAr([String locale = 'ar']) : super(locale);

  @override
  String get appTitle => 'عداد النقود';

  @override
  String get total => 'الإجمالي';

  @override
  String fullBundles(int count) {
    return '$count رزمة كاملة';
  }

  @override
  String partialBundles(int count) {
    return '$count رزمة ناقصة';
  }

  @override
  String get profiles => 'البروفايلات';

  @override
  String get activeProfile => 'نشط';

  @override
  String get addProfile => 'إضافة بروفايل';

  @override
  String get editProfile => 'تعديل البروفايل';

  @override
  String get newProfile => 'بروفايل جديد';

  @override
  String get deleteProfile => 'حذف البروفايل';

  @override
  String confirmDeleteProfile(String name) {
    return 'حذف \"$name\"؟';
  }

  @override
  String get profileName => 'اسم البروفايل';

  @override
  String get currencyCode => 'رمز العملة (مثال: EGP)';

  @override
  String get denominations => 'الفئات';

  @override
  String get addDenomination => 'إضافة فئة';

  @override
  String get dragToReorder => 'اسحب لإعادة الترتيب';

  @override
  String get saveProfile => 'حفظ البروفايل';

  @override
  String bundleSummaryFull(int bundles, int remainder) {
    return '$bundles رزمة + $remainder ورقة';
  }

  @override
  String bundleSummaryOnly(int bundles) {
    return '$bundles رزمة';
  }

  @override
  String notesOnly(int count) {
    return '$count ورقة';
  }

  @override
  String get addExtraDenomination => 'إضافة فئة';

  @override
  String get extraDenominationHint => 'طارئة — تُضاف للجلسة الحالية فقط';

  @override
  String get denominationValue => 'القيمة';

  @override
  String get denominationValueHint => 'مثال: 5';

  @override
  String get denominationLabel => 'الاسم (اختياري)';

  @override
  String get denominationLabelHint => 'مثال: 5 جنيه';

  @override
  String denominationSubtotal(String amount, String currency) {
    return 'مجموع الفئة: $amount $currency';
  }

  @override
  String get reset => 'إعادة ضبط';

  @override
  String get resetTitle => 'إعادة ضبط البروفايل';

  @override
  String get resetConfirm =>
      'سيتم مسح جميع الأرقام المدخلة. الفئات الطارئة ستبقى موجودة.';

  @override
  String get save => 'حفظ';

  @override
  String get cancel => 'إلغاء';

  @override
  String get delete => 'حذف';

  @override
  String get add => 'إضافة';

  @override
  String get saveToHistory => 'حفظ في السجل';

  @override
  String get noteOptional => 'ملاحظة (اختياري)';

  @override
  String get savedToHistory => 'تم الحفظ في السجل';

  @override
  String get history => 'السجل';

  @override
  String get historyEmpty => 'لا يوجد سجل بعد';

  @override
  String get historyEmptyHint => 'احفظ جلسة لتظهر هنا';

  @override
  String get deleteEntry => 'حذف السجل';

  @override
  String get deleteEntryConfirm => 'هل تريد حذف هذا السجل؟';

  @override
  String get share => 'مشاركة';

  @override
  String get shareAutoSaveNote => 'المشاركة تحفظ تلقائياً في السجل';

  @override
  String fullBundlesCount(int count) {
    return 'الرزم الكاملة: $count';
  }

  @override
  String get settings => 'الإعدادات';

  @override
  String get language => 'اللغة';

  @override
  String get languageSubtitle => 'لغة عرض التطبيق';

  @override
  String get about => 'حول التطبيق';

  @override
  String get version => 'الإصدار';

  @override
  String get notesInputHint => 'أوراق';

  @override
  String get valueMustBePositive => 'القيمة يجب أن تكون أكبر من صفر';

  @override
  String get nameRequired => 'الاسم مطلوب';

  @override
  String get currencyRequired => 'رمز العملة مطلوب';

  @override
  String get atLeastOneDenomination => 'أضف فئة واحدة على الأقل';

  @override
  String get denominationAlreadyExists => 'هذه الفئة موجودة مسبقاً';

  @override
  String get defaultProfileEGP => 'جنيه مصري';

  @override
  String get defaultProfileUSD => 'دولار أمريكي';

  @override
  String get extraDenominationTag => 'طارئة';

  @override
  String get switchProfile => 'تغيير البروفايل';

  @override
  String get addProfileShort => '+ بروفايل';

  @override
  String get columnDenomination => 'الفئة';

  @override
  String get columnNotes => 'الأوراق';

  @override
  String get columnBundles => 'الرزم';

  @override
  String get columnAmount => 'المبلغ';

  @override
  String get addDenominationTitle => 'إضافة فئة';

  @override
  String get denominationValueHintShort => 'مثال: 5';

  @override
  String groupSubtotalLabel(String amount, String currency) {
    return 'مجموع الفئة: $amount $currency';
  }

  @override
  String bundleInfoCompact(int bundles) {
    return '($bundles رزمة)';
  }

  @override
  String bundleInfoWithRemainder(int bundles, int remainder) {
    return '($bundles+$remainder)';
  }
}
