// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:hexcolor/hexcolor.dart';
// import 'package:uni_of_madinah/presentation/figma_design_Ui/subscription/widget/custom_listTile.dart';

// class CustomCardWidget extends StatelessWidget {
//   final String subscriptionType;
//   final String subscriptionAmount;
//   final String subscriptionInfo;
//   final String bilingType;
//   final String billingAmount;

//   final bool isSelected;
//   final VoidCallback onTap;

//   const CustomCardWidget({
//     Key? key,
//     required this.subscriptionType,
//     required this.subscriptionAmount,
//     required this.subscriptionInfo,
//     required this.bilingType,
//     required this.billingAmount,
//     required this.isSelected,
//     required this.onTap,
//   }) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return SizedBox(
//       height: 157.h,
//       width: 380.w,
//       child: Card(
//         elevation: 0,
//         color: isSelected ? HexColor("#F5FAFD") : HexColor("FFFFFF"),
//         shape: RoundedRectangleBorder(
//           borderRadius: BorderRadius.circular(16.sp),
//           side: const BorderSide(color: Color(0xFF05677E)),
//         ),
//         child: InkWell(
//             onTap: onTap,
//             child:
//                 Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
//               ListTile(
//                 title: Text(
//                   subscriptionType,
//                   style: Theme.of(context)
//                       .textTheme
//                       .titleMedium!
//                       .copyWith(color: HexColor("#2C3134")),
//                 ),
//                 subtitle: Text(subscriptionInfo,
//                     style: Theme.of(context).textTheme.bodyMedium!.copyWith(
//                           color: HexColor("#2C3134"),
//                         )),
//                 trailing: Text(subscriptionAmount,
//                     style: Theme.of(context).textTheme.headlineMedium!.copyWith(
//                         color: HexColor("#2C3134"),
//                         fontWeight: FontWeight.bold)),
//               ),
//               ListTile(
//                 title: Text(
//                   bilingType,
//                   style: Theme.of(context)
//                       .textTheme
//                       .bodySmall!
//                       .copyWith(color: HexColor("#05677E")),
//                 ),
//                 trailing: Text(billingAmount,
//                     style: Theme.of(context).textTheme.bodyMedium!.copyWith(
//                           color: HexColor("#05677E"),
//                         )),
//               )
//               // CustomListTileWidget(
//               //   leadingIcon: Icons.check,
//               //   title: '100% Ads Free',
//               //   leadingIconColor: HexColor("#05677E"),
//               //   textColor: HexColor("#2C3134"),
//               // ),
//               // CustomListTileWidget(
//               //   leadingIcon: Icons.check,
//               //   title: 'Cancel Anytime',
//               //   leadingIconColor: HexColor("#05677E"),
//               //   textColor: HexColor("#2C3134"),
//               // ),
//               // CustomListTileWidget(
//               //   leadingIcon: Icons.check,
//               //   title: 'Automatic Subscription Renewal',
//               //   leadingIconColor: HexColor("#05677E"),
//               //   textColor: HexColor("#2C3134"),
//               // ),
//               // CustomListTileWidget(
//               //   leadingIcon: Icons.check,
//               //   title: 'Get Reminders',
//               //   leadingIconColor: HexColor("#05677E"),
//               //   textColor: HexColor("#2C3134"),
//               // ),
//               // CustomListTileWidget(
//               //   leadingIcon: Icons.check,
//               //   title: 'Renewal Confirmations',
//               //   leadingIconColor: HexColor("#05677E"),
//               //   textColor: HexColor("#2C3134"),
//               // ),
//             ])),
//       ),
//     );
//   }
// }
// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:hexcolor/hexcolor.dart';
// import 'package:uni_of_madinah/presentation/figma_design_Ui/subscription/widget/custom_listTile.dart';

// class CustomCardWidget extends StatelessWidget {
//   final String subscriptionType;
//   final String subscriptionAmount;
//   final String subscriptionInfo;
//   final String billingType;
//   final String billingAmount;

//   final bool isSelected;
//   final VoidCallback onTap;

//   const CustomCardWidget({
//     Key? key,
//     required this.subscriptionType,
//     required this.subscriptionAmount,
//     required this.subscriptionInfo,
//     required this.billingType,
//     required this.billingAmount,
//     required this.isSelected,
//     required this.onTap,
//   }) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return SizedBox(
//       height: 150.h,
//       width: 385.w,
//       child: Card(
//         elevation: 0,
//         color: isSelected ? HexColor("#F5FAFD") : HexColor("FFFFFF"),
//         shape: RoundedRectangleBorder(
//           borderRadius: BorderRadius.circular(16.sp),
//           side: const BorderSide(color: Color(0xFF05677E)),
//         ),
//         child: InkWell(
//           onTap: onTap,
//           child:
//               Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
//             ListTile(
//               title: Text(
//                 subscriptionType,
//                 style: Theme.of(context)
//                     .textTheme
//                     .titleMedium!
//                     .copyWith(color: HexColor("#2C3134")),
//               ),
//               subtitle: Padding(
//                 padding: EdgeInsets.only(top: 8.h),
//                 child: Text(
//                   subscriptionInfo,
//                   style: Theme.of(context).textTheme.bodyMedium!.copyWith(
//                         color: HexColor("#2C3134"),
//                       ),
//                 ),
//               ),
//               trailing: Padding(
//                 padding: EdgeInsets.only(top: 12.h),
//                 child: Text(
//                   subscriptionAmount,
//                   style: Theme.of(context).textTheme.headlineMedium!.copyWith(
//                         color: HexColor("#2C3134"),
//                         fontWeight: FontWeight.bold,
//                       ),
//                 ),
//               ),
//             ),
//             Padding(
//               padding: EdgeInsets.symmetric(horizontal: 20.0.sp),
//               child: Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 children: [
//                   Text(
//                     billingType,
//                     style: Theme.of(context)
//                         .textTheme
//                         .bodySmall!
//                         .copyWith(color: HexColor("#05677E")),
//                   ),
//                   Text(
//                     billingAmount,
//                     style: Theme.of(context)
//                         .textTheme
//                         .bodyMedium!
//                         .copyWith(color: HexColor("#05677E")),
//                   ),
//                 ],

//               ),
//             ),
//           ]),

//         ),
//       ),
//     );
//   }
// }
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hexcolor/hexcolor.dart';

class CustomCardWidget extends StatelessWidget {
  final String subscriptionType;
  final String subscriptionAmount;
  final String subscriptionInfo;
  final String billingType;
  final String billingAmount;

  final bool isSelected;
  final VoidCallback onTap;

  const CustomCardWidget({
    Key? key,
    required this.subscriptionType,
    required this.subscriptionAmount,
    required this.subscriptionInfo,
    required this.billingType,
    required this.billingAmount,
    required this.isSelected,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 150.h,
      width: 385.w,
      child: Card(
        elevation: 0,
        color: isSelected ? HexColor("#F5FAFD") : HexColor("#FFFFFF"),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16.sp),
          side: BorderSide(
            color: isSelected ? HexColor("#004156") : HexColor("#B2D6E9"),
            width: 1.5,
          ),
        ),
        child: InkWell(
          onTap: onTap,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ListTile(
                title: Padding(
                  padding: EdgeInsets.only(top: 4.0),
                  child: Text(
                    subscriptionType,
                    style: Theme.of(context)
                        .textTheme
                        .titleMedium!
                        .copyWith(color: HexColor("#2C3134")),
                  ),
                ),
                subtitle: Padding(
                  padding: EdgeInsets.only(top: 8.h),
                  child: Text(
                    subscriptionInfo,
                    style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                          color: HexColor("#2C3134"),
                        ),
                  ),
                ),
                trailing: Padding(
                  padding: EdgeInsets.only(top: 16.h),
                  child: Text(
                    subscriptionAmount,
                    style: Theme.of(context).textTheme.headlineSmall!.copyWith(
                          color: HexColor("#2C3134"),
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.0.sp),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      billingType,
                      style: Theme.of(context)
                          .textTheme
                          .bodySmall!
                          .copyWith(color: HexColor("#05677E")),
                    ),
                    Text(
                      billingAmount,
                      style: Theme.of(context)
                          .textTheme
                          .bodySmall!
                          .copyWith(color: Colors.black54),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
