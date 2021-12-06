// ignore_for_file: avoid_print

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sqflite/sqflite.dart';
import 'package:todo_app/modules/archived_tasks_screen.dart';
import 'package:todo_app/modules/done_tasks.dart';
import 'package:todo_app/modules/new_tasks_screen.dart';
import 'package:todo_app/shared/cubit/states.dart';

class MyAppCubit extends Cubit<MyAppStates> {
  MyAppCubit() : super(MyAppInitialState());

  static get(context) => BlocProvider.of<MyAppCubit>(context);

  int currentIndex = 0;
  List<Widget> screens = const [
    NewTaskScreen(),
    DoneTasksScreen(),
    ArchivedTasksScreen(),
  ];
  IconData fabIcon = Icons.edit;
  bool isBottomSheetShown = false;
  late Database database;
  List<Map> newTasks = [];
  List<Map> doneTasks = [];
  List<Map> archivedTasks = [];

  void changeBottomNavigationBar(int index) {
    currentIndex = index;
    emit(BottomNavigationBarState());
  }

  void changeBottomSheetState({required isShown}) {
    isBottomSheetShown = isShown;
    emit(BottomSheetState());
  }

  // void changeDateState({required date}) {
  //   dateController.text = date;
  //   emit(DateState());
  // }

  // void changeTimeState({required time}) {
  //   timeController.text = time;
  //   emit(TimeState());
  // }

  void changeFabIcon({required icon}) {
    fabIcon = icon;
    emit(FabIconState());
  }

  void createDB() {
    openDatabase('todo.db', version: 1,
        onCreate: (Database db, int version) async {
      // When creating the db, create the table
      db
          .execute(
              'CREATE TABLE tasks (id INTEGER PRIMARY KEY, title TEXT, date TEXT, time TEXT,status TEXT)')
          .then((value) => print('database created'));
    }, onOpen: (database) {
      print('database opened');
      getDataFromDB(database);
    }).then((value) {
      database = value;
      emit(CreateDBState());
    });
  }

  void insertToDB({required title, required date, required time}) {
    database.transaction((txn) async {
      txn
          .rawInsert(
              'INSERT INTO tasks(title,date,time,status) VALUES("$title","$date","$time","new")')
          .then((value) {
        print('$value inserted successfully');
        emit(InsertDBState());
        getDataFromDB(database);
      }).catchError((error) {
        print('error when inserting record');
      });
    });
  }

  void getDataFromDB(Database database) {
    newTasks = [];
    doneTasks = [];
    archivedTasks = [];

    database.rawQuery('SELECT * FROM tasks').then((value) {
      for (var element in value) {
        switch (element['status']) {
          case 'new':
            newTasks.add(element);
            break;
          case 'done':
            doneTasks.add(element);
            break;
          default:
            archivedTasks.add(element);
        }
      }
      emit(GetDBState());
    });
  }

  void updateDB({required String status, required int id}) {
    database.rawUpdate('UPDATE tasks SET status = ? WHERE id = ?',
        [status, "$id"]).then((value) {
      getDataFromDB(database);
      emit(UpdateDBState());
    });
  }

  void deleteFromDB({required int id}) {
    database.rawUpdate('DELETE FROM tasks WHERE id = ?', [id]).then((value) {
      getDataFromDB(database);
      emit(DeleteFromDBState());
    });
  }
}
