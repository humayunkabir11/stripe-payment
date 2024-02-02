import 'package:flutter/material.dart';
import 'package:stripe_payment/make_payment.dart';
import 'package:get/get.dart';

void main() {
  runApp( MyApp());
}

class MyApp extends StatelessWidget {
   MyApp({super.key});

   late int index;
   late String rentId;
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(

      home:  MakePaymentScreen(rentId: rentId, index: index)
    );
  }
}


