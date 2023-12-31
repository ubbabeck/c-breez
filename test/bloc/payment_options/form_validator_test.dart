import 'package:breez_translations/generated/breez_translations.dart';
import 'package:breez_translations/generated/breez_translations_en.dart';
import 'package:c_breez/bloc/payment_options/form_validator.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('base fee validator', () {
    test('should return payment_options_exemptfee_label  when value is null', () {
      final result = exemptFeeValidator(null);
      expect(result, _texts().payment_options_exemptfee_label);
    });

    test('should return payment_options_exemptfee_label  when value is empty', () {
      final result = exemptFeeValidator('');
      expect(result, _texts().payment_options_exemptfee_label);
    });

    test('should return payment_options_exemptfee_label  when value is negative', () {
      final result = exemptFeeValidator('-1');
      expect(result, _texts().payment_options_exemptfee_label);
    });

    test('should return null when value is valid', () {
      final result = exemptFeeValidator('1');
      expect(result, null);
    });

    test('should return payment_options_exemptfee_label  when value is not a number', () {
      final result = exemptFeeValidator('a');
      expect(result, _texts().payment_options_exemptfee_label);
    });
  });

  group('proportional fee validator', () {
    test('should return payment_options_proportional_fee_label when value is null', () {
      final result = proportionalFeeValidator(null);
      expect(result, _texts().payment_options_proportional_fee_label);
    });

    test('should return payment_options_proportional_fee_label when value is empty', () {
      final result = proportionalFeeValidator('');
      expect(result, _texts().payment_options_proportional_fee_label);
    });

    test('should return payment_options_proportional_fee_label when value is negative', () {
      final result = proportionalFeeValidator('-1');
      expect(result, _texts().payment_options_proportional_fee_label);
    });

    test('should return null when value is valid', () {
      final result = proportionalFeeValidator('1');
      expect(result, null);
    });

    test('should return payment_options_proportional_fee_label when value is not a number', () {
      final result = proportionalFeeValidator('a');
      expect(result, _texts().payment_options_proportional_fee_label);
    });
  });
}

BreezTranslations _texts() => BreezTranslationsEn();
