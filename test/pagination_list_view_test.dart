import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pagination_list_view/pagination_list_view.dart';

void main() {
  group('PaginationListView Tests', () {
    testWidgets('renders list items correctly', (WidgetTester tester) async {
      final items = ['Item 1', 'Item 2', 'Item 3'];
      bool refreshCalled = false;
      bool loadMoreCalled = false;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: PaginationListView<String>(
              data: items,
              onRefresh: () async {
                refreshCalled = true;
              },
              onLoadMore: () {
                loadMoreCalled = true;
              },
              isLoading: false,
              itemBuilder: (item) => Text(item),
            ),
          ),
        ),
      );

      // Verify all items are rendered
      expect(find.text('Item 1'), findsOneWidget);
      expect(find.text('Item 2'), findsOneWidget);
      expect(find.text('Item 3'), findsOneWidget);
    });

    testWidgets('shows loading indicator when isLoadingMore is true',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: PaginationListView<String>(
              data: ['Item 1'],
              onRefresh: () async {},
              onLoadMore: () {},
              isLoading: true,
              isLoadingMore: true,
              itemBuilder: (item) => Text(item),
            ),
          ),
        ),
      );

      // Verify loading indicator is shown
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });

    testWidgets('shows empty widget when data is empty',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: PaginationListView<String>(
              data: [],
              onRefresh: () async {},
              onLoadMore: () {},
              isLoading: false,
              emptyWidget: const Text('No items'),
              itemBuilder: (item) => Text(item),
            ),
          ),
        ),
      );

      // Verify empty widget is shown
      expect(find.text('No items'), findsOneWidget);
    });

    testWidgets('triggers onRefresh when pulled down',
        (WidgetTester tester) async {
      bool refreshCalled = false;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: PaginationListView<String>(
              data: ['Item 1'],
              onRefresh: () async {
                refreshCalled = true;
              },
              onLoadMore: () {},
              isLoading: false,
              itemBuilder: (item) => Text(item),
            ),
          ),
        ),
      );

      // Simulate pull to refresh
      await tester.drag(find.text('Item 1'), const Offset(0, 300));
      await tester.pump();

      // Give time for the refresh to trigger
      await tester.pump(const Duration(milliseconds: 100));

      expect(refreshCalled, isTrue);
    });

    testWidgets('custom loading indicator is used when provided',
        (WidgetTester tester) async {
      const customIndicator = Text('Loading...');

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: PaginationListView<String>(
              data: ['Item 1'],
              onRefresh: () async {},
              onLoadMore: () {},
              isLoading: true,
              isLoadingMore: true,
              loadingIndicator: customIndicator,
              itemBuilder: (item) => Text(item),
            ),
          ),
        ),
      );

      // Verify custom loading indicator is shown
      expect(find.text('Loading...'), findsOneWidget);
      expect(find.byType(CircularProgressIndicator), findsNothing);
    });
  });
}
