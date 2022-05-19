import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:udon/sign_validate.dart';
import 'package:udon/signup.dart';

import 'map.dart';

class SignInPage extends StatefulWidget {
  const SignInPage({Key? key}) : super(key: key);

  @override
  State<SignInPage> createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  final _emailTextController = TextEditingController();
  final _passwordTextController = TextEditingController();

  final _emailFocus = FocusNode();
  final _passwordFocus = FocusNode();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('login').tr(),
        ),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.only(left: 30.0, top: 10.0, right: 30.0, bottom: 10.0),
            child: Form(
                key: _formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 10.0, bottom: 40.0),
                      child: const Text('sign_up.content', textScaleFactor: 1.3).tr(),
                    ),
                    TextFormField(
                        controller: _emailTextController,
                        keyboardType: TextInputType.emailAddress,
                        focusNode: _emailFocus,
                        decoration: InputDecoration(
                            border: const OutlineInputBorder(), labelText: 'e_mail'.tr()),
                        validator: (value) =>
                            SignValidate().validateEmail(value ?? "", _emailFocus)),
                    Padding(
                      padding: const EdgeInsets.only(top: 30.0),
                      child: TextFormField(
                        obscureText: true,
                        controller: _passwordTextController,
                        focusNode: _passwordFocus,
                        decoration: InputDecoration(
                            border: const OutlineInputBorder(), labelText: 'password'.tr()),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 30.0),
                      child: ElevatedButton(
                        child: Text('login'.tr()),
                        onPressed: () async {
                          if (_formKey.currentState?.validate() != true) {
                            return;
                          }

                          try {
                            await FirebaseAuth.instance.createUserWithEmailAndPassword(
                                email: _emailTextController.text,
                                password: _passwordTextController.text);

                            Navigator.pop(context, null);
                            MaterialPageRoute(builder: (context) => const MapPage());
                          } on FirebaseAuthException catch (e) {
                            if (e.code == 'user-not-found') {
                              print('No user found for that email.');
                            } else if (e.code == 'wrong-password') {
                              print('Wrong password provided for that user.');
                            }
                          } catch (e) {
                            print("wanna catch $e");
                            print(e);
                          }

                          print("sign in pop");
                        },
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 10.0),
                      child: ElevatedButton(
                          child: const Text('sign_up.title').tr(),
                          onPressed: () async {
                            MaterialPageRoute(builder: (context) => const SignUpPage());
                          }),
                    )
                  ],
                )),
          ),
        ));
  }

  void _incrementCounter() {
    setState(() {
      // _counter++;
    });
  }
}
