import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../utils/constants.dart';

class CustomInputDecoration extends InputDecoration {
  final String? labelText;
  final String? hintText;
  final Icon? prefixIcon;

  CustomInputDecoration({this.hintText, this.labelText, this.prefixIcon})
      : super(
            labelText: labelText,
            hintText: hintText,
            hintStyle: const TextStyle(
              color: Colors.grey,
            ),
            labelStyle: GoogleFonts.montserrat(
                textStyle: TextStyle(color: Colors.black)),
            contentPadding: const EdgeInsets.only(left: 10, top: 8, bottom: 8),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10.0),
              borderSide: BorderSide(color: Colors.grey.shade50, width: 1.0),
            ),
            prefixIconColor: AppConstants.colorPrimaryDark,
            suffixIconColor: AppConstants.colorPrimaryDark,
            prefixIcon: prefixIcon,
            focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(20.0),
                borderSide: BorderSide(color: AppConstants.colorPrimary)),
            fillColor: Colors.white,
            filled: true);
}
