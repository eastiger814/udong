import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:udon/sign_validate.dart';
import 'package:udon/signin_password.dart';
import 'package:udon/signup.dart';

import 'map.dart';

class SignInPage extends StatefulWidget {
  const SignInPage({Key? key}) : super(key: key);

  @override
  State<SignInPage> createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  final _emailTextController = TextEditingController();

  final _emailFocus = FocusNode();

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
                    const Icon(Icons.gesture, size: 200),
                    Padding(
                      padding: const EdgeInsets.only(top: 10.0, bottom: 20.0),
                      child: const Text('sign_in_content', textScaleFactor: 1.3).tr(),
                    ),
                    ConstrainedBox(
                      constraints: const BoxConstraints(minWidth: 400),
                      child: TextFormField(
                          controller: _emailTextController,
                          keyboardType: TextInputType.emailAddress,
                          focusNode: _emailFocus,
                          decoration: InputDecoration(
                              border: const OutlineInputBorder(), labelText: 'e_mail'.tr()),
                          validator: (value) =>
                              SignValidate().validateEmail(value ?? "", _emailFocus)),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 20.0),
                      child: ConstrainedBox(
                        constraints: const BoxConstraints(minWidth: 400),
                        child: ElevatedButton(
                          child: Text('keep_going_on_email'.tr()),
                          onPressed: () async {
                            print("wanna LOGIN START");
                            if (_formKey.currentState?.validate() != true) {
                              return;
                            }

                            try {
                              await FirebaseAuth.instance.signInWithEmailAndPassword(
                                  email: _emailTextController.text, password: "0000");

                              print("wanna create");
                              Navigator.pop(context, null);
                              MaterialPageRoute(builder: (context) => const MapPage());
                            } on FirebaseAuthException catch (e) {
                              print("wanna catch FirebaseAuthException ${e.code}");
                              if (e.code == 'user-not-found') {
                                print("wanna go to sign up ${_emailTextController.text}");
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            SignUpPage(email: _emailTextController.text)));
                              } else if (e.code == 'wrong-password') {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            SignInPasswordPage(email: _emailTextController.text)));
                              }
                            } catch (e) {
                              print("wanna catch $e");
                              print(e);
                            }

                            print("sign in pop");
                          },
                        ),
                      ),
                    ),
                    const Text('or', style: TextStyle(color: Colors.grey)).tr(),
                    Padding(
                      padding: const EdgeInsets.only(top: 10.0),
                      child: ConstrainedBox(
                        constraints: const BoxConstraints(minWidth: 400),
                        child: ElevatedButton(
                            child: const Text('keep_going_on_google').tr(),
                            onPressed: () async {
                              // MaterialPageRoute(builder: (context) => const SignUpPage());
                            }),
                      ),
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
