import 'package:chattin/core/utils/app_pallete.dart';
import 'package:chattin/core/utils/app_theme.dart';
import 'package:chattin/features/chat/presentation/widgets/contact_widget.dart';
import 'package:chattin/features/stories/domain/entities/story_entity.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:story_view/controller/story_controller.dart';
import 'package:story_view/utils.dart';
import 'package:story_view/widgets/story_view.dart';

class StorySeeView extends StatefulWidget {
  final List<StoryEntity> storyList;
  const StorySeeView({
    super.key,
    required this.storyList,
  });

  @override
  State<StorySeeView> createState() => _StorySeeViewState();
}

class _StorySeeViewState extends State<StorySeeView> {
  final StoryController _storyController = StoryController();
  final PageController _pageController = PageController();
  late List<List<StoryItem>> storyItems;
  String uploadedAt = "";
  String currentCaption = "";
  int currentIndex = 0;

  @override
  void initState() {
    super.initState();
    storyItems = List.filled(widget.storyList.length, []);
    initStoryPageItems();
  }

  void initStoryPageItems() {
    final stories = widget.storyList;
    for (int i = 0; i < stories.length; i++) {
      storyItems[i] = [];
      for (int j = 0; j < stories[i].imageUrlList.length; j++) {
        storyItems[i].add(
          StoryItem.pageImage(
            url: stories[i].imageUrlList[j]['url'],
            controller: _storyController,
          ),
        );
      }
    }
    final temp = DateTime.fromMillisecondsSinceEpoch(
      widget.storyList.first.imageUrlList.first['uploadedAt'],
    );

    uploadedAt =
        "${DateFormat('dd MMM yyyy').format(temp)} ${DateFormat.jm().format(temp)}";
    currentCaption = widget.storyList.first.imageUrlList.first['caption'];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // bottomNavigationBar:
      body: storyItems.isEmpty
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : Center(
              child: PageView.builder(
                controller: _pageController,
                scrollDirection: Axis.vertical,
                itemCount: storyItems.length,
                onPageChanged: (value) {
                  setState(() {
                    currentIndex = value;
                  });
                },
                itemBuilder: (context, index) {
                  return Stack(
                    children: [
                      Align(
                        alignment: Alignment.center,
                        child: StoryView(
                          storyItems: storyItems[index],
                          controller: _storyController,
                          progressPosition: ProgressPosition.top,
                          onVerticalSwipeComplete: (dir) {
                            if (dir == Direction.down) {
                              context.pop();
                              return;
                            }
                          },
                          onComplete: () {
                            if (currentIndex + 1 == widget.storyList.length) {
                              context.pop();
                              return;
                            }
                            _pageController.nextPage(
                              duration: const Duration(
                                seconds: 1,
                              ),
                              curve: Curves.fastEaseInToSlowEaseOut,
                            );
                          },
                          indicatorHeight: IndicatorHeight.small,
                          indicatorColor: AppPallete.whiteColor,
                          indicatorForegroundColor: AppPallete.blueColor,
                          onStoryShow: (storyItem, pos) {
                            final temp = DateTime.fromMillisecondsSinceEpoch(
                              widget.storyList[index].imageUrlList[pos]
                                  ['uploadedAt'],
                            );

                            if (pos > 0) {
                              setState(
                                () {
                                  currentCaption = widget.storyList[index]
                                      .imageUrlList[pos]['caption'];

                                  uploadedAt =
                                      "${DateFormat('dd MMM yyyy').format(temp)} ${DateFormat.jm().format(temp)}";
                                },
                              );
                            }
                          },
                        ),
                      ),
                      Positioned(
                        top: MediaQuery.of(context).size.height * .06,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16.0),
                          child: ContactWidget(
                            imageUrl:
                                widget.storyList[index].userEntity!.imageUrl,
                            radius: 50,
                            displayName:
                                widget.storyList[index].userEntity!.displayName,
                            about: uploadedAt,
                          ),
                        ),
                      ),
                      Align(
                        alignment: Alignment.bottomCenter,
                        child: Container(
                          decoration: BoxDecoration(
                            color: AppPallete.backgroundColor.withOpacity(.4),
                          ),
                          width: double.maxFinite,
                          height: MediaQuery.of(context).size.height * .1,
                          child: Center(
                            child: Text(
                              textAlign: TextAlign.center,
                              currentCaption,
                              style: AppTheme
                                  .darkThemeData.textTheme.displaySmall!
                                  .copyWith(
                                color: AppPallete.whiteColor,
                                fontSize: 16,
                              ),
                              overflow: TextOverflow.ellipsis,
                              maxLines: 3,
                            ),
                          ),
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
    );
  }
}
