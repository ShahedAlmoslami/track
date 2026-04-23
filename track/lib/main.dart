import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:track/logic/fav/cubit.dart';
import 'package:track/presentaion/screen/admin/add_dish_screen.dart';
import 'package:track/presentaion/screen/admin/add_item_screen.dart';
import 'package:track/presentaion/screen/admin/add_experience_screen.dart';
import 'package:track/presentaion/screen/admin/add_hotel_screen.dart';
import 'package:track/presentaion/screen/admin/add_place_screen.dart';
import 'package:track/presentaion/screen/admin/updateFire.dart';
import 'package:track/presentaion/screen/book.dart';
import 'package:track/presentaion/screen/details.dart';
import 'package:track/presentaion/screen/fav_screen.dart';
import 'package:track/presentaion/screen/home_screen.dart';
import 'package:track/presentaion/screen/sign_up_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => FavoriteCubit(),
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: HomeScreen(),
      ),
    );
  }
}