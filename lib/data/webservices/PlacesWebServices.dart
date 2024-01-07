import 'package:dio/dio.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:maps_flutter/constants/strings.dart';

class PlacesWebServices{

  Dio? dio;

  PlacesWebServices(){
    BaseOptions options = BaseOptions(
      connectTimeout: Duration(milliseconds: 750),
      receiveTimeout: Duration(milliseconds: 750),
      receiveDataWhenStatusError: true,
    );

    dio = Dio(options);
  }

  Future<List<dynamic>>  fetchSuggestions(String place , String sessionToken)async{

    try{
      Response response = await dio!.get(suggestionsBaseUrl, queryParameters: {
        'input': place,
        'type' : 'address',
        'components' : 'country:eg',
        'key': googleAPIKey,
        'sessiontoken': sessionToken,
      });
      print(response.data['predictions']);
      print(response.statusCode);
      return response.data['predictions'];

    }
    catch(error){
      print(error.toString());
      return [];
    }

  }


  Future<dynamic>  getPlaceLocation(String placeId , String sessionToken)async{

    try{
      Response response = await dio!.get(
          placeLocationBaseUrl,
          queryParameters: {
        'place_id': placeId,
        'fields' : 'geometry',
        'key': googleAPIKey,
        'sessiontoken': sessionToken,
      });

      return response.data;

    }
    catch(error){
      print(error.toString());
      return Future.error('Place location error : ' , StackTrace.fromString('this is its trace'));
    }

  }


  Future<dynamic>  getDirection(LatLng origin , LatLng destination)async{

    try{
      Response response = await dio!.get(
          directionBaseUrl,
          queryParameters: {
            'origin': '${origin.latitude},${origin.longitude}',
            'destination' : '${destination.latitude},${destination.longitude}',
            'key': googleAPIKey,
          });

      print(response.data);
      return response.data;

    }
    catch(error){
      print(error.toString());
      return Future.error('Place location error : ' , StackTrace.fromString('this is its trace'));
    }

  }


}