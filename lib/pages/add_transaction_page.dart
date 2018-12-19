import 'dart:async';

import 'package:flutter/material.dart';
import 'package:savings/utils/analytics.dart';
import 'package:savings/utils/colors.dart';
import 'package:savings/utils/logic.dart';
import 'package:savings/utils/models.dart';
import 'package:savings/utils/variables.dart';
import 'package:savings/widgets/themed_button.dart';
import 'package:savings/widgets/themed_text_field.dart';

class AddTransactionPage extends StatefulWidget {
  final Goal goal;

  AddTransactionPage({@required this.goal});

  @override
  _AddTransactionPageState createState() => new _AddTransactionPageState();
}

class _AddTransactionPageState extends State<AddTransactionPage> {
  String transactionType = 'positive';
  bool isDisposed = false;
  bool negativeOnly = false;
  bool insufficientBalance = false;

  final addTransactionFormKey = new GlobalKey<FormState>();

  @override
  void initState() {
    AnalyticsInterface.changeCurrentScreen(
        screenName: 'Add Transaction Page',
        screenOverride: 'AddTransactionPage');

    addTransactionDescriptionController.clear();
    addTransactionAmountController.clear();

    checkNegativeOnlyLock();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    AppBar _appBar = new AppBar(
      leading: new Container(
        margin: new EdgeInsets.only(left: 10.0),
        child: new InkWell(
          child: new Container(
              child: new Icon(Icons.clear, color: darkIconColor,
                  size: appBarBackButtonSize)),
          borderRadius: new BorderRadius.circular(30.0),
          onTap: () {
            Navigator.pop(context);
          },
        ),
      ),
      elevation: 0.0,
      backgroundColor: primaryBackgroundColor,
    );

    Widget _body = new Container(
      margin: new EdgeInsets.only(
        left: 23.0,
        right: 23.0,
        top: 15.0,
      ),
      child: new Form(
        key: addTransactionFormKey,
        child: new Column(
          children: <Widget>[

            ///Basic Heading
            new Container(
              alignment: Alignment.centerLeft,
              child: buildHeading('BASIC', 16.0),
            ),

            ///Description text field
            new Container(
              margin: new EdgeInsets.only(top: 22.0),
              child: new CustomThemedTextField(
                fontSize: 25.0,
                maxLength: 35,
                centerText: false,
                hintText: "Enter description",
                textController: addTransactionDescriptionController,
                validator: (_input) {
                  if (validateTextField(typeOfInput: String, input: _input) ==
                      true) {
                    return null;
                  } else {
                    return "You can't leave this field empty";
                  }
                },
              ),
            ),

            ///Amount text field
            new Container(
              margin: new EdgeInsets.only(top: 7.0),
              child: new CustomThemedTextField(
                fontSize: 25.0,
                maxLength: 7,
                centerText: false,
                hintText: "Enter amount",
                textController: addTransactionAmountController,
                keyboardType: TextInputType.number,
                validator: (_input) {
                  if (validateTextField(typeOfInput: int, input: _input) ==
                      true) {
                    return null;
                  } else {
                    return "You can't leave this field empty";
                  }
                },
              ),
            ),

            ///Transaction Type Heading
            new Container(
              margin: new EdgeInsets.only(top: 5.0),
              alignment: Alignment.centerLeft,
              child: buildHeading("TRANSACTION TYPE", 16.0),
            ),

            ///Transaction Type Toggle Switch
            new Container(
              margin: new EdgeInsets.only(top: 15.0),
              alignment: Alignment.centerLeft,
              child: new CustomThemedButton(
                isDisabled: negativeOnly,
                text: negativeOnly
                    ? 'Negative'
                    : transactionType == 'positive' ? "Positive" : "Negative",
                shadowsVisible: false,
                width: 100.0,
                color: transactionType == 'positive'
                    ? transactionPositiveColor
                    : transactionNegativeColor,
                onTap: () {
                  if (transactionType == 'positive') {
                    setState(() {
                      transactionType = 'negative';
                    });
                  } else {
                    setState(() {
                      transactionType = 'positive';
                    });
                  }
                },
              ),
            ),
            negativeOnly
                ? new Padding(
              padding:
              const EdgeInsets.only(top: 15.0, right: 3.0, left: 3.0),
              child: new Text(
                'i.e. this is disabled because you have already completed your goal',
                style: new TextStyle(
                  fontWeight: FontWeight.w600,
                  color: darkHeadingsTextColor,
                ),
              ),
            )
                : new Container(),
            insufficientBalance
                ? new Padding(
              padding:
              const EdgeInsets.only(top: 15.0, right: 3.0, left: 3.0),
              child: new Container(
                alignment: Alignment.centerLeft,
                child: new Text(
                  'i.e. insufficient balance',
                  style: new TextStyle(
                    fontWeight: FontWeight.w600,
                    color: primaryThemeColor,
                  ),
                ),
              ),
            )
                : new Container(),
          ],
        ),
      ),
    );

    return new Scaffold(
      appBar: _appBar,
      body: _body,
      bottomNavigationBar: bottomNavBar(),
    );
  }

  @override
  void dispose() {
    isDisposed = true;

    super.dispose();
  }

  Widget bottomNavBar() {
    return new BottomAppBar(
      elevation: 0.0,
      color: primaryBackgroundColor,
      child: new Container(
          margin: new EdgeInsets.only(
              bottom: bottomMarginForMainButtons, top: 10.0),
          child: addTransactionButton()),
    );
  }

  Widget addTransactionButton() {
    return new Hero(
      tag: "AddTransactionHero",
      child: new Container(
        margin: new EdgeInsets.only(left: 23.0, right: 23.0),
        child: new CustomThemedButton(
          height: kBottomNavigationBarHeight - 10.0,
          text: 'Add Transaction',
          onTap: submitForm,
          invertedDesign: true,
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

  Future<int> addNewTransaction() async {
    //This method uses a int to return to indicate whether transaction was successful or not
    //1 if positive feedback and 0 for negative feedback

    var goalBalance = getBalanceFromGoal(widget.goal);
    var transactionAmount = int.parse(addTransactionAmountController.text);
    var currentDateTime = new DateTime.now();

    //Check if the negative amount is greater than what the user has as balance
    //So that the balance does not become negative i.e (-503)
    if (transactionAmount > goalBalance && transactionType == 'negative') {
      if (!isDisposed) {
        setState(() {
          insufficientBalance = true;
        });
      }

      //Log output
      print(
          'User does not have enough money to carry out this negative transaction');
      print(
          'Balance: $goalBalance is less than NegativeTransactionAmount: $transactionAmount');

      return 0;
    } else {
      setState(() {
        insufficientBalance = false;
      });

      //Create a new transaction object
      Transaction newTransaction = new Transaction(
        amount: transactionAmount,
        description: addTransactionDescriptionController.text,
        transactionType: transactionType,
        attachedGoalName: widget.goal.name,
        date: currentDateTime.day.toString() + '-' + currentDateTime.month.toString() + '-' + currentDateTime.year.toString(),
      );

      //Insert object to database
      DatabaseInterface.insertToDB('transaction', transaction: newTransaction);

      AnalyticsInterface.logEvent(
          eventName: 'NewTransactionAdded',
          eventObject: 'transaction',
          transactionData: newTransaction);

      setState(() {
        allTransactionsList.insert(0, newTransaction);
      });

      return 1;
    }
  }

  checkNegativeOnlyLock() {
    if (widget.goal.cost != null) {
      if (getBalanceFromGoal(widget.goal) >= widget.goal.cost) {
        setState(() {
          negativeOnly = true;
          transactionType = 'negative';
        });
        print('Transaction Type is locked to NEGATIVE');
      } else {
        setState(() {
          negativeOnly = false;
          transactionType = 'positive';
        });
      }
    } else {
      setState(() {
        negativeOnly = false;
        transactionType = 'positive';
      });
    }
  }

  Future<Null> submitForm() async {
    if (addTransactionFormKey.currentState.validate()) {
      if (await addNewTransaction() == 1) {
        Navigator.pop(context);
      }
    }
  }
}
