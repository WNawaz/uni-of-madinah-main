import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'package:stacked/stacked.dart';
import 'package:uni_of_madinah/constants.dart';
import 'package:uni_of_madinah/dependancy_injection.dart';

import 'package:uni_of_madinah/presentation/contentDetail/content_detail_vm.dart';
import 'package:uni_of_madinah/presentation/figma_design_Ui/detail_Screen/detail.dart';
import 'package:uni_of_madinah/services/admin_service.dart';
import 'package:uni_of_madinah/services/api_service.dart';

import 'package:uni_of_madinah/services/content_detail_service.dart';
import 'package:uni_of_madinah/services/content_edit_service.dart';
import 'package:uni_of_madinah/services/explore_content_edit_service.dart';
import 'package:uni_of_madinah/services/explore_content_service.dart';
import 'package:uni_of_madinah/services/search_content_service.dart';
import 'package:uni_of_madinah/services/user_service.dart';

import 'package:uni_of_madinah/services/volunteer_service.dart';

class SearchVM extends ReactiveViewModel {
  final TextEditingController searchController = TextEditingController();
  final SearchContentService searchContentService =
      getIt<SearchContentService>();
  final ExploreContentService exploreContentService =
      getIt<ExploreContentService>();
  final UserService userService = getIt<UserService>();
  final ApiService apiService = getIt<ApiService>();

  int selectedLanguage = 0;

  final VolunteerService _volunteerService = getIt<VolunteerService>();

  List<IslamicContent> exploreContent = [];
  List<String> authors = [];
  List<String> links = [];
  List<String> selectedAuthors = [];
  List<String> selectedLinks = [];
  List<String> storedSelectedAuthors = [];
  List<String> storedSelectedLinks = [];

  bool isSubscribedToPremium = false;

  bool isLoading = false;
  bool isMicListening = false;
  bool isListening = false;
  bool isAdminsOrVolunteers = false;
  bool isDataFetched = false;

  String? errorMessage;
  LanguageMode selectedLanguageMode =
      LanguageMode.english; // Default language mode
  String baseUrl = 'https://f80f-119-156-232-132.ngrok-free.app/';

  stt.SpeechToText speech = stt.SpeechToText();
  late final BannerAd bannerAd;

  bool hasSearched = false;
  bool isVolunteer = false;
  bool isAdmin = false;

  String userName = "";

  @override
  List<ListenableServiceMixin> get listenableServices => [
        _volunteerService,
        searchContentService,
        exploreContentService,
        userService
      ];

  List<IslamicContent> get searchContent => searchContentService.searchContent;
  List<IslamicContent> get exploreeContent =>
      exploreContentService.exploreContent;

  void init() async {
    try {
      bannerAd = _loadBannerAd();
      bannerAd.load();

      setEdittableStatus();

      setUserName();
      final adminService = getIt<AdminService>();
      final volunteerService = getIt<VolunteerService>();

      isAdmin = adminService.getAdmin();

      isVolunteer = volunteerService.isVolunteer;

      isAdminsOrVolunteers = isAdmin || isVolunteer;

      final exploreContentService = getIt<ExploreContentService>();

      if (exploreContentService.exploreContent.isEmpty) {
        isLoading = true;
        notifyListeners();

        final languageMode = selectedLanguage == 0 ? 'english' : 'arabic';
        isLoading = true;
        notifyListeners();

        await exploreContentService.fetchExploreContent(languageMode);

        print('Explore content fetched');

        exploreContent = exploreContentService.exploreContent;

        isLoading = false;
        notifyListeners();
        checkUserSubscriptionStatus();
        notifyListeners();

        // Fetch authors and links during initialization
        await fetchLinksAndAuthors(() {
          isDataFetched = true; // Data is fetched
          notifyListeners();
        });
      } else {
        exploreContent = exploreContentService.exploreContent;
      }
    } catch (e) {
      print("An error occured while init...: $e");
    }
  }

  void checkUserSubscriptionStatus() {
    isSubscribedToPremium = userService.isPremium;
    notifyListeners();
  }

  void loadEnglishContent() async {
    isLoading = true;
    notifyListeners();

    final exploreContentService = getIt<ExploreContentService>();
    final content = await exploreContentService.fetchExploreContent('english');

    if (content != null) {
      exploreContent = content;
    } else {
      // Handle error or show a message
    }

    isLoading = false;
    notifyListeners();
  }

  void loadArabicContent() async {
    isLoading = true;
    notifyListeners();

    final exploreContentService = getIt<ExploreContentService>();
    final content = await exploreContentService.fetchExploreContent('arabic');

    if (content != null) {
      exploreContent = content;
    } else {}

    isLoading = false;
    notifyListeners();
  }

  void setEdittableStatus() {
    final volunteerService = getIt<VolunteerService>();
    final adminService = getIt<AdminService>();

    isVolunteer = volunteerService.isVolunteer;
    isAdmin = adminService.getAdmin();
    notifyListeners();
  }

  void setUserName() {
    final FirebaseAuth auth = FirebaseAuth.instance;
    final User? user = auth.currentUser;

    if (user != null && user.displayName != null) {
      userName = user.displayName!;

      // take the first name only
      userName = userName.split(' ')[0];

      notifyListeners();
    }
  }

  void updateSelectedLanguage(int index) {
    selectedLanguage = index;
    notifyListeners();
  }

  void hanldeContentEditTap(int index, List<IslamicContent> contentList) {
    final contentDetailService = getIt<ContentDetailService>();
    contentDetailService.content = contentList[index];
    contentDetailService.updateLanguage(selectedLanguageMode);

    final contentEdittingService = getIt<ContentEdittingService>();
    contentEdittingService.enableContentEditing();

    Get.to(const ContentDetailedScreen());
  }

  void hanldeExploreContentEditTap(
      int index, List<IslamicContent> contentList) {
    final contentDetailService = getIt<ContentDetailService>();
    contentDetailService.content = contentList[index];
    contentDetailService.updateLanguage(selectedLanguageMode);

    final exploreContentEdittingService =
        getIt<ExploreContentEdittingService>();
    exploreContentEdittingService.enableContentEditing();

    Get.to(const ContentDetailedScreen());
  }

  BannerAd _loadBannerAd() {
    final adUnitId = Platform.isIOS
        ? 'ca-app-pub-7893908487522866/6658913048'
        : 'ca-app-pub-7893908487522866/6298098197'; // Android test ad unit ID "ca-app-pub-3940256099942544/9214589741"

    return BannerAd(
      adUnitId: adUnitId,
      size: AdSize.banner,
      request: const AdRequest(),
      listener: const BannerAdListener(),
    );
  }

  void updateIsLoadingState() {
    isLoading = !isLoading;
    notifyListeners();
  }

  void handleSearchTap(int index) {
    final contentDetailService = getIt<ContentDetailService>();
    contentDetailService.content = searchContentService.searchContent[index];
    contentDetailService.updateLanguage(selectedLanguageMode);
    Get.to(const ContentDetailedScreen());
  }

  void handleExploreTap(int index) {
    final contentDetailService = getIt<ContentDetailService>();
    contentDetailService.content = exploreContentService.exploreContent[index];
    contentDetailService.updateLanguage(selectedLanguageMode);
    Get.to(const ContentDetailedScreen());
  }

  void showLanguageChangedSnackbar(BuildContext context, String language) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Language changed to $language')),
    );
  }

  void clearFilteredContent() {
    searchContentService.searchContent.clear();
    notifyListeners();
  }

  void updateLanguage(LanguageMode language) {
    selectedLanguageMode = language;
    clearFilteredContent();
    notifyListeners();
  }

  void filterContent(String value) async {
    String trimmedValue = value.trim().replaceAll(RegExp(r'\s+'), ' ');

    if (trimmedValue.isEmpty) {
      print('Empty search query, not performing search.');
      return;
    }
    // Update the TextEditingController to show the trimmed value
    searchController.text = trimmedValue;
    searchController.selection = TextSelection.fromPosition(
      TextPosition(offset: trimmedValue.length),
    );

    print('Search query: $trimmedValue');
    print('Selected language: $selectedLanguageMode');
    print('Stored Selected authors: $storedSelectedAuthors');
    print('Stored Selected links: $storedSelectedLinks');

    updateIsLoadingState();
    errorMessage = null;

    notifyListeners();
    try {
      hasSearched = true;
      notifyListeners();

      final apiService = getIt<ApiService>();

      List<IslamicContent>? data;
      // Determine if user is an admin or volunteer
      bool isAdminOrVolunteer = isVolunteer || isAdmin;

      // Add filters to API query
      if (isAdminOrVolunteer) {
        if (selectedLanguageMode == LanguageMode.arabic) {
          data = await apiService.queryArabicContent(
              trimmedValue, storedSelectedAuthors, storedSelectedLinks);
        } else {
          data = await apiService.queryEnglishContent(
              trimmedValue, storedSelectedAuthors, storedSelectedLinks);
        }
      } else {
        if (selectedLanguageMode == LanguageMode.arabic) {
          data = await apiService.queryEditedArabicContent(
              trimmedValue, storedSelectedAuthors, storedSelectedLinks);
        } else {
          data = await apiService.queryEditedEnglishContent(
              trimmedValue, storedSelectedAuthors, storedSelectedLinks);
        }
      }
      if (data == null) {
        errorMessage = 'Failed to load content';
        print('Error: $errorMessage');
        return;
      }
      searchContentService.setSearchContent(data);
      notifyListeners();
    } catch (e) {
      errorMessage = 'Failed to load content';
      print('Error: $e');
    }

    updateIsLoadingState();
  }

  Future<void> fetchEnglishAuthorsAndLinks(bool isAdminsOrVolunteers) async {
    isLoading = true;
    notifyListeners();

    try {
      // Always send isAdmin as true
      final result =
          await apiService.getEnglishAuthorsAndLinks(isAdminsOrVolunteers);
      if (result != null) {
        authors = result['authors'] ?? [];
        links = result['links'] ?? [];
      } else {
        authors = [];
        links = [];
      }
    } catch (e) {
      print("Error fetching English authors and links: $e");
      authors = [];
      links = [];
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> fetchArabicAuthorsAndLinks(bool isAdminsOrVolunteers) async {
    isLoading = true;
    notifyListeners();

    try {
      final result =
          await apiService.getArabicAuthorsAndLinks(isAdminsOrVolunteers);
      if (result != null) {
        authors = result['authors'] ?? [];
        links = result['links'] ?? [];
      } else {
        authors = [];
        links = [];
      }
    } catch (e) {
      print("Error fetching Arabic authors and links: $e");
      authors = [];
      links = [];
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> fetchLinksAndAuthors([Function? onComplete]) async {
    // Return if the data is already fetched
    if (authors.isNotEmpty && links.isNotEmpty) {
      if (onComplete != null) onComplete();
      return;
    }

    try {
      if (selectedLanguageMode == LanguageMode.arabic) {
        await fetchArabicAuthorsAndLinks(isAdminsOrVolunteers);
      } else {
        await fetchEnglishAuthorsAndLinks(isAdminsOrVolunteers);
      }
    } catch (e) {
      print("Error fetching authors and links: $e");
    } finally {
      isLoading = false;
      notifyListeners();
      if (onComplete != null) onComplete();
    }
  }

  void toggleAuthorSelection(String authorId) {
    if (selectedAuthors.contains(authorId)) {
      selectedAuthors.remove(authorId);
    } else {
      selectedAuthors.add(authorId);
    }
    notifyListeners();
  }

  void toggleLinkSelection(String linkIndex) {
    if (selectedLinks.contains(linkIndex)) {
      selectedLinks.remove(linkIndex);
    } else {
      selectedLinks.add(linkIndex);
    }
    notifyListeners();
  }

  void resetFilters() {
    selectedAuthors.clear();
    selectedLinks.clear();
  }

  void applyFilters() {
    // Save the selected filters
    storedSelectedAuthors = selectedAuthors.cast<String>();
    storedSelectedLinks = selectedLinks.cast<String>();
  }

  void handleMicPressed() {
    if (isMicListening) {
      stopListening();
    } else {
      startListening();
    }
  }

  void startListening() async {
    bool available = await speech.initialize(
      onStatus: (status) {
        if (status == 'listening') {
          isListening = true;
        } else {
          isListening = false;
        }
        notifyListeners();
        print('Speech recognition status: $status');
      },
      onError: (error) {
        print('Speech recognition error: $error');
        isListening = false;
        isMicListening = false;
        notifyListeners();
      },
    );

    if (available) {
      isMicListening = true;
      notifyListeners();

      String selectedLanguageCode =
          selectedLanguageMode == LanguageMode.arabic ? 'ar' : 'en';

      await speech.listen(
        onResult: (result) {
          if (result.finalResult) {
            searchController.text = result.recognizedWords;
            stopListening();
          }
        },
        localeId: selectedLanguageCode,
      );
    } else {
      print('Speech recognition not available');
      isMicListening = false;
      notifyListeners();
    }
  }

  void stopListening() async {
    await speech.stop();
    isListening = false;
    isMicListening = false;
    notifyListeners();
    filterContent(searchController.text);
  }

  Future<void> addVolunteerEmail(String email) async {
    await _volunteerService.addVolunteerEmail(email);
  }

  void disposeBannerAd() {
    bannerAd.dispose();
    super.dispose();
  }
}
