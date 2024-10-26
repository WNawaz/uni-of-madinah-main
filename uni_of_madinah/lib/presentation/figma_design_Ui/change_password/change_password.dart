// import 'package:flutter/material.dart';
// import 'package:hexcolor/hexcolor.dart';
// import 'package:stacked/stacked.dart';
// import 'package:uni_of_madinah/presentation/figma_design_Ui/change_password/widget/change_password_textformfield.dart';
// import 'package:uni_of_madinah/widgets/custom_button.dart';

// import 'change_password_vm.dart'; // Import your ViewModel file

// class ChangePasswordView extends StatelessWidget {
//   const ChangePasswordView({Key? key});

//   @override
//   Widget build(BuildContext context) {
//     return ViewModelBuilder<ChangePasswordViewModel>.reactive(
//       viewModelBuilder: () => ChangePasswordViewModel(),
//       onDispose: (viewModel) => viewModel.dispose(),
//       builder: (context, viewModel, child) => Scaffold(
//         appBar: AppBar(
//           title: Text('Change Password'),
//         ),
//         body: Padding(
//           padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 24),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               PasswordTextField(
//                 controller: viewModel.previousPasswordController,
//                 hintText: 'Enter your current password',
//                 labelText: 'Current Password',
//               ),
//               SizedBox(height: 20),
//               PasswordTextField(
//                 controller: viewModel.newPasswordController,
//                 hintText: 'Enter your new password',
//                 labelText: 'New Password',
//               ),
//               SizedBox(height: 20),
//               PasswordTextField(
//                 controller: viewModel.confirmNewPasswordController,
//                 hintText: 'Confirm your new password',
//                 labelText: 'Confirm New Password',
//               ),
//               SizedBox(height: 20),
//               CustomButton(buttonText: 'Subscribe', onPressed: () {}),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
// ignore_for_file: use_build_context_synchronously

import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:uni_of_madinah/presentation/figma_design_Ui/change_password/change_password_vm.dart';
import 'package:uni_of_madinah/widgets/custom_button.dart';
import 'package:uni_of_madinah/widgets/custom_material_textfield.dart';

class ChangePasswordView extends StatefulWidget {
  const ChangePasswordView({Key? key}) : super(key: key);

  @override
  State<ChangePasswordView> createState() => _ForgotPasswordState();
}

final TextEditingController _emailController = TextEditingController();

class _ForgotPasswordState extends State<ChangePasswordView> {
  final changePasswordViewModel = ChangePasswordViewModel();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          leading: Padding(
            padding: EdgeInsets.only(left: 8.0.sp),
            child: Semantics(
              excludeSemantics: true,
              label:
                  'Back Button. Please double tap to return to previous screen',
              child: IconButton(
                icon: Icon(
                  Icons.arrow_back,
                  color: HexColor("#05677E"),
                ),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
            ),
          ),
        ),
        body: Padding(
          padding: EdgeInsets.symmetric(horizontal: 22.0.sp),
          child: Column(
            children: [
              SizedBox(height: 24.h),
              Row(
                children: [
                  Semantics(
                    excludeSemantics: true,
                    label: 'Change password Screen',
                    child: Text(
                      'Change password',
                      style: Theme.of(context).textTheme.titleLarge!.copyWith(
                          color: HexColor("#2C3134"),
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 12.h),
              Row(
                children: [
                  Expanded(
                    child: Semantics(
                      excludeSemantics: true,
                      label:
                          'Please enter your email address to request password change. We will send you a link to change your passwrod.',
                      child: Text(
                        'Please enter your email address to request password change. We will send you a link to change your passwrod.',
                        style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                              color: HexColor("#2C3134"),
                            ),
                        softWrap: true,
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 24.h),
              Semantics(
                excludeSemantics: true,
                label:
                    'Email input field. Please double tap to enter your eamil.',
                child: CustomMaterialTextField(
                    labelText: "",
                    hintText: "Please enter your email",
                    controller: _emailController),
              ),
              SizedBox(height: 24.h),
              Semantics(
                excludeSemantics: true,
                label: 'Next button. Please double tap to proceed',
                child: CustomButton(
                  buttonText: "Next",
                  onPressed: () async {
                    await changePasswordViewModel
                        .sendPasswordResetEmail(_emailController.text);

                    final snackBar = SnackBar(
                      content: Text('Password change email has been sent'),
                      duration: Duration(seconds: 2),
                    );

                    ScaffoldMessenger.of(context).showSnackBar(snackBar);

                    // Announce the SnackBar text for accessibility
                    SemanticsService.announce(
                        'Password change email has been sent',
                        TextDirection.ltr);
                  },
                ),
              ),
            ],
          ),
        ));
  }
}
