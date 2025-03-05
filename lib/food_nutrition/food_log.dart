// food_log.dart
import 'package:hive/hive.dart';

@HiveType(typeId: 0)
class FoodLog extends HiveObject {
  @HiveField(0) final String foodName;
  @HiveField(1) final DateTime date;
  @HiveField(2) final Map<String, dynamic> nutrients;

  FoodLog(this.foodName, this.date, this.nutrients);
}

class FoodLogAdapter extends TypeAdapter<FoodLog> {
  @override
  final typeId = 0;

  @override
  FoodLog read(BinaryReader reader) {
    return FoodLog(
      reader.read(),
      reader.read(),
      reader.read(),
    );
  }

  @override
  void write(BinaryWriter writer, FoodLog obj) {
    writer.write(obj.foodName);
    writer.write(obj.date);
    writer.write(obj.nutrients);
  }
}