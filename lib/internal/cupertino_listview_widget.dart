import 'package:cupertino_listview/internal/delegate/cupertino_builder_delegate.dart';
import 'package:cupertino_listview/internal/delegate/cupertino_child_list_delegate.dart';
import 'package:cupertino_listview/internal/delegate/cupertino_list_delegate.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

class CupertinoListView extends StatefulWidget {
  final CupertinoListDelegate _delegate;

  final ScrollController controller;

  final double cacheExtent;
  final Clip clipBehavior;
  final DragStartBehavior dragStartBehavior;
  final ScrollPhysics physics;
  final String restorationId;
  final EdgeInsets padding;
  final ScrollViewKeyboardDismissBehavior keyboardDismissBehavior;

  CupertinoListView._(
      {CupertinoListDelegate delegate,
      this.controller,
      this.cacheExtent,
      this.clipBehavior,
      this.dragStartBehavior,
      this.padding,
      this.restorationId,
      this.physics,
      this.keyboardDismissBehavior})
      : _delegate = delegate;

  factory CupertinoListView.builder({
    int sectionCount,
    SectionBuilder sectionBuilder,
    SectionChildBuilder childBuilder,
    SectionItemCount itemInSectionCount,
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
    print(this.controller.runtimeType);
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
