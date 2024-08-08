// ignore_for_file: use_build_context_synchronously

import 'package:chattin/core/enum/enums.dart';
import 'package:chattin/core/utils/app_pallete.dart';
import 'package:chattin/core/utils/app_spacing.dart';
import 'package:chattin/core/utils/app_theme.dart';
import 'package:chattin/core/utils/contacts.dart';
import 'package:chattin/core/utils/toast_messages.dart';
import 'package:chattin/core/utils/toasts.dart';
import 'package:chattin/core/widgets/failure_widget.dart';
import 'package:chattin/features/chat/presentation/cubits/chat_cubit/chat_cubit.dart';
import 'package:chattin/features/chat/presentation/cubits/contacts_cubit/contacts_cubit.dart';
import 'package:chattin/features/chat/presentation/widgets/contact_widget.dart';
import 'package:chattin/features/profile/presentation/cubit/profile_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:toastification/toastification.dart';

class ForwardChatView extends StatefulWidget {
  final String text;
  final MessageType messageType;
  const ForwardChatView({
    super.key,
    required this.text,
    required this.messageType,
  });

  @override
  State<ForwardChatView> createState() => _ForwardChatViewState();
}

class _ForwardChatViewState extends State<ForwardChatView> {
  Set<String> selectedContacts = {};

  @override
  void initState() {
    super.initState();
    _getContactsFromPhone();
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

  void _onCheckboxChanged(bool? value, String uid) {
    if (selectedContacts.length == 5 && value == true) {
      showToast(
        content: ToastMessages.forwardLimitReached,
        type: ToastificationType.info,
      );
      return;
    }
    setState(() {
      if (value == true) {
        selectedContacts.add(uid);
      } else {
        selectedContacts.remove(uid);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Forward Chat'),
        centerTitle: true,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          final forwardContactList = selectedContacts.toList();
          if (forwardContactList.isEmpty) {
            showToast(
              content: ToastMessages.noContactsSelected,
              type: ToastificationType.info,
            );
            return;
          }
          context.read<ChatCubit>().forwardMessage(
                text: widget.text,
                receiverIdList: forwardContactList,
                sender: context.read<ProfileCubit>().state.userData!,
                messageType: widget.messageType,
              );
        },
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(
            20,
          ),
        ),
        backgroundColor: AppPallete.bottomSheetColor,
        child: const Icon(
          Icons.arrow_forward,
          color: AppPallete.blueColor,
        ),
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
          final contactsList = state.contactList ?? [];

          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (contactsList.isNotEmpty)
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      verticalSpacing(5),
                      Text(
                        "Select chats to forward",
                        style: AppTheme.darkThemeData.textTheme.displaySmall!
                            .copyWith(
                          color: AppPallete.greyColor,
                        ),
                      ),
                      verticalSpacing(20),
                    ],
                  ),
                if (contactsList.isNotEmpty)
                  Expanded(
                    child: ListView.builder(
                      itemCount: contactsList.length,
                      itemBuilder: (context, index) {
                        final currentContact = contactsList[index];
                        final isSelected =
                            selectedContacts.contains(currentContact.uid);
                        return Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Checkbox(
                              activeColor: AppPallete.bottomSheetColor,
                              checkColor: AppPallete.blueColor,
                              value: isSelected,
                              onChanged: (val) {
                                _onCheckboxChanged(val, currentContact.uid!);
                              },
                            ),
                            Flexible(
                              child: ContactWidget(
                                imageUrl: currentContact.imageUrl,
                                uid: currentContact.uid!,
                                displayName: currentContact.displayName,
                                about: currentContact.about!,
                                hasVerticalSpacing: true,
                                radius: 50,
                              ),
                            ),
                          ],
                        );
                      },
                    ),
                  )
                else
                  Expanded(
                    child: Center(
                      child: Text(
                        "No chats to forward",
                        style: AppTheme.darkThemeData.textTheme.displaySmall!
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
  }
}
