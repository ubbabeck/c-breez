import 'package:breez_sdk/bridge_generated.dart';
import 'package:c_breez/bloc/account/payment_filters.dart';

const initialInboundCapacity = 4000000;

class AccountState {
  final String? id;
  final bool initial;
  final int blockheight;
  final int balance;
  final int walletBalance;
  final int maxAllowedToPay;
  final int maxAllowedToReceive;
  final int maxPaymentAmount;
  final int maxChanReserve;
  final List<String> connectedPeers;
  final int maxInboundLiquidity;
  final int onChainFeeRate;
  final List<Payment> payments;
  final PaymentFilters paymentFilters;

  const AccountState({
    required this.id,
    required this.initial,
    required this.blockheight,
    required this.balance,
    required this.walletBalance,
    required this.maxAllowedToPay,
    required this.maxAllowedToReceive,
    required this.maxPaymentAmount,
    required this.maxChanReserve,
    required this.connectedPeers,
    required this.maxInboundLiquidity,
    required this.onChainFeeRate,
    required this.payments,
    required this.paymentFilters,
  });

  AccountState.initial()
      : this(
          id: null,
          initial: true,
          blockheight: 0,
          maxAllowedToPay: 0,
          maxAllowedToReceive: 0,
          maxPaymentAmount: 0,
          maxChanReserve: 0,
          connectedPeers: List.empty(),
          maxInboundLiquidity: 0,
          onChainFeeRate: 0,
          balance: 0,
          walletBalance: 0,
          payments: [],
          paymentFilters: PaymentFilters.initial(),
        );

  AccountState copyWith({
    String? id,
    bool? initial,
    int? blockheight,
    int? balance,
    int? walletBalance,
    int? maxAllowedToPay,
    int? maxAllowedToReceive,
    int? maxPaymentAmount,
    int? maxChanReserve,
    List<String>? connectedPeers,
    int? maxInboundLiquidity,
    int? onChainFeeRate,
    List<Payment>? payments,
    PaymentFilters? paymentFilters,
  }) {
    return AccountState(
      id: id ?? this.id,
      initial: initial ?? this.initial,
      balance: balance ?? this.balance,
      walletBalance: walletBalance ?? this.walletBalance,
      maxAllowedToPay: maxAllowedToPay ?? this.maxAllowedToPay,
      maxAllowedToReceive: maxAllowedToReceive ?? this.maxAllowedToReceive,
      maxPaymentAmount: maxPaymentAmount ?? this.maxPaymentAmount,
      blockheight: blockheight ?? this.blockheight,
      maxChanReserve: maxChanReserve ?? this.maxChanReserve,
      connectedPeers: connectedPeers ?? this.connectedPeers,
      maxInboundLiquidity: maxInboundLiquidity ?? this.maxInboundLiquidity,
      onChainFeeRate: onChainFeeRate ?? this.onChainFeeRate,
      payments: payments ?? this.payments,
      paymentFilters: paymentFilters ?? this.paymentFilters,
    );
  }

  int get reserveAmount => balance - maxAllowedToPay;

  // TODO: Add payments toJson
  Map<String, dynamic>? toJson() {
    return {
      "id": id,
      "initial": initial,
      "blockheight": blockheight,
      "balance": balance,
      "walletBalance": walletBalance,
      "maxAllowedToPay": maxAllowedToPay,
      "maxAllowedToReceive": maxAllowedToReceive,
      "maxPaymentAmount": maxPaymentAmount,
      "maxChanReserve": maxChanReserve,
      "maxInboundLiquidity": maxInboundLiquidity,
      "onChainFeeRate": onChainFeeRate,
      "paymentFilters": paymentFilters.toJson(),
    };
  }

// TODO: Generate payments fromJson
  factory AccountState.fromJson(Map<String, dynamic> json) {
    return AccountState(
      id: json["id"],
      initial: json["initial"],
      blockheight: json["blockheight"],
      balance: json["balance"],
      walletBalance: json["walletBalance"],
      maxAllowedToPay: json["maxAllowedToPay"],
      maxAllowedToReceive: json["maxAllowedToReceive"],
      maxPaymentAmount: json["maxPaymentAmount"],
      maxChanReserve: json["maxChanReserve"],
      connectedPeers: <String>[],
      maxInboundLiquidity: json["maxInboundLiquidity"] ?? 0,
      onChainFeeRate: (json["onChainFeeRate"]),
      payments: [],
      paymentFilters: PaymentFilters.fromJson(json["paymentFilters"]),
    );
  }
}
