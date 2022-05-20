import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'map.dart';
import 'sign_in.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({Key? key}) : super(key: key);

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  Widget build(BuildContext context) {
    FirebaseAuth.instance.authStateChanges().listen((User? user) {
      Navigator.pop(context);
      if (user == null) {
        Navigator.push(context, MaterialPageRoute(builder: (context) => const SignInPage()));
      } else {
        Navigator.push(context, MaterialPageRoute(builder: (context) => const MapPage()));
      }
    });

    return Scaffold(
        backgroundColor: Colors.white,
        body: Center(
          child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.gesture, size: 200),
                Text('app_name'.tr(),
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 24.0))
              ]),
        ));
  }
}
