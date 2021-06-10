import 'dart:async';
import '../Screens/homePageScreen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SplashScreen extends StatefulWidget {
  static String routeName = "/splashScreen";

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {

  bool _showAppName = false;
  double _width = 50;
  double _height = 50;
  Color _color = Colors.green;
  BorderRadiusGeometry _borderRadius = BorderRadius.circular(8);
  bool selected = false;
  double deviceHeight;
  double deviceWidth;


  @override
  void initState() {

    Timer(Duration(seconds: 3), () {
      Navigator.of(context).pushReplacementNamed(HomePageScreen.routeName);
    });
    Timer(Duration(seconds: 1), () {
      setState(() {
        selected = !selected;
      });
      setState(() {
        _showAppName = true;
      });
    });
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }



  @override
  Widget build(BuildContext context) {

    deviceHeight = MediaQuery.of(context).size.height;
    deviceWidth = MediaQuery.of(context).size.width;
    print(deviceHeight);
    double nameSize = deviceHeight/40;

    return new Scaffold(
      body: SafeArea(
        top: false,
        left: false,
        right: false,
        child: CustomScrollView(
          // Add the app bar and list of items as slivers in the next steps.
          slivers: <Widget>[
            SliverList(
              // Use a delegate to build items as they're scrolled on screen.
              delegate: SliverChildBuilderDelegate(
                // The builder function returns a ListTile with a title that
                // displays the index of the current item.
                (context, index) => Column(
                  mainAxisAlignment:MainAxisAlignment.center,
                  children: <Widget>[
                    SizedBox(height: deviceHeight*0.1,),
                    Center(child:AnimatedContainer(
                      width: selected ? deviceHeight*0.5 : deviceHeight*0.25,
                      height: selected ? deviceHeight*0.5 : deviceHeight*0.25,
                      alignment:
                      selected ? Alignment.center : AlignmentDirectional.topCenter,
                      duration: const Duration(seconds: 1,milliseconds: 50),
                      curve: Curves.fastOutSlowIn,
                      child: Icon(Icons.accessibility,size: deviceHeight/4.2,color: selected?Colors.green:Colors.red,),
                    ),),
                    _showAppName
                        ? Center(
                            child: Container(
                              child: Text('Fitness Application',style: TextStyle(fontWeight: FontWeight.bold,fontSize: nameSize),),
                            ),
                          )
                        : Container(),
                  ],
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
