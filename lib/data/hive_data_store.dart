import 'package:flutter/foundation.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:todo_app/models/task_model.dart';

class HiveDataStore {
  static const boxName = "tasksBox";
  late final Box<Task> box;

  HiveDataStore() {
    _init();
  }

  Future<void> _init() async {
    await Hive.initFlutter();

    // Check if the adapter is already registered
    if (!Hive.isAdapterRegistered(TaskAdapter().typeId)) {
      Hive.registerAdapter(TaskAdapter()); // Ensure this is done only once
    }

    box = await Hive.openBox<Task>(boxName);
  }

  /// Add new Task
  Future<void> addTask({required Task task}) async {
    await box.put(task.id, task);
  }

  /// Show task
  Future<Task?> getTask({required String id}) async {
    return box.get(id);
  }

  /// Update task
  Future<void> updateTask({required Task task}) async {
    await box.put(task.id,
        task); // Changed to put to ensure the task is updated in the box
  }

  /// Delete task
  Future<void> deleteTask({required Task task}) async {
    await box.delete(task.id); // Changed to delete by id
  }

  ValueListenable<Box<Task>> listenToTask() {
    return box.listenable();
  }
}
