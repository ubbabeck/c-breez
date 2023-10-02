import 'package:breez_translations/breez_translations_locales.dart';
import 'package:c_breez/bloc/withdraw/withdraw_funds_state.dart';
import 'package:c_breez/routes/withdraw/widgets/fee_chooser/widgets/fee_option_button.dart';
import 'package:flutter/material.dart';

class FeeChooserHeader extends StatefulWidget {
  final int walletBalance;
  final List<FeeOption> feeOptions;
  final int selectedFeeIndex;
  final Function(int) onSelect;

  const FeeChooserHeader({
    required this.walletBalance,
    required this.feeOptions,
    required this.selectedFeeIndex,
    required this.onSelect,
    Key? key,
  }) : super(key: key);

  @override
  State<FeeChooserHeader> createState() => _FeeChooserHeaderState();
}

class _FeeChooserHeaderState extends State<FeeChooserHeader> {
  late List<FeeOptionButton> feeOptionButtons;

  @override
  Widget build(BuildContext context) {
    final texts = context.texts();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          mainAxisSize: MainAxisSize.max,
          children: List<FeeOptionButton>.generate(
            widget.feeOptions.length,
            (index) => FeeOptionButton(
              index: index,
              text: widget.feeOptions.elementAt(index).getDisplayName(texts),
              isAffordable: widget.feeOptions.elementAt(index).isAffordable(widget.walletBalance),
              isSelected: widget.selectedFeeIndex == index,
              onSelect: () => widget.onSelect(index),
            ),
          ),
        ),
      ],
    );
  }
}
