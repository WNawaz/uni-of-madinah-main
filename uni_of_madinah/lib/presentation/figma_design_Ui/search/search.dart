import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:shimmer/shimmer.dart';
import 'package:stacked/stacked.dart';
import 'package:uni_of_madinah/constants.dart';
import 'package:uni_of_madinah/presentation/contentDetail/content_detail_vm.dart';
import 'package:uni_of_madinah/presentation/figma_design_Ui/search/search_vm.dart';
import 'package:uni_of_madinah/presentation/figma_design_Ui/search/widget/appbar.dart';
import 'package:uni_of_madinah/presentation/figma_design_Ui/search/widget/drawer.dart';

class SearchScreen extends StatelessWidget {
  const SearchScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<SearchVM>.reactive(
        viewModelBuilder: () => SearchVM(),
        onViewModelReady: (viewModel) {
          viewModel.init();
          viewModel.checkUserSubscriptionStatus();
        },
        onDispose: (model) => model.disposeBannerAd(),
        builder: (context, viewModel, child) => Scaffold(
            drawer: const MyDrawer(),
            bottomNavigationBar: viewModel.isSubscribedToPremium
                ? null
                : Semantics(
                    excludeSemantics: true,
                    label: 'Banner ad',
                    child: Container(
                      alignment: Alignment.bottomCenter,
                      width: double.infinity,
                      height: 50.h,
                      child: AdWidget(ad: viewModel.bannerAd),
                    ),
                  ),
            body: RefreshIndicator(
              onRefresh: () async {
                viewModel.checkUserSubscriptionStatus();
              },
              child: SizedBox(
                width: double.infinity,
                height: double.infinity,
                child: Stack(children: [
                  Container(
                    height: 185.h,
                    width: double.infinity,
                    color: HexColor("#BFC8CC"),
                    child: CustomAppBar(
                      userName: viewModel.userName,
                    ),
                  ),
                  Positioned(
                      top: 150.h,
                      left: 0,
                      right: 0,
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 20.sp),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            SearchBar(
                              hintText: 'Search',
                              controller: viewModel.searchController,
                              backgroundColor:
                                  MaterialStateProperty.resolveWith(
                                (states) => HexColor("#F5FAFD"),
                              ),
                              leading: const Icon(Icons.search),
                              padding: MaterialStateProperty.resolveWith(
                                (states) => EdgeInsets.symmetric(
                                  horizontal: 10.sp,
                                ),
                              ),
                              trailing: [
                                viewModel.isMicListening
                                    ? IconButton(
                                        onPressed: () {
                                          viewModel.handleMicPressed();
                                        },
                                        icon: const Icon(Icons.stop),
                                      )
                                    : IconButton(
                                        onPressed: () {
                                          viewModel.handleMicPressed();
                                        },
                                        icon: Semantics(
                                          button: false,
                                          excludeSemantics: true,
                                          label: 'Micro phone',
                                          child: const Icon(Icons.mic),
                                        ),
                                      ),
                              ],
                              onSubmitted: (value) {
                                String trimmedValue = value.trim();
                                if (trimmedValue.isNotEmpty) {
                                  viewModel.filterContent(trimmedValue);
                                }
                              },
                            ),
                            SizedBox(height: 20.h),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Semantics(
                                  excludeSemantics: true,
                                  label:
                                      'English language selection button. Double Tap to select.',
                                  child: InputChip(
                                    label: const Text('English'),
                                    shape: RoundedRectangleBorder(
                                      borderRadius:
                                          BorderRadius.circular(20.sp),
                                    ),
                                    showCheckmark: false,
                                    selected: viewModel.selectedLanguage == 0,
                                    onPressed: () {
                                      viewModel.loadEnglishContent();
                                      viewModel.updateSelectedLanguage(0);
                                      viewModel
                                          .updateLanguage(LanguageMode.english);
                                    },
                                    selectedColor: HexColor("#CFE6F0"),
                                  ),
                                ),
                                SizedBox(width: 16.w),
                                Semantics(
                                  excludeSemantics: true,
                                  label:
                                      'Arabic language selection button. Double Tap to select.',
                                  child: InputChip(
                                    label: const Text('عربي'),
                                    selected: viewModel.selectedLanguage == 1,
                                    shape: RoundedRectangleBorder(
                                      borderRadius:
                                          BorderRadius.circular(20.sp),
                                    ),
                                    showCheckmark: false,
                                    onPressed: () {
                                      viewModel.loadArabicContent();
                                      viewModel.updateSelectedLanguage(1);
                                      viewModel
                                          .updateLanguage(LanguageMode.arabic);
                                    },
                                    selectedColor: HexColor("#CFE6F0"),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 16.h),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  !viewModel.hasSearched
                                      ? "Explore"
                                      : "Searches",
                                  style:
                                      Theme.of(context).textTheme.titleMedium,
                                ),
                                IconButton(
                                  icon: Icon(Icons.tune_rounded),
                                  onPressed: () {
                                    _showBottomSheet(context, viewModel);
                                  },
                                ),
                              ],
                            ),
                            SizedBox(height: 0.h),
                            SizedBox(
                              height: 570.h,
                              width: 400.w,
                              child: !viewModel.hasSearched
                                  ? viewModel.isLoading
                                      ? _buildShimmerList()
                                      : ExploreContent(
                                          onSearchTap: (index) {
                                            viewModel.handleExploreTap(index);
                                          },
                                          selectedLanguage:
                                              viewModel.selectedLanguageMode,
                                          exploreContent:
                                              viewModel.exploreeContent,
                                          canEdit: viewModel.isVolunteer,
                                          onEditTap: viewModel
                                              .hanldeExploreContentEditTap,
                                        )
                                  : viewModel.isLoading
                                      ? _buildShimmerList()
                                      : SearchedContent(
                                          onSearchTap: (index) {
                                            viewModel.handleSearchTap(index);
                                          },
                                          selectedLanguage:
                                              viewModel.selectedLanguageMode,
                                          searchContent:
                                              viewModel.searchContent,
                                          canEdit: viewModel.isVolunteer,
                                          onEditTap:
                                              viewModel.hanldeContentEditTap,
                                        ),
                            ),
                          ],
                        ),
                      ))
                ]),
              ),
            )));
  }

  void _showBottomSheet(BuildContext context, SearchVM viewModel) async {
    viewModel.resetFilters();

    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Padding(
          padding: EdgeInsets.all(16.0),
          child: StatefulBuilder(
            builder: (BuildContext context, StateSetter setState) {
              // Fetch data if not already fetched
              if (viewModel.authors.isEmpty && viewModel.links.isEmpty) {
                viewModel.fetchLinksAndAuthors(() {
                  setState(() {});
                });
              }

              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Center(
                    child: Text(
                      'Available Authors and Sources',
                      style: Theme.of(context)
                          .textTheme
                          .bodyLarge!
                          .copyWith(fontWeight: FontWeight.bold),
                    ),
                  ),
                  SizedBox(height: 40.h),
                  Text('Authors',
                      style: TextStyle(
                          color: HexColor("#05677E"),
                          fontWeight: FontWeight.bold)),
                  SizedBox(
                    height: 65.h,
                    child: viewModel.authors.isEmpty
                        ? _buildShimmerList()
                        : ListView(
                            scrollDirection: Axis.horizontal,
                            children: viewModel.authors.map((author) {
                              return Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 4.0),
                                child: FilterChip(
                                  label: Text(author),
                                  selected: viewModel.selectedAuthors
                                      .contains(author),
                                  onSelected: (bool selected) {
                                    setState(() {
                                      viewModel.toggleAuthorSelection(author);
                                    });
                                  },
                                  selectedColor: HexColor("#CFE6F0"),
                                ),
                              );
                            }).toList(),
                          ),
                  ),
                  SizedBox(height: 15.h),
                  Text('Sources',
                      style: TextStyle(
                          color: HexColor("#05677E"),
                          fontWeight: FontWeight.bold)),
                  SizedBox(
                    height: 65.h,
                    child: viewModel.links.isEmpty
                        ? _buildShimmerList()
                        : ListView(
                            scrollDirection: Axis.horizontal,
                            children: viewModel.links.map((link) {
                              return Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 4.0),
                                child: FilterChip(
                                  label: Text(link),
                                  selected:
                                      viewModel.selectedLinks.contains(link),
                                  onSelected: (bool selected) {
                                    setState(() {
                                      viewModel.toggleLinkSelection(link);
                                    });
                                  },
                                  selectedColor: HexColor("#CFE6F0"),
                                ),
                              );
                            }).toList(),
                          ),
                  ),
                  SizedBox(height: 20.h),
                  Center(
                    child: ElevatedButton(
                      onPressed: () {
                        viewModel.applyFilters();
                        Navigator.pop(context);
                      },
                      child: Text('Apply Filters'),
                      style: ElevatedButton.styleFrom(
                        foregroundColor: HexColor("#05677E"),
                        textStyle: TextStyle(
                            fontSize: 14.sp, fontWeight: FontWeight.bold),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(100.sp),
                          side: BorderSide(
                            color: HexColor("#70787C"),
                          ),
                        ),
                        minimumSize: Size(160.w, 40.h),
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
        );
      },
    );
  }

  Widget _buildShimmerList() {
    return SizedBox(
      height: double.infinity,
      width: double.infinity,
      child: ListView.builder(
        itemCount: 10,
        itemBuilder: (context, index) {
          return Shimmer.fromColors(
            baseColor: Colors.grey[300]!,
            highlightColor: Colors.grey[100]!,
            child: Semantics(
              excludeSemantics: true,
              label: 'Loading content item. Please wait.',
              child: ListTile(
                contentPadding: EdgeInsets.zero,
                title: Container(
                  height: 200.h,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(5.0.sp),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

class SearchedContent extends StatelessWidget {
  final List<IslamicContent> searchContent;
  final Function(int) onSearchTap;
  final LanguageMode selectedLanguage;
  final bool canEdit;
  final Function(int, List<IslamicContent>) onEditTap;

  const SearchedContent({
    super.key,
    required this.searchContent,
    required this.onSearchTap,
    required this.selectedLanguage,
    required this.canEdit,
    required this.onEditTap,
  });

  @override
  Widget build(BuildContext context) {
    return searchContent.isEmpty
        ? const Center(child: Text('No content found'))
        : ListView.builder(
            itemBuilder: (context, index) => Column(
              children: [
                Card(
                  color: HexColor("#F5FAFD"),
                  child: Directionality(
                    textDirection: LanguageMode.arabic == selectedLanguage
                        ? TextDirection.rtl
                        : TextDirection.ltr,
                    child: ListTile(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.sp),
                      ),
                      onTap: () {
                        onSearchTap(index);
                      },
                      title: SizedBox(
                        width: double.maxFinite,
                        child: Row(
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            SizedBox(
                              width: MediaQuery.of(context).size.width * 0.6,
                              child: Text(
                                searchContent[index].title,
                                style: Theme.of(context).textTheme.titleMedium,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            const Spacer(),
                            canEdit
                                ? IconButton(
                                    onPressed: () {
                                      // Add edit functionality here
                                      print("index: ${index}");
                                      onEditTap(index, searchContent);
                                    },
                                    icon: const Icon(Icons.edit),
                                  )
                                : const SizedBox.shrink(),
                          ],
                        ),
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            height: 5.h,
                          ),
                          Text(
                            'By: ${searchContent[index].author}',
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                          SizedBox(height: 18.h),
                          Text(
                            'Description',
                            style: Theme.of(context).textTheme.labelMedium,
                          ),
                          SizedBox(height: 7.h),
                          Text(
                            searchContent[index].content,
                            style: Theme.of(context).textTheme.bodyMedium,
                            maxLines: 3,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 12.h,
                ),
              ],
            ),
            itemCount: searchContent.length,
          );
  }
}

class ExploreContent extends StatelessWidget {
  final List<IslamicContent> exploreContent;
  final Function(int) onSearchTap;
  final LanguageMode selectedLanguage;
  final bool canEdit;
  final Function(int, List<IslamicContent>) onEditTap;

  const ExploreContent({
    super.key,
    required this.exploreContent,
    required this.onSearchTap,
    required this.selectedLanguage,
    required this.canEdit,
    required this.onEditTap,
  });

  @override
  Widget build(BuildContext context) {
    return exploreContent.isEmpty
        ? const Center(child: Text('No content found'))
        : ListView.builder(
            itemBuilder: (context, index) => Column(
              children: [
                Card(
                  color: HexColor("#F5FAFD"),
                  child: Directionality(
                    textDirection: LanguageMode.arabic == selectedLanguage
                        ? TextDirection.rtl
                        : TextDirection.ltr,
                    child: ListTile(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.sp),
                      ),
                      onTap: () {
                        onSearchTap(index);
                      },
                      title: SizedBox(
                        width: double.maxFinite,
                        child: Row(
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            SizedBox(
                              width: MediaQuery.of(context).size.width * 0.6,
                              child: Text(
                                exploreContent[index].title,
                                style: Theme.of(context).textTheme.titleMedium,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            const Spacer(),
                            canEdit
                                ? IconButton(
                                    onPressed: () {
                                      // Add edit functionality here
                                      print("index: ${index}");
                                      onEditTap(index, exploreContent);
                                    },
                                    icon: const Icon(Icons.edit),
                                  )
                                : const SizedBox.shrink(),
                          ],
                        ),
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            height: 5.h,
                          ),
                          Text(
                            'By: ${exploreContent[index].author}',
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                          SizedBox(height: 18.h),
                          Text(
                            'Description',
                            style: Theme.of(context).textTheme.labelMedium,
                          ),
                          SizedBox(height: 7.h),
                          Text(
                            exploreContent[index].content,
                            style: Theme.of(context).textTheme.bodyMedium,
                            maxLines: 3,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 0.h,
                ),
              ],
            ),
            itemCount: exploreContent.length,
          );
  }
}
