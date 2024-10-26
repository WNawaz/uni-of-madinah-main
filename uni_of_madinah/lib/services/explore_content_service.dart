import 'package:stacked/stacked.dart';
import 'package:uni_of_madinah/dependancy_injection.dart';
import 'package:uni_of_madinah/presentation/contentDetail/content_detail_vm.dart';
import 'package:uni_of_madinah/services/admin_service.dart';
import 'package:uni_of_madinah/services/api_service.dart';
import 'package:uni_of_madinah/services/volunteer_service.dart';

class ExploreContentService with ListenableServiceMixin {
  List<IslamicContent> exploreContent = [];

  void addContent(IslamicContent content) {
    exploreContent.add(content);
  }

  void removeContent(IslamicContent content) {
    exploreContent.remove(content);
  }

  void clearContent() {
    exploreContent.clear();
  }

  Future<void> updateExploreContent(IslamicContent content) async {
    final index =
        exploreContent.indexWhere((element) => element.index == content.index);
    if (index != -1) {
      exploreContent[index] = content;
      notifyListeners();
      print("Search content updated");
    } else {
      print(
          "Error: Content with index ${content.index} not found in searchContent.");
      // Handle the error gracefully, such as logging or ignoring the update.
    }
  }

  IslamicContent? getContent(int index) {
    return exploreContent.firstWhere(
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

  List<IslamicContent> getExploreContent() {
    return exploreContent;
  }

  void setExploreContent(List<IslamicContent> content) {
    exploreContent = content;
  }

  void removeContentByIndex(int index) {
    exploreContent.removeWhere((element) => element.index == index);
  }

  void clear() {
    exploreContent.clear();
  }

  Future<List<IslamicContent>?> fetchExploreContent(
    String languageMode,
  ) async {
    try {
      print("Fetching explore content");

      List<IslamicContent>? content;

      final apiService = getIt<ApiService>();
      final volunteerService = getIt<VolunteerService>();
      final adminService = getIt<AdminService>();

      bool isAdminOrVolunteer =
          adminService.getAdmin() || volunteerService.isVolunteer;

      if (isAdminOrVolunteer) {
        if (languageMode == "arabic") {
          content = await apiService.getExploreContentArabic();
        } else if (languageMode == "english") {
          content = await apiService.getExploreContentEnglish();
        }
      } else {
        if (languageMode == "arabic") {
          content = await apiService.getEditedExploreContentArabic();
        } else if (languageMode == "english") {
          content = await apiService.getEditedExploreContentEnglish();
        }
      }

      if (content == null) {
        return null;
      }

      exploreContent = content;

      return content;
    } catch (e) {
      rethrow;
    }
  }

  // Future<List<IslamicContent>?> fetchExploreContent(
  //   String languageMode,
  // ) async {
  //   // Fetch content from API

  //   try {
  //     print("Fetching explore content");

  //     List<IslamicContent>? content;

  //     final apiService = getIt<ApiService>();

  //     if (languageMode == "english") {
  //       content = await apiService.getExploreContentArabic();
  //       print(
  //           "***********************Content fetched********************:$content");

  //       if (content == null) {
  //         return null;
  //       }

  //       exploreContent = content;
  //     } elseif (languageMode == "arabic")  {
  //       content = await apiService.getExploreContentArabic();

  //       if (content == null) {
  //         return null;
  //       }

  //       exploreContent = content;
  //     }

  //     return content;
  //   } catch (e) {
  //     rethrow;
  //   }
  // }
}
