import 'package:flutter/material.dart';
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

  Widget Function(BuildContext context, AsyncSnapshot snapshot) futureBuilder =
      (BuildContext context, AsyncSnapshot snapshot) {
    var rand = new Random();
    List<SearchItemDataHolder> _searchItemDataHolder = [];
    if (snapshot.hasData) {
      // done loading

      // check data object type
      // and map each object
      if (snapshot.data is List<Medicine>) {
        snapshot.data.forEach((Medicine medicine) {
          String desc = medicine.description;
          SearchItemDataHolder drugData =
              SearchItemDataHolder(name: medicine.brandName, description: desc);

          _searchItemDataHolder.add(drugData);
        });
      } else if (snapshot.data is List<Pharmacy>) {
        snapshot.data.forEach((Pharmacy pharmacy) {
          SearchItemDataHolder pharmaData = SearchItemDataHolder(
            name: pharmacy.name,
            description: pharmacy.address,
          );
          _searchItemDataHolder.add(pharmaData);
        });
      }

      return ListView.separated(
        shrinkWrap: true,
        itemBuilder: (BuildContext context, int index) {
          return SearchItemContainer(
            title: _searchItemDataHolder[index].name,
            description: _searchItemDataHolder[index].description,
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
        return SearchItemContainerSkeleton(
          titleWidth: titleWidth,
          descHeight: descHeight,
        );
      },
      separatorBuilder: (BuildContext context, int index) => const Divider(),
      itemCount: 7,
    );
  };

  Future futureMedicine = Future.delayed(
    Duration(seconds: 10),
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

  Future futurePharma = Future.delayed(
    Duration(seconds: 10),
    () {
      return [
        new Pharmacy(1, 9.0000, 214.2123, "PharmaX", "AddressX"),
      ];
    },
  );

  @override
  void dispose() {
    // TODO: implement dispose
    _searchController.dispose();
    super.dispose();
  }

  @override
  void deactivate() {
    // TODO: implement deactivate
    print("Deactive Search page.");
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
              "/",
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
    );
  }
}

class SearchItemDataHolder {
  final String name;
  final String description;
  SearchItemDataHolder({required this.name, required this.description});
}
