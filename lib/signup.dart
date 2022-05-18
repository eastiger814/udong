import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'sign_validate.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({Key? key}) : super(key: key);

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final _emailTextController = TextEditingController();
  final _passwordTextController = TextEditingController();

  final _emailFocus = FocusNode();
  final _passwordFocus = FocusNode();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
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
                          validator: (value) =>
                              SignValidate().validatePassword(value ?? "", _passwordFocus)),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 30.0),
                      child: ElevatedButton(
                          onPressed: () async {
                            if (_formKey.currentState?.validate() != true) {
                              return;
                            }

                            Navigator.pop(context, null);

                            await FirebaseAuth.instance.createUserWithEmailAndPassword(
                                email: _emailTextController.text,
                                password: _passwordTextController.text);
                          },
                          child: const Text('sign_up.title').tr()),
                    )
                  ],
                )),
          ),
        ));
  }

  void showAlertDialog(State state, BuildContext context, String title, String content) {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return AlertDialog(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
            title: Text(title),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Text(content),
              ],
            ),
            actions: <Widget>[
              Center(
                child: ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: const Text("confirm").tr()),
              ),
            ],
          );
        });
  }
}
