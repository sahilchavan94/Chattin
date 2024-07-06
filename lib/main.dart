import 'package:chattin/core/enum/enums.dart';
import 'package:chattin/core/router/router.dart';
import 'package:chattin/core/utils/app_theme.dart';
import 'package:chattin/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:chattin/features/chat/presentation/cubits/chat_cubit/cubit/chat_cubit.dart';
import 'package:chattin/features/chat/presentation/cubits/contacts_cubit/contacts_cubit.dart';
import 'package:chattin/features/profile/presentation/cubit/profile_cubit.dart';
import 'package:chattin/features/stories/presentation/cubit/stories_cubit.dart';
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
        BlocProvider(
          create: (_) => serviceLocator<ProfileCubit>(),
          lazy: false,
        ),
        BlocProvider(
          create: (_) => serviceLocator<ChatCubit>(),
          lazy: false,
        ),
        BlocProvider(
          create: (_) => serviceLocator<StoriesCubit>(),
          lazy: false,
        ),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    final currentUserData = context.read<ProfileCubit>().state.userData;
    if (currentUserData == null) {
      return;
    }
    final chatCubit = context.read<ChatCubit>();
    switch (state) {
      case AppLifecycleState.resumed:
        chatCubit.setChatStatus(
          status: Status.online,
          uid: currentUserData.uid,
        );
        break;
      case AppLifecycleState.inactive:
      case AppLifecycleState.detached:
      case AppLifecycleState.hidden:
      case AppLifecycleState.paused:
        chatCubit.setChatStatus(
          status: Status.offline,
          uid: currentUserData.uid,
        );
        break;
      default:
        chatCubit.setChatStatus(
          status: Status.unavailable,
          uid: currentUserData.uid,
        );
    }
  }

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
