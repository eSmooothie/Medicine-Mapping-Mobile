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
  TextEditingController _searchController = TextEditingController();

  Widget Function(BuildContext context, AsyncSnapshot snapshot) futureBuilder =
      (BuildContext context, AsyncSnapshot snapshot) {
    var rand = new Random();
    List<Widget> widgets = [];

    if (snapshot.hasData) {
      // done loading

      return ListView.separated(
        shrinkWrap: true,
        itemBuilder: (BuildContext context, int index) {
          return SearchItemContainer(
            title: snapshot.data[index].brandName,
            description: snapshot.data[index].description,
          );
        },
        separatorBuilder: (BuildContext context, int index) => const Divider(),
        itemCount: snapshot.data.length,
      );
    } else if (snapshot.hasError) {
      // error encountered.
      return Text("Error: ${snapshot.error}");
    }

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

  Future future = Future.delayed(
    Duration(seconds: 10),
    () => [
      new Medicine("1", "brandX", "genericX", "2", "vial", true,
          "xqwe qwe qwe qwe qw eqw eqwe qwe qwe qwe qwe qwe wq qweqwe qwe qw"),
      new Medicine("2", "brandY", "genericY", "3", "capsule", true, "y"),
      new Medicine("3", "brandZ", "genericZ", "6", "tablet", true, "z"),
      new Medicine("4", "brandXZ", "genericXZ", "16", "tablet", true, "Xz"),
      new Medicine("4", "brandYZ", "genericXZ", "16", "tablet", true, "Yz"),
      new Medicine("4", "brandZZ", "genericXZ", "16", "tablet", true, "Zz"),
    ],
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
                  future: future,
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
