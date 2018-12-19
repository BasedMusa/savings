import 'package:flutter/material.dart';
import 'package:savings/pages/add_edit_goal_page.dart';
import 'package:savings/utils/analytics.dart';
import 'package:savings/utils/colors.dart';
import 'package:savings/utils/models.dart';
import 'package:savings/utils/variables.dart';
import 'package:savings/widgets/themed_text.dart';
import '../widgets/goal_list_item.dart';

class GoalsPage extends StatefulWidget {
  @override
  _GoalsPageState createState() => new _GoalsPageState();
}

class _GoalsPageState extends State<GoalsPage> {
  @override
  void initState() {
    _initGoalsPage();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      body: _body(),
      key: goalsPageGlobalKey,
    );
  }

  _body() {
    return new Container(
      child: Stack(
        children: <Widget>[
          ///Goals ListView
          new Container(
            margin: new EdgeInsets.only(top: 80.0),
            child: new Column(
              children: <Widget>[
                _goalsListView(),
              ],
            ),
          ),

          ///Dashboard
          new Container(
            child: new Column(
              children: <Widget>[
                new Container(
                  child: _dashboard(),
                )
              ],
            ),
          ),

          ///FloatingActionButton
          new Container(
            alignment: Alignment.bottomCenter,
            margin: new EdgeInsets.only(bottom: bottomMarginForMainButtons),
            child: new Container(
              decoration: _fabDecoration(),
              child: _fab(),
            ),
          ),
        ],
      ),
    );
  }

  _dashboard() {
    return new Container(
      margin: new EdgeInsets.only(left: 20.0, top: 60.0),
      decoration: new BoxDecoration(color: primaryBackgroundColor, boxShadow: [
        new BoxShadow(
          color: primaryBackgroundColor,
          offset: new Offset(0.0, 10.0),
          blurRadius: 10.0,
          spreadRadius: 0.0,
        )
      ]),
      child: new Column(
        children: <Widget>[
          new Container(
              alignment: Alignment.centerLeft,
              child: new Text(
                'YOUR GOALS',
                style:
                    new TextStyle(fontSize: 30.0, fontWeight: FontWeight.w800),
              )),
          new Container(
              alignment: Alignment.centerLeft,
              child: new CustomThemedText(
                text: 'You have planned to buy ' +
                    allGoalsList.length.toString() +
                    ' items',
                color: darkHeadingsTextColor,
                fontSize: 17.0,
              )),
        ],
      ),
    );
  }

  Widget _fab() {
    return new FloatingActionButton(
      heroTag: "AddGoalHero",
      tooltip: "Add a new Goal",
      onPressed: () {
        Navigator.push(
          context,
          new MaterialPageRoute(
              builder: (context) => new AddEditGoalPage(
                    typeOfAction: 'add',
                  )),
        );
      },
      child: new Container(
        height: double.maxFinite,
        width: double.maxFinite,
        decoration: new BoxDecoration(
          gradient: new LinearGradient(
              colors: appThemedGradientColors, stops: [0.0, 50.0]),
        ),
        child: new Icon(Icons.add),
      ),
      elevation: 0.0,
    );
  }

  _goalsListView() {
    return new Flexible(
      child: NotificationListener<OverscrollIndicatorNotification>(
        onNotification: (overScroll) {
          overScroll.disallowGlow();
        },
        child: new ListView.builder(
          itemBuilder: (context, index) {
            return new GoalListItem(goal: allGoalsList[index]);
          },
          itemCount: allGoalsList.length,
        ),
      ),
    );
  }

  _fabDecoration() {
    return new BoxDecoration(
      boxShadow: [
        new BoxShadow(
            color: primaryShadowColor,
            spreadRadius: 1.0,
            blurRadius: 8.0,
            offset: new Offset(0.0, 4.0)),
      ],
      shape: BoxShape.circle,
    );
  }

  _initGoalsPage() async {
    AnalyticsInterface.changeCurrentScreen(
        screenName: 'Goals Page', screenOverride: 'GoalsPage');
  }
}
