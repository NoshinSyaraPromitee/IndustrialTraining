// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'story_do.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

StoryDO _$StoryDOFromJson(Map<String, dynamic> json) => StoryDO(
  id: (json['id'] as num?)?.toInt() ?? 0,
  title: json['title'] as String? ?? 'No title',
  author: json['by'] as String? ?? 'Unknown',
  url: json['url'] as String?,
  score: (json['score'] as num?)?.toInt() ?? 0,
  time: (json['time'] as num?)?.toInt() ?? 0,
  commentCount: (json['descendants'] as num?)?.toInt() ?? 0,
  kids: (json['kids'] as List<dynamic>?)
      ?.map((e) => (e as num).toInt())
      .toList(),
);
