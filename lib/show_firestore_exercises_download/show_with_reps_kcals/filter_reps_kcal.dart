import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'show_reps_kcal.dart';
import 'list_map_exercises.dart';

class FilterRepsKcal extends StatefulWidget {
  @override
  _FilterRepsKcalState createState() => _FilterRepsKcalState();
}

class _FilterRepsKcalState extends State<FilterRepsKcal> {
  late Stream<QuerySnapshot> _exercisesStream;
  bool isLoading = true;
  String? selectedDifficulty;
  String? selectedBMI;
  User? _currentUser;

  String getRepsTimeDisplay(Map<String, dynamic> exercise) {
    if (exercise['baseSetsReps'] != null && exercise['baseReps'] != null) {
      return "${exercise['baseSetsReps']} sets × ${exercise['baseReps']} reps";
    } else if (exercise['baseSetsSecs'] != null && exercise['baseSecs'] != null) {
      return _formatTimeDisplay(exercise['baseSetsSecs'], exercise['baseSecs']);
    } else if (exercise['baseSecs'] != null) {
      return _formatSingleDuration(exercise['baseSecs']);
    }
    return 'N/A';
  }

  String _formatTimeDisplay(int sets, int totalSecs) {
    String time = _secondsToTimeString(totalSecs);
    return "$sets sets × $time";
  }

  String _formatSingleDuration(int totalSecs) {
    return _secondsToTimeString(totalSecs);
  }

  String _secondsToTimeString(int totalSecs) {
    if (totalSecs >= 60) {
      int minutes = totalSecs ~/ 60;
      int seconds = totalSecs % 60;
      String result = "$minutes min";
      if (seconds > 0) result += " $seconds sec";
      return result;
    }
    return "$totalSecs sec";
  }

  String _formatTotalTime(int totalSeconds) {
    if (totalSeconds >= 60) {
      int minutes = totalSeconds ~/ 60;
      int seconds = totalSeconds % 60;
      return "$minutes:${seconds.toString().padLeft(2, '0')}";
    } else {
      return "$totalSeconds sec";
    }
  }

  @override
  void initState() {
    super.initState();
    _currentUser = FirebaseAuth.instance.currentUser;
    fetchUserData();
  }

  Future<void> fetchUserData() async {
    try {
      setState(() => isLoading = true);
      if (_currentUser == null) {
        setState(() => isLoading = false);
        return;
      }

      DocumentSnapshot userDoc = await FirebaseFirestore.instance
          .collection('Users')
          .doc(_currentUser!.email)
          .get();

      if (!userDoc.exists) {
        setState(() => isLoading = false);
        return;
      }

      final userData = userDoc.data() as Map<String, dynamic>;
      setState(() {
        selectedBMI = userData['bmiCategory'] ?? 'normal';
        selectedDifficulty = userData['workoutLevel'] ?? 'beginner';
      });

      await _initializeExercisesStream();
      setState(() => isLoading = false);
    } catch (e) {
      print("Error fetching user data: $e");
      setState(() => isLoading = false);
    }
  }

  Future<void> _initializeExercisesStream() async {
    if (selectedDifficulty == null || selectedBMI == null || _currentUser == null) return;

    _exercisesStream = FirebaseFirestore.instance
        .collection('Users')
        .doc(_currentUser!.email)
        .collection('UserExercises')
        .where('difficulty', isEqualTo: selectedDifficulty)
        .where('bmiCategory', isEqualTo: selectedBMI)
        .snapshots();

    await fetchExercisesFromFirestore();
  }

  Future<void> fetchExercisesFromFirestore() async {
    if (selectedDifficulty == null || selectedBMI == null || _currentUser == null) return;

    try {
      final difficultyMap = exerciseData[selectedDifficulty!] ?? {};
      final bmiMap = difficultyMap[selectedBMI!] ?? {};

      for (var bodyPart in bmiMap.keys) {
        QuerySnapshot snapshot = await FirebaseFirestore.instance
            .collection('BodyweightExercises')
            .where('bodyPart', isEqualTo: bodyPart)
            .get();

        final allowedExercises = bmiMap[bodyPart] ?? [];

        for (var doc in snapshot.docs) {
          final data = doc.data() as Map<String, dynamic>;
          final match = allowedExercises.firstWhere(
                (ex) =>
            (ex['name']?.toLowerCase() ?? '') ==
                (data['name']?.toString().toLowerCase() ?? ''),
            orElse: () => <String, dynamic>{},
          );

          if (match.isNotEmpty) {
            final mergedData = Map<String, dynamic>.from(data)
              ..addAll({
                'baseSetsReps': match['baseSetsReps'],
                'baseReps': match['baseReps'],
                'baseSetsSecs': match['baseSetsSecs'],
                'baseSecs': match['baseSecs'],
                'baseCalories': match['baseCalories'],
                'difficulty': selectedDifficulty,
                'bmiCategory': selectedBMI,
                'completed': false,
                'restTime': 30,
              });

            DocumentReference userExerciseRef = FirebaseFirestore.instance
                .collection('Users')
                .doc(_currentUser!.email)
                .collection('UserExercises')
                .doc(mergedData['id'].toString());

            DocumentSnapshot userExerciseDoc = await userExerciseRef.get();
            if (!userExerciseDoc.exists) {
              await userExerciseRef.set(mergedData);
            }
          }
        }
      }
    } catch (e) {
      print('Error initializing exercises: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          selectedDifficulty == null || selectedBMI == null
              ? "Loading..."
              : "Exercises for $selectedDifficulty ($selectedBMI)",
        ),
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : _currentUser == null || selectedDifficulty == null || selectedBMI == null
          ? Center(child: Text("Please log in and select preferences"))
          : StreamBuilder<QuerySnapshot>(
        stream: _exercisesStream,
        builder: (context, exercisesSnapshot) {
          if (exercisesSnapshot.hasError) {
            return Center(child: Text('Error: ${exercisesSnapshot.error}'));
          }

          if (exercisesSnapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          final exercises = exercisesSnapshot.data!.docs;

          return StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance
                .collection('Users')
                .doc(_currentUser!.email)
                .collection('UserExerciseTimes')
                .snapshots(),
            builder: (context, timesSnapshot) {
              if (timesSnapshot.hasError) {
                return Center(child: Text('Error: ${timesSnapshot.error}'));
              }

              if (timesSnapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator());
              }

              // Create a map of exerciseId to totalExerciseTime
              final exerciseTimes = {
                for (var doc in timesSnapshot.data!.docs)
                  doc['exerciseId'].toString(): doc['totalExerciseTime'] ?? 0
              };

              return exercises.isEmpty
                  ? Center(child: Text("No exercises found for your category."))
                  : ListView.builder(
                itemCount: exercises.length,
                itemBuilder: (context, index) {
                  final exercise = exercises[index].data() as Map<String, dynamic>;
                  final isCompleted = exercise['completed'] == true;
                  final exerciseId = exercise['id'].toString();
                  final totalTime = exerciseTimes[exerciseId] ?? 0; // Get total time from the map

                  return Card(
                    margin: EdgeInsets.all(8),
                    elevation: 3,
                    child: ListTile(
                      leading: Image.network(
                        exercise['gifUrl'],
                        width: 60,
                        height: 60,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) =>
                        const Icon(Icons.download_for_offline, size: 50),
                      ),
                      title: Text(exercise['name']),
                      subtitle: Text(
                        "Target: ${exercise['target']}\n"
                            "Body Part: ${exercise['bodyPart']}\n"
                            "Equipment: ${exercise['equipment']}\n"
                            "Reps/Time: ${getRepsTimeDisplay(exercise)}\n"
                            "Calories: ${exercise['baseCalories'] ?? 'N/A'}\n"
                            "Total Time: ${_formatTotalTime(totalTime)}\n"
                            "ID: ${exercise['id']}",
                      ),
                      trailing: isCompleted
                          ? Icon(Icons.check_circle, color: Colors.green)
                          : null,
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ShowRepsKcal(exercise: exercise),
                          ),
                        );
                      },
                    ),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}