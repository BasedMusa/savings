import 'dart:async';

import 'package:flutter/material.dart';
import 'package:savings/pages/add_transaction_page.dart';
import 'package:savings/utils/analytics.dart';
import 'package:savings/utils/colors.dart';
import 'package:savings/utils/models.dart';
import 'package:savings/utils/variables.dart';
import 'package:savings/utils/logic.dart';
import 'package:savings/widgets/themed_container.dart';
import 'package:savings/widgets/themed_text.dart';
import 'package:savings/widgets/transaction_list_item.dart';

class TransactionsPage extends StatefulWidget {
  final Goal goal;

  TransactionsPage({this.goal});

  @override
  _TransactionsPageState createState() => new _TransactionsPageState();
}

class _TransactionsPageState extends State<TransactionsPage> {
  bool isDisposed = false;
  var currentGoalTransactions = new List();
  var completionPercentageForGoal = 0.0;
  Duration deadlineDifference;
  int goalBalance = 0;
  double upperBodyHeight = 0.0;

  @override
  void initState() {
    AnalyticsInterface.changeCurrentScreen(
        screenName: 'Transactions Page', screenOverride: 'TransactionsPage');
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    refreshVariables();

    AppBar _appBar = new AppBar(
      backgroundColor: primaryBackgroundColor,
      elevation: 0.0,
      leading: new Container(
        margin: new EdgeInsets.only(left: 10.0),
        child: new InkWell(
          child: new Container(
              height: 1.0,
              width: 1.0,
              child: new Icon(Icons.clear,
                  color: darkIconColor, size: appBarBackButtonSize)),
          borderRadius: new BorderRadius.circular(30.0),
          onTap: () {
            Navigator.pop(context);
          },
        ),
      ),
    );

    Widget _body = new Container(
      child: new Stack(
        children: <Widget>[

          ///ListView
          new Container(
            margin: new EdgeInsets.only(
                left: 23.0, right: 23.0, top: upperBodyHeight),
            child: new Column(
              children: <Widget>[
                new Flexible(
                  child:
                  new NotificationListener<OverscrollIndicatorNotification>(
                    onNotification: (overScroll) {
                      overScroll.disallowGlow();
                    },
                    child: new ListView.builder(
                        itemCount: currentGoalTransactions.length,
                        itemBuilder: (BuildContext context, int index) {
                          return TransactionListItem(
                            transaction: currentGoalTransactions[index],
                            lastTransactionForGoal: currentGoalTransactions[
                            currentGoalTransactions.length - 1],
                          );
                        }),
                  ),
                ),
              ],
            ),
          ),

          ///Upper Body
          new Container(
            margin: new EdgeInsets.only(
              left: 23.0,
              right: 23.0,
            ),
            decoration:
            new BoxDecoration(color: primaryBackgroundColor, boxShadow: [
              new BoxShadow(
                color: primaryBackgroundColor,
                offset: new Offset(0.0, 10.0),
                blurRadius: 10.0,
                spreadRadius: 0.0,
              )
            ]),
            child: new Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[

                ///Dashboard
                goalDetailsDashboard(
                  goalName: widget.goal.name,
                  goalCost: widget.goal.cost,
                  goalDeadline:
                  getStringDeadlineFromGoal(widget.goal, byPrefix: false),
                ),

                ///Transactions Heading & Quantity Text
                new Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    new Container(
                      alignment: Alignment.centerLeft,
                      margin: new EdgeInsets.only(top: 20.0, left: 10.0),
                      child: new CustomThemedText(
                        text: "Transactions",
                        fontSize: 25.0,
                        letterSpacing: 0.1,
                      ),
                    ),
                    new Container(
                      margin: new EdgeInsets.only(top: 25.0),
                      child: new CustomThemedText(
                        text: currentGoalTransactions.length.toString() +
                            " transactions",
                        color: darkHeadingsTextColor,
                        fontSize: 16.0,
                        bold: false,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          ///Custom Shadow FloatingActionButton
          new Container(
            alignment: Alignment.bottomCenter,
            margin: new EdgeInsets.only(bottom: bottomMarginForMainButtons),
            child: new Container(
              child: fab(),
              decoration: new BoxDecoration(
                boxShadow: [
                  new BoxShadow(
                      color: primaryShadowColor,
                      spreadRadius: 1.0,
                      blurRadius: 8.0,
                      offset: new Offset(0.0, 4.0)),
                ],
                shape: BoxShape.circle,
              ),
            ),
          ),
        ],
      ),
    );

    return new Scaffold(
      body: _body,
      appBar: _appBar,
    );
  }

  @override
  void dispose() {
    isDisposed = true;
    super.dispose();
  }

  Widget goalDetailsDashboard({
    String goalName,
    String goalDeadline,
    int goalCost,
  }) {
    double borderRadius = 4.0;

    return new Hero(
      tag: "GoalTransactionsHero",
      child: new CustomThemedContainer(
        width: double.maxFinite,
        outerRadius: borderRadius,
        padding: new EdgeInsets.only(top: 15.0),
        child: new Column(
          children: <Widget>[

            ///Goal Details / Completed Heading
            new Container(
              alignment: Alignment.centerLeft,
              margin: new EdgeInsets.only(top: 15.0, right: 23.0, left: 23.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  buildHeading(
                      goalCost != null
                          ? goalBalance >= goalCost
                          ? 'YOUR GOAL HAS BEEN COMPLETED!'
                          : 'GOAL DETAILS'
                          : 'GOAL DETAILS',
                      16.0),
                  deadlineDifference != null ? deadlineDifference.isNegative
                      ? new Container(
                      decoration: new BoxDecoration(
                        gradient:
                        new LinearGradient(colors: appThemedGradientColors),
                        shape: BoxShape.circle,
                      ),
                      height: 30.0,
                      width: 30.0,
                      child: Center(
                        child: new Icon(
                          Icons.timer,
                          color: Colors.white,
                        ),
                      ))
                      : new Container() : new Container(),
                ],
              ),
            ),

            ///Goal Title Text
            new Row(
              children: <Widget>[
                new Flexible(
                  child: new Column(
                    children: <Widget>[
                      new Container(
                        alignment: Alignment.centerLeft,
                        margin: new EdgeInsets.only(
                            left: 23.0, right: 23.0, top: 12.0),
                        child: new CustomThemedText(
                          text: goalName,
                          fontSize: 25.0,
                          letterSpacing: 0.2,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),

            ///Goal Cost Text
            goalCost != null
                ? new Container(
              alignment: Alignment.centerLeft,
              margin:
              new EdgeInsets.only(top: 4.0, left: 23.0, right: 23.0),
              child: new CustomThemedText(
                text: goalCost.toString(),
                fontSize: 23.0,
                letterSpacing: 0.2,
              ),
            )
                : new Container(),

            ///Goal Deadline Text
            widget.goal.deadline != null
                ? new Container(
              alignment: Alignment.centerLeft,
              margin:
              new EdgeInsets.only(top: 4.0, left: 23.0, right: 23.0),
              child: new CustomThemedText(
                text: goalDeadline,
                fontSize: 17.0,
                letterSpacing: 0.2,
                color: darkHeadingsTextColor,
              ),
            )
                : new Container(),

            ///Divider
            new Container(
              margin: new EdgeInsets.only(top: 15.0, right: 13.0, left: 13.0),
              height: 2.0,
              width: double.maxFinite,
              color: new Color(0xFFF1F1EF),
            ),

            ///Progress Heading
            new Container(
              alignment: Alignment.centerLeft,
              margin: new EdgeInsets.only(top: 15.0, right: 23.0, left: 23.0),
              child: buildHeading('PROGRESS', 16.0),
            ),

            ///Completed Amount Text
            new Container(
              alignment: Alignment.centerLeft,
              margin: new EdgeInsets.only(left: 23.0, right: 23.0, top: 12.0),
              child: new CustomThemedText(
                  text: goalCost == null
                      ? goalBalance.toString()
                      : goalBalance.toString() +
                      ' out of ' +
                      goalCost.toString(),
                  fontSize: 20.0),
            ),

            ///Completed Percentage Text
            goalCost != null
                ? new Container(
              alignment: Alignment.centerLeft,
              margin:
              new EdgeInsets.only(left: 23.0, right: 23.0, top: 4.0),
              child: new CustomThemedText(
                  text: completionPercentageForGoal.round().toString() +
                      "%",
                  fontSize: 20.0),
            )
                : new Container(),

            ///Goal Progress Indicator
            new Stack(
              children: <Widget>[
                new Container(
                  width: double.maxFinite,
                  height: 7.0,
                  margin: new EdgeInsets.only(top: 15.0),
                  decoration: new BoxDecoration(
                      color: new Color(0xFFF1F1EF),
                      borderRadius: new BorderRadius.only(
                        bottomRight: new Radius.circular(borderRadius),
                        bottomLeft: new Radius.circular(borderRadius),
                      )),
                ),
                new Container(
                  width: goalCost != null
                      ? (364.0 / 100.0) *
                      completionPercentageForGoal.clamp(0, 100)
                      : 364.0,
                  height: 7.0,
                  margin: new EdgeInsets.only(top: 15.0),
                  decoration: new BoxDecoration(
                      color: goalCost == null ? darkHeadingsTextColor : null,
                      gradient: goalCost != null
                          ? new LinearGradient(colors: appThemedGradientColors)
                          : null,
                      borderRadius: new BorderRadius.only(
                        bottomRight: new Radius.circular(borderRadius),
                        bottomLeft: new Radius.circular(borderRadius),
                      )),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget buildHeading(String title, double fontSize) {
    return new Text(
      title,
      style: new TextStyle(
          fontWeight: FontWeight.w800, letterSpacing: 0.04, fontSize: fontSize),
    );
  }

  Future<Null> refreshVariables() async {
    //For defining margin for listView
    if (widget.goal.deadline != null && widget.goal.cost != null) {
      setState(() {
        upperBodyHeight = 312.5;
      });
    }
    if (widget.goal.deadline != null && widget.goal.cost == null) {
      setState(() {
        upperBodyHeight = 255.0;
      });
    }
    if (widget.goal.deadline == null && widget.goal.cost == null) {
      setState(() {
        upperBodyHeight = 235.0;
      });
    }
    if (widget.goal.deadline == null && widget.goal.cost != null) {
      setState(() {
        upperBodyHeight = 295.0;
      });
    }

    if (widget.goal.deadline != null) {
      deadlineDifference = widget.goal.deadline.difference(new DateTime.now());
    }

    var _currentGoalTransactions = getTransactionsFromGoal(widget.goal);
    var _goalBalance = getBalanceFromGoal(widget.goal);
    var _completionPercentageForGoal =
    getCompletionPercentageFromGoal(widget.goal);

    if (!isDisposed) {
      setState(() {
        currentGoalTransactions = _currentGoalTransactions;
        goalBalance = _goalBalance;
        completionPercentageForGoal = _completionPercentageForGoal;
      });
    }
  }

  Widget fab() {
    return new Hero(
      tag: "AddTransactionHero",
      child: new FloatingActionButton(
        tooltip: "Add a new transaction",
        onPressed: () {
          Navigator.push(
            context,
            new MaterialPageRoute(
                builder: (context) =>
                new AddTransactionPage(goal: widget.goal)),
          );
        },
        backgroundColor: primaryThemeColor,
        child: new Container(
          height: double.maxFinite,
          width: double.maxFinite,
          decoration: new BoxDecoration(
            gradient: new LinearGradient(
                colors: appThemedGradientColors, stops: [0.0, 50.0]),
          ),
          child: new Icon(
            Icons.attach_money,
            size: 30.0,
          ),
        ),
        elevation: 0.0,
      ),
    );
  }
}
