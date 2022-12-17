import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:free_to_play_challange/providers/auth_provider.dart';
import 'package:free_to_play_challange/screens/auth_screens/register_screen.dart';
import 'package:provider/provider.dart';

import '../../main.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final _phoneController = TextEditingController();
  final _passwordController = TextEditingController();

  final _deviceNameController = TextEditingController();
  bool activeBtn = false;

  @override
  Widget build(BuildContext context) {
    final authProviderFunctions = Provider.of<AuthProvider>(context);
    final authProviderListener =
        Provider.of<AuthProvider>(context, listen: true);

    return Scaffold(
      body: Center(
        child: Form(
          key: _formKey,
          onChanged: (() {
            if (_formKey.currentState!.validate()) {
              setState(() {
                activeBtn = true;
              });
            } else {
              setState(() {
                activeBtn = false;
              });
            }
          }),
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  const SizedBox(
                    height: 25,
                  ),
                  TextFormField(
                    decoration: const InputDecoration(
                        hintText: 'Phone', border: OutlineInputBorder()),
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
                      FilteringTextInputFormatter.digitsOnly
                    ],
                    controller: _phoneController,
                    keyboardType: TextInputType.number,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return "enter phone number";
                      }
                      if (value.length != 9) {
                        return "Phone Number should be 9 digits";
                      }
                      return null;
                    },
                  ),
                  const SizedBox(
                    height: 25,
                  ),
                  TextFormField(
                    decoration: const InputDecoration(
                        hintText: 'Password', border: OutlineInputBorder()),
                    controller: _passwordController,
                    validator: ((value) {
                      if (value!.isEmpty) {
                        return "Enter Password";
                      }
                      if (value.length < 8) {
                        return 'password should be 8 characters';
                      }
                      return null;
                    }),
                  ),
                  const SizedBox(
                    height: 25,
                  ),
                  TextFormField(
                    decoration: const InputDecoration(
                        hintText: 'Device Name', border: OutlineInputBorder()),
                    controller: _deviceNameController,
                    validator: ((value) {
                      if (value!.isEmpty) {
                        return "Enter Device Name";
                      }
                      return null;
                    }),
                  ),
                  ElevatedButton(
                      style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all(activeBtn
                              ? Colors.deepPurple
                              : Colors.deepPurple.withOpacity(0.2))),
                      onPressed: () async {
                        if (_formKey.currentState!.validate()) {
                          List x = await authProviderFunctions.login({
                            // Map<String, String> jsonBody
                            "phone": _phoneController.text.toString(),
                            "password": _passwordController.text.toString(),
                            "device_name": _deviceNameController.text.toString()
                          });
                          if (x.first == true) {
                            var snackBar = SnackBar(content: Text(x.last));
                            // ignore: use_build_context_synchronously
                            ScaffoldMessenger.of(context)
                                .showSnackBar(snackBar);
                            // ignore: use_build_context_synchronously
                            Navigator.pushAndRemoveUntil(
                                context,
                                CupertinoPageRoute(
                                    builder: (context) => const ScreenRouter()),
                                (route) => false);
                          } else {
                            var snackBar = SnackBar(content: Text(x.last));
                            // ignore: use_build_context_synchronously
                            ScaffoldMessenger.of(context)
                                .showSnackBar(snackBar);
                          }
                        }
                      },
                      child: authProviderListener.isLoading
                          ? const CircularProgressIndicator()
                          : const Text('Login')),
                  ElevatedButton(
                      style: ButtonStyle(
                          backgroundColor:
                              MaterialStateProperty.all(Colors.deepPurple)),
                      onPressed: () {
                        Navigator.push(
                            context,
                            CupertinoPageRoute(
                                builder: ((context) => RegisterScreen())));
                      },
                      child: const Text('Create Account')),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
