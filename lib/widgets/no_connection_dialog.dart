import 'dart:async';

import 'package:c_breez/theme/theme_provider.dart' as theme;
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

Future<bool?> showNoConnectionDialog(BuildContext context) {
  return showDialog<bool>(
    useRootNavigator: false,
    context: context,
    barrierDismissible: false, // user must tap button!
    builder: (BuildContext context) {
      final themeData = Theme.of(context);
      final dialogTheme = themeData.dialogTheme;
      final texts = AppLocalizations.of(context)!;
      final navigator = Navigator.of(context);

      return AlertDialog(
        contentPadding: const EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 0.0),
        title: Text(
          texts.no_connection_dialog_title,
          style: dialogTheme.titleTextStyle,
        ),
        content: SingleChildScrollView(
          child: RichText(
            text: TextSpan(
              style: dialogTheme.contentTextStyle,
              text: texts.no_connection_dialog_tip_begin,
              children: [
                TextSpan(
                  text: texts.no_connection_dialog_tip_airplane,
                  style: dialogTheme.contentTextStyle,
                ),
                TextSpan(
                  text: texts.no_connection_dialog_tip_wifi,
                  style: dialogTheme.contentTextStyle,
                ),
                TextSpan(
                  text: texts.no_connection_dialog_tip_signal,
                  style: dialogTheme.contentTextStyle,
                ),
                TextSpan(
                  text: "• ",
                  style: dialogTheme.contentTextStyle,
                ),
                TextSpan(
                  text: texts.no_connection_dialog_log_view_action,
                  style: theme.blueLinkStyle,
                  recognizer: TapGestureRecognizer()
                    ..onTap = () async {
                      // ShareExtend.share(
                      //   await ServiceInjector().breezBridge.getLogPath(),
                      //   "file",
                      // );
                    },
                ),
                TextSpan(
                  text: texts.no_connection_dialog_log_view_message,
                  style: dialogTheme.contentTextStyle,
                ),
              ],
            ),
          ),
        ),
        actions: [
          TextButton(
            child: Text(
              texts.no_connection_dialog_action_cancel,
              style: themeData.primaryTextTheme.button,
            ),
            onPressed: () => navigator.pop(false),
          ),
          TextButton(
            child: Text(
              texts.no_connection_dialog_action_try_again,
              style: themeData.primaryTextTheme.button,
            ),
            onPressed: () => navigator.pop(true),
          ),
        ],
      );
    },
  );
}
