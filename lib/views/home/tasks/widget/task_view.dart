import 'package:flutter/material.dart';
import 'package:flutter_cupertino_date_picker_fork/flutter_cupertino_date_picker_fork.dart';
import 'package:intl/intl.dart';
import 'package:todo_app/extension/space_extension.dart';
import 'package:todo_app/main.dart';
import 'package:todo_app/models/task_model.dart';
import 'package:todo_app/utils/app_colors.dart';
import 'package:todo_app/utils/app_string.dart';
import 'package:todo_app/utils/constants.dart';
import 'package:todo_app/views/home/tasks/widget/components/dat_time_selection_widget.dart';
import 'package:todo_app/views/home/tasks/widget/components/re_text_field_controller.dart';
import 'package:todo_app/views/home/tasks/widget/task_view_app_bar.dart';

class TaskView extends StatefulWidget {
  TaskView({
    super.key,
    TextEditingController? titleTaskController,
    TextEditingController? descriptionController,
    required this.task,
  })  : titleTaskController = titleTaskController ?? TextEditingController(),
        descriptionController =
            descriptionController ?? TextEditingController();

  final TextEditingController titleTaskController;
  final TextEditingController descriptionController;
  final Task? task;

  @override
  State<TaskView> createState() => _TaskViewState();
}

class _TaskViewState extends State<TaskView> {
  var title;
  var subTitle;
  DateTime? time;
  DateTime? date;

  /// Show Selected Time As String Format
  String showTime(DateTime? time) {
    if (widget.task?.createdAtTime == null) {
      if (time == null) {
        return DateFormat('hh:mm a').format(DateTime.now()).toString();
      } else {
        return DateFormat('hh:mm a').format(time).toString();
      }
    } else {
      return DateFormat('hh:mm a')
          .format(widget.task!.createdAtTime)
          .toString();
    }
  }

  /// Show Selected Date As String Format
  String showDate(DateTime? date) {
    if (widget.task?.createdAtDate == null) {
      if (date == null) {
        return DateFormat.yMMMEd().format(DateTime.now()).toString();
      } else {
        return DateFormat.yMMMEd().format(date).toString();
      }
    } else {
      return DateFormat.yMMMEd().format(widget.task!.createdAtDate).toString();
    }
  }

  // Show Selected Date As DateTime Format
  DateTime showDateAsDateTime(DateTime? date) {
    if (widget.task?.createdAtDate == null) {
      if (date == null) {
        return DateTime.now();
      } else {
        return date;
      }
    } else {
      return widget.task!.createdAtDate;
    }
  }

//if any task exist then return true otherwise false
  bool isTaskAlreadyExistBool() {
    if (widget.titleTaskController.text.isEmpty &&
        widget.descriptionController.text.isEmpty) {
      return true;
    } else {
      return false;
    }
  }

  /// If any task already exists, the app will update it; otherwise, the app will add a new task

  dynamic isTaskAlreadyExistUpdateTaskOtherwiseCreate() {
    if (widget.titleTaskController.text.isNotEmpty &&
        widget.descriptionController.text.isNotEmpty) {
      // Check if the text is not empty
      try {
        widget.titleTaskController.text = title; // Update the title
        widget.descriptionController.text = subTitle; // Update the subtitle

        // Uncomment and set these if needed
        // widget.task?.createdAtDate = date!;
        // widget.task?.createdAtTime = time!;

        widget.task?.save();
        Navigator.of(context).pop();
      } catch (error) {
        // If user wants to update the task but nothing is entered
        updateTaskWarning(context);
      }
    } else {
      if (title != null && subTitle != null) {
        var task = Task.create(
          title: title,
          createdAtTime: time,
          createdAtDate: date,
          subTitle: subTitle,
        );
        // Adding new task to Hive DB
        BaseWidget.of(context).dataStore.addTask(task: task);
        Navigator.of(context).pop();
      } else {
        emptyWarning(context);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    var textTheme = Theme.of(context).textTheme;

    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: const TaskViewAppBar(),
        body: SizedBox(
          width: double.infinity,
          height: double.infinity,
          child: SingleChildScrollView(
            child: Column(
              children: [
                // Top side
                _buildTopSideText(height, width, textTheme),

                // Main body
                _buildMainActionTaskBody(height, textTheme, context),

                // Bottom side
                _buildBottomSideTask(width, height),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildBottomSideTask(double width, double height) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Row(
        mainAxisAlignment: isTaskAlreadyExistBool()
            ? MainAxisAlignment.center
            : MainAxisAlignment.spaceEvenly,
        children: [
          isTaskAlreadyExistBool()
              ? Container()
              : MaterialButton(
                  onPressed: () {
                    //  print("Current task has been deleted");
                  },
                  minWidth: width * 0.3,
                  color: Colors.grey.shade50,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15)),
                  height: height * 0.05,
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Icon(Icons.close, color: AppColors.primaryColor),
                      Text(
                        AppString.deleteTask,
                        style: TextStyle(
                          color: AppColors.primaryColor,
                        ),
                      ),
                    ],
                  ),
                ),

          // Add or update task
          MaterialButton(
            onPressed: () {
              isTaskAlreadyExistUpdateTaskOtherwiseCreate();
              print("New task has been added");
            },
            minWidth: width * 0.3,
            color: AppColors.primaryColor,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),
            height: height * 0.05,
            child: const Text(
              AppString.addTaskString,
              style: TextStyle(
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }

  SizedBox _buildMainActionTaskBody(
      double height, TextTheme textTheme, BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: height * 0.5,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 30),
            child: Text(
              AppString.titleOfTitleTextField,
              style: textTheme.headlineMedium,
            ),
          ),

          ReTextFieldController(
            controller: widget.titleTaskController,
            onFieldSubmitted: (String inputtitle) {
              title = inputtitle;
            },
            onChanged: (String inputtitle) {
              title = inputtitle;
            },
          ),
          10.h,
          ReTextFieldController(
            controller: widget.descriptionController,
            isForDescription: true,
            onFieldSubmitted: (String inputsubtitle) {
              subTitle = inputsubtitle;
            },
            onChanged: (String inputsubtitle) {
              subTitle = inputsubtitle;
            },
          ),

          // Time selection
          DateTimeSelection(
            ontap: () {
              showModalBottomSheet(
                context: context,
                builder: (_) => SizedBox(
                  height: height * 0.3,
                  child: TimePickerWidget(
                    onChange: (_, __) {},
                    dateFormat: 'HH:mm:ss',
                    onConfirm: (dateTime, _) {
                      setState(() {
                        if (widget.task?.createdAtTime == null) {
                          time = dateTime;
                        } else {
                          widget.task!.createdAtTime = dateTime;
                        }
                      });
                    },
                  ),
                ),
              );
            },
            title: "Time",
            isTime: true,
            time: showTime(time),
          ),

          // Date selection
          DateTimeSelection(
            ontap: () {
              DatePicker.showDatePicker(
                context,
                maxDateTime: DateTime(2090, 12, 30),
                minDateTime: DateTime.now(),
                initialDateTime: showDateAsDateTime(date),
                onConfirm: (dateTime, _) {
                  setState(() {
                    if (widget.task?.createdAtDate == null) {
                      date = dateTime;
                    } else {
                      widget.task!.createdAtDate = dateTime;
                    }
                  });
                },
              );
            },
            title: AppString.dateString,
            isTime: true,
            time: showDate(date),
          ),
        ],
      ),
    );
  }

  SizedBox _buildTopSideText(double height, double width, TextTheme textTheme) {
    return SizedBox(
      width: double.infinity,
      height: height * 0.1,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(
            width: width * 0.07,
            child: const Divider(
              thickness: 2,
            ),
          ),
          RichText(
            text: TextSpan(
              text: isTaskAlreadyExistBool()
                  ? AppString.addNewTask
                  : AppString.updateCurrentTask,
              //text: AppString.addNewTask,
              style: textTheme.titleLarge,
              children: const [
                TextSpan(
                  text: AppString.taskString,
                  style: TextStyle(fontWeight: FontWeight.w400),
                ),
              ],
            ),
          ),
          SizedBox(
            width: width * 0.07,
            child: const Divider(
              thickness: 2,
            ),
          ),
        ],
      ),
    );
  }
}
