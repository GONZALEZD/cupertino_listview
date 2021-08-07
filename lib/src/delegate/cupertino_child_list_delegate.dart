import 'package:cupertino_listview/src/widget_builder.dart';
import 'package:flutter/cupertino.dart';

import 'cupertino_list_delegate.dart';

class CupertinoChildListDelegate extends CupertinoListDelegate {
  final List<List<Widget>> children;

  final SectionBuilder floatingSectionBuilder;

  final Map<Key, int> _keysToIndex;

  CupertinoChildListDelegate(
      {required this.children, required this.floatingSectionBuilder})
      : _keysToIndex = {},
        super(sectionCount: children.length) {
    setup();
  }

  @override
  void setup() {
    super.setup();
    final flatList = children.fold<List>([], (list, section) => list + section);
    Widget child;
    for (var i = 0; i < flatList.length; i++) {
      child = flatList[i];
      if (child.key != null) {
        _keysToIndex[child.key!] = i;
      }
    }
  }

  @override
  int findIndexByKey(Key key) => _keysToIndex[key] ?? 0;

  @override
  Widget buildItem(BuildContext context, IndexPath index) {
    return children[index.section][index.child + 1];
  }

  @override
  Widget buildSection(
      BuildContext context, SectionPath index, bool isFloating) {
    if (isFloating) {
      return floatingSectionBuilder(context, index, true);
    }
    return children[index.section][0];
  }

  @override
  int itemCount({required int section}) {
    return children[section].length - 1;
  }
}
