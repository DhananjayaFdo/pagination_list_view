import 'package:flutter/material.dart';

/// A callback type for refresh actions that returns a Future.
typedef RefreshCallback = Future<void> Function();

/// A callback type for load more actions.
typedef LoadMoreCallback = void Function();

/// A customizable ListView with pagination support including pull-to-refresh
/// and infinite scrolling capabilities.
///
/// This widget automatically handles loading states and prevents multiple
/// simultaneous load requests.
///
/// Example:
/// ```dart
/// PaginationListView<User>(
///   data: users,
///   onRefresh: () async => await fetchUsers(),
///   onLoadMore: () => loadMoreUsers(),
///   isLoading: state.isLoading,
///   isAllLoaded: state.hasReachedEnd,
///   item: (user) => UserListTile(user: user),
/// )
/// ```
class PaginationListView<T> extends StatefulWidget {
  /// Callback triggered when user pulls down to refresh.
  final RefreshCallback onRefresh;

  /// Callback triggered when scrolling reaches the bottom.
  final LoadMoreCallback onLoadMore;

  /// Padding for the ListView.
  final EdgeInsetsGeometry? padding;

  /// The list of data items to display.
  final List<T> data;

  /// Builder function to create widgets for each data item.
  final Widget Function(T item) itemBuilder;

  /// Whether the widget is currently loading more items.
  /// Shows a loading indicator at the bottom when true.
  final bool isLoadingMore;

  /// Whether the widget is in any loading state.
  /// Used to prevent multiple simultaneous load requests.
  final bool isLoading;

  /// Whether all available data has been loaded.
  /// Prevents further load more requests when true.
  final bool isAllLoaded;

  /// The distance from the bottom at which to trigger load more.
  /// Defaults to 200 pixels.
  final double loadMoreThreshold;

  /// Custom loading indicator widget.
  /// Defaults to CircularProgressIndicator.
  final Widget? loadingIndicator;

  /// Padding for the loading indicator.
  final EdgeInsetsGeometry loadingIndicatorPadding;

  /// Physics for the ListView scroll behavior.
  /// Defaults to ClampingScrollPhysics on Android and BouncingScrollPhysics on iOS.
  final ScrollPhysics? physics;

  /// Widget to show when the list is empty and not loading.
  final Widget? emptyWidget;

  /// Creates a [PaginationListView].
  ///
  /// The [data], [onRefresh], [onLoadMore], [isLoading], and [itemBuilder]
  /// parameters must not be null.
  const PaginationListView({
    super.key,
    required this.data,
    required this.onRefresh,
    required this.onLoadMore,
    required this.isLoading,
    required this.itemBuilder,
    this.padding,
    this.isLoadingMore = false,
    this.isAllLoaded = false,
    this.loadMoreThreshold = 200.0,
    this.loadingIndicator,
    this.loadingIndicatorPadding = const EdgeInsets.symmetric(vertical: 16.0),
    this.physics,
    this.emptyWidget,
  });

  @override
  State<PaginationListView<T>> createState() => _PaginationListViewState<T>();
}

class _PaginationListViewState<T> extends State<PaginationListView<T>> {
  late ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    _initializeScrollController();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  /// Initializes the scroll controller and adds the scroll listener.
  void _initializeScrollController() {
    _scrollController = ScrollController();
    _scrollController.addListener(_onScroll);
  }

  /// Handles scroll events to trigger load more when needed.
  void _onScroll() {
    if (!_scrollController.hasClients) return;

    final maxScroll = _scrollController.position.maxScrollExtent;
    final currentScroll = _scrollController.position.pixels;
    final threshold = widget.loadMoreThreshold;

    // Trigger load more if:
    // 1. User scrolled close to bottom (within threshold)
    // 2. Not all data is loaded
    // 3. Not currently loading
    if (maxScroll - currentScroll <= threshold &&
        !widget.isAllLoaded &&
        !widget.isLoading) {
      widget.onLoadMore();
    }
  }

  @override
  Widget build(BuildContext context) {
    // Show empty widget if data is empty and not loading
    if (widget.data.isEmpty && !widget.isLoading && widget.emptyWidget != null) {
      return RefreshIndicator(
        onRefresh: widget.onRefresh,
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: SizedBox(
            height: MediaQuery.of(context).size.height * 0.7,
            child: widget.emptyWidget,
          ),
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: widget.onRefresh,
      child: ListView.builder(
        physics: widget.physics ??
            (Theme.of(context).platform == TargetPlatform.iOS
                ? const BouncingScrollPhysics(
                    parent: AlwaysScrollableScrollPhysics(),
                  )
                : const ClampingScrollPhysics(
                    parent: AlwaysScrollableScrollPhysics(),
                  )),
        controller: _scrollController,
        padding: widget.padding ??
            const EdgeInsets.only(
              left: 20.0,
              right: 20.0,
              top: 20.0,
              bottom: 120.0,
            ),
        itemCount: widget.data.length + (widget.isLoadingMore ? 1 : 0),
        itemBuilder: (context, index) {
          // Show loading indicator at the bottom
          if (index == widget.data.length) {
            return Padding(
              padding: widget.loadingIndicatorPadding,
              child: Center(
                child: widget.loadingIndicator ??
                    const CircularProgressIndicator(),
              ),
            );
          }

          return widget.itemBuilder(widget.data[index]);
        },
      ),
    );
  }
}
