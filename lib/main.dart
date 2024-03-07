import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:to_do_app/mt_theme.dart';
import 'package:to_do_app/providers/app_config_provider.dart';
import 'package:to_do_app/providers/auth._provider.dart';
import 'package:to_do_app/providers/list_provider.dart';
import 'home/home_screen.dart';
import 'login/create_account_screen.dart';
import 'login/login_screen.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: const FirebaseOptions(
      apiKey: "AIzaSyDzrDhAFF5hq7pEbLH5-MpudbbnoR4z2-g",
      appId: "1:845088460805:android:b1b52b25487a71c8b7cc6c",
      messagingSenderId: "845088460805",
      projectId: "to-do-app-7e3e2",
      storageBucket: "to-do-app-7e3e2.appspot.com",
    ),
  );
  // FirebaseFirestore.instance.settings =
  //     const Settings(cacheSizeBytes: Settings.CACHE_SIZE_UNLIMITED);
  // await FirebaseFirestore.instance.disableNetwork();

  runApp(MultiProvider(providers: [
    ChangeNotifierProvider(create: (context) => AppConfigProvider()),
    ChangeNotifierProvider(create: (context) => ListProvider()),
    ChangeNotifierProvider(create: (context) => AuthProviders())
  ], child: const MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    var provider = Provider.of<AppConfigProvider>(context);
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: LoginScreen.routeName,
      routes: {
        HomeScreen.routeName: (context) => const HomeScreen(),
        LoginScreen.routeName: (context) => const LoginScreen(),
        CreateAccount.routeName: (context) => CreateAccount(),
      },
      theme: MyTheme.lightTheme,
      themeMode: provider.appTheme,
      darkTheme: MyTheme.darkMode,
      locale: Locale(provider.appLanguage),
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
    );
  }
}
