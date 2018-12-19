import 'dart:async';
import 'package:flutter/material.dart';
import 'package:savings/utils/analytics.dart';
import 'package:savings/utils/colors.dart';
import 'package:savings/utils/logic.dart';
import 'package:savings/utils/models.dart';
import 'package:savings/utils/variables.dart';
import 'package:savings/widgets/themed_button.dart';
import 'package:savings/widgets/themed_container.dart';
import 'package:savings/widgets/themed_text.dart';

class DeleteGoalPage extends StatefulWidget {
  final Goal goalToDelete;

  DeleteGoalPage({@required this.goalToDelete});

  @override
  _DeleteGoalPageState createState() => _DeleteGoalPageState();
}

class _DeleteGoalPageState extends State<DeleteGoalPage> {
  int goalBalance = 0;
  var completionPercentage = 0.0;

  @override
  void initState() {
    AnalyticsInterface.changeCurrentScreen(
        screenName: 'Delete Goal Page', screenOverride: 'DeleteGoalPage');
    refreshVariables();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    AppBar _appBar = new AppBar(
      backgroundColor: primaryBackgroundColor,
      elevation: 0.0,
      leading: new Container(
        margin: new EdgeInsets.only(left: 10.0),
        child: new InkWell(
          child: new Container(
              child: new Icon(Icons.clear, color: darkIconColor, size: appBarBackButtonSize)),
          borderRadius: new BorderRadius.circular(30.0),
          onTap: () {
            Navigator.pop(context);
          },
        ),
      ),
    );

    Widget _body = new Container(
        margin: new EdgeInsets.only(left: 23.0, right: 23.0),
        child: new CustomThemedContainer(
          padding: new EdgeInsets.all(18.0),
          width: double.maxFinite,
          child: new Stack(
            children: <Widget>[
              new Column(
                children: <Widget>[
                  ///Delete Goal Heading
                  new Container(
                    alignment: Alignment.center,
                    margin: new EdgeInsets.only(top: 10.0),
                    child: new CustomThemedText(
                      text: "Delete Goal",
                      fontSize: 32.0,
                      letterSpacing: 0.1,
                    ),
                  ),

                  ///Divider
                  new Container(
                    margin:
                        new EdgeInsets.only(top: 17.0, right: 13.0, left: 13.0),
                    height: 2.0,
                    width: double.maxFinite,
                    color: new Color(0xFFF1F1EF),
                  ),

                  ///Goal Details
                  new Container(
                      child: new Column(children: <Widget>[
                    ///Goal Details Heading
                    new Container(
                        margin: new EdgeInsets.only(top: 20.0),
                        alignment: Alignment.centerLeft,
                        child: buildHeading(
                          'GOAL DETAILS',
                          16.0,
                        )),

                    ///Goal Name Text
                    new Container(
                      child: new Column(
                        children: <Widget>[
                          new Container(
                            margin: new EdgeInsets.only(top: 12.0),
                            alignment: Alignment.centerLeft,
                            child: new CustomThemedText(
                              text: widget.goalToDelete.name,
                              fontSize: 25.0,
                              letterSpacing: 0.1,
                            ),
                          ),

                          ///Goal Cost Text
                          new Container(
                            margin: new EdgeInsets.only(top: 4.0),
                            alignment: Alignment.centerLeft,
                            child: new CustomThemedText(
                              text: widget.goalToDelete.cost.toString(),
                              fontSize: 25.0,
                              letterSpacing: 0.1,
                            ),
                          ),

                          ///Goal Deadline Text
                          widget.goalToDelete.deadline != null
                              ? new Container(
                                  margin: new EdgeInsets.only(top: 10.0),
                                  alignment: Alignment.centerLeft,
                                  child: new CustomThemedText(
                                    text: getStringDeadlineFromGoal(
                                        widget.goalToDelete,
                                        byPrefix: false),
                                    fontSize: 20.0,
                                    letterSpacing: 0.1,
                                  ),
                                )
                              : new Container(),

                          ///Divider
                          new Container(
                            margin: new EdgeInsets.only(
                                top: 20.0, right: 13.0, left: 13.0),
                            height: 2.0,
                            width: double.maxFinite,
                            color: new Color(0xFFF1F1EF),
                          ),

                          ///Goal Progress Heading
                          new Container(
                              margin: new EdgeInsets.only(top: 20.0),
                              alignment: Alignment.centerLeft,
                              child: buildHeading(
                                'PROGRESS',
                                16.0,
                              )),

                          ///Completed Amount Text
                          new Container(
                            alignment: Alignment.centerLeft,
                            margin: new EdgeInsets.only(top: 12.0),
                            child: new CustomThemedText(
                              text: widget.goalToDelete.cost != null
                                  ? goalBalance.toString() +
                                      ' out of ' +
                                      widget.goalToDelete.cost.toString()
                                  : goalBalance.toString(),
                              fontSize: 20.0,
                            ),
                          ),

                          ///Completed Percentage Text
                          new Container(
                            alignment: Alignment.centerLeft,
                            margin: new EdgeInsets.only(top: 4.0),
                            child: new CustomThemedText(
                              text:
                                  completionPercentage.round().toString() + "%",
                              fontSize: 20.0,
                            ),
                          ),

                          ///Divider
                          new Container(
                            margin: new EdgeInsets.only(
                                top: 20.0, right: 13.0, left: 13.0),
                            height: 2.0,
                            width: double.maxFinite,
                            color: new Color(0xFFF1F1EF),
                          ),

                          new Padding(
                            padding: const EdgeInsets.only(top: 15.0),
                            child: new Text(
                              'Warning! This action cannot be undone!\nAll transactions for this goal will also be deleted!',
                              style: new TextStyle(
                                  fontWeight: FontWeight.w600,
                                  color: darkHeadingsTextColor,
                                  fontSize: 15.5),
                            ),
                          )
                        ],
                      ),
                    ),
                  ])),
                ],
              ),
              //Delete Button
              new Container(
                alignment: Alignment.bottomRight,
                margin: new EdgeInsets.only(bottom: bottomMarginForMainButtons),
                child: new CustomThemedButton(
                      text: 'DELETE',
                      invertedDesign: true,
                      width: 100.0,
                      height: kBottomNavigationBarHeight - 18.0,
                      onTap: () async {
                        //Delete Goal
                        await DatabaseInterface
                            .deleteFromDB(widget.goalToDelete);

                        //Log some data to analytics
                        AnalyticsInterface.logEvent(
                            eventName: 'OldGoalDeleted',
                            eventObject: 'goal',
                            goalData: widget.goalToDelete);

                        setState(() {
                          allGoalsList.remove(widget.goalToDelete);
                        });

                        //Close page
                        Navigator.pop(context);
                      },
                    ),
              )
            ],
          ),
        ));

    return Scaffold(
      appBar: _appBar,
      body: _body,
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
    completionPercentage =
        getCompletionPercentageFromGoal(widget.goalToDelete);
    var _goalBalance = getBalanceFromGoal(widget.goalToDelete);

    setState(() {
      goalBalance = _goalBalance;
    });
  }
}
