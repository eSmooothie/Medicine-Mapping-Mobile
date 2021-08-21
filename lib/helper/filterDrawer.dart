import 'package:flutter/material.dart';

class filterDrawer extends StatefulWidget {
  final Map<String, List<String>> filters;
  const filterDrawer({
    Key? key,
    required this.filters,
  }) : super(key: key);

  @override
  _filterDrawerState createState() => _filterDrawerState();
}

class _filterDrawerState extends State<filterDrawer> {
  Map<String, bool> filterItem1 = {
    "x": false,
    "y": false,
    "z": false,
  };
  Map<String, bool> filterItem2 = {
    "x1": false,
    "y1": false,
    "z1": false,
  };

  List<String> _filterHeaderList = [];
  Map<String, Map<String, bool>> _filterItemsList = {};

  Map<String, List<String>> filters = {};

  bool _initVar = true;

  Widget _filters({
    required String filterHeader,
    required Map<String, bool> filterItems,
  }) {
    return Container(
      color: Colors.orange,
      height: 400,
      child: Flex(
        direction: Axis.vertical,
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Flexible(
              child: Text(
            "$filterHeader",
            style: TextStyle(
              fontSize: 18.0,
              fontWeight: FontWeight.bold,
            ),
          )),
          Expanded(
            child: Wrap(
              spacing: 10.0,
              children: _filterItems(
                filterLabel: filterItems,
                filterHeader: filterHeader,
              ),
            ),
          ),
        ],
      ),
    );
  }

  List<FilterChip> _filterItems({
    required String filterHeader,
    required Map<String, bool> filterLabel,
  }) {
    List<FilterChip> _items = [];
    filterLabel.forEach((key, value) {
      FilterChip _filterChip = FilterChip(
        label: Text("$key: ${_filterItemsList[filterHeader]![key]}"),
        onSelected: (isSelect) {
          setState(() {
            if (_filterItemsList[filterHeader]!.containsKey(key)) {
              _filterItemsList[filterHeader]![key] =
                  !_filterItemsList[filterHeader]![key]!;
            } else {
              _filterItemsList[filterHeader]![key] = isSelect;
            }
          });

          // print("$key: ${_filterItemsList[filterHeader]![key]}");
        },
        selected: (_filterItemsList[filterHeader]!.containsKey(key))
            ? _filterItemsList[filterHeader]![key]!
            : false,
      );
      _items.add(_filterChip);
    });
    return _items;
  }

  void generateMapFilterObjects() {
    filters.forEach((key, value) {
      print("$key: $value");
      Map<String, bool> obj = {};
      _filterHeaderList.add(key);
      value.forEach((label) {
        obj[label] = false;
      });
      _filterItemsList[key] = obj;
    });
  }

  List<Widget> _displayFilters() {
    List<Widget> _container = [];

    // print(_filterHeaderList);
    // print(_filterItemsList);

    _filterItemsList.forEach((key, value) {
      Widget item = _filters(
        filterHeader: key,
        filterItems: value,
      );

      _container.add(item);
    });

    return _container;
  }

  @override
  Widget build(BuildContext context) {
    setState(() {
      _filterHeaderList = [];
      // _filterItemsList = {};
      filters = widget.filters;
      if (_initVar) {
        generateMapFilterObjects();
        _initVar = false;
      }
    });
    return Drawer(
      child: Stack(
        fit: StackFit.expand,
        children: [
          ListView(
            children: _displayFilters(),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              height: 60,
              child: Flex(
                direction: Axis.horizontal,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Reset
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        border: Border.all(
                          color: Colors.blue,
                        ),
                      ),
                      child: InkWell(
                        onTap: () {
                          print("reset");
                        },
                        child: Center(
                          child: Text(
                            "Reset",
                            style: TextStyle(
                              color: Colors.blue,
                              fontWeight: FontWeight.bold,
                              fontSize: 16.0,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.blue,
                        border: Border.all(
                          color: Colors.blue,
                        ),
                      ),
                      child: InkWell(
                        onTap: () {
                          print("submit");
                        },
                        child: Center(
                          child: Text(
                            "Submit",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 16.0,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
