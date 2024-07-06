// ignore_for_file: use_build_context_synchronously

import 'dart:developer';

import 'package:chattin/core/errors/failure.dart';
import 'package:chattin/core/utils/app_pallete.dart';
import 'package:chattin/core/utils/contacts.dart';
import 'package:chattin/core/widgets/failure_widget.dart';
import 'package:chattin/core/widgets/input_widget.dart';
import 'package:chattin/features/chat/presentation/cubits/contacts_cubit/contacts_cubit.dart';
import 'package:chattin/features/profile/presentation/cubit/profile_cubit.dart';
import 'package:chattin/features/stories/domain/entities/story_entity.dart';
import 'package:chattin/features/stories/presentation/cubit/stories_cubit.dart';
import 'package:chattin/features/stories/presentation/widgets/story_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class StoryView extends StatefulWidget {
  const StoryView({super.key});

  @override
  State<StoryView> createState() => _StoryViewState();
}

class _StoryViewState extends State<StoryView> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    _getContactsFromPhone(isRefreshed: false);
    super.initState();
  }

  _getContactsFromPhone({bool isRefreshed = false}) async {
    String phoneNumber =
        context.read<ProfileCubit>().state.userData!.phoneNumber!;
    List<String> contactsList = await Contacts.getContacts(
      selfNumber: phoneNumber,
    );
    await context.read<ContactsCubit>().getAppContacts(
      [...contactsList, phoneNumber],
      isRefreshed: isRefreshed,
    );

    final phoneNumbers = context.read<ContactsCubit>().state.contactList;

    await context.read<StoriesCubit>().getStories(
          phoneNumbers: phoneNumbers!.map((e) => e.phoneNumber!).toList(),
        );
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
          return BlocBuilder<StoriesCubit, StoriesState>(
            builder: (context, storiesState) {
              if (storiesState.storiesStatus == StoriesStatus.loading) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }
              if (storiesState.storiesStatus == StoriesStatus.failure) {
                return const FailureWidget();
              }

              final List<StoryEntity> stories = storiesState.stories ?? [];
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Column(
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
                    Expanded(
                      child: ListView.builder(
                        itemCount: stories.length,
                        itemBuilder: (context, index) {
                          final story = stories[index];
                          return StoryWidget(
                            displayName: story.displayName,
                            firstStoryImageUrl: story.imageUrlList.first['url'],
                            firestStoryUploadTime:
                                DateTime.fromMillisecondsSinceEpoch(
                              story.imageUrlList.first['uploadedAt'],
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
