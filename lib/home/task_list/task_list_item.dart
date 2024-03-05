
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:to_do_app/firebase.dart';
import 'package:to_do_app/model/tasks.dart';
import 'package:to_do_app/mt_theme.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:to_do_app/providers/list_provider.dart';
import '../../providers/app_config_provider.dart';
import '../../providers/auth._provider.dart';

class TaskListItem extends StatefulWidget {
  final Task task;

  const TaskListItem({super.key, required this.task});

  @override
  State<TaskListItem> createState() => _TaskListItemState();
}

class _TaskListItemState extends State<TaskListItem> {
  var selectedDate = DateTime.now();
  var formKey = GlobalKey<FormState>();
  String title = "";
  String des = "";

  late ListProvider listProvider;
  late AuthProviders authProvider;

  @override
  Widget build(BuildContext context) {
    var provider = Provider.of<AppConfigProvider>(context);

    listProvider = Provider.of<ListProvider>(context);
    authProvider = Provider.of<AuthProviders>(context);

    return Container(
      margin: const EdgeInsets.all(10),
      child: Slidable(
        endActionPane: ActionPane(
          extentRatio: 0.25,
          motion: const DrawerMotion(),
          children: [
            SlidableAction(
              borderRadius: BorderRadius.circular(25),
              onPressed: (context) {
                upDateTasks(widget.task, authProvider.currentUser!.id!);
              },
              backgroundColor: MyTheme.greenColor,
              foregroundColor: MyTheme.whiteColor,
              icon: Icons.edit,
              label: AppLocalizations.of(context)!.edit,
            ),
          ],
        ),
        startActionPane: ActionPane(
          extentRatio: 0.25,
          motion: const DrawerMotion(),
          children: [
            SlidableAction(
              borderRadius: BorderRadius.circular(25),
              onPressed: (context) {
                deleteTask();
              },
              backgroundColor: MyTheme.redColor,
              foregroundColor: MyTheme.whiteColor,
              icon: Icons.delete,
              label: AppLocalizations.of(context)!.delete,
            ),
          ],
        ),
        child: Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15),
              color: provider.isDarkMode()
                  ? MyTheme.blackColor
                  : MyTheme.whiteColor),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                height: MediaQuery.of(context).size.height * 0.11,
                width: 3,
                color: widget.task.isDone!
                    ? MyTheme.greenColor
                    : MyTheme.primaryColor,
              ),
              const SizedBox(
                width: 12,
              ),
              Expanded(
                  child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.task.title ?? "",
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        color: widget.task.isDone!
                            ? MyTheme.greenColor
                            : MyTheme.primaryColor),
                  ),
                  Text(
                    widget.task.description ?? "",
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                          color: provider.isDarkMode()
                              ? MyTheme.whiteColor
                              : MyTheme.blackColor,
                        ),
                  ),
                ],
              )),
              InkWell(
                  onTap: () {
                    isDoneTrue();
                  },
                  child: Container(
                      padding: const EdgeInsets.symmetric(
                          vertical: 7, horizontal: 23),
                      decoration: BoxDecoration(
                        color: widget.task.isDone == true
                            ? Colors.transparent
                            : MyTheme.primaryColor,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: widget.task.isDone == true
                          ? Text(
                              "Done!",
                              style: Theme.of(context)
                                  .textTheme
                                  .titleLarge
                                  ?.copyWith(
                                    color: MyTheme.greenColor,
                                  ),
                            )
                          : Icon(
                              Icons.check,
                              color: MyTheme.whiteColor,
                            ))),

            ],
          ),
        ),
      ),
    );
  }

  void showCalender() async {
    var chosenDate = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime.now(),
        lastDate: DateTime.now().add(const Duration(days: 356)));
    if (chosenDate != null) {
      selectedDate = chosenDate;
      setState(() {});
    }
    // selectedDate=chosenDate??DateTime.now()
  }

  /// functions

  // deleteTask function
  void deleteTask() {
    FirebaseUtils.deleteTaskFromFireStore(
            widget.task, authProvider.currentUser!.id!)
        .then((value) {
      print("delete done");
      listProvider.getAllTasksFromFireStore(authProvider.currentUser!.id!);
    }).timeout(const Duration(microseconds: 500), onTimeout: () {
      print("delete done");
      listProvider.getAllTasksFromFireStore(authProvider.currentUser!.id!);
    });
  }

// update is done Task function
  void isDoneTrue() {
    FirebaseUtils.isDoneUpdate(widget.task, authProvider.currentUser!.id!)
        .then((value) {
      print("is  done true");
      listProvider.getAllTasksFromFireStore(authProvider.currentUser!.id!);
    }).timeout(const Duration(milliseconds: 600), onTimeout: () {
      print("is  done true");
      listProvider.getAllTasksFromFireStore(authProvider.currentUser!.id!);
    });
  }

  Future<void> upDateTasks(Task task, String uId) async {
    var provider = Provider.of<AppConfigProvider>(context, listen: false);
    TextEditingController titleController =
        TextEditingController(text: widget.task.title);
    TextEditingController desController =
        TextEditingController(text: widget.task.description);
     Task(title: title, description: des, datetime: selectedDate);
    showModalBottomSheet(
        context: context,
        builder: (context) {
          return Container(
            height: MediaQuery.of(context).size.height * 7,
            color:
                provider.isDarkMode() ? MyTheme.blackColor : MyTheme.whiteColor,
            padding: const EdgeInsets.all(15),
            // margin: const EdgeInsets.all(10),
            // color: Colors.green,
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Center(
                      child: Text(
                    AppLocalizations.of(context)!.edit_task,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        color: provider.isDarkMode()
                            ? MyTheme.whiteColor
                            : MyTheme.blackColor),
                  )),

                  /// 222222
                  Form(
                    key: formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        TextFormField(
                          controller: titleController,
                          onChanged: (text) {
                            title = text;
                          },
                          validator: (text) {
                            if (text == null || text.isEmpty) {
                              return AppLocalizations.of(context)!.task_title;
                            }
                            return null;
                          },
                          decoration: InputDecoration(
                              hintStyle: TextStyle(
                                  color: provider.isDarkMode()
                                      ? MyTheme.whiteColor
                                      : MyTheme.blackColor),
                              hintText:
                                  AppLocalizations.of(context)!.enter_task),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        TextFormField(
                          controller: desController,
                          onChanged: (text) {
                            des = text;
                          },
                          validator: (text) {
                            if (text == null || text.isEmpty) {
                              return AppLocalizations.of(context)!.task_des;
                            }
                            return null;
                          },
                          decoration: InputDecoration(
                              hintStyle: TextStyle(
                                  color: provider.isDarkMode()
                                      ? MyTheme.whiteColor
                                      : MyTheme.blackColor),
                              hintText:
                                  AppLocalizations.of(context)!.enter_des),
                          maxLines: 4,
                        ),
                        const SizedBox(
                          height: 15,
                        ),
                        Text(
                          AppLocalizations.of(context)!.select_date,
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                        const SizedBox(
                          height: 15,
                        ),
                        Center(
                          child: InkWell(
                            onTap: () {
                              showCalender();
                            },
                            child: Text(
                              DateFormat.yMMMd().format(selectedDate),
                              style: Theme.of(context).textTheme.titleSmall,
                            ),
                          ),
                        ),
                        ElevatedButton(
                            onPressed: () async {
                              await FirebaseUtils.getTasksCollection(uId)
                                  .doc(widget.task.id)
                                  .update({
                                "title": title,
                                "description": des,
                                "isDone": false

                              }).then((value) {

                                print("is  done true");
                                Navigator.pop(context);
                                showDialog(context: context, builder: (context){
                                  return AlertDialog(

                                    content: const Text("task Update successfully",textAlign: TextAlign.center,),
                                    actions: [
                                      ElevatedButton(onPressed: (){ Navigator.pop(context);}, child:const Text("ok"))
                                    ],

                                  );
                                    });
                                listProvider.getAllTasksFromFireStore(
                                    authProvider.currentUser!.id!);

                              }).timeout(const Duration(milliseconds: 600),
                                      onTimeout: () {
                                print("is  done true");
                                listProvider.getAllTasksFromFireStore(
                                    authProvider.currentUser!.id!);

                              });
                            },
                            child: Text(
                              AppLocalizations.of(context)!.save_change,
                              style: Theme.of(context)
                                  .textTheme
                                  .titleLarge
                                  ?.copyWith(
                                      color: provider.isDarkMode()
                                          ? MyTheme.whiteColor
                                          : MyTheme.whiteColor),
                            ))
                      ],
                    ),
                  )
                ],
              ),
            ),
          );
        });
  }
}
