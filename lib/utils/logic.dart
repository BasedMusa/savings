import 'dart:async';
import 'dart:io';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:savings/utils/models.dart' as models;
import 'package:savings/utils/variables.dart';

///This logic.dart file is for
/// handling app's all main level logic

validateTextField({dynamic typeOfInput, String input}) {
  ///This method first checks if the input to be validated is
  /// String or Int then validates it by using the public
  /// CONTAINS method for the String class

  ///The return boolean
  bool isValid = true;

  ///Check the input type in switch statement
  switch (typeOfInput) {

    ///If number text field
    case int:

      ///If then else check
      if (input.contains('0') ||
          input.contains('1') ||
          input.contains('2') ||
          input.contains('3') ||
          input.contains('4') ||
          input.contains('5') ||
          input.contains('6') ||
          input.contains('7') ||
          input.contains('8') ||
          input.contains('9')) {
        ///Input text contains proper letters
        ///so the isValid boolean will be set to true
        isValid = true;
      } else {
        ///Input text does not contain proper letters
        ///so the isValid boolean will be set to false
        isValid = false;
      }
      break;

    ///If number text field
    case String:

      ///If then else check
      if (input.contains('a') ||
          input.contains('b') ||
          input.contains('c') ||
          input.contains('d') ||
          input.contains('e') ||
          input.contains('f') ||
          input.contains('g') ||
          input.contains('h') ||
          input.contains('i') ||
          input.contains('j') ||
          input.contains('k') ||
          input.contains('l') ||
          input.contains('m') ||
          input.contains('n') ||
          input.contains('o') ||
          input.contains('p') ||
          input.contains('q') ||
          input.contains('r') ||
          input.contains('s') ||
          input.contains('t') ||
          input.contains('u') ||
          input.contains('v') ||
          input.contains('w') ||
          input.contains('x') ||
          input.contains('y') ||
          input.contains('z') ||
          input.contains('A') ||
          input.contains('B') ||
          input.contains('C') ||
          input.contains('D') ||
          input.contains('E') ||
          input.contains('F') ||
          input.contains('G') ||
          input.contains('H') ||
          input.contains('I') ||
          input.contains('J') ||
          input.contains('K') ||
          input.contains('L') ||
          input.contains('M') ||
          input.contains('N') ||
          input.contains('O') ||
          input.contains('P') ||
          input.contains('Q') ||
          input.contains('R') ||
          input.contains('S') ||
          input.contains('T') ||
          input.contains('U') ||
          input.contains('V') ||
          input.contains('W') ||
          input.contains('X') ||
          input.contains('Y') ||
          input.contains('Z')) {
        ///Input text contains proper letters
        ///so the isValid boolean will be set to true
        isValid = true;
      } else {
        ///Input text does not contain proper letters
        ///so the isValid boolean will be set to false
        isValid = false;
      }
      break;
  }

  ///Return isValid boolean
  return isValid;
}

List<models.Transaction> getTransactionsFromGoal(models.Goal goal) {
  ///All the transactions found for the requested goal will be stored in this local list
  List<models.Transaction> transactionsForRequestedGoal = new List();

  ///Loop through every transaction and check if it is attached to the requested goal
  for (int i = 0; i < allTransactionsList.length; i++) {
    ///Store the looped transaction in a variable
    models.Transaction loopedTransaction = allTransactionsList[i];

    ///Check attached goal name
    if (loopedTransaction.attachedGoalName == goal.name) {
      ///If attached goal name matches then add the looped transaction to the local list
      transactionsForRequestedGoal.add(loopedTransaction);
    }
  }

  ///Finally, return the list
  return transactionsForRequestedGoal;
}

int getBalanceFromGoal(models.Goal goal) {
  ///Store the sum of all the positive and negative for
  ///the given goal in these variables during the for loop
  int positiveTransactionsForGoal = 0;
  int negativeTransactionsForGoal = 0;

  ///Get all the transactions for the passed in goal
  List<models.Transaction> transactionsForGoal = getTransactionsFromGoal(goal);

  ///This will loop through all the positive transactions for the given goal
  ///And add them to positiveSavingsForGoal variable
  for (int i = 0; i < transactionsForGoal.length; i++) {
    models.Transaction transaction = transactionsForGoal[i];

    ///Check if the transaction is positive
    if (transaction.transactionType == "positive") {
      positiveTransactionsForGoal =
          positiveTransactionsForGoal + transaction.amount;
    }
  }

  ///This will loop through all the negative transactions for the given goal
  ///And add them to negativeSavingsForGoal variable
  for (int i = 0; i < transactionsForGoal.length; i++) {
    models.Transaction transaction = transactionsForGoal[i];

    ///Check if the transaction is negative
    if (transaction.transactionType == "negative") {
      negativeTransactionsForGoal =
          negativeTransactionsForGoal + transaction.amount;
    }
  }

  ///Subtract negative from positive
  ///transactions and store the value in a balance variable
  int balance = positiveTransactionsForGoal - negativeTransactionsForGoal;

  ///Return balance amount
  return balance;
}

String getMonthNameFromMonthNumber(int monthNumber,
    {bool shortenName = false}) {
  ///If not to return short name of month
  if (!shortenName) {
    ///Make a list for all the months names
    var monthsInString = [
      "January",
      "February",
      "March",
      "April",
      "May",
      "June",
      "July",
      "August",
      "September",
      "October",
      "November",
      "December",
    ];

    ///Return the monthName according to the passed in monthNumber
    return monthsInString[monthNumber - 1];
  } else {
    ///Make a list for all the short names of months
    var monthsInString = [
      "Jan",
      "Feb",
      "Mar",
      "Apr",
      "May",
      "June",
      "July",
      "Aug",
      "Sep",
      "Oct",
      "Nov",
      "Dec",
    ];

    ///Return the monthName according to the passed in monthNumber
    return monthsInString[monthNumber - 1];
  }
}

String getStringDeadlineFromGoal(models.Goal goal, {bool byPrefix = true}) {
  ///This method returns a deadline for goal that is
  ///ready to use in text widget, if deadline is null,
  ///"No deadline" is returned

  ///If there is a deadline or limitless time
  if (goal.deadline != null) {
    ///Get the month name in string format
    String monthName = getMonthNameFromMonthNumber(goal.deadline.month);

    ///Prepare the other two dates as well in string format
    String dateNumber = goal.deadline.day.toString();
    String yearNumber = goal.deadline.year.toString();

    ///Combine them into one sentence while also checking
    ///if by prefix is to be included or not
    String deadlineSentence;

    if (byPrefix == true) {
      deadlineSentence = 'by $monthName $dateNumber, $yearNumber';
    } else {
      deadlineSentence = '$monthName $dateNumber, $yearNumber';
    }

    ///Return the deadline sentence
    return deadlineSentence;
  } else {
    ///Just return dead text to state that there is no deadline for the passed goal
    return 'No deadline';
  }
}

double getCompletionPercentageFromGoal(models.Goal goal,
    {bool toClamp = false}) {
  ///Calculate how much of the goal has been completed by
  ///multiplying the total savings by 100 and dividing the
  ///result by the total cost

  ///Store all the transactions for that goal in a local list
  var transactionsForGoal = getTransactionsFromGoal(goal);

  ///If there are no transactions for the goal, then we can safely return 0.0
  ///This is an efficient way to avoid calling getBalanceForGoal thus
  ///improving the calculation time of this function
  if (transactionsForGoal.length >= 1) {
    ///Calculate
    var completionPercentage;

    if (goal.cost != null) {
      completionPercentage = (getBalanceFromGoal(goal) * 100) / goal.cost;

      ///Check the toClamp boolean and clamp the percentage
      ///Clamp means to limit the a number between two given values
      ///In our case, 0 and 100 as to get 100% else the method might return something like 1383%
      if (toClamp) {
        completionPercentage = completionPercentage.clamp(0.0, 100.0);
      }

      ///Return the value
      return completionPercentage;
    } else {
      return 100.0;
    }
  } else {
    return 0.0;
  }
}

String getDateStringFromDateNumbers(String dateNumbersString) {
  ///This returns a nicely formatted string date from the the passed in dateNumbersString

  ///Extract the numbers from the date string and store them in list
  List<int> figuresList =
      getFiguresListFromDateNumbersString(dateNumbersString);

  ///Retrieve the current date/time
  DateTime currentDateTime = new DateTime.now();

  ///If the passed in date's year matches the current one then do not include the year in the return string
  if (figuresList[2] == currentDateTime.year) {
    return figuresList[0].toString() +
        ' ' +
        getMonthNameFromMonthNumber(figuresList[1]);

    ///else return the string with year included
  } else {
    return figuresList[0].toString() +
        ' ' +
        getMonthNameFromMonthNumber(figuresList[1]) +
        ' ' +
        figuresList[2].toString();
  }
}

List<int> getFiguresListFromDateNumbersString(String dateNumbersString) {
  ///This method extracts the numbers from a specific type of string i.e 26-7-2018
  ///and stores them in a list and returns them after converting them to integers from strings
  List<String> figuresListString = dateNumbersString.split('-');
  List<int> figuresList = new List();

  for (String dateNumber in figuresListString) {
    figuresList.add(BigInt.parse(dateNumber).toInt());
  }

  return figuresList;
}

int getBalanceFromGoalsList(allGoalsList) {
  ///This method returns the total amount the user has saved using the allGoalsList

  int totalSavings = 0;
  for (var loopedGoal in allGoalsList) {
    totalSavings = totalSavings + getBalanceFromGoal(loopedGoal);
  }

  return totalSavings;
}

///NOTE:
/// This class is specific to database logic
class DatabaseInterface {
  static Future<Database> getDB() async {
    ///Get a string path to the database
    String path = await _getDBLocation();

    ///Open the database
    Database _database = await openDatabase(path, version: 1,
        onCreate: (Database db, int version) async {
      ///Queries to be executed when creating new database
      ///
      /// Create the Goals table
      await db.execute(
          "CREATE TABLE Goals (id INTEGER PRIMARY KEY, goal_name TEXT, goal_cost INTEGER, goal_date_time_day INTEGER, goal_date_time_month INTEGER, goal_date_time_year INTEGER)");

      /// Create the Transactions table
      await db.execute(
          "CREATE TABLE Transactions (id INTEGER PRIMARY KEY, transaction_description TEXT, transaction_amount INTEGER, transaction_type TEXT, transaction_attached_goal_name TEXT)");
    });

    return _database;
  }

  static closeDB() async {
    ///This method closes the database
    ///It is a good practice to properly close database after a user has completed his session
    await appDatabase.close();

    ///Log output
    print("Database Closed");
  }

  static Future<String> _getDBLocation() async {
    /// Get the location of app sql database using path_provider as Directory class
    Directory documentsDirectory = await getApplicationDocumentsDirectory();

    ///Use the directory classpath to get a string path
    String path = join(documentsDirectory.path, "com.quickfix.savings.db");

    ///Return the path
    return path;
  }

  static Future<List<models.Transaction>> getAllTransactionsFromDB() async {
    ///Return the records after retrieving them from the DB using a private method
    ///The main purpose of this method is to provide an evaluated method
    ///that can easily be understood by it's name
    return await DatabaseInterface._getRecordsFromDB(models.Transaction);
  }

  static Future<List<models.Goal>> getAllGoalsFromDB() async {
    ///Return the records after retrieving them from the DB using a private method
    ///The main purpose of this method is to provide an evaluated method
    ///that can easily be understood by it's name
    return await DatabaseInterface._getRecordsFromDB(models.Goal);
  }

  static insertToDB(String objectToAdd,
      {models.Transaction transaction, models.Goal goal}) async {
    ///This method takes in an object to add and
    ///inserts it into the database using switch
    ///statement to check weather it's a goal object or a transaction
    switch (objectToAdd) {

      ///If the object is a transaction
      case 'transaction':

        ///Use SQFlite s helper method to insert a transaction in the Transactions table
        ///This method requires a map of the object so we will first convert
        /// it to a map using the toMap constructor
        int queryResponse;

        ///The try catch is used to catch exception the db might throw
        /// which might here be because the column 'transaction_date' does not exist
        /// So the upgradeDB method is called while 2 is passed in as the new version
        /// to add the column to it
        try {
          queryResponse =
              await appDatabase.insert("Transactions", transaction.toMap());
        } on DatabaseException catch (e) {
          print('Transaction Inserted Exception: $e');
          DatabaseInterface.upgradeDB([transaction]);
        }

        if (queryResponse != null) {
          print('Transaction Inserted Response: $queryResponse');
        }

        break;

      ///If the object is a goal
      case 'goal':

        ///Use SQFlite s helper method to insert a goal in the Goals table
        ///This method requires a map of the object so we will first convert
        /// it to a map using the toMap constructor
        int queryResponse = await appDatabase.insert("Goals", goal.toMap());

        print('Goal Inserted Response: $queryResponse');

        break;
    }
  }

  static updateToDB({models.Goal editedGoal, models.Goal toEditGoal}) async {
    ///This method updates a record in the database using the SQFlite helper

    ///Update goal record
    int queryResponse = await appDatabase.update("Goals", editedGoal.toMap(),
        where: "goal_name = ?", whereArgs: [toEditGoal.name]);

    ///Update the attached goal name's of all the transactions for that goal

    /// First get all the transactions attached to the to edit goal
    List<models.Transaction> transactionsForEditedGoal =
        getTransactionsFromGoal(toEditGoal);

    ///One by one update them in the database by changing their attachedGoalName variable
    for (int i = 0; i < transactionsForEditedGoal.length; i++) {
      ///Grab the transaction to update
      models.Transaction transactionToUpdate = transactionsForEditedGoal[i];

      ///Change attachedGoalName variable
      transactionToUpdate.attachedGoalName = editedGoal.name;

      ///Update to DB
      int queryResponse = await appDatabase.update(
          "Transactions", transactionToUpdate.toMap(),
          where: "id = ?", whereArgs: [transactionToUpdate.id]);

      print('Transaction Attached Goal Name Update Response: $queryResponse');
    }

    ///Log output
    print('Goal Updated Response: $queryResponse');
  }

  static Future<List> _getRecordsFromDB(

      ///Will be a Transaction or Goal object
      var objectToRetrieve) async {
    ///These two lists will be used to store the objects
    /// when retrieved from DB and later returned back
    List<models.Transaction> transactionsFromDB = new List();
    List<models.Goal> goalsFromDB = new List();

    ///Use a switch statement to check if the object type to
    /// be retrieved is goals or transactions
    switch (objectToRetrieve) {

      ///In case they are of type Transaction
      case models.Transaction:

        ///The mapped version list that is returned from the database directly
        List<Map> mappedTransactionsFromDB =
            await appDatabase.query('Transactions', orderBy: 'id DESC');

        ///Loop through the list and create new Transaction objects
        ///Then add them to the transactionsFromDB list and break the statement
        for (var map in mappedTransactionsFromDB) {
          ///Create a new object from the mapped list
          models.Transaction newTransaction = new models.Transaction(
            id: map['id'],
            attachedGoalName: map['transaction_attached_goal_name'],
            transactionType: map['transaction_type'],
            description: map['transaction_description'],
            amount: map['transaction_amount'],
            date: map['transaction_date'],
          );

          ///Add to the list
          transactionsFromDB.add(newTransaction);
        }
        break;

      ///In case they are of type Goal
      case models.Goal:

        ///The mapped version list that is returned from the database directly
        List<Map> mappedGoalsFromDB =
            await appDatabase.rawQuery('SELECT * FROM Goals');

        ///Loop through the list and create new Goal objects
        ///Then add them to the goalsFromDB list and break the statement
        for (int i = 0; i < mappedGoalsFromDB.length; i++) {
          ///For differentiating the goals ith and without deadlines
          ///We will use if then else to check the variables if they are null

          ///Preparing variables for the deadline
          var _deadlineYear = mappedGoalsFromDB[i]['goal_date_time_year'];
          var _deadlineMonth = mappedGoalsFromDB[i]['goal_date_time_month'];
          var _deadlineDay = mappedGoalsFromDB[i]['goal_date_time_day'];

          ///For use in the Goal object, will be declared null in if
          /// then else if any of the above variables is null else
          /// will be initiated properly with values
          DateTime _deadline;

          ///Checking if the deadline for the goal is null
          ///The only way it can be null is if the user has disabled it
          ///
          /// After null check a DateTime object is  created from the
          /// non-null variables for use in the goal
          if (_deadlineDay == null) {
            _deadline = null;
          } else {
            _deadline =
                new DateTime(_deadlineYear, _deadlineMonth, _deadlineDay);
          }

          ///Create a new object from the mapped list
          models.Goal newGoal = new models.Goal(
            id: mappedGoalsFromDB[i]['id'],
            name: mappedGoalsFromDB[i]['goal_name'],
            cost: mappedGoalsFromDB[i]['goal_cost'],
            deadline: _deadline,
          );

          ///Add to the list
          goalsFromDB.add(newGoal);
        }
        break;
    }

    ///Determine which object to be sent back depending on the
    ///one which was requested
    if (objectToRetrieve == models.Transaction) {
      return transactionsFromDB;
    } else {
      return goalsFromDB;
    }
  }

  static Future deleteFromDB(models.Goal goal) async {
    ///Delete the goal from the database using helper method for delete query
    int queryResponseGoal = await appDatabase
        .delete('Goals', where: 'id = ?', whereArgs: [goal.id]);

    ///Log output
    print('Goal Deletion Response: $queryResponseGoal');

    ///Delete all the transactions that are attached to the goal
    int queryResponseTransactions = await appDatabase.delete('Transactions',
        where: 'transaction_attached_goal_name = ?', whereArgs: [goal.name]);

    ///Log output
    print('Transaction Deletion Response: $queryResponseTransactions');
  }

  static Future upgradeDB(var arguments) async {
    ///Get a string path to the database
    String path = await _getDBLocation();

    ///Upgrade the db
    appDatabase = await openDatabase(path, version: 2,
        onUpgrade: (db, oldVersion, newVersion) async {
      switch (oldVersion) {
        case 1:
          await db
              .execute("ALTER TABLE Transactions ADD transaction_date TEXT");
      }
    });
    DatabaseInterface.insertToDB('transaction', transaction: arguments[0]);
  }
}
