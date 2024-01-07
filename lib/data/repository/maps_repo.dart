

import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:maps_flutter/data/models/PlaceSuggestion.dart';
import 'package:maps_flutter/data/models/place.dart';
import 'package:maps_flutter/data/models/place_directions.dart';
import 'package:maps_flutter/data/webservices/PlacesWebServices.dart';

class MapsRepository{

  final PlacesWebServices placesWebServices;

  MapsRepository(this.placesWebServices);


  Future<List<dynamic>>  fetchSuggestions(String place , String sessionToken)async{

   final suggestions = await placesWebServices.fetchSuggestions(place, sessionToken);

   return suggestions.map((suggestions) => PlaceSuggestion.fromJson(suggestions)).toList();

  }



  Future<Place>  getPlaceLocation(String placeId , String sessionToken)async{

  final place  = await placesWebServices.getPlaceLocation(placeId, sessionToken);

  return Place.fromJson(place);

  }


  Future<PlaceDirections>  getDirection(LatLng origin , LatLng destination)async{

    final directions  = await placesWebServices.getDirection(origin, destination);

    return PlaceDirections.fromJson(directions);

  }
}

