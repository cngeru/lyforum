import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class FilledTextField extends StatelessWidget {
  const FilledTextField({Key? key, required this.hintText, required this.controller, this.textLength = 100, this.keyboardType = TextInputType.text})
      : super(key: key);

  final TextEditingController controller;
  final String hintText;
  final int textLength;
  final TextInputType keyboardType;

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      inputFormatters: [
        LengthLimitingTextInputFormatter(textLength),
      ],
      autocorrect: false,
      minLines: 1,
      maxLines: keyboardType == TextInputType.multiline ? 4 : 1,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        contentPadding: const EdgeInsets.all(12),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(
            width: 0,
            style: BorderStyle.none,
          ),
        ),
        isDense: true,
        hintText: hintText,
        filled: true,
        fillColor: Theme.of(context).dividerColor,
      ),
    );
  }
}

class PasswordInput extends HookWidget {
  final TextEditingController controller;
  final String hintText;
  final TextInputType? textInputType;

  const PasswordInput({
    Key? key,
    required this.controller,
    required this.hintText,
    this.textInputType,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final _obscureText = useState(true);
    return TextField(
      controller: controller,
      obscureText: _obscureText.value,
      decoration: InputDecoration(
        prefixIcon: const Icon(Icons.lock),
        isDense: true,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(
            width: 0,
            style: BorderStyle.none,
          ),
        ),
        hintText: hintText,
        filled: true,
        fillColor: Theme.of(context).dividerColor,
        suffixIcon: Padding(
          padding: const EdgeInsets.only(right: 8.0),
          child: IconButton(
            splashRadius: 20,
            icon: Icon(_obscureText.value ? Icons.visibility : Icons.visibility_off),
            onPressed: () {
              _obscureText.value = !_obscureText.value;
            },
          ),
        ),
      ),
      keyboardType: textInputType ?? TextInputType.text,
    );
  }
}
