import 'dart:typed_data';

import 'package:breez_sdk/src/breez_server/generated/breez.pbgrpc.dart';
import 'package:breez_sdk/src/breez_server/server.dart';
import 'package:breez_sdk/src/lsp/models.dart';
import 'package:encrypt/encrypt.dart';
import 'package:grpc/grpc.dart';
import 'package:fixnum/fixnum.dart';
import 'package:hex/hex.dart';

class LSPService {
  Future<Map<String, LSPInfo>> getLSPList(String nodePubkey) async {
    final server = await BreezServer.createWithDefaultConfig();
    var channel = await server.createServerChannel();
    var channelClient = ChannelOpenerClient(channel, options: server.defaultCallOptions);
    var response = await channelClient.lSPList(LSPListRequest()..pubkey = nodePubkey);

    return response.lsps.map((key, value) => MapEntry(
        key,
        LSPInfo(
          lspID: key,
          name: value.name,
          widgetURL: value.widgetUrl,
          pubKey: value.pubkey,
          host: value.host,
          frozen: value.isFrozen,
          minHtlcMsat: value.minHtlcMsat.toInt(),
          targetConf: value.targetConf,
          timeLockDelta: value.timeLockDelta,
          baseFeeMsat: value.baseFeeMsat.toInt(),
          channelCapacity: value.channelCapacity.toInt(),
          channelMinimumFeeMsat: value.channelMinimumFeeMsat.toInt(),
          maxInactiveDuration: value.maxInactiveDuration.toInt(),
          channelFeePermyriad: value.channelFeePermyriad.toInt(),
        )));
  }

  Future registerPayment(
      {required String lspID,
      required String lspPubKey,
      required List<int> paymentHash,
      required List<int> paymentSecret,
      required List<int> destination,
      required Int64 incomingAmountMsat,
      required Int64 outgoingAmountMsat}) async {
    final server = await BreezServer.createWithDefaultConfig();
    var channel = await server.createServerChannel();
    var channelClient = ChannelOpenerClient(channel, options: server.defaultCallOptions);
    final paymentInfo = PaymentInformation(
      paymentHash: paymentHash,
      paymentSecret: paymentSecret,
      destination: destination,
      incomingAmountMsat: incomingAmountMsat,
      outgoingAmountMsat: outgoingAmountMsat,
    );
    final buffer = paymentInfo.writeToBuffer();
    final key = Key(Uint8List.fromList(HEX.decode(lspPubKey)));
    final encrypter = Encrypter(AES(key, mode: AESMode.cbc));
    final encryptedMessage = encrypter.encryptBytes(buffer).bytes;
    
    return channelClient.registerPayment(RegisterPaymentRequest(lspId: lspID, blob: encryptedMessage));
  }

  Future openLSPChannel(String lspID, String pubkey) async {
    final server = await BreezServer.createWithDefaultConfig();
    var channel = await server.createServerChannel();
    var callOptions = server.defaultCallOptions;
    callOptions = callOptions.mergedWith(CallOptions(metadata: {"authorization": "Bearer ${server.openChannelToken}"}));
    var channelClient = PublicChannelOpenerClient(channel, options: callOptions);
    await channelClient.openPublicChannel(OpenPublicChannelRequest(pubkey: pubkey));
  }
}
