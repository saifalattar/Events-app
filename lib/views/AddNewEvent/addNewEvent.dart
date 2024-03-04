import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eventplanner/bloc/cubit.dart';
import 'package:eventplanner/bloc/states.dart';
import 'package:eventplanner/components/resuables.dart';
import 'package:eventplanner/components/themesData.dart';
import 'package:eventplanner/models/EventsModels/eventModel.dart';
import 'package:eventplanner/models/EventsModels/eventTypes.dart';
import 'package:eventplanner/views/AddNewEvent/components.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AddNewEvent extends StatelessWidget {
  const AddNewEvent({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(
          child: Text(
            "Add Event",
            style: appThemeData.textTheme.headlineLarge,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(15),
        child: SingleChildScrollView(
          child: Form(
              child: Column(
            children: [
              BlocBuilder<EventBloc, States>(
                  builder: (context, state) => DropdownMenu(
                          onSelected: (value) {
                            eventType = value!;
                            EventBloc.GET(context).emit(UpdateTypeOfEvent());
                          },
                          dropdownMenuEntries: const [
                            DropdownMenuEntry(
                                value: EventType.Matches, label: "Matches"),
                            DropdownMenuEntry(
                                value: EventType.Lunches, label: "Lunches"),
                            DropdownMenuEntry(
                                value: EventType.Tournaments,
                                label: "Tournaments")
                          ])),
              spaceBetweenWidgets,
              TextFormField(
                  controller: location,
                  decoration: const InputDecoration(
                    labelText: "Location",
                    border: OutlineInputBorder(),
                  ),
                  validator: (data) {
                    if (data!.isEmpty) {
                      return "Please enter the event's location";
                    }
                  }),
              spaceBetweenWidgets,
              TextFormField(
                controller: description,
                maxLines: 4,
                decoration: const InputDecoration(
                  labelText: "Description (optional)",
                  border: OutlineInputBorder(),
                ),
              ),
              spaceBetweenWidgets,
              BlocBuilder<EventBloc, States>(
                  builder: (context, state) => Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Row(
                            children: [
                              Icon(
                                Icons.calendar_month,
                                color: greyColor,
                              ),
                              Text(
                                " ${choosedTime!.toDate().year}-${choosedTime!.toDate().month}-${choosedTime!.toDate().day}\n ${choosedTime!.toDate().hour}:${choosedTime!.toDate().minute}",
                                style: appThemeData.textTheme.headlineMedium,
                              ),
                            ],
                          ),
                          ElevatedButton(
                              onPressed: () async {
                                await showDatePicker(
                                        context: context,
                                        firstDate: DateTime.now(),
                                        lastDate: DateTime(2027))
                                    .then((date) async {
                                  await showTimePicker(
                                          context: context,
                                          initialTime: TimeOfDay.now())
                                      .then((time) {
                                    choosedTime = Timestamp.fromDate(DateTime(
                                        date!.year,
                                        date.month,
                                        date.day,
                                        time!.hour,
                                        time.minute));
                                    EventBloc.GET(context)
                                        .emit(UpdateTimeState());
                                  });
                                });
                              },
                              child: const Text("Choose"))
                        ],
                      )),
              const SizedBox(
                height: 50,
              ),
              BlocBuilder<EventBloc, States>(
                  builder: (context, state) => isLoading
                      ? const CircularProgressIndicator()
                      : ElevatedButton(
                          style: ButtonStyle(
                              backgroundColor: MaterialStatePropertyAll(
                                  appThemeData.primaryColor)),
                          onPressed: () async {
                            isLoading = true;
                            EventBloc.GET(context).emit(LoadingState());
                            Event event = Event(
                                location: location.text,
                                typeOfEvent: eventType,
                                date: choosedTime!,
                                description: description.text);
                            await EventBloc.GET(context)
                                .addNewEvent(context, event)
                                .then((value) {
                              isLoading = false;
                              EventBloc.GET(context).emit(LoadingState());
                            }).catchError((onError) {
                              isLoading = false;
                              EventBloc.GET(context).emit(LoadingState());
                            });
                          },
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              const Icon(
                                Icons.post_add_outlined,
                                color: Colors.white,
                              ),
                              Text(
                                "Create Event Now",
                                style: appThemeData.textTheme.headlineSmall,
                              ),
                            ],
                          )))
            ],
          )),
        ),
      ),
    );
  }
}
