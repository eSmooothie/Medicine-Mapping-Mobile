import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:research_mobile_app/exports.dart';

class Search extends StatefulWidget {
  const Search({Key? key, required this.title, this.arguments})
      : super(key: key);
  final String title;
  final Object? arguments;
  @override
  _SearchState createState() => _SearchState();
}

class _SearchState extends State<Search> {
  late String searchBy;
  TextEditingController _searchController = TextEditingController();

  // future builder
  Widget Function(BuildContext context, AsyncSnapshot snapshot) futureBuilder =
      (BuildContext context, AsyncSnapshot snapshot) {
    var rand = new Random();
    List<ObjectItemDataHolder> _searchItemDataHolder = [];
    if (snapshot.hasData) {
      // done loading

      // check data object type
      // and map each object
      if (snapshot.data is List<Medicine>) {
        snapshot.data.forEach((Medicine medicine) {
          String desc =
              "${medicine.genericName}\n${medicine.dosage} ${medicine.dosageForm}";
          ObjectItemDataHolder drugData = ObjectItemDataHolder(
            name: medicine.brandName,
            description: desc.toUpperCase(),
            object: medicine,
          );

          _searchItemDataHolder.add(drugData);
        });
      } else if (snapshot.data is List<Pharmacy>) {
        snapshot.data.forEach((Pharmacy pharmacy) {
          ObjectItemDataHolder pharmaData = ObjectItemDataHolder(
              name: pharmacy.name,
              description: pharmacy.address,
              object: pharmacy);
          _searchItemDataHolder.add(pharmaData);
        });
      }

      return ListView.separated(
        shrinkWrap: true,
        itemBuilder: (BuildContext context, int index) {
          return ItemContainer(
            title: _searchItemDataHolder[index].name,
            description: _searchItemDataHolder[index].description,
            onPressed: () {
              // reroute to their desire information page
              // evaluate the obj of searchItemDataHolder
              if (_searchItemDataHolder[index].object is Medicine) {
                // reroute to medicine information page
                Navigator.pushNamed(
                  context,
                  medicineInfoPage,
                  arguments: _searchItemDataHolder[index].object,
                );
              } else if (_searchItemDataHolder[index].object is Pharmacy) {
                // reroute to pharmacy information page
                Map<String, Object> args = {
                  'from': searchPage,
                  'pharmacy': _searchItemDataHolder[index].object,
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
      itemCount: 7,
    );
  };

  // future medicine
  Future futureMedicine = Future(() async {
    return await MyHttpRequest().QueryAllMedicine();
  });

  // future pharmacy
  Future futurePharma = Future.delayed(
    Duration(seconds: 4),
    () {
      return [
        new Pharmacy(1, 9.0000, 214.2123, "PharmaX", "AddressX"),
      ];
    },
  );

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
      searchBy = widget.arguments.toString();
      searchBy = searchBy.substring(1, searchBy.length - 1);
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
      ),
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
                      ),
                    ),
                    Flexible(
                      flex: 1,
                      fit: FlexFit.tight,
                      child: CustomWidget.outlinedButton(
                        onPressed: () {
                          print("Filter Clicked...");
                        },
                        child: Icon(Icons.filter_alt_rounded),
                        backgroundColor: Colors.transparent,
                        minHeight: 50.0,
                        minWidth: 50.0,
                        side: BorderSide(color: Colors.transparent),
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                flex: 5,
                child: FutureBuilder(
                  future:
                      (searchBy == 'pharmacy') ? futurePharma : futureMedicine,
                  builder: futureBuilder,
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
}
