import 'package:flutter/material.dart';
import 'package:maps_flutter/constants/my_colors.dart';
import 'package:maps_flutter/data/models/PlaceSuggestion.dart';

class PlaceItem extends StatelessWidget {

  final PlaceSuggestion suggestion;

   PlaceItem({super.key, required this.suggestion});

  @override
  Widget build(BuildContext context) {
    var subTitle = suggestion.description!.replaceAll(suggestion.description!.split(',')[0], '');

    return Container(
      width: double.infinity,
      margin: EdgeInsetsDirectional.all(8),
      padding: EdgeInsetsDirectional.all(4),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        children: [
          ListTile(
            leading: Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                shape: BoxShape.circle,color: MyColors.lightBlue,
              ),
              child: Icon(Icons.place_outlined,color: MyColors.blue,),
            ),
            title: RichText(
              text: TextSpan(
                children: [
                  TextSpan(
                      text: '${suggestion.description}',
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 18.0,
                          fontWeight: FontWeight.bold
                      )
                  ),
                  TextSpan(
                    text: subTitle.substring(2),
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 16.0,

                    )
                  )

                ],

              ),

            ),
          )
        ],
      ),
    );
  }
}
