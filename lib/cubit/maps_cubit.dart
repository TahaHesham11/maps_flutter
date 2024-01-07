import 'package:bloc/bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:maps_flutter/cubit/maps_state.dart';
import 'package:maps_flutter/data/repository/maps_repo.dart';

class MapsCubit extends Cubit<MapsStates>{

  final MapsRepository mapsRepository;

  MapsCubit(this.mapsRepository) : super (MapsInitialState());


  void emitPlacesSuggestions(String place , String sessionToken){

    mapsRepository.fetchSuggestions(place, sessionToken).then((suggestions) {

      emit(PlacesLoaded(suggestions));
    });

  }


  void emitPlaceLocation(String placeId , String sessionToken){

    mapsRepository.getPlaceLocation(placeId, sessionToken).then((place) {

      emit(PlaceLocationLoaded(place));
    });
  }

  void emitPlaceDirection(LatLng origin , LatLng destination){

    mapsRepository.getDirection(origin, destination).then((directions) {

      emit(DirectionLoaded(directions));
    });
  }
}