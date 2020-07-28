import 'package:flutter/material.dart';

import '../views/chat_rooms.dart';
import '../services/auth.dart';
import '../services/database.dart';
import '../widgets/custombuttonwidget.dart';
import '../widgets/textformfieldwidget.dart';

class SignUp extends StatefulWidget {
  final Function toggle;
  SignUp(this.toggle);
  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  bool isLoading = false;
  Auth auth = new Auth();
  Database db = new Database();
  final formKey = GlobalKey<FormState>();
  TextEditingController usernameController = new TextEditingController();
  TextEditingController emailController = new TextEditingController();
  TextEditingController passwordController = new TextEditingController();

  signMeUp() {
    if (formKey.currentState.validate()) {
      Map<String, String> userInfo = {
        "username": usernameController.text,
        "email": emailController.text
      };

      setState(() {
        isLoading = true;
      });

      auth
          .signUpWithEmailAndPassword(
              emailController.text, passwordController.text)
          .then((value) {
        //print("${value.userId}");
        db.uploadUserInfo(userInfo);
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => ChatRoom()));
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
                          hintText: 'username',
                          textType: TextInputType.text,
                          controller: usernameController,
                          validator: (value) {
                            return value.isEmpty || value.length < 8
                                ? 'Field must be at least 8 characters'
                                : null;
                          },
                        ),
                        TextFormFieldWidget(
                          hintText: 'email',
                          textType: TextInputType.emailAddress,
                          controller: emailController,
                          validator: (val) {
                            return RegExp(
                                        r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                                    .hasMatch(val)
                                ? null
                                : "Provide valid email";
                          },
                        ),
                        TextFormFieldWidget(
                          hintText: 'password',
                          obscureText: true,
                          controller: passwordController,
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
                    height: 24.0,
                  ),
                  GestureDetector(
                    onTap: () {
                      signMeUp();
                    },
                    child: CustomButton(
                      text: 'Sign Up',
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
                        'Already have an account? Sign in now',
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
