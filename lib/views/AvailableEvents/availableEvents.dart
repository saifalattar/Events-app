import 'package:eventplanner/bloc/cubit.dart';
import 'package:eventplanner/bloc/states.dart';
import 'package:eventplanner/components/resuables.dart';
import 'package:eventplanner/components/themesData.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AvailableEvents extends StatelessWidget {
  const AvailableEvents({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<EventBloc, States>(builder: (context, state) {
      return Scaffold(
          appBar: AppBar(
            leading: Container(),
            title: Center(
              child: Text(
                "Events",
                style: appThemeData.textTheme.headlineLarge,
              ),
            ),
          ),
          body: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15.0),
            child: FutureBuilder(
                future: EventBloc.GET(context).getAvailableEvents(context),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return ListView.separated(
                        itemBuilder: (context, index) => snapshot.data![index],
                        separatorBuilder: (context, index) =>
                            spaceBetweenWidgets,
                        itemCount: snapshot.data!.length);
                  }
                  return const Center(child: CircularProgressIndicator());
                }),
          ));
    });
  }
}
