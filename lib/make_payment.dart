import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:stripe_payment/controller/customText.dart';
import 'package:stripe_payment/controller/payment_controller.dart';

class MakePaymentScreen extends StatefulWidget {
  const MakePaymentScreen(
      {super.key, required this.rentId, required this.index});

  final int index;
  final String rentId;

  @override
  State<MakePaymentScreen> createState() => _MakePaymentScreenState();
}

class _MakePaymentScreenState extends State<MakePaymentScreen> {


  final PaymentController _controller = Get.put(PaymentController());
  final _rentController = Get.find<RentHistoryController>();

  // final controller =  Get.put(CardDetailsController());

  final formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    print("host id ${widget.rentId}");
    return Scaffold(
      appBar: CustomAppBar(
          appBarContent: Row(
            children: [
              IconButton(
                  onPressed: () {
                    Get.back();
                  },
                  icon: const Icon(
                    Icons.arrow_back_ios_new,
                    size: 18,
                    color: Colors.black45,
                  )),
              CustomText(
                text: "Payment",

                fontSize: 18,
                fontWeight: FontWeight.w600, color: Colors.blueAccent,
              )
            ],
          )),
      body: Form(
        key: formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
          child: GetBuilder<CardDetailsController>(builder: (controller) {
            return Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                controller.cardNumber.isEmpty?const SizedBox(): GestureDetector(
                  onTap: () {
                    showDialog(
                        context: context,
                        builder: (context) {
                          return AlertDialog(
                            title: Column(
                              children: [
                                const CustomText(
                                  text: "Are want to payment?",
                                  color: AppColors.blackNormal,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 16,
                                ),
                                const SizedBox(
                                  height: 24,
                                ),
                                Row(
                                  mainAxisAlignment:
                                  MainAxisAlignment.spaceBetween,
                                  children: [
                                    CustomElevatedButton(
                                      onPressed: () {
                                        Get.back();
                                      },
                                      titleText: "No",
                                      buttonColor: Colors.red.withOpacity(0.3),
                                      buttonHeight: 36,
                                      titleColor: AppColors.blackNormal,
                                      buttonWidth:
                                      MediaQuery.of(context).size.width /
                                          3.5,
                                    ),
                                    controller.isLoading ? const Center(child: CircularProgressIndicator(color: AppColors.primaryColor,)) :CustomElevatedButton(
                                      onPressed: () {
                                        controller.tokenizeCard(
                                            rentId: widget.rentId,
                                            amount: int.parse(
                                                _rentController
                                                    .rentUser[
                                                widget.index]
                                                    .totalAmount!),
                                            email: _rentController
                                                .rentUser[widget.index]
                                                .userId!
                                                .email!,
                                            productName: _rentController
                                                .rentUser[widget.index]
                                                .carId!
                                                .carModelName!,
                                            index: widget.index);

                                        Get.back();
                                      },
                                      titleText: "Yes",
                                      buttonHeight: 36,
                                      titleColor: Colors.white,
                                      buttonWidth: MediaQuery.of(context)
                                          .size
                                          .width /
                                          3.5,
                                    ),
                                  ],
                                )
                              ],
                            ),
                          );
                        });

                    /* controller.tokenizeCard(
                          rentId: widget.rentId,
                          amount: int.parse(_rentController
                              .rentUser[widget.index].totalAmount!),
                          email: _rentController
                              .rentUser[widget.index].userId!.email!,
                          productName: _rentController
                              .rentUser[widget.index].carId!.carModelName!,
                          index: widget.index);*/
                  },
                  child: Container(
                    padding: const EdgeInsets.only(top: 16, left: 26, bottom: 8),
                    decoration: BoxDecoration(
                      border: Border.all(
                          color: AppColors.whiteNormalActive, width: 1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Image.asset(
                          "assets/images/Card Icon.png",
                          height: 35,
                          width: 50,
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const CustomText(
                              bottom: 8,
                              textAlign: TextAlign.start,
                              text: "Visa Card",
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                            CardDetailsWidget(
                                cardDetails: controller.cardDetailsModel),
                          ],
                        ),
                        const Icon(
                          Icons.arrow_forward_ios,
                          size: 24,
                          color: Color(0xff595959),
                        )
                      ],
                    ),
                  ),
                ),


                const SizedBox(
                  height: 12,
                ),


                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CustomText(text: "Card Number".tr, bottom: 12),
                    CustomTextField(
                      inputFormatters: [
                        FilteringTextInputFormatter.digitsOnly,
                        CardNumberFormatter()
                      ],
                      maxLength: 19,
                      hintText: "XXXX XXXX XXXX XXXX".tr,
                      textEditingController: _controller.cardNumber,
                      textInputAction: TextInputAction.next,
                      keyboardType: TextInputType.number,
                      // focusNode: controller.emailFocusNode,
                      hintStyle: GoogleFonts.poppins(
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                          letterSpacing: 1,
                          color: AppColors.whiteNormalActive),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Enter your Credit card number".tr;
                        }
                        return null;
                      },
                    ),
                    CustomText(
                      text: "Expired Date".tr,
                      bottom: 12,
                      top: 16,
                    ),
                    CustomTextField(
                      inputFormatters: [CardExpirationFormatter()],
                      textEditingController: _controller.expiryDate,
                      // focusNode: controller.passwordFocusNode,
                      textInputAction: TextInputAction.next,
                      hintText: "MM/YY".tr,
                      keyboardType: TextInputType.number,
                      maxLength: 5,
                      hintStyle: GoogleFonts.poppins(
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                          letterSpacing: 1,
                          color: AppColors.whiteNormalActive),
                      validator: (value) {
                        if (value == null || value.toString().isEmpty) {
                          return "Enter your Expire date".tr;
                        } else if (value.toString().length > 5) {
                          return "Enter your valid Expire date".tr;
                        }
                        return null;
                      },
                    ),
                    CustomText(
                      text: "CVV".tr,
                      bottom: 12,
                      top: 16,
                    ),
                    CustomTextField(
                      textEditingController: _controller.cvvCode,
                      textInputAction: TextInputAction.next,
                      // focusNode: controller.passwordFocusNode,

                      hintText: "Enter CVV".tr,
                      keyboardType: TextInputType.number,
                      maxLength: 4,
                      hintStyle: GoogleFonts.poppins(
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                          letterSpacing: 1,
                          color: AppColors.whiteNormalActive),
                      validator: (value) {
                        if (value == null || value.toString().isEmpty) {
                          return "Enter your CVV number".tr;
                        } else if (value.toString().length > 4) {
                          return "Enter your valid CVV number";
                        }
                        return null;
                      },
                    ),
                  ],
                ),
              ],
            );
          }),
        ),
      ),
      bottomNavigationBar: GetBuilder<PaymentController>(
        builder: (controller) {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
            child: controller.isLoading
                ? const CustomElevatedLoadingButton()
                : CustomElevatedButton(
                buttonWidth: MediaQuery.of(context).size.width,
                onPressed: () {
                  controller.tokenizeCard(
                      rentId: widget.rentId,
                      amount: int.parse(_rentController
                          .rentUser[widget.index].totalAmount!),
                      email: _rentController
                          .rentUser[widget.index].userId!.email!,
                      productName: _rentController
                          .rentUser[widget.index].carId!.carModelName!,
                      index: widget.index);
                },
                titleText: "Pay Now".tr),
          );
        },
      ),
    );
  }
}

///<----------------card expired date format ------------->
class CardExpirationFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    final newValueString = newValue.text;
    String valueToReturn = '';

    for (int i = 0; i < newValueString.length; i++) {
      if (newValueString[i] != '/') valueToReturn += newValueString[i];
      var nonZeroIndex = i + 1;
      final contains = valueToReturn.contains(RegExp(r'\/'));
      if (nonZeroIndex % 2 == 0 &&
          nonZeroIndex != newValueString.length &&
          !(contains)) {
        valueToReturn += '/';
      }
    }
    return newValue.copyWith(
      text: valueToReturn,
      selection: TextSelection.fromPosition(
        TextPosition(offset: valueToReturn.length),
      ),
    );
  }
}

///<-----------------cardNumber format -------------->
class CardNumberFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue previousValue,
      TextEditingValue nextValue,
      ) {
    var inputText = nextValue.text;

    if (nextValue.selection.baseOffset == 0) {
      return nextValue;
    }

    var bufferString = StringBuffer();
    for (int i = 0; i < inputText.length; i++) {
      bufferString.write(inputText[i]);
      var nonZeroIndexValue = i + 1;
      if (nonZeroIndexValue % 4 == 0 && nonZeroIndexValue != inputText.length) {
        bufferString.write(' ');
      }
    }

    var string = bufferString.toString();
    return nextValue.copyWith(
      text: string,
      selection: TextSelection.collapsed(
        offset: string.length,
      ),
    );
  }
}

class CardDetailsWidget extends StatelessWidget {
  final CardDetailsModel cardDetails;
  final double bottom;
  final TextAlign textAlign;
  final double fontSize;
  final FontWeight fontWeight;

  CardDetailsWidget({
    required this.cardDetails,
    this.bottom = 8,
    this.textAlign = TextAlign.start,
    this.fontSize = 16,
    this.fontWeight = FontWeight.w600,
  });

  @override
  Widget build(BuildContext context) {
    String maskedCardNumber =
    getMaskedCardNumber(cardDetails.cardInfo?.creaditCardNumber ?? "");

    return CustomText(
      bottom: bottom,
      textAlign: textAlign,
      text: maskedCardNumber,
      fontSize: fontSize,
      fontWeight: fontWeight,
    );
  }

  String getMaskedCardNumber(String? cardNumber) {
    // Check for null or empty card number
    if (cardNumber == null || cardNumber.isEmpty) {
      return '';
    }

    // Assuming the last 4 digits are to be shown unmasked
    String lastFourDigits = cardNumber.substring(cardNumber.length - 4);

    // Pad with spaces if needed
    String maskedDigits = '*' * (cardNumber.length - 4);
    maskedDigits = maskedDigits.replaceAllMapped(
        RegExp(r'.{4}'), (match) => '${match.group(0)} ');

    return '$maskedDigits $lastFourDigits';
  }
}
