import 'package:blurry_modal_progress_hud/blurry_modal_progress_hud.dart';
import 'package:flash_chat/components/rounded_button.dart';
import 'package:flash_chat/constants.dart';
import 'package:flash_chat/screens/chat_screen.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class LoginScreen extends StatefulWidget {
  static const screenName = 'login_screen';

  const LoginScreen({super.key});

  @override
  LoginScreenState createState() => LoginScreenState();
}

class LoginScreenState extends State<LoginScreen> {
  final _auth = FirebaseAuth.instance;

  String? email;
  String? password;
  bool showSpinner = false;

  void login() async {
    if (email == null || password == null) {
      print("Email: $email or password: $password is null");
      return;
    }
    setState(() {
      showSpinner = true;
    });
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
          email: email!, password: password!);

      if (userCredential.user != null) {
        print('login: ${userCredential.user?.email}');
        Navigator.pushNamed(context, ChatScreen.screenName);
      }
    } catch (e) {
      print(e);
    }

    setState(() {
      showSpinner = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: BlurryModalProgressHUD(
        inAsyncCall: showSpinner,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Flexible(
                child: Hero(
                  tag: 'logo',
                  child: SizedBox(
                    height: 200.0,
                    child: Image.asset('images/logo.png'),
                  ),
                ),
              ),
              const SizedBox(
                height: 48.0,
              ),
              TextField(
                keyboardType: TextInputType.emailAddress,
                textAlign: TextAlign.center,
                onChanged: (value) {
                  email = value;
                },
                decoration: kInputFieldDecoration.copyWith(
                    hintText: 'Enter your email'),
              ),
              const SizedBox(
                height: 8.0,
              ),
              TextField(
                obscureText: true,
                textAlign: TextAlign.center,
                onChanged: (value) {
                  password = value;
                },
                decoration: kInputFieldDecoration.copyWith(
                    hintText: 'Enter your password.'),
              ),
              const SizedBox(
                height: 24.0,
              ),
              RoundedButton(
                color: Colors.lightBlueAccent,
                label: 'Log In',
                onPress: login,
              ),
              // Padding(
              //   padding: EdgeInsets.symmetric(vertical: 16.0),
              //   child: Material(
              //     color: Colors.lightBlueAccent,
              //     borderRadius: BorderRadius.all(Radius.circular(30.0)),
              //     elevation: 5.0,
              //     child: MaterialButton(
              //       onPressed: () {
              //         //Implement login functionality.
              //       },
              //       minWidth: 200.0,
              //       height: 42.0,
              //       child: const Text(
              //         'Log In',
              //       ),
              //     ),
              //   ),
              // ),
            ],
          ),
        ),
      ),
    );
  }
}
