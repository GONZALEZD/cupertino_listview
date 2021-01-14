import 'package:cupertino_listview/internal/delegate/cupertino_sliver_child_delegate.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/sliver.dart';

typedef SectionBuilder = Widget Function(BuildContext context, int section);
typedef SectionChildBuilder = Widget Function(BuildContext context, int section, int index);
typedef SectionItemCount = int Function(int section);

class CupertinoListBuilderDelegate extends CupertinoListDelegate {

  final SectionBuilder sectionBuilder;
  final SectionChildBuilder childBuilder;
  final SectionItemCount itemInSectionCount;

  CupertinoListBuilderDelegate(
      {int sectionCount, this.sectionBuilder, this.childBuilder, this.itemInSectionCount})
      :super(sectionCount: sectionCount);

  @override
  Widget buildItem(BuildContext context, int section, int index) =>
      this.childBuilder(context, section, index);

  @override
  Widget buildSection(BuildContext context, int section) => this.sectionBuilder(context, section);

  @override
  int itemCount({int section}) => this.itemInSectionCount(section);

  @override
  bool shouldRebuild(covariant SliverChildDelegate oldDelegate) {
    if (oldDelegate is CupertinoListBuilderDelegate) {
      return this.sectionBuilder != oldDelegate.sectionBuilder ||
    this.childBuilder != oldDelegate.childBuilder ||
    this.itemInSectionCount != oldDelegate.itemInSectionCount ||
    super.shouldRebuild(oldDelegate);
    }
    return true;
  }

}