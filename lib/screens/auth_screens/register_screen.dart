import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import '../../providers/auth_provider.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();

  final _passwordController = TextEditingController();

  final _passwordConforemationController = TextEditingController();

  final _deviceNameController = TextEditingController();
  bool activeBtn = false;

  @override
  Widget build(BuildContext context) {
    final authProviderFunctions = Provider.of<AuthProvider>(context);
    return Scaffold(
      body: Center(
        child: Form(
          key: _formKey,
          onChanged: (() {
            setState(() {
              activeBtn = _formKey.currentState!.validate();
            });
          }),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: SafeArea(
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    TextFormField(
                      decoration: const InputDecoration(
                          hintText: 'Name', border: OutlineInputBorder()),
                      validator: ((value) {
                        if (value!.isEmpty) {
                          return "Enter Name";
                        }
                        return null;
                      }),
                      controller: _nameController,
                    ),
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
                        if (value.length != 10) {
                          return "Phone Number should be 10 digits";
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
                          hintText: 'Password Confirmation',
                          border: OutlineInputBorder()),
                      validator: ((value) {
                        if (value!.isEmpty) {
                          return "Enter Password Confirmation";
                        }
                        if (value.length < 8) {
                          return 'password should be 8 characters';
                        }
                        if (value != _passwordController.text) {
                          return 'passwords not matched';
                        }
                        return null;
                      }),
                      controller: _passwordConforemationController,
                    ),
                    const SizedBox(
                      height: 25,
                    ),
                    TextFormField(
                      decoration: const InputDecoration(
                          hintText: 'Device Name',
                          border: OutlineInputBorder()),
                      controller: _deviceNameController,
                      validator: ((value) {
                        if (value!.isEmpty) {
                          return "Enter Device Name";
                        }
                        return null;
                      }),
                    ),
                    const SizedBox(
                      height: 25,
                    ),
                    Text("REGISTER SCREEN"),
                    const SizedBox(
                      height: 25,
                    ),
                    ElevatedButton(
                        style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.all(activeBtn
                                ? Colors.deepPurple
                                : Colors.deepPurple.withOpacity(0.2))),
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            authProviderFunctions.register({
                              "name": _nameController.text.toString(),
                              "phone": _phoneController.text.toString(),
                              "password": _passwordController.text.toString(),
                              "password_confirmation":
                                  _passwordConforemationController.text
                                      .toString(),
                              "device_name":
                                  _deviceNameController.text.toString()
                            });
                          }
                        },
                        child: const Text('Create Account')),
                    const SizedBox(
                      height: 25,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
