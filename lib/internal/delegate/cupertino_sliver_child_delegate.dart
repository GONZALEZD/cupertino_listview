import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/rendering.dart';

class _SectionWidget extends StatelessWidget {
  final Widget child;

  _SectionWidget({this.child, Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) => this.child;
}

abstract class CupertinoListDelegate extends SliverChildDelegate {
  final int sectionCount;
  List<int> _sectionStarts;
  int _estimatedElements;
  List<GlobalObjectKey> _sectionKeys;

  CupertinoListDelegate({this.sectionCount}) : super();

  int itemCount({int section});

  void setup() {
    final elementsPerSection = List.generate(sectionCount, (index) => itemCount(section: index));
    _sectionStarts = List<int>.filled(sectionCount, 0);
    for (var i = 1; i < sectionCount; i++) {
      _sectionStarts[i] = 1 + _sectionStarts[i - 1] + elementsPerSection[i - 1];
    }
    _estimatedElements = _sectionStarts.last + elementsPerSection.last + 1;
    _sectionKeys = List.generate(sectionCount, (index) => GlobalObjectKey(index));
  }

  Widget buildItem(BuildContext context, int section, int index);

  Widget buildSection(BuildContext context, int section);

  /// -1 means no section
  int findCurrentSection(BuildContext context, double scrollOffset) {
    return _sectionKeys.lastIndexWhere((key) {
      final child = key.currentContext?.findRenderObject();
      if( child == null) {
        return false;
      }
      final parent = child.parent as RenderSliverMultiBoxAdaptor;
      if(parent != null) {
        final childOffset = parent.childScrollOffset(child);
        return childOffset < scrollOffset;
      }
      return false;
    });
  }

  Widget buildSectionOverlay(BuildContext context, double scrollOffset) {
    int section = findCurrentSection(context, scrollOffset);
    if(section == -1) {
      return SizedBox(height: 0.0,);
    }
    final child = _sectionKeys[section].currentContext?.findRenderObject();
    final parent = child?.parent as RenderSliverMultiBoxAdaptor ?? null;
    final nextChild = _sectionKeys[min(section+1, _sectionKeys.length-1)].currentContext?.findRenderObject();
    if (child == null) {
      return SizedBox();
    }
    double height = child.paintBounds.height;
    if(parent != null && nextChild != null && section < _sectionKeys.length-1) {
      height = parent.childScrollOffset(nextChild) - scrollOffset;
      height = min(height, child.paintBounds.height);
    }

    return SizedBox(
      height: height,
      child: ClipRect(
        child: OverflowBox(
          maxHeight: child.paintBounds.height,
          alignment: Alignment.bottomCenter,
          child: buildSection(context, section),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context, int index) {
    if (index >= _estimatedElements) {
      return null;
    }
    if (_sectionStarts.contains(index)) {
      final section = _sectionStarts.indexOf(index);
      return _SectionWidget(
        key: _sectionKeys[section],
        child: buildSection(context, section),
      );
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
          _sectionKeys != oldDelegate._sectionKeys ||
          _sectionStarts != oldDelegate._sectionStarts ||
    _estimatedElements != oldDelegate._estimatedElements;
    }
    return true;
  }
}