import 'dart:io';

import 'package:breez_sdk/sdk.dart';
import 'package:c_breez/bloc/currency/currency_bloc.dart';
import 'package:c_breez/bloc/currency/currency_state.dart';
import 'package:c_breez/l10n/build_context_localizations.dart';
import 'package:c_breez/services/injector.dart';
import 'package:c_breez/theme/theme_provider.dart';
import 'package:fixnum/fixnum.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';

class PaymentItemAmount extends StatelessWidget {
  final PaymentInfo _paymentInfo;
  final bool _hideBalance;

  const PaymentItemAmount(
    this._paymentInfo,
    this._hideBalance, {
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final themeData = Theme.of(context);
    final texts = context.texts();

    return SizedBox(
      height: 44,
      child: BlocBuilder<CurrencyBloc, CurrencyState>(
        builder: (context, currencyState) {
          final fee = _paymentInfo.feeSat;
          final amount = currencyState.bitcoinCurrency.format(
            _paymentInfo.amountSat,
            includeDisplayName: false,
          );
          final feeFormatted = currencyState.bitcoinCurrency.format(
            fee,
            includeDisplayName: false,
          );

          return Column(
            mainAxisAlignment: _paymentInfo.feeSat == 0 || _paymentInfo.pending
                ? MainAxisAlignment.center
                : MainAxisAlignment.spaceAround,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                _hideBalance
                    ? texts.wallet_dashboard_payment_item_balance_hide
                    : _paymentInfo.type.isIncome
                        ? texts.wallet_dashboard_payment_item_balance_positive(amount)
                        : texts.wallet_dashboard_payment_item_balance_negative(amount),
                style: themeData.isBreezLight
                    ? const TextStyle(
                        color: Colors.black,
                        fontSize: 13.5,
                        fontWeight: FontWeight.w500,
                        height: 1.2,
                        letterSpacing: 0.5,
                      )
                    : const TextStyle(
                        color: Colors.white,
                        fontSize: 13.5,
                        fontWeight: FontWeight.w500,
                        height: 1.28,
                        letterSpacing: 0.5,
                      ),
              ),
              (fee == 0 || _paymentInfo.pending)
                  ? const SizedBox()
                  : Text(
                      _hideBalance
                          ? texts.wallet_dashboard_payment_item_balance_hide
                          : texts.wallet_dashboard_payment_item_balance_fee(feeFormatted),
                      style: themeData.isBreezLight
                          ? const TextStyle(
                              color: Color(0xb3303234),
                              fontSize: 10.5,
                              fontWeight: FontWeight.w400,
                              height: 1.16,
                              letterSpacing: 0.39,
                            )
                          : TextStyle(
                              color: Colors.white.withOpacity(0.7),
                              fontSize: 10.5,
                              fontWeight: FontWeight.w400,
                              height: 1.16,
                              letterSpacing: 0.39,
                            ),
                    ),
            ],
          );
        },
      ),
    );
  }
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  HydratedBlocOverrides.runZoned(
    () => runApp(MultiBlocProvider(
      providers: [
        BlocProvider<CurrencyBloc>(
          create: (BuildContext context) => CurrencyBloc(ServiceInjector().lightningServices.fiatService),
        ),
      ],
      child: MaterialApp(
        theme: breezLightTheme,
        home: Column(children: [
          PaymentItemAmount(
            PaymentInfo(
              type: PaymentType.received,
              amountMsat: Int64(4321000),
              feeMsat: Int64(0),
              creationTimestamp: Int64(1661791810),
              pending: false,
              keySend: false,
              paymentHash: "7afeee37f0bb1578e94f2e406973118c4dcec0e0755aa873af4a9a24473c02de",
              preimage: null,
              destination: "0264a67069b7cbd4ea3db0709d9f605e11643a66fe434d77eaf9bf960a323dda5d",
              pendingExpirationTimestamp: null,
              description: "",
              longTitle: "",
              shortTitle: "",
              imageURL: null,
            ),
            false,
          ),

          // Pending
          PaymentItemAmount(
            PaymentInfo(
              type: PaymentType.received,
              amountMsat: Int64(4321000),
              feeMsat: Int64(1234),
              creationTimestamp: Int64(1661791810),
              pending: true,
              keySend: false,
              paymentHash: "7afeee37f0bb1578e94f2e406973118c4dcec0e0755aa873af4a9a24473c02de",
              preimage: null,
              destination: "0264a67069b7cbd4ea3db0709d9f605e11643a66fe434d77eaf9bf960a323dda5d",
              pendingExpirationTimestamp: null,
              description: "",
              longTitle: "",
              shortTitle: "",
              imageURL: null,
            ),
            false,
          ),

          // Show all
          PaymentItemAmount(
            PaymentInfo(
              type: PaymentType.received,
              amountMsat: Int64(4321000),
              feeMsat: Int64(1234),
              creationTimestamp: Int64(1661791810),
              pending: false,
              keySend: false,
              paymentHash: "7afeee37f0bb1578e94f2e406973118c4dcec0e0755aa873af4a9a24473c02de",
              preimage: null,
              destination: "0264a67069b7cbd4ea3db0709d9f605e11643a66fe434d77eaf9bf960a323dda5d",
              pendingExpirationTimestamp: null,
              description: "",
              longTitle: "",
              shortTitle: "",
              imageURL: null,
            ),
            false,
          ),

          // Hide all
          PaymentItemAmount(
            PaymentInfo(
              type: PaymentType.received,
              amountMsat: Int64(4321000),
              feeMsat: Int64(1234),
              creationTimestamp: Int64(1661791810),
              pending: false,
              keySend: false,
              paymentHash: "7afeee37f0bb1578e94f2e406973118c4dcec0e0755aa873af4a9a24473c02de",
              preimage: null,
              destination: "0264a67069b7cbd4ea3db0709d9f605e11643a66fe434d77eaf9bf960a323dda5d",
              pendingExpirationTimestamp: null,
              description: "",
              longTitle: "",
              shortTitle: "",
              imageURL: null,
            ),
            true,
          ),
        ]),
      ),
    )),
    storage: await HydratedStorage.build(
      storageDirectory: Directory(join((await getApplicationDocumentsDirectory()).path, "preview_storage")),
    ),
  );
}
