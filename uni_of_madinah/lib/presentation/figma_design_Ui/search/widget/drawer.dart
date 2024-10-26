import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:stacked/stacked.dart';
import 'package:uni_of_madinah/presentation/figma_design_Ui/search/widget/drawer_vm.dart';

class MyDrawer extends StatelessWidget {
  const MyDrawer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder.reactive(
      viewModelBuilder: () => DrawerVM(),
      onViewModelReady: (viewModel) => viewModel.init(),
      builder: (context, viewModel, child) => Drawer(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 8.0.sp),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Container(
                padding: EdgeInsets.fromLTRB(16.sp, 78.sp, 12.sp, 8.sp),
                child: Text(
                  'Menu',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 22.sp,
                    fontWeight: FontWeight.w600,
                    fontFamily: 'Roboto',
                  ),
                ),
              ),
              SizedBox(height: 6.h),
              !viewModel.isAdmin
                  ? const SizedBox.shrink()
                  : buildListTile(
                      Icons.add,
                      'Add Volunteer',
                      0,
                      () {
                        viewModel.handleSelectTap(0);
                      },
                      viewModel.selectedIndex,
                    ),
              buildListTile(
                Icons.library_books_outlined,
                'Terms of Use',
                1,
                () {
                  viewModel.handleSelectTap(1);
                },
                viewModel.selectedIndex,
              ),
              buildListTile(
                Icons.verified_user_outlined,
                'Privacy Policy',
                2,
                () {
                  viewModel.handleSelectTap(2);
                },
                viewModel.selectedIndex,
              ),
              buildListTile(
                Icons.bookmark_outline,
                'Acknowledgements',
                3,
                () {
                  viewModel.handleSelectTap(3);
                },
                viewModel.selectedIndex,
              ),
              buildListTile(
                Icons.workspace_premium_outlined,
                'Subscription',
                4,
                () {
                  viewModel.handleSelectTap(4);
                },
                viewModel.selectedIndex,
              ),
              // buildListTile(
              //   Icons.workspace_premium_outlined,
              //   'Upgrade',
              //   4,
              //   () {
              //     viewModel.handleSelectTap(4);
              //   },
              //   viewModel.selectedIndex,
              // ),
              buildListTile(
                Icons.person_2_outlined,
                'Profile',
                5,
                () {
                  viewModel.handleSelectTap(5);
                },
                viewModel.selectedIndex,
              ),

              Expanded(child: Container()),
              buildLogoutButton(viewModel, context),
            ],
          ),
        ),
      ),
    );
  }

  ListTile buildListTile(IconData icon, String title, int index,
      VoidCallback onTap, int selectedIndex) {
    return ListTile(
      leading: SizedBox(
        width: 24.w,
        height: 24.h,
        child: Icon(
          icon,
          size: 24.sp,
          color: HexColor("#071E26"),
        ),
      ),
      title: Text(
        title,
        style: TextStyle(
          color: HexColor("#071E26"),
          fontWeight:
              selectedIndex == index ? FontWeight.w600 : FontWeight.normal,
        ),
      ),
      selected: selectedIndex == index,
      selectedTileColor: HexColor("#CFE6F0"),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(100),
      ),
      contentPadding: EdgeInsets.symmetric(horizontal: 12.sp, vertical: 0.sp),
      onTap: () {
        onTap(); // Execute the provided onTap function
      },
    );
  }

  Widget buildLogoutButton(DrawerVM viewModel, BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(16.sp, 0, 16.sp, 32.sp),
      child: SizedBox(
        height: 40.h,
        width: 297.w,
        child: ElevatedButton(
          onPressed: () {
            showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  title: Text('Logout'),
                  content: Text('Are you sure you want to logout?'),
                  actions: [
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: Text('Cancel'),
                    ),
                    TextButton(
                      onPressed: () {
                        viewModel.handleLogoutTap();
                        Navigator.of(context).pop();
                      },
                      child: Text('Logout'),
                    ),
                  ],
                );
              },
            );
          },
          style: ElevatedButton.styleFrom(
            foregroundColor: HexColor("#05677E"),
            textStyle: TextStyle(fontSize: 14.sp),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(100.sp),
              side: BorderSide(
                color: HexColor("#70787C"),
              ),
            ),
          ),
          child: viewModel.isLoggingOut
              ? const CircularProgressIndicator.adaptive(
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.black),
                )
              : Text(
                  'Logout',
                  style: TextStyle(
                    fontWeight: FontWeight.w500,
                    fontFamily: "Roboto",
                    fontSize: 14.sp,
                  ),
                ),
        ),
      ),
    );
  }
}
