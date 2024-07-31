import 'package:hive/hive.dart';
import 'package:uuid/uuid.dart';

part 'task_model.g.dart';

@HiveType(typeId: 1)
class Task extends HiveObject {
  Task({
    required this.id,
    required this.title,
    required this.subTitle,
    required this.createdAtTime,
    required this.createdAtDate,
    required this.isCompleted,
  });

  @HiveField(0)
  final String id;

  @HiveField(1)
  final String title;

  @HiveField(2)
  final String subTitle;

  @HiveField(3)
  DateTime createdAtTime; // Keeping it final since it shouldn't change

  @HiveField(4)
  DateTime createdAtDate; // Keeping it final since it shouldn't change

  @HiveField(5)
  bool isCompleted;

  factory Task.create({
    required String title,
    required String subTitle,
    DateTime? createdAtTime,
    DateTime? createdAtDate,
  }) =>
      Task(
        id: const Uuid().v1(),
        title: title,
        subTitle: subTitle,
        createdAtTime: createdAtTime ?? DateTime.now(),
        createdAtDate:
            createdAtDate ?? DateTime.now(), // Ensure this is set correctly
        isCompleted: false, // Default to false for new tasks
      );
}
