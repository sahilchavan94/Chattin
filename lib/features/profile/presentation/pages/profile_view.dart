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
import 'package:chattin/core/widgets/user_info.dart';
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
  Future<void> _selectImage(ImageSource imageSource) async {
    final pickedImage = await Picker.pickImage(imageSource);
    if (pickedImage != null) {
      showDialog(
        context: context,
        builder: (context) {
          return ConfirmationDialogWidget(
            onPressed: () {
              context.pop();
              context.read<ProfileCubit>().setProfileImage(
                    imageFile: pickedImage,
                    isRemoving: false,
                  );
            },
            approvalText: 'Update',
            rejectionText: 'Discard',
            title: 'Update profile image',
            description:
                'Continue if you are confimed to change the display picture from your profile',
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
            if (state.profileStatus == ProfileStatus.loading ||
                state.setProfileStatus == SetProfileStatus.loading) {
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
                                      state.setProfileImageStatus ==
                                              SetProfileImageStatus.loading
                                          ? Container(
                                              width: 100,
                                              height: 100,
                                              decoration: BoxDecoration(
                                                color:
                                                    AppPallete.bottomSheetColor,
                                                borderRadius:
                                                    BorderRadius.circular(50),
                                              ),
                                              padding: const EdgeInsets.all(30),
                                              child:
                                                  const CircularProgressIndicator(),
                                            )
                                          : Hero(
                                              tag: userData.imageUrl,
                                              child: Material(
                                                type: MaterialType.transparency,
                                                child: ImageWidget(
                                                  imagePath: userData
                                                          .imageUrl.isEmpty
                                                      ? 'assets/images/default_profile.png'
                                                      : userData.imageUrl,
                                                  width: 100,
                                                  height: 100,
                                                  radius: BorderRadius.circular(
                                                      100),
                                                  fit: BoxFit.cover,
                                                  isImageFromChat: true,
                                                ),
                                              ),
                                            ),
                                      if (state.isImageLoading != null &&
                                          !state.isImageLoading!)
                                        Positioned(
                                          bottom: -15,
                                          child: IconButton(
                                            onPressed: () {
                                              showBottomSheetForPickingImage(
                                                askForConfirmation: true,
                                                context: context,
                                                isRemovable: userData
                                                    .imageUrl.isNotEmpty,
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
                                                      return ConfirmationDialogWidget(
                                                        onPressed: () {
                                                          context.pop();
                                                          context
                                                              .read<
                                                                  ProfileCubit>()
                                                              .setProfileImage();
                                                        },
                                                        approvalText: 'Remove',
                                                        rejectionText:
                                                            'Discard',
                                                        title:
                                                            'Remove profile image',
                                                        description:
                                                            'Continue if you are confirmed to remove the display picture from your profile',
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
                                      color: AppPallete.whiteColor,
                                    ),
                                  ),
                                  Text(
                                    "+${userData.phoneCode!}${userData.phoneNumber!}",
                                    style: AppTheme
                                        .darkThemeData.textTheme.displaySmall!
                                        .copyWith(
                                      color: AppPallete.whiteColor,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          verticalSpacing(50),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: ProfileDetailsWidget(
                              title: 'Profile Information',
                              icon: const Icon(
                                Icons.edit,
                                color: AppPallete.whiteColor,
                                size: 19,
                              ),
                              userData: userData,
                            ),
                          ),
                          verticalSpacing(30),
                          Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8.0,
                            ),
                            child: Align(
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
                          ),
                          verticalSpacing(25),
                          Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8.0,
                            ),
                            child: userInfo(
                              'Theme mode',
                              const Icon(
                                Icons.dark_mode,
                                color: AppPallete.greyColor,
                                size: 20,
                              ),
                              const Icon(
                                Icons.arrow_forward,
                                size: 20,
                                color: AppPallete.greyColor,
                              ),
                            ),
                          ),
                          verticalSpacing(5),
                          Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8.0,
                            ),
                            child: userInfo(
                              'Account settings',
                              const Icon(
                                Icons.settings,
                                color: AppPallete.greyColor,
                                size: 20,
                              ),
                              GestureDetector(
                                onTap: () {
                                  context.push(RoutePath.accountSettings.path);
                                },
                                child: const Icon(
                                  Icons.arrow_forward,
                                  size: 20,
                                  color: AppPallete.whiteColor,
                                ),
                              ),
                            ),
                          ),
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
