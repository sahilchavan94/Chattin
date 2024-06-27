import 'package:chattin/core/utils/app_pallete.dart';
import 'package:chattin/core/utils/app_theme.dart';
import 'package:chattin/core/utils/app_spacing.dart';
import 'package:flutter/material.dart';

class InputWidget extends StatelessWidget {
  final String? labelText;
  final String hintText;
  final TextEditingController textEditingController;
  final Widget? suffixIcon;
  final VoidCallback? onSuffixIconPressed;
  const InputWidget({
    super.key,
    this.labelText,
    required this.hintText,
    required this.textEditingController,
    this.suffixIcon,
    this.onSuffixIconPressed,
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
          height: 45,
          child: TextFormField(
            controller: textEditingController,
            cursorColor: AppPallete.greyColor,
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
