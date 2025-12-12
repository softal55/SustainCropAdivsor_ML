import 'package:crop_recommendation/app/utils/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:pinput/pinput.dart';

class OtpForm extends StatefulWidget {
  final Function(String) onChanged;

  const OtpForm({super.key, required this.onChanged});

  @override
  State<OtpForm> createState() => _OtpFormState();
}

class _OtpFormState extends State<OtpForm> {
  String currentPin = "";

  @override
  Widget build(BuildContext context) {
    // Default styling for the pin input
    final defaultPinTheme = PinTheme(
      width: 56,
      height: 56,
      textStyle: const TextStyle(
        fontSize: 20,
        color: Colors.white,
        fontWeight: FontWeight.w600,
      ),
      decoration: BoxDecoration(
        border: Border.all(color: AppColors.secondary),
        borderRadius: BorderRadius.circular(15),
        color: AppColors.grey,
      ),
    );

    // Styling for focused pin input
    final focusedPinTheme = defaultPinTheme.copyWith(
      textStyle: const TextStyle(
        fontSize: 20,
        color: Colors.black,
        fontWeight: FontWeight.w600,
      ),
      decoration: defaultPinTheme.decoration!.copyWith(
        border: Border.all(color: AppColors.primary),
      ),
    );

    // Styling for filled pin input
    final filledPinTheme = defaultPinTheme.copyWith(
      decoration: defaultPinTheme.decoration!.copyWith(
        color: AppColors.secondary,
      ),
    );

    return Center(
      child: Pinput(
        length: 4,
        defaultPinTheme: defaultPinTheme,
        focusedPinTheme: focusedPinTheme,
        submittedPinTheme: filledPinTheme,
        errorPinTheme: defaultPinTheme.copyWith(
          decoration: defaultPinTheme.decoration!.copyWith(
            border: Border.all(color: Colors.red),
          ),
        ),
        onChanged: (pin) {
          setState(() {
            currentPin = pin;
          });
          widget.onChanged(pin); // Notify parent about the change
        },
        validator: (value) {
          if (value == null || value.length != 4) {
            return "Invalid OTP";
          }
          return null;
        },
        pinputAutovalidateMode: PinputAutovalidateMode.onSubmit,
        pinAnimationType: PinAnimationType.rotation,
        showCursor: true,
      ),
    );
  }
}