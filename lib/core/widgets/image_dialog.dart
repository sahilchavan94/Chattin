import 'package:chattin/core/router/route_path.dart';
import 'package:chattin/core/utils/app_pallete.dart';
import 'package:chattin/core/utils/app_theme.dart';
import 'package:chattin/core/widgets/image_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';

showImageDialog({
  required BuildContext context,
  required String displayName,
  required String imageUrl,
}) {
  showDialog(
    useRootNavigator: true,
    context: context,
    builder: (context) {
      return Dialog(
        alignment: Alignment.topCenter,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(6),
        ),
        surfaceTintColor: AppPallete.bottomSheetColor,
        elevation: 0,
        backgroundColor: AppPallete.bottomSheetColor,
        child: Padding(
          padding: const EdgeInsets.all(2),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: const EdgeInsets.only(bottom: 3),
                child: Text(
                  displayName,
                  style:
                      AppTheme.darkThemeData.textTheme.displaySmall!.copyWith(
                    color: AppPallete.whiteColor,
                  ),
                ),
              ),
              Hero(
                tag: imageUrl,
                child: GestureDetector(
                  onTap: () {
                    context.push(
                      RoutePath.imageView.path,
                      extra: {
                        'displayName': displayName,
                        'imageUrl': imageUrl,
                      },
                    );
                  },
                  child: ImageWidget(
                    imagePath: imageUrl,
                    fit: BoxFit.cover,
                    width: MediaQuery.of(context).size.width * .675,
                    height: MediaQuery.of(context).size.height * .3,
                    radius: BorderRadius.circular(6),
                    isImageFromChat: true,
                  ),
                ),
              ),
            ],
          ),
        ),
      )
          .animate()
          .scale(
            begin: const Offset(0.5, 0.5),
            end: const Offset(1, 1),
            curve: Curves.fastEaseInToSlowEaseOut,
          )
          .fadeIn()
          .slideY(
            curve: Curves.fastEaseInToSlowEaseOut,
            begin: -.2,
            end: .15,
          );
    },
  );
}
