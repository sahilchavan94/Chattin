import 'package:chattin/core/utils/app_pallete.dart';
import 'package:chattin/core/utils/app_spacing.dart';
import 'package:chattin/core/utils/app_theme.dart';
import 'package:chattin/core/utils/validators.dart';
import 'package:chattin/core/widgets/button_widget.dart';
import 'package:chattin/core/widgets/input_widget.dart';
import 'package:chattin/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:chattin/features/auth/presentation/widgets/delete_account_widget.dart';
import 'package:chattin/features/profile/presentation/cubit/profile_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class DeleteAccountView extends StatefulWidget {
  const DeleteAccountView({super.key});

  @override
  State<DeleteAccountView> createState() => _DeleteAccountViewState();
}

class _DeleteAccountViewState extends State<DeleteAccountView> {
  late TextEditingController _emailController;
  final TextEditingController _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    final currentUserEmail = context.read<ProfileCubit>().state.userData!.email;
    _emailController = TextEditingController(text: currentUserEmail);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Delete Account"),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Prove us that it’s you",
                style: AppTheme.darkThemeData.textTheme.displayMedium!.copyWith(
                  color: AppPallete.blueColor,
                  fontSize: 16,
                ),
              ),
              Text(
                "Verify your account with your email and password to prove that you are the owner of the account.",
                style: AppTheme.darkThemeData.textTheme.displaySmall!.copyWith(
                  color: AppPallete.greyColor,
                ),
              ),
              verticalSpacing(20),
              AbsorbPointer(
                child: InputWidget(
                  labelText: 'Email',
                  textEditingController: _emailController,
                  hintText: "",
                  suffixIcon: const Icon(
                    Icons.lock,
                  ),
                  textColor: AppPallete.greyColor,
                  fillColor: AppPallete.transparent,
                  validator: Validators.validateEmail,
                ),
              ),
              verticalSpacing(12),
              InputWidget(
                labelText: 'Password',
                textEditingController: _passwordController,
                hintText: "Verify password",
                suffixIcon: const Icon(
                  Icons.key,
                ),
                fillColor: AppPallete.transparent,
                validator: Validators.validatePassword,
              ),
              verticalSpacing(20),
              ButtonWidget(
                isLoading: context.watch<AuthCubit>().state.authWorkingStatus ==
                    AuthWorkingStatus.loading,
                buttonText: 'Verify',
                onPressed: () {
                  if (!_formKey.currentState!.validate()) {
                    return;
                  }
                  context.read<AuthCubit>().reauthenticateUser(
                        email: _emailController.text,
                        password: _passwordController.text,
                        callback: () {
                          showModalBottomSheet(
                            context: context,
                            isScrollControlled: true,
                            showDragHandle: true,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(6),
                            ),
                            backgroundColor: AppPallete.bottomSheetColor,
                            constraints: BoxConstraints.expand(
                              height: MediaQuery.of(context).size.height * .3,
                            ),
                            builder: (context) {
                              return DeleteAccountWidget(
                                uid: context
                                    .read<ProfileCubit>()
                                    .state
                                    .userData!
                                    .uid,
                              );
                            },
                          );
                        },
                      );
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}
