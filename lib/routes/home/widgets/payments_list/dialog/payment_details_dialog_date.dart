import 'package:auto_size_text/auto_size_text.dart';
import 'package:breez_sdk/bridge_generated.dart';
import 'package:breez_translations/breez_translations_locales.dart';
import 'package:c_breez/utils/date.dart';
import 'package:flutter/material.dart';

class PaymentDetailsDialogDate extends StatelessWidget {
  final Payment paymentInfo;
  final AutoSizeGroup? labelAutoSizeGroup;
  final AutoSizeGroup? valueAutoSizeGroup;

  const PaymentDetailsDialogDate({
    super.key,
    required this.paymentInfo,
    this.labelAutoSizeGroup,
    this.valueAutoSizeGroup,
  });

  @override
  Widget build(BuildContext context) {
    final texts = context.texts();
    final themeData = Theme.of(context);

    return Container(
      height: 36.0,
      padding: const EdgeInsets.only(left: 16.0, right: 16.0, top: 8.0),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        children: [
          Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: AutoSizeText(
              texts.payment_details_dialog_date_and_time,
              style: themeData.primaryTextTheme.headlineMedium,
              textAlign: TextAlign.left,
              maxLines: 1,
              group: labelAutoSizeGroup,
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              reverse: true,
              padding: const EdgeInsets.only(left: 8.0),
              child: AutoSizeText(
                BreezDateUtils.formatYearMonthDayHourMinute(
                  DateTime.fromMillisecondsSinceEpoch(
                    paymentInfo.paymentTime * 1000,
                  ),
                ),
                style: themeData.primaryTextTheme.displaySmall,
                textAlign: TextAlign.right,
                maxLines: 1,
                group: valueAutoSizeGroup,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
