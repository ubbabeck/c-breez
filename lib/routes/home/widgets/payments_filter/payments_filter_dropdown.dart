import 'package:c_breez/l10n/build_context_localizations.dart';
import 'package:c_breez/theme/theme_provider.dart' as theme;
import 'package:flutter/material.dart';

class PaymentsFilterDropdown extends StatelessWidget {
  final String filter;
  final ValueChanged<Object?> onFilterChanged;

  const PaymentsFilterDropdown(
    this.filter,
    this.onFilterChanged, {
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final texts = context.texts();
    final themeData = Theme.of(context);
    final foregroundColor = theme.themeId == "BLUE"
        ? Colors.black
        : themeData.colorScheme.onSecondary;

    return Theme(
      data: themeData.copyWith(
        canvasColor: theme.customData[theme.themeId]!.paymentListBgColor,
      ),
      child: DropdownButtonHideUnderline(
        child: ButtonTheme(
          alignedDropdown: true,
          child: DropdownButton(
            value: filter,
            iconEnabledColor: foregroundColor,
            style: themeData.textTheme.subtitle2?.copyWith(
              color: foregroundColor,
            ),
            items: [
              texts.payments_filter_option_all,
              texts.payments_filter_option_sent,
              texts.payments_filter_option_received,
            ].map((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Material(
                  child: Text(
                    value,
                    style: themeData.textTheme.subtitle2?.copyWith(
                      color: foregroundColor,
                    ),
                  ),
                ),
              );
            }).toList(),
            onChanged: (item) => onFilterChanged(item),
          ),
        ),
      ),
    );
  }
}
