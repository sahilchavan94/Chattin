import 'dart:io';

import 'package:chattin/core/utils/app_pallete.dart';
import 'package:chattin/core/utils/app_spacing.dart';
import 'package:chattin/core/utils/app_theme.dart';
import 'package:chattin/core/utils/picker.dart';
import 'package:chattin/core/widgets/bottom_sheet_for_image.dart';
import 'package:chattin/core/widgets/button_widget.dart';
import 'package:chattin/core/widgets/image_widget.dart';
import 'package:chattin/core/widgets/input_widget.dart';
import 'package:chattin/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:country_picker/country_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';

class CreateProfileView extends StatefulWidget {
  const CreateProfileView({super.key});

  @override
  State<CreateProfileView> createState() => _CreateProfileViewState();
}

class _CreateProfileViewState extends State<CreateProfileView> {
  final TextEditingController _displayNameController = TextEditingController();
  final TextEditingController _phoneNumberController = TextEditingController();
  String selectedCountry = '91';
  File? selectedImage;

  Future<void> selectImage(ImageSource imageSource) async {
    final pickedImage = await Picker.pickImage(imageSource);
    if (pickedImage != null) {
      setState(() {
        selectedImage = pickedImage;
      });
      return;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              verticalSpacing(50),
              Stack(
                clipBehavior: Clip.none,
                alignment: Alignment.bottomRight,
                children: [
                  selectedImage == null
                      ? ImageWidget(
                          imagePath: 'assets/images/default_profile.png',
                          width: 120,
                        )
                      : ClipRRect(
                          borderRadius: BorderRadius.circular(60),
                          child: Image.file(
                            selectedImage!,
                            width: 120,
                            height: 120,
                            fit: BoxFit.cover,
                          ),
                        ),
                  Positioned(
                    bottom: -10,
                    child: IconButton(
                      onPressed: () {
                        showBottomSheetForPickingImage(
                          context,
                          () {
                            context.pop();
                            selectImage(ImageSource.camera);
                          },
                          () {
                            context.pop();
                            selectImage(ImageSource.gallery);
                          },
                        );
                      },
                      icon: const Icon(
                        Icons.camera_alt,
                      ),
                      color: AppPallete.blueColor,
                      iconSize: 30,
                    ),
                  )
                ],
              ),
              verticalSpacing(26),
              InputWidget(
                hintText: 'Enter your display name e.g John Doe',
                labelText: 'Display name',
                textEditingController: _displayNameController,
                suffixIcon: const Icon(Icons.person),
              ),
              verticalSpacing(12),
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "Phone Number",
                  style:
                      AppTheme.darkThemeData.textTheme.displaySmall!.copyWith(
                    color: AppPallete.whiteColor,
                  ),
                ),
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  GestureDetector(
                    onTap: () {
                      showCountryPicker(
                        context: context,
                        countryListTheme: CountryListThemeData(
                          textStyle: AppTheme
                              .darkThemeData.textTheme.displaySmall!
                              .copyWith(
                            color: AppPallete.whiteColor,
                          ),
                          borderRadius: BorderRadius.circular(6),
                          backgroundColor: AppPallete.bottomSheetColor,
                          bottomSheetHeight: context.size!.height * .75,
                          searchTextStyle: AppTheme
                              .darkThemeData.textTheme.displaySmall!
                              .copyWith(
                            color: AppPallete.whiteColor,
                          ),
                          inputDecoration: InputDecoration(
                            hintText: "Search for your country",
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 18,
                            ),
                            hintStyle: AppTheme
                                .darkThemeData.textTheme.displaySmall!
                                .copyWith(
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
                          ),
                        ),
                        showPhoneCode:
                            true, // optional. Shows phone code before the country name.
                        onSelect: (Country country) {
                          setState(() {
                            selectedCountry = country.phoneCode;
                          });
                        },
                      );
                    },
                    child: Container(
                      width: 55,
                      height: 45,
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: AppPallete.greyColor,
                        ),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Center(
                        child: Text(
                          "+$selectedCountry",
                          style: AppTheme.darkThemeData.textTheme.displaySmall!
                              .copyWith(
                            color: AppPallete.whiteColor,
                          ),
                        ),
                      ),
                    ),
                  ),
                  horizontalSpacing(6),
                  Expanded(
                    child: InputWidget(
                      hintText: 'Enter your 10 digit phone number ',
                      textEditingController: _phoneNumberController,
                      suffixIcon: const Icon(Icons.phone),
                    ),
                  ),
                ],
              ),
              verticalSpacing(20),
              ButtonWidget(
                buttonText: 'Finish',
                isLoading: context.watch<AuthCubit>().state.authStatus ==
                    AuthStatus.loading,
                onPressed: () {
                  context.read<AuthCubit>().setAccountDetails(
                        displayName: _displayNameController.text,
                        phoneNumber: _phoneNumberController.text.trim(),
                        phoneCode: selectedCountry,
                        imageFile: selectedImage!,
                      );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
