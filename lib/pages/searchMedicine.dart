import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:research_mobile_app/helper/utilities.dart';
import 'package:research_mobile_app/models/medicine.dart';
import 'package:research_mobile_app/request/requestMedicine.dart';
import 'package:research_mobile_app/routes.dart';

class SearchMedicine extends StatefulWidget {
  const SearchMedicine({Key? key, required this.med}) : super(key: key);
  final String med;
  @override
  _SearchMedicineState createState() => _SearchMedicineState();
}

class _SearchMedicineState extends State<SearchMedicine> {
  late String keyword;

  List<ListTile> matchFound = [];
  @override
  void initState() {
    // TODO: implement initState
    keyword = widget.med;
    super.initState();
  }

  Future<List<Medicine>> get_all_medicine() async {
    List<Medicine> data = await RequestMedicine().QueryAll();
    return data;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: Colors.black,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text(
          "$keyword",
          style: TextStyle(color: Colors.black),
        ),
        centerTitle: false,
        backgroundColor: HexColor("#A6DCEF"),
        shadowColor: Colors.transparent,
      ),
      body: FutureBuilder(
        future: get_all_medicine(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            List<Medicine>? medicines;

            medicines = snapshot.data as List<Medicine>;
            print(medicines);
            matchFound.clear();
            medicines.forEach((Medicine med) {
              if (med.brandName.toLowerCase().contains(keyword.toLowerCase())) {
                List<String> genericNames = [];
                med.genericNames.forEach((element) {
                  genericNames.add(element.name);
                });

                ListTile listTile = ListTile(
                  leading: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Icon(FontAwesomeIcons.pills),
                  ),
                  title: Text('${med.brandName}'),
                  subtitle: Text(
                    '${genericNames.join(',').toLowerCase()}',
                  ),
                  shape: Border(
                      bottom: BorderSide(
                    color: Colors.grey,
                  )),
                  onTap: () {
                    Navigator.popAndPushNamed(
                      context,
                      mapPage,
                      arguments: med,
                    );
                  },
                );

                matchFound.add(listTile);
              }
            });

            return SingleChildScrollView(
              child: Column(
                children: matchFound,
              ),
            );
          }
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: Utility.loadingCircular(),
            ),
          );
        },
      ),
    );
  }
}
