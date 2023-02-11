import 'package:breez_sdk/bridge_generated.dart';
import 'package:breez_translations/breez_translations_locales.dart';
import 'package:c_breez/services/injector.dart';
import 'package:c_breez/widgets/flushbar.dart';
import 'package:c_breez/widgets/link_launcher.dart';
import 'package:flutter/material.dart';

class SwapInprogress extends StatelessWidget {
  final SwapInfo swap;

  const SwapInprogress({
    required this.swap,
  });

  @override
  Widget build(BuildContext context) {
    final texts = context.texts();
    final swapTxs = swap.unconfirmedTxIds.followedBy(swap.confirmedTxIds).toList();

    return Column(
      mainAxisSize: MainAxisSize.max,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _ContentWrapper(
          content: Text(texts.add_funds_error_deposit, textAlign: TextAlign.center),
          top: 50.0,
        ),
        if (swapTxs.isNotEmpty) ...[
          _ContentWrapper(
            content: _TxLink(txid: swapTxs[0]),
          ),
        ],
        if (swap.lastRedeemError != null) ...[
          _ContentWrapper(
            content: Text(swap.lastRedeemError!, textAlign: TextAlign.center),
          ),
        ],
      ],
    );
  }
}

class _TxLink extends StatelessWidget {
  final String txid;

  const _TxLink({required this.txid});

  @override
  Widget build(BuildContext context) {
    final text = context.texts();

    return LinkLauncher(
      linkName: txid,
      linkAddress: "https://blockstream.info/tx/$txid",
      onCopy: () {
        ServiceInjector().device.setClipboardText(txid);
        showFlushbar(
          context,
          message: text.add_funds_transaction_id_copied,
          duration: const Duration(seconds: 3),
        );
      },
    );
  }
}

class _ContentWrapper extends StatelessWidget {
  final Widget content;
  final double top;

  const _ContentWrapper({required this.content, this.top = 30.0});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        top: top,
        left: 30.0,
        right: 30.0,
      ),
      child: content,
    );
  }
}
