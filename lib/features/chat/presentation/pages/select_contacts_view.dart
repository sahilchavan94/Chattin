// ignore_for_file: use_build_context_synchronously

import 'package:chattin/core/router/route_path.dart';
import 'package:chattin/core/utils/app_pallete.dart';
import 'package:chattin/core/utils/app_spacing.dart';
import 'package:chattin/core/utils/contacts.dart';
import 'package:chattin/core/widgets/input_widget.dart';
import 'package:chattin/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:chattin/features/chat/presentation/cubits/contacts_cubit/contacts_cubit.dart';
import 'package:chattin/features/chat/presentation/widgets/contact_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class SelectContactsView extends StatefulWidget {
  const SelectContactsView({super.key});

  @override
  State<SelectContactsView> createState() => _SelectContactsViewState();
}

class _SelectContactsViewState extends State<SelectContactsView> {
  final TextEditingController _searchController = TextEditingController();
  bool showSearch = false;

  @override
  void initState() {
    _getContactsFromPhone();
    super.initState();
  }

  _getContactsFromPhone() async {
    List<String> contactsList = await Contacts.getContacts();
    context.read<ContactsCubit>().getAppContacts(contactsList);
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthCubit, AuthState>(
      builder: (context, state) {
        if (state.authStatus == AuthStatus.loading) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
        return Scaffold(
          appBar: AppBar(
            title: const Text('Select contact'),
            actions: [
              IconButton(
                onPressed: () {
                  setState(() {
                    showSearch = !showSearch;
                  });
                },
                icon: const Icon(
                  Icons.search,
                ),
                color: AppPallete.whiteColor,
              ),
            ],
          ),
          body: BlocBuilder<ContactsCubit, ContactsState>(
            builder: (context, contactsState) {
              if (contactsState.contactsStatus == ContactsStatus.loading) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }
              if (contactsState.contactsStatus == ContactsStatus.failure) {
                return const Center(
                  child: Text(
                    "failure",
                    style: TextStyle(color: AppPallete.whiteColor),
                  ),
                );
              }
              final contactsList = contactsState.contactList ?? [];
              return Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    Visibility(
                      visible: showSearch,
                      child: InputWidget(
                        height: 45,
                        hintText: 'Search for contacts',
                        textEditingController: _searchController,
                        validator: (String val) {},
                        suffixIcon: const Icon(Icons.search),
                        fillColor: AppPallete.bottomSheetColor,
                        borderRadius: 60,
                        showBorder: false,
                      )
                          .animate()
                          .fadeIn(
                            curve: Curves.fastEaseInToSlowEaseOut,
                            duration: Durations.medium4,
                          )
                          .slide(
                            curve: Curves.fastEaseInToSlowEaseOut,
                            duration: Durations.medium4,
                          ),
                    ),
                    verticalSpacing(30),
                    Expanded(
                      child: ListView.builder(
                        itemCount: contactsList.length,
                        itemBuilder: (context, index) {
                          return GestureDetector(
                            onTap: () {
                              context.push(
                                RoutePath.chatScreen.path,
                                extra: {
                                  'uid': contactsList[index].uid,
                                  'displayName':
                                      contactsList[index].displayName,
                                  'imageUrl': contactsList[index].imageUrl,
                                },
                              );
                            },
                            child: ContactWidget(
                              imageUrl: contactsList[index].imageUrl,
                              displayName: contactsList[index].displayName,
                              about: contactsList[index].about!,
                              hasVerticalSpacing: true,
                            ),
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
      },
    );
  }
}
