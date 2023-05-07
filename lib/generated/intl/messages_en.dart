// DO NOT EDIT. This is code generated via package:intl/generate_localized.dart
// This is a library that provides messages for a en locale. All the
// messages from the main program should be duplicated here with the same
// function name.

// Ignore issues from commonly used lints in this file.
// ignore_for_file:unnecessary_brace_in_string_interps, unnecessary_new
// ignore_for_file:prefer_single_quotes,comment_references, directives_ordering
// ignore_for_file:annotate_overrides,prefer_generic_function_type_aliases
// ignore_for_file:unused_import, file_names, avoid_escaping_inner_quotes
// ignore_for_file:unnecessary_string_interpolations, unnecessary_string_escapes

import 'package:intl/intl.dart';
import 'package:intl/message_lookup_by_library.dart';

final messages = new MessageLookup();

typedef String MessageIfAbsent(String messageStr, List<dynamic> args);

class MessageLookup extends MessageLookupByLibrary {
  String get localeName => 'en';

  static String m0(DATE) => "Selected date: ${DATE}";

  static String m1(DATE) => "Date: ${DATE}";

  static String m2(DATE1, DATE2) => "Selected date: ${DATE1} - ${DATE2}";

  static String m3(SUM) => "Total balance: ${SUM}";

  static String m4(count) =>
      "${Intl.plural(count, zero: 'No transactions', one: '1 transaction', other: '${count} transactions')}";

  static String m5(USED, TOTAL) => "Used credit limit: ${USED}/${TOTAL}";

  final messages = _notInlinedMessages(_notInlinedMessages);
  static Map<String, Function> _notInlinedMessages(_) => <String, Function>{
        "addCategoryTitle":
            MessageLookupByLibrary.simpleMessage("Add category"),
        "addInitialBalanceCategoryTitle":
            MessageLookupByLibrary.simpleMessage("Add initial balance"),
        "addTransactionCategoryHint":
            MessageLookupByLibrary.simpleMessage("Category:"),
        "addTransactionCommentHint":
            MessageLookupByLibrary.simpleMessage("Comment"),
        "addTransactionSumHint": MessageLookupByLibrary.simpleMessage("Sum"),
        "addTransactionTitle":
            MessageLookupByLibrary.simpleMessage("Add transaction"),
        "addTransactionWalletHint":
            MessageLookupByLibrary.simpleMessage("Wallet:"),
        "addWalletCreditLimit":
            MessageLookupByLibrary.simpleMessage("Credit limit"),
        "addWalletOwnBalanceHint":
            MessageLookupByLibrary.simpleMessage("Own balance"),
        "addWalletTitle": MessageLookupByLibrary.simpleMessage("Add wallet"),
        "addWalletTotalBalanceHint":
            MessageLookupByLibrary.simpleMessage("Total balance"),
        "addWalletTypeSelector":
            MessageLookupByLibrary.simpleMessage("Select wallet type"),
        "add_budget_title": MessageLookupByLibrary.simpleMessage("Add budget"),
        "add_category_to_multi_category":
            MessageLookupByLibrary.simpleMessage("Add new category"),
        "appTitle": MessageLookupByLibrary.simpleMessage("Balance Budget"),
        "archive": MessageLookupByLibrary.simpleMessage("Archive"),
        "budgetTabName": MessageLookupByLibrary.simpleMessage("Budgets"),
        "categoriesTitle": MessageLookupByLibrary.simpleMessage("Categories"),
        "category_info_title":
            MessageLookupByLibrary.simpleMessage("Category info"),
        "category_name_title":
            MessageLookupByLibrary.simpleMessage("Category name:"),
        "confirmToArchiveTitle":
            MessageLookupByLibrary.simpleMessage("Are you sure to archive?"),
        "confirmToChangeArchiveText":
            MessageLookupByLibrary.simpleMessage("You can change state later"),
        "confirmToDeleteText":
            MessageLookupByLibrary.simpleMessage("It\'s can be undone!"),
        "confirmToDeleteTitle":
            MessageLookupByLibrary.simpleMessage("Are you sure to delete?"),
        "confirmToUnarchiveTitle":
            MessageLookupByLibrary.simpleMessage("Are you sure to unarchive?"),
        "customDate": MessageLookupByLibrary.simpleMessage("Custom date"),
        "dateString": m0,
        "delete": MessageLookupByLibrary.simpleMessage("Delete"),
        "empty_add_category_to_multi_category":
            MessageLookupByLibrary.simpleMessage(
                "You don\'t add any categories, please press plus for add"),
        "filter": MessageLookupByLibrary.simpleMessage("Filter"),
        "fullDateTimeString": m1,
        "loading": MessageLookupByLibrary.simpleMessage("Loading..."),
        "manageCategoriesButtonText":
            MessageLookupByLibrary.simpleMessage("Manage categories"),
        "manageWalletsButtonText":
            MessageLookupByLibrary.simpleMessage("Manage wallets"),
        "nameHint": MessageLookupByLibrary.simpleMessage("Name"),
        "no": MessageLookupByLibrary.simpleMessage("No"),
        "noBudgets":
            MessageLookupByLibrary.simpleMessage("You don\'t have budget"),
        "noCategories":
            MessageLookupByLibrary.simpleMessage("You don\'t have categories"),
        "noTransactions":
            MessageLookupByLibrary.simpleMessage("You don\'t have transaction"),
        "noWallets":
            MessageLookupByLibrary.simpleMessage("You don\'t have wallets"),
        "ownBalanceTitle": MessageLookupByLibrary.simpleMessage("Own balance:"),
        "remove_category_from_multi_category":
            MessageLookupByLibrary.simpleMessage("Remove category"),
        "save_button": MessageLookupByLibrary.simpleMessage("Save"),
        "select_category":
            MessageLookupByLibrary.simpleMessage("Select category"),
        "select_category_icon":
            MessageLookupByLibrary.simpleMessage("Select icon"),
        "select_wallet_or_keep_empty": MessageLookupByLibrary.simpleMessage(
            "Select wallet, or keep empty for all wallets"),
        "selected_category_icon":
            MessageLookupByLibrary.simpleMessage("Selected icon:"),
        "selected_dates": m2,
        "settingsTabName": MessageLookupByLibrary.simpleMessage("Settings"),
        "signInWithoutRegistration": MessageLookupByLibrary.simpleMessage(
            "Sign in without registration"),
        "sign_out": MessageLookupByLibrary.simpleMessage("Sign out"),
        "sign_out_confirmation_subtitle":
            MessageLookupByLibrary.simpleMessage("Are you sure to sign out?"),
        "today": MessageLookupByLibrary.simpleMessage("Today"),
        "total": MessageLookupByLibrary.simpleMessage("Total: "),
        "totalBalance": m3,
        "totalBalanceTitle":
            MessageLookupByLibrary.simpleMessage("Total balance:"),
        "transactionInfoCategoryPrefix":
            MessageLookupByLibrary.simpleMessage("Category:"),
        "transactionInfoCommentPrefix":
            MessageLookupByLibrary.simpleMessage("Comment:"),
        "transactionInfoEditTitle":
            MessageLookupByLibrary.simpleMessage("Edit transaction"),
        "transactionInfoSumPrefix":
            MessageLookupByLibrary.simpleMessage("Sum:"),
        "transactionInfoTimePrefix":
            MessageLookupByLibrary.simpleMessage("Time:"),
        "transactionInfoTitle":
            MessageLookupByLibrary.simpleMessage("Transaction info"),
        "transactionInfoWalletPrefix":
            MessageLookupByLibrary.simpleMessage("Wallet:"),
        "transactionTypeHint": MessageLookupByLibrary.simpleMessage("Type"),
        "transaction_list_subtitle":
            MessageLookupByLibrary.simpleMessage("Transactions:"),
        "transactions": m4,
        "transactionsTabName":
            MessageLookupByLibrary.simpleMessage("Transactions"),
        "transferCategoryTitle":
            MessageLookupByLibrary.simpleMessage("Transfer"),
        "unarchive": MessageLookupByLibrary.simpleMessage("Unarchive"),
        "usedCreditLimit": m5,
        "usedCreditLimitTitle":
            MessageLookupByLibrary.simpleMessage("Used credit limit:"),
        "walletNameTitle": MessageLookupByLibrary.simpleMessage("Wallet name:"),
        "wallet_info_title":
            MessageLookupByLibrary.simpleMessage("Wallet info"),
        "walletsTabName": MessageLookupByLibrary.simpleMessage("Wallets"),
        "walletsTitle": MessageLookupByLibrary.simpleMessage("Wallets"),
        "yes": MessageLookupByLibrary.simpleMessage("Yes"),
        "yesterday": MessageLookupByLibrary.simpleMessage("Yesterday")
      };
}
