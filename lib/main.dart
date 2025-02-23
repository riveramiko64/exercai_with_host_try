import 'package:exercai_with_host_try/auth/login_or_register.dart';
import 'package:exercai_with_host_try/login_register_pages/Whatisyour_Goal_page.dart';
import 'package:exercai_with_host_try/login_register_pages/Whatisyour_target_weight.dart';
import 'package:exercai_with_host_try/login_register_pages/createaccount.dart';
import 'package:exercai_with_host_try/login_register_pages/login.dart';
import 'package:exercai_with_host_try/profile_pages/profile_page.dart';
import 'package:exercai_with_host_try/homepage/starter_page.dart';
import 'package:exercai_with_host_try/login_register_pages/welcome.dart';
import 'package:exercai_with_host_try/progress_tracking/progress_tracking..dart';
import 'package:exercai_with_host_try/show_all_exercises/exercise_show.dart';
import 'package:exercai_with_host_try/show_firestore_exercises_download/download_button_exercises_firebase.dart';
import 'package:exercai_with_host_try/show_firestore_exercises_download/exercise_download_firebase.dart';
import 'package:exercai_with_host_try/show_firestore_exercises_download/show_screen_get_in_firestore/exercise_firestore_list_screen.dart';
import 'package:exercai_with_host_try/show_firestore_exercises_download/show_screen_get_in_firestore/filter_exercises.dart';
import 'package:exercai_with_host_try/show_firestore_exercises_download/show_with_reps_kcals/filter_reps_kcal.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'firebase_options.dart';
import 'login_register_pages/mainlandingpage.dart';
import 'auth/login_or_register.dart';
import 'workout_complete/workoutcomplete.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {

  /*@override
  void initState() {
    super.initState();
    fetchAndStoreBodyweightExercises(); // Calls only if Firestore is empty
  }*/

  Future<bool> isUserLoggedIn() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.containsKey('user_token');
  }

  Future<void> logout(BuildContext context) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('user_token');
    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => LoginOrRegister()));
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<bool>(
      future: isUserLoggedIn(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const MaterialApp(
            home: Scaffold(
              body: Center(child: CircularProgressIndicator()),
            ),
          );
        }

        bool isLoggedIn = snapshot.data ?? false;
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          //home: isLoggedIn ? MainLandingPage() : LoginOrRegister(),
          //home: LoginOrRegister(),
          home: ProgressTrackingScreen(),
          //home: CompleteWorkout(),
          //home: FilterRepsKcal(),
          //home: ExerciseApp(),
          //home: ButtonDownloadExercises(),
          //home: ExerciseFirestore(),
          //home: FilterExerciseFirestore(),

          routes: {
            '/login_register_page': (context) => LoginOrRegister(),
            '/home_page': (context) => MainLandingPage(),
            '/profile_page': (context) => ProfilePage(),
          },
        );
      },
    );
  }
}

class AppColor {
  static const Color primary = Color(0xFF9575CD);
  static const Color shadow = Color(0xFF5E35B1);
  static const Color solidtext = Color.fromARGB(255, 52, 28, 102);
  static const Color buttonPrimary = Color.fromARGB(255, 51, 51, 51);
  static const Color buttonSecondary = Color.fromARGB(255, 146, 146, 146);
  static const Color textwhite = Color.fromARGB(255, 219, 219, 219);
  static const Color yellowtext = Color.fromARGB(255, 226, 241, 99);
  static const Color purpletext = Color.fromARGB(255, 179, 160, 255);
  static const Color backgroundgrey = Color.fromARGB(255, 19, 19, 19);
}
