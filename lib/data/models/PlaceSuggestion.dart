class PlaceSuggestion{

  String? placeId;
  String? description;

  PlaceSuggestion.fromJson(Map<String,dynamic> json){

    placeId=json['place_id'];
    description=json['description'];
  }
}