import 'package:chattin/core/utils/app_pallete.dart';
import 'package:flutter/material.dart';

class AppTheme {
  static ThemeData darkThemeData = ThemeData(
    //background color
    scaffoldBackgroundColor: AppPallete.backgroundColor,

    //app bar
    appBarTheme: const AppBarTheme(
      titleTextStyle: TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.normal,
      ),
      backgroundColor: AppPallete.backgroundColor,
      surfaceTintColor: AppPallete.backgroundColor,
      elevation: .5,
      iconTheme: IconThemeData(
        color: AppPallete.whiteColor,
      ),
    ),

    //bottom sheet
    bottomSheetTheme: const BottomSheetThemeData(
      backgroundColor: AppPallete.bottomSheetColor,
      surfaceTintColor: AppPallete.bottomSheetColor,
    ),

    fontFamily: 'Inter',
    //text theme
    textTheme: const TextTheme(
      displayLarge: TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.w400,
      ),
      displaySmall: TextStyle(
        fontSize: 12,
        fontWeight: FontWeight.w400,
      ),
    ),

    //text selection
    textSelectionTheme: const TextSelectionThemeData(
      selectionHandleColor: AppPallete.greyColor,
    ),

    //loader
    progressIndicatorTheme: const ProgressIndicatorThemeData(
      color: AppPallete.blueColor,
    ),

    //snackbar
    snackBarTheme: const SnackBarThemeData(
      contentTextStyle: TextStyle(
        color: AppPallete.whiteColor,
        fontSize: 12,
      ),
      showCloseIcon: true,
      backgroundColor: AppPallete.bottomSheetColor,
      closeIconColor: Colors.red,
      insetPadding: EdgeInsets.all(8),
    ),
  );
}
