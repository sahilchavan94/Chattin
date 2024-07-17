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

  List<ContactEntity> _allContacts = [];

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
    if (query.isEmpty) {
      _filteredContactsController.sink.add(_allContacts);
    } else {
      final filteredContacts = _allContacts
          .where((contact) => contact.displayName.toLowerCase().contains(query))
          .toList();
      _filteredContactsController.sink.add(filteredContacts);
    }
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
                    IconButton(
                      onPressed: () async {
                        context.push(RoutePath.storyContactsView.path);
                        return;
                      },
                      icon: const Icon(
                        Icons.add_photo_alternate_outlined,
                      ),
                      color: AppPallete.blueColor,
                      iconSize: 23,
                    ),
                    horizontalSpacing(10),
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
                  ),
                  fillColor: AppPallete.bottomSheetColor,
                  borderRadius: 60,
                  showBorder: false,
                ),
                Expanded(
                  child: StreamBuilder(
                    stream: context.read<ChatCubit>().getChatContacts(),
                    builder: (context, snapshot) {
                      if (snapshot.hasError) {
                        return const FailureWidget();
                      }
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(
                          child: CircularProgressIndicator(),
                        );
                      }
                      _allContacts = snapshot.data ?? [];
                      _filteredContactsController.sink.add(_allContacts);

                      return StreamBuilder<List<ContactEntity>>(
                        stream: _filteredContactsController.stream,
                        builder: (context, snapshot) {
                          final chatsList = snapshot.data ?? [];
                          if (chatsList.isEmpty) {
                            return Center(
                              child: Text(
                                "No chats found!",
                                style: AppTheme
                                    .darkThemeData.textTheme.displaySmall!
                                    .copyWith(
                                  color: AppPallete.greyColor,
                                ),
                              ),
                            );
                          }
                          return Column(
                            children: [
                              verticalSpacing(30),
                              Expanded(
                                child: ListView.builder(
                                  itemCount: chatsList.length,
                                  itemBuilder: (context, index) {
                                    return GestureDetector(
                                      onTap: () {
                                        context.push(
                                          RoutePath.chatScreen.path,
                                          extra: {
                                            'uid': chatsList[index].uid,
                                            'displayName':
                                                chatsList[index].displayName,
                                            'imageUrl':
                                                chatsList[index].imageUrl,
                                          },
                                        );
                                      },
                                      child: ChatContactWidget(
                                        imageUrl: chatsList[index].imageUrl,
                                        displayName:
                                            chatsList[index].displayName,
                                        lastMessage: chatsList[index]
                                                .lastMessage ??
                                            'This message was not available due to some error',
                                        timeSent: chatsList[index].timeSent!,
                                        hasVerticalSpacing: true,
                                      ),
                                    );
                                  },
                                ),
                              ),
                            ],
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
      ),
    );
  }
}
