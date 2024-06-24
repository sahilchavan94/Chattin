import 'package:chattin/core/utils/app_pallete.dart';
import 'package:chattin/core/utils/app_theme.dart';
import 'package:flutter/material.dart';

class ButtonWidget extends StatelessWidget {
  final String buttonText;
  final VoidCallback onPressed;
  final bool? isLoading;
  const ButtonWidget({
    super.key,
    required this.buttonText,
    required this.onPressed,
    this.isLoading,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: Container(
          height: 45,
          width: double.maxFinite,
          decoration: const BoxDecoration(
            color: AppPallete.blueColor,
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
                      color: AppPallete.whiteColor,
                    ),
                  ),
          ),
        ),
      ),
    );
  }
}
