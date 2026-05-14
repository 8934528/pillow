import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:delightful_toast/delight_toast.dart';
import 'package:delightful_toast/toast/components/toast_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';

extension StringExtension on String {
  String capitalize() {
    if (isEmpty) return this;
    return "${this[0].toUpperCase()}${substring(1).toLowerCase()}";
  }
}

class NotificationUtils {
  static void showSuccessAlert(BuildContext context, String? message, {String? title}) {
    AwesomeDialog(
      context: context,
      dialogType: kIsWeb ? DialogType.noHeader : DialogType.success,
      animType: kIsWeb ? AnimType.scale : AnimType.rightSlide,
      title: title ?? 'Success',
      desc: message ?? '',
      btnOkOnPress: () {},
      btnOkColor: const Color(0xFFFF0000),
      buttonsTextStyle: const TextStyle(fontWeight: FontWeight.bold),
    ).show();
  }

  static void showErrorAlert(BuildContext context, String? message, {String? title}) {
    AwesomeDialog(
      context: context,
      dialogType: kIsWeb ? DialogType.noHeader : DialogType.error,
      animType: kIsWeb ? AnimType.scale : AnimType.scale,
      title: title ?? 'Error',
      desc: message ?? '',
      btnOkOnPress: () {},
      btnOkColor: Colors.redAccent,
      buttonsTextStyle: const TextStyle(fontWeight: FontWeight.bold),
    ).show();
  }

  static void showInfoAlert(BuildContext context, String? message, {String? title}) {
    AwesomeDialog(
      context: context,
      dialogType: kIsWeb ? DialogType.noHeader : DialogType.info,
      animType: kIsWeb ? AnimType.scale : AnimType.bottomSlide,
      title: title ?? 'Information',
      desc: message ?? '',
      btnOkOnPress: () {},
      btnOkColor: Colors.blueAccent,
    ).show();
  }

  static void showToast(BuildContext context, String? message, {IconData icon = Icons.info_outline, Color? color}) {
    if (message == null || message.isEmpty) return;
    DelightToastBar(
      autoDismiss: true,
      builder: (context) => ToastCard(
        leading: Icon(icon, color: color ?? const Color(0xFFFF0000)),
        title: Text(
          message,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 14),
        ),
      ),
    ).show(context);
  }

  static void showErrorToast(BuildContext context, String? message) {
    showToast(context, message ?? 'An error occurred', icon: Icons.error_outline, color: Colors.redAccent);
  }

  static void showSuccessToast(BuildContext context, String? message) {
    showToast(context, message ?? 'Success!', icon: Icons.check_circle_outline, color: Colors.green);
  }
}
