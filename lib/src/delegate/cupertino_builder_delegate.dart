import 'cupertino_list_delegate.dart';
import 'package:flutter/cupertino.dart';
import 'package:cupertino_listview/src/widget_builder.dart';

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
  Widget buildItem(BuildContext context, IndexPath index) {
    if (_hasSeparator) {
      final builder = index.child.isEven ? childBuilder : separatorBuilder;
      return builder(context, index.copyWith(child: index.child ~/ 2));
    } else {
      return childBuilder(context, index);
    }
  }

  @override
  Widget buildSection(
          BuildContext context, SectionPath index, bool isAbsolute) =>
      sectionBuilder(context, index, isAbsolute);

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
