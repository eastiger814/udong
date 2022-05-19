import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:udon/popup.dart';

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
                      child: const Text('sign_in_content', textScaleFactor: 1.3).tr(),
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
                              print("wanna sign in start ${widget.email}");
                              await FirebaseAuth.instance.signInWithEmailAndPassword(
                                  email: widget.email, password: _passwordTextController.text);

                              print("wanna sign in pop");
                              Navigator.pop(context, null);
                              MaterialPageRoute(builder: (context) => const MapPage());
                            } on FirebaseAuthException catch (e) {
                              print("wanna ${e.code}");
                              if (e.code == 'user-not-found') {
                                print('No user found for that email.');
                              } else if (e.code == 'wrong-password') {
                                print('Wrong password provided for that user.');
                              }
                              Popup.show(
                                  context, "warning".tr(), "sign_up.password_incorrect".tr());
                            } catch (e) {
                              print("wanna catch $e");
                              print(e);
                              Popup.show(
                                  context, "warning".tr(), "sign_up.password_incorrect".tr());
                            }
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
