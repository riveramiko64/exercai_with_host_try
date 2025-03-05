import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'dart:async';




//global variable
bool staticIsUp = false;
bool staticIsDown = false;
bool warningIndicatorScreen = true;
String warningIndicatorText = "";
String warningIndicatorTextExercise = "";
int raise = 0;
int seconds = 60;
int seconds2 = 30;
Timer? timer;
String ExerciseName = "";
String PrimaryExerciseName = "";
String image = "";
bool isDownPosition = false;
String errorWholebody = "";
int lastUpdateTime = 0;
int lastUpdateTime2 = 0;
int lastUpdateTime3 = 0;
int arcadeNumber = 1;
String Mode = "daysChallenge";
bool youNear = true;
int days = 0;
var peopleBox = Hive.box("Box");
double totalCaloriesBurn = 0;
double totalCaloriesBurnDatabase = 0;

//small Gap

const smallGap = SizedBox(
  height: 15,
);

//large Gap
const largeGap = SizedBox(
  height: 30,
);

extension ShowSnackBar on BuildContext {
  void showErrorMessage(String message) {
    ScaffoldMessenger.of(this).showSnackBar(
      SnackBar(
        content: Text(
          message,
          style: TextStyle(color: Colors.redAccent),
        ),
        backgroundColor: Colors.grey,
      ),
    );
  }
}

//color

/*class AppColor {
  static const Color primary = Color.fromARGB(255, 129, 99, 180);
  static const Color shadow = Color(0xFF5E35B1);
  static const Color solidtext = Color.fromARGB(255, 52, 28, 102);
  static const Color bottonPrimary = Color.fromARGB(255, 51, 51, 51);
  static const Color bottonSecondary = Color.fromARGB(255, 146, 146, 146);
  static const Color textwhite = Color.fromARGB(255, 219, 219, 219);
  static const Color yellowtext = Color.fromARGB(255, 226, 241, 99);
  static const Color purpletext = Color.fromARGB(255, 179, 160, 255);
  static const Color backgroundgrey = Color.fromARGB(255, 30, 30, 30);
}*/
//exercises

final List<Map<String, String>> exercises = [
  {"name": "squat", "image": "squat.gif"},
  {"name": "jumpingjacks", "image": "jumpingjacks.gif"},
  {"name": "legraises", "image": "legraises.gif"},
  {"name": "situp", "image": "situp.gif"},
  {"name": "mountainclimbers", "image": "mountainclimbers.gif"},
  {"name": "highknee", "image": "highknee.gif"},
  {"name": "lunges", "image": "lunges.gif"},
  {"name": "plank", "image": "plank.jpg"},
  {"name": "rightplank", "image": "sideplank.gif"},
  {"name": "leftplank", "image": "sideplank.gif"},
  {"name": "pushup", "image": "pushup.gif"},
];

final List<Map<String, dynamic>> exercises2 = [
  {"name": "squat", "MET": 6},
  {"name": "jumpingjacks", "MET": 8},
  {"name": "legraises", "MET": 3},
  {"name": "situp", "MET": 6},
  {"name": "lunges", "MET": 6},
  {"name": "plank", "MET": 4},
  {"name": "rightplank", "MET": 4},
  {"name": "leftplank", "MET": 4},
  {"name": "pushup", "MET": 7},
  {"name": "highknee", "MET": 9},
  {"name": "mountainclimbers", "MET": 8},
];




class Utils extends StatefulWidget {
  const Utils({super.key});

  @override
  State<Utils> createState() => _UtilsState();
}

class _UtilsState extends State<Utils> {
  @override
  Widget build(BuildContext context) {
    return Scaffold();
  }
}






