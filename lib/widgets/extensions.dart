import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../utils/app_colors.dart';

extension AppInputDecoration on BuildContext {
  InputDecoration appInputDecoration({required String hintText}) {
    return InputDecoration(
      hintText: hintText,
      hintStyle: GoogleFonts.poppins(
        fontSize: 10.2,
        color: AppColors.black.withOpacity(0.3),
      ),
      fillColor: AppColors.lightGrey,
      filled: true,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10.2),
        borderSide: BorderSide.none,
      ),
    );
  }
}


extension TextFieldTitle on BuildContext{
  Widget textFieldTitle(String title) {
    return Column(
      children: [
        Align(
          alignment: Alignment.centerLeft,
          child: Text(
            title,
            style: GoogleFonts.poppins(
              color: AppColors.black,
              fontSize: 14.1,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        SizedBox(
          height: 8,
        ),
      ],
    );
  }
}
