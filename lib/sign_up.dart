import 'dart:developer';

import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:udon/popup.dart';

import 'sign_validate.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({Key? key, required this.email}) : super(key: key);

  final String email;

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final _emailTextController = TextEditingController();
  final _passwordTextController = TextEditingController();
  final _confirmPasswordTextController = TextEditingController();

  final _emailFocus = FocusNode();
  final _passwordFocus = FocusNode();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    _emailTextController.text = widget.email;
    return Scaffold(
        appBar: AppBar(
          title: const Text('sign_up.title').tr(),
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
                            border: const OutlineInputBorder(),
                            labelText: 'password'.tr(),
                          ),
                          validator: (value) => SignValidate().validateConfirmPassword(
                              value ?? "", _confirmPasswordTextController.text, _passwordFocus)),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 20.0),
                      child: TextFormField(
                        obscureText: true,
                        controller: _confirmPasswordTextController,
                        decoration: InputDecoration(
                          border: const OutlineInputBorder(),
                          labelText: 'confirm_password'.tr(),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 30.0),
                      child: ElevatedButton(
                          child: const Text('sign_up.title').tr(),
                          onPressed: () async {
                            if (_formKey.currentState?.validate() != true) {
                              return;
                            }

                            try {
                              Popup(context: context).showConfirm(
                                  "confirm".tr(),
                                  "sign_up.email_verification_sent"
                                      .tr(args: [_emailTextController.text]), () async {
                                final navigator = Navigator.of(context);
                                final newUser = await FirebaseAuth.instance
                                    .createUserWithEmailAndPassword(
                                        email: _emailTextController.text,
                                        password: _passwordTextController.text);
                                newUser.user?.sendEmailVerification();
                                navigator.pop(null);
                              });
                            } on FirebaseAuthException catch (e) {
                              log("wanna FirebaseAuthException ${e.code}");
                              if (e.code == 'weak-password') {
                                log('The password provided is too weak.');
                              } else if (e.code == 'email-already-in-use') {
                                Popup(context: context)
                                    .showConfirm('error'.tr(), 'signup.email_exist'.tr(), null);
                              }
                            } catch (e) {
                              log("wanna catch $e");
                              log(e.toString());
                            }

                            log("wanna end");
                          }),
                    )
                  ],
                )),
          ),
        ));
  }
}
