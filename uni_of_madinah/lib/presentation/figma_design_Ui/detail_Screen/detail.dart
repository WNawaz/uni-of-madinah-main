import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:stacked/stacked.dart';
import 'package:uni_of_madinah/dependancy_injection.dart';
import 'package:uni_of_madinah/presentation/figma_design_Ui/detail_Screen/detail_vm.dart';
import 'package:uni_of_madinah/presentation/figma_design_Ui/detail_Screen/widget/custom_container.dart';
import 'package:uni_of_madinah/presentation/figma_design_Ui/detail_Screen/widget/custom_container_vm.dart';
import 'package:uni_of_madinah/presentation/figma_design_Ui/detail_Screen/widget/title_section.dart';
import 'package:uni_of_madinah/presentation/figma_design_Ui/profile/profile.dart';
import 'package:uni_of_madinah/services/content_edit_service.dart';

class ContentDetailedScreen extends StatefulWidget {
  const ContentDetailedScreen({super.key});

  @override
  State<ContentDetailedScreen> createState() => _ContentDetailedScreenState();
}

class _ContentDetailedScreenState extends State<ContentDetailedScreen> {
  @override
  Widget build(BuildContext context) {
    return PopScope(
      onPopInvoked: (didPop) {
        if (didPop) {
          print("Popped scope");
          final contentEditingService = getIt<ContentEdittingService>();
          contentEditingService.disableContentEditing();
        }
      },
      child: ViewModelBuilder.reactive(
        onViewModelReady: (viewModel) => viewModel.init(),
        viewModelBuilder: () => DetailVM(),
        builder: (context, model, child) => Scaffold(
          body: NestedScrollView(
            headerSliverBuilder: (context, innerBoxIsScrolled) {
              return [
                SliverAppBar(
                  backgroundColor: HexColor("#05677E"),
                  expandedHeight: 175.0.sp,
                  pinned: true,
                  flexibleSpace: FlexibleSpaceBar(
                    background: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                            height: 110
                                .sp), // Add space for the status bar and toolbar
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 16.0),
                          child: Semantics(
                            excludeSemantics: true,
                            label:
                                "Title section. ${model.contentDetailService.content!.title}. By. ${model.contentDetailService.content!.author}.",
                            child: TitleSectionWidget(
                              isEditing: model.isEdittableState,
                              byName:
                                  model.contentDetailService.content!.author,
                              model: CustomContainerVM(),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  leading: model.isEdittableState
                      ? Semantics(
                          excludeSemantics: true,
                          label:
                              "Close button. Please double Tap to Close the edit Mode",
                          child: IconButton(
                            icon: const Icon(
                              Icons.close,
                              color: Colors.white,
                            ),
                            onPressed: () {
                              model.setContentNoneEdittableStatus();
                            },
                          ),
                        )
                      : Semantics(
                          excludeSemantics: true,
                          label:
                              "Back button. Please double Tap to return to the previous screen.",
                          child: IconButton(
                            icon: const Icon(
                              Icons.arrow_back,
                              color: Colors.white,
                            ),
                            onPressed: () {
                              model.handleViewPop();
                              Navigator.pop(context);
                            },
                          ),
                        ),
                  title: Semantics(
                    excludeSemantics: true,
                    label: model.isEdittableState ? "Edit" : "Islam Q",
                    child: Text(
                      model.isEdittableState ? "Edit" : "Islam Q",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                  actions: [
                    if (model.isEdittableState)
                      Padding(
                        padding: EdgeInsets.only(right: 8.0.sp),
                        child: Semantics(
                          excludeSemantics: true,
                          label:
                              "Delete button. Please double Tap to delete this content.",
                          child: IconButton(
                            icon: const Icon(Icons.delete_outlined,
                                color: Colors.white),
                            onPressed: () {
                              _showDeleteConfirmationDialog(context, model);
                            },
                          ),
                        ),
                      )
                    else
                      Padding(
                          padding: EdgeInsets.only(right: 8.0.sp),
                          child: Semantics(
                            excludeSemantics: true,
                            label: "Profile button. Tap to view your profile.",
                            child: TextButton(
                              child: Text(
                                model.userName,
                                style: TextStyle(color: Colors.white),
                              ),
                              onPressed: () {
                                Get.to(ProfileScreen());
                              },
                            ),
                          ))
                  ],
                ),
              ];
            },
            body: CustomScrollView(
              slivers: [
                SliverToBoxAdapter(
                  child: Padding(
                    padding: EdgeInsets.all(8.0),
                    child: CustomContainerWidget(
                      // title: model.contentDetailService.content!.title,
                      // byName: model.contentDetailService.content!.author,
                      content:
                          "${model.contentDetailService.content!.content} \n\n Reference url: ${model.contentDetailService.content!.referenceLink}",
                      isEditing: model.isEdittableState,
                    ),
                  ),
                ),
              ],
            ),
          ),
          floatingActionButton: model.volunteerService.isVolunteer
              ? Semantics(
                  excludeSemantics: true,
                  label: model.isTitleEditing || model.isDescriptionEditing
                      ? "Save changes button. Tap to save your changes."
                      : "Edit button. Tap to switch to edit mode.",
                  child: FloatingActionButton.extended(
                    backgroundColor: HexColor("#05677E"),
                    foregroundColor: Colors.white,
                    onPressed: () {
                      if (model.isTitleEditing || model.isDescriptionEditing) {
                        model.saveContent(model.contentDetailService.content!);
                      } else {
                        model.toggleEditMode();
                      }
                    },
                    icon: model.isTitleEditing || model.isDescriptionEditing
                        ? Icon(Icons.check_outlined, size: 16.sp)
                        : Icon(Icons.edit_outlined, size: 16.sp),
                    label: model.isSavingContent
                        ? SizedBox(
                            height: 16.sp,
                            width: 16.sp,
                            child: CircularProgressIndicator.adaptive(
                              valueColor:
                                  AlwaysStoppedAnimation<Color>(Colors.white),
                            ),
                          )
                        : Text(
                            model.isTitleEditing || model.isDescriptionEditing
                                ? 'Save changes'
                                : 'Edit',
                            style: TextStyle(color: Colors.white),
                          ),
                  ))
              : null,
        ),
      ),
    );
  }

  void _showDeleteConfirmationDialog(BuildContext context, DetailVM model) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Semantics(
            excludeSemantics: true,
            label: "Confirm Delete dialog.",
            child: const Text('Confirm Delete'),
          ),
          content: Semantics(
            excludeSemantics: true,
            label: "Are you sure you want to delete this item?",
            child: const Text('Are you sure you want to delete this item?'),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Semantics(
                excludeSemantics: true,
                label: "Cancel button. Please double Tap to cancel deletion.",
                child: const Text('Cancel'),
              ),
            ),
            TextButton(
              onPressed: () async {
                bool success = await model.deleteContent();
                Navigator.of(context).pop();
                if (success) {
                  Navigator.of(context)
                      .pop(true); // Pass true to indicate successful deletion
                }
              },
              child: Semantics(
                excludeSemantics: true,
                label: "Delete button. Please double Tap to confirm deletion.",
                child: const Text('Delete'),
              ),
            ),
          ],
        );
      },
    );
  }
}
