import 'package:get/get.dart';
import '../db/db_helper1.dart';
import '../models/task1.dart';

class TaskController extends GetxController {

  @override
  void onReady() {
    getTasks();
    super.onReady();
  }

  var taskList = <Task>[].obs;

  Future<int> addTask({Task? task}) async {
    return await DBHelper1.insert(task);
  }

  void getTasks() async {
    List<Map<String, dynamic>> tasks = await DBHelper1.query();
    taskList.assignAll(tasks.map((data) => new Task.fromJson(data)).toList());
  }

  void delete(Task task) {
    DBHelper1.delete(task);
    getTasks();
  }
}