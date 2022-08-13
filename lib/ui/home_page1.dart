import 'package:faizal/controllers/task_controller1.dart';
import 'package:faizal/ui/add_task_bar1.dart';
import 'package:faizal/ui/current_location.dart';
import 'package:faizal/ui/theme1.dart';
import 'package:faizal/widgets/buttons1.dart';
import 'package:date_picker_timeline/date_picker_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:get/get.dart';
import './get_location.dart';

import '../models/task1.dart';
import '../widgets/task_tile1.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key : key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _taskController = Get.put(TaskController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
      ),
      body: Column(
        children: [
          Container(
            margin: const EdgeInsets.only(left: 20, right: 20, top: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                TextButton(
                    child: Text(
                        "+ Add Location".toUpperCase(),
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
                    onPressed: ()async{
                      await Get.to(()=>AddTaskPage());
                      _taskController.getTasks();
                      flag = false;
                    }
                ),
              ],
            ),
          ),
          Container(
            margin: const EdgeInsets.only(top: 20, left: 20),
          ),
          SizedBox(height: 10,),
          _showTasks()
        ],
      ),
    );
  }

  _showTasks() {
    return Expanded(
      child: Obx((){
        return ListView.builder(
            itemCount: _taskController.taskList.length,

            itemBuilder: (_, index) {
              Task task = _taskController.taskList[index];
                  return AnimationConfiguration.staggeredList(
                      position: index,
                      child: SlideAnimation(
                        child: FadeInAnimation(
                          child: Row(
                            children: [
                              GestureDetector(
                                onTap: () {
                                  _showBottomSheet(context, task);
                                },
                                child: TaskTile(task),
                              )
                            ],
                          ),
                        ),
                      )
                  );
        });
      }),
    );
  }

  _showBottomSheet(BuildContext context, Task task) {
    Get.bottomSheet(
      Container(
        padding: const EdgeInsets.only(top: 4),
        height: MediaQuery.of(context).size.height*0.32,
        color: Colors.white,
        child: Column(
          children: [
            Container(
              height: 6,
              width: 120,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Colors.grey[300],
              ),
            ),
            Spacer(),
            _bottomSheetButton(
                label: "Show Direction",
                onTap: () async {
                  var title = task.title.toString();
                  var hmlat = task.lat!.toDouble();
                  var hmlan = task.lan!.toDouble();
                  HomeDirection().openMapsSheet(context,title,hmlat,hmlan);
                  Get.back();
                },
                clr: primaryClr,
                context:context
            ),
            _bottomSheetButton(
                label: "Delete Location",
                onTap: () async {
                  _taskController.delete(task);
                  Get.back();
                },
                clr: Colors.red[300]!,
                context:context
            ),
            SizedBox(
              height: 20,
            ),
            _bottomSheetButton(
                label: "Close",
                onTap: () {
                  Get.back();
                },
                clr: Colors.red[300]!,
                isClose: true,
                context:context
            ),
            SizedBox(
              height: 10,
            )
          ],
        ),
      )
    );
  }

  _bottomSheetButton({
    required String label,
    required Function()? onTap,
    required Color clr,
    bool isClose=false,
    required BuildContext context
}) {
      return GestureDetector(
        onTap: onTap,
        child: Container(
          margin: const EdgeInsets.symmetric(vertical: 4),
          height: 55,
          width: MediaQuery.of(context).size.width*0.9,
          decoration: BoxDecoration(
            border: Border.all(
              width: 2,
              color: isClose==true?Colors.grey[300]!:clr
            ),
            borderRadius: BorderRadius.circular(20),
            color: isClose==true?Colors.transparent:clr,
          ),
          child: Center(
            child: Text(
              label,
              style: isClose?titleStyle:titleStyle.copyWith(color: Colors.white),
            ),
          ),
        ),
      );
   }

}

// ()async{
// await Get.to(()=>AddTaskPage());
// _taskController.getTasks();
// flag = false;
// }