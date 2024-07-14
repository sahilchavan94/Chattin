import 'package:chattin/core/router/route_path.dart';
import 'package:chattin/core/utils/app_pallete.dart';
import 'package:chattin/core/utils/app_spacing.dart';
import 'package:chattin/core/utils/app_theme.dart';
import 'package:chattin/core/widgets/image_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

class ChatContactWidget extends StatelessWidget {
  final String imageUrl;
  final String displayName;
  final String lastMessage;
  final double? radius;
  final DateTime timeSent;
  final bool? hasVerticalSpacing;
  const ChatContactWidget({
    super.key,
    required this.imageUrl,
    required this.displayName,
    required this.lastMessage,
    this.hasVerticalSpacing,
    this.radius,
    required this.timeSent,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
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
                            .slide(
                              curve: Curves.fastEaseInToSlowEaseOut,
                            ),
                      );
                    },
                  );
                },
                child: ImageWidget(
                  imagePath: imageUrl,
                  width: radius ?? 50,
                  height: radius ?? 50,
                  fit: BoxFit.fill,
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
                  Text(
                    lastMessage.length > 30
                        ? "${lastMessage.substring(0, 25)}..."
                        : lastMessage,
                    style:
                        AppTheme.darkThemeData.textTheme.displaySmall!.copyWith(
                      color: AppPallete.greyColor,
                    ),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                  )
                ],
              ),
              const Spacer(),
              Text(
                "${DateFormat.jm().format(timeSent)} ${DateFormat('dd MMMM yyyy').format(timeSent)}",
                style: AppTheme.darkThemeData.textTheme.displaySmall!.copyWith(
                  color: AppPallete.greyColor,
                  fontSize: 11,
                ),
                overflow: TextOverflow.ellipsis, // Ensure text can overflow
              ),
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
