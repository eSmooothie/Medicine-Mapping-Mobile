import 'package:flutter/material.dart';
import 'package:research_mobile_app/exports.dart';

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
  late var pharmaInfo;
  TextEditingController _searchDrugController = TextEditingController();

  Widget Function(BuildContext context, AsyncSnapshot snapshot) _futureBuilder =
      (BuildContext context, AsyncSnapshot snapshot) {
    var rand = new Random();
    List<ObjectItemDataHolder> _medicineItemDataHolder = [];
    if (snapshot.hasData) {
      snapshot.data.forEach((Medicine medicine) {
        ObjectItemDataHolder medicineData = ObjectItemDataHolder(
            name: medicine.brandName,
            description: medicine.description,
            object: medicine);
        _medicineItemDataHolder.add(medicineData);
      });

      return ListView.separated(
        shrinkWrap: true,
        itemBuilder: (BuildContext context, int index) {
          return ItemContainer(
            title: _medicineItemDataHolder[index].name,
            description: _medicineItemDataHolder[index].description,
            onPressed: () {
              // reroute to pharmacy information page
              Navigator.popAndPushNamed(
                context,
                medicineInfoPage,
                arguments: _medicineItemDataHolder[index].object,
              );
            },
          );
        },
        separatorBuilder: (BuildContext context, int index) => const Divider(),
        itemCount: snapshot.data.length,
      );
    } else if (snapshot.hasError) {
      // error encountered.
      return Text("Error: ${snapshot.error}");
    }
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
      itemCount: 5,
    );
  };

  Future _future = Future.delayed(
    Duration(seconds: 3),
    () {
      return [
        new Medicine("1", "brandX", "genericX", "2", "vial", true,
            "xqwe qwe qwe qwe qw eqw eqwe qwe qwe qwe qwe qwe wq qweqwe qwe qw"),
        new Medicine("2", "brandY", "genericY", "3", "capsule", true, "y"),
        new Medicine("3", "brandZ", "genericZ", "6", "tablet", true, "z"),
        new Medicine("4", "brandXZ", "genericXZ", "16", "tablet", true, "Xz"),
        new Medicine("4", "brandYZ", "genericXZ", "16", "tablet", true, "Yz"),
        new Medicine("4", "brandZZ", "genericXZ", "16", "tablet", true, "Zz"),
      ];
    },
  );

  @override
  void dispose() {
    // TODO: implement dispose
    print("Dispose pharmacy info page.");
    _searchDrugController.dispose();
    super.dispose();
  }

  @override
  void deactivate() {
    // TODO: implement deactivate
    print("Deactivate pharmacy info page.");
    super.deactivate();
  }

  @override
  Widget build(BuildContext context) {
    setState(() {
      pharmaInfo = widget.arguments;
      // print(pharmaInfo.toString());
    });
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        leading: CustomWidget.outlinedButton(
          onPressed: () {
            List<Object> args = [
              "pharmacy",
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
        title: Text("${widget.title}"),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Flex(
          direction: Axis.vertical,
          children: [
            // pharmacy information
            Expanded(
              flex: 1,
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
                              "${pharmaInfo.name}",
                              style: TextStyle(
                                fontSize: 24.0,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          Expanded(
                            flex: 5,
                            child: Text("${pharmaInfo.address}"),
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
                        print("get direction.");
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
            Expanded(
              flex: 1,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(10, 0, 10, 5),
                child: Flex(
                  direction: Axis.horizontal,
                  children: [
                    // search textfield
                    Expanded(
                      flex: 5,
                      child: CustomWidget.textField(
                        controller: _searchDrugController,
                        labelText: "Search medicine",
                        hintText: "",
                      ),
                    ),
                    // filter drug
                    Expanded(
                      flex: 2,
                      child: CustomWidget.outlinedButton(
                        onPressed: () {
                          print("Filter Clicked...");
                        },
                        child: SvgIcons.filterDrugs,
                        backgroundColor: Colors.transparent,
                        minHeight: 50.0,
                        minWidth: 50.0,
                        side: BorderSide(color: Colors.transparent),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            // list of drugs in the pharmacy
            Expanded(
              flex: 5,
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: FutureBuilder(
                  future: _future,
                  builder: _futureBuilder,
                ),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          print("chat");
        },
        child: Icon(
          Icons.sms,
          color: Colors.blue,
        ),
        backgroundColor: Colors.white,
        elevation: 10.0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(50.0),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }
}
