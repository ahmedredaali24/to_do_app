import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:to_do_app/firebase.dart';
import 'package:to_do_app/providers/auth._provider.dart';

import '../../model/tasks.dart';
import '../../mt_theme.dart';
import '../../providers/app_config_provider.dart';
import '../../providers/list_provider.dart';
import 'package:awesome_dialog/awesome_dialog.dart';

class TaskBottomSheet extends StatefulWidget {
  const TaskBottomSheet({super.key});

  @override
  State<TaskBottomSheet> createState() => _TaskBottomSheetState();
}

class _TaskBottomSheetState extends State<TaskBottomSheet> {
  var selectedDate = DateTime.now();
  var formKey = GlobalKey<FormState>();
  String title = "";
  String des = "";

  late ListProvider listProvider;

  @override
  Widget build(BuildContext context) {
    var provider = Provider.of<AppConfigProvider>(context);
    listProvider = Provider.of<ListProvider>(context);

    return Container(
      height: MediaQuery.of(context).size.height * 7,
      padding: const EdgeInsets.all(15),

      child: SingleChildScrollView(
        child: Column(
          // crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
                child: Text(
              AppLocalizations.of(context)!.add_task,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: provider.isDarkMode()
                      ? MyTheme.whiteColor
                      : MyTheme.blackColor),
            )),
            Form(
              key: formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  TextFormField(
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
                        hintText: AppLocalizations.of(context)!.enter_task),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  TextFormField(
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
                        hintText: AppLocalizations.of(context)!.enter_des),
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
                      onPressed: () {
                        addTask();
                      },
                      child: Text(
                        AppLocalizations.of(context)!.add,
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
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

  void addTask() {
    if (formKey.currentState?.validate() == true) {
      var authProvider = Provider.of<AuthProviders>(context, listen: false);

      /// show loading
      // DialogUtils.showLoading(context: context, massage: "Loading...");
      AwesomeDialog(
        dialogBackgroundColor: Colors.blue,
        context: context,
        dialogType: DialogType.success,
        animType: AnimType.rightSlide,
        title: 'task add successfully',
        titleTextStyle: Theme.of(context).textTheme.titleLarge,
        btnOkOnPress: () {
          Navigator.pop(context);
        },
      ).show();
      //add task
      Task task = Task(title: title, description: des, datetime: selectedDate);
      FirebaseUtils.addTaskToFireStore(task, authProvider.currentUser!.id!)
          .then((value) {
        print("task add good");



        listProvider.getAllTasksFromFireStore(authProvider.currentUser!.id!);

      }).timeout(const Duration(microseconds: 500), onTimeout: () {
        print("task add good");

        listProvider.getAllTasksFromFireStore(authProvider.currentUser!.id!);
      });
    }
  }
}
