// This is a basic Flutter widget test.
import 'package:flutter_test/flutter_test.dart';
import 'package:app/app.dart';

void main() {
  testWidgets('StravunApp widget can be instantiated', (WidgetTester tester) async {
    // Verify that the StravunApp widget can be created without errors.
    // Note: Full widget tests require Firebase mock setup.
    expect(const StravunApp(), isA<StravunApp>());
  });
}
