import 'dart:async';

import 'package:breez_sdk/sdk.dart' as breez_sdk;
import 'package:c_breez/bloc/input/input_state.dart';
import 'package:c_breez/models/clipboard.dart';
import 'package:c_breez/models/invoice.dart';
import 'package:c_breez/services/device.dart';
import 'package:c_breez/services/lightning_links.dart';
import 'package:c_breez/utils/lnurl.dart';
import 'package:c_breez/utils/node_id.dart';
import 'package:dart_lnurl/dart_lnurl.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rxdart/rxdart.dart';

class InputBloc extends Cubit<InputState> {
  final LightningLinksService _lightningLinks;
  final Device _device;  
  final breez_sdk.LightningNode _lightningNode;

  final _decodeInvoiceController = StreamController<String>();

  InputBloc(
      this._lightningLinks, this._device, this._lightningNode)
      : super(InputState()) {
    _watchIncomingInvoices().listen((inputState) => emit(inputState!));
  }

  void addIncomingInput(String bolt11) {
    _decodeInvoiceController.add(bolt11);
  }

  Future trackPayment(String paymentHash) {
    return _lightningNode
        .getNodeAPI()
        .incomingPaymentsStream()
        .where((p) => p.paymentHash == paymentHash)
        .first;
  }

  Stream<InputState?> _watchIncomingInvoices() {
    return Rx.merge([
      _decodeInvoiceController.stream,
      _lightningLinks.linksNotifications,
      _device.distinctClipboardStream
    ]).asyncMap((s) async {
      // Emit an empty InputState with isLoading to display a loader on UI layer
      emit(InputState(isLoading: true));
      try {
        final command = await breez_sdk.InputParser().parse(s);
        switch (command.protocol) {
          case breez_sdk.InputProtocol.paymentRequest:
            return handlePaymentRequest(s, command);
          case breez_sdk.InputProtocol.lnurl:
            return InputState(
                protocol: command.protocol,
                inputData: command.decoded as LNURLParseResult);
          case breez_sdk.InputProtocol.nodeID:
          case breez_sdk.InputProtocol.appLink:
          case breez_sdk.InputProtocol.webView:
            return InputState(
                protocol: command.protocol, inputData: command.decoded);
          default:
            return InputState(isLoading: false);
        }
      } catch (e) {
        return InputState(isLoading: false);
      }
    }).where((inputState) => inputState != null);
  }

  Future<InputState?> handlePaymentRequest(
      String raw, breez_sdk.ParsedInput command) async {
    final lnInvoice = command.decoded as breez_sdk.LNInvoice;
    var nodeState = await _lightningNode.nodeStateStream().first;
    if (nodeState == null || nodeState.id == lnInvoice.payeePubkey) {
      return null;
    }
    var invoice = Invoice(
        bolt11: raw,
        paymentHash: lnInvoice.paymentHash,
        description: lnInvoice.description,
        amountMsat: lnInvoice.amount ?? 0,
        expiry: lnInvoice.expiry);

    return InputState(protocol: command.protocol, inputData: invoice);
  }

  Stream<DecodedClipboardData> get decodedClipboardStream => _device.rawClipboardStream.map((clipboardData) {
        if (clipboardData.isEmpty) {
          return DecodedClipboardData.unrecognized();
        }
        var nodeID = parseNodeId(clipboardData);
        if (nodeID != null) {
          return DecodedClipboardData(data: nodeID, type: ClipboardDataType.nodeID);
        }
        String normalized = clipboardData.toLowerCase();
        if (normalized.startsWith("lightning:")) {
          normalized = normalized.substring(10);
        }

        if (normalized.startsWith("lnurl")) {
          return DecodedClipboardData(data: clipboardData, type: ClipboardDataType.lnurl);
        }

        if (isLightningAddress(normalized)) {
          return DecodedClipboardData(data: normalized, type: ClipboardDataType.lightningAddress);
        }

        if (normalized.startsWith("ln")) {
          return DecodedClipboardData(data: normalized, type: ClipboardDataType.paymentRequest);
        }
        return DecodedClipboardData.unrecognized();
      });
}
