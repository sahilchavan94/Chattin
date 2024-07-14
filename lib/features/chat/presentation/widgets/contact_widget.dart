import 'package:chattin/core/enum/enums.dart';
import 'package:chattin/core/router/route_path.dart';
import 'package:chattin/core/utils/app_pallete.dart';
import 'package:chattin/core/utils/app_spacing.dart';
import 'package:chattin/core/utils/app_theme.dart';
import 'package:chattin/core/utils/helper_functions.dart';
import 'package:chattin/core/widgets/image_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';

class ContactWidget extends StatelessWidget {
  final String imageUrl;
  final String displayName;
  final String? about;
  final String? status;
  final double? radius;
  final bool? hasVerticalSpacing;
  const ContactWidget({
    super.key,
    required this.imageUrl,
    required this.displayName,
    this.about,
    this.hasVerticalSpacing,
    this.radius,
    this.status,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Row(
            children: [
              GestureDetector(
                onTapDown: (TapDownDetails details) {
                  showDialog(
                    useRootNavigator: true,
                    traversalEdgeBehavior: TraversalEdgeBehavior.closedLoop,
                    context: context,
                    builder: (context) {
                      return GestureDetector(
                        onTap: () {
                          context.push(
                            RoutePath.imageView.path,
                            extra: {
                              'displayName': displayName,
                              'imageUrl': imageUrl,
                            },
                          );
                        },
                        child: Dialog(
                          alignment: Alignment.topCenter,
                          surfaceTintColor: AppPallete.transparent,
                          elevation: 0,
                          backgroundColor: AppPallete.transparent,
                          child: Padding(
                            padding: const EdgeInsets.only(top: 100),
                            child: Hero(
                              tag: imageUrl,
                              child: ImageWidget(
                                imagePath: imageUrl,
                                fit: BoxFit.cover,
                                width: MediaQuery.of(context).size.width * .5,
                                height:
                                    MediaQuery.of(context).size.height * .32,
                                radius: BorderRadius.circular(20),
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
                            .slide(
                              curve: Curves.fastEaseInToSlowEaseOut,
                            ),
                      );
                    },
                  );
                },
                child: ImageWidget(
                  imagePath: imageUrl,
                  width: radius ?? 60,
                  height: radius ?? 60,
                  fit: BoxFit.cover,
                  radius: BorderRadius.circular(60),
                ),
              ),
              horizontalSpacing(16),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    displayName,
                    style:
                        AppTheme.darkThemeData.textTheme.displayLarge!.copyWith(
                      color: AppPallete.whiteColor,
                      fontSize: 16,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  verticalSpacing(5),
                  if (about != null)
                    Text(
                      about!.isEmpty
                          ? "Hello everyone, I'm now on Chattin`!"
                          : about!,
                      style: AppTheme.darkThemeData.textTheme.displaySmall!
                          .copyWith(
                        color: AppPallete.greyColor,
                      ),
                    ),
                  if (status != null)
                    Text(
                      status!,
                      style: AppTheme.darkThemeData.textTheme.displaySmall!
                          .copyWith(
                        color: HelperFunctions.parseStatusType(status!) ==
                                Status.online
                            ? AppPallete.blueColor
                            : AppPallete.redColor,
                      ),
                    )
                ],
              )
            ],
          ),
          hasVerticalSpacing == true
              ? verticalSpacing(25)
              : const SizedBox.shrink(),
        ],
      ),
    );
  }
}
