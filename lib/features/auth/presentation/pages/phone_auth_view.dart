import 'package:chattin/core/utils/app_pallete.dart';
import 'package:chattin/core/utils/app_spacing.dart';
import 'package:chattin/core/utils/app_theme.dart';
import 'package:chattin/core/widgets/button_widget.dart';
import 'package:chattin/core/widgets/input_widget.dart';
import 'package:chattin/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:country_picker/country_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class PhoneAuthView extends StatefulWidget {
  const PhoneAuthView({super.key});

  @override
  State<PhoneAuthView> createState() => _PhoneAuthViewState();
}

class _PhoneAuthViewState extends State<PhoneAuthView> {
  final TextEditingController _phoneController = TextEditingController();
  String selectedCountyCode = "91";

  @override
  void dispose() {
    _phoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            verticalSpacing(100),
            Text(
              "Enter your phone number",
              style: AppTheme.darkThemeData.textTheme.displayLarge!.copyWith(
                color: AppPallete.blueColor,
              ),
            ),
            Text(
              "You will receive a 6 digit code on your entered phone number.",
              style: AppTheme.darkThemeData.textTheme.displaySmall!.copyWith(
                color: AppPallete.whiteColor,
              ),
            ),
            verticalSpacing(46),
            Text(
              "Phone Number",
              style: AppTheme.darkThemeData.textTheme.displaySmall!.copyWith(
                color: AppPallete.whiteColor,
              ),
            ),
            verticalSpacing(10),
            Row(
              children: [
                GestureDetector(
                  onTap: () {
                    showCountryPicker(
                      context: context,
                      showPhoneCode: true,
                      useSafeArea: true,
                      countryListTheme: CountryListThemeData(
                        textStyle: AppTheme
                            .darkThemeData.textTheme.displaySmall!
                            .copyWith(
                          color: AppPallete.whiteColor,
                        ),
                        bottomSheetHeight: context.size!.height * .6,
                        backgroundColor: AppPallete.bottomSheetColor,
                        borderRadius: BorderRadius.circular(10),
                        searchTextStyle: AppTheme
                            .darkThemeData.textTheme.displaySmall!
                            .copyWith(
                          color: AppPallete.greyColor,
                        ),
                        inputDecoration: InputDecoration(
                          hintText: 'Search for your country',
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 18,
                          ),
                          hintStyle: AppTheme
                              .darkThemeData.textTheme.displaySmall!
                              .copyWith(
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
                      onSelect: (Country country) {
                        setState(() {
                          selectedCountyCode = country.phoneCode;
                        });
                      },
                    );
                  },
                  child: Container(
                    height: 45,
                    width: 58,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                        color: AppPallete.greyColor,
                      ),
                    ),
                    child: Center(
                      child: Text(
                        "+$selectedCountyCode",
                        style: AppTheme.darkThemeData.textTheme.displaySmall!
                            .copyWith(
                          color: AppPallete.greyColor,
                        ),
                      ),
                    ),
                  ),
                ),
                horizontalSpacing(5),
                Expanded(
                  child: InputWidget(
                    textEditingController: _phoneController,
                    hintText: "Enter your phone number",
                  ),
                ),
              ],
            ),
            verticalSpacing(12),
            ButtonWidget(
              buttonText: 'Get OTP',
              onPressed: () {
                if (selectedCountyCode.isEmpty ||
                    _phoneController.text.trim().length != 10) {
                  return;
                }
                context.read<AuthCubit>().sendOtpOnPhone(
                      "+$selectedCountyCode${_phoneController.text}",
                    );
              },
            ),
          ],
        ),
      ),
    );
  }
}
