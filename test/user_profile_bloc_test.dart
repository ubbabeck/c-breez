// ignore_for_file: avoid_print, unused_local_variable
import 'package:c_breez/bloc/user_profile/user_profile_bloc.dart';
import 'package:c_breez/services/injector.dart';
import 'package:test/test.dart';

import 'mock/injector_mock.dart';

void main() {
  group('breez_user_model_tests', () {
    InjectorMock injector = InjectorMock();
    UserProfileBloc userProfileBloc;

    setUp(() async {
      ServiceInjector.configure(injector);
      userProfileBloc =
          UserProfileBloc(injector.breezServer, injector.notifications);
    });

    test("should return empty user when not registered", () async {});

    test("should return registered user", () async {});
  });
}
