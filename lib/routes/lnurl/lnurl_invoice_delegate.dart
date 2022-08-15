import 'package:c_breez/widgets/route.dart';
import 'package:dart_lnurl/dart_lnurl.dart';
import 'package:flutter/material.dart';

import 'payment/lnurl_payment_dialog.dart';
import 'payment/lnurl_payment_page.dart';
import 'withdraw/lnurl_withdraw_dialog.dart';

void handleLNURL(
  BuildContext context,
  LNURLParseResult lnurlParseResult,
  Function() onComplete,
  Function(String error) onError,
) {
  if (lnurlParseResult.payParams != null) {
    handlePayRequest(context, lnurlParseResult.payParams!, onComplete, onError);
  }
  if (lnurlParseResult.withdrawalParams != null) {
    handleWithdrawRequest(
        context, lnurlParseResult.withdrawalParams!, onComplete, onError);
  }
}

void handlePayRequest(
  BuildContext context,
  LNURLPayParams payParams,
  Function() onComplete,
  Function(String error) onError,
) {
  bool fixedAmount = payParams.minSendable == payParams.maxSendable;
  if (fixedAmount && !(payParams.commentAllowed > 0)) {
    // Show dialog if payment is of fixed amount with no payer comment allowed
    showDialog(
      useRootNavigator: false,
      context: context,
      barrierDismissible: false,
      builder: (_) => LNURLPaymentDialog(
        payParams,
        onComplete: onComplete,
        onError: onError,
      ),
    );
  } else {
    Navigator.of(context).push(
      FadeInRoute(
        builder: (_) => LNURLPaymentPage(
          payParams,
          onComplete: onComplete,
          onError: onError,
        ),
      ),
    );
  }
}

void handleWithdrawRequest(
  BuildContext context,
  LNURLWithdrawParams withdrawParams,
  Function() onComplete,
  Function(String error) onError,
) {
  showDialog(
    useRootNavigator: false,
    context: context,
    barrierDismissible: false,
    builder: (_) => LNURLWithdrawDialog(
      withdrawParams,
      onComplete: onComplete,
      onError: onError,
    ),
  );
}