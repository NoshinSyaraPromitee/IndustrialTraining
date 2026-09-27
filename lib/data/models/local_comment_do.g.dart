// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'local_comment_do.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

LocalCommentDO _$LocalCommentDOFromJson(Map<String, dynamic> json) =>
    LocalCommentDO(
      id: (json['id'] as num).toInt(),
      parentId: (json['parentId'] as num?)?.toInt(),
      text: json['text'] as String,
      time: (json['time'] as num).toInt(),
    );

Map<String, dynamic> _$LocalCommentDOToJson(LocalCommentDO instance) =>
    <String, dynamic>{
      'id': instance.id,
      'parentId': instance.parentId,
      'text': instance.text,
      'time': instance.time,
    };
