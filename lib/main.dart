import 'package:eventplanner/bloc/cubit.dart';
import 'package:eventplanner/views/HomeBottomNavigator/homeBottomNavigator.dart';
import 'package:eventplanner/views/SignUp/signUp.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp().then((value) {
    var u = FirebaseAuth.instance.currentUser;
    runApp(BlocProvider<EventBloc>(
      create: (context) => EventBloc()..connectingToFirebase(),
      child: MaterialApp(
        home: u == null ? const SignUp() : const HomeBottomNavigator(),
      ),
    ));
  }).catchError((e) => print(e));
}
