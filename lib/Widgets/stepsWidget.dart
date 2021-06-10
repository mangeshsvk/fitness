import 'dart:io';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';

import '../constants.dart';


class StepsWidget extends StatefulWidget {
  final double _percentSteps;
  final int _printWalkingSteps;

  StepsWidget(this._percentSteps,this._printWalkingSteps);

  @override
  _StepsWidgetState createState() => _StepsWidgetState();
}

class _StepsWidgetState extends State<StepsWidget> {


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
                      'Steps:\t',
                      style: TextStyle(fontSize: nameSize),
                    ),
                    Text(
                      widget._printWalkingSteps.toString(),
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 20),
                    ),
                  ],),),

              Container(
                width: deviceWidth*0.55,
                child: new LinearPercentIndicator(
                  width: deviceWidth *0.55,
                  animation: true,
                  lineHeight: nameSize,
                  animationDuration: 2500,
                  percent: widget._percentSteps,
                  linearStrokeCap: LinearStrokeCap.roundAll,
                  progressColor: Colors.black,
                ),
              ),
              Container(
                width:deviceWidth*0.55,child:Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('0'),
                  Text('Goal: 15,000.'),
                ],),),

            ],
          ),
          Icon(Icons.directions_walk,size: deviceWidth*0.18,),
        ],
      ),
    );
  }
}
