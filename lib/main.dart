import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';
import 'l10n/app_localizations.dart';
import 'providers/app_provider.dart';
import 'screens/home_screen.dart';

export 'l10n/app_localizations.dart';

// Convenience extension — use context.l10n.someKey anywhere
extension L10nExt on BuildContext {
  AppLocalizations get l10n => AppLocalizations.of(this)!;
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

  final provider = AppProvider();
  await provider.init();

  runApp(
    ChangeNotifierProvider.value(
      value: provider,
      child: const MoneyCounterApp(),
    ),
  );
}

class MoneyCounterApp extends StatelessWidget {
  const MoneyCounterApp({super.key});

  @override
  Widget build(BuildContext context) {
    final locale = context.watch<AppProvider>().locale;

    return MaterialApp(
      title: 'Money Counter',
      debugShowCheckedModeBanner: false,

      // ── Localization ─────────────────────────────────────────────────────
      locale: locale,
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
      // RTL/LTR is handled automatically by Flutter based on locale —
      // no manual Directionality wrapper needed.

      // ── Theme ────────────────────────────────────────────────────────────
      theme: _buildTheme(Brightness.light),
      darkTheme: _buildTheme(Brightness.dark),
      themeMode: ThemeMode.system,

      home: const HomeScreen(),
    );
  }

  ThemeData _buildTheme(Brightness brightness) {
    return ThemeData(
      useMaterial3: true,
      brightness: brightness,
      colorSchemeSeed: const Color(0xFF1B6CA8),
      appBarTheme: AppBarTheme(
        centerTitle: true,
        elevation: 0,
        backgroundColor: brightness == Brightness.dark ? null : const Color(0xFF1565C0),
        foregroundColor: Colors.white,
      ),
      cardTheme: CardThemeData(
        elevation: 1,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
      inputDecorationTheme: InputDecorationTheme(
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
        isDense: true,
      ),
    );
  }
}
