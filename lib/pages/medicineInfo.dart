import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:research_mobile_app/exportHelper.dart';
import 'package:research_mobile_app/exportModel.dart';
import 'package:research_mobile_app/exportRequest.dart';

class MedicineInfo extends StatefulWidget {
  const MedicineInfo({Key? key, required this.title, this.arguments})
      : super(key: key);
  final String title;
  final Object? arguments;
  @override
  _MedicineInfoState createState() => _MedicineInfoState();
}

class _MedicineInfoState extends State<MedicineInfo> {
  late var args;
  late Medicine drugInfo;
  late String genericNames;
  late String classification;
  double averagePrice = 0.0;

  /**
   * get list of pharmacy offer the medicine
   */
  Future _future() async {
    List<MedicinePharmacy> result = await RequestMedicine().getPharmacies(
      id: drugInfo.id,
    );
    return result;
  }

  Future getAveragePrice() async {
    double avgPrice = await RequestMedicine().getAveragePrice(
      id: drugInfo.id,
    );

    setState(() {
      averagePrice = avgPrice;
    });

    await Future.delayed(Duration(seconds: 3));
  }

  Future addDataToMedicineTrend() async {
    print("adding to trend");
    await RequestMedicine().addToTrend(id: drugInfo.id);
  }

  @override
  void dispose() {
    print("Dispose medicine Info page.");
    super.dispose();
  }

  @override
  void deactivate() {
    print("Deactivate medicine Info page.");
    super.deactivate();
  }

  @override
  void initState() {
    super.initState();

    setState(() {
      args = widget.arguments;
      if (args is Medicine) {
        drugInfo = args;
        List<String> medicineGenericNames = [];
        drugInfo.genericNames.forEach((element) {
          medicineGenericNames.add(element.name);
        });
        genericNames = medicineGenericNames.join(", ").toUpperCase();

        List<String> generalClassificationNames = [];
        drugInfo.medicineClassification.forEach((element) {
          generalClassificationNames.add(element.generalClassificationName);
        });
        classification = generalClassificationNames.join(", ").toUpperCase();
        // print(drugInfo);
      }
    });
    getAveragePrice();
    addDataToMedicineTrend();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
        title: Text(widget.title),
        centerTitle: true,
      ),
      body: CustomScrollView(
        slivers: [
          SliverList(
            delegate: SliverChildListDelegate([
              Container(
                margin: EdgeInsets.all(10),
                padding: EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(
                    color: Colors.blue,
                  ),
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: <BoxShadow>[
                    BoxShadow(
                      color: Colors.blue.shade400,
                      blurRadius: 3.0,
                      spreadRadius: 1.0,
                    ),
                  ],
                ),
                child: Flex(
                  direction: Axis.horizontal,
                  children: [
                    Expanded(
                      flex: 5,
                      child: Flex(
                        direction: Axis.vertical,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            child: Text(
                              "${drugInfo.brandName}",
                              style: TextStyle(
                                fontSize: 24.0,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          Container(
                            child: Text(
                              "$genericNames",
                              style: TextStyle(
                                fontSize: 14.0,
                                fontWeight: FontWeight.normal,
                              ),
                            ),
                          ),
                          Container(
                            child: Text(
                              "${drugInfo.category}",
                              style: TextStyle(
                                fontSize: 14.0,
                                fontWeight: FontWeight.normal,
                              ),
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.only(top: 10.0),
                            child: Text(
                              "Classification:",
                              style: TextStyle(
                                fontSize: 14.0,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          Container(
                            child: Text(
                              "$classification",
                              style: TextStyle(
                                fontSize: 14.0,
                                fontWeight: FontWeight.normal,
                              ),
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.only(top: 10.0),
                            child: Text(
                              "Packaging:",
                              style: TextStyle(
                                fontSize: 14.0,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          Container(
                            child: Text(
                              "${drugInfo.dosage}\t${drugInfo.form}",
                              style: TextStyle(
                                fontSize: 14.0,
                                fontWeight: FontWeight.normal,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                        flex: 2,
                        child: Flex(
                          direction: Axis.vertical,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "P$averagePrice",
                              style: TextStyle(
                                fontSize: 24.0,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text("Average Price"),
                          ],
                        )),
                  ],
                ),
              ),
              Container(
                margin: EdgeInsets.only(top: 15.0),
                child: Text(
                  "Pharmacies",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 18.0,
                    color: Colors.blue,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: FutureBuilder(
                  future: _future(),
                  builder: (BuildContext context, AsyncSnapshot snapshot) {
                    var rand = new Random();
                    List<PharmacyMedicineDataHolder> _pharmacyItemDataHolder =
                        [];
                    if (snapshot.hasData) {
                      List<MedicinePharmacy> pharmacies = snapshot.data;
                      pharmacies.forEach((item) {
                        PharmacyMedicineDataHolder holder =
                            PharmacyMedicineDataHolder(
                          pharmacyName: item.pharmacy.name,
                          pharmacyAddress: item.pharmacy.address,
                          price: item.price,
                          isStock: item.isStock,
                          pharmacyObj: item.pharmacy,
                        );

                        _pharmacyItemDataHolder.add(holder);
                      });

                      if (pharmacies.isNotEmpty) {
                        return ListView.separated(
                          physics: NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          itemBuilder: (BuildContext context, int index) {
                            return PharmaMedicineItemContainer(
                                pharmacyName:
                                    _pharmacyItemDataHolder[index].pharmacyName,
                                pharmacyAddress: _pharmacyItemDataHolder[index]
                                    .pharmacyAddress,
                                price: _pharmacyItemDataHolder[index].price,
                                isStock: _pharmacyItemDataHolder[index].isStock,
                                onPressed: () {
                                  Map<String, Object> args = {
                                    'pharmacy': _pharmacyItemDataHolder[index]
                                        .pharmacyObj,
                                  };
                                  // reroute to pharmacyinfo

                                  Navigator.pushNamed(
                                    context,
                                    pharmacyInfoPage,
                                    arguments: args,
                                  );
                                });
                          },
                          separatorBuilder: (BuildContext context, int index) =>
                              const Divider(),
                          itemCount: _pharmacyItemDataHolder.length,
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
                                      'No pharmacy offer this medicine.',
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                )
                              ]),
                        );
                      }
                    } else if (snapshot.hasError) {
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
            ]),
          ),
        ],
      ),
    );
  }
}
