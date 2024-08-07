import 'package:chattin/core/utils/app_pallete.dart';
import 'package:chattin/core/utils/app_spacing.dart';
import 'package:chattin/core/utils/app_theme.dart';
import 'package:chattin/core/widgets/button_widget.dart';
import 'package:chattin/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class DeleteAccountWidget extends StatelessWidget {
  final String uid;
  const DeleteAccountWidget({
    super.key,
    required this.uid,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Icon(
                Icons.delete_forever,
                size: 30,
                color: AppPallete.blueColor,
              ),
              horizontalSpacing(10),
              Text(
                "Delete Account",
                style: AppTheme.darkThemeData.textTheme.displayLarge!.copyWith(
                  color: AppPallete.blueColor,
                ),
              ),
            ],
          ),
          verticalSpacing(5),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 5),
            child: Text(
              "Are you sure you want to delete your account? This action cannot be undone. All your data, including messages, contacts, and profile information, will be permanently deleted.",
              style: AppTheme.darkThemeData.textTheme.displaySmall!.copyWith(
                color: AppPallete.greyColor,
              ),
              maxLines: 4,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          verticalSpacing(30),
          ButtonWidget(
            buttonText: "Delete",
            isLoading: context.watch<AuthCubit>().state.authWorkingStatus ==
                AuthWorkingStatus.loading,
            onPressed: () {
              context.read<AuthCubit>().deleteAccount(uid);
            },
            color: AppPallete.errorColor,
          ),
        ],
      ),
    );
  }
}
