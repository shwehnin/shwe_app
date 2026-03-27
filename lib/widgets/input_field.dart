import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class InputField extends StatelessWidget {
  final TextEditingController? controller;
  final String label;
  final bool isDigit;
  final bool autoFocus;
  final Widget? prefix;
  final Widget? suffix;
  final int? maxLength;
  final Function()? onTap;
  final Function(String)? onFieldSubmitted;
  final Function(String)? onChanged;
  final TextInputType? inputType;
  final int? minLine;
  final int? maxLine;
  const InputField({
    super.key,
    this.onTap,
    this.maxLine,
    this.autoFocus = false,
    this.maxLength,
    this.inputType,
    this.prefix,
    this.suffix,
    this.controller,
    this.minLine,
    this.onChanged,
    this.onFieldSubmitted,
    required this.label,
    this.isDigit = false,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      autofocus: autoFocus,
      controller: controller,
      onTap: onTap,
      readOnly: onTap != null,
      minLines: minLine,
      maxLength: maxLength,
      onChanged: onChanged,
    //  maxLines:maxLine ?? (minLine == null ? null : minLine! + 2),
      onFieldSubmitted: onFieldSubmitted,
      inputFormatters: isDigit ? [FilteringTextInputFormatter.digitsOnly] : [],
      keyboardType: isDigit ? TextInputType.number : inputType,
      decoration: InputDecoration(
        hintText: label,
        filled: true,
        prefix: prefix,
       counter: const Offstage(),
        suffix: suffix,
        fillColor: Colors.grey.withValues(alpha:.2),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 15,
          vertical: 10,
        ),
        border: const OutlineInputBorder(
          borderSide: BorderSide.none,
          borderRadius: BorderRadius.all(Radius.circular(10)),
        ),
      ),
    );
  }
}
