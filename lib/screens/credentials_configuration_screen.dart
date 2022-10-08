import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:product_assembly/screens/product_selection_screen.dart';
import 'package:product_assembly/services/temp_file_writing_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CredentialsConfigurationScreen extends StatefulWidget {
  static const routeName = '/credentialsConfiguration';

  @override
  State<CredentialsConfigurationScreen> createState() =>
      _CredentialsConfigurationScreenState();
}

class _CredentialsConfigurationScreenState
    extends State<CredentialsConfigurationScreen>
    with TickerProviderStateMixin {
  bool _usernameIsValidated = false;
  bool _isPasswordValidated = false;
  bool _isValidated = false;
  final usernameTextFieldFormController = TextEditingController();
  final passwordTextFieldFormController = TextEditingController();
  late AnimationController animationController;

  int? initScreen;

  @override
  void initState() {
    usernameTextFieldFormController.text = Platform.environment['USERNAME']
        as String; //Loading the username from env. vars.
    animationController = AnimationController(vsync: this);

    //Adding listeners to the controllers
    animationController.addStatusListener((status) async {
      if (status == AnimationStatus.completed) {
        Navigator.of(context).pop();
        animationController.reset();
      }
    });
    super.initState();

    usernameTextFieldFormController.addListener(() {
      setState(validateUsername);
    });

    passwordTextFieldFormController.addListener(() {
      setState(validatePassword);
    });

    getInitScreenValue();
  }

  void getInitScreenValue() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    initScreen = prefs.getInt("initScreen");
  }

  void setInitScreenToOne() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setInt("initScreen", 1);
  }

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    usernameTextFieldFormController.dispose();
    passwordTextFieldFormController.dispose();
    animationController.dispose();
    super.dispose();
  }

  void validateUsername() {
    final usernamePattern = RegExp(r'^[a-zA-Z]{3,}\.[a-zA-Z]{3,}$');
    if (usernameTextFieldFormController.text.isNotEmpty &&
        usernamePattern.hasMatch(usernameTextFieldFormController.text)) {
      _usernameIsValidated = true;
      if (_isPasswordValidated) {
        _isValidated = true;
      }
    } else {
      _usernameIsValidated = false;
      _isValidated = false;
    }
  }

  void validatePassword() {
    validateUsername();
    if (passwordTextFieldFormController.text.isNotEmpty) {
      _isPasswordValidated = true;
      if (_usernameIsValidated) {
        _isValidated = true;
      }
    } else {
      _isPasswordValidated = false;
      _isValidated = false;
    }
  }

  String getPrettyJSONString(jsonObject) {
    var encoder = const JsonEncoder.withIndent("    ");
    return encoder.convert(jsonObject);
  }

  Future<dynamic> showSuccessDialog() async => showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => Dialog(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Lottie.asset('assets/animations/success_animation.json',
                    width: 100,
                    height: 100,
                    repeat: false,
                    controller: animationController, onLoaded: (composition) {
                  animationController.duration = composition.duration;
                  animationController.forward();
                }),
                const Text(
                  'Saving credentials...',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                const SizedBox(
                  height: 16,
                )
              ],
            ),
          ));

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text("Credentials configuration"),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(top: 60.0),
              child: Center(
                child: Container(
                    width: 200,
                    height: 150,
                    /*decoration: BoxDecoration(
                        color: Colors.red,
                        borderRadius: BorderRadius.circular(50.0)),*/
                    child: const Icon(
                      Icons.lock_open_sharp,
                      color: Color.fromARGB(255, 193, 148, 14),
                      size: 64,
                    )),
              ),
            ),
            Padding(
              //padding: const EdgeInsets.only(left:15.0,right: 15.0,top:0,bottom: 0),
              padding: EdgeInsets.symmetric(horizontal: 15),
              child: TextFormField(
                controller: usernameTextFieldFormController,
                decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Username',
                    hintText:
                        'Enter your active directory username, example: john.doe'),
              ),
            ),
            Padding(
              padding:
                  EdgeInsets.only(left: 15.0, right: 15.0, top: 15, bottom: 15),
              //padding: EdgeInsets.symmetric(horizontal: 15),
              child: TextFormField(
                obscureText: true,
                controller: passwordTextFieldFormController,
                decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Password',
                    hintText: 'Enter your active directory password'),
              ),
            ),
            Container(
              height: 50,
              width: 250,
              decoration:
                  BoxDecoration(borderRadius: BorderRadius.circular(20)),
              child: ElevatedButton(
                  onPressed: _isValidated
                      ? () async {
                          //TODO REFACTOR AND SALT THE PASS MAYBE?
                          String credentialsTemplateJSON =
                              await DefaultAssetBundle.of(context).loadString(
                                  "assets/templates/credentials_template.json");
                          final replacedCredentialsJSON =
                              jsonDecode(credentialsTemplateJSON);
                          (replacedCredentialsJSON["credentials"])
                              .forEach((key, value) {
                            value["username"] =
                                usernameTextFieldFormController.text;
                            value["password"] =
                                passwordTextFieldFormController.text;
                          });

                          TempFileWriter.writeContent(
                              getPrettyJSONString(replacedCredentialsJSON),
                              "credentials",
                              ".json");
                          await showSuccessDialog();
                          if (initScreen == 0 || initScreen == null) {
                            setInitScreenToOne();
                            Navigator.of(context).pushReplacementNamed(
                                ProductAssembly.routeName);
                          } else {
                            Navigator.of(context).pop();
                          }

                          TempFileWriter.saveScriptToTemp(
                              "scripts/runAssemblySyncHidden.vbs");
                        }
                      : null,
                  child: const Text('Set the credentials')),
            )
          ],
        ),
      ),
    );
  }
}
