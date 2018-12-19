import 'dart:async';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_analytics/observer.dart';
import 'package:flutter/material.dart';
import 'package:savings/utils/analytics.dart';
import 'package:savings/utils/colors.dart';
import 'package:savings/pages/goals_page.dart';
import 'package:savings/utils/logic.dart' as AppLogic;
import 'package:savings/utils/models.dart' as models;
import 'package:savings/utils/variables.dart';
import 'package:flutter/services.dart';
import 'package:flutter_statusbarcolor/flutter_statusbarcolor.dart';

void main() => runApp(new SavingsApp());

class SavingsApp extends StatefulWidget {
  @override
  _SavingsAppState createState() => new _SavingsAppState();
}

class _SavingsAppState extends State<SavingsApp> {
  @override
  void initState() {
    initAppData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Savings',
      color: primaryThemeColor,
      home: GoalsPage(),
      navigatorObservers: analyticsObserver != null
          ? <NavigatorObserver>[analyticsObserver]
          : [],
      theme: new ThemeData(
        primaryColor: primaryThemeColor,
        accentColor: accentThemeColor,
        fontFamily: "Proxima Nova",
      ),
    );
  }

  @override
  void dispose() {
    //Good practice to close the DB
    AppLogic.DatabaseInterface.closeDB();

    //Handle orientation
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeRight,
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    super.dispose();
  }

  Future<Null> initAppData() async {
    //Database
    _initDBData();

    //Analytics
    analytics = new FirebaseAnalytics();
    AnalyticsInterface.logAppOpen();
    analyticsObserver = new FirebaseAnalyticsObserver(analytics: analytics);
  }

  Future<Null> _initDBData() async {
    //Orientation
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);

    //Status bar color
    FlutterStatusbarcolor.setStatusBarColor(Colors.black);

    //Retrieve database from the DB interface
    appDatabase = await AppLogic.DatabaseInterface.getDB();

    //Log output
    print("DatabaseInterface: DatabaseInitiated");

    //Get a local version of the lists after the DB has been initiated
    List<models.Goal> _goalsList =
        await AppLogic.DatabaseInterface.getAllGoalsFromDB();

    List<models.Transaction> _transactionsList =
        await AppLogic.DatabaseInterface.getAllTransactionsFromDB();

    //Call setState and update the global lists (which are used in the whole app) from the local ones
    setState(() {
      allGoalsList = _goalsList;
      allTransactionsList = _transactionsList;
    });
  }
}

//TODO: Implement animation for add goal button
//TODO: Add option for user to add images to goal
//TODO: Add more currencies
//TODO: Add first time open screen
//TODO: Implement dashboard
//TODO: Implement cloud backup for data
//TODO: Implement dark theme
