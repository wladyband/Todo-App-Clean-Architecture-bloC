import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo/aplication/auth/authBloc/auth_bloc.dart';
import 'package:todo/ui/presentation/routes/router.gr.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        BlocListener<AuthBloc, AuthState>(listener: (context, state) {
          if (state is AuthStateUnauthenticated) {
            AutoRouter.of(context).push(const SignUpPageRoute());
          }
        })
      ],
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(onPressed: (){
            BlocProvider.of<AuthBloc>(context).add(SignOutPressedEvent());
          }, icon: Icon(Icons.exit_to_app)),
          title: Text("tudo"),
        ),
        body: Placeholder(),
      ),
    );
  }
}
