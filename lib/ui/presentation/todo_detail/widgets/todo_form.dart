import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo/aplication/todo/todoForm/todo_form_bloc.dart';
import 'package:todo/ui/presentation/core/custom_button.dart';
import 'package:todo/ui/presentation/todo_detail/widgets/color_field.dart';

class TodoForm extends StatelessWidget {

  const TodoForm({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final GlobalKey<FormState> formKey = GlobalKey<FormState>();
    final textEditingControllerTitle = TextEditingController();
    final textEditingControllerBody = TextEditingController();

    late String title;
    late String body;

    String? validateTitle(String? input) {
      if (input == null || input.isEmpty) {
        return "please enter a title";
      }else if(input.length < 30){
        title = input;
        return null;
      }else{
        return "title too long";
      }
    }

    String? validateBody(String? input) {
      if (input == null || input.isEmpty) {
        return "please enter a description";
      }else if(input.length < 300){
        body = input;
        return null;
      }else{
        return "body too long";
      }
    }

    return BlocConsumer<TodoFormBloc, TodoFormState>(
      listenWhen: (previous, current) => previous.isEditing != current.isEditing,
      listener: (context, state) {
        textEditingControllerTitle.text = state.todo.title;
        textEditingControllerBody.text = state.todo.body;
      },
      builder: (context, state) {
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 30),
          child: Form(
            key: formKey,
            autovalidateMode:
                state.showErrorMessages
                    ? AutovalidateMode.always
                    : AutovalidateMode.disabled,
            child: ListView(
              children: [
                TextFormField(
                  controller: textEditingControllerTitle,
                  cursorColor: Colors.white,
                  validator: validateTitle,
                  maxLength: 100,
                  maxLines: 2,
                  minLines: 1,
                  decoration: InputDecoration(
                      labelText: "Title",
                      counterText: "",
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8))),

                ),
                const SizedBox(
                  height: 20,
                ),
                TextFormField(
                  controller: textEditingControllerBody,
                  cursorColor: Colors.white,
                  validator: validateBody,
                  maxLength: 300,
                  maxLines: 8,
                  minLines: 5,
                  decoration: InputDecoration(
                      labelText: "Body",
                      counterText: "",
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8))),

                ),
                const SizedBox(
                  height: 20,
                ),
                ColorField(color: state.todo.color),
                CustomButton(
                  buttonText: "Safe",
                  callBack: () {
                    if (formKey.currentState!.validate()) {
                      BlocProvider.of<TodoFormBloc>(context)
                          .add(SafePressedEvent(title: title, body: body)); //color: body,
                    } else {
                      BlocProvider.of<TodoFormBloc>(context)
                          .add(SafePressedEvent(title: null, body: null));

                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          backgroundColor: Colors.redAccent,
                          content: Text(
                            "Invalid input",
                            style: Theme.of(context).textTheme.bodyText1,
                          )));
                    }
                  },
                )
              ],
            ),
          ),
        );
      },
    );
  }
}
