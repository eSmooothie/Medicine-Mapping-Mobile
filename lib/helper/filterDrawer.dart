import 'package:flutter/material.dart';
import 'package:research_mobile_app/exportHelper.dart';

class FilterDrawer extends StatefulWidget {
  final Map<String, Map<String, bool>> filters;
  final String searchBy;
  const FilterDrawer({
    Key? key,
    required this.filters,
    required this.searchBy,
  }) : super(key: key);

  @override
  _FilterDrawerState createState() => _FilterDrawerState();
}

class _FilterDrawerState extends State<FilterDrawer> {
  List<String> _filterHeaderList = [];
  Map<String, Map<String, bool>> _filterItemsList = {};

  Widget _filters({
    required String filterHeader,
    required Map<String, bool> filterItems,
  }) {
    return IntrinsicHeight(
      child: Container(
        color: Colors.orange,
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
            // update the state of the object
            _filterItemsList[filterHeader]![key] =
                !_filterItemsList[filterHeader]![key]!;
          });
          // print("$key: ${_filterItemsList[filterHeader]![key]}");
        },
        selected: _filterItemsList[filterHeader]![key]!,
      );
      _items.add(_filterChip);
    });
    return _items;
  }

  List<Widget> _displayFilters() {
    List<Widget> _container = [];

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
      _filterItemsList = widget.filters;
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
                  // Submit
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
                          List<Object> args = [
                            widget.searchBy,
                            _filterItemsList,
                          ];
                          Navigator.popAndPushNamed(
                            context,
                            searchPage,
                            arguments: args,
                          );
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
