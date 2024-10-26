// // import 'package:flutter/material.dart';

// // class ContentEditService extends ChangeNotifier {
// //   static final ContentEditService _instance = ContentEditService._internal();

// //   // Define the instance getter
// //   static ContentEditService get instance => _instance;

// //   factory ContentEditService() {
// //     return _instance;
// //   }

// //   ContentEditService._internal();

// //   String _editedTitle = '';
// //   String _editedDescription = '';

// //   String get editedTitle => _editedTitle;
// //   String get editedDescription => _editedDescription;

// //   void updateTitle(String newTitle) {
// //     _editedTitle = newTitle;
// //     notifyListeners();
// //   }

// //   void updateDescription(String newDescription) {
// //     _editedDescription = newDescription;
// //     notifyListeners();
// //   }

// //   // You can add methods here for saving/updating content in the backend
// // }

// import 'package:flutter/material.dart';

// class ContentEditService extends ChangeNotifier {
//   static final ContentEditService _instance = ContentEditService._internal();

//   // Define the instance getter
//   static ContentEditService get instance => _instance;

//   factory ContentEditService() {
//     return _instance;
//   }

//   ContentEditService._internal();

//   String _editedTitle = '';
//   String _editedDescription = '';

//   String get editedTitle => _editedTitle;
//   String get editedDescription => _editedDescription;

//   void updateTitle(String newTitle) {
//     _editedTitle = newTitle;
//     notifyListeners();
//   }

//   void updateDescription(String newDescription) {
//     _editedDescription = newDescription;
//     notifyListeners();
//   }

//   // You can add methods here for saving/updating content in the backend
// }

import 'package:stacked/stacked.dart';
import 'package:uni_of_madinah/dependancy_injection.dart';
import 'package:uni_of_madinah/presentation/contentDetail/content_detail_vm.dart';
import 'package:uni_of_madinah/services/api_service.dart';
import 'package:uni_of_madinah/services/content_detail_service.dart';

class ContentEdittingService with ListenableServiceMixin {
  String _originalTitle = '';
  String _originalDescription = '';

  String _editedTitle = '';
  String _editedDescription = '';

  String get editedTitle => _editedTitle;
  String get editedDescription => _editedDescription;

  bool isContentEditingEnabled = false;

  void enableContentEditing() {
    isContentEditingEnabled = true;
    notifyListeners();
  }

  void disableContentEditing() {
    isContentEditingEnabled = false;
    notifyListeners();
  }

  void setOriginalContent(String title, String description) {
    _originalTitle = title;
    _originalDescription = description;

    _editedTitle = title;
    _editedDescription = description;
  }

  void updateTitle(String newTitle) {
    print("updating title, $newTitle");
    _editedTitle = newTitle;
  }

  void updateDescription(String newDescription) {
    print("updating description");
    _editedDescription = newDescription;
  }

  void clearContent() {
    _originalTitle = '';
    _originalDescription = '';

    _editedTitle = '';
    _editedDescription = '';

    print("Edit content cleared");
  }

  Future<void> saveTitle({
    required String id,
    required String newTitle,
    required String language,
  }) async {
    // Save the title to the backend

    try {
      final apiService = getIt<ApiService>();

      print("updating title content");
      await apiService.updateTitleContent(
        id,
        newTitle,
        language,
      );

      print("title content updated");
    } catch (e) {
      rethrow;
    }
  }

  Future<void> saveDescription({
    required String id,
    required String newDescription,
    required String language,
  }) async {
    // Save the description to the backend

    try {
      final apiService = getIt<ApiService>();

      print("updating description content");
      await apiService.updateDescriptionContent(
        id,
        newDescription,
        language,
      );

      print("description content updated");
    } catch (e) {
      rethrow;
    }
  }

  Future<void> handleSaveContent() async {
    // Save content to the backend

    try {
      print("handleSaveContent saving content");
      final contentDetailService = getIt<ContentDetailService>();
      final IslamicContent? content = contentDetailService.content;

      if (content == null) {
        print("Content is null, hence cannot be saved");
        throw Exception("Content is null, hence cannot be saved");
      }

      print("original title: $_originalTitle");
      print("edited title: $_editedTitle");

      print("original description: $_originalDescription");
      print("edited description: $_editedDescription");

      final String contentIndex = content.index.toString();
      final String contentLanguage = content.isRTL ? 'arabic' : 'english';

      // check if the title is editted only
      if (_originalTitle != _editedTitle &&
          _originalDescription == _editedDescription) {
        print("updating title only");
        // Save the title only
        await saveTitle(
          id: contentIndex,
          newTitle: _editedTitle,
          language: contentLanguage,
        );
        return;
      }

      notifyListeners();
      // check if the description is editted only
      if (_originalDescription != _editedDescription &&
          _originalTitle == _editedTitle) {
        // Save the description only

        print("updating description only");
        await saveDescription(
          id: contentIndex,
          newDescription: _editedDescription,
          language: contentLanguage,
        );
        return;
      }
      notifyListeners();

      // check if both title and description are editted
      if (_originalTitle != _editedTitle &&
          _originalDescription != _editedDescription) {
        // Save both title and description

        print("updating both title and description");
        await saveTitle(
          id: contentIndex,
          newTitle: _editedTitle,
          language: contentLanguage,
        );

        await saveDescription(
          id: contentIndex,
          newDescription: _editedDescription,
          language: contentLanguage,
        );

        return;
      }
      notifyListeners();

      print("No changes made to the content");
    } catch (e) {
      rethrow;
    }
  }
}
