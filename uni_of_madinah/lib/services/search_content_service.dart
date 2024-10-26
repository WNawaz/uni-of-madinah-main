import 'package:stacked/stacked.dart';
import 'package:uni_of_madinah/dependancy_injection.dart';
import 'package:uni_of_madinah/presentation/contentDetail/content_detail_vm.dart';
import 'package:uni_of_madinah/services/api_service.dart';

class SearchContentService with ListenableServiceMixin {
  List<IslamicContent> searchContent = [];

  void addContent(IslamicContent content) {
    searchContent.add(content);
  }

  void removeContent(IslamicContent content) {
    searchContent.remove(content);
  }

  void clearContent() {
    searchContent.clear();
  }

  Future<void> updateContent(IslamicContent content) async {
    final index =
        searchContent.indexWhere((element) => element.index == content.index);
    print(index);
    searchContent[index] = content;
    notifyListeners();
  }

  IslamicContent? getContent(int index) {
    return searchContent.firstWhere(
      (element) => element.index == index,
      orElse: () => IslamicContent(
        title: "",
        content: "",
        index: -1,
        isRTL: false,
        author: "",
        referenceLink: "",
      ),
    );
  }

  List<IslamicContent> gefetchContent() {
    return searchContent;
  }

  void setSearchContent(List<IslamicContent> content) {
    searchContent = content;
    notifyListeners();
  }

  void removeContentByIndex(int index) {
    searchContent.removeWhere((element) => element.index == index);
  }

  void clear() {
    searchContent.clear();
  }

  Future<List<IslamicContent>?> fetchSearchContent(
    String languageMode,
  ) async {
    // Fetch content from API

    try {
      print("Fetching explore content");

      List<IslamicContent>? content;

      final apiService = getIt<ApiService>();

      if (languageMode == "english") {
        content = await apiService.getExploreContentEnglish();

        if (content == null) {
          return null;
        }

        searchContent = content;
      } else {
        content = await apiService.getExploreContentArabic();

        if (content == null) {
          return null;
        }

        searchContent = content;
      }

      notifyListeners();
      return content;
    } catch (e) {
      rethrow;
    }
  }
}
// import 'package:stacked/stacked.dart';
// import 'package:uni_of_madinah/dependancy_injection.dart';
// import 'package:uni_of_madinah/presentation/contentDetail/content_detail_vm.dart';
// import 'package:uni_of_madinah/services/api_service.dart';

// class SearchContentService with ListenableServiceMixin {
//   List<IslamicContent> searchContent = [];

//   Future<void> updateSearchContent(List<IslamicContent> content) async {
//     searchContent = content;
//     notifyListeners();
//   }

//   Future<List<IslamicContent>?> fetchSearchContent(String languageMode) async {
//     print("Fetching search content");

//     try {
//       List<IslamicContent>? content;

//       final apiService = getIt<ApiService>();

//       if (languageMode == "english") {
//         content = await apiService.getExploreContentEnglish();

//         if (content == null) {
//           return null;
//         }

//         searchContent = content;
//       } else {
//         content = await apiService.getExploreContentArabic();

//         if (content == null) {
//           return null;
//         }

//         searchContent = content;
//       }
//       return content;
//       notifyListeners();
//     } catch (e) {
//       rethrow;
//     }
//   }
// }
