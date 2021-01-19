import 'package:cupertino_listview/src/delegate/cupertino_builder_delegate.dart';
import 'package:cupertino_listview/src/delegate/cupertino_child_list_delegate.dart';
import 'package:cupertino_listview/src/delegate/cupertino_list_delegate.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

/// Display a vertical list of sections, as done by plain list on iOS :
/// the current section remains displayed on top.
///
/// On contrary to [ListView] widget, it is not possible to display items :
/// - in reverse mode
/// - in Horizontal axis
///
/// These restrictions have been set to prevent bad UX design.
class CupertinoListView extends StatefulWidget {
  final CupertinoListDelegate _delegate;

  /// Same as [ListView].scrollController: "control the position to which this scroll view is scrolled".
  final ScrollController controller;

  /// {@macro flutter.rendering.viewport.cacheExtent}
  final double cacheExtent;

  /// Same as [ListView].clipBehavior: "ways to clip a widget's content".
  final Clip clipBehavior;

  /// Same as [ListView].dragStartBehavior: "Determines the way that drag start behavior is handled".
  final DragStartBehavior dragStartBehavior;

  /// Same as [ListView].physics: "How the scroll view should respond to user input".
  final ScrollPhysics physics;

  /// Same as [ListView].restorationId: used "to save and restore the scroll offset of the scrollable".
  final String restorationId;

  /// The amount of space by which to inset the children.
  final EdgeInsets padding;

  /// Defines how the list will dismiss the keyboard automatically.
  final ScrollViewKeyboardDismissBehavior keyboardDismissBehavior;

  CupertinoListView._(
      {@required CupertinoListDelegate delegate,
      this.controller,
      this.cacheExtent,
      this.clipBehavior,
      this.dragStartBehavior,
      this.padding,
      this.restorationId,
      this.physics,
      this.keyboardDismissBehavior})
      : _delegate = delegate,
        assert(delegate != null);

  factory CupertinoListView.builder({
    @required int sectionCount,
    @required SectionBuilder sectionBuilder,
    @required SectionChildBuilder childBuilder,
    @required SectionItemCount itemInSectionCount,
    ChildSeparatorBuilder separatorBuilder,
    ScrollController controller,
    double cacheExtent,
    Clip clipBehavior = Clip.hardEdge,
    DragStartBehavior dragStartBehavior = DragStartBehavior.start,
    ScrollPhysics physics,
    String restorationId,
    EdgeInsets padding,
    ScrollViewKeyboardDismissBehavior keyboardDismissBehavior =
        ScrollViewKeyboardDismissBehavior.manual,
  }) {
    assert(sectionBuilder != null);
    assert(childBuilder != null);
    assert(itemInSectionCount != null);
    assert(sectionCount != null && sectionCount > 0);

    final delegate = CupertinoListBuilderDelegate(
      sectionCount: sectionCount,
      childBuilder: childBuilder,
      sectionBuilder: sectionBuilder,
      itemInSectionCount: itemInSectionCount,
      separatorBuilder: separatorBuilder,
    );
    delegate.setup();
    return CupertinoListView._(
      delegate: delegate,
      controller: controller,
      padding: padding,
      cacheExtent: cacheExtent,
      clipBehavior: clipBehavior,
      dragStartBehavior: dragStartBehavior,
      keyboardDismissBehavior: keyboardDismissBehavior,
      physics: physics,
      restorationId: restorationId,
    );
  }

  factory CupertinoListView({
    @required List<List<Widget>> children,
    ScrollController controller,
    double cacheExtent,
    Clip clipBehavior = Clip.hardEdge,
    DragStartBehavior dragStartBehavior = DragStartBehavior.start,
    ScrollPhysics physics,
    String restorationId,
    EdgeInsets padding,
    ScrollViewKeyboardDismissBehavior keyboardDismissBehavior =
        ScrollViewKeyboardDismissBehavior.manual,
  }) {
    assert(children != null && children.isNotEmpty);
    children.forEach((section) {
      assert(section != null && section.length > 1);
    });

    final delegate = CupertinoChildListDelegate(children: children);
    delegate.setup();
    return CupertinoListView._(
      delegate: delegate,
      controller: controller,
      restorationId: restorationId,
      physics: physics,
      keyboardDismissBehavior: keyboardDismissBehavior,
      dragStartBehavior: dragStartBehavior,
      clipBehavior: clipBehavior,
      cacheExtent: cacheExtent,
      padding: padding,
    );
  }

  @override
  _CupertinoListViewState createState() => _CupertinoListViewState();
}

class _CupertinoListViewState extends State<CupertinoListView> {
  ScrollController _controller;

  _CupertinoListViewState();

  Widget _header;
  GlobalKey _listKey;

  @override
  void initState() {
    super.initState();
    _resetController();
    _header = SizedBox();
    _listKey =
        GlobalKey(debugLabel: '_CupertinoListViewState::listView widget key');
  }

  void _resetController() {
    if (_controller != null) {
      _controller.removeListener(_onScrollChange);
      _controller.dispose();
    }
    _controller = widget.controller ?? ScrollController();
    _controller.addListener(_onScrollChange);
    WidgetsBinding.instance.addPostFrameCallback(_refreshFirstTime);
  }

  void _refreshFirstTime(Duration timestamp) {
    _onScrollChange();
  }

  @override
  void didUpdateWidget(covariant CupertinoListView oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.controller != oldWidget.controller) {
      _resetController();
    }
  }

  @override
  void dispose() {
    _controller.removeListener(_onScrollChange);
    _controller.dispose();
    super.dispose();
  }

  void _onScrollChange() {
    setState(() {
      _header = widget._delegate.buildSectionOverlay(
        _listKey,
        context,
        _controller.offset,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    Widget child = Stack(
      children: [
        _HookableListView(
          listKey: _listKey,
          controller: _controller,
          delegate: widget._delegate,
          cacheExtent: widget.cacheExtent,
          clipBehavior: widget.clipBehavior,
          dragStartBehavior: widget.dragStartBehavior,
          keyboardDismissBehavior: widget.keyboardDismissBehavior,
          physics: widget.physics,
          restorationId: widget.restorationId,
        ),
        Positioned(child: _header),
      ],
    );
    if (widget.padding != null) {
      child = Padding(padding: widget.padding, child: child);
    }
    return child;
  }
}

class _HookableListView extends BoxScrollView {
  final GlobalKey listKey;
  final CupertinoListDelegate delegate;

  _HookableListView({
    @required this.listKey,
    @required this.delegate,
    @required ScrollController controller,
    double cacheExtent,
    Clip clipBehavior = Clip.hardEdge,
    DragStartBehavior dragStartBehavior = DragStartBehavior.start,
    ScrollPhysics physics,
    String restorationId,
    ScrollViewKeyboardDismissBehavior keyboardDismissBehavior =
        ScrollViewKeyboardDismissBehavior.manual,
  }) : super(
          controller: controller,
          cacheExtent: cacheExtent,
          clipBehavior: clipBehavior,
          dragStartBehavior: dragStartBehavior,
          physics: physics,
          restorationId: restorationId,
          scrollDirection: Axis.vertical,
          keyboardDismissBehavior: keyboardDismissBehavior,
        );

  @override
  Widget buildChildLayout(BuildContext context) {
    return SliverList(delegate: delegate, key: listKey);
  }
}
