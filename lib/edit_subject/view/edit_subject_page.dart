import 'package:cards_api/cards_api.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:learning_app/edit_subject/cubit/edit_subject_cubit.dart';

class EditSubjectPage extends StatelessWidget {
  EditSubjectPage({super.key, required this.subjectToEdit});

  /// when add_subject_page is used as edit_subject_page, when not let it empty
  final Subject subjectToEdit;

  @override
  Widget build(BuildContext context) {

      final nameController = TextEditingController(text: subjectToEdit!.name);
      final locationController =
          TextEditingController(text: subjectToEdit!.parentSubjectId);
      final iconController = TextEditingController(text: subjectToEdit!.prefixIcon);

    final formKey = GlobalKey<FormState>();
    return Scaffold(
      appBar: AppBar(title: Text('Edit Subject')),
      body: SafeArea(
          child: Form(
        key: formKey,
        child: Column(
          children: [
            /// Name
            TextFormField(
              controller: nameController,
              validator: (value) {
                if (value!.isEmpty) {
                  return 'Enter something';
                } else {
                  return null;
                }
              },
            ),

            /// File Location
            TextFormField(
              controller: locationController,
            ),

            /// Prefix icon
            TextFormField(
              controller: iconController,
            ),
            ElevatedButton(
                onPressed: () async {
                  if (formKey.currentState!.validate()) {
                    await context.read<EditSubjectCubit>().saveSubject(
                        nameController.text,
                        locationController.text,
                        iconController.text);
                  }
                  Navigator.pop(context);
                },
                child: Text("Save"))
          ],
        ),
      )),
    );
  }
}
