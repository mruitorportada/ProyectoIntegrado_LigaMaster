import 'package:flutter/material.dart';

Card genericCard(
        {required String title,
        required String subtitle,
        required IconData trailIcon}) =>
    Card(
      child: ListTile(
        title: Text(
          title,
        ),
        subtitle: Text(
          subtitle,
        ),
        trailing: Icon(
          trailIcon,
        ),
      ),
    );
