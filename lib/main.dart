import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:maps_flutter/cubit/maps_cubit.dart';
import 'package:maps_flutter/data/repository/maps_repo.dart';
import 'package:maps_flutter/data/webservices/PlacesWebServices.dart';
import 'package:maps_flutter/presentaion/screens/map_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(

        debugShowCheckedModeBanner: false,
        home: BlocProvider(
          create: (context) => MapsCubit(MapsRepository(PlacesWebServices())),
          child: MapsScreen(),
        )
    );
  }
}

