import 'package:animate_do/animate_do.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:lottie/lottie.dart';
import 'package:flutter_slider_drawer/flutter_slider_drawer.dart';

import '../../main.dart';
import '../../models/task.dart';
import '../../utils/colors.dart';
import '../../utils/constanst.dart';
import '../../views/home/widgets/task_widget.dart';
import '../../views/tasks/task_view.dart';
import '../../utils/strings.dart';

class HomeView extends StatefulWidget {
  const HomeView({Key? key}) : super(key: key);

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  GlobalKey<SliderMenuContainerState> dKey = GlobalKey<SliderDrawerState>();

  int checkDondeTask(List<Task> task) {
    int i = 0;
    for(Task doneTaks in task){
      if(donetasks.isCompleted){
        i++;
      }
    }
    return i;
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
                    value: checkDondeTask(tasks) / valueOfTheIndicator(tasks),
                  ),
                ),
                const SizedBox(
                    width: 25,
                ),

                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(MyString.mainTitle, style: textTheme.headline1),
                    const SizedBox(
                        height: 3
                    ),
                    Text(
                        "${chackDoneTask(tasks)} de ${tasks.length} "
                            "tareas completadas", style: textTheme.subtitle1
                    ),
                  ],
                )
              ],
            ),
          ),

          const Padding(
              padding: EdgeInsets.only(
                top: 10
              ),
            child: Divider(
              thickness: 2,
              indent: 100,
            ),
          ),

          SizedBox(
            width: double.infinity,
            height: 585,
            child: tasks.inNotEmpty
                ? ListView.builder(
                physics: const BouncingScrollPhysics(),
                itemCount: tasks.length,
                itemBuilder: (BuildContext context, int index){
                  var task = tasks[index];

                  return Dismissible(
                    direction: DismissDirection.horizontal,
                    background: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const[
                        Icon(
                          Icons.delete_outline,
                          color: Colors.grey,
                        ),
                        SizedBox(
                          width: 8,
                        ),
                        Text(
                          MyString.deletedTask,
                          style: TextStyle(
                              color: Colors.grey,
                          )
                        )
                      ],
                    ),
                    onDismissed: (direction){
                      base.dataStore.deleteTask(task: task);
                    },
                    key: Key(task.id),
                    child: TaskWidget(
                      task: tasks[index],
                    ),
                  );
                },
            ): Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                FadeIn(
                    child: SizedBox(
                      width: 200,
                      height: 200,
                      child: Lottie.asset(
                        lottieURL,
                        animate: tasks.isNotEmpty ? false : true,
                      ),
                    ),
                ),

                FadeIn(
                    from: 30,
                    child: const Text(
                        MyString.doneAllTask
                    ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}

class MySlider extends StatelessWidget {
  MySlider({Key? key}) : super(key: key);

  List<IconData> icons = [
    CupertinoIcons.home,
    CupertinoIcons.person_fill,
    CupertinoIcons.settings,
    CupertinoIcons.info_circle_fill,
  ];

  List<String> texts = [
    "Home",
    "Perfil",
    "Ajustes",
    "Detalles",
  ];

  @override
  Widget build(BuildContext context) {
    var textTheme = Theme.of(context).textTheme;

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 90),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
            colors: MyColors.primaryGradientColor,
            begin: Alignment.topLeft,
            end: Alignment.bottomRight
        ),
      ),
      child: Column(
        children: [
          const CircleAvatar(
            radius: 50,
            backgroundImage: AssetImage("assets/img/main.png"),
          ),
          const SizedBox(
              height: 8
          ),
          Text("Usuario", style: textTheme.headline2),
          Text("Desarrollador junior", style: textTheme.headline3),

          Container(
            margin: const EdgeInsets.symmetric(
              vertical: 30,
              horizontal: 10,
            ),
            width: double.infinity,
            height: 300,

            child: ListView.builder(
                itemCount: icons.length,
                physics: const NeverScrollableScrollPhysics(),
                itemBuilder: (ctx, i){
                  return InkWell(
                    onTap: () => print("$i Seleccionado"),
                    child: ListTile(
                      leading: Icon(
                        icons[i],
                        color: Colors.white,
                        size: 30,
                      ),
                      title: Text(
                        texts[i],
                        style: const TextStyle(
                          color: Colors.white,
                        ),
                      ),
                    ),
                  );
                }
            ),
          )
        ],
      ),
    );
  }
}

class MyAppBar extends StatefulWidget with PreferredSizeWidget {
  MyAppBar ({Key? key, required this.drawerKey}) : super(key: key);

  GlobalKey<SliderDrawerState> drawerKey;

  @override
  State<MyAppBar> createState() => _MyAppBarState();

  @override
  Size get preferredSize => const Size.fromHeight(100);
}

class _MyAppBarState extends State<MyAppBar> with SingleTickerProviderStateMixin {
  @override
  late AnimationController controller;

  bool isDrawerOpen = false;

  @override
  void initState() {
    super.initState();

    controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    );
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  void toggle(){
    setState(() {
      isDrawerOpen = !isDrawerOpen;
      if(isDrawerOpen){
        controller.forward();
        widget.drawerKey.currentState!.openSlider();
      } else {
        controller.reverse();
        widget.drawerKey.currentState!.closeSlider();
      }
    });
  }

  Widget build(BuildContext context) {
    var base = BaseWidget.of(context).dataStore.box;

    return SizedBox(
      width: double.infinity,
      height: 132,
      child: Padding(
          padding: const EdgeInsets.only(top: 20),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 20),
              child: IconButton(
                onPressed: toggle,
                icon: AnimatedIcon(
                  icon: AnimatedIcons.menu_close,
                  progress: controller,
                  size: 40,
                ),
                splashColor: Colors.transparent,
                highlightColor: Colors.transparent,
              ),
            ),

            Padding(
              padding: const EdgeInsets.only(right: 20),
              child: GestureDetector(
                onTap: () {
                  base.isEmpty ? warningNoTask(context): deleteAllTask(context);
                },
                child: const Icon(
                  CupertinoIcons.trash,
                  size: 40,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class FAB extends StatelessWidget {
  const FAB({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(
          CupertinoPageRoute(
              builder: (context) => TaskView(
                taskControllerForSubtitle: null,
                taskControllerForTitle: null,
                task: null,
              ),
          ),
        );
      },
      child: Material(
        borderRadius: BorderRadius.circular(15),
        elevation: 10,
        child: Container(
          width: 70,
          height: 70,
          decoration: BoxDecoration(
            color: MyColors.primaryColor,
            borderRadius: BorderRadius.circular(15),
          ),
          child: const Center(
            child: Icon(
                Icons.add,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}

