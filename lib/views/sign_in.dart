import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../services/database.dart';
import '../services/auth.dart';
import '../views/chat_rooms.dart';
import '../widgets/textformfieldwidget.dart';
import '../widgets/custombuttonwidget.dart';
import '../helper/shared_preferences_helper.dart';

class SignIn extends StatefulWidget {
  final Function toggle;
  SignIn(this.toggle);
  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  bool isLoading = false;
  Auth auth = new Auth();
  Database db = new Database();
  final formKey = GlobalKey<FormState>();
  TextEditingController emailController = new TextEditingController();
  TextEditingController passwordController = new TextEditingController();
  QuerySnapshot snapshotUserInfo;

  signMeIn() {
    if (formKey.currentState.validate()) {
      SharedPreferencesHelper.saveEmail(emailController.text);

      setState(() {
        isLoading = true;
      });

      db.getUserByEmail(emailController.text).then((value) {
        snapshotUserInfo = value;
        SharedPreferencesHelper.saveEmail(
            snapshotUserInfo.documents[0].data["username"]);
      });

      auth
          .signInWithEmailAndPassword(
              emailController.text, passwordController.text)
          .then((value) {
        //print("${value.userId}");
        if (value != null) {
          SharedPreferencesHelper.saveLoggedIn(true);
          Navigator.pushReplacement(
              context, MaterialPageRoute(builder: (context) => ChatRoom()));
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    // double width = MediaQuery.of(context).size.width;
    // double height = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        title: Text('ChatApp'),
      ),
      body: isLoading
          ? Center(child: Container(child: CircularProgressIndicator()))
          : Container(
              padding: EdgeInsets.symmetric(
                horizontal: 24.0,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Form(
                    key: formKey,
                    child: Column(
                      children: [
                        TextFormFieldWidget(
                          controller: emailController,
                          hintText: 'email',
                          textType: TextInputType.emailAddress,
                          validator: (val) {
                            return RegExp(
                                        r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                                    .hasMatch(val)
                                ? null
                                : "Provide valid email";
                          },
                        ),
                        TextFormFieldWidget(
                          controller: passwordController,
                          hintText: 'password',
                          obscureText: true,
                          validator: (val) {
                            return val.length < 8
                                ? "Password must be at least 8 characters"
                                : null;
                          },
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 16.0,
                  ),
                  Container(
                    alignment: Alignment.centerRight,
                    padding: EdgeInsets.symmetric(
                      horizontal: 16.0,
                      vertical: 8.0,
                    ),
                    child: Text(
                      'Forgot Password?',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                  SizedBox(
                    height: 16.0,
                  ),
                  GestureDetector(
                    onTap: () {
                      signMeIn();
                    },
                    child: CustomButton(
                      text: 'Sign In',
                    ),
                  ),
                  SizedBox(
                    height: 16.0,
                  ),
                  GestureDetector(
                    onTap: () {
                      widget.toggle();
                    },
                    child: Container(
                      alignment: Alignment.center,
                      padding: EdgeInsets.symmetric(
                        horizontal: 16.0,
                        vertical: 8.0,
                      ),
                      child: Text(
                        'Don\'t have account? Register Now',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}
