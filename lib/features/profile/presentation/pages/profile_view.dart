import 'package:chattin/core/utils/app_pallete.dart';
import 'package:chattin/core/utils/app_spacing.dart';
import 'package:chattin/core/utils/app_theme.dart';
import 'package:chattin/core/widgets/image_widget.dart';
import 'package:chattin/features/profile/presentation/cubit/profile_cubit.dart';
import 'package:chattin/features/profile/presentation/widgets/profile_details_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<ProfileCubit, ProfileState>(
        builder: (context, state) {
          if (state.profileStatus == ProfileStatus.loading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          if (state.profileStatus == ProfileStatus.failure) {
            return const Text(
              "failure",
            );
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
                      AppPallete.blueColor.withOpacity(.8),
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
                        const SafeArea(
                          child: Align(
                            alignment: Alignment.topLeft,
                            child: BackButton(
                              color: AppPallete.whiteColor,
                            ),
                          ),
                        ),
                        verticalSpacing(15),
                        Padding(
                          padding: const EdgeInsets.all(4.0),
                          child: ImageWidget(
                            imagePath: userData.imageUrl,
                            width: 100,
                            height: 100,
                            radius: BorderRadius.circular(100),
                            fit: BoxFit.cover,
                          ),
                        ),
                        verticalSpacing(10),
                        Text(
                          userData.displayName,
                          style: AppTheme.darkThemeData.textTheme.displayLarge!
                              .copyWith(
                            color: AppPallete.blueColor,
                          ),
                        ),
                        Text(
                          userData.about!,
                          style: AppTheme.darkThemeData.textTheme.displaySmall!
                              .copyWith(
                            color: AppPallete.greyColor,
                          ),
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
                          ),
                          null,
                        ),
                        userInfo(
                          'Account settings',
                          '',
                          const Icon(
                            Icons.settings,
                            color: AppPallete.greyColor,
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
    );
  }
}
