import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

Future<void> fetchAndStoreBodyweightExercises() async {
  const String apiUrl = 'https://exercisedb.p.rapidapi.com/exercises?limit=1300'; // Adjust the API endpoint if needed

  const Map<String, String> headers = {
    'X-RapidAPI-Key': '81efa21332mshc3d43597ee9e475p14e998jsn7776838f3ddd', // Replace with your API key
    'X-RapidAPI-Host': 'exercisedb.p.rapidapi.com',
  };

  try {
    final response = await http.get(Uri.parse(apiUrl), headers: headers);
    if (response.statusCode == 200) {
      List<dynamic> allExercises = json.decode(response.body);

      // Filter exercises where equipment == 'body weight'
      List<dynamic> bodyweightExercises = allExercises
          .where((exercise) => exercise['equipment'].toLowerCase() == 'body weight')
          .toList();

      // Reference Firestore collection
      CollectionReference exercisesRef = FirebaseFirestore.instance.collection('BodyweightExercises');

      for (var exercise in bodyweightExercises) {
        String exerciseId = exercise['id'].toString();

        // Check if the exercise already exists
        DocumentSnapshot existingExercise = await exercisesRef.doc(exerciseId).get();
        if (existingExercise.exists) {
          print("Exercise with ID $exerciseId already exists. Skipping...");
          continue; // Skip adding if it already exists
        }

        // Store each new exercise as a document in Firestore
        await exercisesRef.doc(exerciseId).set({
          'id': exerciseId,
          'name': exercise['name'],
          'equipment': exercise['equipment'],
          'bodyPart': exercise['bodyPart'],
          'target': exercise['target'],
          'gifUrl': exercise['gifUrl'],
          'instructions': List<String>.from(exercise['instructions'] ?? []),
          'secondaryMuscles': List<String>.from(exercise['secondaryMuscles'] ?? []),
        });

        print("Stored new exercise: ${exercise['name']} (ID: $exerciseId)");
      }

      print("Bodyweight exercises have been stored in Firestore without duplicates.");
    } else {
      throw Exception('Failed to fetch exercises');
    }
  } catch (e) {
    print('Error fetching/storing exercises: $e');
  }
}
