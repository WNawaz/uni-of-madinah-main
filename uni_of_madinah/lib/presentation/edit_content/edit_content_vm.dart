// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:stacked/stacked.dart';
// import 'package:uni_of_madinah/constants.dart';
// import 'package:uni_of_madinah/dependancy_injection.dart';
// import 'package:uni_of_madinah/presentation/contentDetail/content_detail_screen.dart';
// import 'package:uni_of_madinah/presentation/contentDetail/content_detail_vm.dart';

// import 'package:uni_of_madinah/services/content_detail_service.dart';
// import 'package:uni_of_madinah/services/edit_content_service.dart';

// class EditContentViewModel extends BaseViewModel {
//   // Add your view model code here

//   LanguageMode selectedLanguage = LanguageMode.english;

//   List<IslamicContent> filteredContent = [];

//   void init() {
//     // Add your initialisation code here
//     fetchEnglishContent();
//   }

//   Future<void> fetchArabicContent() async {
//     setBusy(true);

//     final editContentService = getIt<EditContentService>();
//     List<dynamic> data = await editContentService.getArabicDataForPage(1);

//     List<IslamicContent> newFilteredContent = data.map((dynamic job) {
//       print("job: $job");
//       return IslamicContent(
//         title: selectedLanguage == LanguageMode.values
//             ? job[1] ?? ''
//             : job['title'] ?? '',
//         content: selectedLanguage == LanguageMode.values
//             ? job[3] ?? ''
//             : job['content'] ?? '',
//         index: job[0] ?? job['index'],
//         isRTL: selectedLanguage == LanguageMode.arabic,
//         author: job[4] ?? '',
//         referenceLink: job[5] ?? '',
//       );
//     }).toList();

//     // Update filtered content with new results
//     filteredContent = newFilteredContent;
//     notifyListeners();

//     setBusy(false);
//   }

//   Future<void> fetchEnglishContent() async {
//     setBusy(true);
//     final editContentService = getIt<EditContentService>();

//     DateTime startTime = DateTime.now();

//     List<dynamic> data = await editContentService.getEnglishDataForPage(1);

//     // Calculate the time taken
//     DateTime endTime = DateTime.now();
//     Duration timeTaken = endTime.difference(startTime);
//     print('Request took: ${timeTaken.inMilliseconds} milliseconds');

//     List<IslamicContent> newFilteredContent = data.map((dynamic job) {
//       // print("job: $job");
//       return IslamicContent(
//         title: selectedLanguage == LanguageMode.values
//             ? job[1] ?? ''
//             : job['title'] ?? '',
//         content: selectedLanguage == LanguageMode.values
//             ? job[3] ?? ''
//             : job['content'] ?? '',
//         index: job[0] ?? job['index'],
//         isRTL: selectedLanguage == LanguageMode.arabic,
//         author: job[4] ?? '',
//         referenceLink: job[5] ?? '',
//       );
//     }).toList();

//     // Update filtered content with new results
//     filteredContent = newFilteredContent;
//     notifyListeners();

//     setBusy(false);
//   }

//   void updateLanguage(LanguageMode language) {
//     selectedLanguage = language;
//     clearFilteredContent();
//     notifyListeners();

//     // Trigger a new search after updating the language
//     // filterContent(
//     //     searchController.text); // Assuming this method triggers the search
//   }

//   void clearFilteredContent() {
//     filteredContent.clear();
//     notifyListeners();
//   }

//   void showLanguageChangedSnackbar(BuildContext context, String language) {
//     ScaffoldMessenger.of(context).showSnackBar(
//       SnackBar(content: Text('Language changed to $language')),
//     );
//   }

//   void handleSearchTap(int index) {
//     final contentDetailService = getIt<ContentDetailService>();
//     contentDetailService.content = filteredContent[index];
//     contentDetailService.updateLanguage(selectedLanguage);
//     Get.to(const ContentDetailScreen());
//   }
// }
