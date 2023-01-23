import 'package:auto_size_text/auto_size_text.dart';
import 'package:breez_translations/breez_translations_locales.dart';
import 'package:c_breez/bloc/currency/currency_bloc.dart';
import 'package:c_breez/bloc/currency/currency_state.dart';
import 'package:c_breez/models/currency.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class FeeBreakdown extends StatelessWidget {
  final int total;
  final int fee;

  const FeeBreakdown(
    this.total,
    this.fee, {
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final themeData = Theme.of(context);
    final texts = context.texts();

    return Container(
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.all(Radius.circular(5.0)),
        border: Border.all(
          color: themeData.colorScheme.onSurface.withOpacity(0.4),
        ),
      ),
      child: Column(
        children: [
          ListTile(
            title: AutoSizeText(
              texts.sweep_all_coins_label_send,
              style: themeData.primaryTextTheme.titleMedium!.copyWith(
                color: themeData.primaryColor,
              ),
              maxLines: 1,
              minFontSize: 12,
              stepGranularity: 0.1,
            ),
            trailing: AutoSizeText(
              BitcoinCurrency.SAT.format(total),
              style: themeData.primaryTextTheme.titleMedium!.copyWith(
                color: themeData.primaryColor.withOpacity(0.8),
              ),
              maxLines: 1,
              minFontSize: 12,
              stepGranularity: 0.1,
            ),
          ),
          ListTile(
            title: AutoSizeText(
              texts.sweep_all_coins_label_transaction_fee,
              style: themeData.primaryTextTheme.titleMedium!.copyWith(
                color: themeData.primaryColor.withOpacity(0.4),
              ),
              maxLines: 1,
              minFontSize: 12,
              stepGranularity: 0.1,
            ),
            trailing: AutoSizeText(
              texts.sweep_all_coins_fee(
                BitcoinCurrency.SAT.format(fee),
              ),
              style: themeData.primaryTextTheme.titleMedium!.copyWith(
                color: themeData.primaryColor.withOpacity(0.4),
              ),
              maxLines: 1,
              minFontSize: 12,
              stepGranularity: 0.1,
            ),
          ),
          ListTile(
            title: AutoSizeText(
              texts.sweep_all_coins_label_receive,
              style: themeData.primaryTextTheme.titleMedium!.copyWith(
                color: themeData.primaryColor,
              ),
              maxLines: 1,
              minFontSize: 12,
              stepGranularity: 0.1,
            ),
            trailing: BlocBuilder<CurrencyBloc, CurrencyState>(
              builder: (context, currency) {
                final fiatConversion = currency.fiatConversion();
                int receive = total - fee;
                return AutoSizeText(
                  fiatConversion == null
                      ? texts.sweep_all_coins_amount_no_fiat(
                          BitcoinCurrency.SAT.format(receive),
                        )
                      : texts.sweep_all_coins_amount_with_fiat(
                          BitcoinCurrency.SAT.format(receive),
                          fiatConversion.format(receive),
                        ),
                  style: themeData.primaryTextTheme.titleMedium!.copyWith(
                    color: themeData.primaryColor.withOpacity(0.8),
                  ),
                  maxLines: 1,
                  minFontSize: 12,
                  stepGranularity: 0.1,
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}