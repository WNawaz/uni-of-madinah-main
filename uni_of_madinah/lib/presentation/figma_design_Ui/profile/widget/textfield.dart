import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';

class ProfileDetailTextField extends StatefulWidget {
  final String labelText;
  final String initialValue;
  final bool isPassword;

  const ProfileDetailTextField({
    Key? key,
    required this.labelText,
    required this.initialValue,
    this.isPassword = false,
  }) : super(key: key);

  @override
  _CustomTextFieldState createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<ProfileDetailTextField> {
  bool _obscureText = true;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      initialValue: widget.initialValue,
      readOnly: true,
      obscureText: widget.isPassword ? _obscureText : false,
      decoration: InputDecoration(
        labelText: widget.labelText,
        labelStyle: TextStyle(
          color: HexColor("#05677E"),
        ),
        filled: false,
        enabledBorder: UnderlineInputBorder(
          borderSide: BorderSide(
            color: HexColor("#05677E"),
          ),
        ),
        suffixIcon: widget.isPassword
            ? IconButton(
                icon: Icon(
                  _obscureText ? Icons.visibility : Icons.visibility_off,
                  color: Colors.black,
                ),
                onPressed: () {
                  setState(() {
                    _obscureText = !_obscureText;
                  });
                },
              )
            : null,
        contentPadding:
            const EdgeInsets.symmetric(vertical: 12.0, horizontal: 0.0),
      ),
    );
  }
}
