import 'package:exercai_with_host_try/components/my_drawer.dart';
import 'package:exercai_with_host_try/exercise_posture/exerciseposturepage1.dart';
import 'package:exercai_with_host_try/local_notification/reminder_settings.dart';
import 'package:exercai_with_host_try/profile_pages/profile_page.dart';
import 'package:exercai_with_host_try/main.dart';
import 'package:exercai_with_host_try/progress_tracking/progress_tracking..dart';
import 'package:exercai_with_host_try/show_firestore_exercises_download/show_screen_get_in_firestore/filter_exercises.dart';
import 'package:exercai_with_host_try/show_firestore_exercises_download/show_with_reps_kcals/filter_reps_kcal.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:exercai_with_host_try/local_notification/reminder_settings.dart';

class MainLandingPage extends StatefulWidget {
  const MainLandingPage({super.key});

  @override
  State<MainLandingPage> createState() => _MainLandingPageState();
}

class _MainLandingPageState extends State<MainLandingPage> {

  final User? currentUser = FirebaseAuth.instance.currentUser;

  // Future to fetch user details
  Future<DocumentSnapshot<Map<String, dynamic>>> getUserDetails() async {
    return await FirebaseFirestore.instance
        .collection("Users")
        .doc(currentUser?.email)
        .get();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.backgroundgrey,
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.white),
        backgroundColor: AppColor.backgroundgrey,
        //automaticallyImplyLeading: false, // Remove back button
        elevation: 0,
        title: //const Text('Hi, User', style: TextStyle(color: AppColor.purpletext, fontSize: 25, fontWeight: FontWeight.bold),),
        StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
          stream: FirebaseFirestore.instance
              .collection('Users')
              .doc(currentUser?.email)
              .snapshots(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return CircularProgressIndicator();
            } else if (snapshot.hasError) {
              return Text("Error fetching name", style: TextStyle(color: Colors.white));
            } else if (!snapshot.hasData || !snapshot.data!.exists) {
              return Text(
                "Hi, User",
                style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold, color: AppColor.primary),
              );
            }

            // Extract user's first name in real-time
            Map<String, dynamic>? userData = snapshot.data!.data();
            String firstName = userData?['firstname'] ?? 'User';

            return Text(
              "Hi, $firstName",
              style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold, color: AppColor.primary),
            );
          },
        ),

        actions: [

          IconButton(
            icon: const Icon(Icons.notifications, color: AppColor.purpletext),
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(Icons.person, color: AppColor.purpletext),
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (context)=> ProfilePage()));
            },
          ),
        ],
      ),

      drawer: MyDrawer(),

      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(left: 16,top: 5,right: 16,bottom: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "It's time to challenge your limits.",
                style: const TextStyle(color: Colors.white, fontSize: 14),
              ),
              const SizedBox(height: 20,),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  GestureDetector(
                    onTap: () {
                      Navigator.push(context, MaterialPageRoute(
                          builder: (context) => ReminderSettings()));
                    },

                    child: Column(
                      children: [Icon(Icons.alarm,color: AppColor.yellowtext, size: 35),
                        const SizedBox(height: 8),
                        Text("Set Reminder", style: const TextStyle(color: Colors.white, fontSize: 14),),
                      ],
                    ),
                  ),
                  GestureDetector(onTap: (){Navigator.push(context, MaterialPageRoute(builder: (context)=>ProgressTrackingScreen()));},
                    child: Column(
                      children: [Icon(Icons.insert_chart,color: AppColor.yellowtext, size: 35),
                        const SizedBox(height: 8),
                        Text("Progress Tracking", style: const TextStyle(color: Colors.white, fontSize: 14),),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              const Text(
                'Features',
                style: TextStyle(
                  color: AppColor.yellowtext,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 20),
              GestureDetector(
                child: _buildFeatureCard(
                  'Posture Correction Exercises',
                  'Sample Exercises with\nPosture Correction',
                  AppColor.purpletext,
                  Colors.white,
                  'assets/gym8.jpg',
                ),
                onTap: (){
                  //Navigator.push(context, MaterialPageRoute(builder: (context)=> ExePosturePage1()));
                },
              ),
              const SizedBox(height: 20),
              GestureDetector(
                child: _buildFeatureCard(
                  'Exercise Recommendations',
                  'Recommendation Exercises Especially For You',
                  Colors.black,
                  Colors.white,
                  'assets/gym6.jpg',
                ),
                onTap: (){
                 // Navigator.push(context, MaterialPageRoute(builder: (context)=> FilterExerciseFirestore()));
                  Navigator.push(context, MaterialPageRoute(builder: (context)=> FilterRepsKcal()));

                },
              ),
              const SizedBox(height: 20),
              GestureDetector(
                child: _buildFeatureCard(
                  'Arcade Mode',
                  'Challenge Yourself While EnjoyingPosture Correction Exercises',
                  AppColor.purpletext,
                  Colors.white,
                  'assets/gym4.png',
                ),
                onTap: (){
                  //Navigator.push(context, MaterialPageRoute(builder: (context)=> ExePosturePage1()));
                },
              ),
            ],
          ),
        ),
      ),
    );
  }



  Widget _buildFeatureCard(String title, String subtitle, Color bgColor, Color textColor, String imagePath) {
    return Container(
      height: 140,
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        children: [
          Expanded(
            flex: 3,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      color: textColor,
                      fontSize: 23,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    subtitle,
                    style: TextStyle(
                      color: textColor,
                      fontSize: 15,
                    ),
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: ClipRRect(
              borderRadius: const BorderRadius.all(Radius.circular(20)),
              child: Image.asset(
                imagePath,
                fit: BoxFit.cover,
                height: 140,
                width: double.infinity,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    color: Colors.grey,
                    child: const Center(
                      child: Icon(
                        Icons.broken_image,
                        color: Colors.white,
                        size: 40,
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
