// // import 'package:flutter/material.dart';
// // import 'package:hexcolor/hexcolor.dart';

// // class PasswordTextField extends StatefulWidget {
// //   final TextEditingController controller;
// //   final String hintText;
// //   final String labelText;

// //   const PasswordTextField(
// //       {Key? key,
// //       required this.controller,
// //       required this.hintText,
// //       required this.labelText})
// //       : super(key: key);

// //   @override
// //   _PasswordTextFieldState createState() => _PasswordTextFieldState();
// // }

// // class _PasswordTextFieldState extends State<PasswordTextField> {
// //   bool _obscureText = true;

// //   @override
// //   Widget build(BuildContext context) {
// //     return TextFormField(
// //       controller: widget.controller,
// //       obscureText: _obscureText,
// //       decoration: InputDecoration(
// //         hintText: widget.hintText,
// //         labelText: widget.labelText,
// //         enabledBorder: UnderlineInputBorder(
// //           borderSide: BorderSide(
// //             color: HexColor("#05677E"),
// //           ),
// //         ),
// //         suffixIcon: IconButton(
// //           icon: Icon(
// //             _obscureText ? Icons.visibility : Icons.visibility_off,
// //             color: Colors.black,
// //           ),
// //           onPressed: () {
// //             setState(() {
// //               _obscureText = !_obscureText;
// //             });
// //           },
// //         ),
// //       ),
// //     );
// //   }
// // }
// import 'package:flutter/material.dart';
// import 'package:hexcolor/hexcolor.dart';

// class PasswordTextField extends StatefulWidget {
//   final TextEditingController controller;
//   final String hintText;
//   final String labelText;

//   const PasswordTextField({
//     Key? key,
//     required this.controller,
//     required this.hintText,
//     required this.labelText,
//   }) : super(key: key);

//   @override
//   _PasswordTextFieldState createState() => _PasswordTextFieldState();
// }

// class _PasswordTextFieldState extends State<PasswordTextField> {
//   bool _obscureText = true;

//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Text(
//           widget.labelText,
//           style: TextStyle(color: HexColor("#05677E")),
//         ),
//         TextFormField(
//           controller: widget.controller,
//           obscureText: _obscureText,
//           decoration: InputDecoration(
//             hintText: widget.hintText,
//             enabledBorder: UnderlineInputBorder(
//               borderSide: BorderSide(
//                 color: HexColor("#05677E"),
//               ),
//             ),
//             suffixIcon: IconButton(
//               icon: Icon(
//                 _obscureText ? Icons.visibility : Icons.visibility_off,
//                 color: Colors.black,
//               ),
//               onPressed: () {
//                 setState(() {
//                   _obscureText = !_obscureText;
//                 });
//               },
//             ),
//           ),
//         ),
//       ],
//     );
//   }
// }
