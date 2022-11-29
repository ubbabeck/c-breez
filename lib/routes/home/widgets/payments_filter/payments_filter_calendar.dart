import 'package:breez_sdk/bridge_generated.dart';
import 'package:c_breez/bloc/account/account_bloc.dart';
import 'package:c_breez/bloc/account/account_state.dart';
import 'package:c_breez/l10n/build_context_localizations.dart';
import 'package:c_breez/routes/home/widgets/payments_filter/calendar_dialog.dart';
import 'package:c_breez/theme/theme_provider.dart' as theme;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';

class PaymentsFilterCalendar extends StatelessWidget {
  final PaymentTypeFilter filter;

  const PaymentsFilterCalendar(
    this.filter, {
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final texts = context.texts();
    final themeData = Theme.of(context);

    return BlocBuilder<AccountBloc, AccountState>(
      builder: (context, account) {
        DateTime? firstDate;
        if (account.payments.isNotEmpty) {
          firstDate = DateTime.fromMillisecondsSinceEpoch(
            account.payments.first.paymentTime * 1000,
          );
        }

        return Padding(
          padding: const EdgeInsets.only(left: 0.0, right: 0.0),
          child: IconButton(
            icon: SvgPicture.asset(
              "src/icon/calendar.svg",
              color: themeData.isLightTheme
                  ? Colors.black
                  : themeData.colorScheme.onSecondary,
              width: 24.0,
              height: 24.0,
            ),
            onPressed: () => firstDate != null
                ? showDialog<List<DateTime>>(
                    useRootNavigator: false,
                    context: context,
                    builder: (_) => CalendarDialog(firstDate!),
                  ).then((result) {
                    final accountBloc = context.read<AccountBloc>();
                    if (result != null) {
                      accountBloc.changePaymentFilter(
                        filter: filter,
                        fromTimestamp: result[0].millisecondsSinceEpoch,
                        toTimestamp: result[1].millisecondsSinceEpoch,
                      );
                    }
                  })
                : ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        texts.payments_filter_message_loading_transactions,
                      ),
                      behavior: SnackBarBehavior.floating,
                    ),
                  ),
          ),
        );
      },
    );
  }
}
