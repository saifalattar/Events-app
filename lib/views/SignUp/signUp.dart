import 'package:eventplanner/bloc/cubit.dart';
import 'package:eventplanner/bloc/states.dart';
import 'package:eventplanner/components/resuables.dart';
import 'package:eventplanner/components/themesData.dart';
import 'package:eventplanner/models/AuthModes/authModes.dart';
import 'package:eventplanner/models/userModel.dart';
import 'package:eventplanner/views/LogIn/logIn.dart';
import 'package:eventplanner/views/SignUp/components.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SignUp extends StatelessWidget {
  const SignUp({super.key});

  @override
  Widget build(BuildContext context) {
    bool isLoading = false;
    return BlocBuilder<EventBloc, States>(
        builder: (context, states) => Scaffold(
              appBar: null,
              body: SafeArea(
                child: Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: Form(
                      key: formKey,
                      child: SingleChildScrollView(
                        child: Column(
                          children: [
                            Text(
                              "Sign Up\n",
                              style: appThemeData.textTheme.headlineLarge,
                            ),
                            TextFormField(
                              decoration: const InputDecoration(
                                  border: OutlineInputBorder(),
                                  labelText: "Username"),
                              controller: name,
                              validator: (data) {
                                if (data!.isEmpty) {
                                  return "Please enter your full-name";
                                }
                              },
                            ),
                            spaceBetweenWidgets,
                            TextFormField(
                                decoration: const InputDecoration(
                                    border: OutlineInputBorder(),
                                    labelText: "E-Mail"),
                                controller: email,
                                validator: (data) {
                                  if (data!.isEmpty) {
                                    return "Please enter your E-mail";
                                  }
                                }),
                            spaceBetweenWidgets,
                            TextFormField(
                              controller: password,
                              obscureText: isSecured,
                              decoration: InputDecoration(
                                  labelText: "Password",
                                  border: const OutlineInputBorder(),
                                  suffix: IconButton(
                                      onPressed: () {
                                        EventBloc.GET(context)
                                            .chageVisibilityOfPassword(
                                                AuthenticationMode.Signup);
                                      },
                                      icon: isSecured
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
                                  goTo(context, const LogIn());
                                },
                                child: Text(
                                  "Already have an account",
                                  style: TextStyle(
                                      color: appThemeData.primaryColor,
                                      decoration: TextDecoration.underline),
                                )),
                            isLoading
                                ? const CircularProgressIndicator()
                                : ElevatedButton(
                                    style: ButtonStyle(
                                        backgroundColor:
                                            MaterialStatePropertyAll(
                                                appThemeData.primaryColor)),
                                    onPressed: () async {
                                      if (formKey.currentState!.validate()) {
                                        isLoading = true;
                                        EventBloc.GET(context)
                                            .emit(LoadingState());
                                        UserSignUp user = UserSignUp(
                                            userName: name.text,
                                            email: email.text,
                                            passWord: password.text);
                                        await EventBloc.GET(context)
                                            .signUp(context, user)
                                            .then((value) {
                                          isLoading = false;
                                          EventBloc.GET(context)
                                              .emit(LoadingState());
                                        }).catchError((onError) {
                                          isLoading = false;
                                          EventBloc.GET(context)
                                              .emit(LoadingState());
                                        });
                                      }
                                    },
                                    child: Text(
                                      "Sign Up",
                                      style:
                                          appThemeData.textTheme.headlineSmall,
                                    ))
                          ],
                        ),
                      )),
                ),
              ),
            ));
  }
}
