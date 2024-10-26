import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:stacked/stacked.dart';
import 'package:uni_of_madinah/presentation/figma_design_Ui/subscription/subscription_vm.dart';
import 'package:uni_of_madinah/presentation/figma_design_Ui/subscription/widget/custom_card.dart';
import 'package:uni_of_madinah/widgets/custom_button.dart';
import 'package:uni_of_madinah/presentation/figma_design_Ui/subscription/widget/custom_listTile.dart';
import 'package:url_launcher/url_launcher.dart';

class SubscriptionView extends StatefulWidget {
  const SubscriptionView({super.key});

  @override
  State<SubscriptionView> createState() => _SubscriptionViewState();
}

class _SubscriptionViewState extends State<SubscriptionView> {
  int selectedPlan = 0;

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<SubscriptionVM>.reactive(
      onViewModelReady: (viewModel) => viewModel.setupActivePackages(),
      viewModelBuilder: () => SubscriptionVM(),
      builder: (context, viewModel, child) => Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          title: Semantics(
            excludeSemantics: true,
            label: 'Subscription View',
            child: Text(
              "Subscriptions",
              style: Theme.of(context).textTheme.headlineSmall!.copyWith(
                    color: HexColor("#05677E"),
                  ),
            ),
          ),
          leading: Semantics(
            excludeSemantics: true,
            label:
                'Back button Please double click to navigate back to previous screen',
            child: IconButton(
              icon: Icon(
                Icons.arrow_back,
                color: HexColor("#05677E"),
              ),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ),
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.sp),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 8.h),
                Padding(
                  padding: const EdgeInsets.only(left: 4.0),
                  child: Semantics(
                    excludeSemantics: true,
                    label:
                        "Get your hands on our yearly and monthly subscription plans.",
                    child: Text(
                      "Get your hands on our yearly and monthly subscription plans.",
                      style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                            color: HexColor("#40484C"),
                          ),
                    ),
                  ),
                ),
                SizedBox(height: 16.h),
                Semantics(
                  excludeSemantics: true,
                  label: 'Title for the auto-renewing subscription section.',
                  child: Padding(
                    padding: const EdgeInsets.only(left: 4.0),
                    child: Text(
                      "Auto-Renewing Subscriptions",
                      style: Theme.of(context).textTheme.titleLarge!.copyWith(
                            color: HexColor("#05677E"),
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                  ),
                ),
                SizedBox(height: 8.h),
                Semantics(
                  label: viewModel.userService.isPremium
                      ? ' Current Plan: ${viewModel.userService.planNameSubscription}. Cancel Subscription button. Tap to cancel your current subscription.'
                      : ' Select a Plan (You are currently not Subscribed to any plan)',
                  child: SizedBox(
                    width: double.infinity,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          viewModel.userService.isPremium
                              ? ' Current Plan: ${viewModel.userService.planNameSubscription}'
                              : ' Select a Plan (You are currently not Subscribed to any plan)',
                          style:
                              Theme.of(context).textTheme.bodySmall!.copyWith(
                                    color: HexColor("#40484C"),
                                  ),
                        ),
                        if (viewModel.userService.isPremium)
                          Semantics(
                            label:
                                "Cancel Subscription button. Tap to cancel your current subscription.",
                            child: TextButton(
                              onPressed: () async {
                                viewModel.showCancelSubscriptionDialog(context);
                              },
                              child: Text(
                                'Cancel Subscription',
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyMedium!
                                    .copyWith(
                                      color: HexColor("#1592E6"),
                                    ),
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 8.h),
                viewModel.isSettingUp
                    ? Semantics(
                        excludeSemantics: true,
                        label: "Loading subscription plans, please wait.",
                        child: const Center(
                            child: CircularProgressIndicator.adaptive()),
                      )
                    : ListView.builder(
                        shrinkWrap: true,
                        padding: EdgeInsets.all(0),
                        itemCount:
                            viewModel.revenuecatService.activeOfferings.length,
                        itemBuilder: (context, index) {
                          bool isSelected = index == viewModel.selectedPlan;
                          return Semantics(
                            excludeSemantics: true,
                            label:
                                '${viewModel.getBillingPeriodString(index)} subscription. ${index == 0 ? 'Subscribe and pay 1.99/month' : 'One time payment a year.'} at ${viewModel.revenuecatService.activeOfferings[index].storeProduct.priceString}. ${index == 0 ? 'Billed monthly' : 'Billed yearly'}. ${index == 0 ? '' : '\$1.67/month'}. Tap to select this plan.',
                            child: CustomCardWidget(
                              subscriptionType:
                                  viewModel.getBillingPeriodString(index),
                              subscriptionInfo: index == 0
                                  ? 'Subscribe and pay \$1.99/month'
                                  : 'One time payment a year.',
                              subscriptionAmount: viewModel
                                  .revenuecatService
                                  .activeOfferings[index]
                                  .storeProduct
                                  .priceString,
                              billingType: index == 0
                                  ? "Billed monthly"
                                  : "Billed yearly",
                              billingAmount: index == 0 ? "" : "\$1.67/month",
                              isSelected: isSelected,
                              onTap: () {
                                if (!viewModel.isProcessing) {
                                  viewModel.handlePackageSelection(index);
                                  setState(() {
                                    selectedPlan = index;
                                  });
                                }
                              },
                            ),
                          );
                        },
                      ),
                SizedBox(height: 16.sp),
                Semantics(
                  excludeSemantics: true,
                  label: "Features section.",
                  child: Padding(
                    padding: EdgeInsets.only(left: 4.0.sp),
                    child: Text(
                      "Premium Features",
                      style: Theme.of(context).textTheme.titleMedium!.copyWith(
                            color: HexColor("#40484C"),
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                  ),
                ),
                SizedBox(height: 12.sp),
                Semantics(
                  excludeSemantics: true,
                  label: '100% Ads Free.',
                  child: CustomListTileWidget(
                    leadingIcon: Icons.check,
                    title: '100% Ads Free',
                    leadingIconColor: HexColor("#05677E"),
                    textColor: HexColor("#2C3134"),
                  ),
                ),
                Semantics(
                  excludeSemantics: true,
                  label: 'Cancel Anytime.',
                  child: CustomListTileWidget(
                    leadingIcon: Icons.check,
                    title: 'Cancel Anytime',
                    leadingIconColor: HexColor("#05677E"),
                    textColor: HexColor("#2C3134"),
                  ),
                ),
                Semantics(
                  excludeSemantics: true,
                  label: 'Automatic Subscription Renewal.',
                  child: CustomListTileWidget(
                    leadingIcon: Icons.check,
                    title: 'Automatic Subscription Renewal',
                    leadingIconColor: HexColor("#05677E"),
                    textColor: HexColor("#2C3134"),
                  ),
                ),
                Semantics(
                  excludeSemantics: true,
                  label: 'Get Reminders.',
                  child: CustomListTileWidget(
                    leadingIcon: Icons.check,
                    title: 'Get Reminders',
                    leadingIconColor: HexColor("#05677E"),
                    textColor: HexColor("#2C3134"),
                  ),
                ),
                Semantics(
                  excludeSemantics: true,
                  label: 'Renewal Confirmations.',
                  child: CustomListTileWidget(
                    leadingIcon: Icons.check,
                    title: 'Renewal Confirmations',
                    leadingIconColor: HexColor("#05677E"),
                    textColor: HexColor("#2C3134"),
                  ),
                ),
                SizedBox(height: 16.sp),
                Semantics(
                  excludeSemantics: true,
                  label: viewModel.isProcessing
                      ? 'Subscribe button disabled. Processing payment.'
                      : 'Subscribe button. Tap to proceed with the payment.',
                  child: Center(
                    child: CustomButton(
                      buttonText: 'Subscribe',
                      onPressed: viewModel.isProcessing
                          ? null
                          : viewModel.handlePaymentTap,
                    ),
                  ),
                ),
                SizedBox(height: 12.h),
                Row(children: [
                  Semantics(
                    excludeSemantics: true,
                    label:
                        "By continuing, you agree to Privacy Policy and Terms & Conditions.",
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          " By continuing, you agree to ",
                          style:
                              Theme.of(context).textTheme.labelSmall!.copyWith(
                                    color: HexColor("#40484C"),
                                    fontWeight: FontWeight.w500,
                                  ),
                        ),
                        GestureDetector(
                          onTap: () => _launchUrl(
                              'https://docs.google.com/document/d/15MI5-a0_5SrATpoXLFsDOSoqY-Fbqeg8Hxn7sQIl88I/edit?usp=sharing'),
                          child: Text(
                            "Privacy Policy",
                            style: Theme.of(context)
                                .textTheme
                                .labelSmall!
                                .copyWith(
                                  color: Colors.blue,
                                  fontWeight: FontWeight.w500,
                                  decoration: TextDecoration.underline,
                                ),
                          ),
                        ),
                        Text(
                          " & ",
                          style:
                              Theme.of(context).textTheme.labelSmall!.copyWith(
                                    color: HexColor("#40484C"),
                                    fontWeight: FontWeight.w500,
                                  ),
                        ),
                        GestureDetector(
                          onTap: () => _launchUrl(
                              'https://docs.google.com/document/d/1kSBeeAPumLpsO7Q6WwTMqMbAeXtw1p7gFihxhZn2qAo/edit?usp=sharing'),
                          child: Text(
                            "Terms of Use (EULA)",
                            style: Theme.of(context)
                                .textTheme
                                .labelSmall!
                                .copyWith(
                                  color: Colors.blue,
                                  fontWeight: FontWeight.w500,
                                  decoration: TextDecoration.underline,
                                ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ]),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _launchUrl(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }
}
