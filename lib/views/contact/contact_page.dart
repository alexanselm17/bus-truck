import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../common_widgets/custom_input_decoration.dart';
import '../../common_widgets/customdialog.dart';
import '../../common_widgets/roundedTrackerBtn.dart';
import '../../common_widgets/vertical_spacing.dart';
import '../../providers/auth_provider.dart';
import '../../utils/constants.dart';

class ContactPage extends StatelessWidget {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();

  final TextEditingController _schoolNameController = TextEditingController();
  final TextEditingController _messageController = TextEditingController();
  ContactPage({Key? key}) : super(key: key);

  Widget _buildNameField() {
    return TextFormField(
      decoration: CustomInputDecoration(
        hintText: "Name",
      ),
      keyboardType: TextInputType.phone,
      controller: _nameController,
      textInputAction: TextInputAction.next,
      validator: (String? value) {
        if (value!.isEmpty) {
          return "Please enter your name";
        }
        return null;
      },
      onSaved: (String? value) {},
      onChanged: (value) {},
    );
  }

  Widget _buildSchoolNameField() {
    return TextFormField(
      decoration: CustomInputDecoration(
        hintText: "School Name",
      ),
      keyboardType: TextInputType.phone,
      controller: _schoolNameController,
      textInputAction: TextInputAction.next,

      onSaved: (String? value) {},
      onChanged: (value) {},
    );
  }

  Widget _buildMessageField() {
    return TextFormField(
      decoration: CustomInputDecoration(
        hintText: "Message",
      ),
      keyboardType: TextInputType.phone,
      controller: _messageController,
      textInputAction: TextInputAction.next,
      validator: (String? value) {
        if (value!.isEmpty) {
          return "Message is required";
        }
        return null;
      },
      onSaved: (String? value) {},
      onChanged: (value) {},
    );
  }

  Widget _buildPhoneField() {
    return TextFormField(
      decoration: CustomInputDecoration(
        hintText: "Mobile No",
      ),
      keyboardType: TextInputType.phone,
      controller: _emailController,
      textInputAction: TextInputAction.next,
      validator: (String? value) {
        if (value!.isEmpty) {
          return "Your mobile Number is required";
        }
        return null;
      },
      onSaved: (String? value) {},
      onChanged: (value) {},
    );
  }

  clearInput() {
    _nameController.text = "";
    _schoolNameController.text = "";
    _messageController.text = "";
    _emailController.text = "";
  }

  @override
  Widget build(BuildContext context) {
    AuthProvider auth = Provider.of<AuthProvider>(context);
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: AppConstants.colorPrimary,
        title: Text("Contact Us"),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "We are based in Nairobi, making our clients offices a second office to bring services closer. The company has high professional staff with experience from working abroad and also within the kenya workspace.",
                  style: TextStyle(fontSize: 18.0),
                ),
                VerticalSpacing(),
                _buildNameField(),
                VerticalSpacing(),
                _buildSchoolNameField(),
                VerticalSpacing(),
                _buildPhoneField(),
                VerticalSpacing(),
                _buildMessageField(),
                VerticalSpacing(),
                auth.isLoading
                    ? CircularProgressIndicator()
                    : RoundedTrackerBtn(
                        text: "Submit",
                        press: () async {
                          if (_formKey.currentState!.validate()) {
                            _formKey.currentState!.save();
                            var res = await auth.sendMessage(
                                name: _nameController.text,
                                schoolName: _schoolNameController.text,
                                message: _messageController.text,
                                mobileNo: _emailController.text);
                            print(res);
                            if (res['status']) {
                              clearInput();
                              showDialog(
                                  context: context,
                                  barrierDismissible: false,
                                  builder: (dialogContext) => CustomDialog(
                                        icon: Icons.check,
                                        title: "Success",
                                        description:
                                            "Request received, we will reach out to you shortly",
                                        cancelButtonText: "Ok",
                                        okayPress: () {
                                          Navigator.pop(dialogContext);
                                        },
                                      ));
                              Navigator.pop(context);
                            } else {
                              showDialog(
                                  context: context,
                                  barrierDismissible: false,
                                  builder: (dialogContext) => CustomDialog(
                                        icon: Icons.info_outline,
                                        title: "Alert",
                                        description: "Invalid credentials",
                                        cancelButtonText: "Ok",
                                        okayPress: () {
                                          Navigator.pop(dialogContext);
                                        },
                                      ));
                            }
                          }
                          return;
                        },
                      )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
