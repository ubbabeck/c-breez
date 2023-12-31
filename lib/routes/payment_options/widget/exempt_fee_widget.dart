import 'dart:async';

import 'package:breez_translations/breez_translations_locales.dart';
import 'package:c_breez/bloc/payment_options/form_validator.dart';
import 'package:c_breez/bloc/payment_options/payment_options_bloc.dart';
import 'package:c_breez/bloc/payment_options/payment_options_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:logging/logging.dart';
import 'package:rxdart/rxdart.dart';

final _log = Logger("ExemptfeeMsatWidget");

class ExemptfeeMsatWidget extends StatefulWidget {
  const ExemptfeeMsatWidget({
    super.key,
  });

  @override
  State<ExemptfeeMsatWidget> createState() => _ExemptfeeMsatState();
}

class _ExemptfeeMsatState extends State<ExemptfeeMsatWidget> {
  final _exemptFeeController = TextEditingController();

  StreamSubscription<PaymentOptionsState>? _subscription;

  @override
  void initState() {
    super.initState();
    SchedulerBinding.instance.addPostFrameCallback((_) => _initializeListeners());
  }

  @override
  void dispose() {
    super.dispose();
    _subscription?.cancel();
  }

  @override
  Widget build(BuildContext context) {
    final texts = context.texts();

    return Row(
      children: [
        Expanded(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16.0, 8.0, 16.0, 8.0),
            child: Form(
              child: BlocBuilder<PaymentOptionsBloc, PaymentOptionsState>(
                builder: (context, state) {
                  return TextFormField(
                    keyboardType: const TextInputType.numberWithOptions(),
                    controller: _exemptFeeController,
                    decoration: InputDecoration(
                      labelText: texts.payment_options_exemptfee_label,
                      border: const UnderlineInputBorder(),
                    ),
                    validator: exemptFeeValidator,
                    onChanged: (value) {
                      _log.info("onChanged: $value");
                      int exemptFeeSat;
                      try {
                        exemptFeeSat = int.parse(value);
                      } catch (_) {
                        _log.info("Failed to parse $value as int");
                        return;
                      }
                      context.read<PaymentOptionsBloc>().setExemptfeeMsat(exemptFeeSat * 1000);
                    },
                  );
                },
              ),
            ),
          ),
        ),
      ],
    );
  }

  void _initializeListeners() {
    final bloc = context.read<PaymentOptionsBloc>();
    _subscription = bloc.stream.startWith(bloc.state).distinct().listen((state) {
      if (!state.saveEnabled) {
        final exemptFeeSat = (state.exemptFeeMsat ~/ 1000).toString();

        if (_exemptFeeController.text != exemptFeeSat) {
          _log.info("Setting exemptFee to $exemptFeeSat");
          setState(() {
            _exemptFeeController.text = exemptFeeSat;
          });
        }
      }
    });
  }
}
