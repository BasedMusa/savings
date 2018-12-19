import 'package:savings/utils/models.dart';
import 'package:savings/utils/variables.dart';

class AnalyticsInterface {
  static logAppOpen() {
    analytics.logAppOpen();
    print('AnalyticsInterface: AppOpenLogged');
  }

  static logEvent(
      {String eventName,
      String eventObject,
      Goal goalData,
      Transaction transactionData}) async {
    if (analytics != null) {
      switch (eventObject) {
        case 'transaction':
          await analytics.logEvent(
            name: eventName,
            parameters: <String, dynamic>{
              'Amount': transactionData.amount,
              'Description': transactionData.description,
              'Type': transactionData.transactionType,
              'Goal': transactionData.attachedGoalName,
            },
          );
          break;
        case 'goal':
          await analytics.logEvent(
            name: eventName,
            parameters: <String, dynamic>{
              'Name': goalData.name,
              'Budget': goalData.cost,
              'Deadline': goalData.deadline.toString(),
            },
          );
          break;
      }
    }
  }

  static changeCurrentScreen({String screenName, String screenOverride}) {
    if (analytics != null) {
      analytics.setCurrentScreen(
          screenName: screenName, screenClassOverride: screenOverride);
    }
  }
}
