import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:maps_flutter/constants/my_colors.dart';
import 'package:maps_flutter/cubit/maps_cubit.dart';
import 'package:maps_flutter/cubit/maps_state.dart';
import 'package:maps_flutter/data/models/PlaceSuggestion.dart';
import 'package:maps_flutter/data/models/place.dart';
import 'package:maps_flutter/data/models/place_directions.dart';
import 'package:maps_flutter/helpers/location_helper.dart';
import 'package:maps_flutter/presentaion/widget/distance_and_time.dart';
import 'package:maps_flutter/presentaion/widget/my_drawer.dart';
import 'package:maps_flutter/presentaion/widget/place_item.dart';
import 'package:material_floating_search_bar_2/material_floating_search_bar_2.dart';
import 'package:uuid/uuid.dart';

class MapsScreen extends StatefulWidget {
  const MapsScreen({Key? key}) : super(key: key);

  @override
  State<MapsScreen> createState() => _MapsScreenState();
}

class _MapsScreenState extends State<MapsScreen> {
  @override
  void initState() {
    super.initState();
    getMyCurrentLocation();
  }

  // these variables for getPlaceLocation
  Set<Marker> markers = Set();
  late Marker searchedPlaceMarker;
  late Marker currentLocationMarker;
  late PlaceSuggestion placeSuggestion;
  late Place selectedPlace;
  late CameraPosition goToSearchForPlace;

  // these variables for getDirections
  PlaceDirections? placeDirections;
  var progressIndicator = false;
  late List<LatLng> polylinePoints;
  var isSearchedPlaceMarkerClicked = false;

  var isTimeAndDistanceVisible = false;
  late String time;
  late String distance;

  void buildCameraNewPosition() {
    goToSearchForPlace = CameraPosition(
      bearing: 0.0,
      tilt: 0.0,
      target: LatLng(
        selectedPlace.result!.geometry!.location!.lat!,
        selectedPlace.result!.geometry!.location!.lng!,
      ),
      zoom: 13,
    );
  }

  List<dynamic> places = [];
  FloatingSearchBarController controller = FloatingSearchBarController();

  Completer<GoogleMapController> _mapController = Completer();
  static Position? position;
  static final CameraPosition myCameraPosition = CameraPosition(
    bearing: 0.0,
    target: LatLng(position!.latitude, position!.longitude),
    tilt: 0.0,
    zoom: 17,
  );

  Future<void> getMyCurrentLocation() async {
    position = await LocationHelper.determinePosition().whenComplete(() {
      setState(() {});
    });
  }

  Future<void> goToMyCurrentLocation() async {
    final GoogleMapController controller = await _mapController.future;
    controller.animateCamera(CameraUpdate.newCameraPosition(myCameraPosition));
  }

  Widget buildMap() {
    return GoogleMap(
        mapType: MapType.normal,
        myLocationEnabled: true,
        zoomControlsEnabled: false,
        myLocationButtonEnabled: false,
        initialCameraPosition: myCameraPosition,
        markers: markers,
        onMapCreated: (GoogleMapController controller) {
          _mapController.complete(controller);
        },
        polylines: placeDirections != null
            ? {
          Polyline(
              polylineId: const PolylineId('my_polyline'),
              color: Colors.black,
              width: 2,
              points: polylinePoints),
        }
            : {});
  }

  Widget buildFloatingSearchBar() {
    final isPortrait =
        MediaQuery
            .of(context)
            .orientation == Orientation.portrait;

    return FloatingSearchBar(
      controller: controller,
      elevation: 6,
      hintStyle: TextStyle(
        fontSize: 18,
      ),
      queryStyle: TextStyle(fontSize: 18),
      hint: 'Find a place',
      border: BorderSide.none,
      margins: EdgeInsets.fromLTRB(20, 70, 20, 0),
      padding: EdgeInsets.fromLTRB(2, 0, 2, 0),
      height: 52,
      iconColor: MyColors.blue,
      scrollPadding: EdgeInsets.only(top: 16, bottom: 56),
      transitionDuration: Duration(milliseconds: 600),
      transitionCurve: Curves.easeInOut,
      physics: BouncingScrollPhysics(),
      axisAlignment: isPortrait ? 0.0 : -1,
      openAxisAlignment: 0.0,
      width: isPortrait ? 600 : 500,
      debounceDelay: Duration(milliseconds: 500),
      progress: progressIndicator,
      onQueryChanged: (query) {
        getPlacesSuggestions(query);
      },
      onFocusChanged: (_) {
        setState(() {
          isTimeAndDistanceVisible = false;
        });
      },
      transition: CircularFloatingSearchBarTransition(),
      actions: [
        FloatingSearchBarAction(
          showIfOpened: false,
          child: CircularButton(
            icon: Icon(
              Icons.place_outlined,
              color: Colors.blue.withOpacity(0.6),
            ),
            onPressed: () {},
          ),
        )
      ],
      builder: (context, transition) {
        return ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              buildSuggestionsBloc(),
              buildSelectedPlaceLocationBloc(),

              buildDirectionsBloc()
            ],
          ),
        );
      },
    );
  }

  Widget buildDirectionsBloc() {
    return BlocListener<MapsCubit, MapsStates>(
      listener: (context, state) {
        if (state is DirectionLoaded) {
          placeDirections = (state).placeDirections;

          getPolyLinePoints();
        }
      },
      child: Container(),
    );
  }

  void getPolyLinePoints() {
    polylinePoints = placeDirections!.polylinepoints
        .map((e) => LatLng(e.latitude, e.longitude))
        .toList();
  }

  Widget buildSelectedPlaceLocationBloc() {
    return BlocListener<MapsCubit, MapsStates>(
      listener: (context, state) {
        if (state is PlaceLocationLoaded) {
          selectedPlace = (state).place;

          gotToMySearchedForLocation();
          getDirections();
        }
      },
      child: Container(),
    );
  }

  void getDirections() {
    BlocProvider.of<MapsCubit>(context).emitPlaceDirection(
        LatLng(position!.latitude, position!.longitude),
        LatLng(selectedPlace.result!.geometry!.location!.lat!,
            selectedPlace.result!.geometry!.location!.lng!)
    );
  }

  Future<void> gotToMySearchedForLocation() async {
    buildCameraNewPosition();

    final GoogleMapController controller = await _mapController.future;
    controller
        .animateCamera(CameraUpdate.newCameraPosition(goToSearchForPlace));

    buildSearchedPlaceMarker();
  }

  void buildSearchedPlaceMarker() {
    searchedPlaceMarker = Marker(
      position: goToSearchForPlace.target,
      markerId: MarkerId('1'),
      onTap: () {
        buildCurrentLocationMarker();
        //show time and distance
        setState(() {
          isSearchedPlaceMarkerClicked = true;
          isTimeAndDistanceVisible = true;
        });
      },
      infoWindow: InfoWindow(title: '${placeSuggestion.description}'),
      icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
    );
    addMarkerToMarkersAndUpdateUi(searchedPlaceMarker);
  }

  void buildCurrentLocationMarker() {
    currentLocationMarker = Marker(
      position: LatLng(position!.latitude, position!.longitude),
      markerId: MarkerId('2'),
      onTap: () {},
      infoWindow: InfoWindow(title: 'Your Current Location'),
      icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
    );
    addMarkerToMarkersAndUpdateUi(currentLocationMarker);
  }

  void addMarkerToMarkersAndUpdateUi(Marker marker) {
    setState(() {
      markers.add(marker);
    });
  }

  void getPlacesSuggestions(String query) {
    final sessionToken = Uuid().v4();

    BlocProvider.of<MapsCubit>(context)
        .emitPlacesSuggestions(query, sessionToken);
  }

  Widget buildSuggestionsBloc() {
    return BlocBuilder<MapsCubit, MapsStates>(builder: (context, state) {
      if (state is PlacesLoaded) {
        places = (state).places;
        if (places.length != 0) {
          return buildPlacesList();
        } else {
          return Container();
        }
      } else {
        return Container();
      }
    });
  }

  Widget buildPlacesList() {
    return ListView.builder(
      physics: ClampingScrollPhysics(),
      shrinkWrap: true,
      itemBuilder: (context, index) {
        return InkWell(
          onTap: () async {
            placeSuggestion = places[index];
            controller.close();
            getSelectedPlaceLocation();
            polylinePoints.clear();
            removeAllMarkerAndUpdateUI();

          },
          child: PlaceItem(
            suggestion: places[index],
          ),
        );
      },
      itemCount: places.length,
    );
  }

  void removeAllMarkerAndUpdateUI(){
    setState(() {
      markers.clear();
    });
  }
  void getSelectedPlaceLocation() {
    final sessionToken = Uuid().v4();
    BlocProvider.of<MapsCubit>(context)
        .emitPlaceLocation(placeSuggestion.placeId!, sessionToken);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: MyDrawer(),
      body: Stack(
        fit: StackFit.expand,
        children: [
          position != null
              ? buildMap()
              : Center(
            child: Container(
                child: CircularProgressIndicator(
                  color: Colors.blue,
                )),
          ),
          buildFloatingSearchBar(),
          isSearchedPlaceMarkerClicked ? DistanceAndTime(
            isTimeAndDistanceVisible: isTimeAndDistanceVisible,
            placeDirections: placeDirections,
          ) : Container(),


        ],
      ),
      floatingActionButton: Container(
        margin: EdgeInsets.fromLTRB(0, 0, 8, 10),
        child: FloatingActionButton(
          onPressed: () {
            goToMyCurrentLocation();
          },
          child: Icon(
            Icons.place_outlined,
            color: Colors.blue,
          ),
          backgroundColor: Colors.black,
        ),
      ),
    );
  }
}
