import 'package:chattin/core/common/providers/reply_message_provider.dart';
import 'package:chattin/core/enum/enums.dart';
import 'package:chattin/core/router/router.dart';
import 'package:chattin/core/utils/app_pallete.dart';
import 'package:chattin/core/utils/app_theme.dart';
import 'package:chattin/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:chattin/features/chat/presentation/cubits/chat_cubit/chat_cubit.dart';
import 'package:chattin/features/chat/presentation/cubits/contacts_cubit/contacts_cubit.dart';
import 'package:chattin/features/profile/presentation/cubit/profile_cubit.dart';
import 'package:chattin/features/stories/presentation/cubit/story_cubit.dart';
import 'package:chattin/firebase_options.dart';
import 'package:chattin/init_dependencies.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:provider/provider.dart';
import 'package:toastification/toastification.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  await FlutterContacts.requestPermission(
    readonly: false,
  );

  await initDependencies();

  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: AppPallete.backgroundColor,
      systemNavigationBarColor: AppPallete.backgroundColor,
    ),
  );

  runApp(
    MultiBlocProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => serviceLocator<ReplyMessageProvider>(),
          lazy: false,
        ),
        BlocProvider(
          create: (_) => serviceLocator<AuthCubit>(),
          lazy: false,
        ),
        BlocProvider(
          create: (_) => serviceLocator<ContactsCubit>(),
          lazy: false,
        ),
        BlocProvider(
          create: (_) => serviceLocator<ProfileCubit>(),
          lazy: false,
        ),
        BlocProvider(
          create: (_) => serviceLocator<ChatCubit>(),
        ),
        BlocProvider(
          create: (_) => serviceLocator<StoryCubit>(),
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
        chatCubit.setChatOnOffStatus(
          status: Status.online,
          uid: currentUserData.uid,
        );
        break;
      case AppLifecycleState.inactive:
      case AppLifecycleState.detached:
      case AppLifecycleState.hidden:
      case AppLifecycleState.paused:
        chatCubit.setChatOnOffStatus(
          status: Status.offline,
          uid: currentUserData.uid,
        );
        break;
      default:
        chatCubit.setChatOnOffStatus(
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
        routerConfig: AppRouter.router,
      ),
    );
  }
}
