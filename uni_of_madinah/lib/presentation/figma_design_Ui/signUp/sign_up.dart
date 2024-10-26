import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:stacked/stacked.dart';
import 'package:uni_of_madinah/presentation/figma_design_Ui/search/search.dart';
import 'package:uni_of_madinah/presentation/figma_design_Ui/signUp/sign_up_viewmodel.dart';
import 'package:uni_of_madinah/presentation/welcome%20screen/welcome.dart';
import 'package:uni_of_madinah/widgets/custom_button.dart';
import 'package:uni_of_madinah/widgets/custom_button_for_login.dart';
import 'package:uni_of_madinah/widgets/custom_material_textfield.dart';

class SignUpView extends StatefulWidget {
  const SignUpView({super.key});

  @override
  State<SignUpView> createState() => _SignUpViewState();
}

class _SignUpViewState extends State<SignUpView> {
  bool _acceptTerms = false;

  @override
  Widget build(BuildContext context) {
    final TextTheme textTheme = Theme.of(context).textTheme;
    return ViewModelBuilder.reactive(
      viewModelBuilder: () => SignUpViewModel(),
      builder: (context, viewModel, child) => Scaffold(
        backgroundColor: HexColor("#FFFFFF"),
        body: SingleChildScrollView(
          child: Center(
            child: Column(
              children: [
                SizedBox(height: 105.h),
                Semantics(
                  excludeSemantics: true,
                  label: 'Sign Up',
                  child: SizedBox(
                    width: 361.w,
                    child: Text('Sign Up',
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
                        excludeSemantics: true,
                        label:
                            'Full Name input field. Please double tap to enter Your full name',
                        child: CustomMaterialTextField(
                          labelText: "",
                          hintText: "Full Name",
                          controller: viewModel.nameController,
                          //    isPasswordField: true,
                        ),
                        //
                      ),
                      Semantics(
                        excludeSemantics: true,
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
                        excludeSemantics: true,
                        label:
                            'Password input field. Please double tap to enter your password',
                        child: CustomMaterialTextField(
                          labelText: "",
                          hintText: "Password",
                          controller: viewModel.passwordController,
                          isPasswordField: true,
                        ),
                      ),
                      SizedBox(height: 20.h),
                      Semantics(
                        excludeSemantics: true,
                        label: 'Please Accept Terms and Conditions',
                        child: Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: 28.sp, vertical: 0.0.sp),
                          child: Row(
                            children: [
                              Checkbox(
                                value: _acceptTerms,
                                onChanged: (value) {
                                  setState(() {
                                    _acceptTerms = value ?? false;
                                  });
                                },
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20),
                                ),
                              ),
                              Semantics(
                                excludeSemantics: true,
                                label:
                                    'By continuing you follow our rules and privacy',
                                child: Text(
                                  'By continuing you follow our rules and privacy',
                                  style: TextStyle(
                                    fontSize: 12.sp,
                                    color: HexColor("#9299A3"),
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                      ),

                      SizedBox(height: 32.h),
                      Semantics(
                        excludeSemantics: true,
                        label: 'Sign Up button, Please double click to Sign Up',
                        child: SizedBox(
                          width: 371.w,
                          child: CustomButton(
                            buttonText: 'Sign up',
                            onPressed: viewModel.signingUp
                                ? null
                                : () {
                                    viewModel.signUpWithEmailAndPassword();
                                  },
                            isLoading: viewModel.signingUp,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 32.h),
                SizedBox(
                  width: 340.w,
                  height: 22.h,
                  child: Row(children: <Widget>[
                    Expanded(
                        child: Divider(
                      thickness: 0.5.sp,
                      color: Colors.black54,
                    )),
                    Semantics(
                      excludeSemantics: true,
                      label: 'Or',
                      child: Text(
                        " Or ",
                        style:
                            textTheme.bodyMedium!.copyWith(color: Colors.black),
                      ),
                    ),
                    Expanded(
                        child: Divider(
                      thickness: 0.5.sp,
                      color: Colors.black54,
                    )),
                  ]),
                ),
                SizedBox(
                  height: 32.h,
                ),
                // Displaying Google Sign-Up for Android and Apple Sign-Up for iOS
                Platform.isAndroid
                    ? Semantics(
                        excludeSemantics: true,
                        label:
                            'If you want to sign up using Google, please Double tap to proceed',
                        child: CustomButtonForLogIn(
                          text: 'Continue with Google',
                          iconPath: 'assets/google_icon.png',
                          onPressed: viewModel.signupWithGoogle,
                        ),
                      )
                    : Platform.isIOS
                        ? Semantics(
                            excludeSemantics: true,
                            label:
                                'If you want to sign up using Apple, please Double tap to proceed',
                            child: CustomButtonForLogIn(
                              text: 'Signup with Apple',
                              iconPath: 'assets/apple_icon.png',
                              onPressed: viewModel.signUpWithApple,
                            ))
                        : Container(),

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
