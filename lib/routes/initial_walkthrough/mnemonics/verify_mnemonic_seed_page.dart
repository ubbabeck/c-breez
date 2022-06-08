import 'dart:math';

import 'package:bip39/bip39.dart' as bip39;
import 'package:c_breez/bloc/account/account_bloc.dart';
import 'package:c_breez/bloc/user_profile/user_profile_bloc.dart';
import 'package:c_breez/l10n/build_context_localizations.dart';
import 'package:c_breez/theme/theme_provider.dart' as theme;
import 'package:c_breez/widgets/back_button.dart' as back_button;
import 'package:c_breez/widgets/loader.dart';
import 'package:c_breez/widgets/single_button_bottom_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class VerifyMnemonicSeedPage extends StatefulWidget {
  final String _mnemonics;

  const VerifyMnemonicSeedPage(
    this._mnemonics,
  );

  @override
  VerifyMnemonicSeedPageState createState() => VerifyMnemonicSeedPageState();
}

class VerifyMnemonicSeedPageState extends State<VerifyMnemonicSeedPage> {
  final _formKey = GlobalKey<FormState>();
  final List _randomlySelectedIndexes = [];
  late List<String> _mnemonicsList;
  late bool _hasError;
  bool _registrationFailed = false;
  String _registrationErrorMessage = "";

  @override
  void initState() {
    _mnemonicsList = widget._mnemonics.split(" ");
    _hasError = false;
    _selectIndexes();
    super.initState();
  }

  _selectIndexes() {
    // Select at least one index from each page(0-6,6-11) randomly
    var firstIndex = Random().nextInt(6);
    var secondIndex = Random().nextInt(6) + 6;
    // Select last index randomly from any page, ensure that there are no duplicates and each option has an ~equally likely chance of being selected
    var thirdIndex = Random().nextInt(10);
    if (thirdIndex >= firstIndex) thirdIndex++;
    if (thirdIndex >= secondIndex) thirdIndex++;
    _randomlySelectedIndexes.addAll([firstIndex, secondIndex, thirdIndex]);
    _randomlySelectedIndexes.sort();
  }

  @override
  Widget build(BuildContext context) {
    final query = MediaQuery.of(context);
    final texts = context.texts();

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        leading: const back_button.BackButton(),
        title: Text(texts.backup_phrase_generation_verify),
      ),
      body: SingleChildScrollView(
        child: SizedBox(
          height: query.size.height - kToolbarHeight - query.padding.top,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildForm(context),
              _buildInstructions(context),
              _buildRegisterButton(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildForm(BuildContext context) {
    return Form(
      key: _formKey,
      onChanged: () => _formKey.currentState?.save(),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16.0, 24.0, 16.0, 40.0),
        child: Column(
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: _buildVerificationFormContent(context),
        ),
      ),
    );
  }

  List<Widget> _buildVerificationFormContent(BuildContext context) {
    final themeData = Theme.of(context);
    final texts = context.texts();
    List<Widget> selectedWordList = List.generate(
      _randomlySelectedIndexes.length,
      (index) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 16),
          child: TextFormField(
            decoration: InputDecoration(
              labelText: texts.backup_phrase_generation_type_step(
                _randomlySelectedIndexes[index] + 1,
              ),
            ),
            style: theme.FieldTextStyle.textStyle,
            validator: (text) {
              if (text!.isEmpty ||
                  text.toLowerCase().trim() !=
                      _mnemonicsList[_randomlySelectedIndexes[index]]) {
                setState(() {
                  _hasError = true;
                });
              }
              return null;
            },
            onEditingComplete: () => (index == 2)
                ? FocusScope.of(context).unfocus()
                : FocusScope.of(context).nextFocus(),
          ),
        );
      },
    );
    if (_hasError) {
      selectedWordList.add(Text(
        texts.backup_phrase_generation_verification_failed,
        style: themeData.textTheme.headline4?.copyWith(
          fontSize: 12,
        ),
      ));
    }
    if (_registrationFailed) {
      selectedWordList.add(Text(
        _registrationErrorMessage,
        style: themeData.textTheme.headline4?.copyWith(
          fontSize: 12,
        ),
      ));
    }
    return selectedWordList;
  }

  Padding _buildInstructions(BuildContext context) {
    final texts = context.texts();
    return Padding(
      padding: const EdgeInsets.only(
        left: 72,
        right: 72,
      ),
      child: Text(
        texts.backup_phrase_generation_type_words(
          _randomlySelectedIndexes[0] + 1,
          _randomlySelectedIndexes[1] + 1,
          _randomlySelectedIndexes[2] + 1,
        ),
        style: theme.mnemonicSeedInformationTextStyle.copyWith(
          color: theme.BreezColors.white[300],
        ),
        textAlign: TextAlign.center,
      ),
    );
  }

  Widget _buildRegisterButton(BuildContext context) {
    final texts = context.texts();
    return SingleButtonBottomBar(
      text: texts.backup_phrase_warning_action_backup,
      onPressed: () {
        setState(() {
          _hasError = false;
        });
        if (_formKey.currentState!.validate() && !_hasError) {
          _proceedToRegister();
        }
      },
    );
  }

  void _proceedToRegister() async {
    final registrationBloc = context.read<UserProfileBloc>();
    final accountBloc = context.read<AccountBloc>();

    final navigator = Navigator.of(context);
    var loaderRoute = createLoaderRoute(context);
    navigator.push(loaderRoute);

    await registrationBloc.registerForNotifications();

    await accountBloc
        .startNewNode(bip39.mnemonicToSeed(widget._mnemonics))
        .whenComplete(() => navigator.removeRoute(loaderRoute))
        .catchError(
      (error) {
        setState(() {
          _registrationFailed = true;
          _registrationErrorMessage = error.toString();
        });
        FocusScope.of(context).unfocus();
      },
    );

    navigator.pushReplacementNamed("/");
  }
}
