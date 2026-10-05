import 'package:flutter_test/flutter_test.dart';
import 'package:satsa_mobile/main.dart';

void main() {
  testWidgets('App initializes splash screen with version banner', (WidgetTester tester) async {
    await tester.pumpWidget(const SATSAApp());

    expect(find.text('SAT-SA'), findsOneWidget);
    expect(find.text('Offline Supervisory Analytics'), findsOneWidget);
    expect(find.textContaining('BUILD VERSION'), findsOneWidget);
  });
}
