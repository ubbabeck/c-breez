import 'dart:typed_data';

import 'package:c_breez/bloc/account/account_bloc.dart';
import 'package:c_breez/bloc/account/account_state.dart';
import 'package:c_breez/bloc/lsp/lsp_bloc.dart';
import 'package:c_breez/bloc/user_profile/user_profile_bloc.dart';
import 'package:c_breez/bloc/user_profile/user_profile_state.dart';
import 'package:c_breez/l10n/locales.dart';
import 'package:c_breez/models/user_profile.dart';
import 'package:c_breez/routes/create_invoice/create_invoice_page.dart';
import 'package:c_breez/routes/dev/commands.dart';
import 'package:c_breez/routes/fiat_currencies/fiat_currency_settings.dart';
import 'package:c_breez/routes/home/home_page.dart';
import 'package:c_breez/routes/initial_walkthrough/initial_walkthrough.dart';
import 'package:c_breez/routes/initial_walkthrough/mnemonics/enter_mnemonic_seed_page.dart';
import 'package:c_breez/routes/initial_walkthrough/mnemonics/generate_mnemonic_seed_confirmation_page.dart';
import 'package:c_breez/routes/lsp/select_lsp_page.dart';
import 'package:c_breez/routes/qr_scan/widgets/qr_scan.dart';
import 'package:c_breez/routes/splash/splash_page.dart';
import 'package:c_breez/routes/withdraw_funds/withdraw_funds_address_page.dart';
import 'package:c_breez/routes/withdraw_funds/withdraw_funds_amount_page.dart';
import 'package:c_breez/theme/theme_provider.dart' as theme;
import 'package:c_breez/utils/locale.dart';
import 'package:c_breez/widgets/route.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class UserApp extends StatelessWidget {
  final GlobalKey _appKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    final accountBloc = context.read<AccountBloc>();
    final userProfileBloc = context.read<UserProfileBloc>();
    final lspBloc = context.read<LSPBloc>();

    return BlocBuilder<UserProfileBloc, UserProfileState>(
      builder: (context, state) {
        UserProfileSettings user = state.profileSettings;
        theme.themeId = user.themeId;
        SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
        ));
        return BlocBuilder<AccountBloc, AccountState>(
            builder: (context, accState) {
          return MaterialApp(
            key: _appKey,
            title: getSystemAppLocalizations().app_name,
            theme: theme.themeMap[user.themeId],
            localizationsDelegates: localizationsDelegates(),
            supportedLocales: supportedLocales(),
            builder: (BuildContext context, Widget? child) {
              final MediaQueryData data = MediaQuery.of(context);
              return MediaQuery(
                data: data.copyWith(
                  textScaleFactor: (data.textScaleFactor >= 1.3)
                      ? 1.3
                      : data.textScaleFactor,
                ),
                child: child!,
              );
            },
            initialRoute: "/splash",
            onGenerateRoute: (RouteSettings settings) {
              switch (settings.name) {
                case '/intro':
                  return FadeInRoute(
                    builder: (_) => InitialWalkthroughPage(),
                    settings: settings,
                  );
                case '/splash':
                  return FadeInRoute(
                    builder: (_) => const SplashPage(),
                    settings: settings,
                  );
                case '/mnemonics':
                  return FadeInRoute(
                    builder: (_) => GenerateMnemonicSeedConfirmationPage(),
                    settings: settings,
                  );
                case '/enter_mnemonic_seed':
                  return FadeInRoute<Uint8List>(
                    builder: (_) => EnterMnemonicSeedPage(),
                    settings: settings,
                  );
                case '/':
                  return FadeInRoute(
                    builder: (_) => WillPopScope(
                      onWillPop: () async {
                        return true;
                      },
                      child: Navigator(
                        initialRoute: "/",
                        onGenerateRoute: (RouteSettings settings) {
                          switch (settings.name) {
                            case '/':
                              return FadeInRoute(
                                builder: (_) => const Home(),
                                settings: settings,
                              );
                            case '/select_lsp':
                              return MaterialPageRoute(
                                fullscreenDialog: true,
                                builder: (_) => SelectLSPPage(lstBloc: lspBloc),
                                settings: settings,
                              );
                            case '/create_invoice':
                              return FadeInRoute(
                                builder: (_) => const CreateInvoicePage(),
                                settings: settings,
                              );
                            case '/fiat_currency':
                              return FadeInRoute(
                                builder: (_) => FiatCurrencySettings(
                                  accountBloc,
                                  userProfileBloc,
                                ),
                                settings: settings,
                              );
                            case '/developers':
                              return FadeInRoute(
                                builder: (_) => const DevelopersView(),
                                settings: settings,
                              );
                            case '/qr_scan':
                              return MaterialPageRoute<String>(
                                fullscreenDialog: true,
                                builder: (_) => QRScan(),
                                settings: settings,
                              );
                            case '/withdraw_funds_address':
                              return FadeInRoute(
                                builder: (_) =>
                                    const WithdrawFundsAddressPage(),
                                settings: settings,
                              );
                            case '/withdraw_funds_amount':
                              return FadeInRoute(
                                builder: (_) => WithdrawFundsAmountPage(
                                  settings.arguments as String,
                                ),
                                settings: settings,
                              );
                          }
                          assert(false);
                          return null;
                        },
                      ),
                    ),
                    settings: settings,
                  );
              }
              assert(false);
              return null;
            },
          );
        });
      },
    );
  }
}
