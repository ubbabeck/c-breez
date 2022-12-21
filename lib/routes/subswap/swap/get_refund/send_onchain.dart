import 'dart:async';

import 'package:c_breez/l10n/build_context_localizations.dart';
import 'package:c_breez/routes/subswap/swap/get_refund/widgets/send_onchain_form.dart';
import 'package:c_breez/widgets/flushbar.dart';
import 'package:c_breez/widgets/single_button_bottom_bar.dart';
import 'package:flutter/material.dart';

// TODO: Refactor for readability
class SendOnchain extends StatefulWidget {
  final int _amount;
  final Future<String?> Function(String address, int fee) _onBroadcast;
  final String? originalTransaction;

  const SendOnchain(
    this._amount,
    this._onBroadcast, {
    this.originalTransaction,
  });

  @override
  State<StatefulWidget> createState() {
    return SendOnchainState();
  }
}

class SendOnchainState extends State<SendOnchain> {
  final _formKey = GlobalKey<FormState>();
  final _addressController = TextEditingController();
  final _feeController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final texts = context.texts();
    final query = MediaQuery.of(context);

    return Scaffold(
      appBar: AppBar(title: Text(texts.get_refund_transaction)),
      body: SingleChildScrollView(
        child: SizedBox(
          height: query.size.height - kToolbarHeight - query.padding.top,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SendOnchainForm(
                amount: widget._amount,
                formKey: _formKey,
                addressController: _addressController,
                feeController: _feeController,
                originalTransaction: widget.originalTransaction,
              ),
              SingleButtonBottomBar(
                text: texts.send_on_chain_broadcast,
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    _formKey.currentState!.save();
                    widget
                        ._onBroadcast(_addressController.text, _getFee())
                        .then((msg) {
                      Navigator.of(context).pop();
                      if (msg != null) {
                        showFlushbar(context, message: msg);
                      }
                    });
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  int _getFee() {
    return _feeController.text.isNotEmpty ? int.parse(_feeController.text) : 0;
  }
}
