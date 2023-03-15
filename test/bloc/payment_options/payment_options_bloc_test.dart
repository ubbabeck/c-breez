import 'package:c_breez/bloc/payment_options/payment_options_bloc.dart';
import 'package:c_breez/bloc/payment_options/payment_options_state.dart';
import 'package:c_breez/services/injector.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:path_provider_platform_interface/path_provider_platform_interface.dart';

import '../../mock/injector_mock.dart';
import '../../unit_logger.dart';
import '../../utils/fake_path_provider_platform.dart';
import '../../utils/hydrated_bloc_storage.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  final platform = FakePathProviderPlatform();
  final hydratedBlocStorage = HydratedBlocStorage();
  late InjectorMock injector;
  setUpLogger();

  setUp(() async {
    injector = InjectorMock();
    ServiceInjector.configure(injector);
    await platform.setUp();
    PathProviderPlatform.instance = platform;
    await hydratedBlocStorage.setUpHydratedBloc();
  });

  tearDown(() async {
    await platform.tearDown();
    await hydratedBlocStorage.tearDownHydratedBloc();
  });

  PaymentOptionsBloc make() => PaymentOptionsBloc(
        injector.preferences,
      );

  test('initial state should use defaults', () async {
    final bloc = make();
    expectLater(
      bloc.stream,
      emitsInOrder([
        const PaymentOptionsState.initial(),
      ]),
    );
  });

  test('should emit new state when override fee enabled', () async {
    final bloc = make();
    expectLater(
      bloc.stream,
      emitsInOrder([
        const PaymentOptionsState.initial(),
        const PaymentOptionsState(overrideFeeEnabled: true, saveEnabled: true),
        const PaymentOptionsState(overrideFeeEnabled: true),
      ]),
    );
    // Delay to allow the bloc to initialize
    await Future.delayed(const Duration(milliseconds: 1));
    await bloc.setOverrideFeeEnabled(true);
    await bloc.saveFees();
    expect(injector.preferencesMock.setPaymentOptionsOverrideFeeEnabledCalled, 1);
  });

  test('should emit new state when base fee changed', () async {
    final bloc = make();
    expectLater(
      bloc.stream,
      emitsInOrder([
        const PaymentOptionsState.initial(),
        const PaymentOptionsState(baseFee: 100, saveEnabled: true),
        const PaymentOptionsState(baseFee: 100),
      ]),
    );
    // Delay to allow the bloc to initialize
    await Future.delayed(const Duration(milliseconds: 1));
    await bloc.setBaseFee(100);
    await bloc.saveFees();
    expect(injector.preferencesMock.setPaymentOptionsBaseFeeCalled, 1);
  });

  test('should emit new state when proportional fee changed', () async {
    final bloc = make();
    expectLater(
      bloc.stream,
      emitsInOrder([
        const PaymentOptionsState.initial(),
        const PaymentOptionsState(proportionalFee: 0.01, saveEnabled: true),
        const PaymentOptionsState(proportionalFee: 0.01),
      ]),
    );
    // Delay to allow the bloc to initialize
    await Future.delayed(const Duration(milliseconds: 1));
    await bloc.setProportionalFee(0.01);
    await bloc.saveFees();
    expect(injector.preferencesMock.setPaymentOptionsProportionalFeeCalled, 1);
  });

  test('should emit new state when reset fees', () async {
    final bloc = make();
    expectLater(
      bloc.stream,
      emitsInOrder([
        const PaymentOptionsState.initial(),
        const PaymentOptionsState.initial().copyWith(
          overrideFeeEnabled: true,
          saveEnabled: true,
        ),
        const PaymentOptionsState.initial().copyWith(
          overrideFeeEnabled: true,
          baseFee: 100,
          saveEnabled: true,
        ),
        const PaymentOptionsState.initial().copyWith(
          overrideFeeEnabled: true,
          baseFee: 100,
          proportionalFee: 0.01,
          saveEnabled: true,
        ),
        const PaymentOptionsState.initial().copyWith(
          overrideFeeEnabled: true,
          baseFee: 100,
          proportionalFee: 0.01,
        ),
        const PaymentOptionsState.initial(),
      ]),
    );
    // Delay to allow the bloc to initialize
    await Future.delayed(const Duration(milliseconds: 1));
    await bloc.setOverrideFeeEnabled(true);
    await bloc.setBaseFee(100);
    await bloc.setProportionalFee(0.01);
    await bloc.saveFees();
    await bloc.resetFees();
    expect(injector.preferencesMock.setPaymentOptionsOverrideFeeEnabledCalled, 2);
    expect(injector.preferencesMock.setPaymentOptionsBaseFeeCalled, 2);
    expect(injector.preferencesMock.setPaymentOptionsProportionalFeeCalled, 2);
  });

  test('cancel editing should clear the unsaved state', () async {
    final bloc = make();
    expectLater(
      bloc.stream,
      emitsInOrder([
        const PaymentOptionsState.initial(),
        const PaymentOptionsState.initial().copyWith(
          overrideFeeEnabled: true,
          saveEnabled: true,
        ),
        const PaymentOptionsState.initial().copyWith(
          overrideFeeEnabled: true,
          baseFee: 100,
          saveEnabled: true,
        ),
        const PaymentOptionsState.initial().copyWith(
          overrideFeeEnabled: true,
          baseFee: 100,
          proportionalFee: 0.01,
          saveEnabled: true,
        ),
        const PaymentOptionsState.initial(),
      ]),
    );
    // Delay to allow the bloc to initialize
    await Future.delayed(const Duration(milliseconds: 1));
    await bloc.setOverrideFeeEnabled(true);
    await bloc.setBaseFee(100);
    await bloc.setProportionalFee(0.01);
    await bloc.cancelEditing();
    // Delay to allow the fetch to complete
    await Future.delayed(const Duration(milliseconds: 1));
    expect(injector.preferencesMock.setPaymentOptionsOverrideFeeEnabledCalled, 0);
    expect(injector.preferencesMock.setPaymentOptionsBaseFeeCalled, 0);
    expect(injector.preferencesMock.setPaymentOptionsProportionalFeeCalled, 0);
  });
}
