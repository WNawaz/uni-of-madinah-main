import 'package:flutter/material.dart';

import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:stacked/stacked.dart';
import 'package:uni_of_madinah/presentation/email_verification/email_verification_view_model.dart';
import 'package:uni_of_madinah/widgets/custom_button.dart';

class EmailVerification extends StatefulWidget {
  const EmailVerification({Key? key}) : super(key: key);

  @override
  State<EmailVerification> createState() => _EmailVerificationState();
}

class _EmailVerificationState extends State<EmailVerification> {
  // final TextEditingController _codeController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder.reactive(
      viewModelBuilder: () => EmailVerficationViewModel(),
      builder: (context, viewModel, child) => Scaffold(
          body: SingleChildScrollView(
        child: Center(
            child: Column(children: [
          Container(
            width: 393.w,
            padding: EdgeInsets.symmetric(horizontal: 16.sp, vertical: 32.sp),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: 40.h,
                ),
                SizedBox(
                  width: double.infinity,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        width: double.infinity,
                        child: Text(
                          'Please Verify Your Email',
                          style: Theme.of(context)
                              .textTheme
                              .headlineMedium!
                              .copyWith(color: Colors.black),
                        ),
                      ),
                      SizedBox(height: 16.h),
                      SizedBox(
                        width: double.infinity,
                        child: Text.rich(
                          TextSpan(
                            children: [
                              TextSpan(
                                  text:
                                      'For your account security we have just sent an email to ',
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyLarge!
                                      .copyWith(color: Colors.black)),
                              TextSpan(
                                  text:
                                      '“${viewModel.userService.user!.email}”',
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyLarge!
                                      .copyWith(color: Colors.black)),
                              TextSpan(
                                  text:
                                      ' with a verification link. Please follow the email instructions and press \'Next\' after verifying.\n\n',
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyLarge!
                                      .copyWith(color: Colors.black)),
                              TextSpan(
                                text:
                                    'Note: If you do not see the email in your inbox, then see your spam folder.',
                                style: Theme.of(context)
                                    .textTheme
                                    .titleMedium!
                                    .copyWith(color: Colors.grey),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    TextButton(
                        onPressed: viewModel.sendVerificationEmail,
                        child: Text("Resend verfication email")),
                  ],
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      width: double.maxFinite,
                      child: CustomButton(
                          buttonText: "Next",
                          isLoading: viewModel.isVerifyingEmail,
                          onPressed: viewModel.isVerifyingEmail
                              ? null
                              : viewModel.hanldeNextTap),
                    ),
                  ],
                )
              ],
            ),
          )
        ])),
      )),
    );
  }
}
