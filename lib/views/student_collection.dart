import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:school_tracker/common_widgets/loading.dart';
import '../common_widgets/drawer.dart';
import '../common_widgets/error_message.dart';
import '../common_widgets/menu_icon_container.dart';
import '../common_widgets/roundedTrackerBtn.dart';
import '../common_widgets/tracker_divider.dart';
import '../common_widgets/vertical_spacing.dart';
import '../enums/operation_status.dart';
import '../models/parent/active_student_model.dart';
import '../providers/location_provider.dart';
import '../providers/parent_provider.dart';
import '../services/OsrmApi.dart';
import '../utils/constants.dart';
import '../utils/strings.dart';
import 'package:url_launcher/url_launcher.dart';

class StudentCollection extends StatefulWidget {
  @override
  _StudentCollectionState createState() => _StudentCollectionState();
}

class _StudentCollectionState extends State<StudentCollection> {
  Completer<GoogleMapController> _controller = Completer();
  double mapBottomPadding = 0;
  double mapTopPadding = 0;
  GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  late GoogleMapController mapController;
  late BitmapDescriptor pinLocationIcon;
  Set<Marker> _markers = Set<Marker>();
  late BitmapDescriptor currentPinLocationIcon;
  late LocationProvider _locationProvider;
  late CameraPosition _kGooglePlex;
  late PageController _pageController;
  List vehicles = [];

  @override
  void initState() {
    Provider.of<ParentProvider>(context, listen: false).getMyActiveStudents();
    _locationProvider = Provider.of<LocationProvider>(context, listen: false);
    setCurrentPinIcon();
    _kGooglePlex = CameraPosition(
      target: LatLng(_locationProvider.userCurrentLocation.latitude,
          _locationProvider.userCurrentLocation.longitude),
      zoom: 18.4746,
    );
    super.initState();
    setMapIcon();
    _pageController = PageController(initialPage: 1, viewportFraction: 0.8);
  }

  void setMapIcon() async {
    pinLocationIcon = await BitmapDescriptor.fromAssetImage(
        ImageConfiguration(devicePixelRatio: 2.5), 'assets/images/bus.png');
  }

  void _showPageViewDetails({ActiveStudents? student}) {
    print("scroll bottom sheet");
    setState(() {
      print("we here");
    });
  }

  void setCurrentPinIcon() async {
    currentPinLocationIcon = await BitmapDescriptor.fromAssetImage(
        ImageConfiguration(devicePixelRatio: 2.5),
        'assets/images/currentLocation_icon.png');
  }

  void showStudentMarkers(List<ActiveStudents> students) {
    final Set<Marker> nextMarkers = <Marker>{};
    final Set<int> vehicleIdSet = <int>{};

    for (final student in students) {
      final int? vId = student.activeTripHistory?.trip?.vehicleId;
      if (vId != null) vehicleIdSet.add(vId);

      final double? lat = double.tryParse(student.latitude ?? '');
      final double? lng = double.tryParse(student.longitude ?? '');
      if (lat == null || lng == null) continue;

      nextMarkers.add(
        Marker(
          markerId: MarkerId('student_${student.id ?? UniqueKey().hashCode}'),
          position: LatLng(lat, lng),
          icon: pinLocationIcon,
          onTap: () => _showPageViewDetails(student: student),
        ),
      );
    }

    setState(() {
      _markers = nextMarkers;
      vehicles = vehicleIdSet.toList()..sort();
    });

    if (vehicles.isNotEmpty) {}
  }

  moveCamera(List<ActiveStudents> students) {
    int index = _pageController.page!.toInt();
    mapController.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(
        target: LatLng(double.parse(students[index].latitude!),
            double.parse(students[index].longitude!)),
        zoom: 18.0,
        bearing: 45.0,
        tilt: 45.0)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: AppDrawer(),
      key: _scaffoldKey,
      body: Consumer<ParentProvider>(
        builder: (context, parentProvider, child) => parentProvider
                    .activeStudentLoadingStatus ==
                OperationStatus.Loading
            ? Center(
                child: CircularProgressIndicator(),
              )
            : parentProvider.activeStudentLoadingStatus == OperationStatus.Error
                ? ErrorMessage(errorMessage: AppStrings.ErrorMessage)
                : parentProvider.myActiveStudents.length > 0
                    ? Stack(
                        children: [
                          GoogleMap(
                            padding: EdgeInsets.only(
                                bottom: mapBottomPadding, top: 40),
                            initialCameraPosition: _kGooglePlex,
                            mapType: MapType.normal,
                            myLocationButtonEnabled: true,
                            zoomControlsEnabled: true,
                            zoomGesturesEnabled: true,
                            myLocationEnabled: true,
                            onMapCreated: (GoogleMapController controller) {
                              _controller.complete(controller);
                              mapController = controller;
                              setState(() {
                                // Dynamically calculate padding based on actual content size
                                mapBottomPadding =
                                    190; // Approximate height of student cards + padding
                                mapTopPadding = 40;
                              });
                              showStudentMarkers(
                                  parentProvider.myActiveStudents);
                            },
                            markers: _markers,
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                vertical: 45, horizontal: 10),
                            child: MenuIconContainer(scaffoldkey: _scaffoldKey),
                          ),
                          Positioned(
                            bottom: 0,
                            left: 0,
                            right: 0,
                            child: SafeArea(
                              child: Container(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 10, vertical: 8),
                                child: SizedBox(
                                  height:
                                      170, // Slightly larger than StudentDetails height
                                  child: PageView.builder(
                                    controller: _pageController,
                                    itemCount:
                                        parentProvider.myActiveStudents.length,
                                    itemBuilder:
                                        (BuildContext context, int index) {
                                      return AnimatedBuilder(
                                        animation: _pageController,
                                        builder: (BuildContext context,
                                            Widget? widget) {
                                          double value = 1;
                                          if (_pageController
                                              .position.haveDimensions) {
                                            value =
                                                _pageController.page! - index;
                                            value =
                                                (1 - (value.abs() * 0.3) + 0.06)
                                                    .clamp(0.0, 1.0);
                                          }
                                          return widget!;
                                        },
                                        child: InkWell(
                                          onTap: () {
                                            moveCamera(parentProvider
                                                .myActiveStudents);
                                          },
                                          child: Container(
                                            margin: EdgeInsets.symmetric(
                                                horizontal: 8.0),
                                            child: StudentDetails(
                                                student: parentProvider
                                                    .myActiveStudents[index]),
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                ),
                              ),
                            ),
                          )
                        ],
                      )
                    : NoStudentInRoute(),
      ),
    );
  }
}

class StudentDetails extends StatefulWidget {
  final ActiveStudents? student;
  const StudentDetails({
    Key? key,
    @required this.student,
  }) : super(key: key);

  @override
  State<StudentDetails> createState() => _StudentDetailsState();
}

class _StudentDetailsState extends State<StudentDetails> {
  late ProviderMaps maps;
  @override
  void initState() {
    super.initState();
    maps = Provider.of<ProviderMaps>(context, listen: false);
  }

  int pickingStudentIndex = 0;
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15.0),
        boxShadow: [
          BoxShadow(
              color: Colors.black26,
              blurRadius: 15.0,
              spreadRadius: 0.5,
              offset: Offset(1.0, 10.0)),
        ],
      ),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              "${widget.student!.name} is ${maps.calculateDistance(double.parse(widget.student!.latitude!), double.parse(widget.student!.longitude!), -1.286389, 36.817223)}",
              style: TextStyle(fontSize: 13, fontWeight: FontWeight.w800),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            SizedBox(height: 6),
            TrackerDivider(),
            SizedBox(height: 6),
            Row(
              children: [
                Container(
                  height: 36.0,
                  width: 36.0,
                  child: CircleAvatar(
                    backgroundImage: AssetImage('assets/images/busdriver.jpg'),
                  ),
                ),
                SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        widget.student!.activeTripHistory!.trip!.driver!.name!,
                        style: TextStyle(
                            fontSize: 14, fontWeight: FontWeight.w600),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      SizedBox(height: 1),
                      Text(
                        "${widget.student!.activeTripHistory!.trip!.vehicle!.plateNo!}",
                        style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey[600],
                            fontWeight: FontWeight.w500),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
                GestureDetector(
                  onTap: () => launch(
                      "tel://${widget.student!.activeTripHistory!.trip!.driver!.phone}"),
                  child: Container(
                    padding: EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      color: AppConstants.colorPrimary.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Icon(
                      Icons.call,
                      size: 20.0,
                      color: AppConstants.colorPrimary,
                    ),
                  ),
                )
              ],
            ),
            SizedBox(height: 8),
            Provider.of<ParentProvider>(context, listen: false)
                            .guardianPickingStudentLoadingStatus ==
                        OperationStatus.Loading &&
                    pickingStudentIndex == widget.student!.id
                ? Center(child: Loading())
                : RoundedTrackerBtn(
                    text: "Pick ${widget.student!.name!.toLowerCase()}",
                    press: () async {
                      setState(() {
                        pickingStudentIndex = widget.student!.id!;
                      });
                      await Provider.of<ParentProvider>(context, listen: false)
                          .pickMyStudent(
                        studentId: widget.student!.id,
                        tripId: widget.student!.activeTripHistory!.tripId,
                        pickedLocationLatitude: Provider.of<LocationProvider>(
                                context,
                                listen: false)
                            .userCurrentLocation
                            .latitude,
                        pickedLocationLongitude: Provider.of<LocationProvider>(
                                context,
                                listen: false)
                            .userCurrentLocation
                            .longitude,
                      );
                      var students = Provider.of<ParentProvider>(context,
                              listen: false)
                          .myActiveStudents
                          .firstWhere(
                              (element) => element.id == widget.student!.id);
                      Provider.of<ParentProvider>(context, listen: false)
                          .myActiveStudents
                          .remove(students);
                      setState(() {
                        pickingStudentIndex = 0;
                      });
                    },
                  )
          ],
        ),
      ),
    );
  }
}

class NoStudentInRoute extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: AppConstants.colorPrimary,
        title: Text("In Route"),
      ),
      body: Center(
        child: Container(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "There is no bus in route at the moment!",
                style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.w700),
              ),
              VerticalSpacing(
                height: 10.0,
              ),
              Text('We will notify you once there is one.')
            ],
          ),
        ),
      ),
    );
  }
}
