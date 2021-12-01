import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:research_mobile_app/exportHelper.dart';
import 'package:research_mobile_app/models/medicine.dart';

class SearchWidget extends StatefulWidget {
  const SearchWidget({
    Key? key,
    required this.medicines,
    required this.controller,
  }) : super(key: key);
  final List<Medicine> medicines;
  final TextEditingController controller;
  @override
  _SearchWidgetState createState() => _SearchWidgetState();
}

class _SearchWidgetState extends State<SearchWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late TextEditingController _textEditingController;
  late List<Medicine> _medicines;
  List<Widget> _itemList = [];
  bool _showSearchResult = false;

  @override
  void initState() {
    super.initState();

    _medicines = widget.medicines;

    _textEditingController = widget.controller;

    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );

    _animationController.addListener(() {
      if (_animationController.value >= 0.4) {
        setState(() {});
      }

      if (_animationController.value >= 0.6) {
        setState(() {});
      } else {
        setState(() {});
      }
    });

    _animationController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        setState(() {});
      } else if (status == AnimationStatus.dismissed) {
        setState(() {});
      }
    });
  }

  /// Search through the medicine list base on [keyword]
  ///
  /// Convert to lowercase the brandname, generic names,
  /// and keyword. Then match them using [String.contains(value)]
  List<Widget> search(String keyword) {
    List<Widget> match = [];
    int matchCounter = 0;
    Divider divider = Divider(
      indent: 16.0,
      endIndent: 16.0,
      height: 3.0,
      color: Colors.black.withOpacity(0.5),
    );

    _itemList.add(divider);

    _medicines.forEach((Medicine med) {
      List<String> genericNames = [];
      matchCounter += 1;
      med.genericNames.forEach((element) {
        genericNames.add(element.name);
      });

      String medicineGenericName = genericNames.join(',').toLowerCase();
      if (med.brandName.toLowerCase().contains(keyword.toLowerCase()) ||
          medicineGenericName.contains(keyword.toLowerCase())) {
        ListTile listTile = ListTile(
          leading: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Icon(FontAwesomeIcons.pills),
          ),
          title: Text('${med.brandName}'),
          subtitle: Text(
            '$medicineGenericName',
          ),
          onTap: () {
            // pass the medicine object
            setState(() {
              _showSearchResult = false;
              _textEditingController.clear();
            });

            Navigator.popAndPushNamed(
              context,
              mapPage,
              arguments: med,
            );
          },
        );
        match.add(listTile);
      }
    });

    if (matchCounter == 0) {
      ListTile listTile = ListTile(
        leading: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Icon(FontAwesomeIcons.exclamationCircle),
        ),
        title: Text('No match found'),
        onTap: () {},
      );
      match.add(listTile);
      return match;
    }
    return match;
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        AnimatedContainer(
          duration: const Duration(milliseconds: 500),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.2),
                blurRadius: 12,
              )
            ],
            color: Colors.white,
          ),
          width: 500,
          height: _showSearchResult ? 300 : 80,
          child: Column(
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    width: 50,
                    height: 50,
                    alignment: Alignment.center,
                    child: Icon(
                      FontAwesomeIcons.search,
                      color: Colors.blueAccent,
                    ),
                  ),
                  Expanded(
                    child: TextField(
                      controller: _textEditingController,
                      autofocus: false,
                      style: TextStyle(
                        fontSize: 20,
                        // color: Colors.black.withOpacity(0.4),
                      ),
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: 'Search Medicine...',
                        hintStyle: TextStyle(
                          fontSize: 18,
                          color: Colors.black.withOpacity(0.4),
                        ),
                      ),
                      onSubmitted: (value) {
                        // print(value);
                        Navigator.pushNamed(context, searchMedicinePage,
                            arguments: value);
                      },
                      onChanged: (value) {
                        if (value.isNotEmpty) {
                          setState(() {
                            _itemList = search(value);
                            _showSearchResult = true;
                          });
                        } else {
                          setState(() {
                            _showSearchResult = false;
                          });
                        }
                      },
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      if (_textEditingController.text.isNotEmpty) {
                        setState(() {
                          _textEditingController.clear();
                          _showSearchResult = false;
                        });
                      } else {
                        setState(() {});
                      }
                    },
                    child: Container(
                      width: 80.0,
                      height: 80.0,
                      alignment: Alignment.center,
                      child: Icon(
                        FontAwesomeIcons.times,
                        color: Colors.black,
                        size: 15,
                      ),
                    ),
                  ),
                ],
              ),
              // items
              Expanded(
                child: Visibility(
                  visible: _showSearchResult,
                  child: SingleChildScrollView(
                    child: Column(
                      children: _itemList,
                    ),
                  ),
                ),
              )
            ],
          ),
        )
      ],
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }
}
// yayyyyyyyyyyyayayyyyyyyyyy 🎉
