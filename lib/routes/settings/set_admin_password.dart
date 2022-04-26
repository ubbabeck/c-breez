import 'package:c_breez/bloc/user_profile/user_profile_bloc.dart';
import 'package:c_breez/theme_data.dart' as theme;
import 'package:c_breez/widgets/back_button.dart' as backBtn;
import 'package:c_breez/widgets/single_button_bottom_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class SetAdminPasswordPage extends StatefulWidget {
  final String submitAction;

  const SetAdminPasswordPage({
    Key? key,
    required this.submitAction,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _SetAdminPasswordState();
  }
}

class _SetAdminPasswordState extends State<SetAdminPasswordPage> {
  final _passwordController = TextEditingController();
  final _repeatPasswordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  final _passwordFocus = FocusNode();
  final _repeatPasswordFocus = FocusNode();

  bool _passwordObscured = true;
  bool _repeatPasswordObscured = true;

  @override
  void initState() {
    super.initState();
    _passwordFocus.requestFocus();
  }

  @override
  Widget build(BuildContext context) {
    final texts = AppLocalizations.of(context)!;
    final themeData = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        iconTheme: themeData.appBarTheme.iconTheme,
        backgroundColor: themeData.canvasColor,
        automaticallyImplyLeading: false,
        leading: backBtn.BackButton(),
        title: Text(
          texts.pos_password_admin_title,
          style: themeData.appBarTheme.textTheme!.headline6,
        ),
        elevation: 0.0,
        toolbarTextStyle: themeData.appBarTheme.textTheme!.bodyText2,
        titleTextStyle: themeData.appBarTheme.textTheme!.headline6,
      ),
      body: Padding(
        padding: const EdgeInsets.only(top: 16.0, left: 16.0, right: 16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                focusNode: _passwordFocus,
                obscureText: _passwordObscured,
                textInputAction: TextInputAction.next,
                onFieldSubmitted: (_) {
                  _repeatPasswordFocus.requestFocus();
                },
                validator: (value) {
                  if (value?.isEmpty == true) {
                    return texts.pos_password_admin_error_password_empty;
                  }

                  if (value != null && value.length < 8) {
                    return texts.pos_password_admin_error_password_short;
                  }
                  return null;
                },
                controller: _passwordController,
                decoration: InputDecoration(
                  labelText: texts.pos_password_admin_new_password,
                  suffixIcon: IconButton(
                    icon: const Icon(Icons.remove_red_eye),
                    onPressed: () {
                      setState(() {
                        _passwordObscured = !_passwordObscured;
                      });
                    },
                  ),
                ),
                style: theme.FieldTextStyle.textStyle,
                textCapitalization: TextCapitalization.words,
              ),
              const SizedBox(height: 12.0),
              TextFormField(
                obscureText: _repeatPasswordObscured,
                focusNode: _repeatPasswordFocus,
                textInputAction: TextInputAction.done,
                decoration: InputDecoration(
                  labelText: texts.pos_password_admin_confirm_password,
                  suffixIcon: IconButton(
                    icon: const Icon(Icons.remove_red_eye),
                    onPressed: () {
                      setState(() {
                        _repeatPasswordObscured = !_repeatPasswordObscured;
                      });
                    },
                  ),
                ),
                controller: _repeatPasswordController,
                style: theme.FieldTextStyle.textStyle,
                textCapitalization: TextCapitalization.words,
                onFieldSubmitted: (_) {
                  _formKey.currentState?.validate();
                },
                validator: (value) {
                  if (value != _passwordController.text) {
                    return texts.pos_password_admin_error_password_match;
                  }
                  return null;
                },
              )
            ],
          ),
        ),
      ),
      bottomNavigationBar: SingleButtonBottomBar(
        text: widget.submitAction,
        onPressed: () async {
          if (_formKey.currentState?.validate() == true) {
            await context
                .read<UserProfileBloc>()
                .setAdminPassword(_passwordController.text);
            Navigator.of(context).pop();
          }
        },
      ),
    );
  }
}
