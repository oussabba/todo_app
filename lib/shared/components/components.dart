import 'package:flutter/material.dart';
import 'package:todo_app/shared/cubit/cubit.dart';

Widget buildTextField(
    {required controller,
    required type,
    required String? Function(String?)? validate,
    required label,
    required prefix,
    onTap}) {
  return TextFormField(
    controller: controller,
    decoration: InputDecoration(
        hintText: label,
        prefixIcon: prefix,
        border: const OutlineInputBorder(
            borderSide: BorderSide(color: Colors.grey))),
    keyboardType: type,
    validator: validate,
    onTap: onTap,
  );
}

Widget buildTaskItem({required task, context}) {
  return Dismissible(
    key: Key(task['id'].toString()),
    onDismissed: (direction) {
      MyAppCubit.get(context).deleteFromDB(id: task['id']);
    },
    child: Padding(
      padding: const EdgeInsets.all(20),
      child: Row(
        children: [
          CircleAvatar(
            radius: 40.0,
            child: Text(task['time']),
          ),
          const SizedBox(
            width: 20.0,
          ),
          Expanded(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(
                  task['title'],
                  style: const TextStyle(
                    fontSize: 18.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  task['date'],
                  style: const TextStyle(
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(
            width: 20.0,
          ),
          IconButton(
            onPressed: () {
              MyAppCubit.get(context).updateDB(status: 'done', id: task['id']);
            },
            icon: const Icon(Icons.check_box),
            color: Colors.green,
          ),
          const SizedBox(
            width: 20.0,
          ),
          IconButton(
            onPressed: () {
              MyAppCubit.get(context)
                  .updateDB(status: 'archive', id: task['id']);
            },
            icon: const Icon(
              Icons.archive,
              color: Colors.black54,
            ),
          )
        ],
      ),
    ),
  );
}
