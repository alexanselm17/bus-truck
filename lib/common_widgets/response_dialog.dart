import 'package:flutter/material.dart';
import 'customdialog.dart';

class ResponseDialog {
  final BuildContext? context;
  dynamic response;
  bool success = true;
  ResponseDialog({this.context, this.response, this.success = true}) {
    showDialog(
        context: this.context!,
        barrierDismissible: false,
        builder: (dialogContext) => CustomDialog(
              icon: this.success ? Icons.check : Icons.cancel,
              title: this.success ? "Success" : "Error !",
              description:
                  this.success ? _getSuccessMessage() : _getErrorMessage(),
              cancelButtonText: "Ok",
              okayPress: () {
                Navigator.pop(dialogContext);
              },
            )).then((value) => {
          if (this.success)
            {
              Navigator.pop(context!),
            }
        });
  }
  _getSuccessMessage() {
    return "Success";
  }

  _getErrorMessage() {
    return "Error Please try again later!";
  }
}
