import 'dart:io';

import 'package:archive/archive_io.dart';
import 'package:breez_translations/breez_translations_locales.dart';
import 'package:c_breez/bloc/account/account_bloc.dart';
import 'package:c_breez/config.dart';
import 'package:c_breez/logger.dart';
import 'package:c_breez/routes/dev/command_line_interface.dart';
import 'package:c_breez/routes/ui_test/ui_test_page.dart';
import 'package:c_breez/widgets/back_button.dart' as back_button;
import 'package:c_breez/widgets/flushbar.dart';
import 'package:c_breez/widgets/route.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';

bool allowRebroadcastRefunds = false;

class Choice {
  const Choice({
    required this.title,
    required this.icon,
    required this.function,
  });

  final String title;
  final IconData icon;
  final Function(BuildContext context) function;
}

class DevelopersView extends StatelessWidget {
  const DevelopersView({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
    final themeData = Theme.of(context);

    return Scaffold(
      key: scaffoldKey,
      appBar: AppBar(
        leading: const back_button.BackButton(),
        actions: [
          PopupMenuButton<Choice>(
            onSelected: (c) => c.function(context),
            color: themeData.colorScheme.background,
            icon: Icon(
              Icons.more_vert,
              color: themeData.iconTheme.color,
            ),
            itemBuilder: (context) => [
              if (kDebugMode)
                Choice(
                  title: "Export Keys",
                  icon: Icons.phone_android,
                  function: _exportKeys,
                ),
              Choice(
                title: "Test UI Widgets",
                icon: Icons.phone_android,
                function: (_) => Navigator.push(
                  context,
                  FadeInRoute(
                    builder: (_) => const UITestPage(),
                  ),
                ),
              ),
              Choice(
                title: "Share Logs",
                icon: Icons.share,
                function: (_) => shareLog(),
              ),
              Choice(
                  title: "Export static backup", icon: Icons.charging_station, function: _exportStaticBackup)
            ]
                .map((choice) => PopupMenuItem<Choice>(
                      value: choice,
                      child: Text(
                        choice.title,
                        style: themeData.textTheme.labelLarge,
                      ),
                    ))
                .toList(),
          ),
        ],
        title: const Text("Developers"),
      ),
      body: CommandLineInterface(scaffoldKey: scaffoldKey),
    );
  }

  void _exportKeys(BuildContext context) async {
    final accBloc = context.read<AccountBloc>();
    final appDir = await getApplicationDocumentsDirectory();
    final encoder = ZipFileEncoder();
    final zipFilePath = "${appDir.path}/c-breez-keys.zip";
    encoder.create(zipFilePath);
    final List<File> credentialFiles = await accBloc.exportCredentialFiles();
    for (var credentialFile in credentialFiles) {
      final bytes = await credentialFile.readAsBytes();
      encoder.addArchiveFile(
        ArchiveFile(basename(credentialFile.path), bytes.length, bytes),
      );
    }
    final storageFilePath = "${appDir.path}/storage.sql";
    final storageFile = File(storageFilePath);
    encoder.addFile(storageFile);
    encoder.close();
    final zipFile = XFile(zipFilePath);
    Share.shareXFiles([zipFile]);
  }

  void _exportStaticBackup(BuildContext context) async {
    final texts = getSystemAppLocalizations();
    final accBloc = context.read<AccountBloc>();
    const name = "scb.recover";
    final staticBackup = await accBloc.exportStaticChannelBackup();

    if (staticBackup.backup != null) {
      final backup = staticBackup.backup;

      final emergencyList = backup!.toString();

      Config config = await Config.instance();
      String workingDir = config.sdkConfig.workingDir;
      String filePath = '$workingDir/$name';
      File file = File(filePath);
      await file.writeAsString(emergencyList, flush: true);
      final storageFile = XFile(filePath);
      Share.shareXFiles([storageFile]);
    } else {
      // ignore: use_build_context_synchronously
      showFlushbar(context, title: texts.backup_export_static_error_data_missing);
    }
  }
}
