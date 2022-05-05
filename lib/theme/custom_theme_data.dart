import 'package:flutter/material.dart';

import 'breez_colors.dart';

class CustomData {
  BlendMode loaderColorBlendMode;
  String loaderAssetPath;
  Color pendingTextColor;
  Color dashboardBgColor;
  Color paymentListBgColor;
  Color paymentListDividerColor;
  Color navigationDrawerHeaderBgColor;
  Color navigationDrawerBgColor;

  CustomData(
      {required this.loaderColorBlendMode,
      required this.loaderAssetPath,
      required this.pendingTextColor,
      required this.dashboardBgColor,
      required this.paymentListBgColor,
      required this.paymentListDividerColor,
      required this.navigationDrawerHeaderBgColor,
      required this.navigationDrawerBgColor});
}

final CustomData blueThemeCustomData = CustomData(
  loaderColorBlendMode: BlendMode.multiply,
  loaderAssetPath: 'src/images/breez_loader_blue.gif',
  dashboardBgColor: Colors.white,
  pendingTextColor: const Color(0xff4D88EC),
  paymentListBgColor: const Color(0xFFf9f9f9),
  paymentListDividerColor: const Color.fromRGBO(0, 0, 0, 0.12),
  navigationDrawerBgColor: BreezColors.blue[500]!,
  navigationDrawerHeaderBgColor: const Color.fromRGBO(0, 103, 255, 1),
);

final CustomData darkThemeCustomData = CustomData(
  loaderColorBlendMode: BlendMode.srcIn,
  loaderAssetPath: 'src/images/breez_loader_dark.gif',
  pendingTextColor: const Color(0xFF0085fb),
  dashboardBgColor: const Color(0xFF0D1F33),
  paymentListBgColor: const Color(0xFF152a3d),
  paymentListDividerColor: const Color.fromRGBO(255, 255, 255, 0.12),
  navigationDrawerBgColor: const Color(0xFF152a3d),
  navigationDrawerHeaderBgColor: const Color.fromRGBO(13, 32, 50, 1),
);

final Map<String, CustomData> customData = {
  "BLUE": blueThemeCustomData,
  "DARK": darkThemeCustomData
};
