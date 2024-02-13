import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:task_master/views/AddTodo.dart';

void main() {
  testWidgets("add a todo", (WidgetTester tester) async {
    // find widgets from views
    final addTitle = find.byKey(ValueKey("addTitle"));
    final addDescription = find.byKey(ValueKey("addDescription"));
    final addButton = find.byKey(ValueKey("addButton"));

    //execute the test
    await tester.pumpWidget(MaterialApp(home: AddTodoPage()));
    await tester.enterText(addTitle, "Make a test widget title");
    await tester.enterText(addDescription, "Make a test widget description");
    await tester.tap(addButton);
    await tester.pump();

    // check outputs
    expect(find.text("Make a test widget title"), findsOneWidget);
  });
}