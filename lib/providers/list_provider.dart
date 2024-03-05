import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/widgets.dart';

import '../firebase.dart';
import '../model/tasks.dart';

class ListProvider extends ChangeNotifier {
  List<Task> taskList = [];

  DateTime selectedDate = DateTime.now();

  void getAllTasksFromFireStore(String uId) async {
    //get all tasks
    QuerySnapshot<Task> querySnapshot =
        await FirebaseUtils.getTasksCollection(uId).get();
    taskList = querySnapshot.docs.map((doc) {
      return doc.data();
    }).toList();
    //filter(selectedDate)
    taskList = taskList.where((task) {
      if (selectedDate.day == task.datetime!.day &&
          selectedDate.month == task.datetime!.month &&
          selectedDate.year == task.datetime!.year) {
        return true;
      }
      return false;
    }).toList();

    //sorting
    taskList.sort((Task task1, Task task2) {
      return task1.datetime!.compareTo(task2.datetime!);
    });

    notifyListeners();
  }

  void changeSelectedDate(DateTime newSelectedDate,String uId) {
    selectedDate = newSelectedDate;
    getAllTasksFromFireStore(uId);
  }
}
