import 'dart:developer';

import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:golek_mobile/logic/auth/auth_bloc.dart';
import 'package:golek_mobile/models/login/login_body.dart';

class LoginScreen extends StatefulWidget {
  LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  String _errorMessage = '';
  TextEditingController usernameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState

    super.initState();
  }

  void validateEmail(String val) {
    if (val.isEmpty) {
      setState(() {
        _errorMessage = "Email can not be empty";
      });
    } else if (!EmailValidator.validate(val, true)) {
      setState(() {
        _errorMessage = "Invalid Email Address";
      });
    } else {
      setState(() {
        _errorMessage = "";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is LoginSuccessState) {
          Navigator.pushNamedAndRemoveUntil(context, '/main_screen', (r) => false);
          ScaffoldMessenger.of(context).removeCurrentSnackBar();
        } else if (state is LoginLodingState) {
          final snackBar = SnackBar(
            // backgroundColor: Colors.white,
            duration: const Duration(minutes: 1),
            content: Row(
              children: const [
                SizedBox(
                  height: 30,
                  width: 30,
                  child: CircularProgressIndicator(),
                ),
                Padding(
                  padding: EdgeInsets.only(left: 12.0),
                  child: Text("Login..."),
                )
              ],
            ),
          );

          // Find the ScaffoldMessenger in the widget tree
          // and use it to show a SnackBar.
          ScaffoldMessenger.of(context).showSnackBar(snackBar);
        } else if (state is LoginFailState) {
          setState(() {
            _errorMessage = state.error.toString();
          });
        }
      },
      child: BlocBuilder<AuthBloc, AuthState>(
        builder: (context, state) {
          return Container(
            padding: EdgeInsets.only(left: 20, right: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        width: 100,
                        height: 30,
                        child: Image.asset("assets/images/logo.png"),
                      ),
                      Container(
                        child: TextFormField(
                          controller: usernameController,
                          cursorColor: const Color.fromARGB(255, 163, 4, 33),
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                            enabledBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.black),
                            ),
                            focusedBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.black),
                            ),
                            hintText: 'Email',
                          ),
                          onChanged: (val) {
                            validateEmail(val);
                          },
                        ),
                      ),
                      Container(
                        child: TextFormField(
                          controller: passwordController,
                          obscureText: true,
                          cursorColor: const Color.fromARGB(255, 163, 4, 33),
                          decoration: const InputDecoration(
                            border: UnderlineInputBorder(),
                            enabledBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.black),
                            ),
                            focusedBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.black),
                            ),
                            hintText: 'Password',
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          _errorMessage,
                          style: TextStyle(color: Color.fromARGB(255, 168, 8, 40)),
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(top: 0),
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color.fromARGB(255, 176, 39, 73),
                            elevation: 3,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
                            minimumSize: Size(MediaQuery.of(context).size.width, 42),
                          ),
                          onPressed: () => {
                            // log("${usernameController.text}${passwordController.text}"),
                            context.read<AuthBloc>().add(LoginEvent(loginBody: LoginBody(usernameController.text, passwordController.text))),
                          },
                          child: Container(
                            child: const Text("Login"),
                            margin: EdgeInsets.symmetric(vertical: 10),
                          ),
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
          );
        },
      ),
    ));
  }
}
