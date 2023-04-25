import 'package:fimber/fimber.dart';
import 'package:shared_preferences/shared_preferences.dart';

const kDefaultOverrideFee = false;
const kDefaultProportionalFee = 1.0;

const _mempoolSpaceUrlKey = "mempool_space_url";
const _kPaymentOptionOverrideFee = "payment_options_override_fee";
const _kPaymentOptionProportionalFee = "payment_options_proportional_fee";

final _log = FimberLog("preferences");

class Preferences {
  Future<String?> getMempoolSpaceUrl() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_mempoolSpaceUrlKey);
  }

  Future<void> setMempoolSpaceUrl(String url) async {
    _log.d("set mempool space url: $url");
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_mempoolSpaceUrlKey, url);
  }

  Future<void> resetMempoolSpaceUrl() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_mempoolSpaceUrlKey);
  }

  Future<bool> getPaymentOptionsOverrideFeeEnabled() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_kPaymentOptionOverrideFee) ?? kDefaultOverrideFee;
  }

  Future<void> setPaymentOptionsOverrideFeeEnabled(bool enabled) async {
    _log.d("set payment options override fee enabled: $enabled");
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_kPaymentOptionOverrideFee, enabled);
  }

  Future<double> getPaymentOptionsProportionalFee() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getDouble(_kPaymentOptionProportionalFee) ?? kDefaultProportionalFee;
  }

  Future<void> setPaymentOptionsProportionalFee(double fee) async {
    _log.d("set payment options proportional fee: $fee");
    final prefs = await SharedPreferences.getInstance();
    await prefs.setDouble(_kPaymentOptionProportionalFee, fee);
  }
}
