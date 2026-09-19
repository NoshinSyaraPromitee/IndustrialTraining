import 'package:json_annotation/json_annotation.dart';
import '../../domain/entities/local_comment.dart';

part 'local_comment_do.g.dart';

/// Same JSON keys as before, so comments already saved on-device still load.
@JsonSerializable()
class LocalCommentDO {
  final int id;
  final int? parentId;
  final String text;
  final int time;

  const LocalCommentDO({
    required this.id,
    this.parentId,
    required this.text,
    required this.time,
  });

  factory LocalCommentDO.fromJson(Map<String, dynamic> json) =>
      _$LocalCommentDOFromJson(json);

  Map<String, dynamic> toJson() => _$LocalCommentDOToJson(this);

  LocalComment toEntity() =>
      LocalComment(id: id, parentId: parentId, text: text, time: time);
}