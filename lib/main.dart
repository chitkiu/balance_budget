import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:get/get.dart';

import 'auth_gate.dart';
import 'categories/common/data/local_category_repository.dart';
import 'firebase_options.dart';
import 'generated/l10n.dart';
import 'transactions/list/domain/selected_transactions_date_storage.dart';
import 'wallets/common/data/local_wallet_repository.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  runApp(const MyApp());
}

const Iterable<LocalizationsDelegate<dynamic>> localizationsDelegates = [
  S.delegate,
  GlobalMaterialLocalizations.delegate,
  GlobalWidgetsLocalizations.delegate,
  GlobalCupertinoLocalizations.delegate,
];

//TODO Add theme
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider.value(value: LocalCategoryRepository()),
        RepositoryProvider.value(value: LocalWalletRepository()),
        RepositoryProvider.value(value: SelectedTransactionsDateStorage()),
      ],
      child: _getWidget(context),
    );
  }

  Widget _getWidget(BuildContext context) {
    if (isMaterial(context)) {
      return GetMaterialApp(
        onGenerateTitle: (context) => S.of(context).appTitle,
        localizationsDelegates: localizationsDelegates,
        supportedLocales: S.delegate.supportedLocales,
        theme: ThemeData(
            useMaterial3: true,
            textTheme: const TextTheme(titleMedium: TextStyle(fontSize: 17))),
        home: const AuthGate(),
      );
    } else {
      return GetCupertinoApp(
        onGenerateTitle: (context) => S.of(context).appTitle,
        localizationsDelegates: localizationsDelegates,
        supportedLocales: S.delegate.supportedLocales,
        theme: const CupertinoThemeData(
          brightness: Brightness.light,
        ),
        home: const AuthGate(),
      );
    }
  }
}
