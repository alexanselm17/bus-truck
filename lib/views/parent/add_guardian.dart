import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../common_widgets/custom_input_decoration.dart';
import '../../common_widgets/loading.dart';
import '../../common_widgets/response_dialog.dart';
import '../../common_widgets/roundedTrackerBtn.dart';
import '../../common_widgets/vertical_spacing.dart';
import '../../enums/operation_status.dart';
import '../../providers/student_provider.dart';
import '../../utils/constants.dart';

class AddGuardian extends StatefulWidget {
  const AddGuardian({Key? key}) : super(key: key);
  @override
  _AddGuardianState createState() => _AddGuardianState();
}

class _AddGuardianState extends State<AddGuardian> {
  final GlobalKey<FormState> _formKey = new GlobalKey<FormState>();

  final FocusNode _nameFocusNode = FocusNode();
  final FocusNode _emailFocusNode = FocusNode();
  final FocusNode _phoneFocusNode = FocusNode();
  final FocusNode _relationFocusNode = FocusNode();

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _relationController = TextEditingController();

  void _nameEditingComplete() {
    FocusScope.of(context).requestFocus(_emailFocusNode);
  }

  void _emailEditingComplete() {
    FocusScope.of(context).requestFocus(_phoneFocusNode);
  }

  void _phoneEditingComplete() {
    FocusScope.of(context).requestFocus(_relationFocusNode);
  }

  Widget _buildNameField() {
    return TextFormField(
      decoration: CustomInputDecoration(
        hintText: 'John Doe',
      ),
      focusNode: _nameFocusNode,
      onEditingComplete: _nameEditingComplete,
      controller: _nameController,
      keyboardType: TextInputType.text,
      textInputAction: TextInputAction.next,
      textCapitalization: TextCapitalization.words,
      validator: (String? value) {
        if (value!.isEmpty) {
          return "Guardian Name is required";
        }
        return null;
      },
      onSaved: (String? value) {},
      onChanged: (value) {},
    );
  }

  Widget _buildEmailField() {
    return TextFormField(
      decoration: CustomInputDecoration(
        hintText: 'johndoe@gmail.com',
      ),
      focusNode: _emailFocusNode,
      onEditingComplete: _emailEditingComplete,
      controller: _emailController,
      keyboardType: TextInputType.text,
      textInputAction: TextInputAction.next,
      textCapitalization: TextCapitalization.words,
      validator: (String? value) {
        if (value!.isEmpty) {
          return "Guardian Email is required";
        }
        if (!value.characters.contains('@') ||
            !value.characters.contains('.com')) {
          return "Enter a valid email";
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
        hintText: '0723******45',
      ),
      focusNode: _phoneFocusNode,
      onEditingComplete: _phoneEditingComplete,
      controller: _phoneController,
      keyboardType: TextInputType.text,
      textInputAction: TextInputAction.next,
      textCapitalization: TextCapitalization.words,
      validator: (String? value) {
        if (value!.isEmpty) {
          return "Guardian Mobile is required";
        }
        if (value.length < 10) {
          return "Enter a valid phone number";
        }
        return null;
      },
      onSaved: (String? value) {},
      onChanged: (value) {},
    );
  }

  Widget _buildRelationField() {
    return TextFormField(
      decoration: CustomInputDecoration(
        hintText: 'eg. mother,father,sister',
      ),
      focusNode: _relationFocusNode,
      keyboardType: TextInputType.text,
      controller: _relationController,
      textInputAction: TextInputAction.done,
      textCapitalization: TextCapitalization.words,
      validator: (String? value) {
        if (value!.isEmpty) {
          return "Relation is required";
        }
        return null;
      },
      onSaved: (String? value) {},
      onChanged: (value) {},
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: AppConstants.colorPrimary,
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text("Add Guardian"),
      ),
      body: SingleChildScrollView(
        child: Container(
          margin: EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Guardian Name'),
                VerticalSpacing(),
                _buildNameField(),
                VerticalSpacing(),
                Text('Guardian Email'),
                VerticalSpacing(),
                _buildEmailField(),
                VerticalSpacing(),
                Text('Mobile Number'),
                VerticalSpacing(),
                _buildPhoneField(),
                VerticalSpacing(),
                Text('Relationship'),
                VerticalSpacing(),
                _buildRelationField(),
                VerticalSpacing(),
                Consumer<StudentProvider>(
                  builder: (context, studentProvider, child) =>
                      Column(children: [
                    studentProvider.guardianLoadingStatus ==
                            OperationStatus.Loading
                        ? Align(alignment: Alignment.center, child: Loading())
                        : RoundedTrackerBtn(
                            text: "Add Guardian",
                            press: () async {
                              if (_formKey.currentState!.validate()) {
                                dynamic res = await _handleAddGuardian();
                                res.statusCode == 200
                                    ? ResponseDialog(
                                        context: context, response: res)
                                    : ResponseDialog(
                                        context: context,
                                        response: res.body,
                                        success: false);
                              }
                            },
                          ),
                  ]),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future _handleAddGuardian() async {
    dynamic res = await Provider.of<StudentProvider>(context, listen: false)
        .addGuardian(
          name: _nameController.text.trim(),
          email: _emailController.text.trim(),
          phoneNumber: _phoneController.text.trim(),
          relation: _relationController.text.trim(),
        )
        .then((value) => value);
    return res;
  }
}
