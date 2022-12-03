import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:golek_mobile/logic/auth/auth_bloc.dart';
import 'package:golek_mobile/models/login/login_body.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  Widget _buildText(AuthState state) {
    if (state is LoginLodingState) {
      return Text("Login loading");
    }
    return Text("Login");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is LoginSuccessState) {
          Navigator.pushNamedAndRemoveUntil(context, '/main_screen', (r) => false);
        }
      },
      child: BlocBuilder<AuthBloc, AuthState>(
        builder: (context, state) {
          return Column(
            children: [
              TextButton(
                onPressed: () => {
                  context.read<AuthBloc>().add(LoginEvent(loginBody: LoginBody("septian@gmail.com", "secret12345"))),
                },
                child: Container(
                  child: _buildText(state),
                  margin: EdgeInsets.symmetric(vertical: 100),
                ),
              )
            ],
          );
        },
      ),
    ));
  }
}
