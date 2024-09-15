import 'package:flutter/material.dart';
import 'package:ftoast/ftoast.dart';
import 'package:panara_dialogs/panara_dialogs.dart';

import '../utils/strings.dart';
import '../../main.dart';

dynamic emptyFieldsWarning(context){
  return FToast.toast(
    context,
    msg: MyString.oopsMsg,
    subMsg: "Por favor, rellena todos los campos",
    corner: 20.0,
    duration: 2000,
    padding: const EdgeInsets.all(20),
  );
}

dynamic nothingEnterOnUpdateTaskMode(context){
  return FToast.toast(
    context,
    msg: MyString.oopsMsg,
    subMsg: "Debes ingresar algo para actualizar la tarea",
    corner: 20.0,
    duration: 3000,
    padding: const EdgeInsets.all(20),
  );
}

dynamic warningNoTask(BuildContext context){
  return PanaraInfoDialog.showAnimatedGrow(
      context,
      title: MyString.oopsMsg,
      message:
        "¡No hay tareas para eliminar! \n "
      "Intenta agregar algunas y luego intenta eliminarlas.",
      buttonText: "Aceptar",
      onTapDismiss: () {
        Navigator.pop(context);
      },
      panaraDialogType: PanaraDialogType.warning,
  );
}

dynamic deleteAllTask(BuildContext context){
  return PanaraConfirmDialog.show(
      context,
      title: MyString.areYouSure,
      message: "¿Realmente deseas eliminar todas las tareas? \n"
          "¡No podrás deshacer esta acción!",
      confirmButtonText: "Yes",
      cancelButtonText: "No",
      onTapConfirm: () {
        BaseWidget.of(context).dataStore.box.clear();
        Navigator.pop(context);
      },
      onTapCancel: () {
        Navigator.pop(context);
      },
      panaraDialogType: PanaraDialogType.error,
      barrierDismissible: false,
  );
}

String lottieURL = 'assets/lottie/1.json';