import 'package:flutter/material.dart';

TextButton genericTextButton(BuildContext context,
        {required void Function() onPressed, required String text}) =>
    TextButton(
      onPressed: onPressed,
      child: Text(text,
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Theme.of(context).dividerColor,
          )),
    );
