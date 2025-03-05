// user_model.dart
import 'package:hive/hive.dart';
import 'user_model.dart';

part 'user_model.g.dart';

@HiveType(typeId: 0)
class UserModel extends HiveObject {
  @HiveField(0)
  String email;
  @HiveField(1)
  String firstName;
  @HiveField(2)
  String lastName;
  @HiveField(3)
  String gender;
  @HiveField(4)
  double weight;
  @HiveField(5)
  double height;
  @HiveField(6)
  int age;
  @HiveField(7)
  String goal;
  @HiveField(8)
  String workoutLevel;

  UserModel({
    required this.email,
    required this.firstName,
    required this.lastName,
    required this.gender,
    required this.weight,
    required this.height,
    required this.age,
    required this.goal,
    required this.workoutLevel,
  });

  // Add this empty constructor
  factory UserModel.empty() {
    return UserModel(
      email: '',
      firstName: '',
      lastName: '',
      gender: '',
      weight: 0.0,
      height: 0.0,
      age: 0,
      goal: '',
      workoutLevel: '',
    );
  }
}
