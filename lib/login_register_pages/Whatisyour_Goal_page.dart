import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:exercai_with_host_try/login_register_pages/WhatisTarget_Area_Page.dart';
import 'package:exercai_with_host_try/login_register_pages/injury_selection.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:exercai_with_host_try/main.dart';


class WhatGoalPage extends StatefulWidget {
  const WhatGoalPage({super.key});

  @override
  State<WhatGoalPage> createState() => _WhatGoalPageState();
}

class _WhatGoalPageState extends State<WhatGoalPage> {
  String? selectedGoal;

  void saveGoalToFirebase() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null && selectedGoal != null) {
      await FirebaseFirestore.instance
          .collection("Users")
          .doc(user.email)
          .set({
        'goal': selectedGoal,
      }, SetOptions(merge: true));

      print("Goal saved to Firebase: $selectedGoal");
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Please select a goal before proceeding.")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.backgroundgrey,
      appBar: AppbarSection(),
      body: Column(
        children: [
          TextSection(),
          GoalSelectionSection(),
          SizedBox(height: 75),
          NextButton(context),
        ],
      ),
    );
  }

  GestureDetector NextButton(BuildContext context) {
    return GestureDetector(
      onTap: () {
        saveGoalToFirebase();
        // Navigate to the next screen
        // Navigator.push(context, MaterialPageRoute(builder: (context) => TargetArea()));
          Navigator.push(context, MaterialPageRoute(builder: (context) => InjurySelection()));
      },
      child: Container(
        height: 55,
        width: 150,
        decoration: BoxDecoration(
          color: AppColor.buttonPrimary.withOpacity(0.7),
          borderRadius: BorderRadius.circular(50),
          border: Border.all(width: 2, color: AppColor.buttonSecondary),
          boxShadow: [
            BoxShadow(
              color: AppColor.buttonSecondary.withOpacity(0.7),
              blurRadius: 90,
              spreadRadius: 0.1,
            ),
          ],
        ),
        child: Center(
          child: Text(
            "Next",
            style: TextStyle(
              color: AppColor.textwhite,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }

  Widget GoalSelectionSection() {
    return Container(
      height: 290,
      color: AppColor.primary,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 40),
        child: Column(
          children: [
            GoalOption(
              title: "Lose Weight",
              isSelected: selectedGoal == "lose weight",
              // Change this in the onTap handler
              onTap: () => setState(() {
                selectedGoal = "lose weight"; // Lowercase to match goalTargets key
              }),
            ),
            SizedBox(height: 30),
            GoalOption(
              title: "Muscle Mass Gain",
              isSelected: selectedGoal == "muscle mass gain",
              // Change this in the onTap handler
              onTap: () => setState(() {
                selectedGoal = "muscle mass gain"; // Lowercase to match goalTargets key
              }),
            ),
            SizedBox(height: 30),
            GoalOption(
              title: "Maintain",
              isSelected: selectedGoal == "maintain",
              // Change this in the onTap handler
              onTap: () => setState(() {
                selectedGoal = "maintain"; // Lowercase to match goalTargets key
              }),
            ),
          ],
        ),
      ),
    );
  }

  Widget GoalOption({
    required String title,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 50,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(30),
        ),
        child: Row(
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(left: 25.0),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    title,
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: AppColor.buttonPrimary,
                    ),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(right: 15.0),
              child: Container(
                height: 20,
                width: 20,
                decoration: BoxDecoration(
                  color: isSelected ? AppColor.buttonPrimary : Colors.transparent,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                    width: 2,
                    color: AppColor.buttonPrimary,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

Container TextSection() {
  return Container(
    height: 210,
    child: Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 25),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "What is your Goal?",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.white,
                fontSize: 30,
              ),
            ),
            SizedBox(height: 40),
            Expanded(
              child: Text(
                "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.grey,
                  fontSize: 15,
                ),
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
      onTap: () {
        //Navigator.pop(context);
      },
      child: Row(
        children: [
          Icon(Icons.arrow_left, color: Colors.yellow),
          Text(
            "Back",
            style: TextStyle(
              color: Colors.yellow,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    ),
  );
}
