import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AdaptativeTextfield extends StatelessWidget {
  final String? label;
  final TextEditingController? controller;
  final TextInputType? keyboardType;
  final Function(String)? onSubmitted;

  AdaptativeTextfield({
    this.controller,
    this.keyboardType = TextInputType.text,
    this.onSubmitted,
    this.label,
  });

  @override
  Widget build(BuildContext context) {
    final isIos = Platform.isIOS;

    return isIos
        ? Padding(
            padding: const EdgeInsets.only(bottom: 10.0),
            child: CupertinoTextField(
              controller: controller,
              keyboardType: keyboardType,
              onSubmitted: onSubmitted,
              placeholder: label,
              padding: EdgeInsets.symmetric(
                horizontal: 6,
                vertical: 12,
              ),
            ),
          )
        : TextField(
            controller: controller,
            decoration: InputDecoration(
              labelText: label,
            ),
            keyboardType: keyboardType,
            onSubmitted: onSubmitted,
          );
  }
}
