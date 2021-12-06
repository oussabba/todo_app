import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:todo_app/shared/components/components.dart';
import 'package:todo_app/shared/cubit/cubit.dart';
import 'package:todo_app/shared/cubit/states.dart';

class HomeLayout extends StatelessWidget {
  var scaffoldKey = GlobalKey<ScaffoldState>();
  var formKey = GlobalKey<FormState>();
  var titleController = TextEditingController();
  var dateController = TextEditingController();
  var timeController = TextEditingController();

  HomeLayout({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) => MyAppCubit()..createDB(),
      child: BlocConsumer<MyAppCubit, MyAppStates>(listener: (context, state) {
        if (state is InsertDBState) {
          Navigator.pop(context);
        }
      }, builder: (context, state) {
        MyAppCubit cubit = MyAppCubit.get(context);
        return Scaffold(
          key: scaffoldKey,
          appBar: AppBar(
            title: const Text('Todo app'),
          ),
          body: cubit.screens[cubit.currentIndex],
          floatingActionButton: FloatingActionButton(
            child: Icon(cubit.fabIcon),
            onPressed: () {
              if (cubit.isBottomSheetShown) {
                if (formKey.currentState!.validate()) {
                  cubit.insertToDB(
                    title: titleController.text,
                    date: dateController.text,
                    time: timeController.text,
                  );

                  cubit.changeBottomSheetState(isShown: false);
                }
              } else {
                scaffoldKey.currentState!
                    .showBottomSheet((context) => Container(
                          color: Colors.grey[300],
                          padding: const EdgeInsets.all(20),
                          child: Form(
                            key: formKey,
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                buildTextField(
                                  controller: titleController,
                                  type: TextInputType.text,
                                  validate: (value) {
                                    if (value!.isEmpty) {
                                      return 'Title must not be empty';
                                    }
                                    return null;
                                  },
                                  label: 'Task title',
                                  prefix: const Icon(Icons.title),
                                ),
                                const SizedBox(
                                  height: 20,
                                ),
                                buildTextField(
                                  controller: dateController,
                                  type: TextInputType.text,
                                  onTap: () {
                                    showDatePicker(
                                            context: context,
                                            initialDate: DateTime.now(),
                                            firstDate: DateTime.now(),
                                            lastDate:
                                                DateTime.parse('2030-12-03'))
                                        .then((value) => dateController.text =
                                            DateFormat()
                                                .add_yMMMd()
                                                .format(value!));
                                  },
                                  validate: (value) {
                                    if (value!.isEmpty) {
                                      return 'Date must not be empty';
                                    }
                                    return null;
                                  },
                                  label: 'Task date',
                                  prefix:
                                      const Icon(Icons.calendar_today_outlined),
                                ),
                                const SizedBox(
                                  height: 20,
                                ),
                                buildTextField(
                                  controller: timeController,
                                  type: TextInputType.datetime,
                                  onTap: () {
                                    showTimePicker(
                                            context: context,
                                            initialTime: TimeOfDay.now())
                                        .then((value) => timeController.text =
                                            value!.format(context).toString());
                                  },
                                  validate: (value) {
                                    if (value!.isEmpty) {
                                      return 'Time must not be empty';
                                    }
                                    return null;
                                  },
                                  label: 'Task time',
                                  prefix: const Icon(Icons.watch),
                                ),
                              ],
                            ),
                          ),
                        ))
                    .closed
                    .then((value) {
                  cubit.changeBottomSheetState(isShown: false);
                  cubit.changeFabIcon(icon: Icons.edit);
                });
                cubit.changeBottomSheetState(isShown: true);
                cubit.changeFabIcon(icon: Icons.add);
              }
            },
          ),
          bottomNavigationBar: BottomNavigationBar(
            items: const [
              BottomNavigationBarItem(
                icon: Icon(Icons.menu),
                label: 'New',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.check_circle_outline),
                label: 'Done',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.archive_outlined),
                label: 'Archive',
              ),
            ],
            type: BottomNavigationBarType.fixed,
            currentIndex: cubit.currentIndex,
            onTap: (index) {
              cubit.changeBottomNavigationBar(index);
            },
          ),
        );
      }),
    );
  }
}
