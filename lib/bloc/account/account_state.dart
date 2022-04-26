import 'package:c_breez/models/account.dart';
import 'package:fixnum/fixnum.dart';

const initialInboundCapacity = 4000000;

enum AccountStatus { CONNECTING, CONNECTED, DISCONNECTION, DISCONNECTED }

class AccountState {
  final String? id;
  final bool initial;
  final Int64 blockheight;
  final Int64 balance;
  final Int64 walletBalance;
  final AccountStatus status;
  final Int64 maxAllowedToPay;
  final Int64 maxAllowedToReceive;
  final Int64 maxPaymentAmount;
  final Int64 maxChanReserve;
  final List<String> connectedPeers;
  final Int64 maxInboundLiquidity;
  final Int64 onChainFeeRate;
  final PaymentsState payments;

  AccountState(
      {required this.payments,
      required this.id,
      required this.initial,
      required this.blockheight,
      required this.balance,
      required this.walletBalance,
      required this.status,
      required this.maxAllowedToPay,
      required this.maxAllowedToReceive,
      required this.maxPaymentAmount,
      required this.maxChanReserve,
      required this.connectedPeers,
      required this.maxInboundLiquidity,
      required this.onChainFeeRate});

  AccountState.initial()
      : this(
            id: null,
            blockheight: Int64(0),
            status: AccountStatus.DISCONNECTED,
            maxAllowedToPay: Int64(0),
            maxAllowedToReceive: Int64(0),
            maxPaymentAmount: Int64(0),
            maxChanReserve: Int64(0),
            connectedPeers: List.empty(),
            maxInboundLiquidity: Int64(0),
            onChainFeeRate: Int64(0),
            balance: Int64(0),
            walletBalance: Int64(0),
            payments: PaymentsState.initial(),
            initial: true);

  AccountState copyWith(
      {
        String? id,
      PaymentsState? payments,
      bool? initial,
      Int64? blockheight,
      Int64? balance,
      Int64? walletBalance,
      AccountStatus? status,
      Int64? maxAllowedToPay,
      Int64? maxAllowedToReceive,
      Int64? maxPaymentAmount,
      Int64? maxChanReserve,      
      List<String>? connectedPeers,
      Int64? maxInboundLiquidity,
      Int64? onChainFeeRate}) {
    return AccountState(
        payments: payments ?? this.payments,
        id: id ?? this.id,
        initial: initial ?? this.initial,
        balance: balance ?? this.balance,
        walletBalance: walletBalance ?? this.walletBalance,
        status: status ?? this.status,
        maxAllowedToPay: maxAllowedToPay ?? this.maxAllowedToPay,
        maxAllowedToReceive: maxAllowedToReceive ?? this.maxAllowedToReceive,
        maxPaymentAmount: maxPaymentAmount ?? this.maxPaymentAmount,
        blockheight: blockheight ?? this.blockheight,
        maxChanReserve: maxChanReserve ?? this.maxChanReserve,
        connectedPeers: connectedPeers ?? this.connectedPeers,
        maxInboundLiquidity: maxInboundLiquidity ?? this.maxInboundLiquidity,
        onChainFeeRate: onChainFeeRate ?? this.onChainFeeRate);
  }

  Int64 get reserveAmount => balance - maxAllowedToPay;
}

class PaymentsState {
  final List<PaymentInfo> nonFilteredItems;
  final List<PaymentInfo> paymentsList;
  final PaymentFilterModel filter;
  final DateTime? firstDate;

  PaymentsState(this.nonFilteredItems, this.paymentsList, this.filter, [this.firstDate]);

  PaymentsState.initial() : this(<PaymentInfo>[], <PaymentInfo>[], PaymentFilterModel.initial(), DateTime(DateTime.now().year));

  PaymentsState copyWith(
      {List<PaymentInfo>? nonFilteredItems, List<PaymentInfo>? paymentsList, PaymentFilterModel? filter, DateTime? firstDate}) {
    return PaymentsState(nonFilteredItems ?? this.nonFilteredItems, paymentsList ?? this.paymentsList, filter ?? this.filter,
        firstDate ?? this.firstDate);
  }
}

class PaymentExceededLimitError implements Exception {
  final Int64 limitSat;

  PaymentExceededLimitError(this.limitSat);
}

class PaymentBellowReserveError implements Exception {
  final Int64 reserveAmount;

  PaymentBellowReserveError(this.reserveAmount);
}

class InsufficientLocalBalanceError implements Exception {}
