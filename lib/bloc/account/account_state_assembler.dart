import 'package:breez_sdk/bridge_generated.dart';
import 'package:breez_translations/breez_translations_locales.dart';
import 'package:c_breez/bloc/account/payment_filters.dart';
import 'package:c_breez/models/payment_minutiae.dart';

import 'account_bloc.dart';
import 'account_state.dart';

// assembleAccountState assembles the account state using the local synchronized data.
AccountState? assembleAccountState(
  List<Payment> payments,
  PaymentFilters paymentFilters,
  NodeState? nodeState,
  AccountState state,
) {
  if (nodeState == null) {
    return null;
  }

  final texts = getSystemAppLocalizations();
  // return the new account state
  return state.copyWith(
    id: nodeState.id,
    initial: false,
    blockheight: nodeState.blockHeight,
    balance: nodeState.channelsBalanceMsat.toInt() ~/ 1000,
    walletBalance: nodeState.onchainBalanceMsat ~/ 1000,
    maxAllowedToPay: nodeState.maxPayableMsat ~/ 1000,
    maxAllowedToReceive: nodeState.maxReceivableMsat ~/ 1000,
    maxPaymentAmount: maxPaymentAmount,
    maxChanReserve: (nodeState.channelsBalanceMsat.toInt() - nodeState.maxPayableMsat.toInt()) ~/ 1000,
    connectedPeers: nodeState.connectedPeers,
    onChainFeeRate: 0,
    maxInboundLiquidity: nodeState.inboundLiquidityMsats ~/ 1000,
    payments: payments.map((e) => PaymentMinutiae.fromPayment(e, texts)).toList(),
    paymentFilters: paymentFilters,
    connectionStatus: ConnectionStatus.CONNECTED,
    verificationStatus: state.verificationStatus,
  );
}
