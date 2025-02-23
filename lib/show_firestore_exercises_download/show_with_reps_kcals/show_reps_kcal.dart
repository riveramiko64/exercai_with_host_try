import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:exercai_with_host_try/show_firestore_exercises_download/proceed_to_exercise/reps_page.dart';

class ShowRepsKcal extends StatefulWidget {
  final Map<String, dynamic> exercise;

  const ShowRepsKcal({Key? key, required this.exercise}) : super(key: key);

  @override
  _ShowRepsKcalState createState() => _ShowRepsKcalState();
}

class _ShowRepsKcalState extends State<ShowRepsKcal> {
  late Stream<DocumentSnapshot> _exerciseStream;
  late User _currentUser;

  @override
  void initState() {
    super.initState();
    _currentUser = FirebaseAuth.instance.currentUser!;
    _initializeExerciseStream();
  }

  void _initializeExerciseStream() {
    _exerciseStream = FirebaseFirestore.instance
        .collection('Users')
        .doc(_currentUser.email)
        .collection('UserExercises')
        .doc(widget.exercise['id'].toString())
        .snapshots();
  }

  String _formatDuration(int? totalSecs) {
    final safeSecs = totalSecs ?? 0;
    if (safeSecs >= 60) {
      int minutes = safeSecs ~/ 60;
      int seconds = safeSecs % 60;
      String result = "$minutes minute${minutes != 1 ? 's' : ''}";
      if (seconds > 0) result += " $seconds second${seconds != 1 ? 's' : ''}";
      return result;
    }
    return "$safeSecs second${safeSecs != 1 ? 's' : ''}";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.exercise['name'] ?? 'Unnamed Exercise'),
      ),
      body: StreamBuilder<DocumentSnapshot>(
        stream: _exerciseStream,
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || !snapshot.data!.exists) {
            return const Center(child: Text('Exercise data not found'));
          }

          final exercise = snapshot.data!.data() as Map<String, dynamic>;
          final baseSetsReps = exercise['baseSetsReps'] as int?;
          final baseReps = exercise['baseReps'] as int?;
          final baseSetsSecs = exercise['baseSetsSecs'] as int?;
          final baseSecs = exercise['baseSecs'] as int?;

          final isRepBased = baseSetsReps != null && baseReps != null;
          final isTimeBased = baseSetsSecs != null && baseSecs != null;
          final isSingleDuration = baseSecs != null && !isTimeBased;

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Image.network(
                    exercise['gifUrl'] ?? '',
                    height: 200,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) =>
                    const Icon(Icons.error_outline, size: 100),
                  ),
                ),
                const SizedBox(height: 20),
                Text(
                  'Exercise Details',
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
                const Divider(),
                ListTile(
                  title: Text('Target Muscle: ${exercise['target'] ?? 'N/A'}'),
                  subtitle: Text('Equipment: ${exercise['equipment'] ?? 'N/A'}'),
                ),
                const SizedBox(height: 20),
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        if (isRepBased)
                          Column(
                            children: [
                              const Icon(Icons.repeat, size: 30),
                              Text(
                                '${baseSetsReps ?? 0} Sets',
                                style: const TextStyle(fontSize: 18),
                              ),
                              Text(
                                '${baseReps ?? 0} Reps',
                                style: const TextStyle(
                                    fontSize: 24, fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                        if (isTimeBased || isSingleDuration)
                          Column(
                            children: [
                              const Icon(Icons.timer, size: 30),
                              if (isTimeBased)
                                Text(
                                  '${baseSetsSecs ?? 0} Sets',
                                  style: const TextStyle(fontSize: 18),
                                ),
                              Text(
                                _formatDuration(baseSecs),
                                style: const TextStyle(
                                    fontSize: 24, fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Center(
                  child: Chip(
                    backgroundColor: Colors.orange[100],
                    label: Text(
                      '${exercise['baseCalories'] ?? 'N/A'} kcal',
                      style: const TextStyle(
                          fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Text("Instructions:", style: _headerStyle()),
                const SizedBox(height: 10),
                ...List.generate(
                  exercise['instructions']?.length ?? 0,
                      (index) => Text("• ${exercise['instructions'][index]}"),
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => RepsPage(exercise: exercise),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size(double.infinity, 50),
                  ),
                  child: const Text('Proceed to Exercise'),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  TextStyle _headerStyle() =>
      const TextStyle(fontSize: 18, fontWeight: FontWeight.bold);
}