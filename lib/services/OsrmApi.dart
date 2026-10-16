import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;
import 'dart:math' show cos, sqrt, asin;

class ProviderMaps with ChangeNotifier {
  LatLng _initialposition = LatLng(-1.286389, 36.817223);
  late LatLng _finalposition;
  late GoogleMapController _mapController;
  LatLng get initialPos => _initialposition;
  LatLng get finalPos => _finalposition;
  final Set<Marker> _markers = Set();
  final Set<Polyline> _polylines = Set();
  Set<Marker> get markers => _markers;
  Set<Polyline> get polyline => _polylines;
  String distance = "";
  GoogleMapController get mapController => _mapController;
  void onCreated(GoogleMapController controller) {
    _mapController = controller;
    notifyListeners();
  }

  void setCurrentLocation(currentLocation) {
    // _initialposition =
    //     LatLng(currentLocation.latitude, currentLocation.latitude);
  }

  String calculateDistance(double lat1, double lon1, double lat2, double lon2) {
    // Timer.periodic(Duration(seconds: 60), (timer) {
    //   //calling function after every 10 seconds
    // });
    var p = 0.017453292519943295;
    var c = cos;
    var a = 0.5 -
        c((lat2 - lat1) * p) / 2 +
        c(lat1 * p) * c(lat2 * p) * (1 - c((lon2 - lon1) * p)) / 2;
    double res = 12742 * asin(sqrt(a));
    if (res.toString().substring(0, 1) == "0") {
      res = (12742 * asin(sqrt(a))) * 1000;
      return res.toStringAsFixed(2) + " m";
    } else {
      res = res;
      return res.toStringAsFixed(2) + " Km";
    }
  }

  void addMarker(LatLng location) {
    if (markers.length < 2) {
      _markers.add(Marker(
          markerId: MarkerId(location.toString()),
          position: location,
          icon: BitmapDescriptor.defaultMarker));
    }
    notifyListeners();
  }

  void routermap(waypoints) async {
    polyline.clear();

    List<LatLng> polylines = await ApiOSRM().getpoints(waypoints);
    createpolyline(polylines);

    notifyListeners();
  }

  void createpolyline(List<LatLng> polylines) {
    _polylines.add(Polyline(
        polylineId: PolylineId(_initialposition.toString()),
        width: 5,
        points: polylines,
        color: Colors.redAccent));
    notifyListeners();
  }
}

class ApiOSRM {
  Future<List<LatLng>> getpoints(waypoints) async {
    List<LatLng> llena = [];
    //test co-ordinates
    String test =
        "-1.286389,36.817223;-1.0499998,37.083333;-1.20930429,36.87122079;-1.187234,36.90304;-1.03326,37.06933";
    var url =
        "https://router.project-osrm.org/route/v1/driving/$waypoints?geometries=geojson";
    // "http://10.0.2.2:5000/route/v1/driving/$test?geometries=geojson";

    var response = await http.get(Uri.parse(url));

    print([
      response,
      // response.statusCode,
      // response.body,
      jsonDecode(response.body)["routes"][0]["geometry"]["coordinates"]
    ]);
    if (response.statusCode == 200) {
      var rutar =
          jsonDecode(response.body)["routes"][0]["geometry"]["coordinates"];
      for (int i = 0; i < rutar.length; i++) {
        var reep = rutar[i].toString();
        reep = reep.replaceAll("[", "");
        reep = reep.replaceAll("]", "");
        var lat1 = reep.split(',');
        var long1 = reep.split(',');
        llena.add(LatLng(double.parse(lat1[1]), double.parse(long1[0])));
      }
      return llena;
    } else {
      return [];
    }
  }
}
