import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:todo_app/data/hive_data_store.dart';
import 'package:todo_app/models/task_model.dart';
import 'package:todo_app/views/home/home_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Hive
  await Hive.initFlutter();

  // Register the Hive adapter
  Hive.registerAdapter(TaskAdapter());

  // Open a box
  final box = await Hive.openBox<Task>('tasksBox');

  // Delete data from the previous day using a for loop
  List<int> keysToDelete = []; // Store keys to delete later

  for (var key in box.keys) {
    var task = box.get(key);
    if (task != null && task.createdAtTime.day != DateTime.now().day) {
      keysToDelete.add(key as int); // Collect keys for deletion
    }
  }

  // Delete tasks using their keys
  for (var key in keysToDelete) {
    await box.delete(key); // Use the box's delete method
  }

  // Pass the box to the BaseWidget
  runApp(BaseWidget(box: box, child: const MyApp())); // Pass box here
}

class BaseWidget extends InheritedWidget {
  final HiveDataStore dataStore = HiveDataStore();
  final Box<Task> box; // Store the box reference
  final Widget child;

  BaseWidget({super.key, required this.child, required this.box})
      : super(child: child);

  static BaseWidget of(BuildContext context) {
    final base = context.dependOnInheritedWidgetOfExactType<BaseWidget>();
    if (base != null) {
      return base;
    } else {
      throw StateError('Could not find ancestor widget of type BaseWidget');
    }
  }

  @override
  bool updateShouldNotify(BaseWidget oldWidget) {
    return false;
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // Access the box using BaseWidget
    final box = BaseWidget.of(context).box;

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        textTheme: const TextTheme(
          displayLarge: TextStyle(
            color: Colors.black,
            fontSize: 45,
            fontWeight: FontWeight.bold,
          ),
          titleMedium: TextStyle(
            color: Colors.grey,
            fontSize: 16,
            fontWeight: FontWeight.w300,
          ),
          displayMedium: TextStyle(
            color: Colors.white,
            fontSize: 21,
          ),
          displaySmall: TextStyle(
            color: Color.fromARGB(255, 234, 234, 234),
            fontSize: 14,
            fontWeight: FontWeight.w400,
          ),
          headlineMedium: TextStyle(
            color: Colors.grey,
            fontSize: 17,
          ),
          headlineSmall: TextStyle(
            color: Colors.grey,
            fontSize: 16,
          ),
          titleSmall: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.w500,
          ),
          titleLarge: TextStyle(
            fontSize: 40,
            color: Colors.black,
            fontWeight: FontWeight.w300,
          ),
        ),
      ),
      home: const HomePage(),
    );
  }
}
