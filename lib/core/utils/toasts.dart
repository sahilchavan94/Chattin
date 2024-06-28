import 'package:chattin/core/utils/app_pallete.dart';
import 'package:chattin/core/utils/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:toastification/toastification.dart';

void showToast({
  required String content,
  String? description,
  required ToastificationType type,
}) {
  toastification.show(
    type: ToastificationType.success,
    style: ToastificationStyle.fillColored,
    autoCloseDuration: const Duration(seconds: 5),
    title: Padding(
      padding: const EdgeInsets.only(left: 5.0),
      child: Text(
        content,
        style: AppTheme.darkThemeData.textTheme.displaySmall!.copyWith(
          color: AppPallete.whiteColor,
          fontSize: 14,
        ),
      ),
    ),
    description: description == null
        ? null
        : Padding(
            padding: const EdgeInsets.only(left: 5.0),
            child: Text(
              description,
              style: AppTheme.darkThemeData.textTheme.displaySmall!.copyWith(
                color: const Color.fromARGB(255, 196, 196, 196),
                fontSize: 12,
              ),
            ),
          ),
    alignment: Alignment.topCenter,
    direction: TextDirection.ltr,
    animationDuration: const Duration(milliseconds: 300),

    icon: type == ToastificationType.success
        ? const Icon(
            Icons.check_circle_outline,
            color: AppPallete.whiteColor,
          )
        : const Icon(
            Icons.cancel_outlined,
            color: AppPallete.whiteColor,
          ),
    primaryColor: type == ToastificationType.success
        ? AppPallete.successColor
        : AppPallete.errorColor,
    backgroundColor: type == ToastificationType.success
        ? AppPallete.successColor
        : AppPallete.errorColor,

    foregroundColor: Colors.white,
    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
    margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
    borderRadius: BorderRadius.circular(12),
    boxShadow: const [
      BoxShadow(
        color: Color(0x07000000),
        blurRadius: 16,
        offset: Offset(0, 16),
        spreadRadius: 0,
      )
    ],
    showProgressBar: false,
    closeButtonShowType: CloseButtonShowType.always,
    closeOnClick: false,
    pauseOnHover: true,
    dragToClose: true,
    applyBlurEffect: true,
    borderSide: BorderSide.none,
    // callbacks: ToastificationCallbacks(
    //   onTap: (toastItem) => print('Toast ${toastItem.id} tapped'),
    //   onCloseButtonTap: (toastItem) => print('Toast ${toastItem.id} close button tapped'),
    //   onAutoCompleteCompleted: (toastItem) => print('Toast ${toastItem.id} auto complete completed'),
    //   onDismissed: (toastItem) => print('Toast ${toastItem.id} dismissed'),
    // ),
  );
}
