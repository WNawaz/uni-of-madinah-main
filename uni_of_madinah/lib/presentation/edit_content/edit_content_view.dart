// import 'package:flutter/material.dart';
// import 'package:shimmer/shimmer.dart';
// import 'package:stacked/stacked.dart';
// import 'package:uni_of_madinah/constants.dart';
// import 'package:uni_of_madinah/presentation/edit_content/edit_content_vm.dart';


// class EditContentView extends StatelessWidget {
//   const EditContentView({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return ViewModelBuilder.reactive(
//       viewModelBuilder: () => EditContentViewModel(),
//       onViewModelReady: (viewModel) => viewModel.init(),
//       builder: (context, model, child) => Scaffold(
//         appBar: AppBar(
//           title: const Text('Edit Content'),
//         ),
//         body: Column(
//           mainAxisAlignment: MainAxisAlignment.start,
//           children: [
//             Padding(
//               padding: const EdgeInsets.symmetric(horizontal: 16.0),
//               child: Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceAround,
//                 children: [
//                   TextButton(
//                     onPressed: () {
//                       model.updateLanguage(LanguageMode.arabic);
//                       model.showLanguageChangedSnackbar(context, 'Arabic');
//                       model.fetchArabicContent();
//                     },
//                     child: Text(
//                       'AR',
//                       style: TextStyle(
//                         color: model.selectedLanguage == LanguageMode.arabic
//                             ? Colors.blue
//                             : Colors.grey,
//                       ),
//                     ),
//                   ),
//                   TextButton(
//                     onPressed: () {
//                       model.updateLanguage(LanguageMode.english);
//                       model.showLanguageChangedSnackbar(context, 'English');
//                       model.fetchEnglishContent();
//                     },
//                     child: Text(
//                       'EN',
//                       style: TextStyle(
//                         color: model.selectedLanguage == LanguageMode.english
//                             ? Colors.blue
//                             : Colors.grey,
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//             model.isBusy
//                 ? _buildShimmerList()
//                 : Expanded(
//                     child: ListView.builder(
//                       itemCount: model.filteredContent.length,
//                       itemBuilder: (context, index) {
//                         final bool isRTL =
//                             model.selectedLanguage == LanguageMode.arabic;
//                         return Directionality(
//                           textDirection:
//                               isRTL ? TextDirection.rtl : TextDirection.ltr,
//                           child: Container(
//                             margin: const EdgeInsets.symmetric(vertical: 8.0),
//                             decoration: BoxDecoration(
//                               color: Colors.white,
//                               borderRadius: BorderRadius.circular(5.0),
//                               boxShadow: [
//                                 BoxShadow(
//                                   color: Colors.grey.withOpacity(0.3),
//                                   spreadRadius: 2,
//                                   blurRadius: 5,
//                                   offset: const Offset(0, 3),
//                                 ),
//                               ],
//                             ),
//                             child: ListTile(
//                               title: Text(
//                                 model.filteredContent[index].title,
//                                 style: const TextStyle(
//                                   fontWeight: FontWeight.bold,
//                                   color: Colors.blue,
//                                 ),
//                               ),
//                               subtitle: Text(
//                                 model.filteredContent[index].content.trim(),
//                                 maxLines: 3,
//                                 overflow: TextOverflow.ellipsis,
//                               ),
//                               onTap: () => model.handleSearchTap(index),
//                             ),
//                           ),
//                         );
//                       },
//                     ),
//                   ),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildShimmerList() {
//     return Expanded(
//       child: ListView.builder(
//         itemCount: 10,
//         itemBuilder: (context, index) {
//           return Shimmer.fromColors(
//             baseColor: Colors.grey[300]!,
//             highlightColor: Colors.grey[100]!,
//             child: ListTile(
//               title: Container(
//                 height: 20,
//                 width: double.infinity,
//                 color: Colors.white,
//               ),
//               subtitle: Container(
//                 height: 15,
//                 width: double.infinity,
//                 color: Colors.white,
//               ),
//             ),
//           );
//         },
//       ),
//     );
//   }
// }
