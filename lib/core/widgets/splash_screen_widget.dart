import 'package:chattin/core/router/route_path.dart';
import 'package:chattin/core/utils/app_pallete.dart';
import 'package:chattin/core/utils/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _navigateToNextScreen();
  }

  _navigateToNextScreen() async {
    await Future.delayed(
      const Duration(
        milliseconds: 2500,
      ),
      () {
        if (mounted) {
          context.go(RoutePath.chatContacts.path);
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'CHATTIN`',
              style: AppTheme.darkThemeData.textTheme.displayLarge!.copyWith(
                color: AppPallete.blueColor,
                fontWeight: FontWeight.w700,
              ),
            ).animate().fadeIn().slideX(
                  duration: Durations.long1,
                  begin: -.5,
                  end: 0,
                  curve: Curves.fastEaseInToSlowEaseOut,
                ),
            Text(
              'An attempt to refine my flutter skills',
              style: AppTheme.darkThemeData.textTheme.displayMedium!.copyWith(
                color: AppPallete.greyColor,
              ),
            ).animate().fadeIn().slideX(
                  duration: Durations.long3,
                  begin: 1,
                  end: 0,
                  curve: Curves.fastEaseInToSlowEaseOut,
                ),
          ],
        ),
      ),
    );
  }
}
