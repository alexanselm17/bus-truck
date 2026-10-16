import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:school_tracker/views/authentication/login.dart';

import '../../common_widgets/custom_input_decoration.dart';
import '../../common_widgets/loading.dart';
import '../../common_widgets/reset_password_login.dart';
import '../../common_widgets/vertical_spacing.dart';
import '../../enums/operation_status.dart';
import '../../providers/user_provider.dart';
import '../../utils/constants.dart';
import '../../utils/header_widget.dart';

class UpdatePassword extends StatefulWidget {
  @override
  _UpdatePassword createState() => _UpdatePassword();
}

class _UpdatePassword extends State<UpdatePassword> {
  final TextEditingController twoFactorController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();
  final double _headerHeight = 250;

  Widget _twoFactorField() {
    return TextFormField(
      decoration: CustomInputDecoration(
          hintText: "Verification Code", prefixIcon: Icon(Icons.code)),
      keyboardType: TextInputType.number,
      controller: twoFactorController,
      validator: (String? value) {
        if (value!.isEmpty) {
          return "Verification Code is required";
        }
        return null;
      },
    );
  }

  Widget _resendTwoFactor() {
    return Padding(
      padding: const EdgeInsets.only(top: 10.0),
      child: LoginResetText(
          longText: 'Didn`t receive code?',
          actionText: 'resend',
          press: () {
            Provider.of<UserProvider>(context, listen: false).resendTwoFactor();
          }),
    );
  }

  Widget _passwordField() {
    return TextFormField(
      obscureText: true,
      decoration: CustomInputDecoration(
          hintText: "New Password", prefixIcon: Icon(Icons.lock)),
      keyboardType: TextInputType.text,
      controller: passwordController,
      validator: (String? value) {
        if (value!.isEmpty) {
          return "password required";
        }
        return null;
      },
    );
  }

  Widget _confirmPassword() {
    return TextFormField(
      obscureText: true,
      decoration: CustomInputDecoration(
          hintText: "Confirm Password", prefixIcon: Icon(Icons.lock)),
      keyboardType: TextInputType.number,
      controller: confirmPasswordController,
      validator: (String? value) {
        if (value!.isEmpty) {
          return "password required";
        }
        return null;
      },
    );
  }

  void _handlePasswordReset(context) async {
    Response response =
        await Provider.of<UserProvider>(context, listen: false).resetPassword(
      twoFactorController.text,
      passwordController.text,
    );

    if (response.statusCode == 200) {
      final scaffold = ScaffoldMessenger.of(context);
      scaffold.showSnackBar(SnackBar(
        content: const Text('password Reset Successful'),
      ));
      Navigator.of(context).pop();
      Navigator.push(context, MaterialPageRoute(builder: (context) => Login()));

      Provider.of<UserProvider>(context, listen: false).resetPasswordParams();
      return;
    }

    final scaffold = ScaffoldMessenger.of(context);
    scaffold.showSnackBar(SnackBar(
      content: const Text('Invalid details!'),
    ));
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
              height: _headerHeight,
              child: HeaderWidget(_headerHeight, true, Icons.password_rounded),
            ),
            VerticalSpacing(height: size.height * 0.05),
            Container(
              alignment: Alignment.topLeft,
              margin: const EdgeInsets.fromLTRB(20, 0, 20, 0),
              child: const Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    'Create New Password',
                    style: TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                        color: Colors.black54),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                    'Enter the verification code send to you to your phone number and create a new password for your account',
                    style: TextStyle(
                      color: Colors.black38,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
            Container(
              margin: EdgeInsets.only(top: size.height * 0.05),
              padding: EdgeInsets.symmetric(horizontal: 10),
              color: Colors.white,
              child: Column(
                children: [
                  _twoFactorField(),
                  _resendTwoFactor(),
                  VerticalSpacing(
                    height: 20.0,
                  ),
                  _passwordField(),
                  VerticalSpacing(
                    height: 20.0,
                  ),
                  _confirmPassword(),
                  VerticalSpacing(
                    height: 20.0,
                  ),
                  Consumer<UserProvider>(builder: (context, user, child) {
                    return user.initializePasswordReset ==
                            OperationStatus.Loading
                        ? Loading()
                        : GestureDetector(
                            onTap: () {
                              _handlePasswordReset(context);
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
                                "Reset Password",
                                style: TextStyle(color: Colors.white),
                              )),
                            ),
                          );
                  }),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
