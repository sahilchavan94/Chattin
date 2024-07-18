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

class ChatContactsView extends StatefulWidget {
  const ChatContactsView({super.key});

  @override
  State<ChatContactsView> createState() => _ChatContactsViewState();
}

class _ChatContactsViewState extends State<ChatContactsView> {
  final TextEditingController _searchController = TextEditingController();
  List<ContactEntity> _chatContactsList = [];
  String _searchQuery = '';

  @override
  void initState() {
    context.read<AuthCubit>().checkTheAccountDetailsIfTheEmailIsVerified();
    context.read<ProfileCubit>().getProfileData();
    _searchController.addListener(_onSearchChanged);
    super.initState();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _onSearchChanged() {
    setState(() {
      _searchQuery = _searchController.text.toLowerCase();
    });
  }

  List<ContactEntity> _filterContacts(List<ContactEntity> contacts) {
    if (_searchQuery.isEmpty) {
      return contacts;
    }
    return contacts.where((contact) {
      final name = contact.displayName.toLowerCase();
      return name.contains(_searchQuery);
    }).toList();
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
                fontWeight: FontWeight.w700,
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
                            fit: BoxFit.cover,
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

              _chatContactsList = _filterContacts(chatState.chatContacts ?? []);

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
                    if (_chatContactsList.isEmpty)
                      Expanded(
                        child: Center(
                          child: Text(
                            "No Results Found",
                            style: AppTheme
                                .darkThemeData.textTheme.displaySmall!
                                .copyWith(
                              color: AppPallete.greyColor,
                            ),
                          ),
                        ),
                      )
                    else
                      Expanded(
                        child: ListView.builder(
                          itemCount: _chatContactsList.length,
                          itemBuilder: (context, index) {
                            final chatContact = _chatContactsList[index];
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
                                uid: chatContact.uid!,
                                hasVerticalSpacing: true,
                                imageUrl: chatContact.imageUrl,
                                displayName: chatContact.displayName,
                                lastMessage: chatContact.lastMessage!,
                                timeSent: chatContact.timeSent!,
                              ),
                            );
                          },
                        ),
                      )
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
