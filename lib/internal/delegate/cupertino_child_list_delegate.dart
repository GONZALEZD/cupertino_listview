import 'package:cupertino_listview/internal/delegate/cupertino_list_delegate.dart';
import 'package:flutter/src/widgets/framework.dart';

class CupertinoChildListDelegate extends CupertinoListDelegate {

  final List<List<Widget>> children;

  final Map<Key, int> _keysToIndex;

  CupertinoChildListDelegate({this.children}):
      _keysToIndex = {},
        super(sectionCount: children.length);

  @override
  void setup() {
    super.setup();
    final flatList = children.fold([], (list, section) => list + section);
    Widget child;
    for(var i = 0; i<flatList.length; i++) {
      child = flatList[i];
      if(child.key != null) {
        _keysToIndex[child.key] = i;
      }
    }
  }

  @override
  int findIndexByKey(Key key) {
    return _keysToIndex.containsKey(key) ? _keysToIndex[key] : null;
  }

  @override
  Widget buildItem(BuildContext context, int section, int index, int absoluteIndex) {
    return children[section][index+1];
  }

  @override
  Widget buildSection(BuildContext context, int section, int absoluteIndex) {
    return children[section][0];
  }

  @override
  int itemCount({int section}) {
    return children[section].length-1;
  }
}