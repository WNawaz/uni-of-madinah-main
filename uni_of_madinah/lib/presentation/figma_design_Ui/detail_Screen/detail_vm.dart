import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import 'package:uni_of_madinah/constants.dart';
import 'package:uni_of_madinah/dependancy_injection.dart';
import 'package:uni_of_madinah/presentation/contentDetail/content_detail_vm.dart';
import 'package:uni_of_madinah/services/admin_service.dart';
import 'package:uni_of_madinah/services/api_service.dart';
import 'package:uni_of_madinah/services/content_deletion_service.dart';

import 'package:uni_of_madinah/services/content_detail_service.dart';
import 'package:uni_of_madinah/services/content_edit_service.dart';
import 'package:uni_of_madinah/services/edit_content_service.dart';
import 'package:uni_of_madinah/services/explore_content_service.dart';
import 'package:uni_of_madinah/services/search_content_service.dart';
import 'package:uni_of_madinah/services/volunteer_service.dart';

class DetailVM extends BaseViewModel {
  bool isEdittableState = false;
  bool isTitleEditing = false; // Track edit mode for title
  bool isDescriptionEditing = false;

  bool isAdmin = false;
  bool isVolunteer = false;
  bool isSavingContent = false;
  bool isDeletingContent = false;

  final volunteerService = getIt<VolunteerService>();
  final contentDetailService = getIt<ContentDetailService>();
  final editContentService = getIt<EditContentService>();
  final searchContentService = getIt<SearchContentService>();
  final exploreContentService = getIt<ExploreContentService>();

  LanguageMode selectedLanguage = LanguageMode.english;

  String userName = "";

  void init() {
    try {
      setContentEdittableStatus();

      setUserName();
      final adminService = getIt<AdminService>();
      isAdmin = adminService.getAdmin();
      notifyListeners();

      setBusy(false);
    } catch (e) {
      print("An error occured while init: $e");
    }
  }
  // void init() {
  //   try {
  //     // Define your variables here
  //     String title = 'Default Title';
  //     String content =
  //         "Lorem ipsum dolor sit amet consectetur. Pharetra tristique eget in fermentum nam tempus. Aenean eleifend dictum tempus ultricies condimentum sit pulvinar. Lobortis id mattis aliquet rhoncus aliquet vel. Interdum dignissim nunc cras et sit massa libero nam.Lorem ipsum dolor sit amet consectetur. Pharetra tristique eget in fermentum nam tempus. Aenean eleifend dictum tempus ultricies condimentum sit pulvinar. Lobortis id mattis aliquet rhoncus aliquet vel. Interdum dignissim nunc cras et sit massa libero nam.,Lorem ipsum dolor sit amet consectetur. Pharetra tristique eget in fermentum nam tempus. Aenean eleifend dictum tempus ultricies condimentum sit pulvinar. Lobortis id mattis aliquet rhoncus aliquet vel. Interdum dignissim nunc cras et sit massa libero nam,Lorem ipsum dolor sit amet consectetur. Pharetra tristique eget in fermentum nam tempus. Aenean eleifend dictum tempus ultricies condimentum sit pulvinar. Lobortis id mattis aliquet rhoncus aliquet vel. Interdum dignissim nunc cras et sit massa libero nam.,Lorem ipsum dolor sit amet consectetur. Pharetra tristique eget in fermentum nam tempus. Aenean eleifend dictum tempus ultricies condimentum sit pulvinar. Lobortis id mattis aliquet rhoncus aliquet vel. Interdum dignissim nunc cras et sit massa libero nam.";
  //     int index = 0; // Example value, replace with actual index if needed
  //     bool isRTL = false; // Example value, replace with actual value if needed
  //     String author = 'Default Author';
  //     String referenceLink = 'Default Reference Link';

  //     contentDetailService.content = IslamicContent(
  //       title: title,
  //       content: content,
  //       index: index,
  //       isRTL: isRTL,
  //       author: author,
  //       referenceLink: referenceLink,
  //     );
  //     notifyListeners();

  //     setContentEdittableStatus();
  //     setUserName();
  //   } catch (e) {
  //     print("An error occurred while initializing: $e");
  //   }
  //   notifyListeners();
  // }

  void setUserName() {
    final FirebaseAuth _auth = FirebaseAuth.instance;
    final User? user = _auth.currentUser;

    if (user != null) {
      userName = user.displayName ?? "";

      // use the first name only
      userName = userName.split(' ')[0];
    }
    notifyListeners();
  }

  void setContentNoneEdittableStatus() {
    final contentEdittingService = getIt<ContentEdittingService>();
    contentEdittingService.disableContentEditing();

    isEdittableState = false;
    isTitleEditing = false;
    isDescriptionEditing = false;

    contentEdittingService.clearContent();

    notifyListeners();
  }

  void setContentEdittableStatus() {
    final contentEdittableService = getIt<ContentEdittingService>();
    isEdittableState = contentEdittableService.isContentEditingEnabled;

    isTitleEditing = isDescriptionEditing = isEdittableState;

    if (isEdittableState) {
      contentEdittableService.setOriginalContent(
        contentDetailService.content!.title,
        contentDetailService.content!.content,
      );
    }

    print(
        "isEdittableState: $isEdittableState, isTitleEditing: $isTitleEditing, isDescriptionEditing: $isDescriptionEditing");

    notifyListeners();
  }

  void handleViewPop() {
    final contentEdittingService = getIt<ContentEdittingService>();
    contentEdittingService.disableContentEditing();
  }

  void toggleEditMode() {
    final contentEdittingService = getIt<ContentEdittingService>();
    contentEdittingService.enableContentEditing();

    isEdittableState = isTitleEditing = isDescriptionEditing = true;

    final contentEdittableService = getIt<ContentEdittingService>();

    contentEdittableService.setOriginalContent(
      contentDetailService.content!.title,
      contentDetailService.content!.content,
    );

    notifyListeners();
  }

  void toggleTitleEditMode() {
    isTitleEditing = !isTitleEditing; // Toggle edit mode for title
    notifyListeners();
  }

  void toggleDescriptionEditMode() {
    isDescriptionEditing =
        !isDescriptionEditing; // Toggle edit mode for description
    notifyListeners();
  }

  // void saveContent(IslamicContent content) async {
  //   try {
  //     print("Saving content");
  //     final contentEdittingService = getIt<ContentEdittingService>();
  //     await contentEdittingService.handleSaveContent();
  //     notifyListeners();
  //     await searchContentService
  //         .updateContent(content); // Update searchContent after saving
  //     notifyListeners(); // Notify listeners if needed
  //     setContentNoneEdittableStatus();
  //     print("Content saved");
  //   } catch (e) {
  //     print("An error occurred while saving content: $e");
  //   }
  // }
  // void saveContent(IslamicContent content) async {
  //   try {
  //     print("Saving content");

  //     isSavingContent = true;
  //     notifyListeners();

  //     final contentEdittingService = getIt<ContentEdittingService>();
  //     await contentEdittingService.handleSaveContent();

  //     notifyListeners();
  //     print("Content saved");

  //     print(
  //         "Edited title: ${contentEdittingService.editedTitle}, \n Edited description: ${contentEdittingService.editedDescription}");
  //     IslamicContent updatedContent = IslamicContent(
  //       title: contentEdittingService.editedTitle,
  //       content: contentEdittingService.editedDescription,
  //       index: content.index,
  //       isRTL: content.isRTL,
  //       author: content.author,
  //       referenceLink: content.referenceLink,
  //     );

  //     print(
  //         "Updated content: ${updatedContent.title}, \n ${updatedContent.content}");

  //     setContentNoneEdittableStatus();

  //     // Check if it's Explore content and update accordingly
  //     if (content.index == exploreContentIndex) {
  //       // Update exploreContent in ExploreContentService
  //       exploreContentService.updateContent(updatedContent);
  //       print("Explore content updated");
  //     } else {
  //       // Update searchContent in SearchContentService
  //       searchContentService.updateContent(updatedContent);
  //       print("Search content updated");
  //     }

  //     isSavingContent = false;
  //     notifyListeners();
  //   } catch (e) {
  //     print("An error occurred while saving content: $e");
  //   }
  // }

  void saveContent(IslamicContent content) async {
    try {
      print("Saving content");

      isSavingContent = true;
      notifyListeners();

      final contentEdittingService = getIt<ContentEdittingService>();
      await contentEdittingService.handleSaveContent();

      notifyListeners();
      print("Content saved");

      print(
          "Edited title: ${contentEdittingService.editedTitle}, \n Edited description: ${contentEdittingService.editedDescription}");
      IslamicContent updatedContent = IslamicContent(
        title: contentEdittingService.editedTitle,
        content: contentEdittingService.editedDescription,
        index: content.index,
        isRTL: content.isRTL,
        author: content.author,
        referenceLink: content.referenceLink,
      );

      print(
          "Updated content: ${updatedContent.title}, \n ${updatedContent.content}");

      setContentNoneEdittableStatus();

      // Update searchContent in SearchContentService
      searchContentService.updateContent(updatedContent);
      exploreContentService.updateExploreContent(updatedContent);

      isSavingContent = false;
      notifyListeners();
      print("Search content updated");
    } catch (e) {
      print("An error occurred while saving content: $e");
    }
  }

  // Future<void> deleteContent() async {
  //   try {
  //     //  final contentDetailService = getIt<ContentDetailService>();
  //     //  final IslamicContent? content = contentDetailService.content;
  //     //  final contentDeletionService = getIt<ContentDeletionService>();
  //     final apiService = getIt<ApiService>();

  //     await apiService.deleteContent("");

  //     // if (content == null) {
  //     //   throw Exception("Content is null, hence cannot be deleted");
  //     // }

  //     // final String contentIndex = content.index.toString();

  //     //await contentDeletionService.deleteContent(id);

  //     notifyListeners();
  //   } catch (e) {
  //     print("An error occurred while deleting content: $e");
  //   }
  // }

  Future<bool> deleteContent() async {
    setBusy(true);
    isDeletingContent = true;
    notifyListeners();

    try {
      final apiService = getIt<ApiService>();

      bool deleted = await apiService.deleteContent(
        contentDetailService.content!.index,
      );

      if (deleted) {
        print("Content deleted successfully");
      } else {
        print("Failed to delete content");
      }
      return deleted;
    } catch (e) {
      print("An error occurred while deleting content: $e");
      return false;
    } finally {
      isDeletingContent = false;
      setBusy(false);
      notifyListeners();
    }
  }
}
