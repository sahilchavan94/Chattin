import 'package:chattin/core/utils/app_pallete.dart';
import 'package:chattin/core/utils/app_spacing.dart';
import 'package:chattin/core/utils/validators.dart';
import 'package:chattin/core/widgets/button_widget.dart';
import 'package:chattin/core/widgets/input_widget.dart';
import 'package:chattin/features/profile/presentation/cubit/profile_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class EditProfileView extends StatefulWidget {
  const EditProfileView({super.key});

  @override
  State<EditProfileView> createState() => _EditProfileViewState();
}

class _EditProfileViewState extends State<EditProfileView> {
  late TextEditingController _displayNameController;
  late TextEditingController _phoneNoController;
  late TextEditingController _aboutController;
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    final userData = context.read<ProfileCubit>().state.userData!;
    _displayNameController = TextEditingController(text: userData.displayName);
    _phoneNoController = TextEditingController(text: userData.phoneNumber);
    _aboutController = TextEditingController(text: userData.about);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Edit Profile"),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              InputWidget(
                labelText: 'Display Name',
                hintText: "Edit displayname",
                textEditingController: _displayNameController,
                validator: Validators.validateDisplayName,
                fillColor: AppPallete.backgroundColor,
                suffixIcon: const Icon(
                  Icons.person,
                  size: 20,
                ),
              ),
              verticalSpacing(12),
              InputWidget(
                labelText: "Phone",
                hintText: "Edit phone",
                textEditingController: _phoneNoController,
                validator: Validators.validatePhoneNumber,
                suffixIcon: const Icon(
                  Icons.phone,
                  size: 20,
                ),
                fillColor: AppPallete.backgroundColor,
              ),
              verticalSpacing(12),
              InputWidget(
                hintText: "Edit about",
                labelText: "About",
                textEditingController: _aboutController,
                fillColor: AppPallete.backgroundColor,
                validator: (String val) {
                  if (val.isEmpty) {
                    return "About can't be empty";
                  }
                  return null;
                },
                suffixIcon: const Icon(
                  Icons.info,
                  size: 20,
                ),
              ),
              verticalSpacing(25),
              ButtonWidget(
                buttonText: "Update Details",
                isLoading: context.watch<ProfileCubit>().state.profileStatus ==
                    ProfileStatus.loading,
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    context.read<ProfileCubit>().setProfileData(
                          displayName: _displayNameController.text,
                          phoneNumber: _phoneNoController.text,
                          about: _aboutController.text,
                        );
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
