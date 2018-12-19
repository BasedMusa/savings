import 'dart:async';
import 'package:flutter/material.dart';
import 'package:savings/pages/add_edit_goal_page.dart';
import 'package:savings/pages/delete_goal_page.dart';
import 'package:savings/pages/transactions_page.dart';
import 'package:savings/utils/colors.dart';
import 'package:savings/utils/logic.dart';
import 'package:savings/utils/models.dart';
import 'package:savings/utils/variables.dart';
import 'package:savings/widgets/themed_container.dart';

class GoalListItem extends StatefulWidget {
  final Goal goal;

  GoalListItem({this.goal});

  @override
  _GoalListItemState createState() => new _GoalListItemState();
}

class _GoalListItemState extends State<GoalListItem> {
  Duration deadlineDifference;
  double outerRadius = 3.0;
  double goalPercentage = 0.0;
  bool isDisposed;

  @override
  void initState() {
    isDisposed = false;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    refreshVariables();

    return new CustomThemedContainer(
      margin: new EdgeInsets.only(left: 22.0, top: 20.0, right: 22.0, bottom: allGoalsList[allGoalsList.length-1].name == widget.goal.name ? 30.0 : 0.0),
      child: new InkWell(
        onTap: () {
          Navigator.push(
            context,
            new MaterialPageRoute(
                builder: (context) => new TransactionsPage(
                      goal: widget.goal,
                    )),
          );
        },
        onLongPress: () {
          showModalBottomSheet(
              context: context,
              builder: (context) {
                return new Container(
                  child: new Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      ///Edit List Tile
                      new Container(
                        child: new ListTile(
                          onTap: () {
                            Navigator.pop(context);
                            Navigator.push(
                              context,
                              new MaterialPageRoute(
                                  builder: (context) => new AddEditGoalPage(
                                        goalToEdit: widget.goal,
                                        typeOfAction: 'edit',
                                      )),
                            );
                          },
                          title: new Text(
                            'Edit',
                            style: new TextStyle(
                                color: primaryTextColor,
                                fontWeight: FontWeight.w500,
                                fontSize: 18.0,
                                letterSpacing: 0.2),
                          ),
                        ),
                      ),

                      ///Delete List Tile
                      new Container(
                        child: new ListTile(
                          onTap: () async {
                            Navigator.pop(context);
                            Navigator.push(
                              context,
                              new MaterialPageRoute(
                                  builder: (context) => new DeleteGoalPage(
                                        goalToDelete: widget.goal,
                                      )),
                            );
                          },
                          title: new Text(
                            'Delete',
                            style: new TextStyle(
                                color: primaryTextColor,
                                fontWeight: FontWeight.w500,
                                fontSize: 18.0,
                                letterSpacing: 0.2),
                          ),
                        ),
                      )
                    ],
                  ),
                );
              });
        },
        enableFeedback: true,
        child: new Container(
          child: new Row(
            mainAxisSize: MainAxisSize.max,
            children: <Widget>[
              new Stack(children: [
                new Container(
                  decoration: new BoxDecoration(
                      color: new Color(0xFFF1F1EF),
                      borderRadius: new BorderRadius.only(
                          topLeft: new Radius.circular(outerRadius),
                          bottomLeft: new Radius.circular(outerRadius))),
                  width: 5.0,
                  height: 81.0,
                ),
                new Container(
                  decoration: new BoxDecoration(
                      color: widget.goal.cost != null
                          ? goalPercentage >= 100.0
                              ? darkHeadingsTextColor
                              : null
                          : darkHeadingsTextColor,
                      gradient: widget.goal.cost != null
                          ? goalPercentage < 100.0
                              ? new LinearGradient(
                                  colors: appThemedGradientColors)
                              : null
                          : null,
                      borderRadius: new BorderRadius.only(
                          topLeft: new Radius.circular(outerRadius),
                          bottomLeft: new Radius.circular(outerRadius))),
                  width: 5.0,
                  height: widget.goal.cost != null
                      ? (81.0 / 100.0) * goalPercentage
                      : 81.0,
                ),
              ]),
              new Flexible(
                child: new Container(
                  margin:
                      new EdgeInsets.only(top: 20.0, bottom: 20.0, left: 15.0),
                  child: new RichText(
                    overflow: TextOverflow.ellipsis,
                    softWrap: false,
                    text: new TextSpan(
                      style: new TextStyle(fontFamily: "Proxima Nova"),
                      children: [
                        new TextSpan(
                          text: widget.goal.name + "\n",
                          style: new TextStyle(
                              fontSize: 20.0,
                              fontWeight: FontWeight.w600,
                              color: primaryTextColor),
                        ),
                        new TextSpan(
                          text: getStringDeadlineFromGoal(widget.goal),
                          style: new TextStyle(
                            height: 1.4,
                            fontSize: 15.0,
                            fontWeight: FontWeight.w400,
                            color: subtitlesTextColor,
                          ),
                        ),
                        deadlineDifference != null
                            ? deadlineDifference.inDays < 7
                                ? new TextSpan(
                                    text: deadlineDifference.isNegative
                                        ? '    Crossed deadline!'
                                        : '    Deadline is near!',
                                    style: new TextStyle(
                                      color: primaryThemeColor,
                                      fontSize: 15.0,
                                    ))
                                : new TextSpan(text: '')
                            : new TextSpan(text: ''),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    isDisposed = true;
    super.dispose();
  }

  Future<Null> refreshVariables() async {
    if (widget.goal.deadline != null) {
      deadlineDifference = widget.goal.deadline.difference(new DateTime.now());
    }
    if (isDisposed == false) {
      var _goalPercentage =
          getCompletionPercentageFromGoal(widget.goal, toClamp: true);

      setState(() {
        goalPercentage = _goalPercentage;
      });
    }
  }
}
