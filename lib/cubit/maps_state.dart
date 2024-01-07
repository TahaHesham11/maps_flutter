import 'package:maps_flutter/data/models/place.dart';
import 'package:maps_flutter/data/models/place_directions.dart';

abstract class MapsStates{}

class MapsInitialState extends MapsStates{}

class PlacesLoaded extends MapsStates{

 final List<dynamic> places;

  PlacesLoaded(this.places);

}

class PlaceLocationLoaded extends MapsStates{

 final Place place;

  PlaceLocationLoaded(this.place);

}

class DirectionLoaded extends MapsStates{

 final PlaceDirections placeDirections;

 DirectionLoaded(this.placeDirections);

}