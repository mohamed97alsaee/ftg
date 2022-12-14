import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:free_to_play_challange/providers/auth_provider.dart';
import 'package:free_to_play_challange/screens/auth_screens/register_screen.dart';
import 'package:provider/provider.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  @override
  Widget build(BuildContext context) {
    final authProviderFunctions = Provider.of<AuthProvider>(context);
    return Scaffold(
      floatingActionButton: FloatingActionButton(onPressed: () async {
        Navigator.push(context,
            CupertinoPageRoute(builder: (context) => RegisterScreen()));
        // bool x = await authProviderFunctions.login();
        // if (x) {
        //   Navigator.pushAndRemoveUntil(
        //       context,
        //       CupertinoPageRoute(builder: (context) => ScreenRouter()),
        //       (route) => false);
        // } else {
        //   print("ERROR IN LOGIN");
        // }
      }),
      body: Center(
        child: Column(
          children: [
            Text("LOGIN SCREEN"),
          ],
        ),
      ),
    );
  }
}
