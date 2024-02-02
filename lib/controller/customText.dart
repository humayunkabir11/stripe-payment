

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CustomText extends StatelessWidget {
  const CustomText({super.key, required text, required color, required int fontSize, required FontWeight fontWeight});

  @override
  Widget build(BuildContext context) {
    return Text(

      " Payment",
      style: TextStyle(

        color: Colors.black45,
        fontSize: 18,
        fontWeight: FontWeight.w600,
      ),

    );
  }
}
