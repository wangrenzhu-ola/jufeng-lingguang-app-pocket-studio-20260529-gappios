import 'package:flutter_test/flutter_test.dart';
import 'package:app_pocket_studio/main.dart';

void main() {
  testWidgets('App Pocket Studio renders product-specific home screen', (tester) async {
    await tester.pumpWidget(const AppPocketStudioApp());
    expect(find.text('App Pocket Studio'), findsOneWidget);
    expect(find.text('Today\'s completion'), findsOneWidget);
    expect(find.text('Next action'), findsOneWidget);
  });
}
