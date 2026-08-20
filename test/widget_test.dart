// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'dart:io';
import 'package:flutter_test/flutter_test.dart';
import 'package:photonic_browser/functions.dart';

void main() {
  test('Check metadata', () async {
    List<PhotonicItem> items = await fetchItems(Directory("C:\\Users\\valen\\Downloads"));
    print(items.first.dateTime.toString());
    print("${items.first.latitude},${items.first.longitude}");
  });
}
