import 'package:chattin/core/router/route_path.dart';
import 'package:chattin/core/utils/app_pallete.dart';
import 'package:chattin/core/utils/app_spacing.dart';
import 'package:chattin/core/utils/app_theme.dart';
import 'package:chattin/core/widgets/failure_widget.dart';
import 'package:chattin/core/widgets/image_widget.dart';
import 'package:chattin/core/widgets/input_widget.dart';
import 'package:chattin/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:chattin/features/chat/domain/entities/contact_entity.dart';
import 'package:chattin/features/chat/presentation/cubits/chat_cubit/cubit/chat_cubit.dart';
import 'package:chattin/features/chat/presentation/widgets/chat_contact_widget.dart';
import 'package:chattin/features/profile/presentation/cubit/profile_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'dart:async';

class ChatContactsView extends StatefulWidget {
  const ChatContactsView({super.key});

  @override
  State<ChatContactsView> createState() => _ChatContactsViewState();
}

class _ChatContactsViewState extends State<ChatContactsView> {
  final TextEditingController _searchController = TextEditingController();
  final StreamController<List<ContactEntity>> _filteredContactsController =
      StreamController<List<ContactEntity>>();

  List<ContactEntity> _chatContactsList = [];

  @override
  void initState() {
    context.read<AuthCubit>().checkTheAccountDetailsIfTheEmailIsVerified();
    context.read<ProfileCubit>().getProfileData();
    _searchController.addListener(_filterContacts);
    super.initState();
  }

  @override
  void dispose() {
    _searchController.dispose();
    _filteredContactsController.close();
    super.dispose();
  }

  void _filterContacts() {
    final query = _searchController.text.toLowerCase();
    final filteredContacts = _chatContactsList.where((contact) {
      final name = contact.displayName.toLowerCase();
      return name.contains(query);
    }).toList();

    _filteredContactsController.add(filteredContacts);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Chattin`',
              style: AppTheme.darkThemeData.textTheme.displayLarge!.copyWith(
                color: AppPallete.blueColor,
              ),
            ),
          ],
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 12,
            ),
            child: BlocBuilder<ProfileCubit, ProfileState>(
              builder: (context, state) {
                if (state.profileStatus != ProfileStatus.success) {
                  return const SizedBox.shrink();
                }
                return Row(
                  children: [
                    GestureDetector(
                      onTap: () {
                        context.push(RoutePath.storyContactsView.path);
                      },
                      child: Image.asset(
                        'assets/images/story.png',
                        width: 22,
                        height: 22,
                      ),
                    ),
                    horizontalSpacing(23),
                    GestureDetector(
                      onTap: () {
                        context.push(RoutePath.profileScreen.path);
                      },
                      child: Hero(
                        tag: state.userData!.imageUrl,
                        child: Material(
                          type: MaterialType.transparency,
                          child: ImageWidget(
                            imagePath: state.userData!.imageUrl,
                            radius: BorderRadius.circular(30),
                            width: 25,
                            height: 25,
                            fit: BoxFit.fill,
                          ),
                        ),
                      ),
                    ),
                  ],
                );
              },
            ),
          )
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          context.push(RoutePath.selectContact.path);
        },
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(
            50,
          ),
        ),
        backgroundColor: AppPallete.bottomSheetColor,
        child: Image.asset(
          'assets/images/logo.png',
          width: 30,
        ),
      ),
      body: BlocBuilder<AuthCubit, AuthState>(
        builder: (context, state) {
          if (state.authStatus == AuthStatus.loading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          if (state.authStatus == AuthStatus.failure) {
            return const FailureWidget();
          }

          return BlocBuilder<ChatCubit, ChatState>(
            builder: (context, chatState) {
              if (chatState.chatStatus == ChatStatus.loading) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }
              if (chatState.chatStatus == ChatStatus.failure) {
                return const FailureWidget();
              }

              _chatContactsList = chatState.chatContacts ?? [];
              _filterContacts(); // Initial filter to update the StreamController

              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Column(
                  children: [
                    InputWidget(
                      height: 45,
                      hintText: 'Search your chats',
                      textEditingController: _searchController,
                      validator: (String val) {},
                      suffixIcon: const Icon(
                        Icons.search,
                        color: AppPallete.greyColor,
                        size: 20,
                      ),
                      fillColor: AppPallete.bottomSheetColor,
                      borderRadius: 60,
                      showBorder: false,
                    ),
                    verticalSpacing(30),
                    Expanded(
                      child: StreamBuilder<List<ContactEntity>>(
                        stream: _filteredContactsController.stream,
                        builder: (context, snapshot) {
                          if (!snapshot.hasData) {
                            return const Center(
                              child: CircularProgressIndicator(),
                            );
                          }
                          final filteredContacts = snapshot.data!;
                          return ListView.builder(
                            itemCount: filteredContacts.length,
                            itemBuilder: (context, index) {
                              final chatContact = filteredContacts[index];
                              return GestureDetector(
                                onTap: () {
                                  context.push(
                                    RoutePath.chatScreen.path,
                                    extra: {
                                      'uid': chatContact.uid,
                                      'displayName': chatContact.displayName,
                                      'imageUrl': chatContact.imageUrl,
                                    },
                                  );
                                },
                                child: ChatContactWidget(
                                  hasVerticalSpacing: true,
                                  imageUrl: chatContact.imageUrl,
                                  displayName: chatContact.displayName,
                                  lastMessage: chatContact.lastMessage!,
                                  timeSent: chatContact.timeSent!,
                                ),
                              );
                            },
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
