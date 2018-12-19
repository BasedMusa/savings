class Goal{

  int id;
  String name;
  int cost;
  DateTime deadline;

  Goal({this.id, this.name, this.cost, this.deadline});

  Map<String, dynamic> toMap() {

    var map = new Map<String, dynamic>();
    map["goal_name"] = name;
    map["goal_cost"] = cost != null ? cost.toString() : null;
    map["goal_date_time_day"] = deadline != null ? deadline.day.toString() : null;
    map["goal_date_time_month"] = deadline != null ? deadline.month.toString() : null;
    map["goal_date_time_year"] = deadline != null ? deadline.year.toString() : null;

    return map;
  }

}

class Transaction{

  int id;
  String description;
  String transactionType;
  String attachedGoalName;
  String date;
  int amount;

  Transaction({this.id, this.amount, this.transactionType, this.description, this.attachedGoalName, this.date});

  Map<String, dynamic> toMap() {

    var map = new Map<String, dynamic>();
    map["transaction_description"] = description;
    map["transaction_amount"] = amount.toString();
    map["transaction_type"] = transactionType;
    map["transaction_attached_goal_name"] = attachedGoalName;
    map["transaction_date"] = date;

    return map;
  }

}