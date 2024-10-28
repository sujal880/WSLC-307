import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:wslc_302/models/signupmodel.dart';
import 'package:wslc_302/widgets/uihelper.dart';
import 'package:http/http.dart' as http;

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController usernameController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("POST API"),
        centerTitle: true,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          UiHelper.CustomTextField(
              controller: emailController, text: "Enter Email"),
          UiHelper.CustomTextField(
              controller: passwordController, text: "Enter Password"),
          UiHelper.CustomTextField(
              controller: usernameController, text: "Enter Username"),
          SizedBox(
            height: 20,
          ),
          ElevatedButton(
              onPressed: () {
                signup(
                    email: emailController.text.toString(),
                    password: passwordController.text.toString(),
                    username: usernameController.text.toString());
              },
              child: Text("Sign Up"))
        ],
      ),
    );
  }

  signup(
      {required String email,
      required String password,
      required String username}) async {
    if (email == "" || password == "" || username == "") {
      return log("Enter Required Field's");
    } else {
      final response = await http.post(
        Uri.parse("https://news-app-eosin-beta.vercel.app/newsapp/signup"),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(
            {"email": email, "password": password, "username": username}),
      );
      if (response.statusCode == 200) {
        Map<String, dynamic> responsedata = jsonDecode(response.body);
        SignUpModel signUpModel = SignUpModel.fromJson(responsedata);
        log(signUpModel.response!.username.toString());
      } else {
        log("Error Occured");
      }
    }
  }
}
