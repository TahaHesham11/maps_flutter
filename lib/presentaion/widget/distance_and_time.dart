import 'package:flutter/material.dart';
import 'package:maps_flutter/constants/my_colors.dart';
import 'package:maps_flutter/data/models/place_directions.dart';

class DistanceAndTime extends StatelessWidget {
  final PlaceDirections? placeDirections;

  const DistanceAndTime(
      {super.key,
      this.placeDirections,
      required this.isTimeAndDistanceVisible});

  final bool isTimeAndDistanceVisible;

  @override
  Widget build(BuildContext context) {
    return Visibility(
        visible: isTimeAndDistanceVisible,
        child: Positioned(
          top: 0.0,
          bottom: 430,
          left: 0.0,
          right: 0.0,
          child: Row(
            children: [
              Flexible(
                  flex: 1,
                  child: Card(
                    elevation: 6,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    margin: EdgeInsets.fromLTRB(20, 50, 20, 0),
                    color: Colors.white,
                    child: ListTile(
                      dense: true,
                      horizontalTitleGap: 0,
                      leading: Icon(
                        Icons.access_time_filled,
                        color: MyColors.blue,
                        size: 30,
                      ),
                      title: Text(
                        placeDirections!.totalDuration,
                        style: TextStyle(
                          color: Colors.blue,
                          fontSize: 16,
                          overflow: TextOverflow.ellipsis,
                        ),
                        maxLines: 1,
                      ),
                    ),
                  )
              ),
              SizedBox(width: 30,),
              Flexible(
                  flex: 1,
                  child: Card(
                    elevation: 6,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    margin: EdgeInsets.fromLTRB(20, 50, 20, 0),
                    color: Colors.white,
                    child: ListTile(
                      dense: true,
                      horizontalTitleGap: 0,
                      leading: Icon(
                        Icons.directions_car_filled,
                        color: MyColors.blue,
                        size: 30,
                      ),
                      title: Text(
                        placeDirections!.totalDistance,
                        style: TextStyle(
                          color: Colors.blue,
                          fontSize: 16,
                          overflow: TextOverflow.ellipsis,
                        ),
                        maxLines: 1,
                      ),
                    ),
                  )
              ),

            ],
          ),
        ));
  }
}
