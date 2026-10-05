import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pantry/main.dart';

void main() {
  Future<void> desktop(WidgetTester tester) async {
    tester.view.physicalSize = const Size(1440, 1025);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    await tester.pumpWidget(const MyApp());
    await tester.pumpAndSettle();
  }

  testWidgets('Login, dashboard, profile and sign out navigation', (
    tester,
  ) async {
    await desktop(tester);
    await tester.tap(find.text('Come on in'));
    await tester.pumpAndSettle();
    expect(find.text('Welcome, Yarema'), findsOneWidget);
    expect(tester.takeException(), isNull);
    await tester.tap(find.text('Profile'));
    await tester.pumpAndSettle();
    expect(find.text('Current password'), findsOneWidget);
    expect(tester.takeException(), isNull);
    await tester.ensureVisible(find.text('Sign Out'));
    await tester.tap(find.text('Sign Out'));
    await tester.pumpAndSettle();
    expect(find.text('Come on in'), findsOneWidget);
  });

  testWidgets('Registration and password recovery screens', (tester) async {
    await desktop(tester);
    await tester.tap(find.text('Create your pantry'));
    await tester.pumpAndSettle();
    expect(find.text('Confirm Password'), findsOneWidget);
    expect(tester.takeException(), isNull);
    await tester.tap(find.text('←  Back to sign in'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Forgot your password?'));
    await tester.pumpAndSettle();
    expect(find.text('Email address'), findsOneWidget);
    await tester.tap(find.text('Send reset link'));
    await tester.pumpAndSettle();
    expect(
      find.text('UI demo: email delivery is not connected.'),
      findsOneWidget,
    );
    expect(tester.takeException(), isNull);
  });

  testWidgets('Pantry and add product dialog can be opened and closed', (
    tester,
  ) async {
    await desktop(tester);
    await tester.tap(find.text('Come on in'));
    await tester.pumpAndSettle();
    await tester.tap(find.widgetWithText(ListTile, 'Pantry'));
    await tester.pumpAndSettle();
    expect(find.text('Buckwheat'), findsOneWidget);
    await tester.tap(find.text('Add Product'));
    await tester.pumpAndSettle();
    expect(find.text('Add new product'), findsOneWidget);
    await tester.tap(find.text('Cancel'));
    await tester.pumpAndSettle();
    expect(find.text('Add new product'), findsNothing);
    expect(tester.takeException(), isNull);
  });

  Future<void> addRice(WidgetTester tester) async {
    await tester.tap(find.text('Add Product'));
    await tester.pumpAndSettle();
    await tester.enterText(
      find.byKey(const ValueKey('product-name')),
      ' Rice ',
    );
    await tester.tap(find.byKey(const ValueKey('product-category')));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Pantry').last);
    await tester.pumpAndSettle();
    await tester.enterText(
      find.byKey(const ValueKey('product-quantity')),
      '2,5',
    );
    await tester.enterText(
      find.byKey(const ValueKey('product-expiry')),
      '31/12/2030',
    );
    await tester.tap(find.text('Save'));
    await tester.pumpAndSettle();
  }

  testWidgets('Entered login name appears on dashboard and profile', (
    tester,
  ) async {
    await desktop(tester);
    await tester.enterText(find.byType(TextField).first, '  Olena  ');
    await tester.tap(find.text('Come on in'));
    await tester.pumpAndSettle();
    expect(find.text('Welcome, Olena'), findsOneWidget);
    await tester.tap(find.text('Profile'));
    await tester.pumpAndSettle();
    expect(find.text('Olena'), findsOneWidget);
    expect(find.text('O'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('Registration also passes the entered name', (tester) async {
    await desktop(tester);
    await tester.tap(find.text('Create your pantry'));
    await tester.pumpAndSettle();
    await tester.enterText(find.byType(TextField).first, 'Taras');
    await tester.tap(find.text('Create my pantry'));
    await tester.pumpAndSettle();
    expect(find.text('Welcome, Taras'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('Products can be added, updated and deleted in one session', (
    tester,
  ) async {
    await desktop(tester);
    await tester.tap(find.text('Come on in'));
    await tester.pumpAndSettle();
    await addRice(tester);
    expect(find.text('Added to Pantry'), findsOneWidget);
    await tester.tap(find.widgetWithText(ListTile, 'Pantry'));
    await tester.pumpAndSettle();
    expect(find.text('Rice'), findsOneWidget);
    expect(find.text('2.5 kg'), findsOneWidget);
    await tester.tap(find.byKey(const ValueKey('increase-5')));
    await tester.pump();
    expect(find.text('3.5 kg'), findsOneWidget);
    for (var i = 0; i < 4; i++) {
      await tester.tap(find.byKey(const ValueKey('decrease-5')));
      await tester.pump();
    }
    expect(find.text('0 kg'), findsOneWidget);
    expect(
      tester
          .widget<IconButton>(find.byKey(const ValueKey('decrease-5')))
          .onPressed,
      isNull,
    );
    await tester.enterText(find.byKey(const ValueKey('pantry-search')), 'rice');
    await tester.pump();
    expect(find.text('Buckwheat'), findsNothing);
    await tester.tap(find.byKey(const ValueKey('delete-5')));
    await tester.pumpAndSettle();
    expect(find.text('Rice'), findsNothing);
    expect(find.text('No products match your search.'), findsOneWidget);
    await tester.enterText(find.byKey(const ValueKey('pantry-search')), '');
    await tester.pump();
    expect(find.text('Buckwheat'), findsOneWidget);
    await tester.tap(find.byKey(const ValueKey('category-Fridge')));
    await tester.pumpAndSettle();
    expect(find.text('Chicken Breast'), findsOneWidget);
    expect(find.text('Buckwheat'), findsNothing);
    expect(tester.takeException(), isNull);
  });

  testWidgets(
    'Invalid product input cannot be saved and Cancel leaves data unchanged',
    (tester) async {
      await desktop(tester);
      await tester.tap(find.text('Come on in'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Add Product'));
      await tester.pumpAndSettle();
      await tester.enterText(
        find.byKey(const ValueKey('product-quantity')),
        '-2',
      );
      await tester.enterText(
        find.byKey(const ValueKey('product-expiry')),
        '31/02/2030',
      );
      await tester.tap(find.text('Save'));
      await tester.pumpAndSettle();
      expect(find.text('Add new product'), findsOneWidget);
      expect(find.text('Enter a product name.'), findsOneWidget);
      expect(find.text('Select a category.'), findsOneWidget);
      expect(find.text('Enter a valid date as DD/MM/YYYY.'), findsOneWidget);
      await tester.tap(find.text('Cancel'));
      await tester.pumpAndSettle();
      await tester.tap(find.widgetWithText(ListTile, 'Pantry'));
      await tester.pumpAndSettle();
      expect(find.byKey(const ValueKey('product-row-5')), findsNothing);
      expect(tester.takeException(), isNull);
    },
  );

  testWidgets(
    'Signing out resets local inventory and next login has its own name',
    (tester) async {
      await desktop(tester);
      await tester.tap(find.text('Come on in'));
      await tester.pumpAndSettle();
      await addRice(tester);
      await tester.tap(find.text('Profile'));
      await tester.pumpAndSettle();
      await tester.ensureVisible(find.text('Sign Out'));
      await tester.tap(find.text('Sign Out'));
      await tester.pumpAndSettle();
      await tester.enterText(find.byType(TextField).first, 'Andrii');
      await tester.tap(find.text('Come on in'));
      await tester.pumpAndSettle();
      expect(find.text('Welcome, Andrii'), findsOneWidget);
      await tester.tap(find.widgetWithText(ListTile, 'Pantry'));
      await tester.pumpAndSettle();
      expect(find.text('Rice'), findsNothing);
      expect(find.text('Buckwheat'), findsOneWidget);
      expect(tester.takeException(), isNull);
    },
  );
}
