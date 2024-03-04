# eventplanner

A new Flutter project.

# Project Architecture

## bloc (directory) :
  ### - cubit.dart
      this file contains the bloc state management class that holds the whole app logic and functions.
  ### - states.dart
      this file contains the states abstract class and child classes states to be used while updating states in the app.

## components (directory)
  ### - reusables.dart
      contains the most reusable global components (variables, widgets, and functions). 
  ### - themesData.dart
      contains the theme data of the app such as the text styles for many kinds of texts types and colors to make a harmony between colors.

## models (directory)
  ### - AuthModes (directory)
  #### -- authModes.dart
      this file contains an enum of the authentication modes (LogIn, SignUp).
      
  ### - EventsModels (directory)
  #### -- eventModels.dart 
      this contains the classes that represents the Events data and interfaces and they will appear and interact with user's actions.
  #### -- eventModes.dart
      contains ans enum of the three types of Events.
  
  ### - userModel.dart
      contains the class that represents the user model in two types (UserSignUp, UserLogIn) in the app. 

  
## views (directory)
### - AddNewEvent (directory)
#### -- addNewEvent.dart 
    contains the screen of adding new event to the public.
#### -- components.dart
    contains all the components that the adding new event process will need.
    
### - AvailableEvents (directory)
#### -- availableEvents.dart 
    contains the screen of displaying all the available events.

### - HomeBottomNavigator (directory)
#### -- homeBottomNavigator.dart 
    contains the main screen with bottom navigation bar to navigate between events and settings.
#### -- components.dart
    contains all the components that homeBottomNavigator widget will need.
    
### - LogIn (directory)
#### -- logIn.dart 
    contains the widget of logging in screen for user use.
#### -- components.dart
    contains all the components for logging in process.
    
### - Settings (directory)
#### -- settings.dart 
    contains the widget of displaying the settings in the app.
    
### - SignUp (directory)
#### -- signUp.dart 
    contains the widget of signing up screen for user use.
#### -- components.dart
    contains all the components for signing up process.

## main.dart : the main file for running the material app.

## Demo Video : contains the demo video.
