import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:interview/welcome_screen.dart';
import 'package:firebase_core/firebase_core.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatefulWidget {

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final GlobalKey<FormState> _globalKey = GlobalKey<FormState>();

  final TextEditingController email = TextEditingController();

  final TextEditingController password = TextEditingController();

  String? validateEmail(String? email) {
    Pattern pattern =
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
    RegExp regExp = RegExp(pattern.toString());
    if (!regExp.hasMatch(email!)) {
      return 'Email format is invalid';
    } else {
      return null;
    }
  }

  String? validatePassword(String? value) {
    if (value!.isEmpty) {
      return 'Please fill this field';
    } else if (value.length < 4) {
      return 'Minimum Password length is 4';
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Form(
              key: _globalKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TextFormField(
                    controller: email,
                    decoration: const InputDecoration(
                      label: Text('Email'),
                    ),
                    validator: validateEmail,
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  TextFormField(
                    controller: password,
                    decoration: const InputDecoration(
                        label: Text('Password')
                    ),
                    validator: validatePassword,
                  ),
                ],
              ),
            ),
            ElevatedButton(
              onPressed: () {
                if (_globalKey.currentState!.validate()) {
                  try {
                    final UserCredential userCred = FirebaseAuth.instance
                        .createUserWithEmailAndPassword(
                        email: email.text,
                        password: password.text) as UserCredential;
                    final User? user = userCred.user;

                    if (user != null) {
                      Navigator.push(context, MaterialPageRoute(builder: (context) => const WelcomeScreen()));
                    }

                  } on Exception catch (e) {
                    print(e);
                    // ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                    //     content: Text('Sign Up Failed!')));
                  }
                }
              }
              ,
              child: const Text('Sign Up'),
            ),
          ],
        ),
      ),
    );
  }
}
