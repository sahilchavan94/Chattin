import 'dart:io';
import 'package:chattin/core/utils/app_pallete.dart';
import 'package:chattin/core/widgets/input_widget.dart';
import 'package:chattin/features/stories/presentation/cubit/story_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class StoryPreView extends StatefulWidget {
  final List<File> selectedFiles;
  final String displayName;
  final String phoneNumber;
  final String imageUrl;
  const StoryPreView({
    super.key,
    required this.selectedFiles,
    required this.displayName,
    required this.phoneNumber,
    required this.imageUrl,
  });

  @override
  State<StoryPreView> createState() => _StoryPreViewState();
}

class _StoryPreViewState extends State<StoryPreView> {
  late File currentFile;
  final List<TextEditingController> _textEditingControllerlist = [];
  final TransformationController _transformationController =
      TransformationController();

  @override
  void initState() {
    currentFile = widget.selectedFiles.first;
    for (int i = 0; i < widget.selectedFiles.length; i++) {
      _textEditingControllerlist.add(TextEditingController());
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Upload your story"),
        centerTitle: true,
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: MediaQuery.of(context).viewInsets,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ...widget.selectedFiles.map(
                      (e) => GestureDetector(
                        onTap: () {
                          setState(() {
                            currentFile = e;
                            _transformationController.value =
                                Matrix4.identity();
                          });
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(6),
                            border: e.path == currentFile.path
                                ? Border.all(
                                    color: AppPallete.blueColor,
                                    width: 2,
                                  )
                                : Border.all(
                                    color: AppPallete.transparent,
                                  ),
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(6),
                            child: Image.file(
                              e,
                              width: 50,
                              height: 50,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Row(
                children: [
                  Expanded(
                    child: InputWidget(
                      height: 45,
                      fillColor: AppPallete.bottomSheetColor,
                      showBorder: false,
                      hintText: 'Add a caption ',
                      textEditingController: _textEditingControllerlist[
                          widget.selectedFiles.indexOf(currentFile)],
                      validator: (String val) {},
                      suffixIcon: const Icon(
                        Icons.edit,
                        color: AppPallete.transparent,
                      ),
                    ),
                  ),
                  FloatingActionButton(
                    onPressed: () async {
                      context.read<StoryCubit>().uploadStory(
                            imageUrl: widget.imageUrl,
                            displayName: widget.displayName,
                            phoneNumber: widget.phoneNumber,
                            imageFiles: widget.selectedFiles,
                            captions: _textEditingControllerlist.map(
                              (e) {
                                if (e.text.replaceAll(" ", "").isEmpty) {
                                  return "";
                                } else {
                                  return e.text;
                                }
                              },
                            ).toList(),
                          );
                      context.pop();
                    },
                    backgroundColor: AppPallete.blueColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(50),
                    ),
                    mini: true,
                    child: const Icon(
                      Icons.send,
                      color: AppPallete.whiteColor,
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
      body: Center(
        child: SingleChildScrollView(
          child: SizedBox(
            height: MediaQuery.of(context).size.height * .7,
            width: double.maxFinite,
            child: Align(
              alignment: Alignment.center,
              child: InteractiveViewer(
                transformationController: _transformationController,
                constrained: true,
                panAxis: PanAxis.free,
                boundaryMargin: EdgeInsets.zero,
                minScale: 1,
                maxScale: 7,
                clipBehavior: Clip.hardEdge,
                panEnabled: true,
                scaleEnabled: true,
                child: Image.file(
                  currentFile,
                  alignment: Alignment.center,
                  width: double.infinity,
                  height: double.maxFinite,
                  fit: BoxFit.contain,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
