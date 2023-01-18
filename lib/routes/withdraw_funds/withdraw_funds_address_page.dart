import 'package:c_breez/bloc/account/account_bloc.dart';
import 'package:c_breez/bloc/account/account_state.dart';
import 'package:breez_translations/breez_translations_locales.dart';
import 'package:c_breez/routes/withdraw_funds/bitcoin_address_text_form_field.dart';
import 'package:c_breez/routes/withdraw_funds/withdraw_funds_address_next_button.dart';
import 'package:c_breez/routes/withdraw_funds/withdraw_funds_available_btc.dart';
import 'package:c_breez/widgets/back_button.dart' as back_button;
import 'package:c_breez/widgets/warning_box.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class WithdrawFundsAddressPage extends StatefulWidget {
  const WithdrawFundsAddressPage({
    Key? key,
  }) : super(key: key);

  @override
  State<WithdrawFundsAddressPage> createState() => _WithdrawFundsAddressPageState();
}

class _WithdrawFundsAddressPageState extends State<WithdrawFundsAddressPage> {
  final _addressController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final texts = context.texts();
    final themeData = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        leading: const back_button.BackButton(),
        actions: const [],
        title: Text(texts.unexpected_funds_title),
      ),
      body: Column(
        children: [
          WarningBox(
            boxPadding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
            contentPadding: const EdgeInsets.fromLTRB(8, 12, 8, 12),
            child: Text(
              texts.unexpected_funds_message,
              style: themeData.textTheme.headline6,
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
            child: Form(
              key: _formKey,
              child: BitcoinAddressTextFormField(
                context: context,
                controller: _addressController,
                validatorHolder: ValidatorHolder(),
              ),
            ),
          ),
          const Padding(
            padding: EdgeInsets.fromLTRB(16, 8, 16, 8),
            child: WithdrawFundsAvailableBtc(),
          ),
          Expanded(child: Container()),
          BlocBuilder<AccountBloc, AccountState>(builder: (context, state) {
            return WithdrawFundsAddressNextButton(
              addressController: _addressController,
              validator: () => _formKey.currentState?.validate() ?? false,
              amount: state.walletBalance,
            );
          }),
        ],
      ),
    );
  }
}
