import 'package:breez_sdk/bridge_generated.dart';
import 'package:c_breez/bloc/account/account_bloc.dart';
import 'package:c_breez/bloc/account/account_state.dart';
import 'package:c_breez/bloc/lsp/lsp_bloc.dart';
import 'package:c_breez/bloc/lsp/lsp_state.dart';
import 'package:c_breez/bloc/user_profile/user_profile_bloc.dart';
import 'package:c_breez/bloc/user_profile/user_profile_state.dart';
import 'package:c_breez/routes/home/widgets/bubble_painter.dart';
import 'package:c_breez/routes/home/widgets/dashboard/wallet_dashboard_header_delegate.dart';
import 'package:c_breez/routes/home/widgets/no_lsp_widget.dart';
import 'package:c_breez/routes/home/widgets/payments_filter/fixed_sliver_delegate.dart';
import 'package:c_breez/routes/home/widgets/payments_filter/header_filter_chip.dart';
import 'package:c_breez/routes/home/widgets/payments_filter/payments_filter_sliver.dart';
import 'package:c_breez/routes/home/widgets/payments_list/payments_list.dart';
import 'package:c_breez/routes/home/widgets/status_text.dart';
import 'package:c_breez/theme/theme_provider.dart' as theme;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

const _kFilterMaxSize = 64.0;
const _kPaymentListItemHeight = 72.0;

class AccountPage extends StatelessWidget {
  final GlobalKey firstPaymentItemKey;
  final ScrollController scrollController;

  const AccountPage(
    this.firstPaymentItemKey,
    this.scrollController, {
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LSPBloc, LSPState>(
      builder: (context, lspState) {
        return BlocBuilder<AccountBloc, AccountState>(
          builder: (context, account) {
            return BlocBuilder<UserProfileBloc, UserProfileState>(
              builder: (context, userModel) {
                return Container(
                  color: Theme.of(context).customData.dashboardBgColor,
                  child: _build(
                    context,
                    lspState,
                    account,
                    userModel,
                  ),
                );
              },
            );
          },
        );
      },
    );
  }

  Widget _build(
    BuildContext context,
    LSPState lspState,
    AccountState account,
    UserProfileState userModel,
  ) {
    final transactions = account.transactions;
    final transactionFilters = account.transactionFilters;

    List<Widget> slivers = [];

    slivers.add(
      const SliverPersistentHeader(
        floating: false,
        delegate: WalletDashboardHeaderDelegate(),
        pinned: true,
      ),
    );

    final bool showSliver = transactions.isNotEmpty ||
        transactionFilters.filter != PaymentTypeFilter.All;

    if (showSliver) {
      slivers.add(
        PaymentsFilterSliver(
          maxSize: _kFilterMaxSize,
          scrollController: scrollController,
          hasFilter: transactionFilters.filter != PaymentTypeFilter.All,
        ),
      );
    }

    int? startDate = transactionFilters.fromTimestamp;
    int? endDate = transactionFilters.toTimestamp;
    if (startDate != null && endDate != null) {
      slivers.add(
        HeaderFilterChip(
          _kFilterMaxSize,
          DateTime.fromMillisecondsSinceEpoch(startDate),
          DateTime.fromMillisecondsSinceEpoch(endDate),
        ),
      );
    }

    if (showSliver) {
      slivers.add(
        PaymentsList(
          transactions,
          _kPaymentListItemHeight,
          firstPaymentItemKey,
        ),
      );
      slivers.add(
        SliverPersistentHeader(
          pinned: true,
          delegate: FixedSliverDelegate(
            _bottomPlaceholderSpace(context, transactions),
            child: Container(),
          ),
        ),
      );
    } else if (!account.initial) {
      slivers.add(
        SliverPersistentHeader(
          delegate: FixedSliverDelegate(
            250.0,
            builder: (context, shrinkedHeight, overlapContent) {
              if (lspState.selectionRequired == true) {
                return const Padding(
                  padding: EdgeInsets.only(top: 120.0),
                  child: NoLSPWidget(),
                );
              }
              return const Padding(
                padding: EdgeInsets.fromLTRB(40.0, 120.0, 40.0, 0.0),
                child: StatusText(),
              );
            },
          ),
        ),
      );
    }

    return Stack(
      key: const Key("account_sliver"),
      fit: StackFit.expand,
      children: [
        !showSliver
            ? CustomPaint(painter: BubblePainter(context))
            : const SizedBox(),
        CustomScrollView(
          controller: scrollController,
          slivers: slivers,
        ),
      ],
    );
  }

  double _bottomPlaceholderSpace(
    BuildContext context,
    List<LightningTransaction> transactions,
  ) {
    if (transactions.isEmpty) return 0.0;
    double listHeightSpace = MediaQuery.of(context).size.height -
        kMinExtent -
        kToolbarHeight -
        _kFilterMaxSize -
        25.0;
    const endDate = null;
    double dateFilterSpace = endDate != null ? 0.65 : 0.0;
    double bottomPlaceholderSpace = (listHeightSpace -
            (_kPaymentListItemHeight + 8) *
                (transactions.length + 1 + dateFilterSpace))
        .clamp(0.0, listHeightSpace);
    return bottomPlaceholderSpace;
  }
}
