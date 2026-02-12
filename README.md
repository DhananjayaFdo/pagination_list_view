# pagination_list_view

A customizable Flutter ListView widget with built-in pagination support, including pull-to-refresh and infinite scrolling capabilities.

## Features

✨ **Pull-to-Refresh**: Built-in RefreshIndicator for easy data refresh  
♾️ **Infinite Scrolling**: Automatically loads more data when reaching the bottom  
🎨 **Customizable**: Flexible styling and behavior options  
📱 **Platform-aware**: Adapts scroll physics to iOS/Android conventions  
🔄 **Loading States**: Automatic handling of loading indicators  
⚡ **Performance**: Prevents multiple simultaneous load requests  

## Installation

Add this to your package's `pubspec.yaml` file:

```yaml
dependencies:
  pagination_list_view: ^1.0.0
```

Then run:

```bash
flutter pub get
```

## Usage

### Basic Example

```dart
import 'package:pagination_list_view/pagination_list_view.dart';

PaginationListView<User>(
  data: users,
  onRefresh: () async {
    // Fetch fresh data
    await fetchUsers();
  },
  onLoadMore: () {
    // Load more data
    loadMoreUsers();
  },
  isLoading: isLoadingData,
  isLoadingMore: isLoadingMore,
  isAllLoaded: hasReachedEnd,
  itemBuilder: (user) => UserCard(user: user),
)
```

### With BLoC/Cubit

```dart
BlocBuilder<UserBloc, UserState>(
  builder: (context, state) {
    return PaginationListView<User>(
      data: state.users,
      onRefresh: () async {
        context.read<UserBloc>().add(RefreshUsers());
      },
      onLoadMore: () {
        context.read<UserBloc>().add(LoadMoreUsers());
      },
      isLoading: state.status == Status.loading,
      isLoadingMore: state.status == Status.loading && state.users.isNotEmpty,
      isAllLoaded: state.hasReachedEnd,
      itemBuilder: (user) => UserListTile(user: user),
    );
  },
)
```

### With Empty State

```dart
PaginationListView<Product>(
  data: products,
  onRefresh: () async => fetchProducts(),
  onLoadMore: () => loadMoreProducts(),
  isLoading: isLoading,
  isAllLoaded: allLoaded,
  emptyWidget: Center(
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(Icons.inbox, size: 64, color: Colors.grey),
        SizedBox(height: 16),
        Text('No products found'),
      ],
    ),
  ),
  itemBuilder: (product) => ProductCard(product: product),
)
```

### Custom Styling

```dart
PaginationListView<Item>(
  data: items,
  onRefresh: () async => refresh(),
  onLoadMore: () => loadMore(),
  isLoading: loading,
  isAllLoaded: allLoaded,
  padding: EdgeInsets.all(16),
  loadMoreThreshold: 100, // Trigger load 100px from bottom
  loadingIndicatorPadding: EdgeInsets.all(20),
  loadingIndicator: CircularProgressIndicator(
    color: Colors.blue,
  ),
  physics: BouncingScrollPhysics(),
  itemBuilder: (item) => ItemCard(item: item),
)
```

## Parameters

| Parameter | Type | Required | Default | Description |
|-----------|------|----------|---------|-------------|
| `data` | `List<T>` | Yes | - | The list of items to display |
| `onRefresh` | `Future<void> Function()` | Yes | - | Callback when pull-to-refresh is triggered |
| `onLoadMore` | `void Function()` | Yes | - | Callback when scrolling near bottom |
| `isLoading` | `bool` | Yes | - | Whether any loading is in progress |
| `itemBuilder` | `Widget Function(T)` | Yes | - | Builder for each list item |
| `isLoadingMore` | `bool` | No | `false` | Shows loading indicator at bottom |
| `isAllLoaded` | `bool` | No | `false` | Prevents further load requests |
| `padding` | `EdgeInsetsGeometry?` | No | Default padding | ListView padding |
| `loadMoreThreshold` | `double` | No | `200.0` | Distance from bottom to trigger load |
| `loadingIndicator` | `Widget?` | No | `CircularProgressIndicator` | Custom loading widget |
| `loadingIndicatorPadding` | `EdgeInsetsGeometry` | No | Vertical 16px | Padding for loading indicator |
| `physics` | `ScrollPhysics?` | No | Platform default | Scroll physics |
| `emptyWidget` | `Widget?` | No | `null` | Widget shown when list is empty |

## How It Works

1. **Scroll Detection**: Monitors scroll position and triggers `onLoadMore` when within `loadMoreThreshold` pixels of the bottom
2. **Load Prevention**: Automatically prevents multiple simultaneous load requests using `isLoading` and `isAllLoaded` flags
3. **State Management**: Works with any state management solution (BLoC, Provider, Riverpod, GetX, etc.)
4. **Platform Adaptation**: Uses appropriate scroll physics for iOS and Android

## Best Practices

### State Management

```dart
// In your BLoC/Cubit
class UserState {
  final List<User> users;
  final bool isLoading;
  final bool hasReachedEnd;
  final int currentPage;
  
  // Use computed property for isLoadingMore
  bool get isLoadingMore => isLoading && users.isNotEmpty;
}
```

### Error Handling

```dart
PaginationListView<User>(
  data: users,
  onRefresh: () async {
    try {
      await fetchUsers();
    } catch (e) {
      // Show error snackbar
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to refresh: $e')),
      );
    }
  },
  onLoadMore: () {
    // Handle errors in your state management
    loadMoreUsers();
  },
  isLoading: isLoading,
  isAllLoaded: hasReachedEnd,
  itemBuilder: (user) => UserCard(user: user),
)
```

## Example App

See the [example](example) directory for a complete working example with BLoC state management.

## Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## Support

If you find this package useful, please give it a ⭐ on [GitHub](https://github.com/yourusername/pagination_list_view)!

For issues and feature requests, visit the [issue tracker](https://github.com/yourusername/pagination_list_view/issues).
