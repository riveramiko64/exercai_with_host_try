import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:exercai_with_host_try/user_model.dart';
import 'food_log.dart';


class NutritionScreen extends StatefulWidget {
  @override
  _NutritionScreenState createState() => _NutritionScreenState();
}

class _NutritionScreenState extends State<NutritionScreen> {
  late UserModel _userData;
  double _dailyCalories = 0;
  double _proteinTarget = 0;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    final userBox = Hive.box<UserModel>('users');
    if (userBox.isNotEmpty) {
      setState(() {
        _userData = userBox.values.first;
        _calculateTargets();
      });
    }
  }

  void _calculateTargets() {
    const validLevels = {'beginner', 'intermediate', 'advanced'};
    String workoutLevel = validLevels.contains(_userData.workoutLevel.toLowerCase())
        ? _userData.workoutLevel
        : 'beginner';

    double bmr = _userData.gender == 'Male'
        ? (10 * _userData.weight + 6.25 * _userData.height - 5 * _userData.age + 5)
        : (10 * _userData.weight + 6.25 * _userData.height - 5 * _userData.age - 161);

    double tdee = bmr * _getActivityFactor(workoutLevel);

    setState(() {
      switch(_userData.goal) {
        case 'lose weight':
          _dailyCalories = tdee - 500;
          _proteinTarget = 1.6 * _userData.weight;
          break;
        case 'muscle mass gain':
          _dailyCalories = tdee + 500;
          _proteinTarget = 2.2 * _userData.weight;
          break;
        default:
          _dailyCalories = tdee;
          _proteinTarget = 1.6 * _userData.weight;
      }
    });
  }

  double _getActivityFactor(String level) {
    return {
      'beginner': 1.2,
      'intermediate': 1.55,
      'advanced': 1.9
    }[level.toLowerCase()] ?? 1.2;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Today's Nutrition"),
        elevation: 0,
      ),
      body: !Hive.box<UserModel>('users').isOpen || Hive.box<UserModel>('users').isEmpty
          ? Center(child: CircularProgressIndicator())
          : Column(
        children: [
          _HeaderSection(
            calories: _dailyCalories,
            protein: _proteinTarget,
          ),
          Expanded(
            child: _FoodLogSection(),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () => _navigateToAddFood(),
      ),
    );
  }

  void _navigateToAddFood() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => AddFoodScreen()),
    );
  }
}

class _HeaderSection extends StatelessWidget {
  final double calories;
  final double protein;

  const _HeaderSection({required this.calories, required this.protein});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("TUE 4", style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
          SizedBox(height: 16),
          _ProgressRow(label: "Calories", current: 1810, target: "${calories.round()}kcal"),
          _ProgressRow(label: "Protein", current: 215, target: "${protein.round()}g"),
          SizedBox(height: 16),
          _TargetList(),
        ],
      ),
    );
  }
}

class _ProgressRow extends StatelessWidget {
  final String label;
  final int current;
  final String target;

  const _ProgressRow({required this.label, required this.current, required this.target});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Expanded(child: Text(label)),
          Text("$current / $target"),
        ],
      ),
    );
  }
}

class _TargetList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("Foods to help you reach multiple targets:",
            style: TextStyle(fontWeight: FontWeight.bold)),
        SizedBox(height: 8),
        _TargetItem("Olives, Pickled, Green"),
        _TargetItem("Kidney Beans"),
        _TargetItem("Navy Beans"),
      ],
    );
  }
}

class _TargetItem extends StatelessWidget {
  final String food;

  const _TargetItem(this.food);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Icon(Icons.circle, size: 8),
          SizedBox(width: 8),
          Text(food),
        ],
      ),
    );
  }
}

class _FoodLogSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<Box<FoodLog>>(
      valueListenable: Hive.box<FoodLog>('foodLogs').listenable(),
      builder: (context, box, _) {
        final logs = box.values.toList().cast<FoodLog>();

        return ListView.builder(
          itemCount: logs.length,
          itemBuilder: (context, index) => ListTile(
            title: Text(logs[index].foodName),
            subtitle: Text(_formatNutrients(logs[index].nutrients)),
          ),
        );
      },
    );
  }

  String _formatNutrients(Map<String, dynamic> nutrients) {
    return "Cal: ${nutrients['calories']} | Protein: ${nutrients['protein']}g";
  }
}

class AddFoodScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Find A Food")),
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.all(16),
            child: TextField(
              decoration: InputDecoration(
                hintText: "Search foods...",
                prefixIcon: Icon(Icons.search),
              ),
            ),
          ),
          Expanded(
            child: ListView(
              children: [
                _FoodItem("White Rice", "1 cup", "+53g carbs"),
                _FoodItem("Salmon", "100g", "+30g protein"),
                _FoodItem("Cabbage, Cooked", "1 serving", "+25 fiber"),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _FoodItem extends StatelessWidget {
  final String name;
  final String portion;
  final String nutrients;

  const _FoodItem(this.name, this.portion, this.nutrients);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(name),
      subtitle: Text(portion),
      trailing: Text(nutrients),
      onTap: () => _addToLog(context),
    );
  }

  void _addToLog(BuildContext context) {
    final box = Hive.box<FoodLog>('foodLogs');
    box.add(FoodLog(
        name,
        DateTime.now(),
        {'calories': 100, 'protein': 5} // Replace with real data from API
    ));
    Navigator.pop(context);
  }
}



class UserModelAdapter extends TypeAdapter<UserModel> {
  @override
  final typeId = 1;

  @override
  UserModel read(BinaryReader reader) {
    return UserModel(
      email: reader.read(),
      firstName: reader.read(),
      lastName: reader.read(),
      gender: reader.read(),
      weight: reader.read(),
      height: reader.read(),
      age: reader.read(),
      goal: reader.read(),
      workoutLevel: reader.read(),
    );
  }

  @override
  void write(BinaryWriter writer, UserModel obj) {
    writer.write(obj.email);
    writer.write(obj.firstName);
    writer.write(obj.lastName);
    writer.write(obj.gender);
    writer.write(obj.weight);
    writer.write(obj.height);
    writer.write(obj.age);
    writer.write(obj.goal);
    writer.write(obj.workoutLevel);
  }
}