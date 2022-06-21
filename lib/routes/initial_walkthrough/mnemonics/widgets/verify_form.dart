import 'package:c_breez/l10n/build_context_localizations.dart';
import 'package:c_breez/theme/theme_provider.dart' as theme;
import 'package:flutter/material.dart';

class VerifyForm extends StatefulWidget {
  final GlobalKey<FormState> formKey;
  final List<String> mnemonicsList;
  final List randomlySelectedIndexes;
  final VoidCallback onError;

  const VerifyForm({
    required this.formKey,
    required this.mnemonicsList,
    required this.randomlySelectedIndexes,
    required this.onError,
  });

  @override
  VerifyFormPageState createState() => VerifyFormPageState();
}

class VerifyFormPageState extends State<VerifyForm> {
  @override
  Widget build(BuildContext context) {
    final texts = context.texts();
    return Form(
      key: widget.formKey,
      onChanged: () => widget.formKey.currentState?.save(),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16.0, 24.0, 16.0, 40.0),
        child: Column(
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: List.generate(
            widget.randomlySelectedIndexes.length,
            (index) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 16),
                child: TextFormField(
                  decoration: InputDecoration(
                    labelText: texts.backup_phrase_generation_type_step(
                      widget.randomlySelectedIndexes[index] + 1,
                    ),
                  ),
                  style: theme.FieldTextStyle.textStyle,
                  validator: (text) {
                    if (text!.isEmpty ||
                        text.toLowerCase().trim() !=
                            widget.mnemonicsList[
                                widget.randomlySelectedIndexes[index]]) {
                      widget.onError();
                    }
                    return null;
                  },
                  onEditingComplete: () => (index == 2)
                      ? FocusScope.of(context).unfocus()
                      : FocusScope.of(context).nextFocus(),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
