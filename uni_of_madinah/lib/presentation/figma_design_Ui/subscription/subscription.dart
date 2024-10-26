// import 'package:flutter/material.dart';
// import 'package:uni_of_madinah/presentation/figma_design_Ui/search/search_vm.dart';

// class Subscription extends StatelessWidget {
//   final SearchVM viewModel;

//   const Subscription({Key? key, required this.viewModel}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Subscription'),
//       ),
//       body: Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             ElevatedButton(
//               onPressed: () async {
//                 showDialog(
//                   context: context,
//                   builder: (context) => AlertDialog(
//                     title: const Text('Subscription'),
//                     content: const Text('You have subscribed to premium.'),
//                     actions: [
//                       ElevatedButton(
//                         onPressed: () {
//                           Navigator.pop(context);
//                         },
//                         child: const Text('OK'),
//                       ),
//                     ],
//                   ),
//                 );
//                 viewModel.subscribeToPremium();
//               },
//               child: const Text('Subscribe to Premium'),
//             ),
//             ElevatedButton(
//               onPressed: () async {
//                 bool confirmCancel = await showDialog(
//                   context: context,
//                   builder: (context) => AlertDialog(
//                     title: const Text('Cancel Subscription'),
//                     content: const Text(
//                         'Are you sure you want to cancel your subscription?'),
//                     actions: [
//                       ElevatedButton(
//                         onPressed: () {
//                           Navigator.pop(context, false);
//                         },
//                         child: const Text('No'),
//                       ),
//                       ElevatedButton(
//                         onPressed: () {
//                           Navigator.pop(context, true);
//                         },
//                         child: const Text('Yes'),
//                       ),
//                     ],
//                   ),
//                 );
//                 if (confirmCancel == true) {
//                   viewModel.cancelSubscription();
//                 }
//               },
//               child: const Text('Cancel'),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
