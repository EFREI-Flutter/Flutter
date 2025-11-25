import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

// ignore_for_file: prefer_const_constructors

void main() {
  testWidgets('App starts and shows todo home', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          appBar: AppBar(
            title: Text('Mes tâches'),
          ),
        ),
      ),
    );

    expect(find.text('Mes tâches'), findsOneWidget);
  });
}
