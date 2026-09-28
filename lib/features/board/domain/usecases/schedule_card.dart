import 'package:taskboard/features/board/domain/entities/entities.dart';

class ScheduleCard {
  /// Sets the due day of a card, or clears it when [day] is null.
  List<TaskList> call(List<TaskList> lists, String cardId, DateTime? day) =>
      lists
          .map(
            (l) => l.copyWith(
              cards: l.cards
                  .map(
                    (c) => c.id == cardId
                        ? c.copyWith(due: day, clearDue: day == null)
                        : c,
                  )
                  .toList(),
            ),
          )
          .toList();
}
