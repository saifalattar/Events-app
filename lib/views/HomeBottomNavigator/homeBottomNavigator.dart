import 'package:eventplanner/bloc/cubit.dart';
import 'package:eventplanner/bloc/states.dart';
import 'package:eventplanner/components/resuables.dart';
import 'package:eventplanner/components/themesData.dart';
import 'package:eventplanner/views/AddNewEvent/addNewEvent.dart';
import 'package:eventplanner/views/HomeBottomNavigator/components.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomeBottomNavigator extends StatefulWidget {
  const HomeBottomNavigator({super.key});

  @override
  State<HomeBottomNavigator> createState() => _HomeBottomNavigatorState();
}

class _HomeBottomNavigatorState extends State<HomeBottomNavigator> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<EventBloc, States>(builder: (context, state) {
      return Scaffold(
        appBar: null,
        floatingActionButton: Padding(
          padding: const EdgeInsets.all(15.0),
          child: FloatingActionButton(
            backgroundColor: appThemeData.primaryColor,
            onPressed: () {
              goTo(context, const AddNewEvent());
            },
            child: const Icon(
              Icons.add,
              color: Colors.white,
            ),
          ),
        ),
        body: pages[pageIndex],
        bottomNavigationBar: BottomNavigationBar(
            elevation: 20,
            unselectedLabelStyle: const TextStyle(color: Colors.black),
            selectedLabelStyle: const TextStyle(color: Colors.black),
            onTap: (page) {
              setState(() {
                pageIndex = page;
              });
            },
            currentIndex: pageIndex,
            items: [
              BottomNavigationBarItem(
                  tooltip: "Events",
                  activeIcon: Icon(
                    Icons.event_outlined,
                    color: appThemeData.primaryColor,
                  ),
                  icon: Icon(
                    Icons.event,
                    color: appThemeData.primaryColor.withOpacity(0.4),
                  ),
                  label: "Events"),
              BottomNavigationBarItem(
                  activeIcon: Icon(
                    Icons.settings_outlined,
                    color: appThemeData.primaryColor,
                  ),
                  icon: Icon(
                    Icons.settings,
                    color: appThemeData.primaryColor.withOpacity(0.4),
                  ),
                  tooltip: "Settings",
                  label: "Settings")
            ]),
      );
    });
  }
}
