import 'package:easy_date_timeline/easy_date_timeline.dart';
import 'package:flutter/material.dart';
import 'package:to_do_app/home/task_list/task_list_item.dart';
import 'package:provider/provider.dart';
import 'package:to_do_app/mt_theme.dart';
import 'package:to_do_app/providers/auth._provider.dart';

import '../../providers/app_config_provider.dart';
import '../../providers/list_provider.dart';

class TaskList extends StatefulWidget {
  const TaskList({super.key});

  @override
  State<TaskList> createState() => _TaskListState();
}

class _TaskListState extends State<TaskList> {
  @override
  Widget build(BuildContext context) {
    var provider = Provider.of<AppConfigProvider>(context);
    var listProvider = Provider.of<ListProvider>(context);
    var authProvider = Provider.of<AuthProviders>(context);
    if (listProvider.taskList.isEmpty) {
      listProvider.getAllTasksFromFireStore(authProvider.currentUser!.id!);
    }

    return Column(
      children: [
        EasyDateTimeLine(
          locale: provider.appLanguage,
          initialDate: listProvider.selectedDate,
          onDateChange: (selectedDate) {
            listProvider.changeSelectedDate(selectedDate,authProvider.currentUser!.id!);
          },
          dayProps: EasyDayProps(
            height: MediaQuery.of(context).size.height * .14,
            width: 80,
          ),
          headerProps: EasyHeaderProps(
            selectedDateStyle: TextStyle(
                color: provider.isDarkMode()
                    ? MyTheme.primaryColor
                    : MyTheme.blackColor),
            monthStyle: TextStyle(
                color: provider.isDarkMode()
                    ? MyTheme.grayColor
                    : MyTheme.blackColor),
            dateFormatter: const DateFormatter.fullDateMonthAsStrDY(),
          ),
          itemBuilder: (BuildContext context, String dayNumber, dayName,
              monthName, fullDate, isSelected) {
            return Container(
              padding: const EdgeInsets.all(7),
              margin: const EdgeInsets.all(3),
              decoration: BoxDecoration(
                color: isSelected
                    ? MyTheme.primaryColor
                    : provider.isDarkMode()
                        ? MyTheme.blackColor
                        : MyTheme.whiteColor,
                borderRadius: BorderRadius.circular(16.0),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    monthName,
                    style: TextStyle(
                      fontSize: 12,
                      color: isSelected
                          ? Colors.white
                          : provider.isDarkMode()
                              ? MyTheme.whiteColor
                              : MyTheme.blackColor,
                    ),
                  ),
                  const SizedBox(
                    width: 8.0,
                  ),
                  Text(
                    dayNumber,
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: isSelected
                          ? Colors.white
                          : provider.isDarkMode()
                              ? MyTheme.whiteColor
                              : MyTheme.blackColor,
                    ),
                  ),
                  const SizedBox(
                    width: 8.0,
                  ),
                  Text(
                    dayName,
                    style: TextStyle(
                      fontSize: 12,
                      color: isSelected
                          ? Colors.white
                          : provider.isDarkMode()
                              ? MyTheme.whiteColor
                              : MyTheme.blackColor,
                    ),
                  ),
                ],
              ),
            );
          },
        ),
        SizedBox(
          height: MediaQuery.of(context).size.height * 0.055,
        ),
        Expanded(
          child: ListView.builder(
              itemCount: listProvider.taskList.length,
              itemBuilder: (context, index) {
                return TaskListItem(
                  task: listProvider.taskList[index],
                );
              }),
        )
      ],
    );
  }
}
