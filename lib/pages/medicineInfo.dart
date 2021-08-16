import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:research_mobile_app/exports.dart';

class MedicineInfo extends StatefulWidget {
  const MedicineInfo({Key? key, required this.title, this.arguments})
      : super(key: key);
  final String title;
  final Object? arguments;
  @override
  _MedicineInfoState createState() => _MedicineInfoState();
}

class _MedicineInfoState extends State<MedicineInfo> {
  late var drugInfo;

  Widget Function(BuildContext context, AsyncSnapshot snapshot) _futureBuilder =
      (BuildContext context, AsyncSnapshot snapshot) {
    var rand = new Random();
    List<ObjectItemDataHolder> _pharmacyItemDataHolder = [];
    if (snapshot.hasData) {
      snapshot.data.forEach((Pharmacy pharmacy) {
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
              Navigator.popAndPushNamed(
                context,
                pharmacyInfoPage,
                arguments: _pharmacyItemDataHolder[index].object,
              );
            },
          );
        },
        separatorBuilder: (BuildContext context, int index) => const Divider(),
        itemCount: snapshot.data.length,
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

  Future _future = Future.delayed(Duration(seconds: 5), () {
    return [
      new Pharmacy(1, 9.0000, 214.2123, "PharmaX", "AddressX"),
    ];
  });

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
      drugInfo = widget.arguments;
    });
    return Scaffold(
      appBar: AppBar(
        leading: CustomWidget.outlinedButton(
          onPressed: () {
            List<Object> args = [
              "medicine",
            ];
            Navigator.popAndPushNamed(
              context,
              searchPage,
              arguments: args,
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
        centerTitle: true,
      ),
      body: SafeArea(
          child: Container(
        child: Flex(
          direction: Axis.vertical,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              flex: 1,
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
                          padding: EdgeInsets.all(10.0),
                          child: Text(
                            "${drugInfo.brandName}",
                            style: TextStyle(
                              fontSize: 24.0,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.all(10.0),
                          child: Text(
                            "${drugInfo.description}",
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
            ),
            Expanded(
              flex: 5,
              child: Container(
                padding: EdgeInsets.fromLTRB(10.0, 5.0, 10.0, 5.0),
                child: FutureBuilder(
                  future: _future,
                  builder: _futureBuilder,
                ),
              ),
            ),
          ],
        ),
      )),
    );
  }
}
