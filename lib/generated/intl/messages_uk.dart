// DO NOT EDIT. This is code generated via package:intl/generate_localized.dart
// This is a library that provides messages for a uk locale. All the
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
  String get localeName => 'uk';

  static String m0(DATE) => "Вибрана дата: ${DATE}";

  static String m1(DATE) => "Дата: ${DATE}";

  static String m2(DATE1, DATE2) => "Обрані дати: ${DATE1} - ${DATE2}";

  static String m3(SUM) => "Загальний баланс: ${SUM}";

  static String m4(count) =>
      "${Intl.plural(count, zero: 'Немає транзакцій', one: '1 транзакція', two: '2 транзакції', other: '${count} транзакцій')}";

  static String m5(USED, TOTAL) =>
      "Використаний кредитний ліміт: ${USED}/${TOTAL}";

  final messages = _notInlinedMessages(_notInlinedMessages);
  static Map<String, Function> _notInlinedMessages(_) => <String, Function>{
        "addCategoryTitle":
            MessageLookupByLibrary.simpleMessage("Додати категорію"),
        "addInitialBalanceCategoryTitle": MessageLookupByLibrary.simpleMessage(
            "Налаштований стандартний баланс"),
        "addTransactionCategoryHint":
            MessageLookupByLibrary.simpleMessage("Категорія:"),
        "addTransactionCommentHint":
            MessageLookupByLibrary.simpleMessage("Коментар"),
        "addTransactionSumHint": MessageLookupByLibrary.simpleMessage("Сума"),
        "addTransactionTitle":
            MessageLookupByLibrary.simpleMessage("Додати транзакцію"),
        "addTransactionWalletHint":
            MessageLookupByLibrary.simpleMessage("Гаманець:"),
        "addWalletCreditLimit":
            MessageLookupByLibrary.simpleMessage("Кредитний ліміт"),
        "addWalletOwnBalanceHint":
            MessageLookupByLibrary.simpleMessage("Власний баланс"),
        "addWalletTitle":
            MessageLookupByLibrary.simpleMessage("Додати гаманець"),
        "addWalletTotalBalanceHint":
            MessageLookupByLibrary.simpleMessage("Загальний баланс"),
        "addWalletTypeSelector":
            MessageLookupByLibrary.simpleMessage("Виберіть тип гаманця"),
        "add_budget_title":
            MessageLookupByLibrary.simpleMessage("Додати бюджет"),
        "add_category_to_multi_category":
            MessageLookupByLibrary.simpleMessage("Add new category"),
        "appTitle": MessageLookupByLibrary.simpleMessage("Balance Budget"),
        "archive": MessageLookupByLibrary.simpleMessage("Archive"),
        "budgetTabName": MessageLookupByLibrary.simpleMessage("Бюджети"),
        "categoriesTitle": MessageLookupByLibrary.simpleMessage("Категорії"),
        "category_info_title":
            MessageLookupByLibrary.simpleMessage("Інформація про категорію"),
        "category_name_title":
            MessageLookupByLibrary.simpleMessage("Назва категорії:"),
        "confirmToArchiveTitle":
            MessageLookupByLibrary.simpleMessage("Are you sure to archive?"),
        "confirmToChangeArchiveText":
            MessageLookupByLibrary.simpleMessage("You can change state later"),
        "confirmToDeleteText":
            MessageLookupByLibrary.simpleMessage("Це неможливо відмінити!"),
        "confirmToDeleteTitle": MessageLookupByLibrary.simpleMessage(
            "Ви впевненні що хочете видалити?"),
        "confirmToUnarchiveTitle":
            MessageLookupByLibrary.simpleMessage("Are you sure to unarchive?"),
        "customDate": MessageLookupByLibrary.simpleMessage("Інша дата"),
        "dateString": m0,
        "delete": MessageLookupByLibrary.simpleMessage("Видалити"),
        "empty_add_category_to_multi_category":
            MessageLookupByLibrary.simpleMessage(
                "You don\'t add any categories, please press plus for add"),
        "filter": MessageLookupByLibrary.simpleMessage("Фільтри"),
        "fullDateTimeString": m1,
        "loading": MessageLookupByLibrary.simpleMessage("Завантаження..."),
        "manageCategoriesButtonText":
            MessageLookupByLibrary.simpleMessage("Управління категоріями"),
        "manageWalletsButtonText":
            MessageLookupByLibrary.simpleMessage("Управління гаманцями"),
        "nameHint": MessageLookupByLibrary.simpleMessage("Назва"),
        "no": MessageLookupByLibrary.simpleMessage("Ні"),
        "noBudgets": MessageLookupByLibrary.simpleMessage(
            "У Вас немає запланованих бюджетів!"),
        "noCategories":
            MessageLookupByLibrary.simpleMessage("У Вас немає категорій!"),
        "noTransactions":
            MessageLookupByLibrary.simpleMessage("У Вас немає транзакцій!"),
        "noWallets":
            MessageLookupByLibrary.simpleMessage("У Вас немає гаманців!"),
        "ownBalanceTitle":
            MessageLookupByLibrary.simpleMessage("Власний баланс:"),
        "remove_category_from_multi_category":
            MessageLookupByLibrary.simpleMessage("Remove category"),
        "save_button": MessageLookupByLibrary.simpleMessage("Зберегти"),
        "select_category":
            MessageLookupByLibrary.simpleMessage("Select category"),
        "select_category_icon":
            MessageLookupByLibrary.simpleMessage("Select icon"),
        "select_wallet_or_keep_empty": MessageLookupByLibrary.simpleMessage(
            "Select wallet, or keep empty for all wallets"),
        "selected_category_icon":
            MessageLookupByLibrary.simpleMessage("Selected icon:"),
        "selected_dates": m2,
        "settingsTabName": MessageLookupByLibrary.simpleMessage("Налаштування"),
        "signInWithoutRegistration":
            MessageLookupByLibrary.simpleMessage("Вхід без реєстрації"),
        "sign_out": MessageLookupByLibrary.simpleMessage("Вийти"),
        "sign_out_confirmation_subtitle": MessageLookupByLibrary.simpleMessage(
            "Ви впевнені що хочете вийти?"),
        "today": MessageLookupByLibrary.simpleMessage("Сьогодні"),
        "total": MessageLookupByLibrary.simpleMessage("Усього: "),
        "totalBalance": m3,
        "totalBalanceTitle":
            MessageLookupByLibrary.simpleMessage("Загальний баланс:"),
        "transactionInfoCategoryPrefix":
            MessageLookupByLibrary.simpleMessage("Категорія:"),
        "transactionInfoCommentPrefix":
            MessageLookupByLibrary.simpleMessage("Коментар:"),
        "transactionInfoEditTitle":
            MessageLookupByLibrary.simpleMessage("Редагування транзакції"),
        "transactionInfoSumPrefix":
            MessageLookupByLibrary.simpleMessage("Сума:"),
        "transactionInfoTimePrefix":
            MessageLookupByLibrary.simpleMessage("Час:"),
        "transactionInfoTitle":
            MessageLookupByLibrary.simpleMessage("Інформація про транзакцію"),
        "transactionInfoWalletPrefix":
            MessageLookupByLibrary.simpleMessage("Гаманець:"),
        "transactionTypeHint": MessageLookupByLibrary.simpleMessage("Тип"),
        "transaction_list_subtitle":
            MessageLookupByLibrary.simpleMessage("Транзакції:"),
        "transactions": m4,
        "transactionsTabName":
            MessageLookupByLibrary.simpleMessage("Транзакції"),
        "transferCategoryTitle":
            MessageLookupByLibrary.simpleMessage("Переказ"),
        "unarchive": MessageLookupByLibrary.simpleMessage("Unarchive"),
        "usedCreditLimit": m5,
        "usedCreditLimitTitle": MessageLookupByLibrary.simpleMessage(
            "Використаний кредитний ліміт:"),
        "walletNameTitle":
            MessageLookupByLibrary.simpleMessage("Назва гаманця:"),
        "wallet_info_title":
            MessageLookupByLibrary.simpleMessage("Інформація про гаманець"),
        "walletsTabName": MessageLookupByLibrary.simpleMessage("Гаманці"),
        "walletsTitle": MessageLookupByLibrary.simpleMessage("Гаманці"),
        "yes": MessageLookupByLibrary.simpleMessage("Так"),
        "yesterday": MessageLookupByLibrary.simpleMessage("Вчора")
      };
}
