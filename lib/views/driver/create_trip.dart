import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:search_choices/search_choices.dart';
import '../../common_widgets/loading.dart';
import '../../common_widgets/roundedTrackerBtn.dart';
import '../../common_widgets/response_dialog.dart';
import '../../common_widgets/vertical_spacing.dart';
import '../../enums/operation_status.dart';
import '../../models/app_user.dart';
import '../../models/driver_trip.dart';
import '../../providers/dispatch_provider.dart';
import '../../providers/driver_provider.dart';
import '../../providers/location_provider.dart';
import '../../providers/vehicle_provider.dart';
import '../../utils/constants.dart';
import '../../utils/dio_api_helper.dart';
import '../../utils/user_shared_pref.dart';
import '../student_dispatch.dart';

class CreateTrip extends StatefulWidget {
  @override
  _CreateTripState createState() => _CreateTripState();
}

class _CreateTripState extends State<CreateTrip> {
  DateTime now = new DateTime.now();
  late String selectedValue;
  dynamic selectedVehicle;
  dynamic selectedDispatch;
  ApiBaseHelper api = ApiBaseHelper();
  late LocationProvider _userLocation;
  late AppUser _user;
  int _tripType = 1;

  @override
  void initState() {
    _userLocation = Provider.of<LocationProvider>(context, listen: false);
    _user = Provider.of<UserPreferences>(context, listen: false).appUser;
    Provider.of<VehicleProvider>(context, listen: false).getVehicle();
    Provider.of<DispatchProvider>(context, listen: false).getDispatches();
    super.initState();
    triptype();
  }

  int triptype() {
    var hour = DateTime.now().hour;
    if (hour < 12) {
      return _tripType = 1;
    } else
      return _tripType = 2;
  }

  Widget getVehicleDropdown({required List data}) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      child: DropdownButtonFormField<int>(
        value: selectedVehicle,
        hint: Text(
          "Select Your Vehicle",
          style: TextStyle(
            color: Colors.grey[600],
            fontSize: 16,
          ),
        ),
        isExpanded: true,
        decoration: InputDecoration(
          labelText: "Vehicle",
          hintText: "Select Your Vehicle",
          prefixIcon: Icon(
            Icons.directions_car,
            color: Theme.of(context).primaryColor,
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: Colors.grey[300]!),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: Colors.grey[300]!),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(
              color: Theme.of(context).primaryColor,
              width: 2,
            ),
          ),
          filled: true,
          fillColor: Colors.grey[50],
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 12,
          ),
        ),
        items: data.map<DropdownMenuItem<int>>((item) {
          return DropdownMenuItem<int>(
            value: item.id,
            child: Row(
              children: [
                Icon(
                  Icons.local_shipping,
                  size: 20,
                  color: Colors.grey[600],
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    item.plateNo,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
          );
        }).toList(),
        onChanged: (value) {
          setState(() {
            selectedVehicle = value;
          });
        },
        validator: (value) {
          if (value == null) {
            return 'Please select a vehicle';
          }
          return null;
        },
      ),
    );
  }

  Widget getDispatchesDropdown(List listData) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Dispatch",
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Colors.grey[700],
            ),
          ),
          const SizedBox(height: 8),
          DropdownButtonFormField<dynamic>(
            value: selectedDispatch,
            hint: Row(
              children: [
                Icon(
                  Icons.search,
                  color: Colors.grey[600],
                  size: 20,
                ),
                const SizedBox(width: 12),
                Text(
                  "Select Dispatch",
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 16,
                  ),
                ),
              ],
            ),
            isExpanded: true,
            decoration: InputDecoration(
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: Colors.grey[300]!),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: Colors.grey[300]!),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(
                  color: Theme.of(context).primaryColor,
                  width: 2,
                ),
              ),
              filled: true,
              fillColor: Colors.grey[50],
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 12,
              ),
            ),
            items: listData.map<DropdownMenuItem<dynamic>>((item) {
              return DropdownMenuItem<dynamic>(
                value: item.id,
                child: Row(
                  children: [
                    Container(
                      width: 8,
                      height: 8,
                      decoration: BoxDecoration(
                        color: Theme.of(context).primaryColor,
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        item.name,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
              );
            }).toList(),
            onChanged: (value) {
              setState(() {
                selectedDispatch = value;
              });
            },
            validator: (value) {
              if (value == null) {
                return 'Please select a dispatch';
              }
              return null;
            },
            menuMaxHeight: 200,
          ),
        ],
      ),
    );
  }

  _handleSuccess(context, response, Trip trip) {
    Provider.of<VehicleProvider>(context, listen: false).getVehicle();
    Provider.of<DispatchProvider>(context, listen: false).getDispatches();

    Navigator.of(context).pop();
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => StudentDispatchPage(trip: trip)));
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    DriverProvider _driverProvider =
        Provider.of<DriverProvider>(context, listen: true);
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        centerTitle: false,
        title: Text(
          'Create Trip',
          style: TextStyle(color: Colors.black),
        ),
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: Icon(
            Icons.arrow_back_ios,
            color: Colors.black,
          ),
        ),
        backgroundColor: AppConstants.colorPrimary,
      ),
      body: Stack(
        children: [
          Positioned(
            top: 0,
            right: 0,
            left: 0,
            child: Container(
              height: 300,
              decoration: BoxDecoration(
                image: DecorationImage(
                  alignment: Alignment.topCenter,
                  image: _tripType == 2
                      ? AssetImage(
                          "assets/images/dropoff.jpg",
                        )
                      : AssetImage(
                          "assets/images/pickup.jpg",
                        ),
                  fit: BoxFit.fill,
                ),
              ),
            ),
          ),
          Positioned(
            top: 270,
            child: Container(
              height: size.height * 0.45,
              padding: EdgeInsets.all(20),
              width: MediaQuery.of(context).size.width - 60,
              margin: EdgeInsets.symmetric(horizontal: 30),
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(15),
                  boxShadow: [
                    BoxShadow(
                        color: Colors.black.withOpacity(0.3),
                        blurRadius: 15,
                        spreadRadius: 5),
                  ]),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              _tripType = 1;
                            });
                          },
                          child: Container(
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(100),
                                color: _tripType == 1
                                    ? AppConstants.colorPrimaryDark
                                    : Colors.grey),
                            height: 50,
                            width: 100,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  "PICK-UP",
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: AppConstants.white),
                                ),
                              ],
                            ),
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              _tripType = 2;
                            });
                          },
                          child: Container(
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(100),
                                color: _tripType == 2
                                    ? AppConstants.colorPrimaryDark
                                    : Colors.grey),
                            height: 50,
                            width: 100,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  "DROP-OFF",
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: AppConstants.white),
                                ),
                              ],
                            ),
                          ),
                        )
                      ],
                    ),
                    if (_tripType == 1)
                      Column(
                        children: [
                          VerticalSpacing(),
                          PickUp(),
                          VerticalSpacing(height: size.height * 0.06),
                          _driverProvider.tripCreationStatus ==
                                  OperationStatus.Loading
                              ? Center(child: Loading())
                              : RoundedTrackerBtn(
                                  text: "Start Trip",
                                  press: () async {
                                    Response res = await _driverProvider
                                        .createTrip(
                                            vehicleId: selectedVehicle,
                                            dispatchId: selectedDispatch,
                                            driverId: _user.userId,
                                            latitude: _userLocation
                                                .userCurrentLocation.latitude,
                                            longitude: _userLocation
                                                .userCurrentLocation.longitude,
                                            type: _tripType);

                                    print('Status code ${res.statusCode}');
                                    print(res.data['data']);

                                    if (res.statusCode == 201) {
                                      Trip _trip =
                                          Trip.fromJson(res.data['data']);
                                      print(_trip.id);
                                      print(_trip.driverId);
                                      _handleSuccess(context, res, _trip);

                                      return;
                                    } else {
                                      ResponseDialog(
                                          context: context,
                                          response: res,
                                          success: false);
                                    }
                                  },
                                )
                        ],
                      ),
                    if (_tripType == 2)
                      Column(
                        children: [
                          VerticalSpacing(),
                          PickUp(),
                          VerticalSpacing(height: size.height * 0.06),
                          _driverProvider.tripCreationStatus ==
                                  OperationStatus.Loading
                              ? Center(child: Loading())
                              : RoundedTrackerBtn(
                                  text: "Start Trip",
                                  press: () async {
                                    Response res = await _driverProvider
                                        .createTrip(
                                            vehicleId: selectedVehicle,
                                            dispatchId: selectedDispatch,
                                            driverId: _user.userId,
                                            latitude: _userLocation
                                                .userCurrentLocation.latitude,
                                            longitude: _userLocation
                                                .userCurrentLocation.longitude,
                                            type: _tripType);

                                    print('Status code ${res.statusCode}');
                                    print(res.data['data']);

                                    if (res.statusCode == 201) {
                                      Trip _trip =
                                          Trip.fromJson(res.data['data']);
                                      print(_trip.id);
                                      print(_trip.driverId);
                                      _handleSuccess(context, res, _trip);

                                      return;
                                    } else {
                                      ResponseDialog(
                                          context: context,
                                          response: res,
                                          success: false);
                                    }
                                  },
                                )
                        ],
                      ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget PickUp() {
    return Column(
      children: [
        Consumer<VehicleProvider>(builder: (context, vehicleprovider, child) {
          print(vehicleprovider.vehicles);
          return Container(
              child: Column(children: [
            getVehicleDropdown(data: vehicleprovider.vehicles),
          ]));
        }),
        Consumer<DispatchProvider>(builder: (context, dispatchProvider, child) {
          return Container(
              child: Column(children: [
            getDispatchesDropdown(dispatchProvider.dispatches),
          ]));
        }),
      ],
    );
  }
}
