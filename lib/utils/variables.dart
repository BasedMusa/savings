import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_analytics/observer.dart';
import 'package:savings/utils/colors.dart';
import 'package:savings/utils/models.dart' as models;
import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';

FirebaseAnalytics analytics;
FirebaseAnalyticsObserver analyticsObserver;

Database appDatabase;

List<models.Goal> allGoalsList = new List();
List<models.Transaction> allTransactionsList = new List();

List<Color> appThemedGradientColors = [primaryThemeColor, new Color(0xFFF9653E)];

TextEditingController addEditGoalNameController = new TextEditingController();
TextEditingController addEditGoalBudgetController = new TextEditingController();
TextEditingController addTransactionDescriptionController = new TextEditingController();
TextEditingController addTransactionAmountController = new TextEditingController();

double bottomMarginForMainButtons = 20.0;
double appBarBackButtonSize = 30.0;

final GlobalKey<ScaffoldState> goalsPageGlobalKey = new GlobalKey<ScaffoldState>();