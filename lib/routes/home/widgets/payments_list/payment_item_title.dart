import 'package:breez_sdk/bridge_generated.dart';
import 'package:breez_translations/breez_translations_locales.dart';
import 'package:c_breez/theme/theme_provider.dart' as theme;
import 'package:c_breez/widgets/preview/preview.dart';
import 'package:flutter/material.dart';

class PaymentItemTitle extends StatelessWidget {
  final Payment _paymentInfo;

  const PaymentItemTitle(
    this._paymentInfo, {
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
      _title(context).replaceAll("\n", " "),
      style: Theme.of(context).paymentItemTitleTextStyle,
      overflow: TextOverflow.ellipsis,
    );
  }

  String _title(BuildContext context) {
    final description = _paymentInfo.description?.replaceAll("\n", " ").trim();
    if (description != null && description.isNotEmpty) {
      final breezPosRegex = RegExp(r'(?<=\|)(.*)(?=\|)');
      if (breezPosRegex.hasMatch(description)) {
        final extracted = breezPosRegex.stringMatch(description)?.trim();
        if (extracted != null && extracted.isNotEmpty) {
          return extracted;
        }
      }
      return description;
    }

    final details = _paymentInfo.details.data;
    if (details is PaymentDetails_ClosedChannel) {
      final state = details.data.state;
      switch (state) {
        case ChannelState.PendingOpen:
          return context.texts().payment_info_title_pending_opened_channel;
        case ChannelState.Opened:
          return context.texts().payment_info_title_opened_channel;
        case ChannelState.PendingClose:
          return context.texts().payment_info_title_pending_closed_channel;
        case ChannelState.Closed:
          return context.texts().payment_info_title_closed_channel;
      }
    }

    return context.texts().wallet_dashboard_payment_item_no_title;
  }
}

void main() {
  runApp(Preview([
    // No title
    PaymentItemTitle(
      Payment(
        paymentType: PaymentType.Received, 
        id: "7afeee37f0bb1578e94f2e406973118c4dcec0e0755aa873af4a9a24473c02de",       
        feeMsat: 0,        
        paymentTime: 1661791810,
        amountMsat: 4321000,
        pending: false,
        description: "",
        details: PaymentDetails.ln(data: LnPaymentDetails(
                paymentHash: "7afeee37f0bb1578e94f2e406973118c4dcec0e0755aa873af4a9a24473c02de", label: "", destinationPubkey: "0264a67069b7cbd4ea3db0709d9f605e11643a66fe434d77eaf9bf960a323dda5d", paymentPreimage: "", keysend: false, bolt11: ""))
      ),
    ),

    // Long title
    PaymentItemTitle(
      Payment(
        paymentType: PaymentType.Received,
        id: "7afeee37f0bb1578e94f2e406973118c4dcec0e0755aa873af4a9a24473c02de",        
        feeMsat: 0,  
        paymentTime: 1661791810,
        amountMsat: 4321000,
        pending: false,
        description: "A long title\nwith a new line",
        details: PaymentDetails.ln(data: LnPaymentDetails(
                paymentHash: "7afeee37f0bb1578e94f2e406973118c4dcec0e0755aa873af4a9a24473c02de", label: "", destinationPubkey: "0264a67069b7cbd4ea3db0709d9f605e11643a66fe434d77eaf9bf960a323dda5d", paymentPreimage: "", keysend: false, bolt11: ""))
      ),
    ),

    // Short title
    PaymentItemTitle(
      Payment(
        paymentType: PaymentType.Received,
        id: "7afeee37f0bb1578e94f2e406973118c4dcec0e0755aa873af4a9a24473c02de",        
        feeMsat: 0,        
        paymentTime: 1661791810,
        amountMsat: 4321000,
        pending: false,
        description: "A short title",
        details: PaymentDetails.ln(data: LnPaymentDetails(
                paymentHash: "7afeee37f0bb1578e94f2e406973118c4dcec0e0755aa873af4a9a24473c02de", label: "", destinationPubkey: "0264a67069b7cbd4ea3db0709d9f605e11643a66fe434d77eaf9bf960a323dda5d", paymentPreimage: "", keysend: false, bolt11: ""))
      ),
    ),
  ]));
}
