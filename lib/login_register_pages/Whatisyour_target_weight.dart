import 'package:exercai_with_host_try/homepage/starter_page.dart';
import 'package:exercai_with_host_try/recommend_services_try/exercise_service.dart';
import 'package:flutter/material.dart';
import 'package:exercai_with_host_try/main.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';


class WhatisyourTargetWeight extends StatefulWidget {
  const WhatisyourTargetWeight({super.key});

  @override
  State<WhatisyourTargetWeight> createState() => _WhatisyourTargetWeightState();
}
 final TextEditingController targetWeight = TextEditingController();
class _WhatisyourTargetWeightState extends State<WhatisyourTargetWeight> {

  void saveTargetWeightToFirebase() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null && targetWeight.text.isNotEmpty) {
      await FirebaseFirestore.instance
          .collection("Users")
          .doc(user.email)
          .set({
        'targetWeight': targetWeight.text.trim(),
      }, SetOptions(merge: true));

      print("Target Weight saved to Firebase: $targetWeight");
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Please select a target weight before proceeding.")),
      );
    }
  }

  // Example: Call this when generating recommendations


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.backgroundgrey,
      appBar: AppbarSection(),
      resizeToAvoidBottomInset: true,
      body: SingleChildScrollView(
        child: Column(
          children: [
            TextSection(),
            TextFieldSection(),
            SizedBox(
              height: 70,
            ),
            buttonnext(context)
          ],
        ),
      ),
    );
  }

  GestureDetector buttonnext(BuildContext context) {
    return GestureDetector(
          onTap: () async{
            //saveTargetWeightToFirebase();
            //await ExerciseRecommendationService().saveRecommendedExercises();
            Navigator.push(context, MaterialPageRoute(builder: (_) => WelcomeScreen()));
          },
          child: Container(
            child: Column(
              children: [
                Container(
                  height: 55,
                  width: 150,
                  decoration: BoxDecoration(
                      color: AppColor.buttonPrimary.withOpacity(0.7),
                      borderRadius: BorderRadius.circular(50),
                      border: Border.all(
                          width: 2, color: AppColor.buttonSecondary),
                      boxShadow: [
                        BoxShadow(
                            color: AppColor.buttonSecondary.withOpacity(0.7),
                            blurRadius: 90,
                            spreadRadius: 0.1)
                      ]),
                  child: Center(
                      child: Text(
                    "Next",
                    style: TextStyle(
                        color: AppColor.textwhite,
                        fontSize: 20,
                        fontWeight: FontWeight.bold),
                  )),
                ),
              ],
            ),
          ),
        );
  }
}


Container TextFieldSection() {
  return Container(
    decoration: BoxDecoration(
      color: AppColor.primary,
    ),
    child: Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(20.0),
          child: Container(
            child: Column(
              children: [
                Text(
                  "Challenging Goal!",
                  style: TextStyle(
                      color: AppColor.yellowtext,
                      fontSize: 28,
                      fontWeight: FontWeight.bold),
                ),
                SizedBox(
                  height: 10,
                ),
              ],
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(right: 25, left: 25),
          child: Container(
            child: Column(
              children: [
                SizedBox(
                  height: 25,
                ),

                //Textfield kg
                Row(
                  children: [
                    Expanded(
                      child: Container(
                        decoration: BoxDecoration(boxShadow: [
                          BoxShadow(
                              color: AppColor.shadow.withOpacity(0.5),
                              blurRadius: 40,
                              spreadRadius: 0.0)
                        ]),
                        child: TextField(
                          controller: targetWeight,
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                            prefixIcon: Icon(Icons.monitor_weight_outlined),
                            hintText: 'Weight (kg)',
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.transparent),
                              borderRadius: BorderRadius.circular(16),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.transparent),
                              borderRadius: BorderRadius.circular(16),
                            ),
                            filled: true,
                            fillColor: Colors.white,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Container(
                      height: 50,
                      width: 50,
                      decoration: BoxDecoration(
                          color: const Color.fromARGB(255, 32, 32, 32),
                          borderRadius: BorderRadius.circular(12)),
                      child: Center(
                          child: Text(
                        "kg",
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 15,
                            color: AppColor.yellowtext),
                      )),
                    )
                  ],
                ),

                SizedBox(
                  height: 30,
                ),
                Row(
                  children: [
                    Text("You Will lose ",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 17)),
                    Text("26.6%",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 17,color: Colors.red)),
                    Text(" of weight",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 17),)
                  ],
                ),
                //smallGap,
                Row(
                  children: [
                    Container(
                      
                      
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("You can see more significant health benifits:"),
                          Text("- Improved cardio vascular health"),
                          Text("- Reduce the risk of the cancer"),
                        ],
                    
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 60,
                ),
              ],
            ),
          ),
        ),
      ],
    ),
  );
}

Container TextSection() {
  return Container(
    height: 130,
    child: Padding(
      padding: const EdgeInsets.only(left: 25, right: 25, top: 25),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("What is your Target weight?",
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    fontSize: 30)),
            SizedBox(
              height: 10,
            ),
            Expanded(
              child: Text(
                "",
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.grey,
                    fontSize: 15),
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      ),
    ),
  );
}

AppBar AppbarSection() {
  return AppBar(
    centerTitle: true,
    backgroundColor: Colors.transparent,
    leading: GestureDetector(
      onTap: () {},
      child: Row(
        children: [
          Icon(
            Icons.arrow_left,
            color: Colors.yellow,
          ),
          Text(
            "Back",
            style: TextStyle(color: Colors.yellow, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    ),
  );
}
