import 'package:flutter/material.dart' hide Card;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:learning_app/card_backend/cards_api/models/card.dart';
import 'package:learning_app/card_backend/cards_api/models/search_result.dart';
import 'package:learning_app/editor/card_preview_bottom_sheet.dart';
import 'package:learning_app/search/bloc/search_bloc.dart';
import 'package:learning_app/search/view/parentObjects.dart';
import 'package:learning_app/ui_components/ui_colors.dart';
import 'package:learning_app/ui_components/ui_constants.dart';
import 'package:learning_app/ui_components/ui_icons.dart';
import 'package:learning_app/ui_components/ui_text.dart';
import 'package:learning_app/ui_components/widgets/bottom_sheet/ui_bottom_sheet.dart';
import 'package:learning_app/ui_components/widgets/ui_label_row.dart';class CardsSearchResults extends StatelessWidget {
  CardsSearchResults({
    super.key,
    required this.foundCards,
    this.searchRequest,
  }) {
    if (foundCards.isNotEmpty) {
      var i = 0;
      for (final result in foundCards) {
        widgetCards.add(
          _CardListTileSearch(
            card: result.searchedObject as Card,
            searchRequest: searchRequest!,
            parentObjects: result.parentObjects,
          ),
        );
        if (i < foundCards.length - 1) {
          widgetCards.add(const SizedBox(height: UIConstants.itemPadding));
        }
        i++;
      }
    }
  }
  final List<SearchResult> foundCards;
  List<Widget> widgetCards = List.empty(growable: true);
  String? searchRequest;

  @override
  Widget build(BuildContext context) {
    if (foundCards.isNotEmpty) {
      return Column(
        children: [
          UILabelRow(
            labelText: 'Cards',
            actionWidgets: [
              Text(
                '${foundCards.length} Found',
                style: UIText.label.copyWith(color: UIColors.smallText),
              ),
            ],
          ),
          const SizedBox(
            height: UIConstants.itemPaddingLarge,
          ),
          Column(
            children: widgetCards,
          ),
          const SizedBox(height: UIConstants.itemPaddingLarge * 2),
        ],
      );
    } else {
      return Container();
    }
  }
}

class _CardListTileSearch extends StatelessWidget {
  const _CardListTileSearch({
    required this.card,
    required this.searchRequest,
    required this.parentObjects,
  });
  final Card card;
  final String searchRequest;
  final List<Object> parentObjects;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () {
        UIBottomSheet.showUIBottomSheet(
          context: context,
          builder: (_) {
            return CardPreviewBottomSheet(
              card: card,
              cardsRepository: context.read<SearchBloc>().cardsRepository,
            );
          },
        );
      },
      child: Column(
        children: [
          const SizedBox(
            height: UIConstants.itemPadding / 4,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const SizedBox(
                width: UIConstants.itemPadding * 0.75,
              ),
              UIIcons.card,
              const SizedBox(
                width: UIConstants.itemPadding,
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // card.front was there before
                    Text(card.name, style: UIText.labelBold),
                    const SizedBox(
                      height: UIConstants.itemPadding / 4,
                    ),
                    // _HitText(searchRequest: searchRequest, text: card.front + card.back)
                    ParentObjects(
                      parentObjects: parentObjects,
                    ),
                  ],
                ),
              ),
              const SizedBox(
                width: UIConstants.itemPadding,
              ),
              UIIcons.arrowForwardMedium.copyWith(color: UIColors.smallText),
            ],
          ),
          const SizedBox(
            height: UIConstants.itemPadding / 4,
          ),
        ],
      ),
    );
  }
}

// TODO finish hit text
class _HitText extends StatelessWidget {
  _HitText({required this.searchRequest, required this.text});

  String searchRequest;
  String text;

  @override
  Widget build(BuildContext context) {
    text = text + text + text + text + text + text + text;
    if (text.contains(searchRequest)) {
      text.indexOf(searchRequest);
    }
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          searchRequest,
          style: UIText.normalBold.copyWith(color: UIColors.primary),
        ),
        Flexible(
          child: Text(
            text.substring(text.indexOf(searchRequest) + 1),
            style: UIText.normal.copyWith(color: UIColors.smallText),
          ),
        ),
      ],
    );
  }
}