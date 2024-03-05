import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:to_do_app/firebase.dart';
import 'package:to_do_app/login/text_form_field_widget.dart';
import 'package:to_do_app/mt_theme.dart';

import '../dialog_utils.dart';
import '../home/home_screen.dart';
import '../providers/app_config_provider.dart';
import '../providers/auth._provider.dart';
import 'create_account_screen.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class LoginScreen extends StatefulWidget {
  static const String routeName = "login_screen";

  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _CreateAccountState();
}

class _CreateAccountState extends State<LoginScreen> {
  TextEditingController emailController =
      TextEditingController(text: "ahmed@gmail.com");

  TextEditingController passwordController =
      TextEditingController(text: "12356789");

  var formKey = GlobalKey<FormState>();
  late AppConfigProvider provider;

  // @override
  // void initState() {
  //   super.initState();
  //
  //   WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
  //     provider = Provider.of<AppConfigProvider>(context, listen: false);
  //     provider.getSaveDate();
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    var provider = Provider.of<AppConfigProvider>(context);
    return Stack(
      children: [
        Container(
          color: provider.isDarkMode()
              ? MyTheme.backGroundDarkColor
              : MyTheme.backGroundLightColor,
          child: Image.asset(
            "assets/images/SIGN IN – 1.png",
            width: double.infinity,
            height: double.infinity,
            fit: BoxFit.fill,
          ),
        ),
        Scaffold(
          backgroundColor: Colors.transparent,
          appBar: AppBar(
            title: Text(AppLocalizations.of(context)!.login),
            centerTitle: true,
            backgroundColor: Colors.transparent,
          ),
          body: SingleChildScrollView(
            child: Container(
              padding: const EdgeInsets.all(10),
              child: Column(
                children: [
                  Form(
                      key: formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          SizedBox(
                            height: MediaQuery.of(context).size.height * 0.25,
                          ),
                          TextFormFieldWidgets(
                              label: AppLocalizations.of(context)!.email,
                              keyboardType: TextInputType.emailAddress,
                              controller: emailController,
                              validator: (text) {
                                if (text == null || text.trim().isEmpty) {
                                  return AppLocalizations.of(context)!
                                      .val_email;
                                }
                                //   bool emailValid = RegExp(
                                //           r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                                //       .hasMatch(text);
                                //   if (!emailValid) {
                                //     return AppLocalizations.of(context)!.val_email2;
                                //   }
                                //   return null;
                                // },
                              }),
                          TextFormFieldWidgets(
                            obscureText: true,
                            label: AppLocalizations.of(context)!.pass,
                            keyboardType: TextInputType.number,
                            controller: passwordController,
                            validator: (text) {
                              if (text == null || text.trim().isEmpty) {
                                return AppLocalizations.of(context)!.val_pass;
                              }
                              if (text.length < 6) {
                                return AppLocalizations.of(context)!.val_pass2;
                              }
                              return null;
                            },
                          ),
                          ElevatedButton(
                              onPressed: () {
                                addTaskValidator();
                              },
                              child: Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 10),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      AppLocalizations.of(context)!.login,
                                      style: Theme.of(context)
                                          .textTheme
                                          .titleSmall
                                          ?.copyWith(color: MyTheme.whiteColor),
                                    ),
                                    Icon(
                                      Icons.arrow_forward_outlined,
                                      color: MyTheme.whiteColor,
                                    )
                                  ],
                                ),
                              )),
                          SizedBox(
                            height: MediaQuery.of(context).size.height * 0.05,
                          ),
                          GestureDetector(
                            onTap: () {
                              Navigator.of(context)
                                  .pushNamed(CreateAccount.routeName);
                            },
                            child: Text(
                              AppLocalizations.of(context)!.create_acc,
                              style: Theme.of(context)
                                  .textTheme
                                  .titleMedium
                                  ?.copyWith(color: MyTheme.grayColor),
                            ),
                          )
                        ],
                      ))
                ],
              ),
            ),
          ),
        )
      ],
    );
  }

  void addTaskValidator() async {
    if (formKey.currentState?.validate() == true) {
      /// show loading
      DialogUtils.showLoading(
          context: context, massage: "Loading....", isDismissible: false);
      try {
        final credential = await FirebaseAuth.instance
            .signInWithEmailAndPassword(
                email: emailController.text, password: passwordController.text);
        var user = await FirebaseUtils.readUserFromFireStore(
            credential.user?.uid ?? "");
        if (user == null) {
          return;
        }
        var authProvider = Provider.of<AuthProviders>(context, listen: false);
        authProvider.updateUser(user);

        /// hide loading
        DialogUtils.hideLoading(context);

        /// show message
        DialogUtils.showMessage(
            context: context,
            massage: "Login Successfully",
            title: "Success",
            posActionName: "ok",
            posAction: (context) {
              Navigator.of(context).pushReplacementNamed(HomeScreen.routeName);
            });
        print('login succ');
        print(credential.user?.uid ?? "");
      } on FirebaseAuthException catch (e) {
        if (e.code == 'invalid-credential') {
          /// hide loading
          DialogUtils.hideLoading(context);

          /// show message
          DialogUtils.showMessage(
            context: context,
            massage: 'No user found for that email.',
            title: "Error",
            posActionName: "ok",
          );
          print('No user found for that email.');
        }
      } catch (e) {
        /// hide loading
        DialogUtils.hideLoading(context);

        /// show message
        DialogUtils.showMessage(
          context: context,
          massage: e.toString(),
          title: "Error",
          posActionName: "ok",
        );
        print(e.toString());
      }
    }
  }
}
