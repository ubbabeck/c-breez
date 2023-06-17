import 'package:breez_sdk/breez_bridge.dart';
import 'package:breez_sdk/bridge_generated.dart';
import 'package:breez_translations/breez_translations_locales.dart';
import 'package:c_breez/bloc/buy_bitcoin/moonpay/moonpay_state.dart';
import 'package:c_breez/utils/exceptions.dart';
import 'package:c_breez/utils/preferences.dart';
import 'package:fimber/fimber.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

final _log = FimberLog("MoonPayBloc");

class MoonPayBloc extends Cubit<MoonPayState> {
  final BreezBridge _breezLib;
  final Preferences _preferences;

  MoonPayBloc(
    this._breezLib,
    this._preferences,
  ) : super(MoonPayState.initial());

  Future<void> fetchMoonpayUrl() async {
    _log.v("fetchMoonpayUrl");
    emit(MoonPayState.loading());

    final swapInfo = await _breezLib.inProgressSwap();
    if (swapInfo != null) {
      _log.v("fetchMoonpayUrl swapInfo: $swapInfo");
      emit(MoonPayState.swapInProgress(
        swapInfo.bitcoinAddress,
        swapInfo.status == SwapStatus.Expired,
      ));
      return;
    }

    try {
      final url = await _breezLib.buyBitcoin(BuyBitcoinProvider.Moonpay);
      _log.v("fetchMoonpayUrl url: $url");
      emit(MoonPayState.urlReady(url));
    } catch (e) {
      _log.e("fetchMoonpayUrl error: $e");
      emit(MoonPayState.error(extractExceptionMessage(
        e,
        getSystemAppLocalizations(),
      )));
    }
  }

  void updateWebViewStatus(WebViewStatus status) {
    _log.v("updateWebViewStatus status: $status");
    final state = this.state;
    if (state is MoonPayStateUrlReady) {
      emit(state.copyWith(webViewStatus: status));
    } else {
      _log.e("updateWebViewStatus state is not MoonPayStateUrlReady");
    }
  }

  Future<String> makeExplorerUrl(String address) async {
    _log.v("openExplorer address: $address");
    final mempoolUrl = await _preferences.getMempoolSpaceUrl() ??
        (await _breezLib.defaultConfig(EnvironmentType.Production)).mempoolspaceUrl;
    final url = "$mempoolUrl/address/$address";
    _log.v("openExplorer url: $url");
    return url;
  }

  void dispose() {
    _log.v("dispose");
    emit(MoonPayState.initial());
  }
}