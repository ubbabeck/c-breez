import 'package:auto_size_text/auto_size_text.dart';
import 'package:breez_sdk/bridge_generated.dart';
import 'package:breez_translations/breez_translations_locales.dart';
import 'package:c_breez/bloc/account/account_bloc.dart';
import 'package:c_breez/bloc/currency/currency_bloc.dart';
import 'package:c_breez/bloc/lsp/lsp_bloc.dart';
import 'package:c_breez/theme/theme_provider.dart' as theme;
import 'package:c_breez/utils/min_font_size.dart';
import 'package:c_breez/widgets/warning_box.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ReceivableBTCBox extends StatefulWidget {
  final String? receiveLabel;
  final void Function()? onTap;

  const ReceivableBTCBox({
    super.key,
    this.receiveLabel,
    this.onTap,
  });

  @override
  State<StatefulWidget> createState() {
    return ReceivableBTCBoxState();
  }
}

class ReceivableBTCBoxState extends State<ReceivableBTCBox> {
  @override
  Widget build(BuildContext context) {
    final texts = context.texts();
    final currencyState = context.read<CurrencyBloc>().state;
    final accountState = context.read<AccountBloc>().state;
    final lspState = context.watch<LSPBloc>().state;
    final isChannelOpeningAvailable = lspState?.isChannelOpeningAvailable ?? false;

    return Container(
      width: MediaQuery.of(context).size.width,
      height: 164,
      padding: const EdgeInsets.only(top: 16.0),
      child: GestureDetector(
        onTap: widget.onTap,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            (!isChannelOpeningAvailable && accountState.maxInboundLiquidity <= 0)
                ? WarningBox(
                    boxPadding: const EdgeInsets.only(top: 8),
                    child: AutoSizeText(
                      texts.lsp_error_cannot_open_channel,
                      textAlign: TextAlign.center,
                    ),
                  )
                : AutoSizeText(
                    widget.receiveLabel ??
                        texts.invoice_receive_label(
                          currencyState.bitcoinCurrency.format((isChannelOpeningAvailable)
                              ? accountState.maxAllowedToReceive
                              : accountState.maxInboundLiquidity),
                        ),
                    style: theme.textStyle,
                    maxLines: 1,
                    minFontSize: MinFontSize(context).minFontSize,
                  ),
            isChannelOpeningAvailable && accountState.isFeesApplicable
                ? FeeMessage(lspState!.lspInfo!.openingFeeParamsList.values.first)
                : const SizedBox(),
          ],
        ),
      ),
    );
  }
}

class FeeMessage extends StatelessWidget {
  final OpeningFeeParams openingFeeParams;

  const FeeMessage(this.openingFeeParams);

  @override
  Widget build(BuildContext context) {
    final themeData = Theme.of(context);

    return WarningBox(
      boxPadding: const EdgeInsets.fromLTRB(16, 30, 16, 16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            formatFeeMessage(context, openingFeeParams),
            style: themeData.textTheme.titleLarge,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  String formatFeeMessage(BuildContext context, OpeningFeeParams openingFeeParams) {
    final texts = context.texts();
    final currencyState = context.read<CurrencyBloc>().state;
    final accountState = context.read<AccountBloc>().state;

    final minFee = openingFeeParams.minMsat ~/ 1000;
    final minFeeFormatted = currencyState.bitcoinCurrency.format(minFee);
    final minFeeAboveZero = minFee > 0;
    final setUpFee = (openingFeeParams.proportional / 10000).toString();
    final liquidity = currencyState.bitcoinCurrency.format(
      accountState.maxInboundLiquidity,
    );
    final liquidityAboveZero = accountState.maxInboundLiquidity > 0;

    if (minFeeAboveZero && liquidityAboveZero) {
      // A setup fee of {setUpFee}% with a minimum of {minFee} will be applied for receiving more than {liquidity}
      return texts.invoice_ln_address_warning_with_min_fee_account_connected(
        setUpFee,
        minFeeFormatted,
        liquidity,
      );
    } else if (!minFeeAboveZero && liquidityAboveZero) {
      // A setup fee of {setUpFee}% will be applied for receiving more than {liquidity}.
      return texts.invoice_ln_address_warning_without_min_fee_account_connected(
        setUpFee,
        liquidity,
      );
    } else if (minFeeAboveZero && !liquidityAboveZero) {
      // A setup fee of {setUpFee}% with a minimum of {minFee} will be applied on the received amount.
      return texts.invoice_ln_address_warning_with_min_fee_account_not_connected(
        setUpFee,
        minFeeFormatted,
      );
    } else {
      // A setup fee of {setUpFee}% will be applied on the received amount.
      return texts.invoice_ln_address_warning_without_min_fee_account_not_connected(
        setUpFee,
      );
    }
  }
}
