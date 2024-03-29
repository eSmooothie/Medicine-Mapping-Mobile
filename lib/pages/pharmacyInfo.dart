import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:research_mobile_app/exportHelper.dart';
import 'package:research_mobile_app/exportModel.dart';
import 'package:research_mobile_app/exportRequest.dart';

class PharmacyInformation extends StatefulWidget {
  const PharmacyInformation({
    Key? key,
    required this.title,
    this.arguments,
  }) : super(key: key);
  final String title;
  final Object? arguments;

  @override
  _PharmacyInformationState createState() => _PharmacyInformationState();
}

class _PharmacyInformationState extends State<PharmacyInformation> {
  late Pharmacy _pharmaInfo;
  late var _arguments;
  TextEditingController _searchDrugController = TextEditingController();

  /// get inventory of the pharmacy
  Future _future() async {
    List<PharmaInventory> pharmaInventory = await RequestPharmacy().getMedicine(
      pharmacyId: _pharmaInfo.id,
    );

    return pharmaInventory;
  }

  @override
  void initState() {
    super.initState();
    setState(() {
      _arguments = widget.arguments;

      _pharmaInfo = _arguments['pharmacy'];
    });
  }

  @override
  void dispose() {
    print("Dispose pharmacy info page.");
    _searchDrugController.dispose();
    super.dispose();
  }

  @override
  void deactivate() {
    print("Deactivate pharmacy info page.");
    super.deactivate();
  }

  List<Widget> _contactDetail() {
    List<Widget> container = [];
    _pharmaInfo.contactDetail!.forEach((detail) {
      Container holder = Container(
        child: Flex(
          direction: Axis.horizontal,
          children: [
            Text(
              "${detail.TYPE}: ",
            ),
            Expanded(
              child: Text(
                "${detail.DETAIL}",
                softWrap: true,
              ),
            ),
          ],
        ),
      );

      container.add(holder);
    });
    return container;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        leading: CustomWidget.outlinedButton(
          onPressed: () {
            Navigator.pop(context);
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
        title: Text("${widget.title}"),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Flex(
          direction: Axis.vertical,
          children: [
            // pharmacy information
            IntrinsicHeight(
              child: Container(
                margin: EdgeInsets.all(10.0),
                padding: EdgeInsets.all(15.0),
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(
                    color: Colors.blue,
                    width: 1,
                  ),
                  boxShadow: <BoxShadow>[
                    BoxShadow(
                      color: Colors.blue.shade100,
                      blurRadius: 10.0,
                      spreadRadius: 1.0,
                    ),
                  ],
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Flex(
                  direction: Axis.horizontal,
                  children: [
                    // pharmacy information
                    Expanded(
                      flex: 5,
                      child: Flex(
                        direction: Axis.vertical,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            child: Text(
                              "${_pharmaInfo.name}",
                              style: TextStyle(
                                fontSize: 24.0,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          Expanded(
                            flex: 5,
                            child: Text("${_pharmaInfo.address}"),
                          ),
                          Container(
                            margin: EdgeInsets.only(top: 20.0),
                            child: Text(
                              "Contact Information:",
                              style: TextStyle(
                                fontSize: 14.0,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          Container(
                            child: Flex(
                              direction: Axis.vertical,
                              children: _contactDetail(),
                            ),
                          ),
                        ],
                      ),
                    ),
                    // get direction button
                    Expanded(
                      flex: 2,
                      child: CustomWidget.outlinedButton(
                        backgroundColor: Colors.transparent,
                        side: BorderSide(
                          color: Colors.transparent,
                        ),
                        onPressed: () {
                          List<Object> args = [
                            LatLng(
                              double.parse(_pharmaInfo.lat),
                              double.parse(_pharmaInfo.lng),
                            ),
                            _pharmaInfo.address,
                          ];
                          Navigator.pushNamed(
                            context,
                            getDirectionPage,
                            arguments: args,
                          );
                        },
                        child: SizedBox(
                          child: SvgIcons.getDirection,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            // search and filter drugs
            IntrinsicHeight(
              child: Container(
                margin: EdgeInsets.only(top: 15.0),
                child: Text(
                  "Available Medicines",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 18.0,
                    color: Colors.blue,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            // list of drugs in the pharmacy
            Expanded(
              flex: 5,
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: FutureBuilder(
                  future: _future(),
                  builder: (BuildContext context, AsyncSnapshot snapshot) {
                    var rand = new Random();
                    List<InventoryItemDataHolder> _items = [];
                    if (snapshot.hasData) {
                      snapshot.data.forEach((PharmaInventory item) {
                        List<String> medicineGenericNames = [];
                        item.medicine.genericNames.forEach((element) {
                          medicineGenericNames.add(element.name);
                        });
                        String description = medicineGenericNames.join(", ");
                        String dosage = (item.medicine.dosage != "")
                            ? item.medicine.dosage + " "
                            : "";
                        description =
                            description + "\n$dosage${item.medicine.form}";

                        InventoryItemDataHolder holder =
                            InventoryItemDataHolder(
                          medicineName: item.medicine.brandName,
                          medicineDescription: description,
                          price: item.price.toString(),
                          isStock: (item.isStock == 1) ? true : false,
                          medicineObj: item.medicine,
                        );
                        // display only in stock medicine
                        if (item.isStock == 1) {
                          _items.add(holder);
                        }
                      });

                      if (_items.isNotEmpty) {
                        return ListView.separated(
                          shrinkWrap: true,
                          itemBuilder: (BuildContext context, int index) {
                            return InventoryItemContainer(
                              medicineName: _items[index].medicineName,
                              medicineDescription:
                                  _items[index].medicineDescription,
                              price: _items[index].price,
                              isStock: _items[index].isStock,
                              onPressed: () {
                                // reroute to medicine information page
                                Navigator.pushNamed(
                                  context,
                                  medicineInfoPage,
                                  arguments: _items[index].medicineObj,
                                );
                              },
                            );
                          },
                          separatorBuilder: (BuildContext context, int index) =>
                              const Divider(),
                          itemCount: _items.length,
                        );
                      } else {
                        return Center(
                          child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: <Widget>[
                                const Icon(
                                  Icons.sentiment_dissatisfied,
                                  color: Colors.red,
                                  size: 60,
                                ),
                                Center(
                                  child: Padding(
                                    padding: const EdgeInsets.only(top: 16),
                                    child: Text(
                                      'No medicine listed in their inventory.',
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                )
                              ]),
                        );
                      }
                    } else if (snapshot.hasError) {
                      // error encountered.
                      return Padding(
                        padding: const EdgeInsets.only(top: 10.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: CustomWidget.errorContainer(
                            errorMessage: snapshot.error.toString(),
                          ),
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
                            rand.nextInt(100).clamp(20, 100).floorToDouble();
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
                      itemCount: 5,
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(
            context,
            signInPage,
            arguments: _pharmaInfo,
          );
        },
        child: Icon(
          Icons.sms,
          color: Colors.white,
        ),
        backgroundColor: Color.fromARGB(255, 255, 108, 85),
        elevation: 10.0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(50.0),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }
}

// SEARCH AND FILTER
// Padding(
//                 padding: const EdgeInsets.fromLTRB(10, 0, 10, 5),
//                 child: Flex(
//                   direction: Axis.horizontal,
//                   children: [
//                     // search textfield
//                     Expanded(
//                       flex: 5,
//                       child: CustomWidget.textField(
//                         controller: _searchDrugController,
//                         labelText: "Search medicine",
//                         hintText: "",
//                       ),
//                     ),
//                     // filter drug
//                     Expanded(
//                       flex: 2,
//                       child: CustomWidget.outlinedButton(
//                         onPressed: () {
//                           print("Filter Clicked...");
//                         },
//                         child: SvgIcons.filterDrugs,
//                         backgroundColor: Colors.transparent,
//                         minHeight: 50.0,
//                         minWidth: 50.0,
//                         side: BorderSide(color: Colors.transparent),
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
            