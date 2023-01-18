import 'dart:io';

import 'package:breez_translations/breez_translations_locales.dart';
import 'package:c_breez/widgets/error_dialog.dart';
import 'package:flutter/widgets.dart';

WillPopCallback willPopCallback(
  BuildContext context, {
  bool immediateExit = false,
  String? title,
  String? message,
  required Function canCancel,
}) {
  final texts = context.texts();
  return () async {
    if (canCancel()) return true;
    return promptAreYouSure(
      context,
      title ?? texts.close_popup_title,
      Text(message ?? texts.close_popup_message),
    ).then((ok) {
      if (ok == true && immediateExit) {
        exit(0);
      }
      return ok == true;
    });
  };
}
