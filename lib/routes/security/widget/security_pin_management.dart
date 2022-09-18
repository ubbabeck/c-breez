import 'dart:io';

import 'package:c_breez/bloc/security/security_bloc.dart';
import 'package:c_breez/bloc/security/security_state.dart';
import 'package:c_breez/l10n/build_context_localizations.dart';
import 'package:c_breez/routes/security/change_pin_page.dart';
import 'package:c_breez/routes/security/widget/local_auth_switch.dart';
import 'package:c_breez/routes/security/widget/security_pin_interval.dart';
import 'package:c_breez/widgets/preview/preview.dart';
import 'package:c_breez/widgets/route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';

class SecurityPinManagement extends StatelessWidget {
  const SecurityPinManagement({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final texts = context.texts();
    final themeData = Theme.of(context);
    final navigator = Navigator.of(context);
    final securityBloc = context.read<SecurityBloc>();

    return BlocBuilder<SecurityBloc, SecurityState>(
      builder: (context, state) {
        if (state.pinStatus == PinStatus.enabled) {
          return Column(
            children: [
              ListTile(
                title: Text(
                  texts.security_and_backup_pin_option_deactivate,
                  style: themeData.primaryTextTheme.titleMedium?.copyWith(
                    color: Colors.white,
                  ),
                  maxLines: 1,
                ),
                trailing: Switch(
                  value: true,
                  activeColor: Colors.white,
                  onChanged: (bool value) {
                    securityBloc.clearPin();
                  },
                ),
              ),
              const Divider(),
              SecurityPinInterval(interval: state.lockInterval),
              const Divider(),
              ListTile(
                title: Text(
                  texts.security_and_backup_change_pin,
                  style: themeData.primaryTextTheme.titleMedium?.copyWith(
                    color: Colors.white,
                  ),
                  maxLines: 1,
                ),
                trailing: const Icon(
                  Icons.keyboard_arrow_right,
                  color: Colors.white,
                  size: 30.0,
                ),
                onTap: () => navigator.push(FadeInRoute(builder: (_) => const ChangePinPage())),
              ),
              const LocalAuthSwitch(),
            ],
          );
        } else {
          return ListTile(
            title: Text(
              texts.security_and_backup_pin_option_create,
              style: themeData.primaryTextTheme.titleMedium?.copyWith(
                color: Colors.white,
              ),
              maxLines: 1,
            ),
            trailing: const Icon(
              Icons.keyboard_arrow_right,
              color: Colors.white,
              size: 30.0,
            ),
            onTap: () => navigator.push(FadeInRoute(builder: (_) => const ChangePinPage())),
          );
        }
      },
    );
  }
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  HydratedBlocOverrides.runZoned(
    () => runApp(MultiBlocProvider(
      providers: [
        BlocProvider<SecurityBloc>(
          create: (BuildContext context) => SecurityBloc(),
        ),
      ],
      child: const Preview([
        SecurityPinManagement(),
      ]),
    )),
    storage: await HydratedStorage.build(
      storageDirectory: Directory(join((await getApplicationDocumentsDirectory()).path, "preview_storage")),
    ),
  );
}