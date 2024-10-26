// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:uni_of_madinah/presentation/forgot_password/forgot_password_vm.dart';
import 'package:uni_of_madinah/presentation/figma_design_Ui/signIn/sign_in.dart';
import 'package:uni_of_madinah/widgets/custom_button.dart';
import 'package:uni_of_madinah/widgets/custom_material_textfield.dart';

class ForgotPasswordView extends StatefulWidget {
  const ForgotPasswordView({Key? key}) : super(key: key);

  @override
  State<ForgotPasswordView> createState() => _ForgotPasswordState();
}

final TextEditingController _emailController = TextEditingController();

class _ForgotPasswordState extends State<ForgotPasswordView> {
  final forgotPasswordViewModel = ForgotPasswordViewModel();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            leading: Padding(
              padding: EdgeInsets.only(left: 8.0.sp),
              child: Semantics(
                excludeSemantics: true,
                label:
                    'back button, Please double tap to return to the previous screen',
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
                      label: 'Forgot Password Screen',
                      child: Text(
                        'Forgot password',
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
                            'Please enter your email address in the email field to request a password reset. We will send you a link to reset your password.',
                        child: Text(
                          'Please enter your email address to request a password reset. We will send you a link to reset your passwrod.',
                          style:
                              Theme.of(context).textTheme.bodyMedium!.copyWith(
                                    color: HexColor("#2C3134"),
                                  ),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 24.h),
                Semantics(
                  excludeSemantics: true,
                  label:
                      'Email Input Field, Please double click to enter your email.',
                  child: CustomMaterialTextField(
                      labelText: "",
                      hintText: "Please enter your email",
                      controller: _emailController),
                ),
                SizedBox(height: 24.h),
                Semantics(
                  excludeSemantics: true,
                  label: 'Next Button. Please double click To Proceed.',
                  child: CustomButton(
                    buttonText: "Next",
                    onPressed: () async {
                      await forgotPasswordViewModel
                          .sendPasswordResetEmail(_emailController.text);
                      // Show a SnackBar
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        content: Semantics(
                          excludeSemantics: true,
                          label: 'Password reset email has been sent',
                          child: Text('Password reset email has been sent'),
                        ),
                        duration: Duration(seconds: 2),
                      ));
                    },
                  ),
                ),
                SizedBox(height: 12.h),
                Padding(
                  padding: EdgeInsets.only(left: 18.0.sp),
                  child: Row(
                    children: [
                      Semantics(
                        excludeSemantics: true,
                        label:
                            'If you remembered your account. please double click on log in to your account.',
                        child: Text.rich(
                          TextSpan(
                            children: [
                              TextSpan(
                                text: "Remembered account? ",
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyMedium!
                                    .copyWith(
                                      color: HexColor("#40484C"),
                                    ),
                              ),
                              WidgetSpan(
                                child: GestureDetector(
                                  onTap: () {
                                    // Navigate to SignUp Screen
                                    Get.off(const SignInView());
                                  },
                                  child: Text(
                                    'Login to your account',
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyMedium!
                                        .copyWith(
                                          color: HexColor("#40484C"),
                                          fontWeight: FontWeight.bold,
                                          decoration: TextDecoration.underline,
                                        ),
                                  ),
                                ),
                              )
                            ],
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          )),
    );
  }
}
