import 'package:flutter/material.dart';

SimpleDialog genericSelectionDialog(String title,
        {required List<SimpleDialogOption> options}) =>
    SimpleDialog(
      title: Text(
        title,
      ),
      children: options,
    );
