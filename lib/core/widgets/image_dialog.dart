import 'package:chattin/core/router/route_path.dart';
import 'package:chattin/core/utils/app_pallete.dart';
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
    traversalEdgeBehavior: TraversalEdgeBehavior.closedLoop,
    context: context,
    builder: (context) {
      return Dialog(
        alignment: Alignment.topCenter,
        surfaceTintColor: AppPallete.transparent,
        elevation: 0,
        backgroundColor: AppPallete.transparent,
        child: Hero(
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
              width: MediaQuery.of(context).size.width * .5,
              height: MediaQuery.of(context).size.height * .32,
              radius: BorderRadius.circular(20),
              isImageFromChat: true,
            ),
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
