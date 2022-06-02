import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AdaptativeButton extends StatelessWidget {
  final String? label;
  final Function()? onPress;

  AdaptativeButton({
    this.label,
    this.onPress,
  });

  @override
  Widget build(BuildContext context) {
    final isIos = Platform.isIOS;

    return isIos
        ? CupertinoButton(
            onPressed: onPress,
            color: Theme.of(context).colorScheme.primary,
            padding: EdgeInsets.symmetric(
              horizontal: 20,
            ),
            child: Text(
              label!,
            ),
          )
        : ElevatedButton(
            style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all(
                  Theme.of(context).colorScheme.primary),
            ),
            onPressed: onPress,
            child: Text(label!,
                style: TextStyle(
                  color: Theme.of(context).textTheme.button?.color,
                )),
          );
  }
}
