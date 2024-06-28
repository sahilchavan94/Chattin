import 'package:chattin/core/utils/app_pallete.dart';
import 'package:chattin/core/utils/app_theme.dart';
import 'package:chattin/core/utils/app_spacing.dart';
import 'package:flutter/material.dart';

class InputWidget extends StatelessWidget {
  final String? labelText;
  final String hintText;
  final TextEditingController textEditingController;
  final Widget? suffixIcon;
  final double? height;
  final TextEditingController? passwordController;
  final VoidCallback? onSuffixIconPressed;
  final Function(String val) validator;
  const InputWidget({
    super.key,
    this.labelText,
    required this.hintText,
    required this.textEditingController,
    this.suffixIcon,
    this.onSuffixIconPressed,
    required this.validator,
    this.height,
    this.passwordController,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        labelText != null
            ? Text(
                labelText!,
                style: AppTheme.darkThemeData.textTheme.displaySmall!.copyWith(
                  color: AppPallete.whiteColor,
                ),
              )
            : horizontalSpacing(0),
        verticalSpacing(7),
        SizedBox(
          height: height,
          child: TextFormField(
            controller: textEditingController,
            validator: (val) {
              if (passwordController != null &&
                  passwordController!.text != textEditingController.text) {
                return "Passwords do not match";
              }
              return validator(textEditingController.text);
            },
            autovalidateMode: AutovalidateMode.onUserInteraction,
            cursorColor: AppPallete.greyColor,
            cursorErrorColor: AppPallete.errorColor.withOpacity(.45),
            style: AppTheme.darkThemeData.textTheme.displaySmall!.copyWith(
              color: AppPallete.whiteColor,
              fontSize: 14,
            ),
            decoration: InputDecoration(
              hintText: hintText,
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 18,
              ),
              hintStyle:
                  AppTheme.darkThemeData.textTheme.displaySmall!.copyWith(
                color: AppPallete.greyColor,
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(6),
                borderSide: const BorderSide(
                  color: AppPallete.greyColor,
                ),
              ),
              focusedBorder: OutlineInputBorder(
                gapPadding: 15,
                borderRadius: BorderRadius.circular(6),
                borderSide: const BorderSide(
                  color: AppPallete.greyColor,
                ),
              ),
              enabledBorder: OutlineInputBorder(
                gapPadding: 15,
                borderRadius: BorderRadius.circular(6),
                borderSide: const BorderSide(
                  color: AppPallete.greyColor,
                ),
              ),
              errorBorder: OutlineInputBorder(
                gapPadding: 15,
                borderRadius: BorderRadius.circular(6),
                borderSide: BorderSide(
                  color: AppPallete.errorColor.withOpacity(.45),
                ),
              ),
              focusedErrorBorder: OutlineInputBorder(
                gapPadding: 15,
                borderRadius: BorderRadius.circular(6),
                borderSide: BorderSide(
                  color: AppPallete.errorColor.withOpacity(.45),
                ),
              ),
              errorStyle:
                  AppTheme.darkThemeData.textTheme.displaySmall!.copyWith(
                color: AppPallete.errorColor,
              ),
              errorMaxLines: 3,
              suffixIcon: GestureDetector(
                onTap: onSuffixIconPressed,
                child: suffixIcon,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
