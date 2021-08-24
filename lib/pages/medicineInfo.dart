import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:research_mobile_app/exportHelper.dart';
import 'package:research_mobile_app/exportModel.dart';

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

  Widget Function(BuildContext context, AsyncSnapshot snapshot) _futureBuilder =
      (BuildContext context, AsyncSnapshot snapshot) {
    var rand = new Random();
    List<ObjectItemDataHolder> _pharmacyItemDataHolder = [];
    if (snapshot.hasData) {
      Medicine medicineObj = snapshot.data['medicineData'];
      List<Pharmacy> pharmacies = snapshot.data['pharmacies'];
      pharmacies.forEach((Pharmacy pharmacy) {
        ObjectItemDataHolder pharmaData = ObjectItemDataHolder(
            name: pharmacy.name,
            description: pharmacy.address,
            object: pharmacy);
        _pharmacyItemDataHolder.add(pharmaData);
      });

      return ListView.separated(
        shrinkWrap: true,
        itemBuilder: (BuildContext context, int index) {
          return ItemContainer(
            title: _pharmacyItemDataHolder[index].name,
            description: _pharmacyItemDataHolder[index].description,
            onPressed: () {
              // reroute to pharmacy information page
              Map<String, Object> args = {
                'from': medicineInfoPage,
                'pharmacy': _pharmacyItemDataHolder[index].object,
                'medicine': medicineObj,
              };
              Navigator.pushNamed(
                context,
                pharmacyInfoPage,
                arguments: args,
              );
            },
          );
        },
        separatorBuilder: (BuildContext context, int index) => const Divider(),
        itemCount: pharmacies.length,
      );
    } else if (snapshot.hasError) {}

    // display skeleton animation while waiting for the data
    return ListView.separated(
      shrinkWrap: true,
      itemBuilder: (BuildContext context, int index) {
        double titleWidth = rand.nextInt(200).clamp(50, 200).floorToDouble();
        double descHeight = rand.nextInt(100).clamp(20, 100).floorToDouble();
        return ItemContainerSkeleton(
          titleWidth: titleWidth,
          descHeight: descHeight,
        );
      },
      separatorBuilder: (BuildContext context, int index) => const Divider(),
      itemCount: 7,
    );
  };

  Future<Map<String, Object>> _future(var medicineObj) async {
    Map<String, Object> data = {
      'medicineData': medicineObj,
    };

    List<Pharmacy> pharmacies = [
      new Pharmacy("1", "21312", "xx", "qwe", "qw3e123"),
      new Pharmacy("2", "213qwe12", "xx", "qwqqqe", "qw3e123"),
    ];

    data['pharmacies'] = pharmacies;
    return data;
  }

  @override
  void dispose() {
    // TODO: implement dispose
    print("Dispose medicine Info page.");
    super.dispose();
  }

  @override
  void deactivate() {
    // TODO: implement deactivate
    print("Deactivate medicine Info page.");
    super.deactivate();
  }

  @override
  Widget build(BuildContext context) {
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
    return Scaffold(
      appBar: AppBar(
        leading: CustomWidget.outlinedButton(
          onPressed: () {
            List<Object> args = [
              "medicine",
            ];
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
              Flex(
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
                          padding: EdgeInsets.fromLTRB(10, 10, 10, 0),
                          child: Text(
                            "${drugInfo.brandName}",
                            style: TextStyle(
                              fontSize: 24.0,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.fromLTRB(10, 0, 0, 10),
                          child: Text(
                            "$genericNames",
                            style: TextStyle(
                              fontSize: 14.0,
                              fontWeight: FontWeight.normal,
                            ),
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.only(left: 10),
                          child: Text(
                            "Classification:",
                            style: TextStyle(
                              fontSize: 14.0,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.fromLTRB(10, 0, 0, 10),
                          child: Text(
                            "$classification",
                            style: TextStyle(
                              fontSize: 14.0,
                              fontWeight: FontWeight.normal,
                            ),
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.only(left: 10.0),
                          child: Text(
                            "Packaging:",
                            style: TextStyle(
                              fontSize: 14.0,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.only(left: 10.0),
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
                            "XXX,XXX.XX",
                            style: TextStyle(
                              fontSize: 24.0,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text("PHP"),
                        ],
                      )),
                ],
              ),
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: FutureBuilder(
                  future: _future(drugInfo),
                  builder: _futureBuilder,
                ),
              ),
            ]),
          ),
        ],
      ),
    );
  }
}
