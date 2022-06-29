import 'package:dart_lnurl/dart_lnurl.dart';

import '../bridge_generated.dart';
import 'native_toolkit.dart';

class InputParser {
  final LightningToolkit _lnToolkit = getNativeToolkit();
  static RegExp lnurlPrefix = RegExp(",*?((lnurl)([0-9]{1,}[a-z0-9]+){1})");
  static RegExp lnurlRfc17Prefix = RegExp("(lnurl)(c|w|p)");

  Future<ParsedInput> parse(String s) async {
    // lnurl
    String lower = s.toLowerCase();
    try {
      LNURLParseResult parseResult = await getParams(lower);
      if (parseResult.payParams != null ||
          parseResult.withdrawalParams != null) {
        return ParsedInput(InputProtocol.lnurl, parseResult);
      }
    } catch (error) {
      // do nothing
    }

    // lightning link
    if (lower.startsWith('lightning:')) {
      final invoice = await _lnToolkit.parseInvoice(invoice: s.substring(10));
      return ParsedInput(InputProtocol.paymentRequest, invoice);
    }

    // bolt 11 lightning
    String? bolt11 = _extractBolt11FromBip21(lower);
    if (bolt11 != null) {
      final invoice = await _lnToolkit.parseInvoice(invoice: bolt11);
      return ParsedInput(InputProtocol.paymentRequest, invoice);
    }
    try {
      final invoice = await _lnToolkit.parseInvoice(invoice: lower);
      return ParsedInput(InputProtocol.paymentRequest, invoice);
    } catch (e) {
      // do nothing
    }
    throw Exception("not implemented");
  }
}

String? _extractBolt11FromBip21(String bip21) {
  String lowerBip21 = bip21.toLowerCase();
  if (lowerBip21.startsWith("bitcoin:")) {
    try {
      Uri uri = Uri.parse(lowerBip21);
      String? bolt11 = uri.queryParameters["lightning"];
      if (bolt11 != null && bolt11.isNotEmpty) {
        return bolt11;
      }
    } on FormatException {
      // do nothing.
    }
  }
  return null;
}

enum InputProtocol { paymentRequest, lnurl }

class ParsedInput {
  final InputProtocol protocol;
  final dynamic decoded;

  ParsedInput(this.protocol, this.decoded);
}