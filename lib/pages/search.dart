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
  bool isFiltered = false;

  TextEditingController _searchController = TextEditingController();
  List<Object> _items = [];
  List<Object> _searchResults = [];

  // future medicine
  Future futureMedicine() async {
    Map<String, List<String>> _filter = {};
    // loop through filter
    filter.forEach((key, value) {
      List<String> _params = [];
      // get the name with true value
      // and store it in _params
      value.forEach((key, value) {
        // if one value is true then it is filtered
        if (value) {
          setState(() {
            isFiltered = true;
          });

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
    return await RequestPharmacy().QueryAll();
    // return null;
  });

  void initVariables() async {
    // get all general classification
    List<GeneralClassification> genClass =
        await RequestMedicine().getGeneralClassification();
    // map classification names
    Map<String, bool> genClassNames = {};
    genClass.forEach((element) {
      genClassNames[element.NAME] = false;
    });
    // get all medicine form
    List<MedicineForm> _medicineForms =
        await RequestMedicine().getMedicineForm();
    // map medicine form
    Map<String, bool> _medForm = {};
    _medicineForms.forEach((element) {
      _medForm[element.NAME] = false;
    });
    setState(() {
      filterData["General Classification"] = genClassNames;
      filterData["Medicine Form"] = _medForm;
    });
  }

  @override
  void initState() {
    super.initState();

    initVariables();
    print("initState");
    args = widget.arguments;
    if (args is List) {
      searchBy = args[0];

      if (args.length > 1) {
        filter = args[1];
      }
    }
  }

  @override
  void dispose() {
    print("Dispose search page.");
    _searchController.dispose();
    super.dispose();
  }

  @override
  void deactivate() {
    print("Deactive search page.");
    super.deactivate();
  }

  @override
  Widget build(BuildContext context) {
    // setState(() {});

    return Scaffold(
      backgroundColor: Colors.grey.shade100,
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
        filters: (isFiltered) ? filter : filterData,
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
                        labelText: "Search",
                        onChanged: onSearchTextChange,
                        prefixIcon: Icon(Icons.search),
                      ),
                    ),
                    (searchBy == "medicine")
                        ? _showDrawer(context)
                        : Container(),
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
                            String dosage =
                                (item.dosage != "") ? item.dosage + " " : "";
                            description = description + "\n$dosage${item.form}";
                            ObjectItemDataHolder drugData =
                                ObjectItemDataHolder(
                              name: item.brandName,
                              description: description,
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
                            String dosage =
                                (item.dosage != "") ? item.dosage + " " : "";
                            description = description + "\n$dosage${item.form}";
                            ObjectItemDataHolder drugData =
                                ObjectItemDataHolder(
                              name: item.brandName,
                              description: description,
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
                      return Padding(
                        padding: const EdgeInsets.only(top: 10.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: CustomWidget.errorContainer(
                              errorMessage: snapshot.error.toString()),
                        ),
                      );
                    }

                    // display skeleton animation while waiting for the data
                    return ListView.separated(
                      shrinkWrap: true,
                      itemBuilder: (BuildContext context, int index) {
                        double titleWidth =
                            rand.nextInt(200).clamp(50, 200).floorToDouble();
                        double descHeight =
                            rand.nextInt(150).clamp(20, 150).floorToDouble();
                        double containerHeight =
                            rand.nextInt(150).clamp(80, 150).floorToDouble();
                        return ItemContainerSkeleton(
                          titleWidth: titleWidth,
                          descHeight: descHeight,
                          containerHeight: containerHeight,
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
        overlayColor: Color.fromARGB(255, 41, 171, 226),
        backgroundColor: Color.fromARGB(255, 255, 108, 85),
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
        String genericNames = medicineGenericNames.join(", ").toLowerCase();
        if (item.brandName.toLowerCase().contains(text.toLowerCase()) ||
            genericNames.toLowerCase().contains(text.toLowerCase())) {
          _searchResults.add(item);
        }
      } else if (item is Pharmacy) {
        // print(item.name);
        if (item.name.toLowerCase().contains(text.toLowerCase())) {
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
