import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eventplanner/bloc/cubit.dart';
import 'package:eventplanner/bloc/states.dart';
import 'package:eventplanner/components/resuables.dart';
import 'package:eventplanner/components/themesData.dart';
import 'package:eventplanner/models/EventsModels/eventTypes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class Event {
  final String? description, eventID;
  final String location;
  final EventType typeOfEvent;
  final Timestamp date;
  int attendance;

  Event(
      {this.eventID,
      required this.location,
      this.description,
      required this.typeOfEvent,
      required this.date,
      this.attendance = 0});
  Map<String, dynamic> toMap() {
    Map<String, dynamic> data = {
      "typeOfEvent": typeOfEvent.name,
      "description": description,
      "location": location,
      "date": date,
      "attendance": attendance
    };
    return data;
  }
}

class EventWidget extends StatelessWidget {
  final Event event;
  final bool isAttended;
  const EventWidget({super.key, required this.event, required this.isAttended});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => goTo(context, fullPage(context)),
      child: Container(
          width: 300,
          height: 200,
          decoration: BoxDecoration(
              border: Border.all(color: appThemeData.primaryColor, width: 2),
              borderRadius: BorderRadius.circular(20)),
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Center(
                  child: Text(
                    event.typeOfEvent.name,
                    style: appThemeData.textTheme.displayLarge,
                  ),
                ),
                Text(
                  event.description == null
                      ? "No Information"
                      : event.description.toString(),
                  style: appThemeData.textTheme.displayMedium,
                  maxLines: 3,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.location_on,
                          color: greyColor,
                        ),
                        Text(
                          " : ${event.location}",
                          style: appThemeData.textTheme.bodySmall,
                        )
                      ],
                    ),
                    Row(
                      children: [
                        Icon(
                          Icons.calendar_month,
                          color: greyColor,
                        ),
                        Text(
                          " ${event.date.toDate().year}-${event.date.toDate().month}-${event.date.toDate().day}\n ${event.date.toDate().hour}:${event.date.toDate().minute}",
                          style: appThemeData.textTheme.headlineMedium,
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Icon(
                          Icons.people,
                          color: greyColor,
                        ),
                        Text(
                          " : ${event.attendance}",
                          style: appThemeData.textTheme.bodySmall,
                        )
                      ],
                    )
                  ],
                )
              ],
            ),
          )),
    );
  }

  Widget fullPage(BuildContext context) {
    bool isLoading = false;
    return Scaffold(
      appBar: AppBar(
        title: Center(
          child: Text(
            event.typeOfEvent.name,
            style: appThemeData.textTheme.displayLarge,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Event Description :",
                style: appThemeData.textTheme.bodyMedium,
              ),
              Text(
                "${event.description}",
                style: appThemeData.textTheme.displayMedium,
              ),
              spaceBetweenWidgets,
              Text(
                "Event Date :",
                style: appThemeData.textTheme.bodyMedium,
              ),
              spaceBetweenWidgets,
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.location_on,
                        color: greyColor,
                        size: 30,
                      ),
                      Text(
                        " : ${event.location}",
                        style: appThemeData.textTheme.bodySmall,
                      )
                    ],
                  ),
                  Row(
                    children: [
                      Icon(
                        Icons.calendar_month,
                        color: greyColor,
                      ),
                      Text(
                        " ${event.date.toDate().year}-${event.date.toDate().month}-${event.date.toDate().day}\n ${event.date.toDate().hour}:${event.date.toDate().minute}",
                        style: appThemeData.textTheme.headlineMedium,
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Icon(
                        Icons.people,
                        size: 30,
                        color: greyColor,
                      ),
                      Text(
                        " : ${event.attendance}",
                        style: appThemeData.textTheme.bodySmall,
                      )
                    ],
                  )
                ],
              ),
              spaceBetweenWidgets,
              BlocBuilder<EventBloc, States>(builder: (context, state) {
                return isLoading
                    ? const Center(child: CircularProgressIndicator())
                    : ElevatedButton(
                        style: ButtonStyle(
                            backgroundColor: MaterialStatePropertyAll(
                                appThemeData.primaryColor)),
                        onPressed: () async {
                          isLoading = true;
                          EventBloc.GET(context).emit(LoadingState());
                          isAttended
                              ? await EventBloc.GET(context)
                                  .unAttendEventNow(context, event)
                              : await EventBloc.GET(context)
                                  .attendEventNow(context, event);
                          isLoading = false;
                          EventBloc.GET(context).emit(LoadingState());
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Icon(
                              isAttended ? Icons.remove : Icons.add,
                              color: Colors.white,
                            ),
                            Text(
                                isAttended
                                    ? "Remove my reservation"
                                    : "Reserve To Attend",
                                style: appThemeData.textTheme.headlineSmall),
                          ],
                        ));
              })
            ],
          ),
        ),
      ),
    );
  }
}
