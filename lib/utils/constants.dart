import 'package:flutter/widgets.dart';
import 'package:ftoast/ftoast.dart';
import 'package:panara_dialogs/panara_dialogs.dart';
import 'package:todo_app/main.dart';
import 'package:todo_app/utils/app_string.dart';

//lottie asset url
String lottieURL = 'assets/lottie/1.json';

//empty title or subtitle warning
dynamic emptyWarning(BuildContext context) {
  return FToast.toast(
    context,
    msg: AppString.oopsMsg,
    subMsg: 'You must fill all fields',
    corner: 20,
    duration: 2000,
    padding: const EdgeInsets.all(20),
  );
}

//nothing updated when user try to edit or  update the current task
dynamic updateTaskWarning(BuildContext context) {
  return FToast.toast(
    context,
    msg: AppString.oopsMsg,
    subMsg: 'You must edit the task and try to update it',
    corner: 20,
    duration: 5000,
    padding: const EdgeInsets.all(20),
  );
}

//no Task Warning doalog for deleting
dynamic noTaskWarning(BuildContext context) {
  return PanaraInfoDialog.showAnimatedGrow(
    context,
    title: AppString.oopsMsg,
    message: "There is no Task for Delete. Try adding some and delete.",
    buttonText: "okay",
    onTapDismiss: () {
      Navigator.pop(context);
    },
    panaraDialogType: PanaraDialogType.warning,
  );
}

//delete all task
dynamic deleteAllTask(BuildContext context) {
  return PanaraConfirmDialog.show(
    context,
    title: AppString.areYouSure,
    message:
        "Do You really want to delete all tasks? You will no be able to undo this action!",
    confirmButtonText: "Yes",
    cancelButtonText: "No",
    onTapCancel: () {
      Navigator.pop(context);
    },
    onTapConfirm: () {
      BaseWidget.of(context).dataStore.box.clear();
      Navigator.pop(context);
    },
    panaraDialogType: PanaraDialogType.error,
    barrierDismissible: false,
  );
}
