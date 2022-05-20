import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:udon/popup.dart';

class SignValidate {
  String? validateEmail(String value, FocusNode focusNode) {
    if (value.isEmpty) {
      focusNode.requestFocus();
      return "sign_up.email_empty".tr();
    }

    RegExp regExp = RegExp(
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$');
    if (!regExp.hasMatch(value)) {
      focusNode.requestFocus();
      return "sign_up.email_incorrect".tr();
    }

    return null;
  }

  String? validatePassword(String password, FocusNode focusNode) {
    if (password.isEmpty) {
      focusNode.requestFocus();
      return "sign_up.password_incorrect".tr();
    }

    RegExp regExp = RegExp(
        r'^(?=.*[A-Za-z])(?=.*\d)(?=.*[$@$!%*#?~^<>,.&+=])[A-Za-z\d$@$!%*#?~^<>,.&+=]{8,15}$');
    if (!regExp.hasMatch(password)) {
      focusNode.requestFocus();
      return "sign_up.password_incorrect".tr();
    }

    return null;
  }

  String? validateConfirmPassword(String password, String confirmPassword, FocusNode focusNode) {
    String? validateResult = validatePassword(password, focusNode);
    if (validateResult != null) {
      return validateResult;
    }

    if (password != confirmPassword) {
      focusNode.requestFocus();
      return "sign_up.password_is_not_same".tr();
    }

    return null;
  }
}
