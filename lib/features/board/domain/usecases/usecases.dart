import 'package:taskboard/features/board/domain/entities/entities.dart';
import 'package:taskboard/features/board/domain/repositories/board_repository.dart';

String newId() => DateTime.now().microsecondsSinceEpoch.toString();

class LoadBoard {
  final BoardRepository _repo;
  LoadBoard(this._repo);
  Future<BoardSnapshot> call() => _repo.load();
}

class SaveBoard {
  final BoardRepository _repo;
  SaveBoard(this._repo);
  Future<void> call(BoardSnapshot snapshot) => _repo.save(snapshot);
}

class AddList {
  List<TaskList> call(List<TaskList> lists, String title, String projectId) => [
    ...lists,
    TaskList(id: newId(), title: title, projectId: projectId),
  ];
}

class RenameList {
  List<TaskList> call(List<TaskList> lists, String id, String title) =>
      lists.map((l) => l.id == id ? l.copyWith(title: title) : l).toList();
}

class DeleteList {
  List<TaskList> call(List<TaskList> lists, String id) =>
      lists.where((l) => l.id != id).toList();
}

class AddCard {
  List<TaskList> call(List<TaskList> lists, String listId, String title) =>
      lists
          .map(
            (l) => l.id == listId
                ? l.copyWith(
                    cards: [
                      ...l.cards,
                      TaskCard(id: newId(), title: title),
                    ],
                  )
                : l,
          )
          .toList();
}

class EditCard {
  List<TaskList> call(
    List<TaskList> lists,
    String cardId,
    String title,
    String description,
  ) => lists
      .map(
        (l) => l.copyWith(
          cards: l.cards
              .map(
                (c) => c.id == cardId
                    ? c.copyWith(title: title, description: description)
                    : c,
              )
              .toList(),
        ),
      )
      .toList();
}

class DeleteCard {
  List<TaskList> call(List<TaskList> lists, String cardId) => lists
      .map(
        (l) => l.copyWith(cards: l.cards.where((c) => c.id != cardId).toList()),
      )
      .toList();
}

class MoveCard {
  /// Moves [cardId] into [toListId]. If [beforeCardId] is given, it is inserted
  /// before that card, otherwise appended to the end.
  List<TaskList> call(
    List<TaskList> lists,
    String cardId,
    String toListId, {
    String? beforeCardId,
  }) {
    if (beforeCardId == cardId) return lists;
    TaskCard? moving;
    final removed = lists.map((l) {
      final i = l.cards.indexWhere((c) => c.id == cardId);
      if (i == -1) return l;
      moving = l.cards[i];
      return l.copyWith(cards: [...l.cards]..removeAt(i));
    }).toList();
    if (moving == null) return lists;
    return removed.map((l) {
      if (l.id != toListId) return l;
      final cards = [...l.cards];
      final at = beforeCardId == null
          ? -1
          : cards.indexWhere((c) => c.id == beforeCardId);
      if (at == -1) {
        cards.add(moving!);
      } else {
        cards.insert(at, moving!);
      }
      return l.copyWith(cards: cards);
    }).toList();
  }
}
