import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:to_do_app/home/sitting/sitting.dart';
import 'package:to_do_app/home/task_list/add_task_bottom_sheet.dart';
import 'package:to_do_app/home/task_list/task_list.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:to_do_app/login/login_screen.dart';
import 'package:to_do_app/providers/auth._provider.dart';

import '../mt_theme.dart';
import '../providers/app_config_provider.dart';
import '../providers/list_provider.dart';

class HomeScreen extends StatefulWidget {
  static const String routeName = "home_screen";

  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    var provider = Provider.of<AppConfigProvider>(context);
    var authProvider = Provider.of<AuthProviders>(context);
    var listProvider = Provider.of<ListProvider>(context);

    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
              onPressed: () {
                listProvider.taskList = [];
                authProvider.currentUser = null;
                Navigator.pushReplacementNamed(
                  context,
                  LoginScreen.routeName,
                );
              },
              icon: const Icon(Icons.exit_to_app))
        ],
        toolbarHeight: MediaQuery.of(context).size.height * 0.15,
        title: Text(
          "${AppLocalizations.of(context)!.to_do_list} (${authProvider.currentUser!.name!})",
          style: Theme.of(context).textTheme.titleLarge,
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        elevation: 0,
        padding: const EdgeInsets.all(0),
        shape: const CircularNotchedRectangle(),
        notchMargin: 12,
        color: provider.isDarkMode() ? MyTheme.blackColor : MyTheme.whiteColor,
        child: BottomNavigationBar(
          unselectedItemColor:
              provider.isDarkMode() ? MyTheme.whiteColor : MyTheme.grayColor,
          currentIndex: selectedIndex,
          onTap: (index) {
            selectedIndex = index;
            setState(() {});
          },
          items: const [
            BottomNavigationBarItem(
              icon: Icon(
                Icons.list,
              ),
              label: "",
            ),
            BottomNavigationBarItem(icon: Icon(Icons.settings), label: "")
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showAddBottomSheet();
        },
        child: Icon(
          Icons.add,
          color:
              provider.isDarkMode() ? MyTheme.whiteColor : MyTheme.whiteColor,
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      body: selectedIndex == 0 ? const TaskList() : const Sitting(),
      // tabs[selectedIndex]
    );
  }

  void showAddBottomSheet() {
    var provider=Provider.of<AppConfigProvider>(context,listen: false);
    showModalBottomSheet(
      backgroundColor: provider.isDarkMode() ? MyTheme.blackColor : MyTheme.whiteColor,
        context: context, builder: (context) => const TaskBottomSheet());
  }
}
