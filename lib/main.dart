import 'package:flutter/material.dart';
import 'package:flash_chat/screens/welcome_screen.dart';
import 'package:flash_chat/screens/login_screen.dart';
import 'package:flash_chat/screens/registration_screen.dart';
import 'package:flash_chat/screens/chat_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  runApp(const FlashChat());
}

class FlashChat extends StatelessWidget {
  const FlashChat({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData.light().copyWith(
        appBarTheme: const AppBarTheme(
          color: Colors.white,
          titleTextStyle: TextStyle(color: Colors.white, fontSize: 22),
          actionsIconTheme: IconThemeData(color: Colors.white),
          iconTheme: IconThemeData(color: Colors.white),
        ),
      ),
      initialRoute: WelcomeScreen.screenName,
      routes: {
        WelcomeScreen.screenName: (context) => const WelcomeScreen(),
        RegistrationScreen.screenName: (context) => const RegistrationScreen(),
        LoginScreen.screenName: (context) => const LoginScreen(),
        ChatScreen.screenName: (context) => const ChatScreen(),
      },
    );
  }
}
