import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:udon/popup.dart';

class EmailVerificationPopup {
  final BuildContext context;

  EmailVerificationPopup(this.context);

  show(String email, Function clickYes) {
    Popup(context: context)
        .showYesNo("error".trim(), "sign_up.email_verification_check".tr(args: [email]), () async {
      clickYes();
    }, null);
  }
}
