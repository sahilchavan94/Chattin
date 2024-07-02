import 'package:chattin/core/router/route_path.dart';
import 'package:chattin/core/utils/app_pallete.dart';
import 'package:chattin/core/utils/app_spacing.dart';
import 'package:chattin/core/utils/app_theme.dart';
import 'package:chattin/core/widgets/failure_widget.dart';
import 'package:chattin/core/widgets/image_widget.dart';
import 'package:chattin/core/widgets/input_widget.dart';
import 'package:chattin/features/auth/presentation/cubit/auth_cubit.dart';
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

  @override
  void initState() {
    context.read<AuthCubit>().checkTheAccountDetailsIfTheEmailIsVerified();
    super.initState();
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
                return GestureDetector(
                  onTap: () {
                    context.push(RoutePath.profileScreen.path);
                  },
                  child: ImageWidget(
                    imagePath: state.userData!.imageUrl,
                    radius: BorderRadius.circular(30),
                    width: 25,
                    height: 25,
                    fit: BoxFit.fill,
                  ),
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
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                InputWidget(
                  height: 45,
                  hintText: 'Search your chats',
                  textEditingController: _searchController,
                  validator: (String val) {},
                  suffixIcon: const Icon(Icons.search),
                  fillColor: AppPallete.bottomSheetColor,
                  borderRadius: 60,
                  showBorder: false,
                ),
                verticalSpacing(30),
                Expanded(
                  child: StreamBuilder(
                    stream: context.read<ChatCubit>().getChatContacts(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(
                          child: CircularProgressIndicator(),
                        );
                      }
                      final chatsList = snapshot.data ?? [];
                      if (chatsList.isNotEmpty) {
                        return ListView.builder(
                          itemCount: chatsList.length,
                          itemBuilder: (context, index) {
                            return GestureDetector(
                              onTap: () {
                                context.push(
                                  RoutePath.chatScreen.path,
                                  extra: {
                                    'uid': chatsList[index].uid,
                                    'displayName': chatsList[index].displayName,
                                    'imageUrl': chatsList[index].imageUrl,
                                  },
                                );
                              },
                              child: ChatContactWidget(
                                imageUrl: chatsList[index].imageUrl,
                                displayName: chatsList[index].displayName,
                                lastMessage: chatsList[index].lastMessage ??
                                    'This message was not available due to some error',
                                timeSent: chatsList[index].timeSent!,
                                hasVerticalSpacing: true,
                              ),
                            );
                          },
                        );
                      } else {
                        return const SizedBox.shrink();
                      }
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
