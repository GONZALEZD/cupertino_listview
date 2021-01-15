import 'package:cupertino_listview/internal/delegate/cupertino_sliver_child_delegate.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/sliver.dart';

typedef SectionBuilder = Widget Function(BuildContext context, int section);
typedef SectionChildBuilder = Widget Function(BuildContext context, int section, int index);
typedef ChildSeparatorBuilder = Widget Function(BuildContext context, int section, int index);
typedef SectionItemCount = int Function(int section);

class CupertinoListBuilderDelegate extends CupertinoListDelegate {

  final SectionBuilder sectionBuilder;
  final SectionChildBuilder childBuilder;
  final SectionItemCount itemInSectionCount;
  final ChildSeparatorBuilder separatorBuilder;

  bool get _hasSeparator => this.separatorBuilder != null;

  CupertinoListBuilderDelegate(
      {int sectionCount, this.sectionBuilder, this.childBuilder, this.itemInSectionCount, this.separatorBuilder})
      :super(sectionCount: sectionCount);

  @override
  Widget buildItem(BuildContext context, int section, int index) {
    if(_hasSeparator) {
      if(index.isEven){
        return this.childBuilder(context, section, index~/2);
      }
      else {
        return this.separatorBuilder(context, section, index~/2);
      }
    }
    else {
      return this.childBuilder(context, section, index);
    }
  }

  @override
  Widget buildSection(BuildContext context, int section) => this.sectionBuilder(context, section);

  @override
  int itemCount({int section}) {
    final childCount = this.itemInSectionCount(section);
    return _hasSeparator ? childCount*2-1 : childCount;
  }

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