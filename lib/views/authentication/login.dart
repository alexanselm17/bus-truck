import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../common_widgets/customdialog.dart';
import '../../common_widgets/reset_password_login.dart';
import '../../common_widgets/vertical_spacing.dart';
import '../../models/userModel.dart';
import '../../providers/auth_provider.dart';
import '../../providers/user_provider.dart';
import '../../utils/constants.dart';
import '../../utils/header_widget.dart';
import '../../utils/user_shared_pref.dart';
import 'reset_password.dart';
import '../contact/contact_page.dart';
import '../main_entry.dart';

class Login extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(body: LoginLayout());
  }
}

class LoginLayout extends StatefulWidget {
  const LoginLayout({Key? key}) : super(key: key);
  @override
  _LoginLayout createState() => _LoginLayout();
}

class _LoginLayout extends State<LoginLayout> {
  String? _email;
  String? _password;
  final _formKey = GlobalKey<FormState>();

  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _emailFocusNode = FocusNode();
  final _passwordFocusNode = FocusNode();

  bool _passwordVisible = true;
  bool _isError = false;

  void _emailEditingComplete() {
    FocusScope.of(context).requestFocus(_passwordFocusNode);
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _emailFocusNode.dispose();
    _passwordFocusNode.dispose();
    super.dispose();
  }

  Widget _buildEmailField() {
    return TextFormField(
      decoration: InputDecoration(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20.0),
          borderSide: BorderSide(color: Colors.grey.shade50, width: 1.0),
        ),
        hintText: "Email / Phone",
        prefixIcon: const Icon(Icons.email),
      ),
      keyboardType: TextInputType.emailAddress,
      autofillHints: const [AutofillHints.username, AutofillHints.email],
      controller: _emailController,
      focusNode: _emailFocusNode,
      textInputAction: TextInputAction.next,
      onEditingComplete: _emailEditingComplete,
      validator: (String? value) {
        if ((value ?? '').trim().isEmpty) {
          setState(() => _isError = true);
          return "Email address is required";
        }
        return null;
      },
      onSaved: (String? value) => _email = value?.trim(),
      onChanged: (value) => _email = value.trim(),
    );
  }

  Widget _buildPasswordField() {
    return TextFormField(
      decoration: InputDecoration(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20.0),
          borderSide: BorderSide(color: Colors.grey.shade50, width: 1.0),
        ),
        hintText: "Password",
        prefixIcon: const Icon(Icons.lock, size: 24),
        suffixIcon: IconButton(
          icon:
              Icon(_passwordVisible ? Icons.visibility_off : Icons.visibility),
          onPressed: () => setState(() => _passwordVisible = !_passwordVisible),
        ),
      ),
      obscureText: _passwordVisible,
      controller: _passwordController,
      focusNode: _passwordFocusNode,
      textInputAction: TextInputAction.done,
      autofillHints: const [AutofillHints.password],
      validator: (String? value) {
        if ((value ?? '').isEmpty) {
          setState(() => _isError = true);
          return "Password is required";
        }
        return null;
      },
      onSaved: (String? value) => _password = value,
      onChanged: (value) => _password = value,
      onFieldSubmitted: (_) => _onLogin(context),
    );
  }

  final Widget _loading = Column(
    mainAxisAlignment: MainAxisAlignment.center,
    children: const [
      CircularProgressIndicator(),
      SizedBox(height: 12),
      Text("Authenticating ... Please wait"),
    ],
  );

  Future<void> _onLogin(BuildContext context) async {
    final auth = Provider.of<AuthProvider>(context, listen: false);
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      final res = await auth.login(email: _email, password: _password);
      if (res['status'] == true) {
        final UserModel user = res['userModel'];
        Provider.of<UserProvider>(context, listen: false).setUser(user);
        await Provider.of<UserPreferences>(context, listen: false)
            .saveUser(user);
        if (!mounted) return;
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (_) => MainEntry()),
          (route) => false,
        );
      } else {
        if (!mounted) return;
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (dialogContext) => CustomDialog(
            icon: Icons.info_outline,
            title: "Alert",
            description: "Invalid credentials",
            cancelButtonText: "Ok",
            okayPress: () => Navigator.pop(dialogContext),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthProvider>(context);
    final media = MediaQuery.of(context);

    final headerHeight = math.max(
      180.0,
      math.min(260.0, media.size.height * 0.3),
    );

    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              padding: EdgeInsets.only(
                bottom: media.viewInsets.bottom + 16,
              ),
              child: ConstrainedBox(
                constraints: BoxConstraints(minHeight: constraints.maxHeight),
                child: IntrinsicHeight(
                  child: Column(
                    children: [
                      // Header
                      SizedBox(
                        height: headerHeight,
                        child: HeaderWidget(
                            headerHeight, true, Icons.login_rounded),
                      ),
                      const SizedBox(height: 8),

                      Center(
                        child: ConstrainedBox(
                          constraints: const BoxConstraints(maxWidth: 560),
                          child: Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 20.0),
                            child: Card(
                              elevation: 12,
                              shadowColor: Colors.black.withOpacity(0.15),
                              color: Colors.white, // White card background
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Container(
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(20),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.08),
                                      blurRadius: 20,
                                      offset: const Offset(0, 8),
                                    ),
                                  ],
                                ),
                                child: Padding(
                                  padding:
                                      const EdgeInsets.fromLTRB(24, 32, 24, 32),
                                  child: Form(
                                    key: _formKey,
                                    autovalidateMode: _isError
                                        ? AutovalidateMode.onUserInteraction
                                        : AutovalidateMode.disabled,
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.stretch,
                                      children: [
                                        // Login Title
                                        const Text(
                                          'Welcome Back',
                                          style: TextStyle(
                                            fontSize: 28,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.black87,
                                          ),
                                          textAlign: TextAlign.center,
                                        ),
                                        const SizedBox(height: 8),
                                        const Text(
                                          'Sign in to your account',
                                          style: TextStyle(
                                            fontSize: 16,
                                            color: Colors.black54,
                                          ),
                                          textAlign: TextAlign.center,
                                        ),
                                        const SizedBox(height: 32),

                                        _buildEmailField(),
                                        VerticalSpacing(height: 16.0),

                                        _buildPasswordField(),
                                        VerticalSpacing(height: 16.0),

                                        Align(
                                          alignment: Alignment.centerRight,
                                          child: LoginResetText(
                                            longText: 'Forgot password?',
                                            actionText: 'Reset',
                                            actionColor: Colors.red,
                                            press: () => Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (_) => ResetPassword(),
                                              ),
                                            ),
                                          ),
                                        ),
                                        VerticalSpacing(height: 24),

                                        auth.loggedInStatus ==
                                                Status.Authenticating
                                            ? Container(
                                                height: 50,
                                                decoration: BoxDecoration(
                                                  color: AppConstants
                                                      .colorPrimaryDark
                                                      .withOpacity(0.1),
                                                  borderRadius:
                                                      BorderRadius.circular(12),
                                                ),
                                                child: const Center(
                                                  child:
                                                      CircularProgressIndicator(),
                                                ),
                                              )
                                            : Container(
                                                decoration: BoxDecoration(
                                                  gradient: LinearGradient(
                                                    colors: [
                                                      AppConstants.colorAccent,
                                                      AppConstants.colorAccent
                                                          .withOpacity(0.8),
                                                    ],
                                                    begin: Alignment.topLeft,
                                                    end: Alignment.bottomRight,
                                                  ),
                                                  borderRadius:
                                                      BorderRadius.circular(12),
                                                  boxShadow: [
                                                    BoxShadow(
                                                      color: AppConstants
                                                          .colorPrimaryDark
                                                          .withOpacity(0.3),
                                                      blurRadius: 8,
                                                      offset:
                                                          const Offset(0, 4),
                                                    ),
                                                  ],
                                                ),
                                                child: Material(
                                                  color: Colors.transparent,
                                                  child: InkWell(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            12),
                                                    onTap: () =>
                                                        _onLogin(context),
                                                    child: Container(
                                                      height: 50,
                                                      alignment:
                                                          Alignment.center,
                                                      child: const Text(
                                                        "Login",
                                                        style: TextStyle(
                                                          color: Colors.white,
                                                          fontSize: 16,
                                                          fontWeight:
                                                              FontWeight.w600,
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ),

                                        VerticalSpacing(height: 24.0),

                                        // Contact section with better styling
                                        Container(
                                          padding: const EdgeInsets.all(16),
                                          decoration: BoxDecoration(
                                            color: Colors.grey.shade50,
                                            borderRadius:
                                                BorderRadius.circular(12),
                                            border: Border.all(
                                              color: Colors.grey.shade200,
                                              width: 1,
                                            ),
                                          ),
                                          child: Wrap(
                                            alignment: WrapAlignment.center,
                                            crossAxisAlignment:
                                                WrapCrossAlignment.center,
                                            children: [
                                              const Text(
                                                "Having trouble logging in? ",
                                                style: TextStyle(
                                                  fontWeight: FontWeight.w500,
                                                  fontSize: 14,
                                                  color: Colors.black87,
                                                ),
                                              ),
                                              InkWell(
                                                onTap: () {
                                                  Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                      builder: (_) =>
                                                          ContactPage(),
                                                    ),
                                                  );
                                                },
                                                borderRadius:
                                                    BorderRadius.circular(4),
                                                child: Padding(
                                                  padding: const EdgeInsets
                                                      .symmetric(
                                                    horizontal: 4,
                                                    vertical: 2,
                                                  ),
                                                  child: Text(
                                                    "Contact Support",
                                                    style: TextStyle(
                                                      color: AppConstants
                                                          .colorPrimaryDark,
                                                      decoration: TextDecoration
                                                          .underline,
                                                      decorationColor:
                                                          AppConstants
                                                              .colorPrimaryDark,
                                                      fontWeight:
                                                          FontWeight.w600,
                                                      fontSize: 14,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),

                      // Push content to bottom on tall screens but not on small ones
                      const Spacer(),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
