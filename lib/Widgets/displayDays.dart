import 'dart:io';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';

import '../constants.dart';


class DisplayDaysWidget extends StatefulWidget {
  final bool _isWeekly;
  final bool _isMonthly;
  List<String> _selectedDays = [];
  List<String> _selectedList = [];

  DisplayDaysWidget(this._isWeekly,this._isMonthly,this._selectedDays,this._selectedList);

  @override
  _DisplayDaysWidgetState createState() => _DisplayDaysWidgetState();
}

class _DisplayDaysWidgetState extends State<DisplayDaysWidget> {


  @override
  Widget build(BuildContext context) {

    double appBarHeight = AppBar().preferredSize.height;
    double deviceHeight = MediaQuery.of(context).size.height;
    double deviceWidth = MediaQuery.of(context).size.width;
    double nameSize = deviceHeight/43;
    double _titleSize = deviceHeight/35;

    return Container(
        width: deviceWidth,
        height: deviceHeight * 0.042,
        child: ListView.builder(
          padding: EdgeInsets.symmetric(
              horizontal: nameSize / 4),
          itemCount: widget._isWeekly ? 7 : 2,
          scrollDirection: Axis.horizontal,
          itemBuilder: (context, index) {
            if (widget._isWeekly == true) {
              widget._selectedList = [
                'Mon',
                'Tue',
                'Wed',
                'Thu',
                'Fri',
                'Sat',
                'Sun'
              ];
            }
            if (widget._isMonthly == true) {
              widget._selectedList = [
                'Once a Week',
                'Twice a Week'
              ];
            }

            return Row(
              children: [
                GestureDetector(
                  child: Container(
                    padding: EdgeInsets.symmetric(
                        horizontal: nameSize / 2.3),
                    decoration: BoxDecoration(
                      color: widget._selectedDays.contains(
                          widget._selectedList[index])
                          ? Colors.black
                          : Colors.grey,
                      borderRadius: BorderRadius.all(
                          Radius.circular(nameSize / 4)),
                    ),
                    child: Center(
                      child: Text(
                        widget._selectedList[index],
                        style: TextStyle(
                            color: Colors.white),
                      ),
                    ),
                  ),
                  onTap: () {
                    setState(() {
                      if(widget._selectedDays.contains(widget._selectedList[index])){
                        widget._selectedDays.remove(widget._selectedList[index]);
                      }else{
                        widget._selectedDays.add(widget._selectedList[index]);
                      }
                    });
                  },
                ),
                SizedBox(
                  width: nameSize/2,
                )
              ],
            );
          },
        ));
  }
}
