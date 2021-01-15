import 'package:cupertino_listview/internal/delegate/cupertino_sliver_builder_delegate.dart';
import 'package:cupertino_listview/internal/delegate/cupertino_sliver_child_delegate.dart';
import 'package:flutter/material.dart';

class CupertinoListView extends StatefulWidget {
  final CupertinoListDelegate _delegate;

  CupertinoListView._({CupertinoListDelegate delegate}) : _delegate = delegate;

  factory CupertinoListView.builder({
    int sectionCount,
    SectionBuilder sectionBuilder,
    SectionChildBuilder childBuilder,
    SectionItemCount itemInSectionCount,
    ChildSeparatorBuilder separatorBuilder,
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
    );
  }

  @override
  _CupertinoListViewState createState() => _CupertinoListViewState();
}

class _CupertinoListViewState extends State<CupertinoListView> {
  ScrollController _scrollController;

  Widget _header;
  GlobalKey listKey;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _scrollController.addListener(_onScrollChange);
    _header = SizedBox();
    listKey = GlobalKey(debugLabel: "_CupertinoListViewState::listView widget key");
  }

  @override
  void didUpdateWidget(covariant CupertinoListView oldWidget) {
    super.didUpdateWidget(oldWidget);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onScrollChange() {
    setState(() {
      _header = IgnorePointer(
        ignoring: true,
        child: this.widget._delegate.buildSectionOverlay(listKey, context, _scrollController.offset),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        _HookableListView(
          listKey: listKey,
          controller: _scrollController,
          delegate: this.widget._delegate,
        ),
        Positioned(child: _header),
      ],
    );
  }
}


class _HookableListView extends BoxScrollView {
  final GlobalKey listKey;
  final CupertinoListDelegate delegate;


  _HookableListView({this.listKey, this.delegate, ScrollController controller}):super(
    controller: controller,
  );
  @override
  Widget buildChildLayout(BuildContext context) {
    return SliverList(delegate: this.delegate, key: this.listKey,);
  }

}