// GENERATED CODE - DO NOT MODIFY BY HAND
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'intl/messages_all.dart';

// **************************************************************************
// Generator: Flutter Intl IDE plugin
// Made by Localizely
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, lines_longer_than_80_chars
// ignore_for_file: join_return_with_assignment, prefer_final_in_for_each
// ignore_for_file: avoid_redundant_argument_values, avoid_escaping_inner_quotes

class S {
  S();

  static S? _current;

  static S get current {
    assert(_current != null,
        'No instance of S was loaded. Try to initialize the S delegate before accessing S.current.');
    return _current!;
  }

  static const AppLocalizationDelegate delegate = AppLocalizationDelegate();

  static Future<S> load(Locale locale) {
    final name = (locale.countryCode?.isEmpty ?? false)
        ? locale.languageCode
        : locale.toString();
    final localeName = Intl.canonicalizedLocale(name);
    return initializeMessages(localeName).then((_) {
      Intl.defaultLocale = localeName;
      final instance = S();
      S._current = instance;

      return instance;
    });
  }

  static S of(BuildContext context) {
    final instance = S.maybeOf(context);
    assert(instance != null,
        'No instance of S present in the widget tree. Did you add S.delegate in localizationsDelegates?');
    return instance!;
  }

  static S? maybeOf(BuildContext context) {
    return Localizations.of<S>(context, S);
  }

  /// `Balance Budget`
  String get appTitle {
    return Intl.message(
      'Balance Budget',
      name: 'appTitle',
      desc: '',
      args: [],
    );
  }

  /// `Sign in without registration`
  String get signInWithoutRegistration {
    return Intl.message(
      'Sign in without registration',
      name: 'signInWithoutRegistration',
      desc: '',
      args: [],
    );
  }

  /// `Transactions`
  String get transactionsTabName {
    return Intl.message(
      'Transactions',
      name: 'transactionsTabName',
      desc: '',
      args: [],
    );
  }

  /// `Budgets`
  String get budgetTabName {
    return Intl.message(
      'Budgets',
      name: 'budgetTabName',
      desc: '',
      args: [],
    );
  }

  /// `Wallets`
  String get walletsTabName {
    return Intl.message(
      'Wallets',
      name: 'walletsTabName',
      desc: '',
      args: [],
    );
  }

  /// `Settings`
  String get settingsTabName {
    return Intl.message(
      'Settings',
      name: 'settingsTabName',
      desc: '',
      args: [],
    );
  }

  /// `Add transaction`
  String get addTransactionTitle {
    return Intl.message(
      'Add transaction',
      name: 'addTransactionTitle',
      desc: '',
      args: [],
    );
  }

  /// `Sum`
  String get addTransactionSumHint {
    return Intl.message(
      'Sum',
      name: 'addTransactionSumHint',
      desc: '',
      args: [],
    );
  }

  /// `Category:`
  String get addTransactionCategoryHint {
    return Intl.message(
      'Category:',
      name: 'addTransactionCategoryHint',
      desc: '',
      args: [],
    );
  }

  /// `Wallet:`
  String get addTransactionWalletHint {
    return Intl.message(
      'Wallet:',
      name: 'addTransactionWalletHint',
      desc: '',
      args: [],
    );
  }

  /// `Comment`
  String get addTransactionCommentHint {
    return Intl.message(
      'Comment',
      name: 'addTransactionCommentHint',
      desc: '',
      args: [],
    );
  }

  /// `Transaction info`
  String get transactionInfoTitle {
    return Intl.message(
      'Transaction info',
      name: 'transactionInfoTitle',
      desc: '',
      args: [],
    );
  }

  /// `Edit transaction`
  String get transactionInfoEditTitle {
    return Intl.message(
      'Edit transaction',
      name: 'transactionInfoEditTitle',
      desc: '',
      args: [],
    );
  }

  /// `Sum:`
  String get transactionInfoSumPrefix {
    return Intl.message(
      'Sum:',
      name: 'transactionInfoSumPrefix',
      desc: '',
      args: [],
    );
  }

  /// `Category:`
  String get transactionInfoCategoryPrefix {
    return Intl.message(
      'Category:',
      name: 'transactionInfoCategoryPrefix',
      desc: '',
      args: [],
    );
  }

  /// `Wallet:`
  String get transactionInfoWalletPrefix {
    return Intl.message(
      'Wallet:',
      name: 'transactionInfoWalletPrefix',
      desc: '',
      args: [],
    );
  }

  /// `Time:`
  String get transactionInfoTimePrefix {
    return Intl.message(
      'Time:',
      name: 'transactionInfoTimePrefix',
      desc: '',
      args: [],
    );
  }

  /// `Comment:`
  String get transactionInfoCommentPrefix {
    return Intl.message(
      'Comment:',
      name: 'transactionInfoCommentPrefix',
      desc: '',
      args: [],
    );
  }

  /// `Manage wallets`
  String get manageWalletsButtonText {
    return Intl.message(
      'Manage wallets',
      name: 'manageWalletsButtonText',
      desc: '',
      args: [],
    );
  }

  /// `Manage categories`
  String get manageCategoriesButtonText {
    return Intl.message(
      'Manage categories',
      name: 'manageCategoriesButtonText',
      desc: '',
      args: [],
    );
  }

  /// `Wallets`
  String get walletsTitle {
    return Intl.message(
      'Wallets',
      name: 'walletsTitle',
      desc: '',
      args: [],
    );
  }

  /// `Categories`
  String get categoriesTitle {
    return Intl.message(
      'Categories',
      name: 'categoriesTitle',
      desc: '',
      args: [],
    );
  }

  /// `Add category`
  String get addCategoryTitle {
    return Intl.message(
      'Add category',
      name: 'addCategoryTitle',
      desc: '',
      args: [],
    );
  }

  /// `Type`
  String get transactionTypeHint {
    return Intl.message(
      'Type',
      name: 'transactionTypeHint',
      desc: '',
      args: [],
    );
  }

  /// `Name`
  String get nameHint {
    return Intl.message(
      'Name',
      name: 'nameHint',
      desc: '',
      args: [],
    );
  }

  /// `Add wallet`
  String get addWalletTitle {
    return Intl.message(
      'Add wallet',
      name: 'addWalletTitle',
      desc: '',
      args: [],
    );
  }

  /// `Select wallet type`
  String get addWalletTypeSelector {
    return Intl.message(
      'Select wallet type',
      name: 'addWalletTypeSelector',
      desc: '',
      args: [],
    );
  }

  /// `Total balance`
  String get addWalletTotalBalanceHint {
    return Intl.message(
      'Total balance',
      name: 'addWalletTotalBalanceHint',
      desc: '',
      args: [],
    );
  }

  /// `Own balance`
  String get addWalletOwnBalanceHint {
    return Intl.message(
      'Own balance',
      name: 'addWalletOwnBalanceHint',
      desc: '',
      args: [],
    );
  }

  /// `Credit limit`
  String get addWalletCreditLimit {
    return Intl.message(
      'Credit limit',
      name: 'addWalletCreditLimit',
      desc: '',
      args: [],
    );
  }

  /// `Today`
  String get today {
    return Intl.message(
      'Today',
      name: 'today',
      desc: '',
      args: [],
    );
  }

  /// `Yesterday`
  String get yesterday {
    return Intl.message(
      'Yesterday',
      name: 'yesterday',
      desc: '',
      args: [],
    );
  }

  /// `Custom date`
  String get customDate {
    return Intl.message(
      'Custom date',
      name: 'customDate',
      desc: '',
      args: [],
    );
  }

  /// `Date: {DATE}`
  String fullDateTimeString(Object DATE) {
    return Intl.message(
      'Date: $DATE',
      name: 'fullDateTimeString',
      desc: '',
      args: [DATE],
    );
  }

  /// `Selected date: {DATE}`
  String dateString(Object DATE) {
    return Intl.message(
      'Selected date: $DATE',
      name: 'dateString',
      desc: '',
      args: [DATE],
    );
  }

  /// `Delete`
  String get delete {
    return Intl.message(
      'Delete',
      name: 'delete',
      desc: '',
      args: [],
    );
  }

  /// `Are you sure to delete?`
  String get confirmToDeleteTitle {
    return Intl.message(
      'Are you sure to delete?',
      name: 'confirmToDeleteTitle',
      desc: '',
      args: [],
    );
  }

  /// `It's can be undone!`
  String get confirmToDeleteText {
    return Intl.message(
      'It\'s can be undone!',
      name: 'confirmToDeleteText',
      desc: '',
      args: [],
    );
  }

  /// `Yes`
  String get yes {
    return Intl.message(
      'Yes',
      name: 'yes',
      desc: '',
      args: [],
    );
  }

  /// `No`
  String get no {
    return Intl.message(
      'No',
      name: 'no',
      desc: '',
      args: [],
    );
  }

  /// `Archive`
  String get archive {
    return Intl.message(
      'Archive',
      name: 'archive',
      desc: '',
      args: [],
    );
  }

  /// `Unarchive`
  String get unarchive {
    return Intl.message(
      'Unarchive',
      name: 'unarchive',
      desc: '',
      args: [],
    );
  }

  /// `Are you sure to archive?`
  String get confirmToArchiveTitle {
    return Intl.message(
      'Are you sure to archive?',
      name: 'confirmToArchiveTitle',
      desc: '',
      args: [],
    );
  }

  /// `Are you sure to unarchive?`
  String get confirmToUnarchiveTitle {
    return Intl.message(
      'Are you sure to unarchive?',
      name: 'confirmToUnarchiveTitle',
      desc: '',
      args: [],
    );
  }

  /// `You can change state later`
  String get confirmToChangeArchiveText {
    return Intl.message(
      'You can change state later',
      name: 'confirmToChangeArchiveText',
      desc: '',
      args: [],
    );
  }

  /// `Add initial balance`
  String get addInitialBalanceCategoryTitle {
    return Intl.message(
      'Add initial balance',
      name: 'addInitialBalanceCategoryTitle',
      desc: '',
      args: [],
    );
  }

  /// `Transfer`
  String get transferCategoryTitle {
    return Intl.message(
      'Transfer',
      name: 'transferCategoryTitle',
      desc: '',
      args: [],
    );
  }

  /// `You don't have transaction`
  String get noTransactions {
    return Intl.message(
      'You don\'t have transaction',
      name: 'noTransactions',
      desc: '',
      args: [],
    );
  }

  /// `You don't have budget`
  String get noBudgets {
    return Intl.message(
      'You don\'t have budget',
      name: 'noBudgets',
      desc: '',
      args: [],
    );
  }

  /// `You don't have wallets`
  String get noWallets {
    return Intl.message(
      'You don\'t have wallets',
      name: 'noWallets',
      desc: '',
      args: [],
    );
  }

  /// `You don't have categories`
  String get noCategories {
    return Intl.message(
      'You don\'t have categories',
      name: 'noCategories',
      desc: '',
      args: [],
    );
  }

  /// `Total balance: {SUM}`
  String totalBalance(Object SUM) {
    return Intl.message(
      'Total balance: $SUM',
      name: 'totalBalance',
      desc: '',
      args: [SUM],
    );
  }

  /// `Used credit limit: {USED}/{TOTAL}`
  String usedCreditLimit(Object USED, Object TOTAL) {
    return Intl.message(
      'Used credit limit: $USED/$TOTAL',
      name: 'usedCreditLimit',
      desc: '',
      args: [USED, TOTAL],
    );
  }

  /// `Wallet name:`
  String get walletNameTitle {
    return Intl.message(
      'Wallet name:',
      name: 'walletNameTitle',
      desc: '',
      args: [],
    );
  }

  /// `Total balance:`
  String get totalBalanceTitle {
    return Intl.message(
      'Total balance:',
      name: 'totalBalanceTitle',
      desc: '',
      args: [],
    );
  }

  /// `Own balance:`
  String get ownBalanceTitle {
    return Intl.message(
      'Own balance:',
      name: 'ownBalanceTitle',
      desc: '',
      args: [],
    );
  }

  /// `Used credit limit:`
  String get usedCreditLimitTitle {
    return Intl.message(
      'Used credit limit:',
      name: 'usedCreditLimitTitle',
      desc: '',
      args: [],
    );
  }

  /// `Loading...`
  String get loading {
    return Intl.message(
      'Loading...',
      name: 'loading',
      desc: '',
      args: [],
    );
  }

  /// `Sign out`
  String get sign_out {
    return Intl.message(
      'Sign out',
      name: 'sign_out',
      desc: '',
      args: [],
    );
  }

  /// `Are you sure to sign out?`
  String get sign_out_confirmation_subtitle {
    return Intl.message(
      'Are you sure to sign out?',
      name: 'sign_out_confirmation_subtitle',
      desc: '',
      args: [],
    );
  }

  /// `Selected date: {DATE1} - {DATE2}`
  String selected_dates(Object DATE1, Object DATE2) {
    return Intl.message(
      'Selected date: $DATE1 - $DATE2',
      name: 'selected_dates',
      desc: '',
      args: [DATE1, DATE2],
    );
  }

  /// `Filter`
  String get filter {
    return Intl.message(
      'Filter',
      name: 'filter',
      desc: '',
      args: [],
    );
  }

  /// `{count, plural, =0{No transactions} =1{1 transaction} other{{count} transactions}}`
  String transactions(num count) {
    return Intl.plural(
      count,
      zero: 'No transactions',
      one: '1 transaction',
      other: '$count transactions',
      name: 'transactions',
      desc: '',
      args: [count],
    );
  }

  /// `Total: `
  String get total {
    return Intl.message(
      'Total: ',
      name: 'total',
      desc: '',
      args: [],
    );
  }

  /// `Save`
  String get save_button {
    return Intl.message(
      'Save',
      name: 'save_button',
      desc: '',
      args: [],
    );
  }

  /// `Transactions:`
  String get transaction_list_subtitle {
    return Intl.message(
      'Transactions:',
      name: 'transaction_list_subtitle',
      desc: '',
      args: [],
    );
  }

  /// `Wallet info`
  String get wallet_info_title {
    return Intl.message(
      'Wallet info',
      name: 'wallet_info_title',
      desc: '',
      args: [],
    );
  }

  /// `Category info`
  String get category_info_title {
    return Intl.message(
      'Category info',
      name: 'category_info_title',
      desc: '',
      args: [],
    );
  }

  /// `Category name:`
  String get category_name_title {
    return Intl.message(
      'Category name:',
      name: 'category_name_title',
      desc: '',
      args: [],
    );
  }

  /// `Selected icon:`
  String get selected_category_icon {
    return Intl.message(
      'Selected icon:',
      name: 'selected_category_icon',
      desc: '',
      args: [],
    );
  }

  /// `Select icon`
  String get select_category_icon {
    return Intl.message(
      'Select icon',
      name: 'select_category_icon',
      desc: '',
      args: [],
    );
  }

  /// `Add budget`
  String get add_budget_title {
    return Intl.message(
      'Add budget',
      name: 'add_budget_title',
      desc: '',
      args: [],
    );
  }

  /// `Select wallet, or keep empty for all wallets`
  String get select_wallet_or_keep_empty {
    return Intl.message(
      'Select wallet, or keep empty for all wallets',
      name: 'select_wallet_or_keep_empty',
      desc: '',
      args: [],
    );
  }

  /// `Select category`
  String get select_category {
    return Intl.message(
      'Select category',
      name: 'select_category',
      desc: '',
      args: [],
    );
  }

  /// `You don't add any categories, please press plus for add`
  String get empty_add_category_to_multi_category {
    return Intl.message(
      'You don\'t add any categories, please press plus for add',
      name: 'empty_add_category_to_multi_category',
      desc: '',
      args: [],
    );
  }

  /// `Add new category`
  String get add_category_to_multi_category {
    return Intl.message(
      'Add new category',
      name: 'add_category_to_multi_category',
      desc: '',
      args: [],
    );
  }

  /// `Remove category`
  String get remove_category_from_multi_category {
    return Intl.message(
      'Remove category',
      name: 'remove_category_from_multi_category',
      desc: '',
      args: [],
    );
  }
}

class AppLocalizationDelegate extends LocalizationsDelegate<S> {
  const AppLocalizationDelegate();

  List<Locale> get supportedLocales {
    return const <Locale>[
      Locale.fromSubtags(languageCode: 'en'),
      Locale.fromSubtags(languageCode: 'uk'),
    ];
  }

  @override
  bool isSupported(Locale locale) => _isSupported(locale);
  @override
  Future<S> load(Locale locale) => S.load(locale);
  @override
  bool shouldReload(AppLocalizationDelegate old) => false;

  bool _isSupported(Locale locale) {
    for (var supportedLocale in supportedLocales) {
      if (supportedLocale.languageCode == locale.languageCode) {
        return true;
      }
    }
    return false;
  }
}
