import 'package:bloc/bloc.dart';
import 'package:chattin/core/utils/toast_messages.dart';
import 'package:chattin/core/utils/toasts.dart';
import 'package:chattin/features/chat/domain/entities/contact_entity.dart';
import 'package:chattin/features/chat/domain/usecases/get_app_contacts.dart';
import 'package:toastification/toastification.dart';

part 'contacts_state.dart';

class ContactsCubit extends Cubit<ContactsState> {
  final GetContactsUseCase _getContactsUseCase;
  ContactsCubit(
    this._getContactsUseCase,
  ) : super(ContactsState.initial());

  //method to get the app contacts
  Future<void> getAppContacts(List<String> phoneNumbers,
      {bool isRefreshed = false}) async {
    if (state.contactList != null && isRefreshed == false) {
      return;
    }
    emit(
      state.copyWith(
        contactsStatus: ContactsStatus.loading,
      ),
    );
    final response = await _getContactsUseCase.call(phoneNumbers);
    response.fold(
      (l) {
        emit(
          state.copyWith(
            contactsStatus: ContactsStatus.failure,
          ),
        );
        showToast(
          content: ToastMessages.defaultFailureMessage,
          description: ToastMessages.chatContactsFailureMessage,
          type: ToastificationType.error,
        );
      },
      (r) {
        emit(
          state.copyWith(
            contactsStatus: ContactsStatus.success,
            contactList: r,
          ),
        );
      },
    );
  }
}
