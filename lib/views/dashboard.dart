import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/route_manager.dart';
import 'package:provider/provider.dart';
import 'package:school_tracker/enums/operation_status.dart';
import 'package:school_tracker/views/student_collection.dart';
import 'package:school_tracker/views/student_dispatch.dart';
import '../common_widgets/drawer.dart';
import '../models/app_user.dart';
import '../models/driver_trip.dart';
import '../providers/driver_provider.dart';
import '../providers/location_provider.dart';
import '../providers/parent_provider.dart';
import '../utils/constants.dart';
import '../utils/user_shared_pref.dart';
import 'my_app_bar.dart';
import 'quick_access_menu.dart';

class DashBoardPage extends StatefulWidget {
  late final AppUser user;

  @override
  _DashboardPage createState() => _DashboardPage();
}

class _DashboardPage extends State<DashBoardPage> {
  late final AppUser user;
  late final LocationProvider _locationProvider;

  late DriverProvider _driverProvider;
  late Trip openTrip;
  late ParentProvider _parentProvider;

  @override
  void initState() {
    super.initState();
    _parentProvider = Provider.of<ParentProvider>(context, listen: false);
    _driverProvider = Provider.of<DriverProvider>(context, listen: false);
    _locationProvider = LocationProvider();

    user = Provider.of<UserPreferences>(context, listen: false).appUser;
    List<Trip> trips = _driverProvider.driverTrips;
    openTrip = trips.firstWhere((trip) => trip.endAt == null, orElse: () {
      return Trip();
    });

    if (openTrip.id != null && user.permissions!.app!.createTrips == true) {
      WidgetsBinding.instance.addPostFrameCallback((_) async {
        await _locationProvider.updateTripVehicleLocation(
            vehicleId: openTrip.vehicleId!);
        Get.to(StudentDispatchPage(trip: openTrip));
      });
    }

    if (_parentProvider.myActiveStudent.length > 0) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Get.to(StudentCollection());
      });
    }
  }

  @override
  didChangeDependencies() {
    super.didChangeDependencies();
    print("did change dependencies ");
    _driverProvider = Provider.of<DriverProvider>(context, listen: true);
    List<Trip> trips = _driverProvider.driverTrips;
    openTrip = trips.firstWhere((trip) => trip.endAt == null, orElse: () {
      return Trip();
    });
    if (openTrip.driverId == user.userId) {
      _locationProvider.updateTripVehicleLocation(
          vehicleId: openTrip.vehicleId!);
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        final shouldPop = await showDialog<bool>(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: Text('Warning'),
              content: Text("Do you really want to exit"),
              actions: <Widget>[
                TextButton(
                  onPressed: () {
                    Navigator.pop(context, true);
                  },
                  child: Text("Yes"),
                ),
                TextButton(
                  onPressed: () => Navigator.pop(context, false),
                  child: Text("No"),
                ),
              ],
            );
          },
        );
        return shouldPop!;
      },
      child: Scaffold(
        backgroundColor: Colors.grey[100],
        appBar: AppBar(
          backgroundColor: AppConstants.colorPrimary,
          title: MyAppBar(),
          elevation: 0.0,
        ),
        drawer: AppDrawer(),
        body: SingleChildScrollView(
          child: Container(
            child: HomePage(user: user),
          ),
        ),
      ),
    );
  }
}

class HomePage extends StatelessWidget {
  final AppUser? user;
  const HomePage({
    Key? key,
    this.user,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Column(
      children: [
        Stack(
          children: [
            Container(height: size.height * 0.5),
            UserDetails(),
            Positioned(
              top: size.height * 0.125,
              right: size.width * 0.08,
              left: size.width * 0.08,
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 20),
                child: Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(30),
                      color: AppConstants.white),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 20),
                    child: QuickAccessMenu(),
                  ),
                ),
              ),
            ),
          ],
        ),
        SingleChildScrollView(
          child: Column(
            children: [
              user!.permissions!.app!.createTrips != true
                  ? ParentSchools()
                  : Consumer<UserPreferences>(
                      builder: (context, userPreference, child) {
                        return userPreference
                                    .appUser.permissions!.app!.createTrips ==
                                true
                            ? DriverSchool()
                            : SizedBox();
                      },
                    )
            ],
          ),
        )
      ],
    );
  }
}

class UserDetails extends StatelessWidget {
  const UserDetails({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Consumer<UserPreferences>(builder: (context, userPreference, child) {
      return Container(
        decoration: BoxDecoration(
          color: AppConstants.colorPrimary,
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(45),
            bottomRight: Radius.circular(45),
          ),
        ),
        height: size.height * 0.31,
        width: double.infinity,
        child: Padding(
          padding: const EdgeInsets.only(
            left: 20.0,
            right: 20.0,
          ),
          child:
              Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
            Container(
              child: Center(
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        'Hi, ${userPreference.appUser.name!.toUpperCase()}',
                        style: TextStyle(
                            fontSize: 20.0,
                            fontWeight: FontWeight.w600,
                            fontFamily: 'Poppins',
                            color: Colors.black87,
                            letterSpacing: 0.35),
                      ),
                      SizedBox(height: 2.0),
                      Text(
                        'Welcome back',
                        style: TextStyle(
                          fontSize: 18,
                        ),
                      ),
                    ]),
              ),
            ),
          ]),
        ),
      );
    });
  }
}

class DriverSchool extends StatefulWidget {
  @override
  _DriverSchools createState() => _DriverSchools();
}

class _DriverSchools extends State<DriverSchool> {
  late DriverProvider provider;

  void initState() {
    provider = Provider.of<DriverProvider>(context, listen: false);
    provider.getAttachedSchool();
    super.initState();
  }

  Widget _schoolInformation(school) {
    return Container(
      margin: EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: Colors.grey[200]!,
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.08),
            spreadRadius: 0,
            blurRadius: 8,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: () {
            // Add your navigation logic here
            print("Tapped on ${school.name}");
          },
          child: Padding(
            padding: EdgeInsets.all(16),
            child: Row(
              children: [
                // School Avatar
                Container(
                  width: 56,
                  height: 56,
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
                      school?.name?.substring(0, 2)?.toUpperCase() ?? "SC",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ),
                ),

                SizedBox(width: 16),

                // School Information
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        school?.name ?? "Unknown School",
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 16,
                          color: Colors.grey[900],
                          letterSpacing: 0.2,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      SizedBox(height: 6),
                      Row(
                        children: [
                          Icon(
                            Icons.location_on_outlined,
                            size: 16,
                            color: Colors.grey[600],
                          ),
                          SizedBox(width: 4),
                          Expanded(
                            child: Text(
                              school?.address ?? "No address provided",
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.grey[600],
                                letterSpacing: 0.1,
                              ),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                // Arrow Icon
                Container(
                  padding: EdgeInsets.all(8),
                  child: Icon(
                    Icons.arrow_forward_ios_rounded,
                    size: 16,
                    color: Colors.grey[400],
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
              padding: EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: Colors.grey[100],
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.school_outlined,
                size: 48,
                color: Colors.grey[400],
              ),
            ),
            SizedBox(height: 16),
            Text(
              "No School Attached",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: Colors.grey[700],
              ),
            ),
            SizedBox(height: 8),
            Text(
              "Your assigned school will appear here",
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[500],
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLoadingState() {
    return Center(
      child: Container(
        padding: EdgeInsets.all(32),
        child: Column(
          children: [
            CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(
                AppConstants.colorPrimaryDark,
              ),
            ),
            SizedBox(height: 16),
            Text(
              "Loading school...",
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey[600],
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey[50],
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: EdgeInsets.symmetric(horizontal: 4, vertical: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Attached School",
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.grey[900],
                          letterSpacing: 0.2,
                        ),
                      ),
                      SizedBox(height: 4),
                      Consumer<DriverProvider>(
                        builder: (context, driverProvider, child) {
                          return Text(
                            driverProvider.school.id != null
                                ? "1 school"
                                : "0 schools",
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey[600],
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                  Consumer<DriverProvider>(
                      builder: (context, driverProvider, child) {
                    return IconButton(
                      onPressed: () {
                        driverProvider.getAttachedSchool();
                      },
                      icon: Icon(
                        Icons.refresh_rounded,
                        color: AppConstants.colorPrimaryDark,
                      ),
                      tooltip: "Refresh",
                    );
                  })
                ],
              ),
            ),
            Consumer<DriverProvider>(
              builder: (context, driverProvider, child) {
                if (driverProvider.school.id == null) {
                  return _buildEmptyState();
                }

                if (driverProvider.fetchingSchoolStatus ==
                    OperationStatus.Loading) {
                  return _buildLoadingState();
                }

                return RefreshIndicator(
                  onRefresh: () async {
                    await driverProvider.getAttachedSchool();
                  },
                  color: AppConstants.colorPrimaryDark,
                  child: ListView.builder(
                    shrinkWrap: true,
                    physics: AlwaysScrollableScrollPhysics(),
                    padding: EdgeInsets.only(bottom: 20),
                    itemCount: 1,
                    itemBuilder: (context, index) {
                      return AnimatedContainer(
                        duration: Duration(milliseconds: 300),
                        curve: Curves.easeInOut,
                        child: _schoolInformation(driverProvider.school),
                      );
                    },
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

class ParentSchools extends StatefulWidget {
  @override
  _ParentSchools createState() => _ParentSchools();
}

class _ParentSchools extends State<ParentSchools> {
  Widget _schoolInformation(school) {
    return Container(
      margin: EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: Colors.grey[200]!,
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.08),
            spreadRadius: 0,
            blurRadius: 8,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: () {
            // Add your navigation logic here
            print("Tapped on ${school.name}");
          },
          child: Padding(
            padding: EdgeInsets.all(16),
            child: Row(
              children: [
                // School Avatar
                Container(
                  width: 56,
                  height: 56,
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
                      school?.name?.substring(0, 2)?.toUpperCase() ?? "SC",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ),
                ),

                SizedBox(width: 16),

                // School Information
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        school?.name ?? "Unknown School",
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 16,
                          color: Colors.grey[900],
                          letterSpacing: 0.2,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      SizedBox(height: 6),
                      Row(
                        children: [
                          Icon(
                            Icons.location_on_outlined,
                            size: 16,
                            color: Colors.grey[600],
                          ),
                          SizedBox(width: 4),
                          Expanded(
                            child: Text(
                              school?.address ?? "No address provided",
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.grey[600],
                                letterSpacing: 0.1,
                              ),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                // Arrow Icon
                Container(
                  padding: EdgeInsets.all(8),
                  child: Icon(
                    Icons.arrow_forward_ios_rounded,
                    size: 16,
                    color: Colors.grey[400],
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
              padding: EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: Colors.grey[100],
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.school_outlined,
                size: 48,
                color: Colors.grey[400],
              ),
            ),
            SizedBox(height: 16),
            Text(
              "No Schools Found",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: Colors.grey[700],
              ),
            ),
            SizedBox(height: 8),
            Text(
              "Schools associated with your account will appear here",
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[500],
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLoadingState() {
    return Center(
      child: Container(
        padding: EdgeInsets.all(32),
        child: Column(
          children: [
            CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(
                AppConstants.colorPrimaryDark,
              ),
            ),
            SizedBox(height: 16),
            Text(
              "Loading schools...",
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey[600],
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey[50],
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: EdgeInsets.symmetric(horizontal: 4, vertical: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "My Schools",
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.grey[900],
                          letterSpacing: 0.2,
                        ),
                      ),
                      SizedBox(height: 4),
                      Consumer<ParentProvider>(
                        builder: (context, parentProvider, child) {
                          return Text(
                            "${parentProvider.parentSchools.length} school${parentProvider.parentSchools.length != 1 ? 's' : ''}",
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey[600],
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                  // Optional: Add refresh button
                  Consumer<ParentProvider>(
                      builder: (context, parentProvider, child) {
                    return IconButton(
                      onPressed: () {
                        parentProvider.getParentSchools();
                      },
                      icon: Icon(
                        Icons.refresh_rounded,
                        color: AppConstants.colorPrimaryDark,
                      ),
                      tooltip: "Refresh",
                    );
                  })
                ],
              ),
            ),

            // Schools List
            Consumer<ParentProvider>(
              builder: (context, parentProvider, child) {
                if (parentProvider.parentSchools.isEmpty) {
                  return _buildEmptyState();
                }
                if (parentProvider.gettingSchools == OperationStatus.Loading) {
                  return _buildLoadingState();
                }

                return RefreshIndicator(
                  onRefresh: () async {
                    await Future.delayed(Duration(seconds: 1));
                  },
                  color: AppConstants.colorPrimaryDark,
                  child: ListView.builder(
                    shrinkWrap: true,
                    physics: AlwaysScrollableScrollPhysics(),
                    padding: EdgeInsets.only(bottom: 20),
                    itemCount: parentProvider.parentSchools.length,
                    itemBuilder: (context, index) {
                      return AnimatedContainer(
                        duration: Duration(milliseconds: 300),
                        curve: Curves.easeInOut,
                        child: _schoolInformation(
                          parentProvider.parentSchools[index],
                        ),
                      );
                    },
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
