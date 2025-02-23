import 'package:flutter/material.dart';
import 'package:exercai_with_host_try/main.dart';
import 'profile_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart'; // For date formatting

class ProfilePageProfile extends StatefulWidget {
  @override
  _ProfilePageProfileState createState() => _ProfilePageProfileState();
}

class _ProfilePageProfileState extends State<ProfilePageProfile> {
  TextEditingController firstNameController = TextEditingController();
  TextEditingController lastNameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController mobileNumberController = TextEditingController();
  TextEditingController dobController = TextEditingController();
  TextEditingController weightController = TextEditingController();
  TextEditingController heightController = TextEditingController();
  bool _isDataLoaded = false;

  final User? currentUser = FirebaseAuth.instance.currentUser;

  @override
  void dispose() {
    firstNameController.dispose();
    lastNameController.dispose();
    emailController.dispose();
    mobileNumberController.dispose();
    dobController.dispose();
    weightController.dispose();
    heightController.dispose();
    super.dispose();
  }

  Future<DocumentSnapshot<Map<String, dynamic>>> getUserDetails() async {
    return await FirebaseFirestore.instance
        .collection("Users")
        .doc(currentUser!.email)
        .get();
  }

  String computeAge(Timestamp? dob) {
    if (dob == null) return "N/A";
    DateTime birthDate = dob.toDate();
    DateTime today = DateTime.now();
    int age = today.year - birthDate.year;
    if (today.month < birthDate.month ||
        (today.month == birthDate.month && today.day < birthDate.day)) {
      age--;
    }
    return age.toString();
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (picked != null) {
      setState(() {
        dobController.text = DateFormat('MM-dd-yyyy').format(picked); // Format MM-dd-yyyy
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Icon(Icons.arrow_left, color: AppColor.yellowtext),
        title: Text('My Profile',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        backgroundColor: AppColor.primary,
        elevation: 0,
      ),
      body: FutureBuilder<DocumentSnapshot<Map<String, dynamic>>>(
        future: getUserDetails(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text("Error: ${snapshot.error}"));
          }

          if (snapshot.hasData) {
            Map<String, dynamic>? user = snapshot.data!.data();

            if (!_isDataLoaded) {
              firstNameController.text = user?['firstname'] ?? '';
              lastNameController.text = user?['lastname'] ?? '';
              emailController.text = user?['email'] ?? '';
              mobileNumberController.text = user?['mobileNumber'] ?? '';

              if (user?['dateOfBirth'] != null) {
                DateTime dob = (user!['dateOfBirth'] as Timestamp).toDate();
                dobController.text = DateFormat('MM-dd-yyyy').format(dob);
              }

              weightController.text = user?['weight']?.toString() ?? '';
              heightController.text = user?['height']?.toString() ?? '';
              _isDataLoaded = true;
            }

            return SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    color: AppColor.primary,
                    padding: EdgeInsets.symmetric(vertical: 20),
                    child: Column(
                      children: [
                        CircleAvatar(
                          radius: 50,
                          backgroundImage: AssetImage('assets/MikoProfile.jpg'),
                        ),
                        SizedBox(height: 10),
                        Text(
                          "${user?['firstname'] ?? 'Unknown'} ${user?['lastname'] ?? 'User'}",
                          style: TextStyle(
                            fontSize: 20,
                            color: AppColor.textwhite,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 5),
                        Text(
                          user?['email'] ?? 'No Email Provided',
                          style: TextStyle(
                            fontSize: 14,
                            color: AppColor.textwhite.withOpacity(0.7),
                          ),
                        ),
                        SizedBox(height: 15),
                        Container(
                          margin: EdgeInsets.only(left: 60, right: 60),
                          padding: EdgeInsets.only(top: 15, bottom: 15),
                          decoration: BoxDecoration(
                              color: AppColor.shadow.withOpacity(0.5),
                              borderRadius: BorderRadius.circular(14)),
                          child: Row(
                            children: [
                              Expanded(child: _infoCard(user?['weight']?.toString() ?? 'N/A', 'Weight (kg)')),
                              Column(
                                children: [
                                  Text("|", style: TextStyle(color: AppColor.textwhite.withOpacity(0.5))),
                                  Text("|", style: TextStyle(color: AppColor.textwhite.withOpacity(0.5))),
                                  Text("|", style: TextStyle(color: AppColor.textwhite.withOpacity(0.5))),
                                ],
                              ),
                              Expanded(child: _infoCard(computeAge(user?['dateOfBirth']), 'Years Old')),
                              Column(
                                children: [
                                  Text("|", style: TextStyle(color: AppColor.textwhite.withOpacity(0.5))),
                                  Text("|", style: TextStyle(color: AppColor.textwhite.withOpacity(0.5))),
                                  Text("|", style: TextStyle(color: AppColor.textwhite.withOpacity(0.5))),
                                ],
                              ),
                              Expanded(child: _infoCard(user?['height']?.toString() ?? 'N/A', 'Height (cm)')),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    color: Colors.black,
                    padding: EdgeInsets.all(16),
                    child: Column(
                      children: [
                        SizedBox(height: 20),
                        _buildTextField('First Name', firstNameController),
                        _buildTextField('Last Name', lastNameController),
                        _buildTextField('Email', emailController),
                        _buildTextField('Mobile Number', mobileNumberController),
                        _buildDateOfBirthField(context), // Updated for Date of Birth
                        _buildTextField('Weight (kg)', weightController),
                        _buildTextField('Height (cm)', heightController),
                        SizedBox(height: 10),
                        ElevatedButton(
                          onPressed: () async {
                            User? user = FirebaseAuth.instance.currentUser;

                            if (user != null) {
                              DateTime? dob;
                              try {
                                dob = DateFormat('MM-dd-yyyy').parse(dobController.text);
                              } catch (e) {
                                print("Invalid date format: $e");
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text("Invalid date format. Please use MM-dd-yyyy.")),
                                );
                                return;
                              }

                              await FirebaseFirestore.instance
                                  .collection("Users")
                                  .doc(user.email)
                                  .update({
                                'firstname': firstNameController.text,
                                'lastname': lastNameController.text,
                                'email': emailController.text,
                                'mobileNumber': mobileNumberController.text,
                                'dateOfBirth': Timestamp.fromDate(dob),
                                'weight': weightController.text,
                                'height': heightController.text,
                              }).then((_) {
                                print("User profile data saved.");
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text("Profile updated successfully!")),
                                );
                              }).catchError((error) {
                                print("Failed to save data: $error");
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text("Failed to update profile. Please try again.")),
                                );
                              });
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColor.yellowtext,
                            padding: EdgeInsets.symmetric(vertical: 12, horizontal: 32),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30),
                            ),
                          ),
                          child: Text(
                            'Update Profile',
                            style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          }

          return Center(child: Text("No user data found."));
        },
      ),
    );
  }

  Widget _infoCard(String value, String label) {
    return Column(
      children: [
        Text(
          value,
          style: TextStyle(
              fontSize: 16, color: Colors.white, fontWeight: FontWeight.bold),
        ),
        Text(
          label,
          style: TextStyle(fontSize: 14, color: Colors.white.withOpacity(0.7)),
        ),
      ],
    );
  }

  Widget _buildTextField(String label, TextEditingController controller) {
    return Container(
      margin: EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label,
              style: TextStyle(
                  color: AppColor.purpletext, fontWeight: FontWeight.w600)),
          SizedBox(height: 5),
          TextField(
            controller: controller,
            style: TextStyle(color: Colors.black),
            decoration: InputDecoration(
              hintText: label,
              filled: true,
              fillColor: AppColor.textwhite,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.grey),
                borderRadius: BorderRadius.circular(30),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.white),
                borderRadius: BorderRadius.circular(30),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDateOfBirthField(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Date of Birth (MM-dd-yyyy)',
              style: TextStyle(
                  color: AppColor.purpletext, fontWeight: FontWeight.w600)),
          SizedBox(height: 5),
          GestureDetector(
            onTap: () => _selectDate(context), // Open date picker on tap
            child: AbsorbPointer(
              child: TextField(
                controller: dobController,
                style: TextStyle(color: Colors.black),
                decoration: InputDecoration(
                  hintText: 'Date of Birth (MM-dd-yyyy)',
                  filled: true,
                  fillColor: AppColor.textwhite,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey),
                    borderRadius: BorderRadius.circular(30),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.white),
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}