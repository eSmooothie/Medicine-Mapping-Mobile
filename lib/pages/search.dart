import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:research_mobile_app/exportHelper.dart';
import 'package:research_mobile_app/exportModel.dart';
import 'package:research_mobile_app/exportRequest.dart';
import 'package:research_mobile_app/helper/filterDrawer.dart';

class Search extends StatefulWidget {
  const Search({Key? key, required this.title, this.arguments})
      : super(key: key);
  final String title;
  final Object? arguments;
  @override
  _SearchState createState() => _SearchState();
}

class _SearchState extends State<Search> {
  late var args;
  late String searchBy;
  Map<String, Map<String, bool>> filter = {};
  Map<String, Map<String, bool>> filterData = {};

  TextEditingController _searchController = TextEditingController();
  List<Object> _items = [];
  List<Object> _searchResults = [];

  // future medicine
  Future futureMedicine() async {
    bool isFiltered = false;

    Map<String, List<String>> _filter = {};
    // loop through filter
    filter.forEach((key, value) {
      List<String> _params = [];
      // get the name with true value
      // and store it in _params
      value.forEach((key, value) {
        // if one value is true then it is filtered
        if (value) {
          isFiltered = true;
          _params.add(key);
        }
      });
      String newKey = key.replaceAll(" ", "");
      _filter[newKey] = _params;
    });

    if (isFiltered) {
      return await RequestMedicine().filterMedicine(filter: _filter);
    } else {
      return await RequestMedicine().QueryAll();
    }
  }

  // future pharmacy
  Future futurePharma = Future(() async {
    // return await RequestPharmacy().QueryAll();
    return null;
  });

  void initVariables() async {
    await Future.delayed(Duration(seconds: 3));
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    initVariables();
    print("initState");
  }

  @override
  void dispose() {
    // TODO: implement dispose
    print("Dispose search page.");
    _searchController.dispose();
    super.dispose();
  }

  @override
  void deactivate() {
    // TODO: implement deactivate
    print("Deactive search page.");
    super.deactivate();
  }

  @override
  Widget build(BuildContext context) {
    setState(() {
      args = widget.arguments;
      if (args is List) {
        searchBy = args[0];

        if (args.length > 1) {
          filter = args[1];
        }
      }
    });

    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        leading: CustomWidget.outlinedButton(
          onPressed: () {
            Navigator.popAndPushNamed(
              context,
              landingPage,
            );
          },
          child: Icon(
            Icons.arrow_back,
            color: Colors.white,
          ),
          backgroundColor: Colors.transparent,
          minHeight: 50.0,
          minWidth: 50.0,
          side: BorderSide(color: Colors.transparent),
        ),
        title: Text(widget.title),
        actions: [Container()],
      ),
      endDrawer: FilterDrawer(
        filters: {
          'General Classification': {'x': true, 'y': false, 'z': false},
          'Medicine Form': {
            'form_1': false,
            'form_2': false,
          },
        },
        searchBy: searchBy,
      ),
      drawerEnableOpenDragGesture: false,
      endDrawerEnableOpenDragGesture: false,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(18.0, 18.0, 18.0, 0),
          child: Flex(
            direction: Axis.vertical,
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Container(
                height: 60,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Flexible(
                      flex: 4,
                      fit: FlexFit.tight,
                      child: CustomWidget.textField(
                        controller: _searchController,
                        keyboardType: TextInputType.name,
                        radius: 50.0,
                        hintText: "",
                        labelText: "Label",
                        onChanged: onSearchTextChange,
                      ),
                    ),
                    _showDrawer(context),
                  ],
                ),
              ),
              Expanded(
                flex: 5,
                child: FutureBuilder(
                  future: (searchBy == 'pharmacy')
                      ? futurePharma
                      : futureMedicine(),
                  builder: (BuildContext context, AsyncSnapshot snapshot) {
                    var rand = new Random();
                    List<ObjectItemDataHolder> _searchItemDataHolder = [];
                    if (snapshot.hasData) {
                      // done loading

                      // check data object type
                      // and map each object
                      if (snapshot.data is List<Medicine>) {
                        _items.clear();
                        snapshot.data.forEach((Medicine medicine) {
                          _items.add(medicine);
                        });
                      } else if (snapshot.data is List<Pharmacy>) {
                        _items.clear();
                        snapshot.data.forEach((Pharmacy pharmacy) {
                          _items.add(pharmacy);
                        });
                      }

                      if (_searchResults.isNotEmpty ||
                          _searchController.text.isNotEmpty) {
                        _searchItemDataHolder.clear();
                        // print("$_searchResults");
                        _searchResults.forEach((item) {
                          if (item is Medicine) {
                            List<String> medicineGenericNames = [];
                            item.genericNames.forEach((element) {
                              medicineGenericNames.add(element.name);
                            });
                            String description =
                                medicineGenericNames.join(", ");
                            description =
                                description + "\n${item.dosage} ${item.form}";
                            ObjectItemDataHolder drugData =
                                ObjectItemDataHolder(
                              name: item.brandName,
                              description: description.toUpperCase(),
                              object: item,
                            );

                            _searchItemDataHolder.add(drugData);
                          } else if (item is Pharmacy) {
                            ObjectItemDataHolder pharmaData =
                                ObjectItemDataHolder(
                                    name: item.name,
                                    description: item.address,
                                    object: item);
                            _searchItemDataHolder.add(pharmaData);
                          }
                        });
                      } else {
                        _searchItemDataHolder.clear();
                        _items.forEach((item) {
                          if (item is Medicine) {
                            List<String> medicineGenericNames = [];
                            item.genericNames.forEach((element) {
                              medicineGenericNames.add(element.name);
                            });
                            String description =
                                medicineGenericNames.join(", ");
                            description =
                                description + "\n${item.dosage} ${item.form}";
                            ObjectItemDataHolder drugData =
                                ObjectItemDataHolder(
                              name: item.brandName,
                              description: description.toUpperCase(),
                              object: item,
                            );

                            _searchItemDataHolder.add(drugData);
                          } else if (item is Pharmacy) {
                            ObjectItemDataHolder pharmaData =
                                ObjectItemDataHolder(
                                    name: item.name,
                                    description: item.address,
                                    object: item);
                            _searchItemDataHolder.add(pharmaData);
                          }
                        });
                      }

                      return ListView.separated(
                        shrinkWrap: true,
                        itemBuilder: (BuildContext context, int index) {
                          return ItemContainer(
                            title: _searchItemDataHolder[index].name,
                            description:
                                _searchItemDataHolder[index].description,
                            onPressed: () {
                              // reroute to their desire information page
                              // evaluate the obj of searchItemDataHolder
                              if (_searchItemDataHolder[index].object
                                  is Medicine) {
                                // reroute to medicine information page
                                Navigator.pushNamed(
                                  context,
                                  medicineInfoPage,
                                  arguments:
                                      _searchItemDataHolder[index].object,
                                );
                              } else if (_searchItemDataHolder[index].object
                                  is Pharmacy) {
                                // reroute to pharmacy information page
                                Map<String, Object> args = {
                                  'from': searchPage,
                                  'pharmacy':
                                      _searchItemDataHolder[index].object,
                                };
                                Navigator.pushNamed(
                                  context,
                                  pharmacyInfoPage,
                                  arguments: args,
                                );
                              }
                            },
                          );
                        },
                        separatorBuilder: (BuildContext context, int index) =>
                            const Divider(),
                        itemCount: _searchItemDataHolder.length,
                      );
                    } else if (snapshot.hasError) {
                      // error encountered.
                      return Text("Error: ${snapshot.error}");
                    }

                    // display skeleton animation while waiting for the data
                    return ListView.separated(
                      shrinkWrap: true,
                      itemBuilder: (BuildContext context, int index) {
                        double titleWidth =
                            rand.nextInt(200).clamp(50, 200).floorToDouble();
                        double descHeight =
                            rand.nextInt(100).clamp(20, 100).floorToDouble();
                        return ItemContainerSkeleton(
                          titleWidth: titleWidth,
                          descHeight: descHeight,
                        );
                      },
                      separatorBuilder: (BuildContext context, int index) =>
                          const Divider(),
                      itemCount: 7,
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: SpeedDial(
        animatedIcon: AnimatedIcons.search_ellipsis,
        overlayColor: Colors.blue.shade100,
        animationSpeed: 50,
        spacing: 10.0,
        spaceBetweenChildren: 10.0,
        children: [
          SpeedDialChild(
            child: SizedBox(
              height: 25,
              width: 25,
              child: SvgIcons.capsulesSolid,
            ),
            label: "Medicine",
            onTap: () {
              List<Object> args = [
                "medicine",
              ];
              Navigator.popAndPushNamed(context, searchPage, arguments: args);
            },
          ),
          SpeedDialChild(
            child: SizedBox(
              height: 25,
              width: 25,
              child: SvgIcons.pharmacy,
            ),
            label: "Pharmacy",
            onTap: () {
              List<Object> args = [
                "pharmacy",
              ];

              Navigator.popAndPushNamed(context, searchPage, arguments: args);
            },
          ),
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }

  onSearchTextChange(String text) {
    // print(text);
    // clear result
    _searchResults.clear();
    if (text.isEmpty) {
      setState(() {});
      return;
    }

    // search match text

    _items.forEach((item) {
      if (item is Medicine) {
        List<String> medicineGenericNames = [];
        item.genericNames.forEach((element) {
          medicineGenericNames.add(element.name);
        });
        String genericNames = medicineGenericNames.join(", ").toUpperCase();
        if (item.brandName.toLowerCase().contains(text) ||
            genericNames.toLowerCase().contains(text)) {
          _searchResults.add(item);
        }
      } else if (item is Pharmacy) {
        // print(item.name);
        if (item.name.toLowerCase().contains(text)) {
          _searchResults.add(item);
        }
      }
    });

    setState(() {});
  }

  Builder _showDrawer(BuildContext context) {
    return Builder(builder: (context) {
      return Flexible(
        flex: 1,
        fit: FlexFit.tight,
        child: CustomWidget.outlinedButton(
          onPressed: () {
            print("Filter Clicked...");
            Scaffold.of(context).openEndDrawer();
          },
          child: Icon(Icons.filter_alt_rounded),
          backgroundColor: Colors.transparent,
          minHeight: 50.0,
          minWidth: 50.0,
          side: BorderSide(color: Colors.transparent),
        ),
      );
    });
  }
}
