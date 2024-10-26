import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hexcolor/hexcolor.dart';

class CustomListTileWidget extends StatelessWidget {
  final IconData leadingIcon;
  final String title;
  final Color leadingIconColor;
  final Color textColor;

  const CustomListTileWidget({
    Key? key,
    required this.leadingIcon,
    required this.title,
    required this.leadingIconColor,
    required this.textColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      dense: true,
      contentPadding: EdgeInsets.symmetric(horizontal: 4.0.sp, vertical: 0.0),
      visualDensity: VisualDensity(horizontal: 0, vertical: -4.sp),
      leading: Container(
        width: 27.sp,
        height: 27.sp,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(48.sp),
          color: HexColor("#CFE6F0"),
        ),
        child: Center(
          child: Icon(
            leadingIcon,
            size: 16.sp,
            color: HexColor("#05677E"),
          ),
        ),
      ),
      title: Text(
        title,
        style:
            Theme.of(context).textTheme.titleSmall!.copyWith(color: textColor),
      ),
    );
  }
}
