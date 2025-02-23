import 'package:exercai_with_host_try/main.dart';
import 'package:flutter/material.dart';
import 'package:exercai_with_host_try/show_firestore_exercises_download/show_with_reps_kcals/filter_reps_kcal.dart';

class CompleteWorkout extends StatefulWidget {
  const CompleteWorkout({super.key});

  @override
  State<CompleteWorkout> createState() => _CompleteWorkoutState();
}

class _CompleteWorkoutState extends State<CompleteWorkout> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 0,
        /*leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            // Handle back button action
          },
        ),*/
      ),
      body: Column(
        children: [
          Expanded(
            flex: 2,
            child: Container(
              padding: const EdgeInsets.only(left: 40,top: 0,right: 40,bottom: 40),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Image.asset(
                  'assets/congrats.jpg',
                  fit: BoxFit.cover,
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
          ),
          Expanded(
            flex: 1,
            child: Container(
              color: AppColor.yellowtext,
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 32.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    'Congratulations!',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'You Have Finished Your Workout',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 20,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white, // Background color
                      borderRadius: BorderRadius.circular(12), // Rounded corners
                    ),// White background for the row
                    padding: const EdgeInsets.all(8), // Add padding around the row content
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        Icon(Icons.directions_run_rounded, color: Colors.black, size: 16),
                        SizedBox(width: 4),
                        Text(
                          '10-15 Repetitions',
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 15,
                          ),
                        ),
                        SizedBox(width: 16),
                        Icon(Icons.local_fire_department, color: Colors.black, size: 16),
                        SizedBox(width: 4),
                        Text(
                          '5-7 Kcal',
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 15,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),

          Expanded(
            flex: 1,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    // Update the ElevatedButton's onPressed:
                    onPressed: () {
                      Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(builder: (context) => FilterRepsKcal()),
                            (Route<dynamic> route) => false,
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColor.purpletext,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(40),
                      ),
                      padding: const EdgeInsets.only(left: 50,top: 20,right: 50,bottom: 20),
                    ),
                    child: const Text(
                      'Go to the next workout',
                      style: TextStyle(color: Colors.white, fontSize: 18),
                    ),
                  ),
                  /*
                  ElevatedButton(
                    onPressed: () {
                      // Handle "Home" action
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColor.yellowtext,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(40),
                      ),
                      padding: const EdgeInsets.only(left: 115,top: 20,right: 115,bottom: 20),
                    ),
                    child: const Text(
                      'Home',
                      style: TextStyle(color: AppColor.purpletext, fontSize: 18),
                    ),
                  ),
                  */
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
