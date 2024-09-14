import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

Future<void> main() async {
  await Hive.initFlutter();
  Hive.registerAdapter<Task>(TaskAdapter());

  var box = await Hive.openBox<Task>('tasksBox');

  box.values.forEach((task) {
    if(task.createdAtTime.day != DateTime.now().day) {
      task.delete();
    } else {}
  });

  runApp(BaseWidget(child: const MyApp()));
}

class BaseWidget extends InheritedWidget{
  BaseWidget({Key? key, required this.child}) : super(key: key, child: child);

  final HiveDataStore dataStore = HiveDataStore();
  final Widget child;

  static BaseWidget of(BuildContext context) {
    final base = context.dependOnInheritedWidgetOfExactType<BaseWidget>();
    
    if(base != null) {
      return base;
    } else {
      throw StateError('No se pudo encontrar un widget superior de tipo BaseWidget'')
    }
  }

  @override
  bool updateShouldNotify(covariant InheritedWidget oldWidget) {
    return false;
  }
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Lista de Tareas',
      theme: ThemeData(
        textTheme: const TextTheme(
          headline1: TextStyle(
              color: Colors.black,
              fontSize: 45,
              fontWeight: FontWeight.bold
          ),
          subtitle1: TextStyle(
              color: Colors.grey,
              fontSize: 16,
              fontWeight: FontWeight.w300
          ),
          headline2: TextStyle(
              color: Colors.white,
              fontSize: 21,
          ),
          headline3: TextStyle(
            color: Color.fromARGB(255, 255, 234, 234),
            fontSize: 14,
            fontWeight: FontWeight.w400
          ),
          headline4: TextStyle(
            color: Colors.grey,
            fontSize: 17,
          ),
          headline5: TextStyle(
            color: Colors.grey,
            fontSize: 16,
          ),
          subtitle2: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.w500,
          ),
          headline6: TextStyle(
            color: Colors.black,
            fontSize: 40,
            fontWeight: FontWeight.w300
          ),
        ),
      ),
      home: const HomeView(),
    );
  }
}
