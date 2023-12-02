import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_ui_auth/firebase_ui_auth.dart' as ui;
import 'package:flutter/widgets.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:get/get.dart';

import 'common/getx_extensions.dart';
import 'home_screen/ui/home_screen.dart';

class AuthGate extends StatelessWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return ui.SignInScreen(
            providers: [
              ui.EmailAuthProvider(),
              // GoogleProvider(clientId: '')
            ],
            footerBuilder: (context, action) {
              return PlatformTextButton(
                onPressed: () {
                  FirebaseAuth.instance.signInAnonymously();
                },
                child: Text(Get.localisation.signInWithoutRegistration),
              );
            },
          );
        }

        //TODO Add own implementation of Profile screen
        // return ui.ProfileScreen();
        return const HomeScreen();
      },
    );
  }
}