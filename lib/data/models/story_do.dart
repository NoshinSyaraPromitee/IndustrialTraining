import 'package:json_annotation/json_annotation.dart';
import '../../domain/entities/story.dart';

part 'story_do.g.dart';

/// Parsing code is generated into story_do.g.dart (run build_runner).
@JsonSerializable(createToJson: false)
class StoryDO {
  @JsonKey(defaultValue: 0)
  final int id;
  @JsonKey(defaultValue: 'No title')
  final String title;
  @JsonKey(name: 'by', defaultValue: 'Unknown')
  final String author;
  final String? url;
  @JsonKey(defaultValue: 0)
  final int score;
  @JsonKey(defaultValue: 0)
  final int time;
  @JsonKey(name: 'descendants', defaultValue: 0)
  final int commentCount;
  final List<int>? kids;

  const StoryDO({
    required this.id,
    required this.title,
    required this.author,
    this.url,
    required this.score,
    required this.time,
    required this.commentCount,
    this.kids,
  });

  factory StoryDO.fromJson(Map<String, dynamic> json) =>
      _$StoryDOFromJson(json);

  Story toEntity() => Story(
        id: id,
        title: title,
        author: author,
        url: url,
        score: score,
        time: time,
        commentCount: commentCount,
        kids: kids ?? const [],
      );
}