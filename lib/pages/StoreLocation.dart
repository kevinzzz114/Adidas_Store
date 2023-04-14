import 'package:flutter/material.dart';
import 'package:flutter_application_1/pages/CustomerHomePage.dart';
import 'package:flutter_application_1/pages/LoginPage.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'dart:math';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';

class StoreLocation extends StatefulWidget {

  final String userName;
  final int userID;
  final String userEmail;
  final String userPassword;

  StoreLocation({
    required this.userName,
    required this.userID,
    required this.userEmail,
    required this.userPassword});


  @override
  _StoreLocationState createState() => _StoreLocationState();
}

class _StoreLocationState extends State<StoreLocation> {
  late int _userID = 0;
  late String _userName = '';
  late String _userEmail = '';
  late String _userPassword = '';

  GoogleMapController? mapController;
  PolylinePoints polylinePoints = PolylinePoints();

  String googleAPiKey = "AIzaSyAgK15dSCki7Gc3D3Js5dcsSZsez0DqSxk";

  Set<Marker> markers = Set();
  Map<PolylineId, Polyline> polylines = {};
  // LatLng _tappedLatLng = LatLng(0,0);
  // late LatLng _tappedLatLng;
  // List<LatLng> _polylineCoordinates = [];

  LatLng shopLocation = LatLng(3.0727787962685222, 101.60790312792508);
  LatLng endLocation = LatLng(3.077848716756535, 101.60670262245452);
  double _distance = 0.0;

  static final CameraPosition _initialCameraPosition = CameraPosition(
    target: LatLng(3.0727787962685222, 101.60790312792508), // LatLng of Adidas shop in KL
    zoom: 15,
  );

  // void _onMapTap(LatLng latLng) {
  //   setState(() {
  //     _tappedLatLng = latLng; // Update the tapped LatLng coordinates
  //   });
  // }
  @override
  void initState() {

    if (widget.userID != null) {
      _userID = widget.userID;
    }if (widget.userName != null) {
      _userName = widget.userName;
    }
    if (widget.userEmail != null) {
      _userEmail = widget.userEmail;
    }
    if (widget.userPassword != null) {
      _userPassword = widget.userPassword;
    }

    markers.add(Marker( //add distination location marker
      markerId: MarkerId(shopLocation.toString()),
      position: shopLocation, //position of marker
      infoWindow: InfoWindow( //popup info
        title: 'Adidas Shop Sunway Pyramid ',
        snippet: 'Selangor, Malaysia',
      ),
      icon: BitmapDescriptor.defaultMarker, //Icon for Marker
    ));

    markers.add(Marker( //add distination location marker
      markerId: MarkerId(endLocation.toString()),
      position: endLocation, //position of marker
      infoWindow: InfoWindow( //popup info
        title: 'You are here ',
        snippet: '',
      ),
      icon: BitmapDescriptor.defaultMarker, //Icon for Marker
      draggable: true, // Set marker as draggable
      onDragEnd: _onMarkerDragEnd, // Set callback for marker drag event
    ));

  //   markers.add(Marker( //add distination location marker
  //     markerId: MarkerId(_tappedLatLng.toString()),
  //     position: _tappedLatLng, //position of marker
  //     infoWindow: InfoWindow( //popup info
  //       title: 'You are here ',
  //       snippet: '',
  //     ),
  //     icon: BitmapDescriptor.defaultMarker, //Icon for Marker
  //   ));
  //
    getDirections();
    super.initState();
  }
  void _onMarkerDragEnd(LatLng newPosition) {
    setState(() {
      // Update the end location coordinates with the new position
      LatLng _endLatLng = newPosition;

      // Update the polyline with the new end location coordinates
      polylines.clear();
      getDirections();

      // Calculate the new distance between start and end locations
      _distance = _calculateDistance(shopLocation, _endLatLng);
    });
  }

  // Calculate distance between two LatLng coordinates using Haversine formula
  double _calculateDistance(LatLng start, LatLng end) {
    final double earthRadius = 6371; // Radius of the earth in kilometers
    double lat1Rad = degToRad(start.latitude);
    double lon1Rad = degToRad(start.longitude);
    double lat2Rad = degToRad(end.latitude);
    double lon2Rad = degToRad(end.longitude);
    double dLon = lon2Rad - lon1Rad;
    double dLat = lat2Rad - lat1Rad;
    double a = sin(dLat / 2) * sin(dLat / 2) +
        cos(lat1Rad) * cos(lat2Rad) * sin(dLon / 2) * sin(dLon / 2);
    double c = 2 * atan2(sqrt(a), sqrt(1 - a));
    double distance = earthRadius * c;
    return distance;
  }

// Helper method to convert degrees to radians
  double degToRad(double degrees) {
    return degrees * (pi / 180);
  }

  getDirections() async {
    List<LatLng> polylineCoordinates = [];

    PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
      googleAPiKey,
      PointLatLng(shopLocation.latitude, shopLocation.longitude),
      PointLatLng(endLocation.latitude, endLocation.longitude),
      // PointLatLng(_tappedLatLng.latitude, _tappedLatLng.longitude),
      travelMode: TravelMode.transit,
    );

    if (result.points.isNotEmpty) {
      result.points.forEach((PointLatLng point) {
        polylineCoordinates.add(LatLng(point.latitude, point.longitude));
      });
    } else {
      print(result.errorMessage);
    }

    //polulineCoordinates is the List of longitute and latidtude.
    double totalDistance = 0;
    for(var i = 0; i < polylineCoordinates.length-1; i++){
      totalDistance += calculateDistance(
          polylineCoordinates[i].latitude,
          polylineCoordinates[i].longitude,
          polylineCoordinates[i+1].latitude,
          polylineCoordinates[i+1].longitude);
    }
    print(totalDistance);

    setState(() {
      _distance = totalDistance;
    });

    //add to the list of poly line coordinates
    addPolyLine(polylineCoordinates);
  }

  addPolyLine(List<LatLng> polylineCoordinates) {
    PolylineId id = PolylineId("poly");
    Polyline polyline = Polyline(
      polylineId: id,
      color: Colors.deepPurpleAccent,
      points: polylineCoordinates,
      width: 8,
    );
    polylines[id] = polyline;
    setState(() {});
  }

  double calculateDistance(lat1, lon1, lat2, lon2){
    var p = 0.017453292519943295;
    var a = 0.5 - cos((lat2 - lat1) * p)/2 +
        cos(lat1 * p) * cos(lat2 * p) *
            (1 - cos((lon2 - lon1) * p))/2;
    return 12742 * asin(sqrt(a));
  }

  @override
  Widget build(BuildContext context) {
    LoginData loginData = LoginData(email: _userEmail, password: _userPassword);
    return Scaffold(
      body: Stack(
        children: [
          GoogleMap( //Map widget from google_maps_flutter package
            zoomGesturesEnabled: true, //enable Zoom in, out on map
            initialCameraPosition: _initialCameraPosition,
            // onTap: _onMapTap,
            markers: markers, //markers to show on map
            polylines: Set<Polyline>.of(polylines.values), //polylines
            mapType: MapType.normal, //map type
            onMapCreated: (controller) { //method called when map is created
              setState(() {
                mapController = controller;
              });
            },
          ),
          Positioned(
            bottom: 200,
            left: 100,
            child: Container(
              child: Card(
                child: Container(
                  padding: EdgeInsets.all(20),
                  child: Text("Total Distance: " + _distance.toStringAsFixed(2) + " KM",
                      style: TextStyle(fontSize: 15, fontWeight:FontWeight.bold)),
                ),
              ),
            ),
          ),
          Container(
            color: Colors.white,
            padding: EdgeInsets.all(25),
            child: Row(
              children: [
                InkWell(
                  onTap: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => CustomerHomePage(loginData: loginData),
                      ),
                    );
                  },
                  child: Icon(
                    Icons.arrow_back,
                    size: 30,
                    color: Color(0xFF4C53A5),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(left: 20),
                  child: Text(
                    "Store Location",
                    style: TextStyle(
                        fontSize: 23,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF4C53A5)),
                  ),
                ),
                Spacer()
              ],
            ),
          ),
        ],
      ),
    );
  }

}
