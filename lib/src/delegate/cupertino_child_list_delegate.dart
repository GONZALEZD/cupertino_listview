import 'cupertino_list_delegate.dart';
import 'package:flutter/cupertino.dart';
import 'package:cupertino_listview/src/widget_builder.dart';

class CupertinoChildListDelegate extends CupertinoListDelegate {
  final List<List<Widget>> children;

  final SectionBuilder floatingSectionBuilder;

  final Map<Key, int> _keysToIndex;

  CupertinoChildListDelegate({this.children, this.floatingSectionBuilder})
      : _keysToIndex = {},
        super(sectionCount: children.length);

  @override
  void setup() {
    super.setup();
    final flatList = children.fold([], (list, section) => list + section);
    Widget child;
    for (var i = 0; i < flatList.length; i++) {
      child = flatList[i];
      if (child.key != null) {
        _keysToIndex[child.key] = i;
      }
    }
  }

  @override
  int findIndexByKey(Key key) {
    return _keysToIndex.containsKey(key) ? _keysToIndex[key] : null;
  }

  @override
  Widget buildItem(BuildContext context, IndexPath index) {
    return children[index.section][index.child + 1];
  }

  @override
  Widget buildSection(
      BuildContext context, SectionPath index, bool isFloating) {
    if (isFloating && floatingSectionBuilder != null) {
      return floatingSectionBuilder(context, index, true);
    }
    return children[index.section][0];
  }

  @override
  int itemCount({int section}) {
    return children[section].length - 1;
  }
}
