// import 'package:flutter/material.dart';
// import 'package:hexcolor/hexcolor.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:stacked/stacked.dart';
// import 'package:uni_of_madinah/presentation/figma_design_Ui/detail_Screen/widget/custom_container_vm.dart';

// class TitleSectionWidget extends StatelessWidget {
//   final bool isEditing;
//   final String byName;
//   final CustomContainerVM model;

//   TitleSectionWidget({
//     required this.isEditing,
//     required this.byName,
//     required this.model,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return ViewModelBuilder<CustomContainerVM>.reactive(
//       viewModelBuilder: () => model,
//       onViewModelReady: (model) {
//         model.init();
//       },
//       builder: (context, model, child) => Container(
//         padding: EdgeInsets.symmetric(vertical: 0.0, horizontal: 0),
//         width: double.infinity,
//         constraints: BoxConstraints(
//           maxHeight: 100.0.sp,
//         ),
//         decoration: BoxDecoration(
//           color: HexColor("#BFC8CC"),
//           borderRadius: BorderRadius.circular(12.sp),
//           border: Border.all(
//             color: Colors.grey.shade500,
//           ),
//           // boxShadow: [
//           //   BoxShadow(
//           //     color: Colors.grey.withOpacity(0.3),
//           //     spreadRadius: 0.5.sp,
//           //     blurRadius: 2.sp,
//           //     offset: const Offset(0, 3),
//           //   ),
//           // ],
//         ),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Align(
//               alignment: Alignment.centerRight,
//               child: IconButton(
//                 iconSize: 25.sp,
//                 onPressed: () {
//                   if (model.isTtsActive) {
//                     model.pauseOrResumeTts();
//                   } else {
//                     model.speakContent();
//                   }
//                 },
//                 color: HexColor("#40484C"),
//                 icon: Icon(
//                   model.isTtsActive
//                       ? Icons.pause_outlined
//                       : Icons.volume_up_outlined,
//                 ),
//               ),
//             ),
//             isEditing
//                 ? TextFormField(
//                     controller: model.titleController,
//                     onChanged: (value) {
//                       model.handleTitleChange(value);
//                     },
//                     style: Theme.of(context).textTheme.headlineSmall,
//                     maxLines: null,
//                     decoration: const InputDecoration(
//                       border: InputBorder.none,
//                     ),
//                     readOnly: !model.isDescriptionEditingEnabled,
//                   )
//                 : Text(
//                     model.titleController.text,
//                     style: Theme.of(context).textTheme.titleSmall,
//                   ),
//             if (model.isTtsLoading) CircularProgressIndicator(),
//             SizedBox(height: 0.h),
//             Center(
//               child: Text(
//                 "by $byName",
//                 style: Theme.of(context).textTheme.labelMedium,
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:stacked/stacked.dart';
import 'package:uni_of_madinah/presentation/figma_design_Ui/detail_Screen/widget/custom_container_vm.dart';

class TitleSectionWidget extends StatelessWidget {
  final bool isEditing;
  final String byName;
  final CustomContainerVM model;

  TitleSectionWidget({
    required this.isEditing,
    required this.byName,
    required this.model,
  });

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<CustomContainerVM>.reactive(
      viewModelBuilder: () => model,
      onViewModelReady: (model) {
        model.init();
      },
      builder: (context, model, child) => Container(
        padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 8.0),
        width: double.infinity,
        constraints: BoxConstraints(
          minHeight: 90.0.sp,
        ),
        decoration: BoxDecoration(
          color: HexColor("#BFC8CC"),
          borderRadius: BorderRadius.circular(12.sp),
          border: Border.all(
            color: Colors.grey.shade500,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      isEditing
                          ? TextFormField(
                              controller: model.titleController,
                              onChanged: (value) {
                                model.handleTitleChange(value);
                              },
                              style: Theme.of(context).textTheme.titleSmall,
                              maxLines: 2,
                              decoration: const InputDecoration(
                                border: InputBorder.none,
                              ),
                              readOnly: !model.isDescriptionEditingEnabled,
                            )
                          : Text(
                              model.titleController.text,
                              style: Theme.of(context).textTheme.titleSmall,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                    ],
                  ),
                ),
                model.isTtsLoading
                    ? SizedBox(
                        width: 25.sp,
                        height: 25.sp,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                        ),
                      )
                    : IconButton(
                        iconSize: 25.sp,
                        onPressed: () {
                          if (model.isTtsActive) {
                            model.pauseOrResumeTts();
                          } else {
                            model.speakContent();
                          }
                        },
                        color: HexColor("#40484C"),
                        icon: Icon(
                          model.isTtsActive
                              ? Icons.pause_outlined
                              : Icons.volume_up_outlined,
                        ),
                      ),
              ],
            ),
            SizedBox(height: 0.0.h),
            Center(
              child: Text(
                "by $byName",
                style: Theme.of(context).textTheme.labelMedium,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
