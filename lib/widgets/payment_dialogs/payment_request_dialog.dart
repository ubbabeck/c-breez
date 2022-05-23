import 'dart:async';

import 'package:c_breez/bloc/account/account_bloc.dart';
import 'package:c_breez/models/account.dart';
import 'package:fixnum/fixnum.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'payment_confirmation_dialog.dart';
import 'payment_request_info_dialog.dart';
import 'processing_payment_dialog.dart';

enum PaymentRequestState {
  PAYMENT_REQUEST,
  WAITING_FOR_CONFIRMATION,
  PROCESSING_PAYMENT,
  USER_CANCELLED,
  PAYMENT_COMPLETED
}

class PaymentRequestDialog extends StatefulWidget {
  final Invoice invoice;
  final GlobalKey firstPaymentItemKey;
  final ScrollController scrollController;
  final Function() onComplete;

  const PaymentRequestDialog(
    this.invoice,
    this.firstPaymentItemKey,
    this.scrollController,
    this.onComplete, {
    Key? key,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return PaymentRequestDialogState();
  }
}

class PaymentRequestDialogState extends State<PaymentRequestDialog> {
  PaymentRequestState? _state;
  String? _amountToPayStr;
  Int64? _amountToPay;
  ModalRoute? _currentRoute;

  @override
  void initState() {
    super.initState();
    _state = PaymentRequestState.PAYMENT_REQUEST;
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _currentRoute ??= ModalRoute.of(context);
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () => _onWillPop(context),
      child: showPaymentRequestDialog(context),
    );
  }

  Future<bool> _onWillPop(BuildContext context) async {
    if (_state == PaymentRequestState.PROCESSING_PAYMENT) return false;
    context.read<AccountBloc>().cancelPayment(widget.invoice.bolt11);
    return true;
  }

  Widget showPaymentRequestDialog(BuildContext context) {
    const double minHeight = 220;
    if (_state == PaymentRequestState.PROCESSING_PAYMENT) {
      return ProcessingPaymentDialog(
        () => context
            .read<AccountBloc>()
            .sendPayment(widget.invoice.bolt11, _amountToPay!),
        widget.firstPaymentItemKey,
        (state) => _onStateChange(context, state),
        minHeight,
      );
    } else if (_state == PaymentRequestState.WAITING_FOR_CONFIRMATION) {
      return PaymentConfirmationDialog(
        widget.invoice.bolt11,
        _amountToPay!,
        _amountToPayStr!,
        () => _onStateChange(context, PaymentRequestState.USER_CANCELLED),
        (bolt11, amount) => setState(() {
          _amountToPay = amount;
          _onStateChange(context, PaymentRequestState.PROCESSING_PAYMENT);
        }),
        minHeight,
      );
    } else {
      return PaymentRequestInfoDialog(
        widget.invoice,
        () => _onStateChange(context, PaymentRequestState.USER_CANCELLED),
        () => _onStateChange(context, PaymentRequestState.WAITING_FOR_CONFIRMATION),
        (bolt11, amount) {
          _amountToPay = amount;
          _onStateChange(context, PaymentRequestState.PROCESSING_PAYMENT);
        },
        (map) => _setAmountToPay(map),
        minHeight,
      );
    }
  }

  void _onStateChange(BuildContext context, PaymentRequestState state) {
    if (state == PaymentRequestState.PAYMENT_COMPLETED) {
      Navigator.of(context).removeRoute(_currentRoute!);
      widget.onComplete();
      return;
    }
    if (state == PaymentRequestState.USER_CANCELLED) {
      Navigator.of(context).removeRoute(_currentRoute!);
      context.read<AccountBloc>().cancelPayment(widget.invoice.bolt11);
      widget.onComplete();
      return;
    }
    setState(() {
      _state = state;
    });
  }

  void _setAmountToPay(Map<String, dynamic> map) {
    _amountToPay = map["_amountToPay"];
    _amountToPayStr = map["_amountToPayStr"];
  }
}