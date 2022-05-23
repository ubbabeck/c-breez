import 'package:c_breez/bloc/account/account_bloc.dart';
import 'package:c_breez/bloc/account/account_state.dart';
import 'package:c_breez/bloc/lsp/lsp_bloc.dart';
import 'package:c_breez/bloc/lsp/lsp_state.dart';
import 'package:c_breez/routes/lsp/select_lsp_page.dart';
import 'package:c_breez/routes/select_provider_error_dialog.dart';
import 'package:c_breez/widgets/route.dart';
import 'package:fixnum/fixnum.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'warning_action.dart';

class AccountRequiredActionsIndicator extends StatelessWidget {
  const AccountRequiredActionsIndicator({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LSPBloc, LSPState>(
      builder: (ctx, lspState) {
        return BlocBuilder<AccountBloc, AccountState>(
          builder: (context, accState) {
            return _build(
              context,
              lspState,
              accState,
            );
          },
        );
      },
    );
  }

  Widget _build(
    BuildContext context,
    LSPState lspStatus,
    AccountState accountModel,
  ) {
    final navigatorState = Navigator.of(context);

    List<Widget> warnings = [];
    Int64 walletBalance = accountModel.walletBalance;

    if (walletBalance > 0) {
      warnings.add(
        WarningAction(() => navigatorState.pushNamed("/send_coins")),
      );
    }

    if (lspStatus.selectionRequired == true ||
        lspStatus.connectionStatus == LSPConnectionStatus.notActive) {
      warnings.add(WarningAction(() {
        if (lspStatus.lastConnectionError != null) {
          showProviderErrorDialog(context, () {
            navigatorState.push(FadeInRoute(
              builder: (_) => SelectLSPPage(lstBloc: context.read()),
            ));
          });
        } else {
          navigatorState.pushNamed("/select_lsp");
        }
      }));
    }

    if (warnings.isEmpty) {
      return const SizedBox();
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      mainAxisSize: MainAxisSize.min,
      children: warnings,
    );
  }
}