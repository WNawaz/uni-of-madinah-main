import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:stacked/stacked.dart';
import 'package:uni_of_madinah/presentation/figma_design_Ui/change_password/change_password.dart';
import 'package:uni_of_madinah/presentation/figma_design_Ui/profile/profile_vm.dart';
import 'package:uni_of_madinah/presentation/figma_design_Ui/profile/widget/textfield.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<ProfileVm>.reactive(
      viewModelBuilder: () => ProfileVm(),
      onModelReady: (viewModel) => viewModel.init(),
      builder: (context, viewModel, child) => Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          title: Padding(
            padding: EdgeInsets.only(left: 8.0.sp),
            child: Semantics(
              excludeSemantics: true,
              label: "Profile screen",
              child: Semantics(
                excludeSemantics: true,
                label: 'Profile Screen',
                child: Text(
                  "Profile",
                  style: Theme.of(context).textTheme.titleLarge!.copyWith(
                        color: Colors.black,
                      ),
                ),
              ),
            ),
          ),
          leading: Padding(
            padding: EdgeInsets.only(left: 16.0.sp),
            child: Semantics(
              excludeSemantics: true,
              label:
                  "Back button, please double tap to return to previous screen.",
              child: IconButton(
                icon: const Icon(
                  Icons.arrow_back,
                  color: Colors.black,
                ),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
            ),
          ),
        ),
        body: Padding(
          padding: EdgeInsets.symmetric(vertical: 16.0.sp, horizontal: 32.sp),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Semantics(
                excludeSemantics: true,
                label: "Username field. Current Name is: ${viewModel.userName}",
                child: ProfileDetailTextField(
                  labelText: 'Username',
                  initialValue: viewModel.userName,
                ),
              ),
              SizedBox(height: 16.0.h),
              Semantics(
                excludeSemantics: true,
                label: "Email field. Current email is: ${viewModel.email}",
                child: ProfileDetailTextField(
                  labelText: 'Email',
                  initialValue: viewModel.email,
                ),
              ),
              SizedBox(height: 20.h),
              GestureDetector(
                onTap: () {
                  Get.to(const ChangePasswordView());
                },
                child: Align(
                  alignment: Alignment.bottomRight,
                  child: Semantics(
                    excludeSemantics: true,
                    label:
                        "Change Password button. please double tap to change your password.",
                    child: Text(
                      'Change Password',
                      style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                            color: HexColor("#05677E"),
                          ),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 40.h),
              buildDeleteAccountButton(viewModel, context)
            ],
          ),
        ),
      ),
    );
  }
}

Widget buildDeleteAccountButton(ProfileVm viewModel, BuildContext context) {
  return Padding(
    padding: EdgeInsets.fromLTRB(16.sp, 0, 16.sp, 32.sp),
    child: SizedBox(
      height: 40.h,
      width: 380.w,
      child: ElevatedButton(
        onPressed: () {
          viewModel.handleDeleteAccountTap(context);
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.red,
          foregroundColor: Colors.white,
          textStyle: TextStyle(fontSize: 14.sp),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(100.sp),
          ),
        ),
        child: viewModel.isDeletingAccount
            ? const CircularProgressIndicator.adaptive(
                valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
              )
            : Text(
                'Delete Account',
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
