import 'package:c_breez/theme/theme_provider.dart' as theme;
import 'package:c_breez/widgets/loading_animated_text.dart';
import 'package:c_breez/widgets/payment_dialogs/processing_payment/processing_payment_title.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ProcessingPaymentContent extends StatelessWidget {
  final GlobalKey? dialogKey;
  final Color color;

  const ProcessingPaymentContent({
    Key? key,
    this.dialogKey,
    this.color = Colors.transparent,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final texts = AppLocalizations.of(context)!;
    final themeData = Theme.of(context);
    final queryData = MediaQuery.of(context);

    return Column(
      key: dialogKey,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      mainAxisSize: MainAxisSize.min,
      children: [
        const ProcessingPaymentTitle(),
        Padding(
          padding: const EdgeInsets.fromLTRB(16.0, 0.0, 16.0, 0.0),
          child: SizedBox(
            width: queryData.size.width,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                LoadingAnimatedText(
                  texts.processing_payment_dialog_wait,
                  textStyle: themeData.dialogTheme.contentTextStyle,
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(bottom: 24.0),
          child: Image.asset(
            theme.customData[theme.themeId]!.loaderAssetPath,
            height: 64.0,
            colorBlendMode: theme.customData[theme.themeId]!.loaderColorBlendMode,
            color: color,
            gaplessPlayback: true,
          ),
        )
      ],
    );
  }
}
