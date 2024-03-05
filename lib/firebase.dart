import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:to_do_app/model/my_user.dart';

import 'model/tasks.dart';

class FirebaseUtils {
  /// tasksCollection
  static CollectionReference<Task> getTasksCollection(String uId) {
    return getUsersCollection()
        .doc(uId)
        .collection(Task.collectionName)
        .withConverter<Task>(
            fromFirestore: ((snapshot, options) =>
                Task.fromJson(snapshot.data()!)),
            toFirestore: (task, _) => task.toJson());
  }

  static Future<void> addTaskToFireStore(Task task, String uId) {
    CollectionReference<Task> taskCollection =
        getTasksCollection(uId); //collection

    DocumentReference<Task> taskDocRef = taskCollection.doc();
    task.id = taskDocRef.id; //auto id

    return taskDocRef.set(task);
    //  return getTasksCollection().doc().set(task);
  }

  static Future<void> deleteTaskFromFireStore(Task task, String uId) {
    return getTasksCollection(uId).doc(task.id).delete();
  }

  static isDoneUpdate(Task task, String uId) {
    return getTasksCollection(uId).doc(task.id).update({"isDone": true});
  }

  static isDoneUpdate2(Task task, String uId) {
    return getTasksCollection(uId).doc(task.id).update({"isDone": false});
  }

  static updateAllTasks(Task task,String uId){
    return getTasksCollection(uId).doc(task.id).update({


    });
  }

  /// usersCollection
  static CollectionReference<MyUser> getUsersCollection() {
    return FirebaseFirestore.instance
        .collection(MyUser.collectionName)
        .withConverter(
            fromFirestore: ((snapshot, options) =>
                MyUser.fromJson(snapshot.data()!)),
            toFirestore: (user, _) => user.toJson());
  }

  static Future<void> addUseToFireStore(MyUser myUser) {
    return getUsersCollection().doc(myUser.id).set(myUser);
  }

  static Future<MyUser?> readUserFromFireStore(String uId) async {
    var querySnapShot = await getUsersCollection().doc(uId).get();
    return querySnapShot.data();
  }

}
