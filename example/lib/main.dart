import 'package:cupertino_listview/cupertino_listview.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'src/console.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter CupertinoListView Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(title: 'Flutter CupertinoListView Demo'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final _data = Section.allData();
  late final ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.title)),
      body: CupertinoListView.builder(
        sectionCount: _data.length,
        itemInSectionCount: (section) => _data[section].itemCount,
        sectionBuilder: _buildSection,
        childBuilder: _buildItem,
        separatorBuilder: _buildSeparator,
        controller: _scrollController,
      ),
    );
  }

  Widget _buildSeparator(BuildContext context, IndexPath index) {
    return Divider(indent: 20.0, endIndent: 20.0);
  }

  Widget _buildSection(
      BuildContext context, SectionPath index, bool isFloating) {
    final style = Theme.of(context).textTheme.headlineMedium;
    return Container(
      height: 80.0,
      alignment: Alignment.centerLeft,
      padding: EdgeInsets.only(left: 20.0),
      color: Theme.of(context).primaryColorDark,
      child: Text(_data[index.section].name,
          style: style!.copyWith(color: Colors.white)),
    );
  }

  Widget _buildItem(BuildContext context, IndexPath index) {
    final attribute = _data[index.section][index.child];
    return Container(
      padding: const EdgeInsets.all(20.0),
      constraints: BoxConstraints(minHeight: 50.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(child: Text(attribute.console), width: 120.0),
          Expanded(child: Text(attribute.attribute)),
        ],
      ),
    );
  }
}