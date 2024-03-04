import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

CollectionReference<Map<String, dynamic>>? usersCollection, eventsCollection;
List eventsIDs = [];
Widget spaceBetweenWidgets = const SizedBox(
  height: 30,
);
void goTo(BuildContext context, Widget nextScreen) => Navigator.push(
    context, MaterialPageRoute(builder: (context) => nextScreen));
