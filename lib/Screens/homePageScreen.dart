import 'dart:async';
import 'package:fitness/Widgets/caloriesWidget.dart';
import 'package:fitness/Widgets/stepsWidget.dart';
import '../Screens/pillBox.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:health/health.dart';

import '../constants.dart';

class HomePageScreen extends StatefulWidget {
  static String routeName = "/homePageScreen";

  @override
  _HomePageScreenState createState() => _HomePageScreenState();
}

enum AppState {
  DATA_NOT_FETCHED,
  FETCHING_DATA,
  DATA_READY,
  NO_DATA,
  AUTH_NOT_GRANTED
}

class _HomePageScreenState extends State<HomePageScreen> {

  AppState _state = AppState.DATA_NOT_FETCHED;
  List<HealthDataPoint> _healthDataList = [];
  DateTime startDate;
  DateTime endDate;
  int walkingSteps = 0, _printWalkingSteps = 0;
  double calariesBurned = 0.0, _printCalariesBurned = 0.0;
  double _percentStep = 0.0;
  double _percentCalories = 0.0;

  final key = GlobalKey();

  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    fetchData().then((_) {
      calculateStepsAndCalories();
    });
  }

  calculateStepsAndCalories() {
    for (var i = 0; i < _healthDataList.length; i++) {
      HealthDataPoint p = _healthDataList[i];
      if (p.typeString == 'STEPS') {
        walkingSteps = walkingSteps + p.value;
      }
      if (p.typeString == 'ACTIVE_ENERGY_BURNED') {
        calariesBurned = calariesBurned + p.value;
      }
    }
    var newcalariesBurned = calariesBurned / 1000;

    print(calariesBurned);
    setState(() {
      _percentStep = (walkingSteps / 15000);
      _percentCalories = (newcalariesBurned / 100);
      _printWalkingSteps = walkingSteps;
      _printCalariesBurned = calariesBurned;
    });
  }

  Future fetchData() async {
    /// Get everything from midnight until now
    startDate = DateTime.now();
    startDate = new DateTime(startDate.year, startDate.month, startDate.day, 0, 0, 0);
    endDate = DateTime.now();

    HealthFactory health = HealthFactory();

    /// Define the types to get.
    List<HealthDataType> types = [
      HealthDataType.STEPS,
      HealthDataType.ACTIVE_ENERGY_BURNED,
    ];

    setState(() => _state = AppState.FETCHING_DATA);

    /// You MUST request access to the data types before reading them
    bool accessWasGranted = await health.requestAuthorization(types);

    int steps = 0;

    if (accessWasGranted) {
      try {
        /// Fetch new data
        List<HealthDataPoint> healthData =
        await health.getHealthDataFromTypes(startDate, endDate, types);

        /// Save all the new data points
        _healthDataList.addAll(healthData);
      } catch (e) {
        print("Caught exception in getHealthDataFromTypes: $e");
      }

      /// Filter out duplicates
      _healthDataList = HealthFactory.removeDuplicates(_healthDataList);

      /// Print the results
      _healthDataList.forEach((x) {
        print("Data point: $x");
        steps += x.value.round();
      });

      print("Steps: $steps");

      /// Update the UI to display the results
      setState(() {
        _state =
        _healthDataList.isEmpty ? AppState.NO_DATA : AppState.DATA_READY;
      });
    } else {
      print("Authorization not granted");
      setState(() => _state = AppState.DATA_NOT_FETCHED);
    }
  }

  @override
  void dispose() {
    _printWalkingSteps = 0;
    _printCalariesBurned = 0.0;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double appBarHeight = AppBar().preferredSize.height;
    double deviceHeight = MediaQuery.of(context).size.height;
    double deviceWidth = MediaQuery.of(context).size.width;
    double nameSize = deviceHeight/43;
    double _titleSize = deviceHeight/35;
    print(_titleSize);

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
                (context, index) => Padding(
                  padding: EdgeInsets.all(nameSize),
                  child: Column(
                    key: key,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      SizedBox(
                        height: appBarHeight,
                      ),
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: nameSize),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Hi\t!!!',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: _titleSize),
                            ),
                            IconButton(
                              icon: Icon(
                                Icons.notifications,
                              ),
                              onPressed: () {
                                // do something
                              },
                            ),
                          ],
                        ),
                      ),

                      SizedBox(
                        height: appBarHeight,
                      ),
                      StepsWidget(_percentStep,_printWalkingSteps),
                      SizedBox(
                        height: appBarHeight,
                      ),
                      CaloriesWidget(_percentCalories,_printCalariesBurned),
                      SizedBox(
                        height: appBarHeight,
                      ),
                      Container(
                        height: 80,
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
                                Text('Pill Box',style: TextStyle(fontWeight: FontWeight.bold),),
                                Icon(
                                  Icons.arrow_forward_ios,
                                ),
                              ],
                            ),
                          ),
                          onTap: () {
                            Navigator.of(context)
                                .pushNamed(PillBoxScreen.routeName);
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
