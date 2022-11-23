import 'dart:async';

import 'package:breez_sdk/breez_bridge.dart';
import 'package:breez_sdk/bridge_generated.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';

class LSPBloc extends Cubit<LspInformation?> {
  final BreezBridge _breezLib;

  LSPBloc(this._breezLib) : super(null) {
    // for every change in node state check if we have the current selected lsp as a peer.
    // If not instruct the sdk to connect.
    _breezLib.nodeStateStream
        .where((nodeState) => nodeState != null)
        .listen((nodeState) async {
      var activeLSP = await currentLSP;
      if (activeLSP != null) {
        if (!nodeState!.connectedPeers.contains(activeLSP.pubkey)) {
          await connectLSP(activeLSP.id);
        }
        emit(activeLSP);
        return;
      }
    });
  }

  // connect to a specific lsp
  Future connectLSP(String lspID) async => await _breezLib.setLspId(lspID);

  // fetch the connected lsp from the sdk.
  Future<LspInformation>? get currentLSP async => await _breezLib.getLsp();

  // fetch the lsp list from the sdk.
  Future<List<LspInformation>> get lspList async => await _breezLib.listLsps();
}
