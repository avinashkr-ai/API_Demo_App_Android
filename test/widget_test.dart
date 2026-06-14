import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:api_demo_app/features/home/home_screen.dart';

void main() {
  testWidgets('Home screen shows the six API sections', (tester) async {
    // Use a tall surface so all six grid cards lay out at once.
    tester.view.physicalSize = const Size(1200, 2400);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(const MaterialApp(home: HomeScreen()));

    expect(find.text('Photos'), findsOneWidget);
    expect(find.text('Albums'), findsOneWidget);
    expect(find.text('Posts'), findsOneWidget);
    expect(find.text('Users'), findsOneWidget);
    expect(find.text('Comments'), findsOneWidget);
    expect(find.text('Todos'), findsOneWidget);
  });
}
