import 'package:c_breez/bloc/input/input_bloc.dart';
import 'package:c_breez/bloc/input/input_state.dart';
import 'package:c_breez/models/invoice.dart';
import 'package:c_breez/routes/lnurl/lnurl_payment_delegate.dart';
import 'package:c_breez/widgets/flushbar.dart';
import 'package:c_breez/widgets/loader.dart';
import 'package:c_breez/widgets/payment_dialogs/payment_request_dialog.dart'
    as payment_request;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

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
      if (_handlingRequest ||
          inputState.invoice == null ||
          inputState.lnurlParseResult == null) {
        return;
      }
      _handlingRequest = true;
      handleInput(inputState);
    }).onError((error) {
      _setLoading(false);
      showFlushbar(_context, message: error.toString());
    });
  }

  void handleInput(InputState inputState) {
    if (inputState.invoice != null) {
      handleInvoice(inputState.invoice);
    }
    final lnurlParseResult = inputState.lnurlParseResult;
    if (lnurlParseResult?.payParams != null) {
      handleLNURLPayRequest(_context, lnurlParseResult!.payParams!,
          () => _handlingRequest = false);
    }
    if (lnurlParseResult?.withdrawalParams != null) {}
  }

  void handleInvoice(Invoice? invoice) {
    showDialog(
      useRootNavigator: false,
      context: _context,
      barrierDismissible: false,
      builder: (_) => payment_request.PaymentRequestDialog(
        invoice!,
        firstPaymentItemKey,
        scrollController,
        () => _handlingRequest = false,
      ),
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
