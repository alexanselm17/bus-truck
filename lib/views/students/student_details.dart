import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:school_tracker/providers/parent_provider.dart';
import '../../common_widgets/loading.dart';
import '../../common_widgets/response_dialog.dart';
import '../../common_widgets/roundedTrackerBtn.dart';
import '../../common_widgets/vertical_spacing.dart';
import '../../enums/operation_status.dart';
import '../../models/app_user.dart';
import '../../models/parent/my_student_list.dart';
import '../../providers/location_provider.dart';
import '../../providers/student_provider.dart';
import '../../utils/constants.dart';
import '../../utils/user_shared_pref.dart';
import '../payments/payment_page.dart';
import 'student_location_pending.dart';

class StudentDetails extends StatefulWidget {
  final Student? student;

  StudentDetails({Key? key, this.student}) : super(key: key);

  @override
  _StudentDetails createState() => _StudentDetails();
}

class _StudentDetails extends State<StudentDetails> {
  late AppUser user;

  // Orange color scheme
  static const Color primaryOrange = Color(0xFFFF6B35);
  static const Color lightOrange = Color(0xFFFFF4F1);
  static const Color darkGray = Color(0xFF2D3748);
  static const Color lightGray = Color(0xFFF7FAFC);

  @override
  void initState() {
    user = Provider.of<UserPreferences>(context, listen: false).appUser;
    Provider.of<StudentProvider>(context, listen: false)
        .getLocationPendingApproval();
    super.initState();
  }

  Widget _buildInfoCard(String title, String content, IconData icon) {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: lightOrange,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(icon, color: primaryOrange, size: 16),
              ),
              SizedBox(width: 12),
              Text(
                title,
                style: GoogleFonts.inter(
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  color: Colors.grey[600],
                ),
              ),
            ],
          ),
          SizedBox(height: 12),
          Text(
            content,
            style: GoogleFonts.inter(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: darkGray,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  Widget _buildLocationCard() {
    return Container(
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 15,
            offset: Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: lightOrange,
                  borderRadius: BorderRadius.circular(10),
                ),
                child:
                    Icon(Icons.home_outlined, color: primaryOrange, size: 20),
              ),
              SizedBox(width: 12),
              Text(
                'Home Location',
                style: GoogleFonts.inter(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: darkGray,
                ),
              ),
            ],
          ),
          SizedBox(height: 16),
          Consumer<StudentProvider>(builder: (context, studentProvider, child) {
            return Column(
              children: [
                _buildLocationRow('Address',
                    studentProvider.selected.locationName ?? 'Not set'),
                SizedBox(height: 8),
                _buildLocationRow('Latitude',
                    studentProvider.selected.latitude?.toString() ?? 'Not set'),
                SizedBox(height: 8),
                _buildLocationRow(
                    'Longitude',
                    studentProvider.selected.longitude?.toString() ??
                        'Not set'),
              ],
            );
          }),
        ],
      ),
    );
  }

  Widget _buildLocationRow(String label, String value) {
    return Row(
      children: [
        Container(
          width: 80,
          child: Text(
            '$label:',
            style: GoogleFonts.inter(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: Colors.grey[600],
            ),
          ),
        ),
        Expanded(
          child: Text(
            value,
            style: GoogleFonts.inter(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: darkGray,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildAppBar() {
    return Container(
      decoration: BoxDecoration(
        color: primaryOrange,
      ),
      child: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Row(
            children: [
              GestureDetector(
                onTap: () => Navigator.of(context).pop(),
                child: Container(
                  padding: EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(
                    Icons.arrow_back_ios_new,
                    color: Colors.white,
                    size: 20,
                  ),
                ),
              ),
              Expanded(
                child: Center(
                  child: Text(
                    'Student Details',
                    style: GoogleFonts.inter(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => StudentHomeLocation(),
                    ),
                  );
                },
                child: Container(
                  padding: EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(
                    Icons.edit_location,
                    color: Colors.white,
                    size: 20,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStudentHeader() {
    return Consumer<StudentProvider>(
      builder: (context, studentProvider, child) {
        return Container(
          margin: EdgeInsets.only(
            top: 10,
          ),
          decoration: BoxDecoration(
            color: Colors.white,
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
                    Container(
                      width: 80,
                      height: 80,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(20),
                        child: Image.asset(
                          'assets/images/studentdetail.png',
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    SizedBox(width: 20),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            studentProvider.selected.name ?? 'Student Name',
                            style: GoogleFonts.inter(
                              color: Colors.black87,
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 0.5,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                          SizedBox(height: 8),
                          Container(
                            padding: EdgeInsets.symmetric(
                                horizontal: 12, vertical: 6),
                            decoration: BoxDecoration(
                              color: primaryOrange.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              ' ${studentProvider.selected.adminNo ?? 'N/A'}',
                              style: GoogleFonts.inter(
                                color: Color(0xFFE55A31),
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
                    color: primaryOrange.withOpacity(0.05),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: _buildStatItem(
                            Icons.school_outlined,
                            'Status',
                            studentProvider.selected.subscribed == 1
                                ? 'Active'
                                : 'Inactive'),
                      ),
                      Container(
                        width: 1,
                        height: 30,
                        color: Colors.grey[300],
                      ),
                      Expanded(
                        child: _buildStatItem(
                            Icons.verified_user_outlined,
                            'Guardians',
                            studentProvider.selected.guardians!.length
                                .toString()),
                      ),
                      Container(
                        width: 1,
                        height: 30,
                        color: Colors.grey[300],
                      ),
                      Expanded(
                        child:
                            _buildStatItem(Icons.access_time, 'Joined', '2024'),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildStatItem(IconData icon, String label, String value) {
    return Column(
      children: [
        Icon(
          icon,
          color: primaryOrange,
          size: 20,
        ),
        SizedBox(height: 4),
        Text(
          label,
          style: GoogleFonts.inter(
            fontSize: 11,
            color: Colors.grey[600],
            fontWeight: FontWeight.w500,
          ),
        ),
        Text(
          value,
          style: GoogleFonts.inter(
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
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => StudentHomeLocation(),
            ),
          );
        },
        backgroundColor: AppConstants.primaryOrange,
        icon: Icon(Icons.edit_location, color: Colors.white),
        label: Text(
          'Change Location',
          style: GoogleFonts.inter(
            color: Colors.white,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      backgroundColor: Colors.white,
      body: Consumer2<StudentProvider, ParentProvider>(
        builder: (context, studentProvider, parentProvider, child) {
          return Column(children: [
            Expanded(
                child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Column(
                  children: [
                    _buildStudentHeader(),
                    if (studentProvider.selected.subscribed != 1 &&
                        studentProvider.selected.parentId == user.userId)
                      Container(
                        width: double.infinity,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: primaryOrange,
                            padding: EdgeInsets.symmetric(vertical: 12),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            elevation: 0,
                          ),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => PaymentPage(
                                  student: studentProvider.selected,
                                ),
                              ),
                            );
                          },
                          child: Text(
                            "Make Payment",
                            style: GoogleFonts.inter(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),

                    SizedBox(height: 20),

                    // Info Cards
                    Row(
                      children: [
                        Expanded(
                          child: _buildInfoCard(
                            'School',
                            parentProvider.parentSchools
                                .firstWhere((element) =>
                                    element.id ==
                                    studentProvider.selected.schoolId)
                                .name!,
                            Icons.school_outlined,
                          ),
                        ),
                        SizedBox(width: 16),
                        Expanded(
                          child: _buildInfoCard(
                            'Subscription',
                            '12 weeks to expiry',
                            Icons.schedule_outlined,
                          ),
                        ),
                      ],
                    ),

                    SizedBox(height: 20),

                    _buildLocationCard(),

                    SizedBox(height: 20),
                    StudentLocationPendingApproval(),

                    SizedBox(height: 80),
                  ],
                ),
              ),
            )),
          ]);
        },
      ),
    );
  }
}

class StudentHomeLocation extends StatefulWidget {
  _StudentHomeLocation createState() => _StudentHomeLocation();
}

class _StudentHomeLocation extends State<StudentHomeLocation> {
  Completer<GoogleMapController> _controller = Completer();
  double mapBottomPadding = 0;
  late GoogleMapController mapController;
  late CameraPosition _kGooglePlex;
  late BitmapDescriptor currentPinLocationIcon;

  late LocationProvider _locationProvider;
  String _addressName = '';
  final TextEditingController addressInput = TextEditingController();
  late AppUser user;

  void initState() {
    setCurrentPinIcon();
    _locationProvider = Provider.of<LocationProvider>(context, listen: false);
    _kGooglePlex = CameraPosition(
      target: LatLng(_locationProvider.userCurrentLocation.latitude,
          _locationProvider.userCurrentLocation.longitude),
      zoom: 18.4746,
    );
    _locationProvider = Provider.of<LocationProvider>(context, listen: false);
    user = Provider.of<UserPreferences>(context, listen: false).appUser;
    super.initState();
  }

  void setCurrentPinIcon() async {
    currentPinLocationIcon = await BitmapDescriptor.fromAssetImage(
        ImageConfiguration(devicePixelRatio: 2.5),
        'assets/images/currentLocation_icon.png');
  }

  void _handleChangeLocation(context) async {
    if (_addressName.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Please enter address"),
          backgroundColor: Colors.red,
          behavior: SnackBarBehavior.floating,
        ),
      );
      return;
    }
    Student student =
        Provider.of<StudentProvider>(context, listen: false).selected;
    bool res = await Provider.of<StudentProvider>(context, listen: false)
        .updateStudentLocation(
      student: student,
      latitude: _locationProvider.userCurrentLocation.latitude,
      longitude: _locationProvider.userCurrentLocation.longitude,
      locationName: _addressName,
      userId: user.userId,
    );
    res
        ? ResponseDialog(context: context, response: res)
        : ResponseDialog(context: context, response: res, success: false);
  }

  Widget _buildLocationField() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20),
      child: TextFormField(
        decoration: InputDecoration(
          filled: true,
          fillColor: Colors.white,
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: AppConstants.primaryOrange, width: 2),
            borderRadius: BorderRadius.circular(12),
          ),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.grey[300]!, width: 1),
            borderRadius: BorderRadius.circular(12),
          ),
          labelText: 'Location Name',
          labelStyle: GoogleFonts.inter(color: Colors.grey[600]),
          prefixIcon: Icon(Icons.location_on_outlined,
              color: AppConstants.primaryOrange),
        ),
        controller: addressInput,
        style: GoogleFonts.inter(),
        onChanged: (value) {
          _addressName = value;
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: AppConstants.colorPrimary,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: Icon(Icons.arrow_back_ios, color: Colors.white),
        ),
        title: Text(
          'Change Home Location',
          style: GoogleFonts.inter(
            color: Colors.white,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Column(
          children: [
            // Map
            Container(
              height: size.height * 0.4, // Reduced from 0.5 to leave more space
              child: GoogleMap(
                initialCameraPosition: _kGooglePlex,
                mapType: MapType.normal,
                myLocationButtonEnabled: true,
                zoomControlsEnabled: true,
                myLocationEnabled: true,
                onMapCreated: (GoogleMapController controller) {
                  _controller.complete(controller);
                  mapController = controller;
                },
              ),
            ),

            Expanded(
              child: SingleChildScrollView(
                // Added scrolling capability
                child: Container(
                  width: double.infinity,
                  padding: EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.grey[50],
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(25),
                      topRight: Radius.circular(25),
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize:
                        MainAxisSize.min, // Important for SingleChildScrollView
                    children: [
                      Text(
                        'New Location',
                        style: GoogleFonts.inter(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: AppConstants.darkGray,
                        ),
                      ),
                      SizedBox(height: 16),
                      Container(
                        padding: EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Column(
                          children: [
                            Row(
                              children: [
                                Text(
                                  "Latitude: ",
                                  style: GoogleFonts.inter(
                                    fontWeight: FontWeight.w500,
                                    color: Colors.grey[600],
                                  ),
                                ),
                                Flexible(
                                  // Added to prevent overflow
                                  child: Text(
                                    "${_locationProvider.userCurrentLocation.latitude.toStringAsFixed(6)}",
                                    style: GoogleFonts.inter(
                                        fontWeight: FontWeight.w600),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 8),
                            Row(
                              children: [
                                Text(
                                  "Longitude: ",
                                  style: GoogleFonts.inter(
                                    fontWeight: FontWeight.w500,
                                    color: Colors.grey[600],
                                  ),
                                ),
                                Flexible(
                                  // Added to prevent overflow
                                  child: Text(
                                    "${_locationProvider.userCurrentLocation.longitude.toStringAsFixed(6)}",
                                    style: GoogleFonts.inter(
                                        fontWeight: FontWeight.w600),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 20),
                      _buildLocationField(),
                      SizedBox(height: 20), // Added spacing before button
                      Consumer<StudentProvider>(
                        builder: (context, studentProvider, child) {
                          return studentProvider.updateStudentLocationStatus ==
                                  OperationStatus.Loading
                              ? Center(child: Loading())
                              : Container(
                                  width: double.infinity,
                                  child: ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor:
                                          AppConstants.primaryOrange,
                                      padding:
                                          EdgeInsets.symmetric(vertical: 16),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      elevation: 0,
                                    ),
                                    onPressed: () =>
                                        _handleChangeLocation(context),
                                    child: Text(
                                      'Request Location Change',
                                      style: GoogleFonts.inter(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w600,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                );
                        },
                      ),
                      SizedBox(height: 20), // Bottom padding
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
