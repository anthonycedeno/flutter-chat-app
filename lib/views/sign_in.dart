import 'package:flutter/material.dart';

import '../widgets/textfieldwidget.dart';
import '../widgets/custombuttonwidget.dart';

class SignIn extends StatefulWidget {
  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        title: Text('ChatApp'),
      ),
      body: Container(
        padding: EdgeInsets.symmetric(
          horizontal: 24.0,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextFieldWidget(
              hintText: 'email',
              textType: TextInputType.emailAddress,
            ),
            TextFieldWidget(
              hintText: 'password',
              obscureText: true,
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
            CustomButton(
              function: () {},
              text: 'Sign In',
            ),
            SizedBox(
              height: 16.0,
            ),
            Container(
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
          ],
        ),
      ),
    );
  }
}
