import 'dart:convert';

import 'package:c_breez/models/lsp.dart';

enum LSPConnectionStatus {
  notSelected,
  inProgress,
  active,
  notActive
}

class LSPState {
  final List<LSPInfo> availableLSPs;
  final bool initial;
  final String? selectedLSP;
  final LSPConnectionStatus connectionStatus;
  final String? lastConnectionError;

  LSPState({this.availableLSPs=const[], this.connectionStatus=LSPConnectionStatus.notSelected, this.selectedLSP, this.lastConnectionError, this.initial=true});

  LSPState.initial() : this(initial: true);

  LSPState copyWith(
      {List<LSPInfo>? availableLSPs,
      LSPConnectionStatus? connectionStatus,
      String? selectedLSP,
      String? lastConnectionError,
      bool? initial}) {
    return LSPState(availableLSPs: availableLSPs ?? this.availableLSPs, connectionStatus: connectionStatus ?? this.connectionStatus,
        selectedLSP: selectedLSP ?? this.selectedLSP, lastConnectionError: lastConnectionError ?? this.lastConnectionError, initial: initial ?? this.initial);
  }

  factory LSPState.fromJson(Map<String, dynamic> jsonMap) {
    final List lsps = jsonDecode(jsonMap["availableLSPs"]);
    List<LSPInfo> availableLsps = lsps.map((l) => LSPInfo.fromJson(l)).toList();
    return LSPState(availableLSPs: availableLsps, connectionStatus: LSPConnectionStatus.values[jsonMap["connectionStatus"] as int], selectedLSP: jsonMap["selectedLSP"],
        lastConnectionError: jsonMap["lastConnectionError"], initial: jsonMap["initial"]);
  }

  Map<String, dynamic> toJson() {
    return {
      "availableLSPs": jsonEncode(availableLSPs),
      "connectionStatus": connectionStatus.index,
      "selectedLSP": selectedLSP,
      "lastConnectionError": lastConnectionError,
      "initial": initial,
    };
  }

  bool get selectionRequired => selectedLSP == null && availableLSPs.isNotEmpty;

  LSPInfo? get currentLSP {
    try {
      return availableLSPs.firstWhere((element) => element.lspID == selectedLSP);
    } on Exception {
      return null;
    }
  }

  bool get hasLSP => currentLSP != null;
}
