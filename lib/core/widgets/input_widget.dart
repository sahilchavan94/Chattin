import 'package:chattin/core/utils/app_pallete.dart';
import 'package:chattin/core/utils/app_theme.dart';
import 'package:chattin/core/utils/app_spacing.dart';
import 'package:flutter/material.dart';

class InputWidget extends StatelessWidget {
  final String? labelText;
  final String hintText;
  final TextEditingController textEditingController;
  const InputWidget({
    super.key,
    this.labelText,
    required this.hintText,
    required this.textEditingController,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        labelText != null
            ? Text(
                labelText!,
                style: AppTheme.darkThemeData.textTheme.displayLarge!.copyWith(
                  color: AppPallete.whiteColor,
                ),
              )
            : horizontalSpacing(0),
        SizedBox(
          height: 45,
          child: TextFormField(
            controller: textEditingController,
            cursorColor: AppPallete.greyColor,
            style: AppTheme.darkThemeData.textTheme.displaySmall!.copyWith(
              color: AppPallete.greyColor,
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
                borderRadius: BorderRadius.circular(10),
                borderSide: const BorderSide(
                  color: AppPallete.greyColor,
                ),
              ),
              focusedBorder: OutlineInputBorder(
                gapPadding: 15,
                borderRadius: BorderRadius.circular(10),
                borderSide: const BorderSide(
                  color: AppPallete.greyColor,
                ),
              ),
              enabledBorder: OutlineInputBorder(
                gapPadding: 15,
                borderRadius: BorderRadius.circular(10),
                borderSide: const BorderSide(
                  color: AppPallete.greyColor,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
