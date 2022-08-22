import 'package:auto_size_text/auto_size_text.dart';
import 'package:c_breez/bloc/account/account_state.dart';
import 'package:c_breez/bloc/currency/currency_bloc.dart';
import 'package:c_breez/bloc/currency/currency_state.dart';
import 'package:c_breez/l10n/build_context_localizations.dart';
import 'package:c_breez/theme/theme_provider.dart' as theme;
import 'package:c_breez/widgets/warning_box.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'bottom_action_item_image.dart';

class ReceiveOptionsBottomSheet extends StatelessWidget {
  final AccountState account;
  final bool connected;
  final GlobalKey firstPaymentItemKey;

  const ReceiveOptionsBottomSheet(
      {super.key,
      required this.connected,
      required this.firstPaymentItemKey,
      required this.account});

  @override
  Widget build(BuildContext context) {
    final texts = context.texts();
    final themeData = Theme.of(context);

    return BlocBuilder<CurrencyBloc, CurrencyState>(
      builder: (context, currencyState) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 8.0),
            ListTile(
              enabled: connected,
              leading: BottomActionItemImage(
                iconAssetPath: "src/icon/paste.png",
                enabled: connected,
              ),
              title: Text(
                texts.bottom_action_bar_receive_invoice,
                style: theme.bottomSheetTextStyle,
              ),
              onTap: () => _push(context, "/create_invoice"),
            ),
            account.maxChanReserve == 0
                ? const SizedBox(height: 8.0)
                : WarningBox(
                    boxPadding: const EdgeInsets.all(16),
                    contentPadding: const EdgeInsets.all(8),
                    child: AutoSizeText(
                      texts.bottom_action_bar_warning_balance_title(
                        currencyState.bitcoinCurrency.format(
                          account.maxChanReserve,
                          removeTrailingZeros: true,
                        ),
                      ),
                      maxFontSize: themeData.textTheme.subtitle1!.fontSize!,
                      style: themeData.textTheme.headline6,
                      textAlign: TextAlign.center,
                    ),
                  ),
          ],
        );
      },
    );
  }

  void _push(BuildContext context, String route) {
    final navigatorState = Navigator.of(context);
    navigatorState.pop();
    navigatorState.pushNamed(route);
  }
}