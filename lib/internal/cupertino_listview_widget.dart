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
  }) {
    final delegate = CupertinoListBuilderDelegate(
      sectionCount: sectionCount,
      childBuilder: childBuilder,
      sectionBuilder: sectionBuilder,
      itemInSectionCount: itemInSectionCount,
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
  
  double _scrollOffset;


  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _scrollController.addListener(_onScrollChange);
    _scrollOffset = 0.0;
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onScrollChange() {
    setState(() {
      _scrollOffset = _scrollController.offset;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        ListView.custom(
          controller: _scrollController,
          childrenDelegate: this.widget._delegate,
        ),
        Positioned(child: this.widget._delegate.buildSectionOverlay(context, _scrollOffset))
      ],
    );
  }
}
