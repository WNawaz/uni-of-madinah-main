import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hexcolor/hexcolor.dart';

class CustomMaterialTextField extends StatefulWidget {
  final String labelText;
  final String hintText;
  final TextEditingController controller;
  final TextInputType keyboardType;
  final bool isPasswordField;

  const CustomMaterialTextField({
    Key? key,
    required this.labelText,
    required this.hintText,
    required this.controller,
    this.keyboardType = TextInputType.text,
    this.isPasswordField = false,
  }) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _CustomMaterialTextFieldState createState() =>
      _CustomMaterialTextFieldState();
}

class _CustomMaterialTextFieldState extends State<CustomMaterialTextField> {
  bool obscureText = true;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 355.w,
      //height: 65.h,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(widget.labelText,
              style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                  color: HexColor("#40484C"),
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w400,
                  fontFamily: 'Roboto')),
          //SizedBox(height: 8.h),
          TextFormField(
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'This field is required.';
              }
              return null;
            },
            controller: widget.controller,
            obscuringCharacter: "*",
            keyboardType: widget.keyboardType,
            obscureText: widget.isPasswordField ? obscureText : false,
            style:
                const TextStyle(color: Colors.black), // Set text color to white

            decoration: InputDecoration(
              focusedErrorBorder: OutlineInputBorder(
                borderSide: BorderSide(
                  color: Colors.red,
                  width: 1.sp,
                ),
                borderRadius: BorderRadius.circular(1.sp),
              ),
              contentPadding: EdgeInsets.symmetric(horizontal: 16.sp),
              hintText: widget.hintText,
              hintStyle: Theme.of(context).textTheme.bodyLarge!.copyWith(
                  color: HexColor("#40484C"),
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w400,
                  fontFamily: 'Roboto'),
              //SizedBox(height: 8.h),
              filled: true,
              fillColor: HexColor("#F5FAFD"),
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(
                  color: Colors.transparent,
                  width: 1.0.sp,
                ),
                borderRadius: BorderRadius.circular(100.sp),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(
                  color: Colors.transparent,
                  width: 1.0.sp,
                ),
                borderRadius: BorderRadius.circular(100.sp),
              ),
              errorBorder: OutlineInputBorder(
                borderSide: BorderSide(
                  color: Colors.red,
                  width: 1.0.sp,
                ),
                borderRadius: BorderRadius.circular(100.sp),
              ),
              // suffixIcon: widget.isPasswordField
              //     ? ExcludeSemantics(
              //         child: IconButton(
              //           icon: Icon(
              //             !obscureText
              //                 ? Icons.visibility_off
              //                 : Icons.visibility,
              //           ),
              //           onPressed: () {
              //             setState(() {
              //               obscureText = !obscureText;
              //             });
              //           },
              //         ),
              //       )
              // : null,
            ),
          ),
        ],
      ),
    );
  }
}
