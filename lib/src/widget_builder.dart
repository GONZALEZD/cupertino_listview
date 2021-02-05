import 'package:flutter/material.dart';

/// Class describing a section's index of the [CupertinoListView]
class SectionPath {
  /// Section index
  final int section;

  /// Index of the element in the whole list
  final int absoluteIndex;

  SectionPath({this.section, this.absoluteIndex});
}

/// Class describing a child's index of the [CupertinoListView]
class IndexPath extends SectionPath {
  /// Index of the child in the current section
  final int child;

  IndexPath({int section, this.child, int absoluteIndex})
      : super(section: section, absoluteIndex: absoluteIndex);

  IndexPath copyWith({int section, int child, int absoluteIndex}) {
    return IndexPath(
      section: section ?? this.section,
      child: child ?? this.child,
      absoluteIndex: absoluteIndex ?? this.absoluteIndex,
    );
  }
}

/// Section title builder, either used to build sections of the
/// list and the current floating section.
/// Avoid using same key for floating widget and list widget,
/// using [isFloating] input parameter.
typedef SectionBuilder = Widget Function(
    BuildContext context, SectionPath index, bool isFloating);

/// Section children builder
typedef SectionChildBuilder = Widget Function(
    BuildContext context, IndexPath index);

/// Separator Builder, used between two children
typedef ChildSeparatorBuilder = Widget Function(
    BuildContext context, IndexPath index);

/// Retrieve the number of items of a given section
typedef SectionItemCount = int Function(int section);
