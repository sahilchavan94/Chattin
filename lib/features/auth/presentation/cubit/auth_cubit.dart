// ignore: depend_on_referenced_packages
import 'package:bloc/bloc.dart';
import 'package:chattin/core/utils/toasts.dart';
import 'package:chattin/features/auth/domain/usecases/sign_in_with_phone.dart';
import 'package:toastification/toastification.dart';

part 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  final SendOtpOnPhoneUseCase _sendOtpOnPhoneUseCase;
  AuthCubit(
    this._sendOtpOnPhoneUseCase,
  ) : super(AuthState.initial());

  //method for sending otp
  Future<void> sendOtpOnPhone(String phoneNumber) async {
    final response = await _sendOtpOnPhoneUseCase.call(phoneNumber);
    response.fold((l) {
      showToast(
        'sorry',
        'failed',
        ToastificationType.error,
      );
    }, (r) {
      showToast(
        'hello',
        'succeeded',
        ToastificationType.success,
      );
    });
  }
}
