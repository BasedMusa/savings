import 'package:flutter/material.dart';
import 'package:savings/utils/colors.dart';
import 'package:savings/utils/logic.dart';
import 'package:savings/utils/variables.dart';
import 'package:savings/widgets/themed_container.dart';
import 'package:savings/widgets/themed_text.dart';

class SavingsDashboard extends StatefulWidget {
  @override
  _SavingsDashboardState createState() => _SavingsDashboardState();
}

class _SavingsDashboardState extends State<SavingsDashboard> {
  @override
  Widget build(BuildContext context) {
    return CustomThemedContainer(
      margin: new EdgeInsets.only(right: 22.0, top: 40.0, left: 22.0),
      padding: new EdgeInsets.all(16.0),
      width: double.maxFinite,
      outerRadius: 6.0,
      child: Container(
        child: new Column(
          children: <Widget>[
            new Container(
              child: Column(
                children: <Widget>[
                  ///Balance Heading
                  new Container(
                      alignment: Alignment.centerLeft,
                      child: new CustomThemedText(
                        text: 'Balance',
                        bold: true,
                        fontSize: 25.0,
                      )),
                  ///Current Date Text
                  new Container(
                    alignment: Alignment.centerLeft,
                    child: new CustomThemedText(
                      text: dateString(),
                      bold: true,
                      fontSize: 18.0,
                      color: darkHeadingsTextColor,
                    ),
                  )
                ],
              ),
            ),
            ///Balance Amount Text
            new Container(
              margin: new EdgeInsets.only(top: 20.0),
              alignment: Alignment.centerLeft,
              child: new CustomThemedText(text: totalSaved(), fontSize: 35.0,),
            )
          ],
        ),
      ),
    );
  }

  String dateString() {
    var currentDate = new DateTime.now();
    var currentMonthString = getMonthNameFromMonthNumber(currentDate.month, shortenName: true);

    return 'Today, ' + currentDate.day.toString() + ' $currentMonthString';
  }

  String totalSaved() {
    var totalSaved = getBalanceFromGoalsList(allGoalsList);

    if (totalSaved > 99999) {
      return '99999+';
    } else {
      return totalSaved.toString();
    }

  }
}
