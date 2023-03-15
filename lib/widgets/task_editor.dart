import 'package:flutter/material.dart';
import 'package:habit_tracker_app/main.dart';
import 'package:habit_tracker_app/models/task_model.dart';
import 'package:hive/hive.dart';

class TaskEditor extends StatefulWidget {
  TaskEditor({this.task, Key? key}) : super(key: key);
  Task? task;
  @override
  State<TaskEditor> createState() => _TeskEditorState();
}

class _TeskEditorState extends State<TaskEditor> {
  @override
  Widget build(BuildContext context) {
    TextEditingController _taskTitle = TextEditingController(
        text: widget.task == null ? null : widget.task!.title!);
    TextEditingController _taskNote = TextEditingController(
        text: widget.task == null ? null : widget.task!.note!);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white.withOpacity(0.5),
        iconTheme: const IconThemeData(color: Colors.blueGrey),
        title: Text(
          widget.task == null ? "Add a new task" : "Update your Task",
          style: const TextStyle(color: Colors.black),
        ),
        elevation: 0.0,
      ),
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/background.jpg"),
            fit: BoxFit.cover,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Your Task's Title",
                style: TextStyle(fontSize: 22.0, fontWeight: FontWeight.bold),
              ),
              const SizedBox(
                height: 12.0,
              ),
              TextField(
                controller: _taskTitle,
                decoration: InputDecoration(
                  fillColor: Colors.blueGrey.shade100.withAlpha(75),
                  filled: true,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                    borderSide: BorderSide.none,
                  ),
                  hintText: "Your Task Title",
                ),
              ),
              const SizedBox(
                height: 40.0,
              ),
              const Text(
                "Your Task's Note",
                style: TextStyle(fontSize: 22.0, fontWeight: FontWeight.bold),
              ),
              const SizedBox(
                height: 12.0,
              ),
              TextField(
                keyboardType: TextInputType.multiline,
                minLines: 5,
                maxLines: 20,
                controller: _taskNote,
                decoration: InputDecoration(
                  fillColor: Colors.blueGrey.shade100.withAlpha(75),
                  filled: true,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                    borderSide: BorderSide.none,
                  ),
                  hintText: "Write some note",
                ),
              ),
              Expanded(
                child: Align(
                  alignment: FractionalOffset.bottomCenter,
                  child: Container(
                    width: double.infinity,
                    height: 60.0,
                    child: RawMaterialButton(
                      onPressed: () async {
                        //add the function to delete or update our task
                        var newTask = Task(
                          title: _taskTitle.text,
                          note: _taskNote.text,
                          creation_date: DateTime.now(),
                          done: false,
                        );
                        Box<Task> taskBox = Hive.box<Task>("tasks");
                        //to update task
                        if (widget.task != null) {
                          widget.task!.title = newTask.title;
                          widget.task!.note = newTask.note;
                          widget.task!.save();
                          //if you encounter any error, make sure that you extended your Task class to Hive object to be able to use save() method
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => HomePage()));
                        } else {
                          //to add new task
                          await taskBox.add(newTask);
                          // ignore: use_build_context_synchronously
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => HomePage()));
                        }
                      },
                      fillColor: Colors.blueGrey.shade300,
                      child: Text(
                        widget.task == null ? "Add New Task" : "Update Task",
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 20.0,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
