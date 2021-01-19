import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/rendering.dart';


/// Define how to build child of CupertinoListView.
abstract class CupertinoListDelegate extends SliverChildDelegate {
  
  /// Number of sections This delegate will layout
  final int sectionCount;
  
  ///Absolute indexes of each section
  List<int> _sectionStarts;
  
  /// Estimation of the Number of items. 
  int _estimatedItemCount;

  CupertinoListDelegate({this.sectionCount}) : super();

  /// Retrieve the number of items for a given section.
  int itemCount({int section});

  int _section(int index) => _sectionStarts.lastIndexWhere((element) => element <= index);

  /// Compute all data needed to build section and items widgets.
  /// Must be called before building widgets.
  void setup() {
    final elementsPerSection = List.generate(sectionCount, (index) => itemCount(section: index));
    _sectionStarts = List<int>.filled(sectionCount, 0);
    for (var i = 1; i < sectionCount; i++) {
      _sectionStarts[i] = 1 + _sectionStarts[i - 1] + elementsPerSection[i - 1];
    }
    _estimatedItemCount = _sectionStarts.last + elementsPerSection.last + 1;
  }

  /// Build an item defined by its [section], its local [index].
  /// [absoluteIndex] define the index in the entire list of items.
  Widget buildItem(BuildContext context, int section, int index, int absoluteIndex);

  /// Build a section header defined by its [section] index.
  /// [absoluteIndex] define the index in the entire list of items.
  Widget buildSection(BuildContext context, int section, int absoluteIndex);

  /// Build the overlay displaying the current section.
  /// Depending of the scroll offset, the retrieved widget may be truncated,
  /// in order to stick with the next section widget.
  Widget buildSectionOverlay(GlobalKey listKey, BuildContext context, double scrollOffset) {

    final listRender = listKey.currentContext.findRenderObject() as RenderSliverMultiBoxAdaptor;

    final firstChild = _findFirstVisibleObject(listRender, scrollOffset);
    if(firstChild == null) {
      return SizedBox();
    }
    final childData = firstChild.parentData as SliverMultiBoxAdaptorParentData;
    final childSection = max(0, _section(childData.index));
    if(childData.index == 0 && scrollOffset <= 0.0) {
      return SizedBox();
    }

    final nextSectionBox = _findSection(listRender, childSection+1);
    if(nextSectionBox == null) {
      return buildSection(context, childSection, _sectionStarts[childSection]);
    }

    var offset = listRender.childScrollOffset(nextSectionBox) - scrollOffset;
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
          child: buildSection(context, childSection, null),
        ),
      ),
    );
  }

  RenderObject _findFirstVisibleObject(RenderSliverMultiBoxAdaptor listRenderObject, double scrollOffset) {
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

  RenderObject _findSection(RenderSliverMultiBoxAdaptor listRenderObject, int section) {
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
    if (index >= _estimatedItemCount || index < 0) {
      return null;
    }
    if (_sectionStarts.contains(index)) {
      final section = _sectionStarts.indexOf(index);
      return buildSection(context, section, index);
    } else {
      var section = _sectionStarts.lastIndexWhere((element) => element < index);
      final childIndex = index - _sectionStarts[section] - 1;
      return buildItem(context, section, childIndex, index);
    }
  }

  @override
  int get estimatedChildCount => _estimatedItemCount;

  @override
  bool shouldRebuild(SliverChildDelegate oldDelegate) {
    if (oldDelegate is CupertinoListDelegate) {
      return sectionCount != oldDelegate.sectionCount ||
          _sectionStarts != oldDelegate._sectionStarts ||
          _estimatedItemCount != oldDelegate._estimatedItemCount;
    }
    return true;
  }
}
