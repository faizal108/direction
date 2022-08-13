import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_maps_webservice/places.dart';
import 'package:google_api_headers/google_api_headers.dart';
import 'package:flutter_google_places/flutter_google_places.dart';
import './add_task_bar1.dart';

double? homelat;
double? homelan;
bool flag = false;
const kGoogleApiKey = 'AIzaSyDFFo3zWVu002APQeTrGG2uiQ_0ErlcJKw';
final homeScaffoldKey = GlobalKey<ScaffoldState>();


class CurrentLocationScreen extends StatefulWidget {
  const CurrentLocationScreen({Key? key}) : super(key: key);

  @override
  _CurrentLocationScreenState createState() => _CurrentLocationScreenState();
}

class _CurrentLocationScreenState extends State<CurrentLocationScreen> {
  late GoogleMapController googleMapController;

  static const CameraPosition initialCameraPosition = CameraPosition(target: LatLng(22.4371423,71.2974643), zoom: 6);

  Set<Marker> markers = {};
  final Mode _mode = Mode.overlay;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        key: homeScaffoldKey,
        appBar: AppBar(
          title: const Text("Pick Your Location"),
          centerTitle: true,
        ),
        body: GoogleMap(
          initialCameraPosition: initialCameraPosition,
          markers: markers,
          zoomControlsEnabled: false,
          mapType: MapType.hybrid,
          mapToolbarEnabled: false,
          onMapCreated: (GoogleMapController controller) {
            googleMapController = controller;
          },
          onTap:(x) {
            _handleTap(x);
          },

        ),
        floatingActionButton: Padding(
          padding: const EdgeInsets.fromLTRB(30, 90, 0, 5),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              FloatingActionButton(
                onPressed: _handlePressButton,
                tooltip: "Search",
                child: Icon(Icons.search_rounded),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  FloatingActionButton.extended(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    label: Text("Done"),
                    icon: Icon(Icons.done),
                    backgroundColor: Colors.green,
                  ),
                  FloatingActionButton.extended(
                    onPressed: () async {
                      Position position = await _determinePosition();

                      googleMapController
                          .animateCamera(CameraUpdate.newCameraPosition(CameraPosition(target: LatLng(position.latitude, position.longitude), zoom: 16)));


                      markers.clear();

                      markers.add(Marker(markerId: const MarkerId('currentLocation'),position: LatLng(position.latitude, position.longitude)));

                      setState(() {});

                    },
                    label: const Text("Current Location"),
                    icon: const Icon(Icons.my_location_outlined),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  _handleTap(LatLng point) {
    setState(() {
      markers.clear();
      markers.add(Marker(
        markerId: MarkerId(point.toString()),
        position: LatLng(point.latitude, point.longitude),
        infoWindow: InfoWindow(
          title: pointName,
        ),
        icon:
        BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueAzure),
      ));
    });
    homelat = point.latitude;
    homelan = point.longitude;
    flag = true;
    print(flag);
    print(homelat);
    print(homelan);

  }

  Future<void> _handlePressButton() async {
    Prediction? p = await PlacesAutocomplete.show(
        context: context,
        apiKey: kGoogleApiKey,
        onError: onError,
        mode: _mode,
        language: 'en',
        strictbounds: false,
        types: [""],
        decoration: InputDecoration(
            hintText: 'Search',
            focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(20), borderSide: BorderSide(color: Colors.white))),
        components: [Component(Component.country,"pk"),Component(Component.country,"usa")]);


    displayPrediction(p!,homeScaffoldKey.currentState);
  }

  void onError(PlacesAutocompleteResponse response){
    homeScaffoldKey.currentState!.showSnackBar(SnackBar(content: Text(response.errorMessage!)));
  }

  Future<void> displayPrediction(Prediction p, ScaffoldState? currentState) async {

    GoogleMapsPlaces places = GoogleMapsPlaces(
        apiKey: kGoogleApiKey,
        apiHeaders: await const GoogleApiHeaders().getHeaders()
    );

    PlacesDetailsResponse detail = await places.getDetailsByPlaceId(p.placeId!);

    final lat = detail.result.geometry!.location.lat;
    final lng = detail.result.geometry!.location.lng;

    markers.clear();
    markers.add(Marker(markerId: const MarkerId("0"),position: LatLng(lat, lng),infoWindow: InfoWindow(title: detail.result.name)));

    setState(() {});

    googleMapController.animateCamera(CameraUpdate.newLatLngZoom(LatLng(lat, lng), 14.0));

  }


  Future<Position> _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();

    if (!serviceEnabled) {
      return Future.error('Location services are disabled');
    }

    permission = await Geolocator.checkPermission();

    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();

      if (permission == LocationPermission.denied) {
        return Future.error("Location permission denied");
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return Future.error('Location permissions are permanently denied');
    }

    Position position = await Geolocator.getCurrentPosition(desiredAccuracy:LocationAccuracy.high);
    homelat = position.latitude;
    homelan = position.longitude;
    flag = true;
    print(flag);
    print(position);
    return position;
  }
}
