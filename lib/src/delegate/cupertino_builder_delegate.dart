import 'cupertino_list_delegate.dart';
import 'package:flutter/cupertino.dart';

/// Section title builder
typedef SectionBuilder = Widget Function(
    BuildContext context, int section, int absoluteIndex);

/// Section children builder
typedef SectionChildBuilder = Widget Function(
    BuildContext context, int section, int element, int absoluteIndex);

/// Separator Builder, used between two section children
typedef ChildSeparatorBuilder = Widget Function(
    BuildContext context, int section, int element, int absoluteIndex);

/// Retrieve the number of items of a given section
typedef SectionItemCount = int Function(int section);

class CupertinoListBuilderDelegate extends CupertinoListDelegate {
  final SectionBuilder sectionBuilder;
  final SectionChildBuilder childBuilder;
  final SectionItemCount itemInSectionCount;
  final ChildSeparatorBuilder separatorBuilder;

  bool get _hasSeparator => separatorBuilder != null;

  CupertinoListBuilderDelegate(
      {int sectionCount,
      this.sectionBuilder,
      this.childBuilder,
      this.itemInSectionCount,
      this.separatorBuilder})
      : super(sectionCount: sectionCount);

  @override
  Widget buildItem(
      BuildContext context, int section, int index, int absoluteIndex) {
    if (_hasSeparator) {
      final builder = index.isEven ? childBuilder : separatorBuilder;
      return builder(context, section, index ~/ 2, absoluteIndex);
    } else {
      return childBuilder(context, section, index, absoluteIndex);
    }
  }

  @override
  Widget buildSection(BuildContext context, int section, int absoluteIndex) =>
      sectionBuilder(context, section, absoluteIndex);

  @override
  int itemCount({int section}) {
    final childCount = itemInSectionCount(section);
    return _hasSeparator ? childCount * 2 - 1 : childCount;
  }

  @override
  bool shouldRebuild(covariant SliverChildDelegate oldDelegate) {
    if (oldDelegate is CupertinoListBuilderDelegate) {
      return sectionBuilder != oldDelegate.sectionBuilder ||
          childBuilder != oldDelegate.childBuilder ||
          itemInSectionCount != oldDelegate.itemInSectionCount ||
          super.shouldRebuild(oldDelegate);
    }
    return true;
  }
}
