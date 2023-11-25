import 'package:diario_viagens_front/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AppFormField extends StatelessWidget {
  final String? label;
  final String? hint;
  final TextEditingController? controller;
  final FocusNode? currentFocus;
  final FocusNode? nextFocus;
  final bool isNumber;
  final bool enabled;
  final bool fadeTextIfDisabled;
  final bool obsecureText;
  final VoidCallback? onTap;
  final Function? onFiledSubmited;
  final EdgeInsets margin;
  final double? width;
  final int maxLines;
  final int maxLength;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  final TextCapitalization textCapitalization;
  final bool autocorrect;
  final Widget? suffixIcon;
  final bool? readOnly;
  String? Function(String?)? validator;
  void Function(String)? onChanged;

  AppFormField(
      {this.label,
      this.hint,
      this.controller,
      this.currentFocus,
      this.nextFocus,
      this.onChanged,
      this.isNumber = false,
      this.enabled = true,
      this.validator,
      this.fadeTextIfDisabled = true,
      this.obsecureText = false,
      this.onTap,
      this.margin = const EdgeInsets.symmetric(horizontal: 7, vertical: 5),
      this.width,
      this.keyboardType,
      this.maxLines = 1,
      this.maxLength = 250,
      this.textCapitalization = TextCapitalization.sentences,
      this.autocorrect = true,
      this.onFiledSubmited,
      this.suffixIcon,
      this.textInputAction,
      this.readOnly});

  @override
  Widget build(BuildContext context) {
    var style = Theme.of(context).textTheme.labelLarge;

    if (!enabled && fadeTextIfDisabled) {
      style = style!.copyWith(color: style.color!.withAlpha(100));
    }

    return Padding(
      padding: margin,
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          width: width,
          decoration: BoxDecoration(
            color: Theme.of(context).cardColor,
            borderRadius: ThemeApp.defaultCardBorderRadius(),
            boxShadow: ThemeApp.defaultShadow(context),
          ),
          padding: const EdgeInsets.only(left: 20, right: 8, bottom: 15),
          child: TextFormField(
            onChanged: onChanged,
            validator: validator,
            readOnly: readOnly ?? false,
            style: TextStyle(
              color: Colors.grey[900],
            ),
            autocorrect: autocorrect,
            controller: controller,
            focusNode: currentFocus,
            enabled: enabled,
            obscureText: obsecureText,
            maxLines: maxLines,
            textCapitalization: textCapitalization,
            textInputAction: textInputAction ??
                (maxLines > 1 ? TextInputAction.done : TextInputAction.next),
            keyboardType: keyboardType ??
                (maxLines > 1
                    ? TextInputType.multiline
                    : isNumber
                        ? TextInputType.phone
                        : TextInputType.text),
            onFieldSubmitted: (v) {
              if (nextFocus != null)
                FocusScope.of(context).requestFocus(nextFocus);

              if (onFiledSubmited != null) {
                onFiledSubmited!();
              }
            },
            inputFormatters: [
              LengthLimitingTextInputFormatter(maxLength),
            ],
            decoration: InputDecoration(
                hintText: hint,
                labelText: label,
                labelStyle: TextStyle(
                  color: Colors.grey[900],
                ),
                alignLabelWithHint: true,
                suffixIcon: suffixIcon),
          ),
        ),
      ),
    );
  }
}
