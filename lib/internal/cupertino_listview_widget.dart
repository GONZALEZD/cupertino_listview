import 'package:cupertino_listview/internal/delegate/cupertino_builder_delegate.dart';
import 'package:cupertino_listview/internal/delegate/cupertino_child_list_delegate.dart';
import 'package:cupertino_listview/internal/delegate/cupertino_list_delegate.dart';
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
    @required ChildSeparatorBuilder separatorBuilder,
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
    assert(separatorBuilder != null);
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
    List<List<Widget>> children,
    ScrollController controller,
    double cacheExtent,
    Clip clipBehavior = Clip.hardEdge,
    bool primary,
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
  ScrollController controller;

  _CupertinoListViewState();

  Widget _header;
  GlobalKey listKey;

  @override
  void initState() {
    super.initState();
    _resetController();
    _header = SizedBox();
    listKey = GlobalKey(debugLabel: "_CupertinoListViewState::listView widget key");
  }

  void _resetController() {
    if (this.controller != null) {
      this.controller.removeListener(_onScrollChange);
      this.controller.dispose();
    }
    this.controller = this.widget.controller ?? ScrollController();
    this.controller.addListener(_onScrollChange);
    WidgetsBinding.instance.addPostFrameCallback(_refreshFirstTime);
  }

  void _refreshFirstTime(Duration timestamp) {
    _onScrollChange();
  }

  @override
  void didUpdateWidget(covariant CupertinoListView oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (this.widget.controller != oldWidget.controller) {
      _resetController();
    }
  }

  @override
  void dispose() {
    this.controller.removeListener(_onScrollChange);
    this.controller.dispose();
    super.dispose();
  }

  void _onScrollChange() {
    setState(() {
      _header = this.widget._delegate.buildSectionOverlay(
        listKey,
        context,
        this.controller.offset,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    Widget widget = Stack(
      children: [
        _HookableListView(
          listKey: listKey,
          controller: controller,
          delegate: this.widget._delegate,
          cacheExtent: this.widget.cacheExtent,
          clipBehavior: this.widget.clipBehavior,
          dragStartBehavior: this.widget.dragStartBehavior,
          keyboardDismissBehavior: this.widget.keyboardDismissBehavior,
          physics: this.widget.physics,
          restorationId: this.widget.restorationId,
        ),
        Positioned(child: _header),
      ],
    );
    if(this.widget.padding != null) {
      widget = Padding(padding: this.widget.padding, child: widget);
    }
    return widget;
  }
}

class _HookableListView extends BoxScrollView {
  final GlobalKey listKey;
  final CupertinoListDelegate delegate;

  _HookableListView({
    this.listKey,
    this.delegate,
    ScrollController controller,
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
    return SliverList(delegate: this.delegate, key: this.listKey);
  }
}
