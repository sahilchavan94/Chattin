import 'package:chattin/core/router/router.dart';
import 'package:chattin/core/utils/app_theme.dart';
import 'package:chattin/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:chattin/features/chat/presentation/cubit/contacts_cubit.dart';
import 'package:chattin/firebase_options.dart';
import 'package:chattin/init_dependencies.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:toastification/toastification.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await initDependencies();
  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) => serviceLocator<AuthCubit>(),
        ),
        BlocProvider(
          create: (_) => serviceLocator<ContactsCubit>(),
        ),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ToastificationWrapper(
      child: MaterialApp.router(
        title: 'Flutter Demo',
        theme: AppTheme.darkThemeData,
        themeMode: ThemeMode.dark,
        debugShowCheckedModeBanner: false,
        routerConfig: MyRouter.router,
      ),
    );
  }
}
