import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/parent/my_student_list.dart';
import '../../utils/user_shared_pref.dart';
import '../guardians/guardian_details.dart';
import 'student_trip_history_panellist.dart';
import '../students/student_details.dart';
import '../../models/app_user.dart';

class MyStudentDetails extends StatefulWidget {
  final Student? student;
  const MyStudentDetails({
    Key? key,
    @required this.student,
  }) : super(key: key);
  _MyStudentsDetailState createState() => _MyStudentsDetailState();
}

class _MyStudentsDetailState extends State<MyStudentDetails>
    with SingleTickerProviderStateMixin {
  late TabController tabController;
  late AppUser user;

  // Consistent color scheme matching homepage
  static const Color primaryYellow = Color(0xFFF2C94C);
  static const Color darkYellow = Color(0xFFE6B800);
  static const Color lightBackground = Color(0xFFF8FAFC);
  static const Color cardBackground = Colors.white;

  @override
  void initState() {
    user = Provider.of<UserPreferences>(context, listen: false).appUser;

    tabController = TabController(
      length: 3,
      vsync: this,
    );

    super.initState();
  }

  @override
  void dispose() {
    tabController.dispose();
    super.dispose();
  }

  Widget _buildStudentHeader() {
    return Container(
      margin: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: cardBackground,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 20,
            offset: Offset(0, 8),
          ),
        ],
      ),
      child: Container(
        padding: EdgeInsets.all(24),
        child: Column(
          children: [
            Row(
              children: [
                // Student Avatar
                Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [primaryYellow, darkYellow],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: primaryYellow.withOpacity(0.3),
                        blurRadius: 15,
                        offset: Offset(0, 8),
                      ),
                    ],
                  ),
                  child: Center(
                    child: Text(
                      widget.student!.name!
                          .split(' ')
                          .map((name) => name[0])
                          .take(2)
                          .join('')
                          .toUpperCase(),
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1,
                      ),
                    ),
                  ),
                ),

                SizedBox(width: 20),

                // Student Info
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.student!.name!,
                        style: TextStyle(
                          color: Colors.black87,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 0.5,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                      SizedBox(height: 8),
                      Container(
                        padding:
                            EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: primaryYellow.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          'ID: ${widget.student!.adminNo}',
                          style: TextStyle(
                            color: darkYellow,
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),

            SizedBox(height: 20),

            // Quick Stats Row
            Container(
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: primaryYellow.withOpacity(0.05),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: _buildStatItem(
                        Icons.school_outlined, 'Student', 'Active'),
                  ),
                  Container(
                    width: 1,
                    height: 30,
                    color: Colors.grey[300],
                  ),
                  Expanded(
                    child: _buildStatItem(
                        Icons.verified_user_outlined, 'Status', 'Verified'),
                  ),
                  Container(
                    width: 1,
                    height: 30,
                    color: Colors.grey[300],
                  ),
                  Expanded(
                    child: _buildStatItem(Icons.access_time, 'Joined', '2024'),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatItem(IconData icon, String label, String value) {
    return Column(
      children: [
        Icon(
          icon,
          color: primaryYellow,
          size: 20,
        ),
        SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(
            fontSize: 11,
            color: Colors.grey[600],
            fontWeight: FontWeight.w500,
          ),
        ),
        Text(
          value,
          style: TextStyle(
            fontSize: 13,
            color: Colors.black87,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: primaryYellow,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, color: Colors.white, size: 20),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          'Student Profile',
          style: TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        actions: [
          IconButton(
            icon: Container(
              padding: EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.2),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(Icons.refresh, color: Colors.white, size: 18),
            ),
            onPressed: () {
              setState(() {});
            },
          ),
          SizedBox(width: 12),
        ],
      ),
      body: Column(
        children: [
          SizedBox(height: 16),
          Container(
            margin: EdgeInsets.symmetric(horizontal: 16),
            decoration: BoxDecoration(
              color: cardBackground,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 10,
                  offset: Offset(0, 4),
                ),
              ],
            ),
            child: TabBar(
              controller: tabController,
              indicator: BoxDecoration(
                color: primaryYellow,
                borderRadius: BorderRadius.circular(12),
              ),
              indicatorSize: TabBarIndicatorSize.tab,
              indicatorPadding: EdgeInsets.all(4),
              labelPadding: EdgeInsets.zero,
              dividerColor: Colors.transparent,
              overlayColor: WidgetStateProperty.all(Colors.transparent),
              tabs: [
                _buildTab(Icons.person_outline, 'Details'),
                _buildTab(Icons.family_restroom, 'Guardians'),
                _buildTab(Icons.history, 'Trips'),
              ],
              labelColor: Colors.white,
              unselectedLabelColor: Colors.grey[600],
            ),
          ),

          SizedBox(height: 16),

          // Tab Content - Fixed: Removed nested Expanded
          Expanded(
            child: Container(
              margin: EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                color: cardBackground,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 15,
                    offset: Offset(0, 5),
                  ),
                ],
              ),
              child: TabBarView(
                controller: tabController,
                children: [
                  // Student Details Tab
                  Container(
                    padding: EdgeInsets.all(4),
                    child: StudentDetails(),
                  ),

                  // Guardians Tab
                  Container(
                    padding: EdgeInsets.all(4),
                    child: GuardianDetails(),
                  ),

                  // Trip History Tab
                  Container(
                    padding: EdgeInsets.all(4),
                    child: StudentTripHistory(studentId: widget.student!.id!),
                  ),
                ],
              ),
            ),
          ),

          SizedBox(height: 16),
        ],
      ),
    );
  }

  Widget _buildTab(IconData icon, String text) {
    return Container(
      height: 50,
      padding: EdgeInsets.symmetric(horizontal: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 18),
          SizedBox(width: 6),
          Flexible(
            child: Text(
              text,
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
