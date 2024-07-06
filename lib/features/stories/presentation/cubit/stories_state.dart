// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'stories_cubit.dart';

enum StoriesStatus {
  initial,
  loading,
  success,
  failure,
}

class StoriesState {
  final StoriesStatus storiesStatus;
  final List<StoryEntity>? stories;
  final String? message;

  StoriesState({
    required this.storiesStatus,
    this.stories,
    this.message,
  });

  StoriesState.initial() : this(storiesStatus: StoriesStatus.initial);

  StoriesState copyWith({
    StoriesStatus? storiesStatus,
    List<StoryEntity>? stories,
    String? message,
  }) {
    return StoriesState(
      storiesStatus: storiesStatus ?? this.storiesStatus,
      stories: stories ?? this.stories,
      message: message ?? this.message,
    );
  }
}
