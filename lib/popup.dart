import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

class Popup {
  Popup({required this.context});

  final BuildContext context;

  void showConfirm(String title, String content, Function? clickConfirm) {
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
                      clickConfirm?.call();
                      Navigator.pop(context);
                    },
                    child: const Text("confirm").tr()),
              ),
            ],
          );
        });
  }

  void showYesNo(String title, String content, Function clickYes, Function? clickNo) {
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
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton(
                        onPressed: () {
                          clickYes();
                          Navigator.pop(context);
                        },
                        child: const Text("yes").tr()),
                    Padding(
                      padding: const EdgeInsets.only(left: 20.0),
                      child: ElevatedButton(
                          onPressed: () {
                            clickNo?.call();
                            Navigator.pop(context);
                          },
                          child: const Text("no").tr()),
                    ),
                  ],
                ),
              ),
            ],
          );
        });
  }
}
