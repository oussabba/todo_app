import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo_app/shared/components/components.dart';
import 'package:todo_app/shared/cubit/cubit.dart';
import 'package:todo_app/shared/cubit/states.dart';

class ArchivedTasksScreen extends StatelessWidget {
  const ArchivedTasksScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<MyAppCubit, MyAppStates>(
        listener: (context, state) {},
        builder: (context, state) {
          var tasks = MyAppCubit.get(context).archivedTasks;
          if (tasks.length == 0) {
            return Center(
              child: Container(
                width: double.infinity,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Icon(
                      Icons.menu,
                      size: 100,
                    ),
                    Text(
                      'No tasks here',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            );
          } else {
            return ListView.separated(
                itemBuilder: (context, index) =>
                    buildTaskItem(task: tasks[index], context: context),
                separatorBuilder: (context, index) => Padding(
                      padding: const EdgeInsetsDirectional.only(start: 20.0),
                      child: Container(
                        width: double.infinity,
                        height: 1.0,
                        color: Colors.grey[300],
                      ),
                    ),
                itemCount: tasks.length);
          }
        });
  }
}
