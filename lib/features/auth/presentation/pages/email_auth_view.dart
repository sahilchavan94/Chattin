import 'package:chattin/core/utils/app_pallete.dart';
import 'package:chattin/core/utils/app_spacing.dart';
import 'package:chattin/core/utils/app_theme.dart';
import 'package:chattin/core/utils/validators.dart';
import 'package:chattin/core/widgets/button_widget.dart';
import 'package:chattin/core/widgets/dialog_box.dart';
import 'package:chattin/core/widgets/input_widget.dart';
import 'package:chattin/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class PhoneAuthView extends StatefulWidget {
  const PhoneAuthView({super.key});

  @override
  State<PhoneAuthView> createState() => _PhoneAuthViewState();
}

class _PhoneAuthViewState extends State<PhoneAuthView> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();
  final _formKey = GlobalKey<FormState>();

  bool _validateEmailAndPassword() {
    if (_formKey.currentState!.validate()) {
      return true;
    }
    if (_passwordController.text != _confirmPasswordController.text) {
      return true;
    }
    return false;
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                verticalSpacing(100),
                Row(
                  children: [
                    Text(
                      "Chattin",
                      style: AppTheme.darkThemeData.textTheme.displayLarge!
                          .copyWith(
                        color: AppPallete.blueColor,
                      ),
                    ),
                    Text(
                      "`",
                      style: AppTheme.darkThemeData.textTheme.displayLarge!
                          .copyWith(
                        color: AppPallete.whiteColor,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    horizontalSpacing(5),
                    Image.asset(
                      'assets/images/logo.png',
                      width: 28,
                    ),
                  ],
                ),
                Text(
                  "Get started easily with 3 simple steps 😌",
                  style:
                      AppTheme.darkThemeData.textTheme.displaySmall!.copyWith(
                    color: AppPallete.greyColor,
                    fontSize: 14,
                  ),
                ),
                verticalSpacing(40),
                InputWidget(
                  labelText: 'Email',
                  textEditingController: _emailController,
                  hintText: "Enter your email",
                  suffixIcon: const Icon(
                    Icons.email,
                  ),
                  validator: Validators.validateEmail,
                ),
                verticalSpacing(12),
                InputWidget(
                  labelText: 'Password',
                  textEditingController: _passwordController,
                  hintText: "Enter your password",
                  suffixIcon: const Icon(
                    Icons.lock,
                  ),
                  validator: Validators.validatePassword,
                ),
                verticalSpacing(12),
                InputWidget(
                  labelText: 'Confirm password',
                  textEditingController: _confirmPasswordController,
                  hintText: "Confirm your password",
                  passwordController: _passwordController,
                  suffixIcon: const Icon(
                    Icons.lock,
                  ),
                  validator: Validators.validatePassword,
                ),
                verticalSpacing(20),
                ButtonWidget(
                  buttonText: 'Continue',
                  isLoading: context.watch<AuthCubit>().state.authStatus ==
                      AuthStatus.loading,
                  onPressed: () {
                    if (!_validateEmailAndPassword()) {
                      return;
                    }
                    showDialog(
                      context: context,
                      builder: (context) {
                        return DialogWidget(
                          onPressed: () {
                            context.pop();
                            context
                                .read<AuthCubit>()
                                .createAccountWithEmailAndPassword(
                                  _emailController.text.trim(),
                                  _passwordController.text.trim(),
                                );
                          },
                          title: 'Recheck Email',
                          approvalText: 'Continue',
                          rejectionText: 'Cancel',
                        );
                      },
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
