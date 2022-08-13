import 'package:faizal/controllers/task_controller1.dart';
import 'package:faizal/ui/theme1.dart';
import 'package:faizal/widgets/buttons1.dart';
import 'package:faizal/widgets/input_field1.dart';
import 'package:flutter/material.dart';
import 'package:flutter/physics.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../models/task1.dart';
// import './get_direction.dart';
import './current_location.dart';

String? pointName;

class AddTaskPage extends StatefulWidget {
  const AddTaskPage({Key? key}) : super(key: key);

  @override
  State<AddTaskPage> createState() => _AddTaskPageState();
}

class _AddTaskPageState extends State<AddTaskPage> {
  final TaskController _taskController = Get.put(TaskController());
  final TextEditingController _titleController = TextEditingController();
  int _selectedColor = 0;


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _appBar(context),
      body: Container(
        padding: const EdgeInsets.only(left: 20, right: 20),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Text(
                "Add Location",
                style: headingStyle,
              ),
              MyInputField(title: "Title", hint: "Enter your title", controller: _titleController,),
              SizedBox(height: 18,),
              TextButton(
                  child: Text(
                      "Set Location".toUpperCase(),
                      style: TextStyle(fontSize: 14)
                  ),
                  style: ButtonStyle(
                    padding: MaterialStateProperty.all<EdgeInsets>(EdgeInsets.all(15)),
                    backgroundColor: MaterialStateProperty.all<Color>(Colors.blueAccent),
                    foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(18.0),
                            side: BorderSide(color: Colors.blueAccent)
                        )
                    ),
                  ),
                  onPressed: () {
                    pointName = _titleController.text;
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) =>
                            CurrentLocationScreen()));
                  },
              ),
              SizedBox(height: 100,),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Color",
                      style: titleStyle,
                      ),
                      SizedBox(height: 8.0,),
                      Wrap(
                        children: List<Widget>.generate(
                          3,
                            (int index) {
                            return GestureDetector(
                              onTap: () {
                                setState(() {
                                  _selectedColor = index;
                                });
                              },
                              child: Padding(
                                padding: const EdgeInsets.only(right: 8.0),
                                child: CircleAvatar(
                                  radius: 14,
                                  backgroundColor: index==0?primaryClr:index==1?pinkClr:yellowClr,
                                  child: _selectedColor==index?Icon(Icons.done,
                                  color: Colors.white,
                                  size: 16,
                                  ):Container(),
                                ),
                              ),
                            );
                            }
                        ),
                      )
                    ],
                  ),
                  ElevatedButton.icon(   // <-- ElevatedButton
                    onPressed: ()=>_validateData(),
                    icon: Icon(
                      Icons.done_outline_sharp,
                      size: 24.0,
                    ),
                    label: Text('DONE'),
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12), // <-- Radius
                      ),
                    ),
                  ),
                ],
              )
            ],
          ),
        )
      ),
    );
  }

  _validateData(){
    if(_titleController.text.isNotEmpty && flag==true) {
      _addTaskToDb();
      Get.back();
    }
    else if(_titleController.text.isEmpty || flag==false){
      Get.snackbar("Required", "All fields are required !",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.white,
        colorText: pinkClr,
        icon: Icon(Icons.warning_amber_rounded,
        color: Colors.red,
        ),
      );
    }
  }

  _addTaskToDb() async {
    int value = await _taskController.addTask(
        task: Task(
          title:_titleController.text,
          color: _selectedColor,
          lat: homelat,
          lan: homelan
        )
    );
    print("My id is " + "$value");
  }

  _appBar(BuildContext context) {
    return AppBar(
      elevation: 0,
      //backgroundColor: ,
      leading: GestureDetector(
        onTap: (){
          Get.back();
        },
        child: Icon(
          Icons.arrow_back_ios,
          size: 20,
          color: Colors.black,
        ),
      ),
    );
  }
}
//
// () {
// pointName = _titleController.text;
// Navigator.of(context).push(MaterialPageRoute(
// builder: (context) =>
// CurrentLocationScreen()));
// },

// ()=>_validateData()