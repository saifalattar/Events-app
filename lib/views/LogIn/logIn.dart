import 'package:eventplanner/bloc/cubit.dart';
import 'package:eventplanner/bloc/states.dart';
import 'package:eventplanner/components/resuables.dart';
import 'package:eventplanner/components/themesData.dart';
import 'package:eventplanner/models/AuthModes/authModes.dart';
import 'package:eventplanner/models/userModel.dart';
import 'package:eventplanner/views/LogIn/components.dart';
import 'package:eventplanner/views/SignUp/signUp.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LogIn extends StatelessWidget {
  const LogIn({super.key});

  @override
  Widget build(BuildContext context) {
    bool isLoading = false;
    return BlocBuilder<EventBloc, States>(builder: (context, state) {
      return Scaffold(
        appBar: null,
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(15.0),
            child: Form(
                key: formKeyLogin,
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      Text("Log In\n",
                          style: appThemeData.textTheme.headlineLarge),
                      TextFormField(
                          decoration: const InputDecoration(
                            labelText: "E-Mail",
                            border: OutlineInputBorder(),
                          ),
                          controller: emailLogin,
                          validator: (data) {
                            if (data!.isEmpty) {
                              return "Please enter your E-mail";
                            }
                          }),
                      spaceBetweenWidgets,
                      TextFormField(
                        controller: passwordLogin,
                        obscureText: isSecuredLogin,
                        decoration: InputDecoration(
                            labelText: "Password",
                            border: const OutlineInputBorder(),
                            suffix: IconButton(
                                onPressed: () {
                                  EventBloc.GET(context)
                                      .chageVisibilityOfPassword(
                                          AuthenticationMode.LogIn);
                                },
                                icon: isSecuredLogin
                                    ? const Icon(Icons.visibility)
                                    : const Icon(Icons.visibility_off))),
                        validator: (data) {
                          if (data!.isEmpty) {
                            return "Please enter a new password";
                          } else if (data.length < 10) {
                            return "Password length must be 10 characters or more";
                          }
                        },
                      ),
                      const SizedBox(
                        height: 50,
                      ),
                      TextButton(
                          onPressed: () {
                            goTo(context, SignUp());
                          },
                          child: Text(
                            "Don't have? Create a new account",
                            style: TextStyle(
                                color: appThemeData.primaryColor,
                                decoration: TextDecoration.underline),
                          )),
                      isLoading
                          ? const CircularProgressIndicator()
                          : ElevatedButton(
                              style: ButtonStyle(
                                  backgroundColor: MaterialStatePropertyAll(
                                      appThemeData.primaryColor)),
                              onPressed: () async {
                                if (formKeyLogin.currentState!.validate()) {
                                  isLoading = true;
                                  EventBloc.GET(context).emit(LoadingState());

                                  UserModel user = UserLogIn(
                                      email: emailLogin.text,
                                      passWord: passwordLogin.text);
                                  await EventBloc.GET(context)
                                      .logIn(context, user)
                                      .then((value) {
                                    isLoading = false;
                                    EventBloc.GET(context).emit(LoadingState());
                                  }).catchError((onError) {
                                    isLoading = false;
                                    EventBloc.GET(context).emit(LoadingState());
                                  });
                                }
                              },
                              child: Text(
                                "Log In",
                                style: appThemeData.textTheme.headlineSmall,
                              )),
                    ],
                  ),
                )),
          ),
        ),
      );
    });
  }
}
