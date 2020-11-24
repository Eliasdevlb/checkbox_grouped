import 'package:checkbox_grouped/checkbox_grouped.dart';
import 'package:flutter/material.dart';

class ListGroupedCheckbox<T> extends StatefulWidget {
  final List<List<T>> values;
  final List<List<String>> titles;
  final List<String> groupTitles;
  final List<String> subTitles;
  final List<bool> isMultipleSelectionPerGroup;
  final List<List<T>> preSelectedValues;
  final List<List<T>> disabledValues;

  ListGroupedCheckbox({
    @required this.titles,
    @required this.groupTitles,
    @required this.values,
    this.subTitles,
    this.isMultipleSelectionPerGroup,
    this.preSelectedValues = const [],
    this.disabledValues = const [],
    Key key,
  })  : assert(values.length == titles.length),
        assert(groupTitles.length == titles.length),
        assert(isMultipleSelectionPerGroup.length == titles.length),
        super(key: key);

  @override
  ListGroupedCheckboxState createState() => ListGroupedCheckboxState();

  static ListGroupedCheckboxState of<T>(BuildContext context,
      {bool nullOk = false}) {
    assert(context != null);
    assert(nullOk != null);
    final ListGroupedCheckboxState<T> result =
        context.findAncestorStateOfType<ListGroupedCheckboxState<T>>();
    if (nullOk || result != null) return result;
    throw FlutterError.fromParts(<DiagnosticsNode>[
      ErrorSummary(
          'ListGroupedCheckboxState.of() called with a context that does not contain an CustomGroupedCheckbox.'),
      ErrorDescription(
          'No ListGroupedCheckboxState ancestor could be found starting from the context that was passed to CustomGroupedCheckbox.of().'),
      context.describeElement('The context used was')
    ]);
  }
}

class ListGroupedCheckboxState<T> extends State<ListGroupedCheckbox> {
  int len = 0;
  List<GlobalKey<SimpleGroupedCheckboxState>> listKeys = [];

  @override
  void initState() {
    super.initState();
    len = widget.values.length;
    listKeys.addAll(List.generate(widget.values.length,
        (index) => GlobalKey<SimpleGroupedCheckboxState>()));
  }

  Future<List<T>> getAllValues() async {
    List<T> resultList = List<T>();
    resultList.addAll(listKeys.map((e) => e.currentState.selection()));
    return resultList;
  }

  Future<List<T>> getValuesByIndex(int index) async {
    assert(index < len);
    List<T> resultList = List<T>();
    resultList.addAll(listKeys[index].currentState.selection());
    return resultList;
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemBuilder: (ctx, index) {
        return SimpleGroupedCheckbox<T>(
          itemsTitle: widget.titles[index],
          values: widget.values[index],
          preSelection: widget.preSelectedValues[index],
          disableItems: widget.disabledValues[index],
          groupTitle: widget.groupTitles[index],
          isCirculaire: false,
          multiSelection: widget.isMultipleSelectionPerGroup[index],
        );
      },
      itemCount: len,
    );
  }
}
