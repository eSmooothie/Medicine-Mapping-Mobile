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
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Row(
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
          ],
        ),
      ),
    );
  }
}
