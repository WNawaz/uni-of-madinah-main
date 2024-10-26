import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hexcolor/hexcolor.dart';

class CustomButtonForLogIn extends StatelessWidget {
  final String text;
  final String iconPath;
  final VoidCallback onPressed;

  const CustomButtonForLogIn({
    super.key,
    required this.text,
    required this.iconPath,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: 'Continue with Google To Proceed Please double tap the button',
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 24.sp),
        child: SizedBox(
          height: 40.h,
          width: 355.w,
          child: ElevatedButton(
            onPressed: onPressed,
            style: ElevatedButton.styleFrom(
              // padding: EdgeInsets.symmetric(
              //   horizontal: 12.sp,
              //   vertical: 12,
              // ),
              elevation: 0,
              backgroundColor: Colors.transparent,
              shape: RoundedRectangleBorder(
                side: BorderSide(width: 1.w, color: HexColor("#70787C")),
                borderRadius: BorderRadius.circular(100),
              ),
            ),
            child: Row(
              //mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Container(
                //   width: 24.w,
                //   height: 24.h,
                //   clipBehavior: Clip.antiAlias,
                //   decoration: const BoxDecoration(),
                //   child:
                Image.asset(
                  iconPath,
                  height: 18.h,
                  width: 18.w,
                  // color: Colors.transparent,
                ),
                // ),
                SizedBox(width: 12.w),
                Text(text,
                    style: Theme.of(context).textTheme.labelLarge!.copyWith(
                        color: HexColor("#40484C"),
                        fontFamily: 'Roboto',
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w500)),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
