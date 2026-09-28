import 'package:taskboard/features/board/domain/entities/entities.dart';

class LocateCard {
  /// Pins a card on the map, or removes the pin when lat/lng is null.
  List<TaskList> call(
    List<TaskList> lists,
    String cardId,
    double? lat,
    double? lng,
  ) => lists
      .map(
        (l) => l.copyWith(
          cards: l.cards
              .map(
                (c) => c.id == cardId
                    ? c.copyWith(
                        lat: lat,
                        lng: lng,
                        clearLocation: lat == null || lng == null,
                      )
                    : c,
              )
              .toList(),
        ),
      )
      .toList();
}
