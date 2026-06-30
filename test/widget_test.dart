import 'package:flutter_test/flutter_test.dart';
import 'package:money_counter/main.dart';
import 'package:money_counter/providers/app_provider.dart';
import 'package:provider/provider.dart';

void main() {
  testWidgets('App builds without errors', (WidgetTester tester) async {
    final provider = AppProvider();
    await provider.init();
    await tester.pumpWidget(
      ChangeNotifierProvider.value(
        value: provider,
        child: const MoneyCounterApp(),
      ),
    );
    expect(find.byType(MoneyCounterApp), findsOneWidget);
  });
}
