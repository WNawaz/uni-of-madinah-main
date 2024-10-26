// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hexcolor/hexcolor.dart';

class CustomButton extends StatelessWidget {
  final String buttonText;
  final Function()? onPressed;
  final bool isLoading;
  final IconData? iconData;
  Color? color;

  CustomButton({
    Key? key,
    required this.buttonText,
    required this.onPressed,
    this.isLoading = false,
    this.iconData,
    this.color,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 0.0),
      child: SizedBox(
        width: 355.w,
        height: 40.h,
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: HexColor("#05677E"),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(100.sp),
              side: const BorderSide(
                  width: 1.0,
                  color: Colors.transparent), // Add this line for the border
            ),
            // padding: EdgeInsets.symmetric(horizontal: 24.sp, vertical: 12.sp),
            elevation: 10.sp,
            shadowColor: Colors.transparent,
          ),
          onPressed: onPressed,
          child: isLoading
              ? const CircularProgressIndicator.adaptive()
              : Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      buttonText,
                      style: Theme.of(context).textTheme.labelLarge!.copyWith(
                          color: Colors.white,
                          fontFamily: 'Roboto',
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w500),
                    ),
                    SizedBox(width: 12.w),
                    if (iconData != null)
                      SizedBox(
                        width: 20.w,
                        height: 20.h,
                        child: Icon(
                          iconData,
                          size: 20.w,
                          color: Colors.white,
                        ),
                      ),
                    const SizedBox(width: 5),
                  ],
                ),
        ),
      ),
    );
  }
}
