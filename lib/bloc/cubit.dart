import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eventplanner/bloc/states.dart';
import 'package:eventplanner/components/resuables.dart';
import 'package:eventplanner/models/AuthModes/authModes.dart';
import 'package:eventplanner/models/EventsModels/eventModel.dart';
import 'package:eventplanner/models/EventsModels/eventTypes.dart';
import 'package:eventplanner/models/userModel.dart';
import 'package:eventplanner/views/HomeBottomNavigator/homeBottomNavigator.dart';
import 'package:eventplanner/views/LogIn/components.dart';
import 'package:eventplanner/views/SignUp/components.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class EventBloc extends Cubit<States> {
  EventBloc() : super(InitialState());
  static EventBloc GET(BuildContext context) => BlocProvider.of(context);

  void chageVisibilityOfPassword(AuthenticationMode mode) {
    if (mode == AuthenticationMode.Signup) {
      isSecured = !isSecured;
    } else {
      isSecuredLogin = !isSecuredLogin;
    }
    emit(PasswordEntryState());
  }

  Future<void> connectingToFirebase() async {
    eventsCollection = FirebaseFirestore.instance.collection("Events");
    usersCollection = FirebaseFirestore.instance.collection("Users");
    if (FirebaseAuth.instance.currentUser != null) {
      var d = await usersCollection!
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .get();
      eventsIDs = d.data()!["eventIDs"];
    }
  }

  Future signUp(BuildContext context, UserSignUp user) async {
    await FirebaseAuth.instance
        .createUserWithEmailAndPassword(
            email: user.email.toString().trim(),
            password: user.passWord.toString().trim())
        .then((value) async {
      await usersCollection!.doc(FirebaseAuth.instance.currentUser!.uid).set({
        "name": user.userName,
        "email": user.email,
        "eventIDs": []
      }).then((value) => goTo(context, const HomeBottomNavigator()));
    }).catchError((onError) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(onError.message),
        backgroundColor: Colors.red,
      ));
    });
  }

  Future logIn(BuildContext context, UserModel user) async {
    await FirebaseAuth.instance
        .signInWithEmailAndPassword(
            email: user.email.toString().trim(),
            password: user.passWord.toString().trim())
        .then((value) async {
      var d = await usersCollection!
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .get();
      eventsIDs = d.data()!["eventIDs"];
      goTo(context, const HomeBottomNavigator());
    }).catchError((onError) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(onError.code),
        backgroundColor: Colors.red,
      ));
    });
  }

  Future addNewEvent(BuildContext context, Event event) async {
    await eventsCollection!.add(event.toMap()).then((value) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text("Event added successfully"),
        backgroundColor: Colors.green,
      ));
    }).catchError((onError) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(onError.message),
        backgroundColor: Colors.red,
      ));
    });
  }

  Future<List<EventWidget>> getAvailableEvents(BuildContext context) async {
    List<EventWidget> availableEvents = [];
    var d = await eventsCollection!.get();
    for (var document in d.docs) {
      var data = document.data();
      Event event = Event(
          eventID: document.id,
          description: data["description"],
          location: data["location"],
          typeOfEvent: data["typeOfEvent"] == EventType.Lunches.name
              ? EventType.Lunches
              : data["typeOfEvent"] == EventType.Matches.name
                  ? EventType.Matches
                  : EventType.Tournaments,
          date: data["date"],
          attendance: data["attendance"]);
      EventWidget eventWidget = EventWidget(
        event: event,
        isAttended: eventsIDs.contains(document.id),
      );

      availableEvents.add(eventWidget);
    }
    return availableEvents;
  }

  Future attendEventNow(BuildContext context, Event event) async {
    event.attendance += 1;
    await eventsCollection!
        .doc(event.eventID)
        .set(event.toMap())
        .then((value) async {
      eventsIDs!.add(event.eventID!);
      await usersCollection!
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .update({"eventIDs": eventsIDs});
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text("You have reserved your place to attend this event"),
        backgroundColor: Colors.green,
      ));
    }).catchError((onError) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(onError),
        backgroundColor: Colors.red,
      ));
    });
  }

  Future unAttendEventNow(BuildContext context, Event event) async {
    event.attendance -= 1;
    await eventsCollection!
        .doc(event.eventID)
        .set(event.toMap())
        .then((value) async {
      eventsIDs!.remove(event.eventID!);
      await usersCollection!
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .update({"eventIDs": eventsIDs});
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text("You have removed your place in this event"),
        backgroundColor: Colors.green,
      ));
    }).catchError((onError) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(onError),
        backgroundColor: Colors.red,
      ));
    });
  }
}
