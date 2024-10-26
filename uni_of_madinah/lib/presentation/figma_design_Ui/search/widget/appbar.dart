import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:uni_of_madinah/presentation/figma_design_Ui/profile/profile.dart';

class CustomAppBar extends StatelessWidget {
  final String userName;

  const CustomAppBar({
    Key? key,
    required this.userName,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.sp),
      height: kToolbarHeight,
      color: const Color(0xFF05677E),
      child: Row(
        children: [
          Padding(
            padding: EdgeInsets.fromLTRB(0, 0, 0, 50.sp),
            child: Semantics(
              excludeSemantics: true,
              label: 'Menu button',
              child: IconButton(
                icon: const Icon(Icons.menu, color: Colors.white),
                onPressed: () {
                  print('Menu button pressed');
                  Scaffold.of(context).openDrawer();
                }, // Updated onPressed callback
              ),
            ),
          ),
          Expanded(
            child: Center(
              child: Padding(
                padding: EdgeInsets.fromLTRB(0, 0, 0, 50.sp),
                child: Text(
                  'Islam Q',
                  style: TextStyle(
                      fontSize: 20.sp,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      fontFamily: 'Zilla Slab'),
                ),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(0, 0, 0, 50.sp),
            child: Semantics(
              excludeSemantics: true,
              button: false,
              label:
                  'User name ${userName}. Please double tap to navigate to profile screen.',
              child: TextButton(
                child: Text(
                  userName,
                  style: TextStyle(
                    fontSize: 16.sp,
                    color: Colors.white,
                  ),
                ),
                onPressed: () {
                  Get.to(ProfileScreen());
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
