// ignore_for_file: avoid_print
import 'package:bip39/bip39.dart' as bip39;
import 'package:breez_sdk/breez_sdk.dart';
import 'package:c_breez/bloc/account/credentials_manager.dart';
import 'package:c_breez/config.dart';
import 'package:c_breez/services/injector.dart';

Future<BreezSDK> initializeBreezServices() async {
  final injector = ServiceInjector();
  final breezSDK = injector.breezSDK;
  final bool isBreezInitialized = await breezSDK.isInitialized();
  print("Is Breez Services initialized: $isBreezInitialized");
  if (!isBreezInitialized) {
    final credentialsManager = CredentialsManager(keyChain: injector.keychain);
    final mnemonic = await credentialsManager.restoreMnemonic();
    final seed = bip39.mnemonicToSeed(mnemonic);
    print("Retrieved credentials");
    await breezSDK.connect(config: (await Config.instance()).sdkConfig, seed: seed);
    print("Initialized Services");
    print("Node has started");
  }
  await breezSDK.sync();
  print("Node has synchronized");
  return breezSDK;
}
