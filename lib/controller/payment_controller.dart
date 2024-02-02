import 'dart:convert';

import 'package:flutter/cupertino.dart';

class PaymentController extends GetxController {
  TextEditingController expiryDate = TextEditingController();
  TextEditingController cardNumber = TextEditingController();
  TextEditingController cvvCode = TextEditingController();
  bool isLoading = false;

  final rentHistoryController = Get.find<RentHistoryController>();



  Future<void> tokenizeCard({required String rentId, required String productName, required int amount,required String email, required int index}) async {
    print(expiryDate.text.substring(0, 2));
    print(expiryDate.text.substring(3, 5));
    isLoading = true;
    update();
    try {
      var headers = {
        'Content-Type': 'application/x-www-form-urlencoded',
        'Authorization': 'Bearer ${AppConstants.secretKeyStripe}'
      };
      var request = http.Request('POST', Uri.parse(ApiUrlContainer.stripeUrl));

      request.bodyFields= {
        'card[exp_month]': expiryDate.text.substring(0, 2),
        'card[exp_year]': expiryDate.text.substring(3, 5),
        'card[number]': cardNumber.text,
        'card[cvc]': cvvCode.text
      };
      request.bodyFields.forEach((key, value) {
        print('$key: $value');
      });

      request.headers.forEach((key, value) {
        print('$key: $value');
      });

      request.headers.addAll(headers);

      http.StreamedResponse response = await request.send();

      if (response.statusCode == 200) {
        //print(await response.stream.bytesToString());
        var data = json.decode(await response.stream.bytesToString());
        print(data['id']);
        await payment(amount: amount, rentId: rentId, productName: productName, email: email, token: data['id'],  index: index);
        isLoading = false;
        update();
      } else {
        print(response.reasonPhrase);
      }
    } on Exception catch (e) {
      AppUtils.successToastMessage(e.toString());
      // TODO
    }
    isLoading = false;
    update();
  }


  payment({required String rentId, required String productName, required int amount, required String email, required String token, required int index}) async {
    try {
      Map<String, dynamic> body = {
        "product": {"name": productName, "price": amount},
        "token": {"email": email, "id": token}
      };
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      String t = prefs.getString(SharedPreferenceHelper.accessTokenKey) ?? "";
      debugPrint("=======> bearer token :$t");
      debugPrint("=======> rentId :$rentId");
      var headers = {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $t'
      };
      debugPrint(
          "=======> Url : ${ApiUrlContainer.apiBaseUrl}${ApiUrlContainer.paymentApi}/$rentId");
      var response = await http.post(
          Uri.parse("${ApiUrlContainer.apiBaseUrl}${ApiUrlContainer.paymentApi}/$rentId"),
          body: json.encode(body),
          headers: headers);


      if (response.statusCode == 200) {
        clearData();
        AppUtils.successToastMessage("Payment Completed");
        rentHistoryController.rentHistoryResult();
        Get.toNamed(AppRoute.startTrip, arguments: index);
        print("==========> response : ${response.body}");
      } else {
        print("==========> response error : ${response.body}");
      }
    } on Exception catch (e) {
      print("==========> catch error  : $e ");
    }
    isLoading = false;
    update();
  }

  clearData() {
    cardNumber.text = "";
    cvvCode.text = "";
    expiryDate.text = "";
    update();
  }
}
