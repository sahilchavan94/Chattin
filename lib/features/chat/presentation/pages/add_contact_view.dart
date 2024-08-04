import 'package:chattin/core/utils/app_pallete.dart';
import 'package:chattin/core/utils/app_spacing.dart';
import 'package:chattin/core/utils/validators.dart';
import 'package:chattin/core/widgets/button_widget.dart';
import 'package:chattin/core/widgets/input_widget.dart';
import 'package:chattin/features/profile/presentation/cubit/profile_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AddContactView extends StatefulWidget {
  const AddContactView({super.key});

  @override
  State<AddContactView> createState() => _AddContactViewState();
}

class _AddContactViewState extends State<AddContactView> {
  final TextEditingController _phoneNoController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("New contact"),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                InputWidget(
                  labelText: "Phone",
                  hintText: "Enter a valid 10 digit phone number",
                  textEditingController: _phoneNoController,
                  validator: Validators.validatePhoneNumber,
                  suffixIcon: const Icon(
                    Icons.phone,
                    size: 20,
                  ),
                  fillColor: AppPallete.backgroundColor,
                ),
                verticalSpacing(12),
                ButtonWidget(
                  buttonText: "Add contact",
                  isLoading:
                      context.watch<ProfileCubit>().state.profileStatus ==
                          ProfileStatus.loading,
                  onPressed: () {},
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
