import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'roundedTrackerBtn.dart';
import 'vertical_spacing.dart';
import '../utils/constants.dart';

class CustomDialog extends StatelessWidget {
  final String? title, description, okayButtonText, cancelButtonText;
  final Function? okayPress;
  final IconData? icon;

  const CustomDialog(
      {Key? key,
      @required this.title,
      @required this.description,
      this.icon,
      this.okayButtonText,
      this.okayPress,
      this.cancelButtonText})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0)), //this right here
      child: Container(
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              icon != null
                  ? Container(
                      height: 50.0,
                      width: 50.0,
                      decoration: new BoxDecoration(
                        color: AppConstants.colorPrimary,
                        shape: BoxShape.circle,
                      ),
                      child: Center(
                        child: Icon(
                          icon,
                          color: Colors.white,
                        ),
                      ))
                  : Container(),
              VerticalSpacing(),
              Text(
                title!,
                style: GoogleFonts.oswald(
                    color: Colors.black,
                    fontWeight: FontWeight.w700,
                    fontSize: 18.0),
              ),
              VerticalSpacing(),
              Text(
                description!,
                style: TextStyle(fontSize: 18.0),
                textAlign: TextAlign.center,
              ),
              VerticalSpacing(
                height: 20.0,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  okayButtonText != null
                      ? Expanded(
                          child: RoundedTrackerBtn(
                            press: () => okayPress,
                            text: okayButtonText!,
                            color: AppConstants.colorAccent,
                          ),
                        )
                      : Container(),
                  SizedBox(
                    width: 3,
                  ),
                  Expanded(
                    child: cancelButtonText != null
                        ? RoundedTrackerBtn(
                            text: cancelButtonText!,
                            color: Colors.grey,
                            press: () {
                              Navigator.of(context).pop();
                            },
                          )
                        : Container(),
                  )
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
