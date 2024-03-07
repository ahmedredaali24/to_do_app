import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:to_do_app/dialog_utils.dart';
import 'package:to_do_app/firebase.dart';
import 'package:to_do_app/login/login_screen.dart';
import 'package:to_do_app/login/text_form_field_widget.dart';
import 'package:to_do_app/model/my_user.dart';
import 'package:to_do_app/mt_theme.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../providers/app_config_provider.dart';

import '../providers/auth._provider.dart';

class CreateAccount extends StatefulWidget {
  static const String routeName = "CreateAccount";

  @override
  State<CreateAccount> createState() => _CreateAccountState();
}

class _CreateAccountState extends State<CreateAccount> {
  TextEditingController nameController = TextEditingController(text: "");

  TextEditingController emailController =
      TextEditingController(text: "");

  TextEditingController passwordController =
      TextEditingController(text: "");

  TextEditingController confirmPasswordController =
      TextEditingController(text: "");

  var formKey = GlobalKey<FormState>();

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
            title: Text(AppLocalizations.of(context)!.create_acc),
            centerTitle: true,
            backgroundColor: Colors.transparent,
          ),
          body: SingleChildScrollView(
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
                          label: AppLocalizations.of(context)!.first_name,
                          controller: nameController,
                          validator: (text) {
                            if (text == null || text.trim().isEmpty) {
                              return "please enter user name";
                            }
                            return null;
                          },
                        ),
                        TextFormFieldWidgets(
                          label: AppLocalizations.of(context)!.email,
                          keyboardType: TextInputType.emailAddress,
                          controller: emailController,
                          validator: (text) {
                            if (text == null || text.trim().isEmpty) {
                              return AppLocalizations.of(context)!.val_email;
                            }
                            bool emailValid = RegExp(
                                    r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                                .hasMatch(text);
                            if (!emailValid) {
                              return AppLocalizations.of(context)!.val_email2;
                            }
                            return null;
                          },
                        ),
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
                        TextFormFieldWidgets(
                          obscureText: true,
                          label: AppLocalizations.of(context)!.confirm_password,
                          keyboardType: TextInputType.number,
                          controller: confirmPasswordController,
                          validator: (text) {
                            if (text == null || text.trim().isEmpty) {
                              return AppLocalizations.of(context)!.val_pass;
                            }
                            if (text.length < 6) {
                              return AppLocalizations.of(context)!.val_pass2;
                            }
                            if (text != passwordController.text) {
                              return "confirm password is wrong";
                            }
                            return null;
                          },
                        ),
                        MaterialButton(
                            padding: const EdgeInsets.all(20),
                            onPressed: () {
                              register();
                            },
                            child: Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 10),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    "Create Account",
                                    style: Theme.of(context)
                                        .textTheme
                                        .titleSmall
                                        ?.copyWith(color: MyTheme.grayColor),
                                  ),
                                  Icon(
                                    Icons.arrow_forward_outlined,
                                    color: MyTheme.grayColor,
                                  )
                                ],
                              ),
                            )),
                      ],
                    ))
              ],
            ),
          ),
        )
      ],
    );
  }

  void register() async {
    if (formKey.currentState?.validate() == true) {
      /// show loading
      DialogUtils.showLoading(
          context: context, massage: "Loading....", isDismissible: false);

      try {
        final credential =
            await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: emailController.text,
          password: passwordController.text,
        );
        var myUser = MyUser(
            id: credential.user?.uid ?? "",
            name: nameController.text,
            email: emailController.text);
        await FirebaseUtils.addUseToFireStore(myUser);
        var authProvider = Provider.of<AuthProviders>(context, listen: false);
        authProvider.updateUser(myUser);

        /// hide loading
        DialogUtils.hideLoading(context);

        /// show message
        DialogUtils.showMessage(
            context: context,
            massage: "create successfully",
            title: "Success",
            posActionName: "ok",
            posAction: (context) {
              Navigator.of(context).pushReplacementNamed(LoginScreen.routeName);
            });
        print("create good");
        print(credential.user?.uid ?? "");
      } on FirebaseAuthException catch (e) {
        if (e.code == 'weak-password') {
          /// hide loading
          DialogUtils.hideLoading(context);

          /// show message
          DialogUtils.showMessage(
            context: context,
            massage: 'The password provided is too weak.',
            title: "Error",
            posActionName: "ok",
          );
          print('The password provided is too weak.');
        } else if (e.code == 'email-already-in-use') {
          /// hide loading
          DialogUtils.hideLoading(context);

          /// show message
          DialogUtils.showMessage(
            context: context,
            massage: 'The account already exists for that email.',
            title: "Error",
            posActionName: "ok",
          );
          print('The account already exists for that email.');
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
