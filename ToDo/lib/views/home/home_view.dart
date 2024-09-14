import 'package:animate_do/animate_do.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:lottie/lottie.dart';
import 'package:flutter_slider_drawer/flutter_slider_drawer.dart';
import 'package:todo/main.dart';

class HomeView extends StatefulWidget {
  const HomeView({Key? key}) : super(key: key);

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  GlobalKey<SliderMenuContainerState> dKey = GlobalKey<SliderDrawerState>();

  int checkDondeTask(List<Task> task) {
    int count = 0;
    for(Task doneTaks in task){
      if(donetasks.isCompleted){
        count++;
      }
    }
    return count;
  }

  dynamic valueOfTheIndicator(List<Task> task) {
    if(task.isNotEmpty){
      return task.length;
    } else {
      return 3;
    }
  }

  @override
  Widget build(BuildContext context) {
    final base = BaseWidget.of(context);
    var textTheme = Theme.of(context).textTheme;

    return ValueListenableBuilder(
      valueListenable: base.dataStore.listenToTask(),
      builder: (ctx, Box<Task> box, Widget? child){
        var tasks = box.values.toList();

        tasks.sort(((a, b) => a.createdAtDate.compareTo(b.createdAtDate)));

        return Scaffold(
          backgroundColor: Colors.white,

          floatingActionButton: const FAB(),

          body: SliderDrawer(
            isDraggable: false,
            key: dKey,
            animationDuration: 1000,

            appBar: MyAppBar(
              drawerKey: dKey,
            ),

            slider: MySlider(),

            child: _buildBody(
              tasks,
              base,
              textTheme,
            )
          ),
        );
      },
    );
  }

  SizedBox _buildBody(
      List<Task> tasks,
      BaseWidget base,
      TextTheme textTheme,
  ){
    return SizedBox(
      width: double.infinity,
      height: double.infinity,
      child: Column(
        children: [
          Container(
            margin: const EdgeInsets.fromLTRB(55, 0, 0, 0),
            width: double.infinity,
            height: 100,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(
                  width: 25,
                  height: 25,
                  child: CircularProgressIndicator(
                    valueColor: const AlwaysStoppedAnimation(MyColors.primaryColor),
                    backgroundColor: Colors.grey,
                    value: checkDondeTask(task) / valueOfTheIndicator(task),
                  ),
                ),
                const SizedBox(
                    width: 25,
                ),
                
              ],
            ),
          )
        ],
      ),
    )
  }
}
