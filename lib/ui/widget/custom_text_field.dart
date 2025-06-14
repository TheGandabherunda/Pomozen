// Core Flutter imports
import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // Import for TextInputFormatter

// CustomTextField Widget Definition
class CustomTextField extends StatefulWidget {
  const CustomTextField({
    super.key,
    required this.controller,
    required this.hintText,
    required this.fillColor,
    required this.borderColor,
    required this.focusedBorderColor,
    required this.enabledBorderColor,
    required this.textColor,
    required this.hintTextColor,
    required this.isInputValid,
    required this.errorBorderColor,
    this.errorText,
    this.focusNode,
    this.autoFocusWhenEmpty = true,
    this.maxLines,
    this.onChanged,
    this.keyboardType = TextInputType.text,
    this.suffixIcon,
    this.validator,
    this.enabled = true,
    this.onSubmitted,
    this.inputFormatters, // Added inputFormatters property
  });

  // Text field properties
  final TextEditingController controller;
  final String hintText;
  final Color fillColor;
  final Color borderColor;
  final Color focusedBorderColor;
  final Color enabledBorderColor;
  final void Function(String)? onSubmitted;
  final Color textColor;
  final Color hintTextColor;
  final Color errorBorderColor;
  final String? errorText;
  final bool isInputValid;
  final FocusNode? focusNode;
  final bool autoFocusWhenEmpty;
  final int? maxLines;
  final ValueChanged<String>? onChanged;
  final TextInputType keyboardType;
  final Widget? suffixIcon;
  final String? Function(String?)? validator;
  final bool enabled;
  final List<TextInputFormatter>? inputFormatters; // New: Optional list of input formatters

  // Static constants for styling
  static const double _borderRadius = 14;
  static const double _borderWidth = 2;
  static const double _fontSize = 16;
  static const double _errorFontSize = 13;
  static const double _fieldPadding = 16;
  static const double _errorTopPadding = 6;

  @override
  State<CustomTextField> createState() => _CustomTextFieldState();
}

// State for CustomTextField
class _CustomTextFieldState extends State<CustomTextField> {
  late FocusNode _focusNode;

  // Lifecycle: Initialization
  @override
  void initState() {
    super.initState();
    _focusNode = widget.focusNode ?? FocusNode();

    if (widget.autoFocusWhenEmpty) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _handleAutoFocus();
      });
    }
  }

  // Lifecycle: Disposal
  @override
  void dispose() {
    if (widget.focusNode == null) {
      _focusNode.dispose();
    }
    super.dispose();
  }

  // Focus handling
  void _handleAutoFocus() {
    if (widget.autoFocusWhenEmpty &&
        widget.controller.text.isEmpty &&
        mounted &&
        widget.enabled) {
      _focusNode.requestFocus();
    }
  }

  // Main build method
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        TextField(
          controller: widget.controller,
          focusNode: _focusNode,
          style: _getTextStyle(),
          decoration: _getInputDecoration(),
          cursorColor: _hasError ? widget.errorBorderColor : widget.textColor,
          maxLines: widget.maxLines,
          onSubmitted: widget.onSubmitted,
          onChanged: widget.onChanged,
          keyboardType: widget.keyboardType,
          enabled: widget.enabled,
          inputFormatters: widget.inputFormatters, // Passed the new property here
        ),
        if (_hasError) _buildErrorText(),
      ],
    );
  }

  // Error state getter
  bool get _hasError =>
      widget.errorText != null && widget.errorText!.isNotEmpty;

  // Text style configuration
  TextStyle _getTextStyle() {
    return TextStyle(
      fontFamily: 'OpenRunde',
      height: 1.3,
      fontWeight: FontWeight.w500,
      color: widget.enabled ? widget.textColor : widget.textColor.withOpacity(0.5),
      fontSize: CustomTextField._fontSize,
    );
  }

  // Input decoration configuration
  InputDecoration _getInputDecoration() {
    return InputDecoration(
      hintText: widget.hintText,
      hintStyle: TextStyle(
        color: widget.enabled
            ? widget.hintTextColor
            : widget.hintTextColor.withOpacity(0.5),
        fontSize: CustomTextField._fontSize,
      ),
      filled: true,
      fillColor: widget.enabled ? widget.fillColor : widget.fillColor.withOpacity(0.5),
      contentPadding: const EdgeInsets.all(CustomTextField._fieldPadding),
      border: _buildBorder(_hasError ? widget.errorBorderColor : widget.borderColor),
      enabledBorder: _buildBorder(_hasError ? widget.errorBorderColor : widget.enabledBorderColor),
      focusedBorder: _buildBorder(_hasError ? widget.errorBorderColor : widget.focusedBorderColor),
      errorBorder: _buildBorder(widget.errorBorderColor),
      focusedErrorBorder: _buildBorder(widget.errorBorderColor),
      suffixIcon: widget.suffixIcon,
    );
  }

  // Border configuration
  OutlineInputBorder _buildBorder(Color color) {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(CustomTextField._borderRadius),
      borderSide: BorderSide(
        color: _hasError
            ? widget.errorBorderColor
            : (widget.enabled ? color : color.withOpacity(0.5)),
        width: CustomTextField._borderWidth,
      ),
    );
  }

  // Error text widget
  Widget _buildErrorText() {
    return Padding(
      padding: const EdgeInsets.only(top: CustomTextField._errorTopPadding),
      child: Text(
        widget.errorText!,
        style: TextStyle(
          fontFamily: 'OpenRunde',
          color: widget.errorBorderColor,
          height: 1.4,
          fontSize: CustomTextField._errorFontSize,
          fontWeight: FontWeight.normal,
        ),
      ),
    );
  }
}
