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
  final Color? fillColor;
  final Color? textColor;
  final double? borderRadius;
  final bool? showBorder;
  final int? maxLines;
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
    this.fillColor,
    this.borderRadius,
    this.showBorder,
    this.maxLines,
    this.textColor,
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
            maxLines: 1,
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
              color: textColor ?? AppPallete.whiteColor,
              fontSize: 14,
            ),
            decoration: InputDecoration(
              hintText: hintText,
              filled: true,
              fillColor: fillColor,
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 18,
              ),
              hintStyle:
                  AppTheme.darkThemeData.textTheme.displaySmall!.copyWith(
                color: AppPallete.greyColor,
              ),
              border: showBorder == null
                  ? OutlineInputBorder(
                      borderRadius: BorderRadius.circular(borderRadius ?? 6),
                      borderSide: const BorderSide(
                        color: AppPallete.greyColor,
                      ),
                    )
                  : noBorder,
              focusedBorder: showBorder == null
                  ? OutlineInputBorder(
                      borderRadius: BorderRadius.circular(borderRadius ?? 6),
                      borderSide: const BorderSide(
                        color: AppPallete.greyColor,
                      ),
                    )
                  : noBorder,
              enabledBorder: showBorder == null
                  ? OutlineInputBorder(
                      borderRadius: BorderRadius.circular(borderRadius ?? 6),
                      borderSide: const BorderSide(
                        color: AppPallete.greyColor,
                      ),
                    )
                  : noBorder,
              errorBorder: showBorder == null
                  ? OutlineInputBorder(
                      borderRadius: BorderRadius.circular(borderRadius ?? 6),
                      borderSide: const BorderSide(
                        color: AppPallete.errorColor,
                      ),
                    )
                  : noBorder,
              focusedErrorBorder: showBorder == null
                  ? OutlineInputBorder(
                      borderRadius: BorderRadius.circular(borderRadius ?? 6),
                      borderSide: const BorderSide(
                        color: AppPallete.errorColor,
                      ),
                    )
                  : noBorder,
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

OutlineInputBorder noBorder = OutlineInputBorder(
  borderRadius: BorderRadius.circular(60),
  borderSide: BorderSide.none,
);
