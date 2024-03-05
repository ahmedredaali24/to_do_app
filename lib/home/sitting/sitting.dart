import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../mt_theme.dart';
import '../../providers/app_config_provider.dart';
import 'langauge_bootom_sheet.dart';

class Sitting extends StatefulWidget {
  const Sitting({super.key});

  @override
  State<Sitting> createState() => _SittingState();
}

class _SittingState extends State<Sitting> {
  String? mode;

  @override
  Widget build(BuildContext context) {
    var provider = Provider.of<AppConfigProvider>(context);
    return Container(
      margin: const EdgeInsets.all(15),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 0.1 * MediaQuery.of(context).size.height,
            ),
            Text(
              AppLocalizations.of(context)!.language,
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    color: provider.isDarkMode()
                        ? MyTheme.whiteColor
                        : MyTheme.blackColor,
                  ),
            ),
            SizedBox(
              height: .01 * MediaQuery.of(context).size.height,
            ),
            InkWell(
              onTap: () {
                showLanguageBottomSheet();
              },
              child: Container(
                padding: const EdgeInsets.all(10),
                margin: const EdgeInsets.all(15),
                decoration: BoxDecoration(
                    color: provider.isDarkMode()
                        ? MyTheme.primaryColor
                        : MyTheme.primaryColor,
                    borderRadius: BorderRadius.circular(15)),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                        provider.appLanguage == "en"
                            ? AppLocalizations.of(context)!.english
                            : AppLocalizations.of(context)!.arabic,
                        style: Theme.of(context)
                            .textTheme
                            .bodyMedium
                            ?.copyWith(fontSize: 20)),
                    const Icon(
                      Icons.arrow_drop_down,
                      size: 35,
                    )
                  ],
                ),
              ),
            ),
            SizedBox(
              height: .05 * MediaQuery.of(context).size.height,
            ),
            Text(
              AppLocalizations.of(context)!.theme,
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    color: provider.isDarkMode()
                        ? MyTheme.whiteColor
                        : MyTheme.blackColor,
                  ),
            ),
            SizedBox(
              height: .01 * MediaQuery.of(context).size.height,
            ),
            RadioListTile(
              dense: true,
              tileColor: provider.isDarkMode()
                  ? MyTheme.backGroundDarkColor
                  : Colors.transparent,
              selectedTileColor: provider.isDarkMode()
                  ? MyTheme.primaryColor
                  : MyTheme.primaryColor,
              selected: mode == "light" ? true : false,
              title: Text(
                AppLocalizations.of(context)!.light,
                style: TextStyle(
                    fontSize: 20,
                    color: provider.isDarkMode()
                        ? MyTheme.whiteColor
                        : MyTheme.blackColor),
              ),
              onChanged: (val) {
                setState(() {
                  mode = val;
                  provider.changThemeMode(ThemeMode.light);
                });
              },
              groupValue: mode,
              value: "light",
            ),
            SizedBox(
              height: 0.01 * MediaQuery.of(context).size.height,
            ),
            RadioListTile(

              tileColor: provider.isDarkMode()
                  ? Colors.transparent
                  : Colors.transparent,
              selectedTileColor: provider.isDarkMode()
                  ? MyTheme.primaryColor
                  : MyTheme.primaryColor,
              selected: mode == "dark" ? true : false,
              title: Text(
                AppLocalizations.of(context)!.dark,
                style: TextStyle(
                    fontSize: 20,
                    color: provider.isDarkMode()
                        ? MyTheme.whiteColor
                        : MyTheme.blackColor),
              ),
              onChanged: (val) async {
                mode = val;
                provider.changThemeMode(ThemeMode.dark);
                setState(() {});
              },
              groupValue: mode,
              value: "dark",
            ),
          ],
        ),
      ),
    );
  }

  void showLanguageBottomSheet() {
    showModalBottomSheet(
        context: (context),
        builder: (context) {
          return const LangugeBottomSheet();
        });
  }
}
