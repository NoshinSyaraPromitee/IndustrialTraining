// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'comment_do.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CommentDO _$CommentDOFromJson(Map<String, dynamic> json) => CommentDO(
  id: (json['id'] as num?)?.toInt() ?? 0,
  author: json['by'] as String?,
  text: json['text'] as String? ?? '',
  time: (json['time'] as num?)?.toInt() ?? 0,
  deleted: _readDeleted(json, 'deleted') as bool,
  kids: (json['kids'] as List<dynamic>?)
      ?.map((e) => (e as num).toInt())
      .toList(),
);
