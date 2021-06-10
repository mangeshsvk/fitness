import 'dart:async';
import 'package:fitness/Providers/medicines.dart';
import 'package:fitness/Widgets/listOfPillsWidget.dart';
import 'package:fitness/Widgets/pillNotAvailableWidget.dart';
import 'package:provider/provider.dart';

import '../Providers/medicine.dart';
import '../Screens/addMedicationScreen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../constants.dart';

class PillBoxScreen extends StatefulWidget {
  static String routeName = "/pillBoxScreen";

  @override
  _PillBoxScreenState createState() => _PillBoxScreenState();
}

class _PillBoxScreenState extends State<PillBoxScreen> {
  bool _isPillsAvailable = false;
  String newString = '';
  List<Medicine> _medicineList = [];

  @override
  void initState() {
   getMedicineData();
    super.initState();
  }

Future<void> getMedicineData()async{
  await Provider.of<Medicines>(context,listen: false).fetchAndSetMedicines();
  _medicineList = Provider.of<Medicines>(context,listen: false).items;
  if(_medicineList.length>0){
    setState(() {
      _isPillsAvailable = true;
    });
  }
}

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double appBarHeight = AppBar().preferredSize.height;
    double deviceHeight = MediaQuery.of(context).size.height;
    double deviceWidth = MediaQuery.of(context).size.width;
    double nameSize = deviceHeight / 43;
    double _titleSize = deviceHeight / 35;
    print(_titleSize);

    return new Scaffold(
      body: SafeArea(
        top: false,
        left: false,
        right: false,
        child: CustomScrollView(
          // Add the app bar and list of items as slivers in the next steps.
          slivers: <Widget>[
            SliverAppBar(
              title: Text(
                'Pill Box',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              elevation: 0,
            ),
            SliverList(
              // Use a delegate to build items as they're scrolled on screen.
              delegate: SliverChildBuilderDelegate(
                // The builder function returns a ListTile with a title that
                // displays the index of the current item.
                (context, index) => Padding(
                  padding: EdgeInsets.all(nameSize),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[

                      Container(
                        height: deviceHeight / 4.25,
                        width: deviceHeight / 4.25,
                        child: Center(
                          child: Icon(
                            Icons.medical_services,
                            size: deviceHeight / 5.66,
                            color: Colors.green,
                          ),
                        ),
                      ),
                      !_isPillsAvailable
                          ? PillNotAvailableWidget()
                          : Container(),
                      _isPillsAvailable
                          ? DisplayPillsList(_medicineList): Container(),
                      Container(
                        height: nameSize * 4,
                        padding: EdgeInsets.all(nameSize),
                        decoration: BoxDecoration(
                            color: kPrimaryColor,
                            borderRadius:
                                BorderRadius.all(Radius.circular(nameSize))),
                        child: GestureDetector(
                          child: InkWell(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text('Add New Medication'),
                                Icon(
                                  Icons.arrow_forward_ios,
                                ),
                              ],
                            ),
                          ),
                          onTap: () {
                            Navigator.of(context)
                                .pushNamed(AddMedicationScreen.routeName);
                          },
                        ),
                      ),
                    ],
                  ),
                ),
                // Builds 1000 ListTiles
                childCount: 1,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
