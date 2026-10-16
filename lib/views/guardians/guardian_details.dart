import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../common_widgets/loading.dart';
import '../../enums/operation_status.dart';
import '../../providers/student_provider.dart';
import '../../utils/constants.dart';
import '../../utils/user_shared_pref.dart';
import '../parent/add_guardian.dart';

class GuardianDetails extends StatefulWidget {
  GuardianDetails({Key? key}) : super(key: key);

  @override
  _GuardianDetailsState createState() => _GuardianDetailsState();
}

class _GuardianDetailsState extends State<GuardianDetails> {
  @override
  void initState() {
    Provider.of<StudentProvider>(context, listen: false).fetchStudentGuardian();
    super.initState();
  }

  Widget _popUpMenu(guardian) => PopupMenuButton<int>(
        itemBuilder: (context) => [
          PopupMenuItem(
            value: 1,
            child: Row(
              children: [
                Icon(
                  guardian.pivot.active == null ||
                          guardian.pivot.active == 'null'
                      ? Icons.check_circle_outline
                      : Icons.pause_circle_outline,
                  color: guardian.pivot.active == null ||
                          guardian.pivot.active == 'null'
                      ? Colors.green
                      : Colors.orange,
                  size: 18,
                ),
                SizedBox(width: 8),
                Text(
                  guardian.pivot.active == null ||
                          guardian.pivot.active == 'null'
                      ? 'Activate'
                      : 'Deactivate',
                  style: TextStyle(
                    color: Colors.black87,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
          PopupMenuItem(
            value: 2,
            child: Row(
              children: [
                Icon(Icons.delete_outline, color: Colors.red, size: 18),
                SizedBox(width: 8),
                Text(
                  "Remove Guardian",
                  style: TextStyle(
                    color: Colors.red,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ],
        elevation: 8,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        icon: Container(
          padding: EdgeInsets.all(4),
          decoration: BoxDecoration(
            color: Colors.grey[100],
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(
            Icons.more_vert_rounded,
            color: Colors.grey[700],
            size: 20,
          ),
        ),
        onSelected: (value) async {
          if (value == 2) {
            // Show confirmation dialog before deleting
            bool confirm =
                await _showDeleteConfirmation(context, guardian.name);
            if (confirm) {
              Provider.of<StudentProvider>(context, listen: false)
                  .removeGuardian(guardian.id);
            }
          }
          if (value == 1) {
            Provider.of<StudentProvider>(context, listen: false)
                .toggleStatus(guardian.id);
          }
        },
      );

  Future<bool> _showDeleteConfirmation(
      BuildContext context, String guardianName) async {
    return await showDialog<bool>(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16)),
              title: Row(
                children: [
                  Icon(Icons.warning_amber_rounded,
                      color: Colors.orange, size: 24),
                  SizedBox(width: 8),
                  Text('Confirm Removal', style: TextStyle(fontSize: 18)),
                ],
              ),
              content: Text(
                'Are you sure you want to remove $guardianName as a guardian? This action cannot be undone.',
                style: TextStyle(fontSize: 16),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(false),
                  child:
                      Text('Cancel', style: TextStyle(color: Colors.grey[600])),
                ),
                ElevatedButton(
                  onPressed: () => Navigator.of(context).pop(true),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8)),
                  ),
                  child: Text('Remove', style: TextStyle(color: Colors.white)),
                ),
              ],
            );
          },
        ) ??
        false;
  }

  Widget _getRelationIcon(String relation) {
    switch (relation.toLowerCase()) {
      case 'mother':
        return Icon(Icons.woman, color: Colors.pink[300], size: 16);
      case 'father':
        return Icon(Icons.man, color: Colors.blue[300], size: 16);
      case 'guardian':
      case 'uncle':
      case 'aunt':
        return Icon(Icons.people, color: Colors.purple[300], size: 16);
      default:
        return Icon(Icons.person, color: Colors.grey[500], size: 16);
    }
  }

  Widget _showGuardians(parentProvider, guardian) {
    bool isActive = guardian.pivot.active == 1;

    return AnimatedContainer(
      duration: Duration(milliseconds: 300),
      margin: EdgeInsets.symmetric(vertical: 6),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 10,
            offset: Offset(0, 2),
          ),
        ],
        border: Border.all(
          color: isActive
              ? AppConstants.colorPrimaryDark.withOpacity(0.3)
              : Colors.grey[200]!,
          width: isActive ? 2 : 1,
        ),
      ),
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Row(
          children: [
            Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: LinearGradient(
                  colors: isActive
                      ? [
                          AppConstants.colorPrimary,
                          AppConstants.colorPrimaryDark,
                        ]
                      : [Colors.grey[400]!, Colors.grey[500]!],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                boxShadow: [
                  BoxShadow(
                    color: (isActive
                            ? AppConstants.colorPrimary
                            : Colors.grey[400]!)
                        .withOpacity(0.3),
                    blurRadius: 8,
                    offset: Offset(0, 4),
                  ),
                ],
              ),
              child: CircleAvatar(
                backgroundColor: Colors.transparent,
                radius: 28,
                child: Text(
                  guardian.name
                      .split(' ')
                      .map((name) => name[0])
                      .take(2)
                      .join('')
                      .toUpperCase(),
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),

            SizedBox(width: 16),

            // Guardian info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Name and relation row
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          guardian.name,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 17,
                            color: Colors.black87,
                            letterSpacing: 0.3,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),

                  SizedBox(height: 4),

                  // Relation chip
                  Row(
                    children: [
                      _getRelationIcon(guardian.pivot.relation),
                      SizedBox(width: 6),
                      Container(
                        padding:
                            EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: AppConstants.colorPrimary.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: AppConstants.colorPrimary.withOpacity(0.3),
                            width: 1,
                          ),
                        ),
                        child: Text(
                          guardian.pivot.relation,
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: AppConstants.colorPrimaryDark,
                          ),
                        ),
                      ),
                      SizedBox(width: 8),
                      // Status badge
                      Container(
                        padding:
                            EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: isActive ? Colors.green[50] : Colors.red[50],
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: isActive
                                ? Colors.green[200]!
                                : Colors.red[200]!,
                            width: 1,
                          ),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Container(
                              width: 6,
                              height: 6,
                              decoration: BoxDecoration(
                                color: isActive ? Colors.green : Colors.red,
                                shape: BoxShape.circle,
                              ),
                            ),
                            SizedBox(width: 6),
                            Text(
                              isActive ? "Active" : "Inactive",
                              style: TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.w600,
                                color: isActive
                                    ? Colors.green[700]
                                    : Colors.red[700],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),

                  SizedBox(height: 8),

                  // Phone number with icon
                  Row(
                    children: [
                      Icon(
                        Icons.phone_rounded,
                        size: 16,
                        color: Colors.grey[600],
                      ),
                      SizedBox(width: 6),
                      Text(
                        guardian.phone,
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey[700],
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // Menu button
            _popUpMenu(guardian),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Container(
      padding: EdgeInsets.all(32),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.grey[100],
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.people_outline,
              size: 48,
              color: Colors.grey[400],
            ),
          ),
          SizedBox(height: 20),
          Text(
            'No Guardians Added',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.grey[700],
            ),
          ),
          SizedBox(height: 8),
          Text(
            'Add guardians to manage and monitor\nstudent activities',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[600],
              height: 1.4,
            ),
          ),
          SizedBox(height: 24),
          if (context.read<UserPreferences>().appUser.userId ==
              context.read<StudentProvider>().selected.parentId)
            ElevatedButton.icon(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (BuildContext context) => AddGuardian(),
                  ),
                );
              },
              icon: Icon(Icons.add_rounded),
              label: Text('Add First Guardian'),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppConstants.colorPrimary,
                foregroundColor: Colors.white,
                padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 2,
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: EdgeInsets.fromLTRB(20, 16, 20, 20),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: AppConstants.colorPrimary.withOpacity(0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(
              Icons.family_restroom,
              color: AppConstants.colorPrimaryDark,
              size: 24,
            ),
          ),
          SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Guardian Management',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              Text(
                'Manage student guardians and permissions',
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey[600],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      floatingActionButton: Visibility(
        visible: context.read<UserPreferences>().appUser.userId ==
            context.read<StudentProvider>().selected.parentId,
        child: FloatingActionButton.extended(
          backgroundColor: AppConstants.colorPrimaryDark,
          foregroundColor: Colors.white,
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (BuildContext context) => AddGuardian(),
              ),
            );
          },
          icon: Icon(Icons.add_rounded),
          label: Text(
            'Add Guardian',
            style: TextStyle(fontWeight: FontWeight.w600),
          ),
          elevation: 4,
        ),
      ),
      body: Consumer<StudentProvider>(
        builder: (context, parentProvider, child) {
          if (parentProvider.guardianLoadingStatus == OperationStatus.Loading) {
            return Center(
              child: Container(
                height: MediaQuery.of(context).size.height * 0.7,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Loading(),
                    SizedBox(height: 16),
                    Text(
                      'Loading guardians...',
                      style: TextStyle(
                        color: Colors.grey[600],
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
              ),
            );
          }

          if (parentProvider.studentGuardian!.guardians.isEmpty) {
            return SingleChildScrollView(
              child: Column(
                children: [
                  _buildHeader(),
                  Container(
                    height: MediaQuery.of(context).size.height * 0.6,
                    child: _buildEmptyState(),
                  ),
                ],
              ),
            );
          }

          return RefreshIndicator(
            onRefresh: () async {
              await Provider.of<StudentProvider>(context, listen: false)
                  .fetchStudentGuardian();
            },
            color: AppConstants.colorPrimary,
            child: SingleChildScrollView(
              physics: AlwaysScrollableScrollPhysics(),
              child: Column(
                children: [
                  _buildHeader(),

                  Container(
                    margin: EdgeInsets.fromLTRB(20, 16, 20, 8),
                    padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    decoration: BoxDecoration(
                      color: AppConstants.colorPrimary.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: AppConstants.colorPrimary.withOpacity(0.2),
                      ),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          Icons.info_outline,
                          color: AppConstants.colorPrimaryDark,
                          size: 18,
                        ),
                        SizedBox(width: 8),
                        Text(
                          '${parentProvider.studentGuardian!.guardians.length} Guardian${parentProvider.studentGuardian!.guardians.length != 1 ? 's' : ''} Added',
                          style: TextStyle(
                            color: AppConstants.colorPrimaryDark,
                            fontWeight: FontWeight.w600,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Guardians list
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                    child: ListView.builder(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemCount:
                          parentProvider.studentGuardian!.guardians.length,
                      itemBuilder: (context, index) {
                        return _showGuardians(
                          parentProvider,
                          parentProvider.studentGuardian!.guardians[index],
                        );
                      },
                    ),
                  ),

                  // Bottom padding for FAB
                  SizedBox(height: 100),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
