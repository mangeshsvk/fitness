import 'dart:io';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';

import '../constants.dart';


class PillNotAvailableWidget extends StatelessWidget {


  @override
  Widget build(BuildContext context) {

    double appBarHeight = AppBar().preferredSize.height;
    double deviceHeight = MediaQuery.of(context).size.height;
    double deviceWidth = MediaQuery.of(context).size.width;
    double nameSize = deviceHeight/43;
    double _titleSize = deviceHeight/35;

    return Container(
      padding: EdgeInsets.all(nameSize * 2),
      child: Center(
          child: Column(
            mainAxisAlignment:
            MainAxisAlignment.spaceEvenly,
            children: [
              Center(
                child: Text(
                  'Welcome to Pill Box, here you can add your medication and set a reminder for them.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: nameSize,
                  ),
                ),
              ),
              SizedBox(
                height: appBarHeight,
              ),
              Center(
                child: Text(
                  'Let\'s Start with adding your first medication.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: nameSize,
                  ),
                ),
              ),
            ],
          )),
    );
  }
}
