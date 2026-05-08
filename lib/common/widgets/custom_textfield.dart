import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../core/constants/app_colors.dart';
import '../../core/theme/text_styles.dart';

class CustomTextField extends StatefulWidget {

  final TextEditingController controller;

  final String hintText;

  final String? labelText;

  final String? initialValue;

  final bool obscureText;

  final bool enabled;

  final bool readOnly;

  final int? maxLength;

  final int maxLines;

  final TextInputType keyboardType;

  final TextInputAction textInputAction;

  final Widget? prefixIcon;

  final Widget? suffixIcon;

  final String? Function(String?)? validator;

  final Function(String)? onChanged;

  final VoidCallback? onTap;

  final List<TextInputFormatter>? inputFormatters;

  final FocusNode? focusNode;

  final FocusNode? nextFocus;

  final EdgeInsetsGeometry? contentPadding;

  final Color? fillColor;

  final bool autofocus;

  final bool showBorder;

  const CustomTextField({
    super.key,
    required this.controller,
    required this.hintText,
    this.labelText,
    this.initialValue,
    this.obscureText = false,
    this.enabled = true,
    this.readOnly = false,
    this.maxLength,
    this.maxLines = 1,
    this.keyboardType = TextInputType.text,
    this.textInputAction = TextInputAction.next,
    this.prefixIcon,
    this.suffixIcon,
    this.validator,
    this.onChanged,
    this.onTap,
    this.inputFormatters,
    this.focusNode,
    this.nextFocus,
    this.contentPadding,
    this.fillColor,
    this.autofocus = false,
    this.showBorder = true,
  });

  @override
  State<CustomTextField> createState() =>
      _CustomTextFieldState();
}

class _CustomTextFieldState
    extends State<CustomTextField> {

  String? errorText;

  @override
  void initState() {
    super.initState();

    widget.controller.addListener(_handleValidation);
  }

  void _handleValidation() {

    if(widget.validator != null){

      final validation =
      widget.validator!(widget.controller.text);

      if(validation != errorText){

        setState(() {
          errorText = validation;
        });
      }
    }
  }

  @override
  void dispose() {

    widget.controller
        .removeListener(_handleValidation);

    super.dispose();
  }

  OutlineInputBorder _border({
    Color? color,
  }) {

    return OutlineInputBorder(

      borderRadius: BorderRadius.circular(16.r),

      borderSide: BorderSide(
        color: color ?? Colors.transparent,
        width: 1.2,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,

      children: [

        /// LABEL
        if(widget.labelText != null)...[

          Padding(
            padding: EdgeInsets.only(
              left: 2.w,
              bottom: 10.h,
            ),

            child: Text(
              widget.labelText!,

              style: AppTextStyles.semiBold(
                size: 13,
                color: const Color(0xFF5B5B6E),
              ),
            ),
          ),
        ],

        /// TEXTFIELD
        AnimatedContainer(

          duration:
          const Duration(milliseconds: 250),

          decoration: BoxDecoration(

            borderRadius:
            BorderRadius.circular(16.r),

            boxShadow: [

              if(errorText == null)
                BoxShadow(
                  color: Colors.black.withOpacity(0.03),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
            ],
          ),

          child: TextFormField(
            validator: widget.validator,

            controller: widget.controller,

            obscureText: widget.obscureText,

            enabled: widget.enabled,

            readOnly: widget.readOnly,

            maxLength: widget.maxLength,

            maxLines: widget.maxLines,

            keyboardType: widget.keyboardType,

            textInputAction:
            widget.textInputAction,

            focusNode: widget.focusNode,

            autofocus: widget.autofocus,

            inputFormatters:
            widget.inputFormatters,

            cursorColor: AppColors.primary,

            style: AppTextStyles.medium(
              size: 15,
              color: AppColors.black,
            ),

            decoration: InputDecoration(

              counterText: "",

              hintText: widget.hintText,

              hintStyle: AppTextStyles.medium(
                size: 14,
                color: const Color(0xFF9CA3AF),
              ),

              filled: true,

              fillColor: widget.fillColor ??
                  const Color(0xFFF7F8FA),

              prefixIcon: widget.prefixIcon,

              suffixIcon: widget.suffixIcon,

              contentPadding:
              widget.contentPadding ??

                  EdgeInsets.symmetric(
                    horizontal: 18.w,
                    vertical: 14.h,
                  ),

              errorStyle: const TextStyle(
                height: 0,
                fontSize: 0,
              ),

              border: _border(),

              enabledBorder: _border(
                color: widget.showBorder
                    ? const Color(0xFFE5E7EB)
                    : Colors.transparent,
              ),

              focusedBorder: _border(
                color: AppColors.primary,
              ),

              disabledBorder: _border(
                color: const Color(0xFFE5E7EB),
              ),

              errorBorder: _border(
                color: Colors.red,
              ),

              focusedErrorBorder: _border(
                color: Colors.red,
              ),
            ),

            onTap: widget.onTap,

            onChanged: (value){

              /// AUTO REMOVE ERROR
              if(errorText != null){

                final validation =
                widget.validator?.call(value);

                setState(() {
                  errorText = validation;
                });
              }

              widget.onChanged?.call(value);

              /// NEXT FOCUS
              if(value.isNotEmpty &&
                  widget.nextFocus != null){

                FocusScope.of(context)
                    .requestFocus(
                  widget.nextFocus,
                );
              }
            },
          ),
        ),

        /// ERROR TEXT
        AnimatedSwitcher(

          duration:
          const Duration(milliseconds: 250),

          child: errorText == null

              ? SizedBox(height: 8.h)

              : Padding(

            padding: EdgeInsets.only(
              top: 8.h,
              left: 4.w,
            ),

            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,

              children: [

                Icon(
                  Icons.error_outline_rounded,
                  color: Colors.red,
                  size: 16.sp,
                ),

                SizedBox(width: 6.w),

                Expanded(

                  child: Text(
                    errorText!,

                    style:
                    AppTextStyles.regular(
                      size: 12,
                      color: Colors.red,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}


// CustomTextField(
//
// controller: emailController,
//
// hintText: "Enter email",
//
// labelText: "EMAIL",
//
// keyboardType: TextInputType.emailAddress,
//
// validator: (value){
//
// if(value == null || value.isEmpty){
// return "Please enter email";
// }
//
// if(!RegExp(
// r'^[^@]+@[^@]+\.[^@]+',
// ).hasMatch(value)){
// return "Invalid email";
// }
//
// return null;
// },
// )









//
//
//
//
// CustomTextField(
//
// controller: passwordController,
//
// hintText: "Enter password",
//
// labelText: "PASSWORD",
//
// obscureText: true,
//
// validator: (value){
//
// if(value == null || value.isEmpty){
// return "Please enter password";
// }
//
// if(value.length < 6){
// return "Password must be 6 characters";
// }
//
// return null;
// },
// )