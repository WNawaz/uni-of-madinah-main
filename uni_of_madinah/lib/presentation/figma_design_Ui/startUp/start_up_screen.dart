import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:stacked/stacked.dart';
import 'package:uni_of_madinah/presentation/figma_design_Ui/startUp/start_up_screen_vm.dart';

class StartupScreen extends StatelessWidget {
  const StartupScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder.reactive(
      viewModelBuilder: () => StartUpViewModel(),
      onViewModelReady: (model) => model.init(),
      builder: (context, viewModel, child) => Scaffold(
        backgroundColor: HexColor('#05677E'),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Column(
                      children: [
                        Semantics(
                          excludeSemantics:
                              true, // Excludes the default semantics

                          label: 'Welcome to islam Q',
                          child: Image.asset('assets/startup_screen/Group.png',
                              height: 155.h, width: 215.w),
                        ),
                        Text(
                          'ISLAM Q',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 35.sp,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            viewModel.isBusy
                ? SizedBox(
                    width: 24.h,
                    height: 24.h,
                    child: const CircularProgressIndicator.adaptive(
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                    ),
                  )
                : SizedBox(
                    height: 40.h,
                    width: 250.w,
                    child: Semantics(
                      excludeSemantics: true, // Excludes the default semantics
                      label: 'Get Started Button',
                      hint: 'To proceed, please double click the button',
                      child: ElevatedButton(
                        onPressed: () {
                          viewModel.handleGetStartedTap();
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          foregroundColor: HexColor("#05677E"),
                          textStyle: TextStyle(fontSize: 14.sp),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(100.sp),
                          ),
                        ),
                        child: Text(
                          'Get Started',
                          style: TextStyle(
                              fontWeight: FontWeight.w500,
                              fontFamily: "Roboto",
                              fontSize: 14.sp),
                        ),
                      ),
                    ),
                  ),
            SizedBox(height: 130.h),
            Align(
              alignment: Alignment.bottomCenter,
              child: Image.asset(
                'assets/startup_screen/Vector.png',
              ),
            ),
          ],
        ),
      ),
    );
  }
}
