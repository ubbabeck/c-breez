import 'package:c_breez/bloc/account/account_bloc.dart';
import 'package:c_breez/bloc/account/account_state.dart';
import 'package:c_breez/bloc/ext/block_builder_extensions.dart';
import 'package:c_breez/bloc/lsp/lsp_bloc.dart';
import 'package:c_breez/bloc/security/security_bloc.dart';
import 'package:c_breez/bloc/security/security_state.dart';
import 'package:c_breez/bloc/user_profile/user_profile_bloc.dart';
import 'package:c_breez/bloc/user_profile/user_profile_state.dart';
import 'package:c_breez/l10n/locales.dart';
import 'package:c_breez/routes/create_invoice/create_invoice_page.dart';
import 'package:c_breez/routes/dev/commands.dart';
import 'package:c_breez/routes/fiat_currencies/fiat_currency_settings.dart';
import 'package:c_breez/routes/home/home_page.dart';
import 'package:c_breez/routes/initial_walkthrough/initial_walkthrough.dart';
import 'package:c_breez/routes/initial_walkthrough/mnemonics/enter_mnemonic_seed_page.dart';
import 'package:c_breez/routes/initial_walkthrough/mnemonics/generate_mnemonic_seed_confirmation_page.dart';
import 'package:c_breez/routes/lsp/select_lsp_page.dart';
import 'package:c_breez/routes/network/network_page.dart';
import 'package:c_breez/routes/qr_scan/widgets/qr_scan.dart';
import 'package:c_breez/routes/security/lock_screen.dart';
import 'package:c_breez/routes/security/secured_page.dart';
import 'package:c_breez/routes/security/security_page.dart';
import 'package:c_breez/routes/splash/splash_page.dart';
import 'package:c_breez/theme/breez_dark_theme.dart';
import 'package:c_breez/theme/breez_light_theme.dart';
import 'package:c_breez/utils/locale.dart';
import 'package:c_breez/widgets/route.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:theme_provider/theme_provider.dart';

const String THEME_ID_PREFERENCE_KEY = "themeID";

class UserApp extends StatelessWidget {
  final GlobalKey _appKey = GlobalKey();
  final GlobalKey<NavigatorState> _homeNavigatorKey = GlobalKey<NavigatorState>();

  @override
  Widget build(BuildContext context) {
    final accountBloc = context.read<AccountBloc>();
    final userProfileBloc = context.read<UserProfileBloc>();
    final lspBloc = context.read<LSPBloc>();

    return ThemeProvider(
      saveThemesOnChange: true,
      onInitCallback: (controller, previouslySavedThemeFuture) async {
        String? savedTheme = await previouslySavedThemeFuture;
        if (savedTheme != null) {
          controller.setTheme(savedTheme);
        } else {
          controller.setTheme('light');
          controller.forgetSavedTheme();
        }
      },
      themes: <AppTheme>[
        AppTheme(
          id: 'light',
          data: breezLightTheme,
          description: 'Blue Theme',
        ),
        AppTheme(
          id: 'dark',
          data: breezDarkTheme,
          description: 'Dark Theme',
        ),
      ],
      child: ThemeConsumer(
        child: BlocBuilder<UserProfileBloc, UserProfileState>(
          builder: (context, state) {
            SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
              statusBarColor: Colors.transparent,
            ));
            return BlocBuilder2<AccountBloc, AccountState, SecurityBloc,
                SecurityState>(builder: (context, accState, securityState) {
              return MaterialApp(
                key: _appKey,
                title: getSystemAppLocalizations().app_name,
                theme: ThemeProvider.themeOf(context).data,
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
                initialRoute: securityState.pinStatus == PinStatus.enabled
                    ? "lockscreen"
                    : "splash",
                onGenerateRoute: (RouteSettings settings) {
                  switch (settings.name) {
                    case '/intro':
                      return FadeInRoute(
                        builder: (_) => InitialWalkthroughPage(),
                        settings: settings,
                      );
                    case 'splash':
                      return FadeInRoute(
                        builder: (_) => const SplashPage(),
                        settings: settings,
                      );
                    case 'lockscreen':
                      return NoTransitionRoute(
                        builder: (_) => const LockScreen(
                          authorizedAction: AuthorizedAction.launchHome,
                        ),
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
                            return !await _homeNavigatorKey.currentState!.maybePop();
                          },
                          child: Navigator(
                            initialRoute: "/",
                            key: _homeNavigatorKey,
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
                                    builder: (_) =>
                                        SelectLSPPage(lstBloc: lspBloc),
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
                                case '/security':
                                  return FadeInRoute(
                                    builder: (_) => const SecuredPage(
                                      securedWidget: SecurityPage(),
                                    ),
                                    settings: settings,
                                  );
                                case '/network':
                                  return FadeInRoute(
                                    builder: (_) => const NetworkPage(),
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
        ),
      ),
    );
  }
}
