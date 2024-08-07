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
  required String uid,
  required String imageUrl,
}) {
  showDialog(
    useRootNavigator: true,
    useSafeArea: true,
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
        child: SizedBox(
          width: MediaQuery.of(context).size.width * .65,
          child: Padding(
            padding: const EdgeInsets.all(2.12),
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
                Stack(
                  children: [
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
                          height: MediaQuery.of(context).size.height * .3,
                          width: MediaQuery.of(context).size.width * 98,
                          radius: BorderRadius.circular(2),
                          isImageFromChat: true,
                        ),
                      ),
                    ),
                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: Container(
                        width:
                            MediaQuery.of(context).size.width > 700 ? 600 : 275,
                        decoration: BoxDecoration(
                          color: AppPallete.blueColor,
                          gradient: LinearGradient(
                            colors: [
                              AppPallete.transparent,
                              AppPallete.backgroundColor.withOpacity(.4),
                              AppPallete.backgroundColor.withOpacity(.8),
                            ],
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                          ),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            IconButton(
                              splashColor: AppPallete.transparent,
                              onPressed: () {
                                context.pop();
                                context.push(
                                  RoutePath.chatScreen.path,
                                  extra: {
                                    'displayName': displayName,
                                    'imageUrl': imageUrl,
                                    'uid': uid,
                                  },
                                );
                              },
                              icon: const Icon(
                                Icons.message_outlined,
                                color: AppPallete.blueColor,
                              ),
                            ),
                            // IconButton(
                            //   splashColor: AppPallete.transparent,
                            //   onPressed: () {},
                            //   icon: const Icon(
                            //     Icons.info_outline,
                            //     color: AppPallete.blueColor,
                            //   ),
                            // ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ],
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
