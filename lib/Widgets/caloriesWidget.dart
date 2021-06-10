import 'dart:io';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';

import '../constants.dart';


class CaloriesWidget extends StatefulWidget {
  final double _percentCalories;
  final double _printCalariesBurned;

  CaloriesWidget(this._percentCalories,this._printCalariesBurned);

  @override
  _CaloriesWidgetState createState() => _CaloriesWidgetState();
}

class _CaloriesWidgetState extends State<CaloriesWidget> {


  @override
  Widget build(BuildContext context) {

    double appBarHeight = AppBar().preferredSize.height;
    double deviceHeight = MediaQuery.of(context).size.height;
    double deviceWidth = MediaQuery.of(context).size.width;
    double nameSize = deviceHeight/43;
    double _titleSize = deviceHeight/35;

    return Container(
      height: deviceHeight/5.66,
      padding: EdgeInsets.all(nameSize),
      decoration: BoxDecoration(
          color: kPrimaryColor,
          borderRadius:
          BorderRadius.all(Radius.circular(nameSize))),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Container(
                width:deviceWidth*0.55,
                child:Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(
                      'Calories Burned:\t',
                      style: TextStyle(fontSize: nameSize),
                    ),
                    Text(
                      widget._printCalariesBurned.round().toString(),
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: nameSize),
                    ),
                  ],),),

              Container(
                width: deviceWidth*0.55,
                child: new LinearPercentIndicator(
                  width: deviceWidth *0.55,
                  animation: true,
                  lineHeight: nameSize,
                  animationDuration: 2500,
                  percent: widget._percentCalories,
                  linearStrokeCap: LinearStrokeCap.roundAll,
                  progressColor: Colors.black,
                ),
              ),
              Container(
                width:deviceWidth*0.55,child:Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('0'),
                  Text('Goal: 1,000.'),
                ],),),
            ],
          ),
          Icon(Icons.local_fire_department_rounded,size: deviceWidth*0.18,),
        ],
      ),
    );
  }
}
