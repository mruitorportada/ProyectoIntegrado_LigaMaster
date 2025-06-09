import 'package:flutter/material.dart';

Card genericCard(
        {required String title,
        required String subtitle,
        required Widget trailIcon}) =>
    Card(
      child: ListTile(
        title: Text(
          title,
        ),
        subtitle: Text(
          subtitle,
        ),
        trailing: trailIcon,
      ),
    );
