import 'package:auto_size_text/auto_size_text.dart';
import 'package:breez_sdk/bridge_generated.dart';
import 'package:c_breez/routes/home/widgets/payments_list/dialog/payment_details_dialog_amount.dart';
import 'package:c_breez/routes/home/widgets/payments_list/dialog/payment_details_dialog_date.dart';
import 'package:c_breez/routes/home/widgets/payments_list/dialog/payment_details_dialog_description.dart';
import 'package:c_breez/routes/home/widgets/payments_list/dialog/payment_details_dialog_destination_pubkey.dart';
import 'package:c_breez/routes/home/widgets/payments_list/dialog/payment_details_dialog_expiration.dart';
import 'package:c_breez/routes/home/widgets/payments_list/dialog/payment_details_dialog_preimage.dart';
import 'package:c_breez/routes/home/widgets/payments_list/dialog/payment_details_dialog_title.dart';
import 'package:fimber/fimber.dart';
import 'package:flutter/material.dart';

final AutoSizeGroup _labelGroup = AutoSizeGroup();
final AutoSizeGroup _valueGroup = AutoSizeGroup();

final _log = FimberLog("PaymentDetailsDialog");

class PaymentDetailsDialog extends StatelessWidget {
  final Payment paymentInfo;

  PaymentDetailsDialog({
    super.key,
    required this.paymentInfo,
  }) {
    _log.v("PaymentDetailsDialog for payment: ${paymentInfo.id}");
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      titlePadding: EdgeInsets.zero,
      title: PaymentDetailsDialogTitle(
        paymentInfo: paymentInfo,
      ),
      contentPadding: const EdgeInsets.fromLTRB(8.0, 16.0, 8.0, 16.0),
      content: SingleChildScrollView(
        child: SizedBox(
          width: MediaQuery.of(context).size.width,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              PaymentDetailsDialogDescription(
                paymentInfo: paymentInfo,
              ),
              PaymentDetailsAmount(
                paymentInfo: paymentInfo,
                labelAutoSizeGroup: _labelGroup,
                valueAutoSizeGroup: _valueGroup,
              ),
              PaymentDetailsDialogDate(
                paymentInfo: paymentInfo,
                labelAutoSizeGroup: _labelGroup,
                valueAutoSizeGroup: _valueGroup,
              ),
              PaymentDetailsDialogExpiration(
                paymentInfo: paymentInfo,
                labelAutoSizeGroup: _labelGroup,
              ),
              PaymentDetailsPreimage(
                paymentInfo: paymentInfo,
              ),
              PaymentDetailsDestinationPubkey(
                paymentInfo: paymentInfo,
              ),
            ],
          ),
        ),
      ),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          bottom: Radius.circular(12.0),
          top: Radius.circular(13.0),
        ),
      ),
    );
  }
}
