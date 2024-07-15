// ignore_for_file: use_build_context_synchronously

import 'package:chattin/core/router/route_path.dart';
import 'package:chattin/core/utils/app_pallete.dart';
import 'package:chattin/core/utils/app_spacing.dart';
import 'package:chattin/core/utils/app_theme.dart';
import 'package:chattin/core/utils/picker.dart';
import 'package:chattin/core/widgets/bottom_sheet_for_image.dart';
import 'package:chattin/core/widgets/confirmation_dialog.dart';
import 'package:chattin/core/widgets/failure_widget.dart';
import 'package:chattin/core/widgets/image_widget.dart';
import 'package:chattin/features/profile/presentation/cubit/profile_cubit.dart';
import 'package:chattin/features/profile/presentation/widgets/profile_details_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';

class ProfileView extends StatefulWidget {
  const ProfileView({super.key});

  @override
  State<ProfileView> createState() => _ProfileViewState();
}

class _ProfileViewState extends State<ProfileView> {
  @override
  void initState() {
    context.read<ProfileCubit>().getProfileData();
    super.initState();
  }

  Future<void> _selectImage(ImageSource imageSource) async {
    final pickedImage = await Picker.pickImage(imageSource);
    if (pickedImage != null) {
      showDialog(
        context: context,
        builder: (context) {
          return DialogWidget(
            onPressed: () {
              context.pop();
              context.read<ProfileCubit>().setProfileImage(
                    imageFile: pickedImage,
                    isRemoving: false,
                  );
            },
            approvalText: 'Update',
            rejectionText: 'Cancel',
            title: 'Update profile image',
            description:
                'Continue if you are confimed to change your profile picture',
          );
        },
      );
    }
  }

  final _customAppBarTheme = AppBarTheme(
    backgroundColor: AppPallete.bottomSheetColor.withOpacity(.5),
    surfaceTintColor: AppPallete.bottomSheetColor.withOpacity(.5),
    titleTextStyle: const TextStyle(
      fontSize: 20,
      fontWeight: FontWeight.normal,
      color: AppPallete.whiteColor,
    ),
    elevation: 0,
    iconTheme: const IconThemeData(
      color: AppPallete.whiteColor,
    ),
  );

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: Theme.of(context).copyWith(
        appBarTheme: _customAppBarTheme,
      ),
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Profile"),
          centerTitle: true,
        ),
        body: BlocBuilder<ProfileCubit, ProfileState>(
          builder: (context, state) {
            if (state.profileStatus == ProfileStatus.loading) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
            if (state.profileStatus == ProfileStatus.failure) {
              return const FailureWidget();
            }
            if (state.profileStatus == ProfileStatus.success) {
              final userData = state.userData!;

              return SingleChildScrollView(
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        AppPallete.bottomSheetColor.withOpacity(.5),
                        AppPallete.backgroundColor,
                        AppPallete.backgroundColor,
                        AppPallete.backgroundColor,
                        AppPallete.backgroundColor,
                        AppPallete.backgroundColor,
                      ],
                    ),
                  ),
                  child: Center(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(4.0),
                                child: GestureDetector(
                                  onTap: () {
                                    context.push(
                                      RoutePath.imageView.path,
                                      extra: {
                                        'imageUrl': state.userData!.imageUrl,
                                        'displayName': 'Your Profile',
                                      },
                                    );
                                  },
                                  child: Stack(
                                    alignment: Alignment.bottomRight,
                                    children: [
                                      userData.imageUrl.isEmpty
                                          ? ImageWidget(
                                              imagePath:
                                                  'assets/images/default_profile.png',
                                              width: 100,
                                            )
                                          : ImageWidget(
                                              imagePath: userData.imageUrl,
                                              width: 100,
                                              height: 100,
                                              radius:
                                                  BorderRadius.circular(100),
                                              fit: BoxFit.cover,
                                              isImageFromChat: true,
                                            ),
                                      Positioned(
                                        bottom: -15,
                                        child: IconButton(
                                          onPressed: () {
                                            showBottomSheetForPickingImage(
                                              askForConfirmation: true,
                                              context: context,
                                              isRemovable:
                                                  userData.imageUrl.isNotEmpty,
                                              title: "Update profile picture",
                                              subTitle:
                                                  "You can update your profile picture in few easy steps",
                                              onClick1: () {
                                                context.pop();
                                                _selectImage(
                                                  ImageSource.camera,
                                                );
                                              },
                                              onClick2: () {
                                                context.pop();
                                                _selectImage(
                                                  ImageSource.gallery,
                                                );
                                              },
                                              onClick3: () {
                                                context.pop();
                                                showDialog(
                                                  context: context,
                                                  builder: (context) {
                                                    return DialogWidget(
                                                      onPressed: () {
                                                        context.pop();
                                                        context
                                                            .read<
                                                                ProfileCubit>()
                                                            .setProfileImage();
                                                      },
                                                      approvalText: 'Remove',
                                                      rejectionText: 'Cancel',
                                                      title:
                                                          'Remove profile image',
                                                      description:
                                                          'Continue if you are confirmed to remove your profile image',
                                                    ).animate().fadeIn();
                                                  },
                                                );
                                              },
                                            );
                                          },
                                          icon: const Icon(
                                            Icons.camera_alt,
                                            size: 25,
                                          ),
                                          color: AppPallete.blueColor,
                                          iconSize: 30,
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                              horizontalSpacing(20),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    userData.displayName,
                                    style: AppTheme
                                        .darkThemeData.textTheme.displayLarge!
                                        .copyWith(
                                      color: AppPallete.blueColor,
                                    ),
                                  ),
                                  Text(
                                    userData.about!,
                                    style: AppTheme
                                        .darkThemeData.textTheme.displaySmall!
                                        .copyWith(
                                      color: AppPallete.greyColor,
                                    ),
                                  ),
                                  Text(
                                    "+${userData.phoneCode!}${userData.phoneNumber!}",
                                    style: AppTheme
                                        .darkThemeData.textTheme.displaySmall!
                                        .copyWith(
                                      color: AppPallete.greyColor,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          verticalSpacing(50),
                          ProfileDetailsWidget(
                            title: 'Profile Information',
                            icon: const Icon(
                              Icons.edit,
                              color: AppPallete.whiteColor,
                            ),
                            userData: userData,
                          ),
                          verticalSpacing(35),
                          Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              "App Settings",
                              style: AppTheme
                                  .darkThemeData.textTheme.displayLarge!
                                  .copyWith(
                                color: AppPallete.whiteColor,
                                fontSize: 16,
                              ),
                            ),
                          ),
                          verticalSpacing(25),
                          userInfo(
                            'Theme mode',
                            'Dark',
                            const Icon(
                              Icons.dark_mode,
                              color: AppPallete.greyColor,
                              size: 20,
                            ),
                            null,
                          ),
                          userInfo(
                            'Account settings',
                            '',
                            const Icon(
                              Icons.settings,
                              color: AppPallete.greyColor,
                              size: 20,
                            ),
                            const Icon(
                              Icons.arrow_forward,
                              weight: .1,
                              color: AppPallete.whiteColor,
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              );
            }
            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }
}
