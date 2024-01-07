class Place{

  Result? result;

  Place.fromJson(dynamic json){

    result = Result.fromJson(json['result']);
  }

}
class Result{

  Geometry? geometry;

  Result.fromJson(dynamic json){

    geometry = Geometry.fromJson(json['geometry']);
  }

}
class Geometry{

  Location? location;
  Geometry.fromJson(dynamic json){
    location = Location.fromJson(json['location']);
  }
}

class Location{

  double? lat;
  double? lng;

  Location.fromJson(dynamic json){

    lat= json['lat'];
    lng= json['lng'];

  }

}