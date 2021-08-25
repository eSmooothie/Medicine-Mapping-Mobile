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
            Text("${detail.TYPE}: "),
            Text("${detail.DETAIL}"),
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
              child: Flex(
                direction: Axis.horizontal,
                children: [
                  // pharmacy information
                  Expanded(
                    flex: 5,
                    child: Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Flex(
                        direction: Axis.vertical,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            margin: EdgeInsets.only(top: 20.0),
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
            // search and filter drugs
            IntrinsicHeight(
              child: Container(
                width: MediaQuery.of(context).size.width - 21,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10.0),
                ),
                margin: EdgeInsets.fromLTRB(5, 15, 5, 15),
                alignment: Alignment.centerLeft,
                child: Text(
                  "List of medicine available",
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
                        description = description +
                            "\n${item.medicine.dosage} ${item.medicine.form}";

                        InventoryItemDataHolder holder =
                            InventoryItemDataHolder(
                          medicineName: item.medicine.brandName,
                          medicineDescription: description,
                          price: item.price.toString(),
                          isStock: (item.isStock == 1) ? true : false,
                          medicineObj: item.medicine,
                        );

                        _items.add(holder);
                      });

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
                    } else if (snapshot.hasError) {
                      // error encountered.
                      return Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
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
        backgroundColor: Colors.blue,
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
            