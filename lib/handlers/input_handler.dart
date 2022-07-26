import 'package:breez_sdk/sdk.dart';
import 'package:c_breez/bloc/input/input_bloc.dart';
import 'package:c_breez/bloc/input/input_state.dart';
import 'package:c_breez/routes/lnurl/lnurl_invoice_delegate.dart';
import 'package:c_breez/routes/spontaneous_payment/spontaneous_payment_page.dart';
import 'package:c_breez/widgets/flushbar.dart';
import 'package:c_breez/widgets/loader.dart';
import 'package:c_breez/widgets/payment_dialogs/payment_request_dialog.dart'
    as payment_request;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../widgets/open_link_dialog.dart';
import '../widgets/route.dart';

class InputHandler {
  final BuildContext _context;
  final GlobalKey firstPaymentItemKey;
  final ScrollController scrollController;
  final GlobalKey<ScaffoldState> scaffoldController;

  ModalRoute? _loaderRoute;
  bool _handlingRequest = false;

  InputHandler(
    this._context,
    this.firstPaymentItemKey,
    this.scrollController,
    this.scaffoldController,
  ) {
    final InputBloc inputBloc = _context.read<InputBloc>();
    inputBloc.stream.listen((inputState) {
      if (_handlingRequest || inputState.inputData == null) {
        return;
      }
      _handlingRequest = true;
      handleInput(inputState);
    }).onError((error) {
      _handlingRequest = false;
      _setLoading(false);
      showFlushbar(_context, message: error.toString());
    });
  }

  void handleInput(InputState inputState) {
    switch (inputState.protocol) {
      case InputProtocol.paymentRequest:
        handleInvoice(inputState.inputData);
        return;
      case InputProtocol.lnurl:
        handleLNURL(
            _context, inputState.inputData, () => _handlingRequest = false);
        return;
      case InputProtocol.nodeID:
        handleNodeID(inputState.inputData);
        return;
      case InputProtocol.appLink:
      case InputProtocol.webView:
        handleWebAddress(inputState.inputData);
        return;
      default:
        break;
    }
  }

  void handleInvoice(dynamic invoice) {
    showDialog(
      useRootNavigator: false,
      context: _context,
      barrierDismissible: false,
      builder: (_) => payment_request.PaymentRequestDialog(
        invoice,
        firstPaymentItemKey,
        scrollController,
        () => _handlingRequest = false,
      ),
    );
  }

  void handleNodeID(String nodeID) {
    Navigator.of(_context).push(
      FadeInRoute(
        builder: (_) => SpontaneousPaymentPage(
          nodeID,
          firstPaymentItemKey,
          onComplete: () => _handlingRequest = false,
        ),
      ),
    );
  }

  void handleWebAddress(String url) {
    showDialog(
      useRootNavigator: false,
      context: _context,
      barrierDismissible: false,
      builder: (_) =>
          OpenLinkDialog(url, onComplete: () => _handlingRequest = false),
    );
  }

  _setLoading(bool visible) {
    if (visible && _loaderRoute == null) {
      _loaderRoute = createLoaderRoute(_context);
      Navigator.of(_context).push(_loaderRoute!);
      return;
    }

    if (!visible && _loaderRoute != null) {
      Navigator.removeRoute(_context, _loaderRoute!);
      _loaderRoute = null;
    }
  }
}
