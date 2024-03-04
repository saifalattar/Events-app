import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eventplanner/models/EventsModels/eventTypes.dart';
import 'package:flutter/material.dart';

EventType eventType = EventType.Lunches;
TextEditingController location = TextEditingController();
TextEditingController description = TextEditingController();
Timestamp? choosedTime = Timestamp.now();
bool isLoading = false;
