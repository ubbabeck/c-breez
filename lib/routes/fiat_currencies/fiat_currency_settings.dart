
import 'package:c_breez/bloc/account/account_bloc.dart';
import 'package:c_breez/bloc/currency/currency_bloc.dart';
import 'package:c_breez/bloc/currency/currency_state.dart';
import 'package:c_breez/bloc/user_profile/user_profile_bloc.dart';
import 'package:c_breez/models/currency.dart';
import 'package:c_breez/theme_data.dart' as theme;
import 'package:c_breez/widgets/back_button.dart' as backBtn;
import 'package:c_breez/widgets/loader.dart';
import 'package:drag_and_drop_lists/drag_and_drop_lists.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

const double ITEM_HEIGHT = 72.0;

class FiatCurrencySettings extends StatefulWidget {
  final AccountBloc accountBloc;
  final UserProfileBloc userProfileBloc;

  const FiatCurrencySettings(
    this.accountBloc,
    this.userProfileBloc,
  );

  @override
  FiatCurrencySettingsState createState() {
    return FiatCurrencySettingsState();
  }
}

class FiatCurrencySettingsState extends State<FiatCurrencySettings> {
  final _scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    final themeData = Theme.of(context);
    final texts = AppLocalizations.of(context)!;

    return BlocBuilder<CurrencyBoc, CurrencyState>(
      buildWhen: (s1, s2) => !listEquals(s1.preferredCurrencies, s2.preferredCurrencies),      
      builder: (context, currencyState) {        
        if (currencyState.fiatCurrenciesData.isEmpty ||
            currencyState.fiatCurrency == null) {
          return const Loader();
        }

        return Scaffold(
          appBar: AppBar(
            iconTheme: themeData.appBarTheme.iconTheme,
            backgroundColor: themeData.canvasColor,
            leading: const backBtn.BackButton(),
            title: Text(
              texts.fiat_currencies_title,
              style: themeData.appBarTheme.titleTextStyle,
            ),
            elevation: 0.0, toolbarTextStyle: themeData.appBarTheme.toolbarTextStyle, 
            titleTextStyle: themeData.appBarTheme.titleTextStyle,
          ),
          body: DragAndDropLists(
            listPadding: EdgeInsets.zero,
            children: [
              _buildList(context, currencyState),
            ],
            lastListTargetSize: 0,
            lastItemTargetHeight: 8,
            scrollController: _scrollController,
            onListReorder: (oldListIndex, newListIndex) => null,
            onItemReorder: (from, oldListIndex, to, newListIndex) =>
                _onReorder(context, currencyState, from, to),
            itemDragHandle: DragHandle(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Icon(
                  Icons.drag_handle,
                  color: theme.BreezColors.white[200],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  DragAndDropList _buildList(
    BuildContext context,
    CurrencyState currencyState,
  ) {
    return DragAndDropList(
      header: const SizedBox(),
      canDrag: false,
      children: List.generate(currencyState.fiatCurrenciesData.length, (index) {
        return DragAndDropItem(
          child: _buildFiatCurrencyTile(context, currencyState, index),
          canDrag: currencyState.preferredCurrencies.contains(
            currencyState.fiatCurrenciesData[index].shortName,
          ),
        );
      }),
    );
  }

  Widget _buildFiatCurrencyTile(
    BuildContext context,
    CurrencyState currencyState,
    int index,
  ) {
    final texts = AppLocalizations.of(context)!;
    final themeData = Theme.of(context);

    final currencyData = currencyState.fiatCurrenciesData[index];    
    final prefCurrencies = currencyState.preferredCurrencies.toList();

    return CheckboxListTile(
      key: Key("tile-index-$index"),
      controlAffinity: ListTileControlAffinity.leading,
      activeColor: Colors.white,
      checkColor: themeData.canvasColor,
      value: prefCurrencies.contains(currencyData.shortName),
      onChanged: (bool? checked) {
        setState(() {
          if (checked == true) {
            prefCurrencies.add(currencyData.shortName);
            // center item in viewport
            if (_scrollController.offset >=
                (ITEM_HEIGHT * (prefCurrencies.length - 1))) {
              _scrollController.animateTo(
                ((2 * prefCurrencies.length - 1) * ITEM_HEIGHT -
                        _scrollController.position.viewportDimension) /
                    2,
                curve: Curves.easeOut,
                duration: const Duration(milliseconds: 400),
              );
            }
          } else if (currencyState.preferredCurrencies.length != 1) {
            prefCurrencies.remove(
              currencyData.shortName,
            );
          }
          _updatePreferredCurrencies(context, currencyState, prefCurrencies);
        });
      },
      subtitle: Text(
        _subtitle(texts, currencyData),
        style: theme.fiatConversionDescriptionStyle,
      ),
      title: RichText(
        text: TextSpan(
          text: currencyData.shortName,
          style: theme.fiatConversionTitleStyle,
          children: [
            TextSpan(
              text: " (${currencyData.symbol})",
              style: theme.fiatConversionDescriptionStyle,
            ),
          ],
        ),
      ),
    );
  }

  String _subtitle(AppLocalizations texts, FiatCurrency currencyData) {
    final localizedName = currencyData.localizedName[texts.locale];
    return localizedName ?? currencyData.name;
  }

  void _onReorder(
    BuildContext context,
    CurrencyState currencyState,
    int oldIndex,
    int newIndex,
  ) {
    final preferredFiatCurrencies = List<String>.from(
      currencyState.preferredCurrencies,
    );
    if (newIndex >= preferredFiatCurrencies.length) {
      newIndex = preferredFiatCurrencies.length - 1;
    }
    String item = preferredFiatCurrencies.removeAt(oldIndex);
    preferredFiatCurrencies.insert(newIndex, item);
    _updatePreferredCurrencies(context, currencyState, preferredFiatCurrencies);
  }

  void _updatePreferredCurrencies(
    BuildContext context,
    CurrencyState currencyState,
    List<String> preferredFiatCurrencies,
  ) {    
    context.read<CurrencyBoc>().setPreferredCurrencies(preferredFiatCurrencies);   
  }
}
