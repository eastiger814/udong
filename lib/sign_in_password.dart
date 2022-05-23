import 'dart:developer';

import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:udon/popup.dart';
import 'package:udon/sign_in.dart';

import 'email_verification_popup.dart';
import 'map.dart';

class SignInPasswordPage extends StatefulWidget {
  const SignInPasswordPage({Key? key, required this.email}) : super(key: key);

  final String email;

  @override
  State<SignInPasswordPage> createState() => _SignInPasswordPageState();
}

class _SignInPasswordPageState extends State<SignInPasswordPage> {
  final _passwordTextController = TextEditingController();
  final _passwordFocus = FocusNode();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('login_with_password').tr(),
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
                      child: Text('sign_in_content'.tr(), textScaleFactor: 1.3),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 20.0),
                      child: ConstrainedBox(
                        constraints: const BoxConstraints(minWidth: 400),
                        child: TextFormField(
                          obscureText: true,
                          controller: _passwordTextController,
                          focusNode: _passwordFocus,
                          decoration: InputDecoration(
                              border: const OutlineInputBorder(), labelText: 'password'.tr()),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 20.0),
                      child: ConstrainedBox(
                        constraints: const BoxConstraints(minWidth: 400),
                        child: ElevatedButton(
                          child: Text('login'.tr()),
                          onPressed: () async {
                            if (_formKey.currentState?.validate() != true) {
                              return;
                            }

                            try {
                              log("wanna sign in start ${widget.email} : ${_passwordTextController.text}");
                              final navigator = Navigator.of(context);
                              var emailVerificationPopup = EmailVerificationPopup(context);
                              final user = await FirebaseAuth.instance.signInWithEmailAndPassword(
                                  email: widget.email, password: _passwordTextController.text);

                              if (user.user == null || user.user?.email?.isNotEmpty != true) {
                                navigator.pop(null);
                                navigator.push(
                                    MaterialPageRoute(builder: (context) => const SignInPage()));
                                return;
                              }

                              if (user.user?.emailVerified != true) {
                                emailVerificationPopup.show(user.user?.email ?? "", () async {
                                  await user.user?.sendEmailVerification();
                                });
                                return;
                              }

                              log("wanna sign in with password");
                              navigator.pop(null);
                              navigator
                                  .push(MaterialPageRoute(builder: (context) => const MapPage()));
                            } on FirebaseAuthException catch (e) {
                              log("wanna ${e.code}");
                              if (e.code == 'user-not-found') {
                                log('No user found for that email.');
                              } else if (e.code == 'wrong-password') {
                                log('Wrong password provided for that user.');
                              }
                              Popup(context: context).showConfirm(
                                  "warning".tr(), "sign_up.password_incorrect".tr(), null);
                            } catch (e) {
                              log("wanna catch $e");
                              log(e.toString());
                              Popup(context: context).showConfirm(
                                  "warning".tr(), "sign_up.password_incorrect".tr(), null);
                            }
                          },
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 10.0),
                      child: const Text('or', style: TextStyle(color: Colors.grey)).tr(),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 10.0),
                      child: ConstrainedBox(
                        constraints: const BoxConstraints(minWidth: 400),
                        child: ElevatedButton(
                          child: const Text('sign_up.password_reset').tr(),
                          onPressed: () async {
                            Popup(context: context).showYesNo(
                                "warning".tr(), "sign_up.password_reset_question".tr(), () {
                              FirebaseAuth.instance.sendPasswordResetEmail(email: widget.email);

                              Fluttertoast.showToast(
                                  msg: "sign_up.password_reset_toast".tr(),
                                  toastLength: Toast.LENGTH_SHORT,
                                  gravity: ToastGravity.CENTER);
                            }, null);
                          },
                        ),
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
