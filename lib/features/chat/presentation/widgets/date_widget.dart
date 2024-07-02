import 'package:chattin/core/utils/app_pallete.dart';
import 'package:chattin/core/utils/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class DateWidget extends StatelessWidget {
  final DateTime timeSent;
  const DateWidget({
    super.key,
    required this.timeSent,
  });

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.center,
      child: Container(
        width: 130,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(6),
          color: AppPallete.blueColor.withOpacity(.1),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 6),
        margin: const EdgeInsets.symmetric(vertical: 30),
        child: Center(
          child: Text(
            DateFormat('dd MMMM yyyy').format(timeSent),
            style: AppTheme.darkThemeData.textTheme.displaySmall!.copyWith(
              color: AppPallete.greyColor,
              fontSize: 10,
            ),
          ),
        ),
      ),
    );
  }
}
