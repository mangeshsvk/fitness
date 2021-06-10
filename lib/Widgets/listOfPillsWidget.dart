import 'dart:io';
import 'package:fitness/Providers/medicine.dart';
import 'package:fitness/Providers/medicines.dart';
import 'package:fitness/Screens/pillBox.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';

import '../constants.dart';


class DisplayPillsList extends StatefulWidget {

  List<Medicine> _medicineList;

  DisplayPillsList(this._medicineList);

  @override
  _DisplayPillsListState createState() => _DisplayPillsListState();
}

class _DisplayPillsListState extends State<DisplayPillsList> {


  @override
  Widget build(BuildContext context) {

    double appBarHeight = AppBar().preferredSize.height;
    double deviceHeight = MediaQuery.of(context).size.height;
    double deviceWidth = MediaQuery.of(context).size.width;
    double nameSize = deviceHeight/43;
    double _titleSize = deviceHeight/35;

    return Column(children: [
      Container(
          alignment: Alignment.centerLeft,
          child: Text('Added Medicine :')),
      SizedBox(
        height: nameSize / 4,
      ),
      Container(
          height: deviceHeight * 0.353,
          child: Consumer<Medicines>(
              builder: (ctx, medicineData, _) {

                widget._medicineList = medicineData.items;

                return ListView.builder(
                  itemCount: widget._medicineList.length,
                  scrollDirection: Axis.vertical,
                  physics: NeverScrollableScrollPhysics(),
                  itemBuilder: (context, index) {
                    print(widget._medicineList);
                    return InkWell(
                      highlightColor: kPrimaryColor,
                      child: ListTile(
                        title: Text(
                          widget._medicineList[index].medicineName,
                          style: TextStyle(color: Colors.black),
                        ),
                        trailing: Icon(Icons.arrow_forward_ios),
                      ),
                      onTap: (){
                        showModalBottomSheet(
                            enableDrag: false,
                            context: context,
                            builder: (BuildContext
                            context) {
                              return SingleChildScrollView(
                                  child: Container(
                                      padding: EdgeInsets
                                          .symmetric(
                                          horizontal:
                                          nameSize),
                                      height:
                                      deviceHeight *
                                          0.5,
                                      child: Column(
                                        mainAxisAlignment:
                                        MainAxisAlignment
                                            .spaceEvenly,
                                        crossAxisAlignment:
                                        CrossAxisAlignment
                                            .start,
                                        children: [
                                          Text(
                                              'Update Timing'),

                                          Container(
                                            decoration: BoxDecoration(
                                                color: Colors
                                                    .black,
                                                borderRadius:
                                                BorderRadius.all(Radius.circular(nameSize / 4))),
                                            child:
                                            Center(
                                              child:
                                              TextButton(
                                                onPressed:
                                                    () {
                                                  Provider.of<Medicines>(context, listen: false).deleteProduct(widget._medicineList[index]);
                                                  Navigator.of(context).pop();
                                                  Navigator.of(context).pushReplacementNamed(PillBoxScreen.routeName);
                                                },
                                                child:
                                                Text(
                                                  'Delete Medicine',
                                                  textAlign:
                                                  TextAlign.center,
                                                  style:
                                                  TextStyle(color: Colors.white),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      )));
                            });
                      },
                    );
                  },
                );
              }))
    ],);
  }
}
