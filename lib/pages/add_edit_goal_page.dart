import 'dart:async';
import 'package:flutter/material.dart';
import 'package:savings/utils/analytics.dart';
import 'package:savings/utils/colors.dart';
import 'package:savings/utils/logic.dart';
import 'package:savings/utils/models.dart';
import 'package:savings/utils/variables.dart';
import 'package:savings/widgets/themed_button.dart';
import 'package:savings/widgets/themed_checkbox.dart';
import 'package:savings/widgets/themed_text_field.dart';

String selectedPriority;

class AddEditGoalPage extends StatefulWidget {
  final String typeOfAction;
  final Goal goalToEdit;

  AddEditGoalPage({this.typeOfAction = 'add', this.goalToEdit});

  @override
  _AddEditGoalPageState createState() => new _AddEditGoalPageState();
}

class _AddEditGoalPageState extends State<AddEditGoalPage> {
  DateTime _initialDate = new DateTime.now();
  DateTime selectedDate = new DateTime.now();

  double _checkboxSize = 25.0;

  DateTime deadline;
  String timeDifference;
  bool anyDeadline;
  bool anyBudget;

  final GlobalKey<FormState> addEditGoalFormKey = new GlobalKey<FormState>();

  @override
  void initState() {
    if (widget.typeOfAction == "add") {
      AnalyticsInterface.changeCurrentScreen(
          screenName: 'Add Goal Page', screenOverride: 'AddGoalPage');

      addEditGoalNameController.clear();
      addEditGoalBudgetController.clear();

      anyDeadline = true;
      anyBudget = true;

      selectedDate = new DateTime(
          selectedDate.year, selectedDate.month, selectedDate.day + 1);
    } else {
      AnalyticsInterface.changeCurrentScreen(
          screenName: 'Edit Goal Page', screenOverride: 'EditGoalPage');

      //Title Text Field
      addEditGoalNameController.text = widget.goalToEdit.name;

      //Budget data
      if (widget.goalToEdit.cost != null) {
        anyBudget = true;
        //Budget Text Field
        addEditGoalBudgetController.text = widget.goalToEdit.cost.toString();
      } else {
        anyBudget = false;

        //Budget Text Field
        addEditGoalBudgetController.text = '';
      }

      //Deadline data
      if (widget.goalToEdit.deadline != null) {
        anyDeadline = true;
        selectedDate = widget.goalToEdit.deadline;
      } else {
        anyDeadline = false;
      }
    }

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    selectedPriority = "High";

    deadline = selectedDate;

    timeDifference = calculateTimeDifference();

    AppBar _appBar = new AppBar(
      elevation: 0.0,
      backgroundColor: primaryBackgroundColor,
      leading: new Container(
        margin: new EdgeInsets.only(left: 10.0),
        child: new InkWell(
          child: new Container(
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
        margin: new EdgeInsets.only(left: 23.0, right: 23.0),
        child: new Form(
          key: addEditGoalFormKey,
          child: new Column(
            children: <Widget>[
              new Container(
                margin: new EdgeInsets.only(top: 20.0),

                ///Title Text Field
                child: new CustomThemedTextField(
                  hintText: "Title of the item...",
                  fontSize: 34.0,
                  maxLength: 35,
                  textController: addEditGoalNameController,
                  centerText: false,
                  validator: (_input) {
                    if (validateTextField(input: _input, typeOfInput: String)) {
                      //Check if there is already a goal with the same name
                      //and assigning the alreadyCreatedGoal boolean accordingly
                      for (int i = 0; i < allGoalsList.length; i++) {
                        Goal loopedGoal = allGoalsList[i];

                        print(loopedGoal.name);
                        print(_input);

                        if (widget.typeOfAction == 'edit' &&
                            loopedGoal.id != widget.goalToEdit.id) {
                          if (loopedGoal.name == _input) {
                            print('There is already a goal with that name');
                            return 'Already created goal with same name';
                          }
                        } else if (widget.typeOfAction == 'add') {
                          if (loopedGoal.name == _input) {
                            print('There is already a goal with that name');
                            return 'Already created goal with same name';
                          }
                        }
                      }
                    } else {
                      return "You can't leave this field empty";
                    }
                  },
                ),
              ),

              ///Budget Sections
              new Container(
                margin: new EdgeInsets.only(top: 10.0),
                child: new Column(
                  children: <Widget>[
                    new Row(
                      children: <Widget>[
                        ///Budget Checkbox
                        new Container(
                          child: new CustomThemedCheckbox(
                            size: _checkboxSize,
                            value: anyBudget,
                            onChanged: () {
                              setState(() {
                                if (anyBudget == true) {
                                  anyBudget = false;
                                } else {
                                  anyBudget = true;
                                }
                              });
                            },
                          ),
                        ),

                        ///Budget Heading
                        new Container(
                          margin: new EdgeInsets.only(left: 8.0),
                          alignment: Alignment.centerLeft,
                          child: buildHeading("BUDGET", 16.0,
                              isDisabled: anyBudget == true ? false : true),
                        ),
                      ],
                    ),

                    ///Budget Text Field
                    new Container(
                      margin: new EdgeInsets.only(top: 10.0),
                      child: new CustomThemedTextField(
                        hintText: "\$\$\$",
                        fontSize: 19.0,
                        maxLength: 7,
                        textController: addEditGoalBudgetController,
                        keyboardType: TextInputType.number,
                        centerText: true,
                        isDisabled: anyBudget == true ? false : true,
                        validator: (_input) {
                          if (anyBudget == true) {
                            if (validateTextField(
                                    typeOfInput: int, input: _input) ==
                                true) {
                              return null;
                            } else {
                              return "You can't leave this field empty";
                            }
                          } else {
                            return null;
                          }
                        },
                      ),
                    ),

                    new Container(
                      margin: new EdgeInsets.only(top: 10.0),
                      child: new Column(children: <Widget>[
                        new Row(
                          children: <Widget>[
                            ///Deadline Checkbox
                            new Container(
                              child: new CustomThemedCheckbox(
                                size: _checkboxSize,
                                value: anyDeadline,
                                onChanged: () {
                                  setState(() {
                                    if (anyDeadline == true) {
                                      anyDeadline = false;
                                    } else {
                                      anyDeadline = true;
                                    }
                                  });
                                },
                              ),
                            ),

                            ///Deadline Heading
                            new Container(
                              margin: new EdgeInsets.only(left: 8.0),
                              alignment: Alignment.centerLeft,
                              child: buildHeading(
                                "DEADLINE",
                                16.0,
                                isDisabled: anyDeadline == true ? false : true,
                              ),
                            ),
                          ],
                        ),

                        ///Deadline Button & Elaboration Text
                        new Container(
                          alignment: Alignment.centerLeft,
                          margin: new EdgeInsets.only(top: 20.0),
                          child: new Row(
                            children: <Widget>[
                              new CustomThemedButton(
                                isDisabled: anyDeadline == true ? false : true,
                                invertedDesign: false,
                                shadowsVisible: false,
                                height: kBottomNavigationBarHeight - 15.0,
                                text: getMonthNameFromMonthNumber(
                                        selectedDate.month) +
                                    " " +
                                    selectedDate.day.toString() +
                                    ", " +
                                    selectedDate.year.toString(),
                                onTap: () {
                                  showDatePickerDialog(context, _initialDate);
                                },
                              ),
                              new Padding(
                                padding: const EdgeInsets.only(left: 15.0),
                                child: new Text(
                                  "i.e. " + timeDifference,
                                  style: new TextStyle(
                                    fontWeight: FontWeight.w600,
                                    color: anyDeadline == true
                                        ? darkHeadingsTextColor
                                        : lightHeadingsTextColor,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ]),
                    )
                  ],
                ),
              )
            ],
          ),
        ));

    return new Scaffold(
      appBar: _appBar,
      body: _body,
      bottomNavigationBar: bottomNavBar(),
    );
  }

  Future submitForm() async {
    final form = addEditGoalFormKey.currentState;
    if (form.validate()) {
      form.save();

      if (await processGoal() == 1) {
        Navigator.pop(context);
      }
    }
  }

  Future<int> processGoal() async {
    ///This method returns a 0 int if a goal cannot be processed
    ///and returns 1 if the goal is successfully processed
    ///It processes a goal by adding the goal or editing the
    ///goal and saving it's changes, depends on what the type
    ///of action is passed to page

    int budget;

    if (anyBudget == true) {
      budget = int.parse(addEditGoalBudgetController.text);
    } else {
      budget = null;
    }

    bool alreadyCreatedGoal = false;

    String _name = addEditGoalNameController.text;

    //Check if there is already a goal with the same name
    //using a alreadyCreatedGoal boolean
    if (alreadyCreatedGoal == false) {
      Goal toProcessGoal = new Goal(
          id: allGoalsList.length + 1,
          name: _name,
          cost: budget,
          deadline: anyDeadline == true ? deadline : null);

      //Insert to database or update to database
      if (widget.typeOfAction == 'add') {
        DatabaseInterface.insertToDB(
          'goal',
          goal: toProcessGoal,
        );
        AnalyticsInterface.logEvent(
            eventName: 'NewGoalAdded',
            eventObject: 'goal',
            goalData: toProcessGoal);
        setState(() {
          allGoalsList.add(toProcessGoal);
        });
      } else {
        DatabaseInterface.updateToDB(
          editedGoal: toProcessGoal,
          toEditGoal: widget.goalToEdit,
        );
        AnalyticsInterface.logEvent(
            eventName: 'OldGoalEdited',
            eventObject: 'goal',
            goalData: toProcessGoal);

        for (int i = 0; i < allGoalsList.length; i++) {
          Goal loopedGoal = allGoalsList[i];

          if (loopedGoal.id == widget.goalToEdit.id) {
            setState(() {
              allGoalsList.remove(loopedGoal);
              allGoalsList.add(toProcessGoal);
            });
          }
        }
      }

      return 1;
    } else {
      return 0;
    }
  }

  Widget bottomNavBar() {
    return new BottomAppBar(
      elevation: 0.0,
      color: primaryBackgroundColor,
      child: new Container(
          margin: new EdgeInsets.only(
              bottom: bottomMarginForMainButtons, top: 10.0),
          child: addGoalButton()),
    );
  }

  Widget buildHeading(String title, double fontSize,
      {bool isDisabled = false}) {
    return new Text(
      title,
      style: new TextStyle(
          fontWeight: FontWeight.w800,
          letterSpacing: 0.04,
          fontSize: fontSize,
          color: isDisabled ? lightHeadingsTextColor : primaryTextColor),
    );
  }

  Widget addGoalButton() {
    return new Hero(
        tag: "AddGoalHero",
        child: new Container(
          margin: new EdgeInsets.only(left: 23.0, right: 23.0),
          child: new CustomThemedButton(
            text: widget.typeOfAction == 'add' ? "Add Goal" : "Save changes",
            textStyle: new TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w700,
                fontSize: 19.0,
                letterSpacing: 0.2),
            shadowsVisible: true,
            invertedDesign: true,
            width: double.maxFinite,
            height: kBottomNavigationBarHeight - 10.0,
            onTap: () {
              submitForm();
            },
          ),
        ));
  }

  String calculateTimeDifference() {
    String difference =
        (selectedDate.difference(new DateTime.now()).inDays + 1).toString() +
            " day";

    if (selectedDate.difference(new DateTime.now()).inDays + 1 > 1) {
      difference = difference + "(s)";
    }

    return difference;
  }

  Future<Null> showDatePickerDialog(
      BuildContext context, DateTime initialDate) async {
    final DateTime pickedDate = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: initialDate,
      lastDate: new DateTime(initialDate.year + 5),
    );

    if (pickedDate != null && pickedDate != initialDate) {
      pickedDate.day + 1;

      setState(() {
        selectedDate = pickedDate;
      });
    }
  }
}
