import './Providers/medicine.dart';
import './Providers/medicines.dart';
import './Providers/timeslot.dart';
import './Providers/timeslots.dart';
import './Screens/homePageScreen.dart';
import './Screens/splashScreen.dart';
import './routes.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {

    return MultiProvider(
        providers: [
          ChangeNotifierProvider.value(
            value: TimeSlot(),
          ),
          ChangeNotifierProvider.value(
            value: Medicine(),
          ),
          ChangeNotifierProxyProvider<Medicine, Medicines>(
            update: (ctx, auth, previousProducts) => Medicines(
              previousProducts == null ? [] : previousProducts.items,
              previousProducts == null ? [] : previousProducts.newItems,
            ),
          ),
          ChangeNotifierProxyProvider<TimeSlot,TimeSlots>(
            update: (ctx, auth, previousProducts) => TimeSlots(
              previousProducts == null ? [] : previousProducts.items,
              previousProducts == null ? [] : previousProducts.newItems,
            ),
          ),
        ],
        child: MaterialApp(
          theme: ThemeData(
            primaryColor: Colors.white,
          ),
          darkTheme: ThemeData.dark(),
          themeMode: ThemeMode.system,
          home: SplashScreen(),
          routes: routes,
          debugShowCheckedModeBanner: false,
        ));
  }
}
