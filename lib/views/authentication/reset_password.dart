import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:school_tracker/views/authentication/update_password.dart';
import '../../common_widgets/loading.dart';
import '../../common_widgets/reset_password_login.dart';
import '../../common_widgets/vertical_spacing.dart';
import '../../enums/operation_status.dart';
import '../../providers/user_provider.dart';
import '../../utils/constants.dart';
import '../../utils/header_widget.dart';
import 'login.dart';

class ResetPassword extends StatefulWidget {
  @override
  _ResetPassword createState() => _ResetPassword();
}

class _ResetPassword extends State<ResetPassword> {
  final double _headerHeight = 250;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              height: _headerHeight,
              child: HeaderWidget(_headerHeight, true, Icons.password_rounded),
            ),
            SizedBox(height: 20),
            Container(
              alignment: Alignment.topLeft,
              margin: const EdgeInsets.fromLTRB(20, 0, 20, 0),
              child: const Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    'Forgot Password?',
                    style: TextStyle(
                        fontSize: 35,
                        fontWeight: FontWeight.bold,
                        color: Colors.black54),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                    'Enter the phone number associated with your account.',
                    style: TextStyle(
                        fontWeight: FontWeight.bold, color: Colors.black54),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                    'We will send you a verification code to reset your password.',
                    style: TextStyle(
                      color: Colors.black38,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
            VerticalSpacing(
              height: 30.0,
            ),
            RequestPasswordReset(),
            VerticalSpacing(height: 20.0),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: LoginResetText(
                longText: 'Already have an account?',
                actionText: 'Login',
                actionColor: Colors.green,
                press: () {
                  Navigator.of(context).pop();
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => Login()));
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class RequestPasswordReset extends StatefulWidget {
  @override
  _RequestPasswordReset createState() => _RequestPasswordReset();
}

class _RequestPasswordReset extends State<RequestPasswordReset> {
  final TextEditingController _phoneInputField = TextEditingController();

  void _handlePasswordResetRequest(context) async {
    var response = await Provider.of<UserProvider>(context, listen: false)
        .requestPasswordReset(_phoneInputField.text, context);

    if (response == null) {
      final scaffold = ScaffoldMessenger.of(context);
      scaffold.showSnackBar(SnackBar(
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 25),
        backgroundColor: Colors.red,
        content: const Text('Invalid details given!'),
      ));
    } else if (response.statusCode == 200) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => UpdatePassword(),
        ),
      );
    }
  }

  Widget _phoneField() {
    return TextFormField(
      decoration: InputDecoration(
        hintText: 'Phone Number',
        border: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.grey.shade50, width: 1.0),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: AppConstants.colorPrimary, width: 1.0),
        ),
        prefixIcon: Icon(Icons.phone),
      ),
      keyboardType: TextInputType.phone,
      controller: _phoneInputField,
      validator: (String? value) {
        if (value!.isEmpty) {
          return "Phone Number is required";
        }
        return null;
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          _phoneField(),
          VerticalSpacing(height: 20.0),
          Consumer<UserProvider>(builder: (context, user, child) {
            return user.initializePasswordReset == OperationStatus.Loading
                ? Loading()
                : GestureDetector(
                    onTap: () {
                      _handlePasswordResetRequest(context);
                    },
                    child: Container(
                      width: MediaQuery.of(context).size.width,
                      height: 40.0,
                      decoration: BoxDecoration(
                        color: AppConstants.colorAccent,
                        borderRadius: BorderRadius.circular(20.0),
                      ),
                      child: Center(
                          child: Text(
                        "Request Reset",
                        style: TextStyle(color: Colors.white),
                      )),
                    ),
                  );
          })
        ],
      ),
    );
  }
}
