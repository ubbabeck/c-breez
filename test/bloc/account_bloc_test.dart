@Timeout(Duration(seconds: 400))
import 'package:c_breez/bloc/account/account_bloc.dart';
import 'package:c_breez/bloc/account/account_state.dart';
import 'package:drift/drift.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:bip39/bip39.dart' as bip39;
import 'package:fixnum/fixnum.dart';
import 'package:hex/hex.dart';
import '../mocks.dart';

var testSeed = '0c56b71ef51d393ecd55cbd22779ada82705d15bb583e7c6a4a20482a986e35031544c88f408b32fd0dd7604c0e8ced8c1595143a2da58dc0704effd58b80680';

void main() {
  group('account', () {
    test('recover node', () async {
      var injector = InjectorMock();
      AccountBloc accBloc = AccountBloc(injector.breezBridge, injector.appStorage, injector.keychain);      
      var seed = bip39.mnemonicToSeed(bip39.generateMnemonic()); 
      print(HEX.encode(seed));

      var creds = await accBloc.recoverNode(Uint8List.fromList(HEX.decode(testSeed)));      
      await accBloc.syncStateWithNode();
      var accountState = accBloc.state;
      expect(accountState.blockheight, greaterThan(1));
      expect(accountState.id?.length, equals(66));
      expect(accountState.balance, Int64(0));
      expect(accountState.walletBalance,Int64(0));
      expect(accountState.status, AccountStatus.DISCONNECTED);
      expect(accountState.maxAllowedToPay, Int64(0));
      expect(accountState.maxAllowedToReceive, Int64(0));
      expect(accountState.maxPaymentAmount, Int64(4294967));
      expect(accountState.maxChanReserve, Int64(0));
      expect(accountState.maxInboundLiquidity, Int64(0));
      expect(accountState.onChainFeeRate, Int64(0));
      expect(accountState.payments.paymentsList.length, 0);      
    });
  });
}
