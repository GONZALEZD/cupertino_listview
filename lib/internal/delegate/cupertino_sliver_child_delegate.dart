import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/rendering.dart';

abstract class CupertinoListDelegate extends SliverChildDelegate {
  final int sectionCount;
  List<int> _sectionStarts;
  int _estimatedElements;

  CupertinoListDelegate({this.sectionCount}) : super();

  int itemCount({int section});

  void setup() {
    final elementsPerSection = List.generate(sectionCount, (index) => itemCount(section: index));
    _sectionStarts = List<int>.filled(sectionCount, 0);
    for (var i = 1; i < sectionCount; i++) {
      _sectionStarts[i] = 1 + _sectionStarts[i - 1] + elementsPerSection[i - 1];
    }
    _estimatedElements = _sectionStarts.last + elementsPerSection.last + 1;
  }

  Widget buildItem(BuildContext context, int section, int index);

  Widget buildSection(BuildContext context, int section);

  int _section(int index) => _sectionStarts.lastIndexWhere((element) => element <= index);

  Widget buildSectionOverlay(GlobalKey listKey, BuildContext context, double scrollOffset) {

    final listRender = listKey.currentContext.findRenderObject() as RenderSliverMultiBoxAdaptor;

    final firstChild = findFirstVisibleObject(listRender, scrollOffset);
    if(firstChild == null) {
      return SizedBox();
    }
    final childData = firstChild.parentData as SliverMultiBoxAdaptorParentData;
    final childSection = max(0, _section(childData.index));
    if(childData.index == 0 && scrollOffset <= 0.0) {
      return SizedBox();
    }

    final nextSectionBox = findSection(listRender, childSection+1);
    if(nextSectionBox == null) {
      return buildSection(context, childSection);
    }

    double offset = listRender.childScrollOffset(nextSectionBox) - scrollOffset;
    if(offset < 0.0) {
      offset = double.infinity;
    }
    final sectionHeight = nextSectionBox.paintBounds.height;
    return ConstrainedBox(
      constraints: BoxConstraints(maxHeight: min(sectionHeight, offset)),
      child: ClipRect(
        child: OverflowBox(
          maxHeight: sectionHeight,
          alignment: Alignment.bottomCenter,
          child: buildSection(context, childSection),
        ),
      ),
    );
  }

  RenderObject findFirstVisibleObject(RenderSliverMultiBoxAdaptor listRenderObject, double scrollOffset) {
    RenderObject sectionRender;
    SliverMultiBoxAdaptorParentData childData;
    listRenderObject.visitChildren((child) {
      childData = child.parentData as SliverMultiBoxAdaptorParentData;
      if(childData.layoutOffset <= scrollOffset) {
        sectionRender = child;
      }
    });
    return sectionRender;
  }

  RenderObject findSection(RenderSliverMultiBoxAdaptor listRenderObject, int section) {
    RenderObject sectionRender;
    SliverMultiBoxAdaptorParentData childData;
    listRenderObject.visitChildren((child) {
      childData = child.parentData as SliverMultiBoxAdaptorParentData;
      if(_section(childData.index) == section && sectionRender == null) {
        sectionRender = child;
      }
    });
    return sectionRender;
  }

  @override
  Widget build(BuildContext context, int index) {
    if (index >= _estimatedElements || index < 0) {
      return null;
    }
    if (_sectionStarts.contains(index)) {
      final section = _sectionStarts.indexOf(index);
      return buildSection(context, section);
    } else {
      var section = _sectionStarts.lastIndexWhere((element) => element < index);
      final childIndex = index - _sectionStarts[section] - 1;
      return buildItem(context, section, childIndex);
    }
  }

  @override
  int get estimatedChildCount => _estimatedElements;

  @override
  bool shouldRebuild(SliverChildDelegate oldDelegate) {
    if (oldDelegate is CupertinoListDelegate) {
      return this.sectionCount != oldDelegate.sectionCount ||
          _sectionStarts != oldDelegate._sectionStarts ||
          _estimatedElements != oldDelegate._estimatedElements;
    }
    return true;
  }
}
