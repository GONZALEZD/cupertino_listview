## [3.0.0] Update flutter versions + Empty sections
* Add possibility to show empty section (display only header).

## [2.0.0] Null Safety migration
* Migration to null safety
* Change linter to flutter_lints

## [1.0.5] Fix ScrollController bug

* Fix a bug where scroll controller was disposed on widget update. 
Now, if the user set its own ScrollController, then it's his/her responsibility 
to dispose it. 

## [1.0.4] Enhance CupertinoListView API

* Introduce SectionPath and IndexPath, grouping information about indexes: 
section index, child index, and list absolute index.

* Add floatingSectionBuilder for default CupertinoListView constructor, in order
to differentiate the section widget built for the list, and the other one
built for the floating widget.

## [1.0.3] Fix CupertinoListView API

* For CupertinoListView.builder factory, make separatorBuilder optional.

## [1.0.2] Dartfmt format

* Reformat files using "dartfmt -w" command.

## [1.0.1] Take into account pub package analysis

* Remove private imports from other packages.
* Add a longer package description.

## [1.0.0] Initial release

* Initial version of Cupertino listview behaving like UITableView.
