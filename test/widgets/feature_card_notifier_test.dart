import 'package:feature_notifier/feature_notifier.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() async {
  setUpAll(() async {
    WidgetsFlutterBinding.ensureInitialized();
  });
  testWidgets("Test Feature Card Notifier Widget", (WidgetTester tester) async {
    ///Arrange widget for test
    final FeatureCardNotifier featureCardNotifier = FeatureCardNotifier(
      title: const Text("Test Title"),
      hasButton: true,
      description: const Text("Test Description"),
      featureKey: 'test_feature_key',
      onClose: () {},
      onTapCard: () {},
      showIcon: true,
      onTapButton: () {},
    );

    //act on arrangement
    await tester.pumpWidget(MaterialApp(home: featureCardNotifier));

    //assert result
    expect(find.text("Test Description"), findsOneWidget);
  });
}
