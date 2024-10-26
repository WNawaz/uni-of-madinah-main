import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hexcolor/hexcolor.dart';

class StackedCard extends StatelessWidget {
  final String title;
  final String name;
  final String descriptionHeading;
  final String descriptionText;

  const StackedCard({
    Key? key,
    required this.title,
    required this.name,
    required this.descriptionHeading,
    required this.descriptionText,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 360.w,
      height: 220.h,
      decoration: BoxDecoration(
        color: HexColor("#F5FAFD"),
        borderRadius: BorderRadius.circular(12.sp),
        border:
            Border.all(color: Colors.grey.shade500), // Light black border color

        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.3),
            spreadRadius: 0.5.sp,
            blurRadius: 2.sp,
            offset: Offset(0, 3), // changes position of shadow
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.all(16.sp),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 20.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.edit),
                  onPressed: () {
                    // Add edit functionality here
                  },
                ),
              ],
            ),
          ),
          SizedBox(height: 0),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.h),
            child: Text(
              'BY: $name',
              style: TextStyle(
                fontSize: 16.sp,
              ),
            ),
          ),
          SizedBox(height: 8.h),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.sp),
            child: Text(
              descriptionHeading,
              style: TextStyle(
                fontSize: 18.sp,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          SizedBox(height: 8.h),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.sp),
            child: SizedBox(
              height: 48.h,
              child: SingleChildScrollView(
                child: Text(
                  descriptionText,
                  style: TextStyle(
                    fontSize: 16.sp,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ),
          ),
          SizedBox(height: 12.h), // Padding below the text
        ],
      ),
    );
  }
}
