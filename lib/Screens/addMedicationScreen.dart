import 'package:fitness/Providers/medicine.dart';
import 'package:fitness/Providers/medicines.dart';
import 'package:fitness/Screens/pillBox.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../Providers/timeslot.dart';
import '../Providers/timeslots.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../constants.dart';
import '../size_config.dart';
import 'package:flutter_time_picker_spinner/flutter_time_picker_spinner.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'dart:async';

class AddMedicationScreen extends StatefulWidget {
  static String routeName = "/addMedicationScreen";

  @override
  _AddMedicationScreenState createState() => _AddMedicationScreenState();
}

class _AddMedicationScreenState extends State<AddMedicationScreen> {

  TextEditingController _medicineTitle = TextEditingController();
  TextEditingController _slotNameController = TextEditingController();

  bool _isWeekly = false;
  bool _isMonthly = false;
  List<String> _selectedList = [];
  List<String> _selectedTimeSlots = [];
  List<TimeSlot> _loadedTimeSlots = [];
  DateTime selectedDate = DateTime.now();
  String newSelectedDate = 'Not Selected';
  DateTime _dateTime = DateTime.now();
  bool firstTime = false;
  var _newTimeSlot = TimeSlot(
    slotId: '',
    slotName: '',
    slotTime: '',
  );
  List<String> _selectedDays = [];
  List<String> _selectedTimes = [];

  Medicine _newMedicine = new Medicine(medicineId: DateTime.now().toIso8601String(), medicineName: '', medicineSchedule: [], medicineDays: []);

  Future<void> _selectDate(BuildContext context) async {
    final DateTime picked = await showDatePicker(
        context: context,
        initialDate: selectedDate,
        firstDate: DateTime(1950, 8),
        lastDate: DateTime(2101));
    if (picked != null && picked != selectedDate) {
      setState(() {
        newSelectedDate = new DateFormat("d MMMM").format(picked);
      });
    }
  }

  Future checkFirstSeen() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      firstTime = prefs.getBool('seen');
    });
  }

  @override
  void initState() {
    checkFirstSeen();
    Provider.of<TimeSlots>(context, listen: false).fetchAndSetTimeSlots();
    super.initState();
  }

  @override
  void dispose() {
    _medicineTitle.dispose();
    _slotNameController.dispose();
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
                'Add New Medication',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            SliverList(
              // Use a delegate to build items as they're scrolled on screen.
              delegate: SliverChildBuilderDelegate(
                // The builder function returns a ListTile with a title that
                // displays the index of the current item.
                (context, index) => Padding(

                  padding: EdgeInsets.all(nameSize),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      Container(
                        child: Text('Medicine Name'),
                        alignment: Alignment.centerLeft,
                      ),
                      SizedBox(
                        height: nameSize,
                      ),
                      Container(

                        decoration: BoxDecoration(
                            color: kPrimaryColor,
                            borderRadius: BorderRadius.all(
                                Radius.circular(nameSize / 4))),
                        child: TextFormField(
                          autofocus: false,
                          controller: _medicineTitle,
                          decoration: InputDecoration(
                              hintText: '\t\t\t\t Enter name of your medicine',
                              border: InputBorder.none),
                          onChanged: (text) => {},
                        ),
                      ),
                      SizedBox(
                        height: _titleSize,
                      ),
                      Container(
                        child: Text('Select Meditation Routine'),
                        alignment: Alignment.centerLeft,
                      ),
                      SizedBox(
                        height: nameSize / 4,
                      ),
                      Container(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            InkWell(
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  _isWeekly
                                      ? Icon(
                                          Icons.radio_button_checked_rounded,
                                        )
                                      : Icon(
                                          Icons.radio_button_checked_rounded,
                                          color: Colors.grey,
                                        ),
                                  Text(
                                    'Weekly',
                                    style: TextStyle(
                                        color: _isWeekly
                                            ? Colors.black
                                            : Colors.grey),
                                  ),
                                ],
                              ),
                              onTap: () {
                                setState(() {
                                  _isWeekly = true;
                                  _isMonthly = false;
                                });
                              },
                            ),
                            InkWell(
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  _isMonthly
                                      ? Icon(
                                          Icons.radio_button_checked_rounded,
                                        )
                                      : Icon(
                                          Icons.radio_button_checked_rounded,
                                          color: Colors.grey,
                                        ),
                                  Text(
                                    'Monthly',
                                    style: TextStyle(
                                        color: _isMonthly
                                            ? Colors.black
                                            : Colors.grey),
                                  ),
                                ],
                              ),
                              onTap: () {
                                setState(() {
                                  _isMonthly = true;
                                  _isWeekly = false;
                                });
                              },
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: nameSize,
                      ),
                      _isWeekly || _isMonthly
                          ? Container(
                              width: deviceWidth,
                              height: deviceHeight * 0.042,
                              child: ListView.builder(
                                padding: EdgeInsets.symmetric(
                                    horizontal: nameSize / 4),
                                itemCount: _isWeekly ? 7 : 2,
                                scrollDirection: Axis.horizontal,
                                itemBuilder: (context, index) {
                                  if (_isWeekly == true) {
                                    _selectedList = [
                                      'Mon',
                                      'Tue',
                                      'Wed',
                                      'Thu',
                                      'Fri',
                                      'Sat',
                                      'Sun'
                                    ];
                                  }
                                  if (_isMonthly == true) {
                                    _selectedList = [
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
                                            color: _selectedDays.contains(
                                                    _selectedList[index])
                                                ? Colors.black
                                                : Colors.grey,
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(nameSize / 4)),
                                          ),
                                          child: Center(
                                            child: Text(
                                              _selectedList[index],
                                              style: TextStyle(
                                                  color: Colors.white),
                                            ),
                                          ),
                                        ),
                                        onTap: () {
                                          setState(() {
                                            if(_selectedDays.contains(_selectedList[index])){
                                              _selectedDays.remove(_selectedList[index]);
                                            }else{
                                              _selectedDays.add(_selectedList[index]);
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
                              ))
                          : Container(),
                      SizedBox(
                        height: nameSize / 4,
                      ),
                      _isWeekly
                          ? Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  child: Text(
                                    'Select Time at which you take medicine.',
                                    style: TextStyle(fontSize: nameSize * 0.8),
                                  ),
                                ),
                                Container(
                                  child: Text(
                                    'You can change the time to match your schedule',
                                    style: TextStyle(
                                        fontSize: nameSize / 2,
                                        color: Colors.grey),
                                  ),
                                )
                              ],
                            )
                          : Container(),
                      _isMonthly
                          ? Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  child: Text(
                                    'Select Date',
                                    style: TextStyle(fontSize: nameSize * 0.8),
                                  ),
                                ),
                                Container(
                                  child: Text(
                                    'Select Date on which you can take your Monthly Medicine.',
                                    style: TextStyle(
                                        fontSize: nameSize / 2,
                                        color: Colors.grey),
                                  ),
                                ),
                                SizedBox(
                                  height: nameSize / 2,
                                ),
                                Center(
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: <Widget>[
                                      SizedBox(
                                        height: nameSize,
                                      ),
                                      Text(
                                        newSelectedDate.toString(),
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: nameSize),
                                      ),
                                      SizedBox(
                                        height: nameSize,
                                      ),
                                      RaisedButton(
                                        onPressed: () {
                                          _selectDate(context)
                                              .then((value) => {});
                                        },
                                        child: Text('Select Date'),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            )
                          : Container(),
                      Container(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            SizedBox(
                              height: nameSize,
                            ),
                            Container(
                              height: deviceHeight * 0.353,
                              child: Consumer<TimeSlots>(
                                  builder: (ctx, timeSlotData, _) {
                                _loadedTimeSlots = timeSlotData.items;
                                return ListView.builder(
                                    itemCount: _loadedTimeSlots.length,
                                    itemBuilder:
                                        (BuildContext context, int index) {
                                      return new Container(
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Row(
                                              children: [
                                                _selectedTimeSlots.contains(_loadedTimeSlots[index].slotTime)?IconButton(
                                                  onPressed: () {

                                                    setState(() {
                                                      _selectedTimeSlots.remove(_loadedTimeSlots[index].slotTime);
                                                    });
                                                  },
                                                  icon: Icon(Icons
                                                      .check_box_outlined),
                                                ):IconButton(
                                                  onPressed: () {
                                                    setState(() {
                                                      _selectedTimeSlots.add(_loadedTimeSlots[index].slotTime);
                                                    });
                                                  },
                                                  icon: Icon(Icons
                                                      .crop_square_outlined),
                                                ),
                                                Text(_loadedTimeSlots[index]
                                                    .slotName),
                                              ],
                                            ),
                                            GestureDetector(
                                                child: Text(
                                                    _loadedTimeSlots[index]
                                                        .slotTime),
                                                onTap: () {
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
                                                                    hourMinute12HCustomStyle(
                                                                        _titleSize,
                                                                        nameSize),
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
                                                                            Navigator.of(context).pop();
                                                                            _loadedTimeSlots[index].slotTime =
                                                                                DateFormat().add_jm().format(_dateTime);
                                                                            Provider.of<TimeSlots>(context, listen: false).updateTimeSlot(_loadedTimeSlots[index].slotId,
                                                                                _loadedTimeSlots[index]);
                                                                          },
                                                                          child:
                                                                              Text(
                                                                            'Update',
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
                                                }),
                                          ],
                                        ),
                                      );
                                    });
                              }),
                            ),
                            TextButton(
                              onPressed: () {
                                showModalBottomSheet(
                                    enableDrag: false,
                                    context: context,
                                    builder: (BuildContext context) {
                                      return SingleChildScrollView(
                                          child:Container(
                                              padding: EdgeInsets.symmetric(horizontal: nameSize),
                                              height:deviceHeight*0.5,child:Column(
                                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Text('Enter Time Slot Name'),
                                              Container(
                                                decoration: BoxDecoration(
                                                    color: kPrimaryColor,
                                                    borderRadius: BorderRadius.all(
                                                        Radius.circular(nameSize/4))),
                                                child: TextField(
                                                  autofocus: false,
                                                  controller: _slotNameController,
                                                  decoration: InputDecoration(
                                                      hintText:
                                                      '\t\t\t\t Morning, Afternoon etc.',
                                                      border: InputBorder.none),
                                                ),
                                              ),
                                              hourMinute12HCustomStyle(_titleSize,nameSize),
                                              Container(
                                                decoration: BoxDecoration(
                                                    color:Colors.black,
                                                    borderRadius: BorderRadius.all(
                                                        Radius.circular(nameSize/4))),
                                                child:Center(child:TextButton(onPressed: (){
                                                  Navigator.of(context).pop();
                                                  _newTimeSlot.slotId = DateTime.now().toIso8601String();
                                                  _newTimeSlot.slotName = _slotNameController.text;
                                                  _newTimeSlot.slotTime = DateFormat().add_jm().format(_dateTime);

                                                  Provider.of<TimeSlots>(context, listen: false)
                                                      .addTimeSlot(_newTimeSlot).then((_){
                                                    Navigator.of(context).pushReplacementNamed(AddMedicationScreen.routeName);
                                                  });
                                                }, child: Text('Add Time Slot',textAlign:TextAlign.center,style: TextStyle(color: Colors.white),),),),),
                                            ],
                                          )));
                                    });

                              },
                              child: Row(
                                children: [
                                  Icon(Icons.add),
                                  Text('Add New Time Slot')
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: nameSize,
                      ),
                      Container(
                        height: nameSize * 2.5,
                        padding: EdgeInsets.symmetric(horizontal: nameSize),
                        decoration: BoxDecoration(
                            color: kPrimaryColor,
                            borderRadius:
                                BorderRadius.all(Radius.circular(nameSize))),
                        child: GestureDetector(
                          child: InkWell(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text('Save'),
                                Icon(
                                  Icons.arrow_forward_ios,
                                ),
                              ],
                            ),
                          ),
                          onTap: () {
                            _newMedicine.medicineName = _medicineTitle.text;
                            _newMedicine.medicineSchedule = _selectedTimeSlots;
                            _newMedicine.medicineDays = _selectedDays;
                            Provider.of<Medicines>(context, listen: false).addMedicine(_newMedicine).then((_) {
                              Navigator.of(context).pushReplacementNamed(PillBoxScreen.routeName);
                            } );
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

  Widget hourMinute12HCustomStyle(double _titleSize, double nameSize) {
    return new TimePickerSpinner(
      is24HourMode: false,
      normalTextStyle: TextStyle(fontSize: _titleSize, color: Colors.grey),
      highlightedTextStyle:
          TextStyle(fontSize: _titleSize, color: Colors.black),
      spacing: nameSize / 2,
      itemHeight: _titleSize * 2,
      isForce2Digits: true,
      minutesInterval: 1,
      onTimeChange: (time) {
        setState(() {
          _dateTime = time;
        });
      },
    );
  }
}
