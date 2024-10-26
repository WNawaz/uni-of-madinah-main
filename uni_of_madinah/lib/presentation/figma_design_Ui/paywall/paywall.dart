import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:uni_of_madinah/presentation/figma_design_Ui/subscription/subscription_view.dart';

class MyBottomSheet extends StatelessWidget {
  const MyBottomSheet({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      child: GestureDetector(
        onTap: () {
          Navigator.pop(context);
        },
        child: Material(
          child: Container(
            color: Colors.white,
            height: 0.85 * MediaQuery.of(context).size.height,
            child: Padding(
              padding: EdgeInsets.fromLTRB(36.0.sp, 48.sp, 36.sp, 32.sp),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Semantics(
                      excludeSemantics: true,
                      label:
                          'Upgrade to Premium. Please Click on the button to see our plans.',
                      child: Text(
                        'Upgrade to Premium',
                        style: Theme.of(context).textTheme.titleLarge!.copyWith(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                    ),
                    SizedBox(height: 16.h),
                    buildListTile(
                      context,
                      Icons.check_outlined,
                      'Free access',
                      'Unlock ads-free access to our app',
                    ),
                    buildListTile(
                      context,
                      Icons.notifications_outlined,
                      'Get reminders',
                      'Get reminders when your trial is ending.',
                    ),
                    buildListTile(
                      context,
                      Icons.close_outlined,
                      'Cancel anytime',
                      'Cancel your subscription anytime.',
                    ),
                    buildListTile(
                      context,
                      Icons.autorenew_outlined,
                      'Automatic Subscription renewal',
                      'Payment will be charged to Play store Account automatically.',
                    ),
                    SizedBox(height: 16.h),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: HexColor("#05677E"),
                      ),
                      onPressed: () {
                        Get.off(const SubscriptionView());
                      },
                      child: Text(
                        'See Our Plans',
                        style: Theme.of(context)
                            .textTheme
                            .labelLarge!
                            .copyWith(color: Colors.white),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  ListTile buildListTile(
      BuildContext context, IconData icon, String title, String subtitle) {
    return ListTile(
      leading: Container(
        width: 32.sp,
        height: 32.sp,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(48.sp),
          color: HexColor("#CFE6F0"),
        ),
        child: Center(
          child: Icon(
            icon,
            size: 20.sp,
            color: HexColor("#05677E"),
          ),
        ),
      ),
      title: Text(
        title,
        style: Theme.of(context).textTheme.titleMedium!.copyWith(
              color: HexColor("#4C626A"),
            ),
      ),
      subtitle: Text(
        subtitle,
        style: Theme.of(context).textTheme.bodyLarge!.copyWith(
              color: HexColor("#4C626A"),
            ),
      ),
    );
  }
}
