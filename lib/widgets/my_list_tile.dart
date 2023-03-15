import 'package:flutter/material.dart';
import 'package:habit_tracker_app/models/task_model.dart';
import 'package:habit_tracker_app/widgets/task_editor.dart';

class MyListTile extends StatefulWidget {
  MyListTile(this.task,this.index,{Key? key}) : super(key: key);
  Task task;
  int index;
  @override
  State<MyListTile> createState() => _MyListTileState();
}

class _MyListTileState extends State<MyListTile> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 12.0),
      width: double.infinity,
      padding: EdgeInsets.all(12.0),
      decoration: BoxDecoration(
        color: Colors.blueGrey.shade50,
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(child: Text(widget.task.title!,
                style: const TextStyle(
                    fontSize: 18.0,
                    fontWeight: FontWeight.bold) ,),
              ),
              IconButton(icon: const Icon(Icons.edit),color: Colors.black87,
                  onPressed: (){
                    Navigator.push(context, MaterialPageRoute(builder: (context)=>TaskEditor(task: widget.task,)));
                  } ),
              IconButton(icon: const Icon(Icons.delete),color: Colors.black87,
                  onPressed: (){
                    widget.task.delete();
                  } )
            ],
          ),
          const Divider(
            color: Colors.black87,
            height: 20.0,
            thickness: 1.0,
          ),
          Text(widget.task.note!,style: TextStyle(fontSize: 16.0),),
        ],
      ),
    );
  }
}
