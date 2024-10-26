// ignore_for_file: avoid_print, use_build_context_synchronously
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:stacked/stacked.dart';
import 'package:uni_of_madinah/presentation/figma_design_Ui/search/search.dart';
import 'package:uni_of_madinah/presentation/forgot_password/forgot_password.dart';
import 'package:uni_of_madinah/presentation/figma_design_Ui/signIn/sign_in_vm.dart';
import 'package:uni_of_madinah/presentation/figma_design_Ui/signUp/sign_up.dart';
import 'package:uni_of_madinah/widgets/custom_button.dart';
import 'package:uni_of_madinah/widgets/custom_button_for_login.dart';
import 'package:uni_of_madinah/widgets/custom_material_textfield.dart';

import '../../welcome screen/welcome.dart';

class SignInView extends StatefulWidget {
  const SignInView({super.key});

  @override
  State<SignInView> createState() => _SignInViewState();
}

class _SignInViewState extends State<SignInView> {
  @override
  Widget build(BuildContext context) {
    final TextTheme textTheme = Theme.of(context).textTheme;
    return ViewModelBuilder.reactive(
      viewModelBuilder: () => SignInViewModel(),
      builder: (context, viewModel, child) => Scaffold(
        backgroundColor: HexColor("#FFFFFF"),
        body: SingleChildScrollView(
          child: Center(
            child: Column(
              children: [
                SizedBox(height: 105.h),
                SizedBox(
                  width: 361.w,
                  child: Semantics(
                    excludeSemantics: true, // Excludes the default semantics

                    label: 'Sign In',
                    child: Text('Sign in',
                        textAlign: TextAlign.center,
                        style: textTheme.displaySmall!.copyWith(
                            fontWeight: FontWeight.w600,
                            color: Colors.black,
                            fontFamily: 'Roboto',
                            fontSize: 24.sp)),
                  ),
                ),
                SizedBox(height: 32.h),
                Form(
                    key: viewModel.formKey,
                    child: Column(
                      children: [
                        Semantics(
                          excludeSemantics:
                              true, // Excludes the default semantics

                          label:
                              'Email input field. Please double tap to enter your email ',
                          child: CustomMaterialTextField(
                            labelText: "",
                            hintText: "Email",
                            controller: viewModel.emailController,
                          ),
                        ),
                        // SizedBox(height: 24.h),
                        Semantics(
                          excludeSemantics:
                              true, // Excludes the default semantics

                          label:
                              'Password input field. Please double tap to enter your password ',
                          child: CustomMaterialTextField(
                            labelText: "",
                            hintText: "Password",
                            controller: viewModel.passwordController,
                            isPasswordField: true,
                          ),
                        ),
                        // SizedBox(height: 24.h),
                        Padding(
                          padding: EdgeInsets.fromLTRB(16.sp, 0, 24.sp, 0),
                          child: Align(
                            alignment: Alignment.centerRight,
                            child: Semantics(
                              excludeSemantics: true,
                              label:
                                  'Forgot Password button. Please double tap to change your password',
                              child: TextButton(
                                style: ButtonStyle(
                                  elevation: MaterialStateProperty.all(0),
                                ),
                                onPressed: () {
                                  Get.to(ForgotPasswordView());
                                },
                                child: Text(
                                  'Forgot Password?',
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodySmall!
                                      .copyWith(
                                          color: HexColor("#404B52"),
                                          fontFamily: 'Roboto',
                                          fontWeight: FontWeight.w400,
                                          fontSize: 12.sp),
                                ),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: 24.h),
                        SizedBox(
                          width: 371.w,
                          // height: 51.h,
                          child: Semantics(
                            excludeSemantics:
                                true, // Excludes the default semantics

                            label:
                                'Sign In button. please double click to Sign in',
                            child: CustomButton(
                              buttonText: 'Sign in',
                              onPressed: viewModel.isSigningIn
                                  ? null
                                  : () => viewModel.signIn(),
                              isLoading: viewModel.isSigningIn,
                            ),
                          ),
                        ),
                      ],
                    )),
                SizedBox(height: 32.h),
                SizedBox(
                  width: 340.w,
                  height: 22.h,
                  child: Row(children: <Widget>[
                    Expanded(
                        child: Divider(
                      thickness: 0.5.sp,
                      color: Colors.black45,
                    )),
                    Semantics(
                      excludeSemantics: true,
                      label: 'Or',
                      child: Text(
                        " Or ",
                        style: textTheme.bodySmall!
                            .copyWith(color: Colors.black87),
                      ),
                    ),
                    Expanded(
                        child: Divider(
                      thickness: 0.5.sp,
                      color: Colors.black45,
                    )),
                  ]),
                ),
                SizedBox(
                  height: 24.h,
                ),

                // Displaying Google Sign-In for Android and Apple Sign-In for iOS
                Platform.isAndroid
                    ? Semantics(
                        excludeSemantics: true,
                        label:
                            'If you want to sign in using Google, please double tap to proceed',
                        child: CustomButtonForLogIn(
                          text: 'Continue with Google',
                          iconPath: 'assets/google_icon.png',
                          onPressed: viewModel.signInWithGoogle,
                        ),
                      )
                    : Platform.isIOS
                        ? Semantics(
                            excludeSemantics: true,
                            label:
                                'If you want to sign in using Apple, please double tap to proceed',
                            child: CustomButtonForLogIn(
                              text: 'Login with Apple',
                              iconPath: 'assets/apple_icon.png',
                              onPressed: viewModel.signInWithApple,
                            ),
                          )
                        : Container(),

                SizedBox(height: 32.h),
                Semantics(
                  excludeSemantics: true, // Excludes the default semantics

                  label:
                      "If you Don't have an account. Please click sign up Button to Sign Up first. Double Click on Sign up button to proceed.",
                  button: false,
                  child: GestureDetector(
                    onTap: () {
                      // Navigate to SignUp Screen
                      Get.to(const SignUpView());
                    },
                    child: Text.rich(
                      TextSpan(
                        children: [
                          TextSpan(
                            text: "Don't have an account? ",
                            style: textTheme.labelLarge!.copyWith(
                                color: HexColor("#2C3134"),
                                fontSize: 14.sp,
                                fontFamily: 'Roboto',
                                fontWeight: FontWeight.w400),
                          ),
                          TextSpan(
                            text: 'Sign up',
                            style: Theme.of(context)
                                .textTheme
                                .labelLarge!
                                .copyWith(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                  decoration: TextDecoration.underline,
                                ),
                          ),
                        ],
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
                SizedBox(height: 24.h),

                // Skip Button
                TextButton(
                  onPressed: () {
                    Get.offAll(const SearchScreen());
                  },
                  child: Text(
                    'Skip for now',
                    style: textTheme.bodyLarge!.copyWith(
                      color: HexColor("#404B52"),
                    ),
                  ),
                ),

                // Volunteer Message
                Padding(
                  padding: EdgeInsets.all(16.h),
                  child: Text(
                    'To edit content as a volunteer, you must log in with your registered volunteer account.',
                    textAlign: TextAlign.center,
                    style: textTheme.bodySmall!.copyWith(
                      color: Colors.black,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
