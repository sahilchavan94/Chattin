import 'package:chattin/core/router/route_path.dart';
import 'package:chattin/core/utils/app_pallete.dart';
import 'package:chattin/core/utils/app_spacing.dart';
import 'package:chattin/core/utils/app_theme.dart';
import 'package:chattin/core/utils/validators.dart';
import 'package:chattin/core/widgets/button_widget.dart';
import 'package:chattin/core/widgets/input_widget.dart';
import 'package:chattin/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class EmailPassLoginView extends StatefulWidget {
  const EmailPassLoginView({super.key});

  @override
  State<EmailPassLoginView> createState() => _EmailPassLoginViewState();
}

class _EmailPassLoginViewState extends State<EmailPassLoginView> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  bool _validateEmailAndPassword() {
    if (_formKey.currentState!.validate()) {
      return true;
    }

    return false;
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        systemOverlayStyle: const SystemUiOverlayStyle(
          systemNavigationBarColor: AppPallete.backgroundColor,
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                verticalSpacing(35),
                Row(
                  children: [
                    Text(
                      "Sign In",
                      style: AppTheme.darkThemeData.textTheme.displayLarge!
                          .copyWith(
                        color: AppPallete.blueColor,
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
                  "Sign In into your account just with your email with ease ❗️",
                  style:
                      AppTheme.darkThemeData.textTheme.displaySmall!.copyWith(
                    color: AppPallete.greyColor,
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
                  fillColor: AppPallete.transparent,
                  validator: Validators.validateEmail,
                ),
                verticalSpacing(12),
                InputWidget(
                  labelText: 'Password',
                  textEditingController: _passwordController,
                  hintText: "Enter your password",
                  fillColor: AppPallete.transparent,
                  suffixIcon: const Icon(
                    Icons.lock,
                  ),
                  validator: Validators.validatePassword,
                ),
                verticalSpacing(20),
                ButtonWidget(
                  buttonText: 'Sign In',
                  isLoading: context.watch<AuthCubit>().state.authStatus ==
                      AuthStatus.loading,
                  onPressed: () {
                    if (!_validateEmailAndPassword()) {
                      return;
                    }
                    context.read<AuthCubit>().signInWithEmailAndPassword(
                          _emailController.text,
                          _passwordController.text,
                        );
                  },
                ),
                verticalSpacing(20),
                TextButton(
                  onPressed: () {
                    context.push(RoutePath.emailAuth.path);
                  },
                  child: Align(
                    alignment: Alignment.center,
                    child: Text(
                      "Don't have an account ?",
                      style: AppTheme.darkThemeData.textTheme.displaySmall!
                          .copyWith(
                        color: AppPallete.blueColor,
                        fontSize: 14,
                        decoration: TextDecoration.underline,
                        decorationStyle: TextDecorationStyle.solid,
                        decorationColor: AppPallete.blueColor,
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
}
