import 'dart:async';

import 'package:chattin/core/utils/app_pallete.dart';
import 'package:chattin/core/utils/app_spacing.dart';
import 'package:chattin/core/utils/app_theme.dart';
import 'package:chattin/core/widgets/button_widget.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:sms_autofill/sms_autofill.dart';

class VerifyOtpView extends StatefulWidget {
  const VerifyOtpView({super.key});

  @override
  State<VerifyOtpView> createState() => _VerifyOtpViewState();
}

class _VerifyOtpViewState extends State<VerifyOtpView> {
  int _start = 30;
  String codeValue = '';

  void startTimer() {
    _start = 30;
    const oneSec = Duration(seconds: 1);
    Timer.periodic(oneSec, (timer) {
      setState(() {
        if (_start < 1) {
          timer.cancel();
        } else {
          _start--;
        }
      });
    });
  }

  void listenCode() async {
    await SmsAutoFill().listenForCode();
  }

  @override
  void initState() {
    startTimer();
    super.initState();
    listenCode();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            context.pop();
          },
          icon: const Icon(
            Icons.arrow_back,
            color: AppPallete.whiteColor,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            verticalSpacing(20),
            Text(
              "Verify OTP",
              style: AppTheme.darkThemeData.textTheme.displayLarge!.copyWith(
                color: AppPallete.blueColor,
              ),
            ),
            Text(
              "A six digit OTP is sent on +91 9922 341 223.",
              style: AppTheme.darkThemeData.textTheme.displaySmall!.copyWith(
                color: AppPallete.whiteColor,
              ),
            ),
            verticalSpacing(46),
            Text(
              "Enter OTP",
              style: AppTheme.darkThemeData.textTheme.displaySmall!.copyWith(
                color: AppPallete.whiteColor,
              ),
            ),
            verticalSpacing(10),
            PinFieldAutoFill(
              decoration: BoxLooseDecoration(
                radius: const Radius.circular(10),
                strokeColorBuilder: const FixedColorBuilder(
                  AppPallete.greyColor,
                ),
                textStyle:
                    AppTheme.darkThemeData.textTheme.displaySmall!.copyWith(
                  color: AppPallete.whiteColor,
                  fontSize: 14,
                ),
              ),
              codeLength: 6,
              currentCode: codeValue,
              onCodeSubmitted: (code) {},
              onCodeChanged: (code) {
                codeValue = code ?? '';
              },
            ),
            verticalSpacing(12),
            ButtonWidget(
              buttonText: 'Verify OTP',
              onPressed: () {},
            ),
            verticalSpacing(12),
            Row(
              children: [
                Text(
                  "00:${_start >= 10 ? _start : "0$_start"}",
                  style:
                      AppTheme.darkThemeData.textTheme.displaySmall!.copyWith(
                    color: AppPallete.whiteColor,
                  ),
                ),
                horizontalSpacing(5),
                Text(
                  "Resend OTP",
                  style:
                      AppTheme.darkThemeData.textTheme.displaySmall!.copyWith(
                    color: _start > 1
                        ? AppPallete.greyColor
                        : AppPallete.whiteColor,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
