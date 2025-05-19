import 'package:flutter/material.dart';

import 'app_colors.dart';
import 'app_syles.dart';

abstract class AppDialogs {
  static void showMessage(
    context, {
    required String message,
    required Color color,
  }) =>
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            message,
            textAlign: TextAlign.center,
            style: AppStyles.settingsTabLabel.copyWith(
              color: AppColors.white,
              fontSize: 18,
            ),
          ),
          backgroundColor: color,
          dismissDirection: DismissDirection.horizontal,
        ),
      );

  static void showDialogWaiting(context) => showDialog(
        barrierDismissible: false,
        context: context,
        builder: (context) => const AlertDialog(
          title:  Center(
            child: CircularProgressIndicator(),
          ),
        ),
      );

  static void removeDialog(context) => Navigator.pop(context);
}
