import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import 'package:uni_of_madinah/constants.dart';
import 'package:uni_of_madinah/dependancy_injection.dart';

import 'package:uni_of_madinah/services/content_detail_service.dart';
import 'package:uni_of_madinah/services/edit_content_service.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:uni_of_madinah/services/volunteer_service.dart';

class IslamicContent {
  int index;
  String title;
  String content;
  String author;
  String referenceLink;
  bool isRTL;

  IslamicContent({
    required this.title,
    required this.content,
    required this.index,
    required this.isRTL,
    required this.author,
    required this.referenceLink,
  });
}

class ContentDetailViewModel extends ReactiveViewModel {
  final volunteerService = getIt<VolunteerService>();
  final contentDetailService = getIt<ContentDetailService>();

  late TextEditingController titleController;
  late TextEditingController descriptionController;

  late FlutterTts flutterTts;
  bool isTtsActive = false; // Track TTS state
  bool isTtsLoading = false; // Track TTS loading state
  bool isTitleEditing = false; // Track edit mode for title
  bool isDescriptionEditing = false;

  IconData fabIcon = Icons.volume_up; // Default FAB icon
  int? lastTtsPosition; // Track last TTS position

  LanguageMode selectedLanguage = LanguageMode.english;

  @override
  List<ListenableServiceMixin> get listenableServices => [
        volunteerService,
      ];

  void init() {
    titleController =
        TextEditingController(text: contentDetailService.content!.title);
    descriptionController =
        TextEditingController(text: contentDetailService.content!.content);
    flutterTts = FlutterTts();

    selectedLanguage = contentDetailService.selectedLanguage;

    print(
        "Content Detail View Model, isVolunteer: ${volunteerService.isVolunteer}");
    notifyListeners();
    _getDefaultVoice();

    // Initialize TTS settings
    flutterTts.setLanguage(contentDetailService.content!.isRTL ? 'ar' : 'en');
    flutterTts.setSpeechRate(0.5);
    flutterTts.setVolume(5.0);
    flutterTts.setPitch(0.5);
    //flutterTts.setVoice({"name": "Karen", "locale": "en-AU"});

    flutterTts.setStartHandler(() {
      isTtsActive = true;
      fabIcon = Icons.pause; // Update FAB icon to pause when TTS starts
      notifyListeners();
    });

    flutterTts.setCompletionHandler(() {
      isTtsActive = false;
      fabIcon =
          Icons.volume_up; // Reset FAB icon to volume up when TTS completes
      lastTtsPosition = null; // Reset lastTtsPosition when TTS completes
      notifyListeners();
    });
  }

  @override
  void dispose() {
    titleController.dispose();
    descriptionController.dispose();
    flutterTts.stop();
    super.dispose();
  }

  Future<void> speakContent() async {
    isTtsLoading = true; // Set loading state to true
    notifyListeners();

    print(
        'Content Detail View Model, isRTL: ${contentDetailService.content!.isRTL}');

    await flutterTts
        .setLanguage(contentDetailService.content!.isRTL ? 'ar' : 'en');
    await flutterTts.setIosAudioCategory(
      IosTextToSpeechAudioCategory.playAndRecord,
      [IosTextToSpeechAudioCategoryOptions.defaultToSpeaker],
    );

    String fullContent = '';
    fullContent += 'Title. ';
    fullContent += '${contentDetailService.content!.title}. ';
    fullContent += 'Description. ';
    fullContent += contentDetailService.content!.content;

    await flutterTts.speak(fullContent);
    isTtsActive = true;
    isTtsLoading = false; // Set loading state to false after speaking starts
    notifyListeners();
  }

  void pauseOrResumeTts() {
    if (isTtsActive) {
      flutterTts.pause(); // Pause TTS
    } else {
      //flutterTts.resume(); // Resume TTS
    }
    isTtsActive = !isTtsActive; // Toggle TTS state
    notifyListeners();
  }

  Future<void> _getDefaultVoice() async {
    var voice = await flutterTts.getDefaultVoice;
    if (voice != null) {
      print(voice);
    }
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

  // void saveContent() {
  //   if (isTitleEditing || isDescriptionEditing) {
  //     // Only save if in edit mode for title or description
  //     content.title = titleController.text;
  //     content.content = descriptionController.text;
  //     EditContentService.editApi(
  //       content.title,
  //       content.content,
  //       content.index.toString(),
  //       'english',
  //     );
  //     toggleTitleEditMode(); // Exit edit mode for title
  //     toggleDescriptionEditMode(); // Exit edit mode for description
  //   }
  // }
  void saveContent() {
    if (isTitleEditing && isDescriptionEditing) {
      // Both title and description are edited
      contentDetailService.content!.title = titleController.text;
      contentDetailService.content!.content = descriptionController.text;
      EditContentService.editApi(
        contentDetailService.content!.title,
        contentDetailService.content!.content,
        contentDetailService.content!.index.toString(),
        // 'english',
        selectedLanguage == LanguageMode.arabic ? 'arabic' : 'english',
      );
    } else if (isTitleEditing) {
      // Only title is edited
      contentDetailService.content!.title = titleController.text;
      EditContentService.ediTitleApi(
        contentDetailService.content!.title,
        contentDetailService.content!.index.toString(),
        // 'english',
        selectedLanguage == LanguageMode.arabic ? 'arabic' : 'english',
      );
    } else if (isDescriptionEditing) {
      // Only description is edited
      contentDetailService.content!.content = descriptionController.text;
      EditContentService.ediContentApi(
        contentDetailService.content!.content,
        contentDetailService.content!.index.toString(),
        // 'english',
        selectedLanguage == LanguageMode.arabic ? 'arabic' : 'english',
      );
    }

    toggleTitleEditMode(); // Exit edit mode for title
    toggleDescriptionEditMode(); // Exit edit mode for description
  }
}
