import 'package:flutter/material.dart';
import 'package:pagination_list_view/pagination_list_view.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Pagination ListView Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      home: const PaginationExample(),
    );
  }
}

class PaginationExample extends StatefulWidget {
  const PaginationExample({super.key});

  @override
  State<PaginationExample> createState() => _PaginationExampleState();
}

class _PaginationExampleState extends State<PaginationExample> {
  List<int> items = List.generate(20, (index) => index);
  bool isLoading = false;
  bool hasReachedEnd = false;
  int currentPage = 1;

  Future<void> _onRefresh() async {
    setState(() {
      isLoading = true;
    });

    // Simulate network delay
    await Future.delayed(const Duration(seconds: 1));

    setState(() {
      items = List.generate(20, (index) => index);
      currentPage = 1;
      hasReachedEnd = false;
      isLoading = false;
    });
  }

  void _onLoadMore() {
    if (isLoading || hasReachedEnd) return;

    setState(() {
      isLoading = true;
    });

    // Simulate network delay
    Future.delayed(const Duration(seconds: 1), () {
      if (!mounted) return;

      final newItems = List.generate(
        20,
        (index) => items.length + index,
      );

      setState(() {
        items.addAll(newItems);
        currentPage++;
        isLoading = false;
        // Simulate end of data after 5 pages
        hasReachedEnd = currentPage >= 5;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pagination ListView Example'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: PaginationListView<int>(
        data: items,
        onRefresh: _onRefresh,
        onLoadMore: _onLoadMore,
        isLoading: isLoading,
        isLoadingMore: isLoading && items.isNotEmpty,
        isAllLoaded: hasReachedEnd,
        emptyWidget: const Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.inbox_outlined, size: 64, color: Colors.grey),
              SizedBox(height: 16),
              Text(
                'No items found',
                style: TextStyle(fontSize: 18, color: Colors.grey),
              ),
            ],
          ),
        ),
        itemBuilder: (item) => Card(
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: ListTile(
            leading: CircleAvatar(
              backgroundColor: Theme.of(context).colorScheme.primary,
              child: Text(
                '${item + 1}',
                style: const TextStyle(color: Colors.white),
              ),
            ),
            title: Text('Item ${item + 1}'),
            subtitle: Text('This is item number ${item + 1}'),
            trailing: const Icon(Icons.arrow_forward_ios, size: 16),
            onTap: () {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Tapped on item ${item + 1}'),
                  duration: const Duration(seconds: 1),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
