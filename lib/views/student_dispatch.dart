import 'dart:async';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import '../common_widgets/drawer.dart';
import '../common_widgets/loading.dart';
import '../common_widgets/menu_icon_container.dart';
import '../common_widgets/response_dialog.dart';
import '../common_widgets/roundedTrackerBtn.dart';
import '../enums/operation_status.dart';
import '../models/driver_trip.dart';
import '../models/pending_students.dart';
import '../providers/driver_provider.dart';
import '../providers/location_provider.dart';
import '../services/OsrmApi.dart';
import '../utils/constants.dart';
import 'student_dispatch_list.dart';

class StudentDispatchPage extends StatefulWidget {
  final Trip? trip;

  const StudentDispatchPage({Key? key, @required this.trip}) : super(key: key);
  @override
  _StudentDispatchState createState() => _StudentDispatchState();
}

class _StudentDispatchState extends State<StudentDispatchPage> {
  Completer<GoogleMapController> _controller = Completer();
  double mapBottomPadding = 100;
  double mapTopPadding = 0;

  GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  late GoogleMapController mapController;
  late Position currentPosition;
  late CameraPosition currentLocation;
  late BitmapDescriptor pinLocationIcon;
  late BitmapDescriptor currentPinLocationIcon;
  Set<Marker> _markers = Set<Marker>();
  late LocationProvider _locationProvider;
  // late DriverProvider _driverProvider;

  late PageController _pageController;
  late Polyline _polylines;

  @override
  void initState() {
    Provider.of<DriverProvider>(context, listen: false)
        .getPendingStudents(tripId: widget.trip!.id);
    _locationProvider = Provider.of<LocationProvider>(context, listen: false);
    _locationProvider.setUpPositionLocator();
    print('My location ${_locationProvider.userCurrentLocation}');

    currentLocation = CameraPosition(
      target: LatLng(_locationProvider.userCurrentLocation.latitude,
          _locationProvider.userCurrentLocation.longitude),
      zoom: 14.4746,
    );

    super.initState();
    setMapIcon();
    setCurrentPinIcon();
    _pageController = PageController(initialPage: 1, viewportFraction: 0.8);
  }

  // @override
  // didChangeDependencies() {
  //   super.didChangeDependencies();
  //   print("did change dependencies ");
  //   _driverProvider = Provider.of<DriverProvider>(context, listen: true);
  //   showStudentMarkers(_driverProvider.pendingStudents, context);
  // }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void setMapIcon() async {
    pinLocationIcon = await BitmapDescriptor.fromAssetImage(
        ImageConfiguration(devicePixelRatio: 2.5),
        'assets/images/studentIcon.png');
  }

  void setCurrentPinIcon() async {
    currentPinLocationIcon = await BitmapDescriptor.fromAssetImage(
        ImageConfiguration(devicePixelRatio: 2.5),
        'assets/images/studentIcon.png');
  }

  _handleShowClickedStudent(context, List<PendingStudents> students, student) {
    print(student.name);
    print('----------------checking index------------');
    int index = students.indexWhere((element) => element.id == student.id);
    setState(() {
      _pageController.animateToPage(
        index,
        duration: Duration(seconds: 1),
        curve: Curves.easeIn,
      );
    });
  }

  showStudentMarkers(List<PendingStudents> students, context) {
    // _markers.remove(Marker(markerId: markerId))
    setState(() {
      students.forEach((student) {
        _markers.add(Marker(
            markerId: MarkerId(student.id.toString()),
            position: LatLng(double.parse(student.latitude!),
                double.parse(student.longitude!)),
            icon: pinLocationIcon,
            onTap: () {
              _handleShowClickedStudent(context, students, student);
            }));
      });
    });
  }

  moveCamera(List<PendingStudents> students) {
    int index = _pageController.page!.toInt();
    mapController.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(
        target: LatLng(double.parse(students[index].latitude!),
            double.parse(students[index].longitude!)),
        zoom: 18.0,
        bearing: 45.0,
        tilt: 45.0)));
  }

  Widget _endTrip(context, driverProvider) {
    return Positioned(
      bottom: 20,
      left: 10,
      right: 10,
      child: Container(
        child: driverProvider.endTripStatus == OperationStatus.Loading
            ? Loading()
            : RoundedTrackerBtn(
                text: "End Trip",
                press: () async {
                  bool res =
                      await driverProvider.endTrip(tripId: widget.trip!.id!);
                  res
                      ? ResponseDialog(context: context, response: res)
                      : ResponseDialog(
                          context: context, response: res, success: false);
                  Provider.of<DriverProvider>(context, listen: false)
                      .getDriverTrips(widget.trip!.driverId!);
                },
              ),
      ),
    );
  }

  Widget _studentListCards(context, driverProvider) {
    return Positioned(
        bottom: 0,
        child: Container(
          padding: EdgeInsets.all(10),
          height: 200,
          width: MediaQuery.of(context).size.width,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.max,
            children: [
              InkWell(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => DispatchList(
                                trip: widget.trip,
                                tripType: widget.trip!.type == 1
                                    ? TripType.PICK
                                    : TripType.DROP,
                              )));
                },
                child: Align(
                    alignment: Alignment.topRight,
                    child: Container(
                        margin: EdgeInsets.only(bottom: 10),
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(20.0),
                            boxShadow: [
                              BoxShadow(
                                  color: Colors.black26,
                                  blurRadius: 5.0,
                                  spreadRadius: 0.5,
                                  offset: Offset(0.7, 0.7))
                            ]),
                        child: CircleAvatar(
                          radius: 20,
                          backgroundColor: Colors.white,
                          child: Icon(
                            Icons.list,
                            color: AppConstants.colorPrimary,
                          ),
                        ))),
              ),
              Expanded(
                child: PageView.builder(
                    controller: _pageController,
                    itemCount: driverProvider.pendingStudents.length,
                    itemBuilder: (BuildContext context, int index) {
                      return AnimatedBuilder(
                        animation: _pageController,
                        builder: (BuildContext context, Widget? widget) {
                          return widget!;
                        },
                        child: InkWell(
                          onTap: () {
                            moveCamera(driverProvider.pendingStudents);
                          },
                          child: DispatchItem(
                            student: driverProvider.pendingStudents[index],
                            tripType: widget.trip!.type == 1
                                ? TripType.PICK
                                : TripType.DROP,
                            trip: widget.trip,
                            onStudentDrop: () {
                              debugPrint("Dropped student" +
                                  driverProvider.pendingStudents[index].id
                                      .toString());
                              print(_markers.length);
                              setState(() {
                                _markers.remove(_markers.firstWhere(
                                    (Marker marker) =>
                                        marker.markerId.value ==
                                        driverProvider
                                            .pendingStudents[index].id));
                              });
                            },
                          ),
                        ),
                      );
                    }),
              ),
            ],
          ),
        ));
  }

  @override
  Widget build(BuildContext context) {
    final provmaps = Provider.of<ProviderMaps>(context);
    provmaps.setCurrentLocation(_locationProvider.userCurrentLocation);
    return (Scaffold(
      key: _scaffoldKey,
      drawer: AppDrawer(),
      body: Consumer<DriverProvider>(
        builder: (context, value, child) =>
            value.pendingStudentLoadingStatus == OperationStatus.Loaded
                ? Stack(
                    children: [
                      GoogleMap(
                        padding: EdgeInsets.only(
                            bottom: mapBottomPadding,
                            left: 0,
                            right: 0,
                            top: mapTopPadding),
                        initialCameraPosition: currentLocation,
                        mapType: MapType.normal,
                        myLocationEnabled: true,
                        myLocationButtonEnabled: true,
                        zoomControlsEnabled: true,
                        zoomGesturesEnabled: true,
                        polylines: provmaps.polyline,
                        onMapCreated: (GoogleMapController controller) {
                          // _controller.complete(controller);
                          mapController = controller;
                          setState(() {
                            mapBottomPadding =
                                MediaQuery.of(context).size.height * 0.3;
                            mapTopPadding =
                                MediaQuery.of(context).size.height * 0.1;
                          });
                          showStudentMarkers(value.pendingStudents, context);
                        },
                        markers: _markers,
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 50, horizontal: 10),
                        child: MenuIconContainer(scaffoldkey: _scaffoldKey),
                      ),
                      Consumer<DriverProvider>(
                          builder: (context, driverProvider, child) {
                        return driverProvider.pendingStudents.length > 0
                            ? _studentListCards(context, driverProvider)
                            : _endTrip(context, driverProvider);
                      })
                    ],
                  )
                : Center(child: CircularProgressIndicator()),
      ),
    ));
  }
}
