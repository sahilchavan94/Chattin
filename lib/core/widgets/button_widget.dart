import 'package:chattin/core/utils/app_pallete.dart';
import 'package:chattin/core/utils/app_theme.dart';
import 'package:flutter/material.dart';

class ButtonWidget extends StatelessWidget {
  final String buttonText;
  final double? width;
  final double? height;
  final VoidCallback onPressed;
  final bool? isLoading;
  final Color? color;
  final Color? textColor;
  const ButtonWidget({
    super.key,
    required this.buttonText,
    required this.onPressed,
    this.isLoading,
    this.color,
    this.textColor,
    this.width,
    this.height,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (isLoading != null && isLoading == true) {
          return;
        }
        onPressed();
      },
      child: ClipRRect(
        borderRadius: BorderRadius.circular(6),
        child: Container(
          height: height ?? 45,
          width: width ?? double.maxFinite,
          decoration: BoxDecoration(
            color: color ?? AppPallete.blueColor,
          ),
          child: Center(
            child: isLoading != null && isLoading == true
                ? const SizedBox(
                    height: 23,
                    width: 23,
                    child: CircularProgressIndicator(),
                  )
                : Text(
                    buttonText,
                    style:
                        AppTheme.darkThemeData.textTheme.displaySmall!.copyWith(
                      color: textColor ?? AppPallete.whiteColor,
                    ),
                  ),
          ),
        ),
      ),
    );
  }
}
