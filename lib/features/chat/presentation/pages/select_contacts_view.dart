// ignore_for_file: use_build_context_synchronously

import 'package:chattin/core/router/route_path.dart';
import 'package:chattin/core/utils/app_pallete.dart';
import 'package:chattin/core/utils/app_spacing.dart';
import 'package:chattin/core/utils/app_theme.dart';
import 'package:chattin/core/utils/contacts.dart';
import 'package:chattin/core/widgets/failure_widget.dart';
import 'package:chattin/core/widgets/input_widget.dart';
import 'package:chattin/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:chattin/features/chat/domain/entities/contact_entity.dart';
import 'package:chattin/features/chat/presentation/cubits/contacts_cubit/contacts_cubit.dart';
import 'package:chattin/features/chat/presentation/widgets/contact_widget.dart';
import 'package:chattin/features/profile/presentation/cubit/profile_cubit.dart';
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
  String _searchQuery = '';

  @override
  void initState() {
    _getContactsFromPhone(isRefreshed: false);
    _searchController.addListener(_onSearchChanged);
    super.initState();
  }

  _getContactsFromPhone({bool isRefreshed = false}) async {
    String phoneNumber =
        context.read<ProfileCubit>().state.userData!.phoneNumber!;
    List<String> contactsList = await Contacts.getContacts(
      selfNumber: phoneNumber,
    );
    context.read<ContactsCubit>().getAppContacts(
          contactsList,
          isRefreshed: isRefreshed,
        );
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
      return contact.displayName.toLowerCase().contains(_searchQuery);
    }).toList();
  }

  @override
  void dispose() {
    _searchController.removeListener(_onSearchChanged);
    _searchController.dispose();
    super.dispose();
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
        if (state.authStatus == AuthStatus.failure) {
          return const FailureWidget();
        }

        return Scaffold(
          appBar: AppBar(
            title: const Text('Select contact'),
            centerTitle: true,
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
                color: AppPallete.blueColor,
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
                return const FailureWidget();
              }
              final contactsList =
                  _filterContacts(contactsState.contactList ?? []);
              final currentUserUid =
                  context.read<ProfileCubit>().state.userData!.uid;
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Visibility(
                      visible: showSearch,
                      child: InputWidget(
                        height: 45,
                        hintText: 'Search for contacts',
                        textEditingController: _searchController,
                        validator: (String val) {},
                        suffixIcon: const Icon(
                          Icons.search,
                          color: AppPallete.greyColor,
                        ),
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
                    verticalSpacing(showSearch ? 30 : 5),
                    if (contactsList.isNotEmpty)
                      Column(
                        children: [
                          Text(
                            "Your available contacts",
                            style: AppTheme
                                .darkThemeData.textTheme.displaySmall!
                                .copyWith(
                              color: AppPallete.greyColor,
                            ),
                          ),
                          verticalSpacing(20),
                        ],
                      ),
                    if (contactsList.isNotEmpty)
                      Expanded(
                        child: RefreshIndicator(
                          backgroundColor: AppPallete.bottomSheetColor,
                          color: AppPallete.blueColor,
                          onRefresh: () async {
                            _getContactsFromPhone(isRefreshed: true);
                          },
                          child: ListView.builder(
                            itemCount: contactsList.length,
                            itemBuilder: (context, index) {
                              if (contactsList[index].uid == currentUserUid) {
                                return const SizedBox.shrink();
                              }
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
                                  radius: 50,
                                ),
                              );
                            },
                          ),
                        ),
                      )
                    else
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
