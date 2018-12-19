import 'package:flutter/material.dart';
import 'package:savings/utils/colors.dart';
import 'package:savings/utils/logic.dart';
import 'package:savings/utils/models.dart';
import 'package:savings/widgets/themed_container.dart';
import 'package:savings/widgets/themed_text.dart';

class TransactionListItem extends StatefulWidget {
  final Transaction transaction;
  final Transaction lastTransactionForGoal;

  TransactionListItem({@required this.transaction, @required this.lastTransactionForGoal});

  @override
  _TransactionListItemState createState() => new _TransactionListItemState();
}

class _TransactionListItemState extends State<TransactionListItem> {
  @override
  Widget build(BuildContext context) {
    return new CustomThemedContainer(
      padding: new EdgeInsets.all(10.0),
      margin: new EdgeInsets.only(top: 20.0, bottom: widget.lastTransactionForGoal.id == widget.transaction.id ? 20.0 : 0.0),
      child: new Column(
        children: <Widget>[
          new Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              ///Amount Text
              new Row(
                children: <Widget>[
                  ///Amount Positive/Negative Indicator
                  new Container(
                    height: 8.0,
                    width: 8.0,
                    decoration: new BoxDecoration(
                      color: widget.transaction.transactionType == "positive"
                          ? transactionPositiveColor
                          : transactionNegativeColor,
                      gradient: new LinearGradient(
                        colors: widget.transaction.transactionType == 'positive'
                            ? [Colors.green, Colors.green[300]]
                            : [primaryThemeColor, Colors.redAccent[100]],
                      ),
                      borderRadius: new BorderRadius.circular(10.0),
                    ),
                  ),

                  ///Amount Number
                  new Container(
                    margin: new EdgeInsets.only(left: 5.0),
                    alignment: Alignment.centerLeft,
                    child: new CustomThemedText(
                      text: widget.transaction.amount.toString(),
                      //color: widget.transaction.transactionType == "positive" ? transactionPositiveColor : transactionNegativeColor,
                      fontSize: 18.0,
                      letterSpacing: 0.1,
                    ),
                  ),
                ],
              ),
              new Container(
                child: new Text(
                  widget.transaction.date != null
                      ? getDateStringFromDateNumbers(widget.transaction.date)
                      : "",
                  style: new TextStyle(
                    fontWeight: FontWeight.w600,
                    color: Colors.grey[700]
                  ),
                ),
              )
            ],
          ),

          ///Description Text
          new Container(
            margin: new EdgeInsets.only(top: 3.0),
            alignment: Alignment.centerLeft,
            child: new CustomThemedText(
              text: widget.transaction.description,
              letterSpacing: 0.1,
              fontSize: 18.0,
            ),
          ),
        ],
      ),
    );
  }
}
