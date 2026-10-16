import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../utils/constants.dart';
import '../utils/user_shared_pref.dart';
import 'main_entry.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key, this.embedded = false});

  final bool embedded;

  Widget _buildProfileHeader(UserPreferences userPreferences) {
    return Container(
      padding: EdgeInsets.all(24),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(30),
          bottomRight: Radius.circular(30),
        ),
      ),
      child: Column(
        children: [
          SizedBox(height: 20),
          Stack(
            children: [
              Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(50),
                  border: Border.all(color: Colors.white, width: 4),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.2),
                      blurRadius: 15,
                      offset: Offset(0, 5),
                    ),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(50),
                  child: Container(
                    color: Colors.white,
                    child: Image(
                      image: AssetImage("assets/images/userIcon.png"),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
              Positioned(
                bottom: 8,
                right: 8,
                child: Container(
                  width: 24,
                  height: 24,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    color: userPreferences.appUser.status.toString() == '1'
                        ? Colors.green
                        : Colors.grey,
                    border: Border.all(color: Colors.white, width: 2),
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 16),
          Text(
            userPreferences.appUser.name ?? 'User Name',
            style: TextStyle(
              color: Colors.black,
              fontSize: 24,
              fontWeight: FontWeight.bold,
              letterSpacing: 0.5,
            ),
          ),
          SizedBox(height: 4),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 12, vertical: 4),
            decoration: BoxDecoration(
              color: AppConstants.primaryOrange,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              userPreferences.appUser.status.toString() == '1'
                  ? 'Active'
                  : 'Inactive',
              style: TextStyle(
                color: Colors.white,
                fontSize: 12,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppConstants.background,
      appBar: embedded
          ? null
          : AppBar(
              elevation: 0,
              backgroundColor: AppConstants.colorPrimary,
              leading: IconButton(
                onPressed: () => Navigator.pop(context),
                icon: Icon(Icons.arrow_back_ios,
                    color: AppConstants.navy, size: 20),
              ),
              title: Text(
                'My Profile',
                style: TextStyle(
                  color: AppConstants.navy,
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),
              actions: [
                IconButton(
                  onPressed: () {
                    _showLogoutDialog(context);
                  },
                  icon: Container(
                    padding: EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      color: AppConstants.navy.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child:
                        Icon(Icons.logout, color: AppConstants.navy, size: 18),
                  ),
                ),
                SizedBox(width: 12),
              ],
            ),
      body: Consumer<UserPreferences>(
        builder: (context, UserPreferences userPreferences, child) {
          return SingleChildScrollView(
            child: Column(
              children: [
                _buildProfileHeader(userPreferences),
                SizedBox(height: 24),
                Container(
                  margin: EdgeInsets.symmetric(horizontal: 16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 15,
                        offset: Offset(0, 5),
                      ),
                    ],
                  ),
                  child: Padding(
                    padding: EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Personal Information',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w700,
                            color: Colors.black87,
                          ),
                        ),
                        SizedBox(height: 20),
                        CustomTextField(
                          label: "Full Name",
                          icon: Icons.person_outline,
                          initialValue: userPreferences.appUser.name,
                        ),
                        SizedBox(height: 16),
                        CustomTextField(
                          label: "Email Address",
                          icon: Icons.email_outlined,
                          initialValue: userPreferences.appUser.email,
                        ),
                        SizedBox(height: 16),
                        CustomTextField(
                          label: "Phone Number",
                          icon: Icons.phone_outlined,
                          initialValue: userPreferences.appUser.phone,
                        ),
                        SizedBox(height: 24),
                        Container(
                          width: double.infinity,
                          height: 50,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppConstants.primaryOrange,
                              foregroundColor: Colors.white,
                              elevation: 0,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15),
                              ),
                            ),
                            onPressed: () {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(
                                      'Profile update functionality coming soon'),
                                  backgroundColor: AppConstants.primaryOrange,
                                ),
                              );
                            },
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.edit, size: 20),
                                SizedBox(width: 8),
                                Text(
                                  "Update Profile",
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 24),

                // Account Actions
                Container(
                  margin: EdgeInsets.symmetric(horizontal: 16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 15,
                        offset: Offset(0, 5),
                      ),
                    ],
                  ),
                  child: Padding(
                    padding: EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Account',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w700,
                            color: Colors.black87,
                          ),
                        ),
                        SizedBox(height: 16),
                        _buildActionTile(
                          icon: Icons.security,
                          title: 'Change Password',
                          subtitle: 'Update your account password',
                          onTap: () {
                            // Handle password change
                          },
                        ),
                        _buildActionTile(
                          icon: Icons.notifications_outlined,
                          title: 'Notifications',
                          subtitle: 'Manage your notification preferences',
                          onTap: () {
                            // Handle notifications settings
                          },
                        ),
                        _buildActionTile(
                          icon: Icons.help_outline,
                          title: 'Help & Support',
                          subtitle: 'Get help or contact support',
                          onTap: () {
                            // Handle help/support
                          },
                        ),
                        _buildActionTile(
                          icon: Icons.logout,
                          title: 'Sign Out',
                          subtitle: 'Sign out of your account',
                          onTap: () => _showLogoutDialog(context),
                          isDestructive: true,
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 32),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildActionTile({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
    bool isDestructive = false,
  }) {
    return Container(
      margin: EdgeInsets.only(bottom: 8),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: EdgeInsets.all(12),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.grey.withOpacity(0.1)),
          ),
          child: Row(
            children: [
              Container(
                padding: EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: isDestructive
                      ? Colors.red.withOpacity(0.1)
                      : AppConstants.colorPrimary.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  icon,
                  color: isDestructive ? Colors.red : AppConstants.colorPrimary,
                  size: 20,
                ),
              ),
              SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                        color: isDestructive ? Colors.red : Colors.black87,
                      ),
                    ),
                    SizedBox(height: 2),
                    Text(
                      subtitle,
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
              ),
              Icon(
                Icons.arrow_forward_ios,
                size: 16,
                color: Colors.grey[400],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          title: Row(
            children: [
              Icon(Icons.logout, color: Colors.red),
              SizedBox(width: 8),
              Text(
                'Sign Out',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          content: Text(
            'Are you sure you want to sign out of your account?',
            style: TextStyle(fontSize: 14),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text(
                'Cancel',
                style: TextStyle(
                  color: Colors.grey[600],
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              onPressed: () {
                Navigator.pop(context);
                Provider.of<UserPreferences>(context, listen: false)
                    .removeUser();
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(
                    builder: (BuildContext context) => MainEntry(),
                  ),
                );
              },
              child: Text(
                'Sign Out',
                style: TextStyle(fontWeight: FontWeight.w600),
              ),
            ),
          ],
        );
      },
    );
  }
}

class CustomTextField extends StatefulWidget {
  const CustomTextField({
    Key? key,
    this.initialValue,
    this.label,
    this.icon,
    this.isEnabled = false,
  }) : super(key: key);

  final String? initialValue;
  final String? label;
  final IconData? icon;
  final bool isEnabled;

  @override
  State<CustomTextField> createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  late TextEditingController _controller;
  bool _isEditing = false;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.initialValue);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: _isEditing
              ? AppConstants.colorPrimary.withOpacity(0.5)
              : Colors.grey.withOpacity(0.2),
          width: 1,
        ),
      ),
      child: TextFormField(
        controller: _controller,
        enabled: widget.isEnabled || _isEditing,
        onTap: () {
          if (!_isEditing && widget.isEnabled) {
            setState(() {
              _isEditing = true;
            });
          }
        },
        onFieldSubmitted: (value) {
          setState(() {
            _isEditing = false;
          });
        },
        onTapOutside: (event) {
          setState(() {
            _isEditing = false;
          });
          FocusScope.of(context).unfocus();
        },
        style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w500,
          color: Colors.black87,
        ),
        decoration: InputDecoration(
          prefixIcon: Container(
            margin: EdgeInsets.only(left: 12, right: 8),
            child: Icon(
              widget.icon,
              color: _isEditing ? AppConstants.colorPrimary : Colors.grey[600],
              size: 20,
            ),
          ),
          suffixIcon: widget.isEnabled
              ? IconButton(
                  icon: Icon(
                    _isEditing ? Icons.check : Icons.edit,
                    color: AppConstants.colorPrimary,
                    size: 18,
                  ),
                  onPressed: () {
                    setState(() {
                      _isEditing = !_isEditing;
                    });
                    if (!_isEditing) {
                      FocusScope.of(context).unfocus();
                    }
                  },
                )
              : null,
          labelText: widget.label,
          labelStyle: TextStyle(
            color: _isEditing ? AppConstants.colorPrimary : Colors.grey[600],
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
          floatingLabelStyle: TextStyle(
            color: AppConstants.colorPrimary,
            fontWeight: FontWeight.w600,
          ),
          border: InputBorder.none,
          contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        ),
      ),
    );
  }
}
