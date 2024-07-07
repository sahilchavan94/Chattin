// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'story_cubit.dart';

enum StoryStatus {
  initial,
  loading,
  success,
  failure,
}

class StoryState {
  final StoryStatus storyStatus;
  final List<StoryEntity>? stories;
  final StoryEntity? myStory;
  final String? message;

  StoryState({
    required this.storyStatus,
    this.stories,
    this.message,
    this.myStory,
  });

  StoryState.initial() : this(storyStatus: StoryStatus.initial);

  StoryState copyWith({
    StoryStatus? storyStatus,
    List<StoryEntity>? stories,
    StoryEntity? myStory,
    String? message,
  }) {
    return StoryState(
      storyStatus: storyStatus ?? this.storyStatus,
      stories: stories ?? this.stories,
      message: message ?? this.message,
      myStory: myStory ?? this.myStory,
    );
  }
}
