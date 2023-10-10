import 'dart:async';
import 'dart:io';

import 'package:bip39/bip39.dart' as bip39;
import 'package:breez_sdk/breez_sdk.dart';
import 'package:breez_sdk/bridge_generated.dart' as sdk;
import 'package:c_breez/bloc/account/account_state.dart';
import 'package:c_breez/bloc/account/credentials_manager.dart';
import 'package:c_breez/bloc/account/payment_error.dart';
import 'package:c_breez/bloc/account/payment_filters.dart';
import 'package:c_breez/bloc/account/payment_result.dart';
import 'package:c_breez/config.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:logging/logging.dart';
import 'package:flutter_fgbg/flutter_fgbg.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:path/path.dart' as p;
import 'package:rxdart/rxdart.dart';

import 'account_state_assembler.dart';

const maxPaymentAmount = 4294967;
const nodeSyncInterval = 60;

// AccountBloc is the business logic unit that is responsible to communicating with the lightning service
// and reflect the node state. It is responsible for:
// 1. Synchronizing with the node state.
// 2. Abstracting actions exposed by the lightning service.
class AccountBloc extends Cubit<AccountState> with HydratedMixin {
  final _log = Logger("AccountBloc");
  static const String paymentFilterSettingsKey = "payment_filter_settings";
  static const int defaultInvoiceExpiry = Duration.secondsPerHour;

  final StreamController<PaymentResult> _paymentResultStreamController = StreamController<PaymentResult>();

  Stream<PaymentResult> get paymentResultStream => _paymentResultStreamController.stream;

  final StreamController<PaymentFilters> _paymentFiltersStreamController = BehaviorSubject<PaymentFilters>();

  Stream<PaymentFilters> get paymentFiltersStream => _paymentFiltersStreamController.stream;

  final BreezSDK _breezLib;
  final CredentialsManager _credentialsManager;

  AccountBloc(
    this._breezLib,
    this._credentialsManager,
  ) : super(AccountState.initial()) {
    // emit on every change
    _watchAccountChanges().listen((acc) => emit(acc));

    _paymentFiltersStreamController.add(state.paymentFilters);

    if (!state.initial) connect();

    _listenPaymentResultEvents();
  }

  // TODO: _watchAccountChanges listens to every change in the local storage and assemble a new account state accordingly
  _watchAccountChanges() {
    return Rx.combineLatest3<List<sdk.Payment>, PaymentFilters, sdk.NodeState?, AccountState>(
      _breezLib.paymentsStream,
      paymentFiltersStream,
      _breezLib.nodeStateStream,
      (payments, paymentFilters, nodeState) {
        return assembleAccountState(payments, paymentFilters, nodeState, state) ?? state;
      },
    );
  }

  Future connect({
    String? mnemonic,
    bool restored = false,
  }) async {
    if (mnemonic != null) {
      await _credentialsManager.storeMnemonic(mnemonic: mnemonic);
      emit(state.copyWith(
        initial: false,
        verificationStatus: restored ? VerificationStatus.VERIFIED : null,
      ));
    }
    await _startSdkForever();
  }

  Future _startSdkForever() async {
    _log.fine("starting sdk forever");
    await _startSdkOnce();

    // in case we failed to start (lack of inet connection probably)
    if (state.connectionStatus == ConnectionStatus.DISCONNECTED) {
      StreamSubscription<ConnectivityResult>? subscription;
      subscription = Connectivity().onConnectivityChanged.listen((event) async {
        // we should try fetch the selected lsp information when internet is back.
        if (event != ConnectivityResult.none && state.connectionStatus == ConnectionStatus.DISCONNECTED) {
          await _startSdkOnce();
          if (state.connectionStatus == ConnectionStatus.CONNECTED) {
            subscription!.cancel();
            _onConnected();
          }
        }
      });
    } else {
      _onConnected();
    }
  }

  Future _startSdkOnce() async {
    _log.fine("starting sdk once");
    try {
      emit(state.copyWith(connectionStatus: ConnectionStatus.CONNECTING));
      final mnemonic = await _credentialsManager.restoreMnemonic();
      final seed = bip39.mnemonicToSeed(mnemonic);
      await _breezLib.connect(config: (await Config.instance()).sdkConfig, seed: seed);
      emit(state.copyWith(connectionStatus: ConnectionStatus.CONNECTED));
    } catch (e) {
      emit(state.copyWith(connectionStatus: ConnectionStatus.DISCONNECTED));
    }
  }

  // Once connected sync sdk periodically on foreground events.
  void _onConnected() {
    _log.fine("on connected");
    var lastSync = DateTime.fromMillisecondsSinceEpoch(0);
    FGBGEvents.stream.listen((event) async {
      if (event == FGBGType.foreground && DateTime.now().difference(lastSync).inSeconds > nodeSyncInterval) {
        await _breezLib.sync();
        lastSync = DateTime.now();
      }
    });
  }

  Future<sdk.LnUrlWithdrawResult> lnurlWithdraw({
    required int amountSats,
    required sdk.LnUrlWithdrawRequestData reqData,
    String? description,
  }) async {
    _log.fine("lnurlWithdraw amount: $amountSats, description: '$description', reqData: $reqData");
    try {
      return await _breezLib.lnurlWithdraw(
        amountSats: amountSats,
        reqData: reqData,
        description: description,
      );
    } catch (e) {
      _log.severe("lnurlWithdraw error", e);
      rethrow;
    }
  }

  Future<sdk.LnUrlPayResult> lnurlPay({
    required int amount,
    required sdk.LnUrlPayRequestData reqData,
    String? comment,
  }) async {
    _log.fine("lnurlPay amount: $amount, comment: '$comment', reqData: $reqData");
    try {
      return await _breezLib.lnurlPay(
        userAmountSat: amount,
        reqData: reqData,
        comment: comment,
      );
    } catch (e) {
      _log.severe("lnurlPay error", e);
      rethrow;
    }
  }

  Future<sdk.LnUrlCallbackStatus> lnurlAuth({
    required sdk.LnUrlAuthRequestData reqData,
  }) async {
    _log.fine("lnurlAuth amount: reqData: $reqData");
    try {
      return await _breezLib.lnurlAuth(reqData: reqData);
    } catch (e) {
      _log.severe("lnurlAuth error", e);
      rethrow;
    }
  }

  Future sendPayment(String bolt11, int? amountSats) async {
    _log.fine("sendPayment: $bolt11, $amountSats");
    try {
      await _breezLib.sendPayment(bolt11: bolt11, amountSats: amountSats);
    } catch (e) {
      _log.severe("sendPayment error", e);
      return Future.error(e);
    }
  }

  Future cancelPayment(String bolt11) async {
    _log.fine("cancelPayment: $bolt11");
    throw Exception("not implemented");
  }

  Future sendSpontaneousPayment(
    String nodeId,
    String description,
    int amountSats,
  ) async {
    _log.fine("sendSpontaneousPayment: $nodeId, $description, $amountSats");
    _log.info("description field is not being used by the SDK yet");
    try {
      await _breezLib.sendSpontaneousPayment(
        nodeId: nodeId,
        amountSats: amountSats,
      );
    } catch (e) {
      _log.severe("sendSpontaneousPayment error", e);
      return Future.error(e);
    }
  }

  Future<bool> isValidBitcoinAddress(String? address) async {
    _log.fine("isValidBitcoinAddress: $address");
    if (address == null) return false;
    return _breezLib.isValidBitcoinAddress(address);
  }

  // validatePayment is used to validate that outgoing/incoming payments meet the liquidity
  // constraints.
  void validatePayment(
    int amount,
    bool outgoing,
    bool channelCreationPossible, {
    int? channelMinimumFee,
  }) {
    _log.fine("validatePayment: $amount, $outgoing, $channelMinimumFee");
    var accState = state;
    if (amount > accState.maxPaymentAmount) {
      _log.fine("Amount $amount is bigger than maxPaymentAmount ${accState.maxPaymentAmount}");
      throw PaymentExceededLimitError(accState.maxPaymentAmount);
    }

    if (!outgoing) {
      if (!channelCreationPossible && accState.maxInboundLiquidity == 0) {
        throw NoChannelCreationZeroLiqudityError();
      } else if (!channelCreationPossible && accState.maxInboundLiquidity < amount) {
        throw PaymentExcededLiqudityChannelCreationNotPossibleError(accState.maxInboundLiquidity);
      } else if (channelMinimumFee != null &&
          (amount > accState.maxInboundLiquidity && amount <= channelMinimumFee)) {
        throw PaymentBelowSetupFeesError(channelMinimumFee);
      } else if (channelMinimumFee == null && amount > accState.maxInboundLiquidity) {
        throw PaymentExceedLiquidityError(accState.maxInboundLiquidity);
      } else if (amount > accState.maxAllowedToReceive) {
        throw PaymentExceededLimitError(accState.maxAllowedToReceive);
      }
    }

    if (outgoing && amount > accState.maxAllowedToPay) {
      _log.fine("Outgoing but amount $amount is bigger than ${accState.maxAllowedToPay}");
      if (accState.reserveAmount > 0) {
        _log.fine("Reserve amount ${accState.reserveAmount}");
        throw PaymentBelowReserveError(accState.reserveAmount);
      }
      throw const InsufficientLocalBalanceError();
    }
  }

  void changePaymentFilter({
    sdk.PaymentTypeFilter? filter,
    int? fromTimestamp,
    int? toTimestamp,
  }) async {
    _log.fine("changePaymentFilter: $filter, $fromTimestamp, $toTimestamp");
    _paymentFiltersStreamController.add(
      state.paymentFilters.copyWith(
        filter: filter,
        fromTimestamp: fromTimestamp,
        toTimestamp: toTimestamp,
      ),
    );
  }

  Future<sdk.ReceivePaymentResponse> addInvoice({
    String description = "",
    required int amountSats,
    required sdk.OpeningFeeParams? chosenFeeParams,
  }) async {
    _log.fine("addInvoice: $description, $amountSats");

    final requestData = sdk.ReceivePaymentRequest(amountSats: amountSats, description: description, openingFeeParams: chosenFeeParams);
    final responseData = await _breezLib.receivePayment(reqData: requestData);
    return responseData;
  }

  @override
  AccountState? fromJson(Map<String, dynamic> json) {
    return AccountState.fromJson(json);
  }

  @override
  Map<String, dynamic>? toJson(AccountState state) {
    return state.toJson();
  }

  Future<List<File>> exportCredentialFiles() async {
    _log.fine("exportCredentialFiles");
    return _credentialsManager.exportCredentials();
  }

  void recursiveFolderCopySync(String path1, String path2) {
    _log.fine("recursiveFolderCopySync: $path1, $path2");
    Directory dir1 = Directory(path1);
    Directory dir2 = Directory(path2);
    if (!dir2.existsSync()) {
      dir2.createSync(recursive: true);
    }

    dir1.listSync().forEach((element) {
      String elementName = p.basename(element.path);
      String newPath = "${dir2.path}/$elementName";
      if (element is File) {
        File newFile = File(newPath);
        newFile.writeAsBytesSync(element.readAsBytesSync());
      } else {
        recursiveFolderCopySync(element.path, newPath);
      }
    });
  }

  void _listenPaymentResultEvents() {
    _log.fine("_listenPaymentResultEvents");
    _breezLib.paymentResultStream.listen((paymentInfo) {
      _paymentResultStreamController.add(
        PaymentResult(paymentInfo: paymentInfo),
      );
    }, onError: (error) {
      _paymentResultStreamController.add(PaymentResult(error: error));
    });
  }

  void mnemonicsValidated() {
    _log.fine("mnemonicsValidated");
    emit(state.copyWith(verificationStatus: VerificationStatus.VERIFIED));
  }
}
