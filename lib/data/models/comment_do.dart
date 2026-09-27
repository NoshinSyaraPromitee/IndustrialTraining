import 'package:json_annotation/json_annotation.dart';
import '../../domain/entities/comment.dart';

part 'comment_do.g.dart';

/// HN marks removed comments with either `deleted` or `dead`.
Object? _readDeleted(Map<dynamic, dynamic> json, String key) =>
    json['deleted'] == true || json['dead'] == true;

@JsonSerializable(createToJson: false)
class CommentDO {
  @JsonKey(defaultValue: 0)
  final int id;
  @JsonKey(name: 'by')
  final String? author;
  @JsonKey(defaultValue: '')
  final String text;
  @JsonKey(defaultValue: 0)
  final int time;
  @JsonKey(readValue: _readDeleted)
  final bool deleted;
  final List<int>? kids;

  const CommentDO({
    required this.id,
    this.author,
    required this.text,
    required this.time,
    required this.deleted,
    this.kids,
  });

  factory CommentDO.fromJson(Map<String, dynamic> json) =>
      _$CommentDOFromJson(json);

  /// [replies] are resolved by the data source, then attached here.
  Comment toEntity(List<Comment> replies) => Comment(
        id: id,
        author: author,
        text: text,
        time: time,
        deleted: deleted,
        replies: replies,
      );
}