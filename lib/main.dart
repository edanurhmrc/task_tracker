import 'package:flutter/material.dart';
import 'package:habit_tracker_app/models/task_model.dart';
import 'package:date_format/date_format.dart';
import 'package:habit_tracker_app/widgets/my_list_tile.dart';
import 'package:habit_tracker_app/widgets/task_editor.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/adapters.dart';

late Box box;
void main() async {
  await Hive.initFlutter();
  Hive.registerAdapter<Task>(TaskAdapter());
  box = await Hive.openBox<Task>("tasks");
  box.add(Task(
    title: "this is the first task",
    note: "this is the first task made with the app",
    creation_date: DateTime.now(),
  ));
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blueGrey,
      ),
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white.withOpacity(0.5),
        elevation: 0.0,
        title: const Text(
          "Task Tracker",
          style: TextStyle(
              color: Colors.black),
        ),
        centerTitle: true,

      ),
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/background.jpg"),
            fit: BoxFit.cover,
          ),
        ),
        child: ValueListenableBuilder<Box<Task>>(
          valueListenable: Hive.box<Task>("tasks").listenable(),
          builder: (context, box, _) {
            return Padding(
              padding: EdgeInsets.all(16.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Today's Task",
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 26.0,
                        fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(
                    height: 10.0,
                  ),
                  Text(
                    formatDate(DateTime.now(), [d, ", ", M, " ", yyyy]),
                    style: TextStyle(color: Colors.grey.shade700, fontSize: 18.0),
                  ),
                  const Divider(
                    height: 40.0,
                    thickness: 1.0,
                  ),
                  Expanded(
                      child: ListView.builder(
                        itemCount: box.values.length,
                        itemBuilder: (context, index) {
                          Task currentTask = box.getAt(index)!;
                          return MyListTile(currentTask, index);
                          },
                      ))
                ],
              ),
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.blueGrey.shade300,
        child: Icon(Icons.add),
        onPressed: () {
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => TaskEditor()));
        },
      ),
    );
  }
}
