import '../../../../accounts/common/data/models/account_id.dart';
import '../../../../common/data/models/transaction_type.dart';
import '../../../../transactions/common/data/models/transaction.dart';
import '../../../common/data/models/budget.dart';
import 'date_period_validation.dart';

class TotalBudgetSpendSumCalculator {
  final DatePeriodValidation _periodValidation = const DatePeriodValidation();

  const TotalBudgetSpendSumCalculator();

  double calculate(TotalBudget budget, List<Transaction> transactions) {
    var filteredTransaction = transactions.where((element) {
      return element.transactionType == TransactionType.spend &&
          _periodValidation.isInCurrentPeriod(element.time, budget.repeatType,
              budget.startDate, budget.endDate) &&
          _isCorrectAccount(budget.accounts, element.accountId);
    });

    double totalSpends = 0.0;
    for (var value in filteredTransaction) {
      totalSpends += value.sum;
    }
    return totalSpends;
  }

  bool _isCorrectAccount(List<AccountId> accounts, AccountId id) {
    return accounts.isEmpty || accounts.contains(id);
  }
}
