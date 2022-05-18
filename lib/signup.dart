import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({Key? key}) : super(key: key);

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final idTextController = TextEditingController();
  final passwordTextController = TextEditingController();
  final confirmPasswordTextController = TextEditingController();

  void _incrementCounter() {
    setState(() {
      // _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: const Text('sign_up.title').tr(),
      ),
      body: Center(
        // Center is a layout widget. It takes a single child and positions it
        // in the middle of the parent.
        child: Padding(
          padding: const EdgeInsets.only(
              left: 30.0, top: 10.0, right: 30.0, bottom: 10.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(top: 10.0, bottom: 40.0),
                child: const Text('sign_up.content', textScaleFactor: 1.3).tr(),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 10.0, bottom: 20.0),
                child: TextField(
                  controller: idTextController,
                  decoration: InputDecoration(
                    border: const OutlineInputBorder(),
                    labelText: 'e_mail'.tr(),
                  ),
                ),
              ),
              TextField(
                obscureText: true,
                controller: passwordTextController,
                decoration: InputDecoration(
                  border: const OutlineInputBorder(),
                  labelText: 'password'.tr(),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 10.0),
                child: TextField(
                  obscureText: true,
                  controller: confirmPasswordTextController,
                  decoration: InputDecoration(
                    border: const OutlineInputBorder(),
                    labelText: 'confirm_password'.tr(),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 30.0),
                child: ElevatedButton(
                    onPressed: () async {
                      if (idTextController.text.isEmpty) {
                        showAlertDialog(this, context, "warning".tr(),
                            "sign_up.email_empty".tr());
                        return;
                      }

                      if (passwordTextController.text.isEmpty) {
                        showAlertDialog(this, context, "warning".tr(),
                            "sign_up.password_empty".tr());
                        return;
                      }

                      if (passwordTextController.text.length < 8) {
                        showAlertDialog(this, context, "warning".tr(),
                            "sign_up.password_short".tr());
                        return;
                      }

                      if (passwordTextController.text !=
                          confirmPasswordTextController.text) {
                        showAlertDialog(this, context, "warning".tr(),
                            "sign_up.password_is_not_same".tr());
                        return;
                      }

                      await FirebaseAuth.instance
                          .createUserWithEmailAndPassword(
                              email: idTextController.text,
                              password: passwordTextController.text);
                    },
                    child: const Text('sign_up.title').tr()),
              )
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }

  void showAlertDialog(
      State state, BuildContext context, String title, String content) {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return AlertDialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0)),
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
