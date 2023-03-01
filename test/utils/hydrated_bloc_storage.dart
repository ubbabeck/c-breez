import 'dart:io';

import 'package:flutter/material.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';

class HydratedBlocStorage {
  final basePath = "${Directory.current.path}/.dart_tool/hydrated_bloc/${DateTime.now().millisecondsSinceEpoch}";

  Future<void> setUpHydratedBloc() async {
    WidgetsFlutterBinding.ensureInitialized();
    HydratedBloc.storage = await HydratedStorage.build(
      storageDirectory: Directory(basePath),
    );
  }

  Future<void> tearDownHydratedBloc() async {
    await HydratedBloc.storage.clear();
    Directory(basePath).deleteSync(recursive: true);
  }
}
