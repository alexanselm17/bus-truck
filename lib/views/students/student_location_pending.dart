import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../providers/student_provider.dart';

class StudentLocationPendingApproval extends StatefulWidget {
  @override
  _StudentLocationPendingApproval createState() =>
      _StudentLocationPendingApproval();
}

class _StudentLocationPendingApproval
    extends State<StudentLocationPendingApproval> {
  @override
  void initState() {
    Provider.of<StudentProvider>(context, listen: false)
        .getLocationPendingApproval();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<StudentProvider>(
        builder: (context, studentProvider, child) {
      return studentProvider.pendingLocation.status == 2
          ? SingleChildScrollView(
              child: Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    border: Border.all(
                      color: Colors.grey[300]!,
                    )),
                child: ListTile(
                  shape: StadiumBorder(),
                  leading: Column(
                    children: [
                      Icon(
                        Icons.message,
                        size: 40,
                        color: Colors.blue,
                      ),
                    ],
                  ),
                  title: Text(
                    "Your location change request to ${studentProvider.pendingLocation.locationName!.toUpperCase()} is under review you will be informed once done.",
                    style: GoogleFonts.aBeeZee(
                      textStyle: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w300,
                        color: Colors.black,
                        letterSpacing: 0.05,
                      ),
                    ),
                  ),
                  subtitle: Text(
                    'Hint: This request is approved by the school. You could call the school management to fast truck this request.',
                    style: TextStyle(
                      fontStyle: FontStyle.normal,
                    ),
                  ),
                ),
              ),
            )
          : Text('');
    });
  }
}
