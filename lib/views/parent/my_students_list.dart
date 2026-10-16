import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../common_widgets/error_message.dart';
import '../../enums/operation_status.dart';
import '../../models/parent/my_student_list.dart';
import '../../providers/parent_provider.dart';
import '../../providers/student_provider.dart';
import '../../utils/constants.dart';
import '../../utils/strings.dart';
import 'student_detail_tab_page.dart';

class MyStudentsList extends StatefulWidget {
  @override
  _MyStudentsListState createState() => _MyStudentsListState();
}

class _MyStudentsListState extends State<MyStudentsList> {
  @override
  void initState() {
    super.initState();
    Provider.of<ParentProvider>(context, listen: false).getMyStudents();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50], // Light background like homepage
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Color(0xFFF2C94C), // Yellow theme matching homepage
        title: Text(
          "My Kids",
          style: TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 18,
            color: Colors.white,
          ),
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, color: Colors.white, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Container(
        child: Consumer<ParentProvider>(
          builder: (context, parentProvider, child) {
            if (parentProvider.myStudentLoadingStatus ==
                OperationStatus.Loading) {
              return Center(
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(Color(0xFFF2C94C)),
                ),
              );
            }

            if (parentProvider.myStudentLoadingStatus ==
                OperationStatus.Loaded) {
              if (parentProvider.myStudents.isEmpty) {
                return _buildEmptyState();
              }

              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header section
                  Container(
                    padding: EdgeInsets.fromLTRB(20, 20, 20, 10),
                    child: Text(
                      '${parentProvider.myStudents.length} Students',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey[600],
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  // Students list
                  Expanded(
                    child: ListView.builder(
                      padding: EdgeInsets.symmetric(horizontal: 16),
                      itemCount: parentProvider.myStudents.length,
                      itemBuilder: (BuildContext context, int index) {
                        Student _student = parentProvider.myStudents[index];
                        return _buildStudentCard(
                            _student, context, parentProvider);
                      },
                    ),
                  ),
                ],
              );
            }

            return ErrorMessage(errorMessage: AppStrings.ErrorMessage);
          },
        ),
      ),
    );
  }

  Widget _buildStudentCard(
      Student student, BuildContext context, ParentProvider parentProvider) {
    return Container(
      margin: EdgeInsets.only(bottom: 12),
      child: Material(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        elevation: 2,
        shadowColor: Colors.black.withOpacity(0.1),
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: () {
            Provider.of<StudentProvider>(context, listen: false)
                .setSelected(student);
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => MyStudentDetails(student: student),
              ),
            );
          },
          child: Container(
            padding: EdgeInsets.all(16),
            child: Row(
              children: [
                // Student Avatar
                Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        AppConstants.colorPrimary,
                        AppConstants.colorPrimaryDark,
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(15),
                    boxShadow: [
                      BoxShadow(
                        color: AppConstants.colorPrimary.withOpacity(0.3),
                        blurRadius: 8,
                        offset: Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Center(
                    child: Text(
                      student.name!.length >= 2
                          ? student.name!.substring(0, 2).toUpperCase()
                          : student.name!.substring(0, 1).toUpperCase(),
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 16),
                // Student Info
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        student.name!,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Colors.black87,
                        ),
                      ),
                      SizedBox(height: 4),
                      Container(
                        padding:
                            EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                        decoration: BoxDecoration(
                          color: Color(0xFFF2C94C).withOpacity(0.1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          'ID: ${student.adminNo!}',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                            color: Color(0xFFE6B800),
                          ),
                        ),
                      ),
                      SizedBox(height: 6),
                      Row(
                        children: [
                          Icon(
                            Icons.school_outlined,
                            size: 14,
                            color: Colors.grey[600],
                          ),
                          SizedBox(width: 4),
                          Expanded(
                            child: Text(
                              _getSchoolName(
                                  parentProvider, student.schoolId!.toString()),
                              style: TextStyle(
                                fontSize: 13,
                                color: Colors.grey[600],
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                // Arrow icon
                Container(
                  padding: EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Color(0xFFF2C94C).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    Icons.arrow_forward_ios,
                    size: 14,
                    color: Color(0xFFE6B800),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Container(
        padding: EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                color: Color(0xFFF2C94C).withOpacity(0.1),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Icon(
                Icons.person_add_outlined,
                size: 48,
                color: Color(0xFFF2C94C),
              ),
            ),
            SizedBox(height: 24),
            Text(
              "No Students Added Yet",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: Colors.black87,
              ),
            ),
            SizedBox(height: 8),
            Text(
              "You haven't added any students to your account. Contact your school to add students.",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[600],
                height: 1.4,
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _getSchoolName(ParentProvider parentProvider, String? schoolId) {
    try {
      return parentProvider.parentSchools
              .firstWhere((element) => element.id == schoolId)
              .name ??
          'Unknown School';
    } catch (e) {
      return 'Unknown School';
    }
  }
}
