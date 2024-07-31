import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:lottie/lottie.dart';
import 'package:todo_app/extension/space_extension.dart';
import 'package:todo_app/main.dart';
import 'package:todo_app/models/task_model.dart';
import 'package:todo_app/utils/app_colors.dart';
import 'package:todo_app/utils/app_string.dart';
import 'package:todo_app/utils/constants.dart';
import 'package:animate_do/animate_do.dart';
import 'package:flutter_slider_drawer/flutter_slider_drawer.dart';
import 'package:todo_app/views/home/tasks/widget/components/home_app_bar.dart';
import 'package:todo_app/views/home/tasks/widget/components/slider_drawer.dart';
import 'package:todo_app/views/home/tasks/widget/fab.dart';
import 'package:todo_app/views/home/tasks/widget/task_widget.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final GlobalKey<SliderDrawerState> drawerKey = GlobalKey<SliderDrawerState>();

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    final base = BaseWidget.of(context);

    TextTheme textTheme = Theme.of(context).textTheme;
    return ValueListenableBuilder(
      valueListenable: base.dataStore.listenToTask(),
      builder: (ctx, Box<Task> box, Widget? child) {
        List<Task> tasks = box.values.toList();
        return Scaffold(
          backgroundColor: Colors.white,
          floatingActionButton: Fab(width: width, height: height),
          body: SliderDrawer(
            key: drawerKey,
            isDraggable: false,
            animationDuration: 1000,
            slider: CustomSliderDrawer(),
            appBar: HomeAppBar(drawerKey: drawerKey),
            child: _buildHomeBody(
              height,
              width,
              textTheme,
              base,
              tasks,
            ),
          ),
        );
      },
    );
  }

  SizedBox _buildHomeBody(
    double height,
    double width,
    TextTheme textTheme,
    BaseWidget base,
    List<Task> tasks,
  ) {
    return SizedBox(
      height: double.infinity,
      width: double.infinity,
      child: Column(
        children: [
          Container(
            margin: const EdgeInsets.only(top: 60),
            width: double.infinity,
            height: height * 0.09,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  width: width * 0.04,
                  height: height * 0.02,
                  child: const CircularProgressIndicator(
                    backgroundColor: Colors.grey,
                    value: 1 / 3,
                    valueColor: AlwaysStoppedAnimation(AppColors.primaryColor),
                  ),
                ),
                25.w,
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      AppString.mainTitle,
                      style: textTheme.displayLarge,
                    ),
                    12.h,
                    Text("1 of 3 task", style: textTheme.titleMedium),
                  ],
                )
              ],
            ),
          ),
          const Padding(
            padding: EdgeInsets.only(top: 10),
            child: Divider(
              thickness: 2,
              indent: 100,
            ),
          ),
          SizedBox(
            width: double.infinity,
            height: height * 0.3,
            child: tasks.isNotEmpty
                ? ListView.builder(
                    itemCount: tasks.length,
                    scrollDirection: Axis.vertical,
                    itemBuilder: (context, index) {
                      var task = tasks[index];
                      return Dismissible(
                        direction: DismissDirection.horizontal,
                        onDismissed: (_) {
                          // handle task dismissal logic
                        },
                        background: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(
                              Icons.delete_outline,
                              color: Colors.grey,
                            ),
                            8.w,
                            const Text(
                              AppString.deletedTask,
                              style: TextStyle(color: Colors.grey),
                            ),
                          ],
                        ),
                        key: Key(index.toString()),
                        child: TaskWidget(
                          width: width,
                          task: task,
                        ),
                      );
                    },
                  )
                : Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      FadeInUp(
                        child: Lottie.asset(
                          height: height * 0.1,
                          lottieURL,
                          animate: tasks.isNotEmpty ? false : true,
                        ),
                      ),
                      FadeInUp(
                        from: 30,
                        child: const Text(
                          AppString.doneAllTask,
                        ),
                      ),
                    ],
                  ),
          ),
        ],
      ),
    );
  }
}
