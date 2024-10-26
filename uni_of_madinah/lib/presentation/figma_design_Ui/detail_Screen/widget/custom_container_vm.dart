import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:stacked/stacked.dart';
import 'package:uni_of_madinah/constants.dart';
import 'package:uni_of_madinah/dependancy_injection.dart';
import 'package:uni_of_madinah/presentation/contentDetail/content_detail_vm.dart';
import 'package:uni_of_madinah/services/api_service.dart';

import 'package:uni_of_madinah/services/content_detail_service.dart';
import 'package:uni_of_madinah/services/content_edit_service.dart';
import 'package:uni_of_madinah/services/content_summary_service.dart';

import 'package:uni_of_madinah/services/volunteer_service.dart';

class CustomContainerVM extends ReactiveViewModel {
  FlutterTts flutterTts = FlutterTts(); // Initialize Flutter TTS

  bool isSelected = false;
  bool showSummary = false;

  bool loadingSummary = false;

  String? summary;
  final volunteerService = getIt<VolunteerService>();
  final contentDetailService = getIt<ContentDetailService>();
  final contentEdittingService = getIt<ContentEdittingService>();

  final TextEditingController titleController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();

  bool isTtsActive = false; // Track TTS state
  bool isTtsLoading = false; // Track TTS loading state
  bool isDescriptionEditing = false;

  IconData fabIcon = Icons.volume_up; // Default FAB icon
  int? lastTtsPosition; // Track last TTS position

  LanguageMode selectedLanguage = LanguageMode.english;

  @override
  List<ListenableServiceMixin> get listenableServices =>
      [contentEdittingService];

  bool get isDescriptionEditingEnabled =>
      contentEdittingService.isContentEditingEnabled;

  void changeSelected() {
    isSelected = !isSelected;

    notifyListeners();
  }

  void handleSummaryTap(String content) async {
    showSummary = !showSummary;
    notifyListeners();

    print("Show summary is $showSummary");

    if (showSummary && summary == null) {
      print("Getting summary");
      await getSummary(content,
          selectedLanguage == LanguageMode.arabic ? 'arabic' : 'english');
    }
  }

  Future<void> getSummary(String content, String languageCode) async {
    try {
      loadingSummary = true;
      notifyListeners();

      final apiService = getIt<ApiService>();

      if (languageCode == 'arabic') {
        summary = await apiService.getArabicContentSummary(content);
      } else if (languageCode == 'english') {
        summary = await apiService.getEnglishContentSummary(content);
      }
      print(summary);
      loadingSummary = false;
      notifyListeners();
    } catch (e) {
      loadingSummary = false;
      notifyListeners();
      print("An error occurred: $e");
    }
  }

  // Future<void> getSummary(String content, String languageCode) async {
  //   try {
  //     loadingSummary = true;
  //     notifyListeners();

  //     // final ContentSummaryService contentSummaryService =
  //     //     ContentSummaryService();
  //     // summary = await contentSummaryService.getContentSummaries(
  //     //     content, languageCode);
  //     // final contentEdittableService = getIt<ContentEdittingService>();
  //     final apiService = getIt<ApiService>();

  //     summary = await apiService
  //         .summariseEnglishContentEndpoint; //     content, languageCode);      print("summarise title content");

  //     print(summary);

  //     loadingSummary = false;
  //     notifyListeners();
  //   } catch (e) {
  //     loadingSummary = false;
  //     notifyListeners();
  //     print("An error occurred: $e");
  //   }
  // }

  void init() {
    print("Init called");
    titleController.text = contentDetailService.content!.title;
    descriptionController.text = contentDetailService.content!.content;
    flutterTts = FlutterTts();

    selectedLanguage = contentDetailService.selectedLanguage;

    final contentEdittingService = getIt<ContentEdittingService>();
    isDescriptionEditing = contentEdittingService.isContentEditingEnabled;

    print(
        "Content Detail View Model, isVolunteer: ${volunteerService.isVolunteer}");
    notifyListeners();

    // Initialize TTS settings
    flutterTts.setLanguage(contentDetailService.content!.isRTL ? 'ar' : 'en');
    flutterTts.setSpeechRate(0.5);
    flutterTts.setVolume(5.0);
    flutterTts.setPitch(0.5);
    flutterTts.setVoice({"name": "Karen", "locale": "en-AU"});

    flutterTts.setStartHandler(() {
      isTtsActive = true;
      fabIcon = Icons.pause; // Update FAB icon to pause when TTS starts
      notifyListeners();
    });

    flutterTts.setCompletionHandler(() {
      isTtsActive = false;
      fabIcon =
          Icons.volume_up; // Reset FAB icon to volume up when TTS completes
      lastTtsPosition = null;
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

  void handleTitleChange(String value) {
    final contentEdittingService = getIt<ContentEdittingService>();
    contentEdittingService.updateTitle(titleController.text);

    notifyListeners();
  }

  void handleDescriptionChange(String value) {
    final cursorPosition = descriptionController.selection.baseOffset;

    descriptionController.value = TextEditingValue(
      text: value,
      selection: TextSelection.collapsed(offset: cursorPosition),
    );

    final contentEdittingService = getIt<ContentEdittingService>();
    contentEdittingService.updateDescription(value);

    notifyListeners();
  }

  void hideSummary() {
    showSummary = false;
    notifyListeners();
  }

  Future<void> speakContent() async {
    isTtsLoading = true; // Set loading state to true
    notifyListeners();

    contentDetailService.content = IslamicContent(
      index: 0,
      title: titleController.text,
      content: descriptionController.text,
      isRTL: selectedLanguage == LanguageMode.arabic,
      author: '',
      referenceLink: '',
    );

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
}
