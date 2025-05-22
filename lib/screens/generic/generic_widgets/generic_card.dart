import 'package:flutter/material.dart';
import 'package:liga_master/screens/generic/appcolors.dart';

Card genericCard(
        {required String title,
        required String subtitle,
        required IconData trailIcon}) =>
    Card(
      color: AppColors.primaryColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      elevation: 2,
      child: ListTile(
        title: Text(
          title,
          style: TextStyle(color: AppColors.textColor),
        ),
        subtitle: Text(
          subtitle,
          style: TextStyle(
              color: AppColors.subtextColor, fontWeight: FontWeight.w600),
        ),
        trailing: Icon(
          trailIcon,
          color: AppColors.secondaryColor,
        ),
      ),
    );
