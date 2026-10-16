import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:school_tracker/enums/operation_status.dart';
import 'package:school_tracker/models/driver_trip.dart';

import '../../providers/driver_provider.dart';
import '../../providers/location_provider.dart';
import '../../utils/constants.dart';
import '../../utils/conversion_util.dart';
import '../../utils/user_shared_pref.dart';
import '../student_dispatch.dart';
import 'create_trip.dart';

class DriverTripList extends StatefulWidget {
  const DriverTripList({super.key, this.embedded = false});

  final bool embedded;

  @override
  _DriverTripListState createState() => _DriverTripListState();
}

class _DriverTripListState extends State<DriverTripList>
    with TickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: Duration(milliseconds: 800),
      vsync: this,
    );
    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));

    Provider.of<LocationProvider>(context, listen: false)
        .setUpPositionLocator();
    int userId =
        Provider.of<UserPreferences>(context, listen: false).appUser.userId!;
    DriverProvider _driverProvider =
        Provider.of<DriverProvider>(context, listen: false);
    _driverProvider.getDriverTrips(userId);

    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  Widget _buildStatusBadge(String text, Color color, IconData icon) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withOpacity(0.3), width: 1),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: 14,
            color: color,
          ),
          SizedBox(width: 6),
          Text(
            text,
            style: TextStyle(
              color: color,
              fontSize: 12,
              fontWeight: FontWeight.w600,
              letterSpacing: 0.2,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTripCard(Trip trip, int index) {
    bool isPickUp = trip.type == 1;
    Color statusColor = isPickUp ? Colors.blue[600]! : Colors.green[600]!;
    IconData statusIcon = isPickUp ? Icons.login_rounded : Icons.logout_rounded;

    return AnimatedContainer(
      duration: Duration(milliseconds: 300),
      curve: Curves.easeInOut,
      margin: EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.grey[200]!, width: 1),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.08),
            spreadRadius: 0,
            blurRadius: 12,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(20),
          onTap: () {
            // Navigate to trip details or handle tap
            print("Tapped on trip: ${trip.dispatch!.name}");
          },
          child: Padding(
            padding: EdgeInsets.all(20),
            child: Column(
              children: [
                Row(
                  children: [
                    // Vehicle Avatar
                    Container(
                      width: 64,
                      height: 64,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            AppConstants.colorPrimary.withOpacity(0.8),
                            AppConstants.colorPrimaryDark,
                          ],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.circular(18),
                        boxShadow: [
                          BoxShadow(
                            color: AppConstants.colorPrimary.withOpacity(0.3),
                            blurRadius: 8,
                            offset: Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Center(
                        child: Icon(
                          Icons.directions_bus_rounded,
                          size: 32,
                          color: Colors.white,
                        ),
                      ),
                    ),

                    SizedBox(width: 16),

                    // Trip Information
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: Text(
                                  trip.dispatch?.name ?? "Unknown Dispatch",
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.grey[900],
                                    letterSpacing: 0.2,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              SizedBox(width: 8),
                              _buildStatusBadge(
                                isPickUp ? 'Pick Up' : 'Drop Off',
                                statusColor,
                                statusIcon,
                              ),
                            ],
                          ),
                          SizedBox(height: 8),
                          Row(
                            children: [
                              Icon(
                                Icons.local_shipping_outlined,
                                size: 16,
                                color: Colors.grey[600],
                              ),
                              SizedBox(width: 6),
                              Text(
                                trip.vehicle?.plateNo ?? "No Vehicle",
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.grey[700],
                                  letterSpacing: 0.1,
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
                      decoration: BoxDecoration(
                        color: Colors.grey[50],
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(
                        Icons.arrow_forward_ios_rounded,
                        size: 16,
                        color: Colors.grey[400],
                      ),
                    ),
                  ],
                ),

                SizedBox(height: 16),

                // Trip Timeline
                Container(
                  padding: EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.grey[50],
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Container(
                            width: 8,
                            height: 8,
                            decoration: BoxDecoration(
                              color: Colors.green[500],
                              shape: BoxShape.circle,
                            ),
                          ),
                          SizedBox(width: 12),
                          Icon(
                            Icons.play_circle_outline,
                            size: 18,
                            color: Colors.grey[600],
                          ),
                          SizedBox(width: 8),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Started",
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.grey[600],
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                Text(
                                  ConversionUtils.formatUtc(
                                      trip.startAt.toString()),
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.grey[800],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      if (trip.endAt != null) ...[
                        SizedBox(height: 12),
                        Container(
                          width: 1,
                          height: 24,
                          color: Colors.grey[300],
                          margin: EdgeInsets.only(left: 4),
                        ),
                        SizedBox(height: 12),
                        Row(
                          children: [
                            Container(
                              width: 8,
                              height: 8,
                              decoration: BoxDecoration(
                                color: Colors.red[500],
                                shape: BoxShape.circle,
                              ),
                            ),
                            SizedBox(width: 12),
                            Icon(
                              Icons.stop_circle_outlined,
                              size: 18,
                              color: Colors.grey[600],
                            ),
                            SizedBox(width: 8),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Ended",
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: Colors.grey[600],
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  Text(
                                    ConversionUtils.formatUtc(
                                        trip.endAt.toString()),
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.grey[800],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ] else ...[
                        SizedBox(height: 12),
                        Container(
                          width: 1,
                          height: 24,
                          color: Colors.grey[300],
                          margin: EdgeInsets.only(left: 4),
                        ),
                        SizedBox(height: 12),
                        Row(
                          children: [
                            Container(
                              width: 8,
                              height: 8,
                              decoration: BoxDecoration(
                                color: Colors.orange[500],
                                shape: BoxShape.circle,
                              ),
                            ),
                            SizedBox(width: 12),
                            Icon(
                              Icons.access_time_rounded,
                              size: 18,
                              color: Colors.orange[600],
                            ),
                            SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                "Trip in progress...",
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.orange[700],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ],
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
              padding: EdgeInsets.all(32),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    AppConstants.colorPrimary.withOpacity(0.1),
                    AppConstants.colorPrimaryDark.withOpacity(0.1),
                  ],
                ),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.directions_bus_outlined,
                size: 64,
                color: AppConstants.colorPrimary,
              ),
            ),
            SizedBox(height: 24),
            Text(
              "No Trips Yet",
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.grey[800],
              ),
            ),
            SizedBox(height: 12),
            Text(
              "Start your first trip to begin tracking students and routes",
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey[600],
                height: 1.4,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 32),
            ElevatedButton.icon(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => CreateTrip()),
                );
              },
              icon: Icon(Icons.add_road_rounded),
              label: Text("Create Your First Trip"),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppConstants.colorPrimary,
                foregroundColor: Colors.white,
                padding: EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                elevation: 4,
                shadowColor: AppConstants.colorPrimary.withOpacity(0.3),
              ),
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
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 60,
              height: 60,
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(
                  AppConstants.colorPrimary,
                ),
                strokeWidth: 4,
              ),
            ),
            SizedBox(height: 24),
            Text(
              "Loading your trips...",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w500,
                color: Colors.grey[700],
              ),
            ),
            SizedBox(height: 8),
            Text(
              "Please wait while we fetch your trip history",
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

  @override
  Widget build(BuildContext context) {
    return Consumer<DriverProvider>(
        builder: (BuildContext context, driverProvider, Widget? child) {
      var openTrip = driverProvider.driverTrips
          .firstWhere((trip) => trip.endAt == null, orElse: () => Trip());

      if (openTrip.id != null) {
        return StudentDispatchPage(trip: openTrip);
      }

      if (driverProvider.getDriverTripStatus == OperationStatus.Loading &&
          driverProvider.driverTrips.isEmpty) {
        return Scaffold(
          backgroundColor: AppConstants.background,
          body: _buildLoadingState(),
        );
      }

      if (driverProvider.driverTrips.isEmpty) {
        return CreateTrip();
      }

      return Scaffold(
        backgroundColor: AppConstants.background,
        appBar: widget.embedded
            ? null
            : AppBar(
                backgroundColor: AppConstants.colorPrimary,
                title: Text(
                  "My Trips",
                  style: TextStyle(
                    color: AppConstants.navy,
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                    letterSpacing: 0.2,
                  ),
                ),
                centerTitle: false,
                elevation: 0,
                leading: IconButton(
                  icon: Icon(Icons.arrow_back_ios_rounded,
                      color: AppConstants.navy),
                  onPressed: () => Navigator.pop(context),
                ),
              ),
        body: Column(
          children: [
            if (driverProvider.driverTrips.isEmpty)
              Expanded(child: _buildEmptyState())
            else if (driverProvider.getDriverTripStatus ==
                OperationStatus.Loading) ...[
              Expanded(child: _buildLoadingState())
            ] else ...[
              Expanded(
                child: FadeTransition(
                  opacity: _fadeAnimation,
                  child: RefreshIndicator(
                    onRefresh: () async {
                      int userId =
                          Provider.of<UserPreferences>(context, listen: false)
                              .appUser
                              .userId!;
                      await driverProvider.getDriverTrips(userId);
                    },
                    color: AppConstants.colorPrimary,
                    child: ListView.builder(
                      padding: EdgeInsets.all(20),
                      itemCount: driverProvider.driverTrips.length,
                      itemBuilder: (context, index) {
                        return SlideTransition(
                          position: Tween<Offset>(
                            begin: Offset(0, 0.3),
                            end: Offset.zero,
                          ).animate(CurvedAnimation(
                            parent: _animationController,
                            curve: Interval(
                              (index * 0.1).clamp(0.0, 1.0),
                              ((index * 0.1) + 0.3).clamp(0.0, 1.0),
                              curve: Curves.easeOut,
                            ),
                          )),
                          child: _buildTripCard(
                            driverProvider.driverTrips[index],
                            index,
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ),
            ],
          ],
        ),
        floatingActionButton: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: AppConstants.colorPrimary.withOpacity(0.3),
                blurRadius: 12,
                offset: Offset(0, 6),
              ),
            ],
          ),
          child: FloatingActionButton.extended(
            backgroundColor: AppConstants.colorPrimary,
            foregroundColor: AppConstants.navy,
            elevation: 0,
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => CreateTrip()),
              );
            },
            icon: Container(
              padding: EdgeInsets.all(2),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.2),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                Icons.add_road_rounded,
                size: 20,
              ),
            ),
            label: Text(
              "Start New Trip",
              style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 16,
                letterSpacing: 0.2,
              ),
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
          ),
        ),
      );
    });
  }
}
