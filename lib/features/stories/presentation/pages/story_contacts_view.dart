// ignore_for_file: use_build_context_synchronously

import 'dart:io';
import 'package:chattin/core/common/entities/user_entity.dart';
import 'package:chattin/core/router/route_path.dart';
import 'package:chattin/core/utils/app_pallete.dart';
import 'package:chattin/core/utils/app_spacing.dart';
import 'package:chattin/core/utils/app_theme.dart';
import 'package:chattin/core/utils/contacts.dart';
import 'package:chattin/core/utils/picker.dart';
import 'package:chattin/core/widgets/failure_widget.dart';
import 'package:chattin/core/widgets/image_widget.dart';
import 'package:chattin/core/widgets/input_widget.dart';
import 'package:chattin/features/chat/presentation/cubits/contacts_cubit/contacts_cubit.dart';
import 'package:chattin/features/profile/presentation/cubit/profile_cubit.dart';
import 'package:chattin/features/stories/domain/entities/story_entity.dart';
import 'package:chattin/features/stories/presentation/cubit/story_cubit.dart';
import 'package:chattin/features/stories/presentation/widgets/story_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class StoryContactsView extends StatefulWidget {
  const StoryContactsView({super.key});

  @override
  State<StoryContactsView> createState() => _StoryContactsViewState();
}

class _StoryContactsViewState extends State<StoryContactsView> {
  final TextEditingController _searchController = TextEditingController();
  late UserEntity userData;

  @override
  void initState() {
    userData = context.read<ProfileCubit>().state.userData!;
    _getContactsFromPhone(isRefreshed: false);
    super.initState();
  }

  _getContactsFromPhone({bool isRefreshed = false}) async {
    List<String> contactsList = await Contacts.getContacts(
      selfNumber: userData.phoneNumber!,
    );
    await context.read<ContactsCubit>().getAppContacts(
      [...contactsList, userData.phoneNumber!],
      isRefreshed: isRefreshed,
    );
    final phoneNumbers = context.read<ContactsCubit>().state.contactList;
    await context.read<StoryCubit>().getStories(
          phoneNumbers: phoneNumbers!.map((e) => e.phoneNumber!).toList(),
          selfNumber: userData.phoneNumber!,
        );
  }

  _callUseCaseToUploadStoryImages() async {
    final pickedImages = await Picker.pickMultipleImages();
    if (pickedImages != null && pickedImages.isNotEmpty) {
      final List<File> selectedFiles = [];
      selectedFiles.addAll(pickedImages);
      context.push(
        RoutePath.storyPreview.path,
        extra: {
          'selectedFiles': selectedFiles,
          'imageUrl': userData.imageUrl,
          'displayName': userData.displayName,
          'phoneNumber': userData.phoneNumber,
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Stories'),
        centerTitle: true,
      ),
      body: BlocBuilder<ContactsCubit, ContactsState>(
        builder: (context, state) {
          if (state.contactsStatus == ContactsStatus.loading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          if (state.contactsStatus == ContactsStatus.failure) {
            return const FailureWidget();
          }
          return BlocBuilder<StoryCubit, StoryState>(
            builder: (context, storiesState) {
              if (storiesState.storyStatus == StoryStatus.loading) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }
              if (storiesState.storyStatus == StoryStatus.failure) {
                return const FailureWidget();
              }

              final List<StoryEntity> stories = storiesState.stories ?? [];
              final StoryEntity? myStory = storiesState.myStory;
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    InputWidget(
                      height: 45,
                      hintText: 'Search for stories',
                      textEditingController: _searchController,
                      validator: (String val) {},
                      suffixIcon: const Icon(
                        Icons.search,
                        color: AppPallete.greyColor,
                      ),
                      fillColor: AppPallete.bottomSheetColor,
                      borderRadius: 60,
                      showBorder: false,
                    ),
                    verticalSpacing(30),
                    //show the information of your story
                    Text(
                      "Explore stories",
                      style: AppTheme.darkThemeData.textTheme.displaySmall!
                          .copyWith(
                        color: AppPallete.whiteColor,
                        fontSize: 16,
                      ),
                    ),

                    if (myStory == null)
                      Column(
                        children: [
                          verticalSpacing(20),
                          _NoStoryWidget(
                            userData: userData,
                            onPressed: _callUseCaseToUploadStoryImages,
                          ),
                          verticalSpacing(20),
                        ],
                      )
                    else
                      GestureDetector(
                        onTap: () {
                          context.push(
                            RoutePath.storyView.path,
                            extra: [myStory],
                          );
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            StoryWidget(
                              displayName: "Your Story",
                              firstStoryImageUrl:
                                  myStory.imageUrlList.first['url'],
                              firestStoryUploadTime:
                                  DateTime.fromMillisecondsSinceEpoch(
                                myStory.imageUrlList.first['uploadedAt'],
                              ),
                            ),
                            IconButton(
                              onPressed: () async {
                                await _callUseCaseToUploadStoryImages();
                              },
                              icon: const Icon(
                                Icons.add_photo_alternate_outlined,
                              ),
                              color: AppPallete.blueColor,
                              iconSize: 23,
                            ),
                          ],
                        ),
                      ),
                    const Divider(
                      color: AppPallete.greyColor,
                      thickness: .15,
                      height: 1,
                    ),

                    Expanded(
                      child: ListView.builder(
                        itemCount: stories.length,
                        itemBuilder: (context, index) {
                          final story = stories[index];
                          return GestureDetector(
                            onTap: () {
                              context.push(
                                RoutePath.storyView.path,
                                extra: stories,
                              );
                            },
                            child: StoryWidget(
                              displayName: story.displayName,
                              firstStoryImageUrl:
                                  story.imageUrlList.first['url'],
                              firestStoryUploadTime:
                                  DateTime.fromMillisecondsSinceEpoch(
                                story.imageUrlList.first['uploadedAt'],
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}

class _NoStoryWidget extends StatelessWidget {
  final UserEntity userData;
  final VoidCallback onPressed;
  const _NoStoryWidget({
    required this.userData,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        ImageWidget(
          imagePath: userData.imageUrl,
          height: 50,
          width: 50,
          radius: BorderRadius.circular(50),
          fit: BoxFit.cover,
        ),
        horizontalSpacing(10),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            GestureDetector(
              onTap: () async {
                onPressed();
              },
              child: Text(
                "Add your story",
                style: AppTheme.darkThemeData.textTheme.displaySmall!.copyWith(
                  color: AppPallete.blueColor,
                  fontSize: 16,
                ),
              ),
            ),
            verticalSpacing(5),
            Text(
              "Share stories by sharing awesome pics",
              style: AppTheme.darkThemeData.textTheme.displaySmall!.copyWith(
                color: AppPallete.greyColor,
              ),
              maxLines: 2,
            ),
          ],
        ),
      ],
    );
  }
}
