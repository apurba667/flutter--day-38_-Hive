import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  TextEditingController _nameController = TextEditingController();
  TextEditingController _updateController = TextEditingController();
  Box? myBox;
  @override
  void initState() {
    myBox = Hive.box("myList");
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Hive Demo")),
      body: Padding(
        padding: EdgeInsets.all(15),
        child: Column(
          children: [
            TextField(
              controller: _nameController,
              decoration: InputDecoration(
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15))),
            ),
            ElevatedButton(
                onPressed: () async {
                  var country = _nameController.text;
                  await myBox!.add(country);
                },
                child: Text("Add data")),
            Expanded(
                child: ValueListenableBuilder(
              valueListenable: Hive.box("myList").listenable(),
              builder: (context, box, widget) {
                return ListView.builder(
                    itemCount: myBox!.keys.toList().length,
                    itemBuilder: (context, index) {
                      return Card(
                          elevation: 10,
                          child: ListTile(
                            title: Text(myBox!.getAt(index).toString()),
                            trailing: Container(
                              color: Colors.amber,
                              width: 100,
                              child: Row(
                                children: [
                                  IconButton(
                                      onPressed: () {
                                        showDialog(
                                            context: context,
                                            builder: (context) {
                                              return AlertDialog(
                                                content: Column(
                                                  children: [
                                                    TextField(
                                                      controller:
                                                          _updateController,
                                                      decoration: InputDecoration(
                                                          border: OutlineInputBorder(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          15))),
                                                    ),
                                                    ElevatedButton(
                                                        onPressed: () async {
                                                          Navigator.pop(
                                                              context);
                                                          myBox!.putAt(
                                                              index,
                                                              _updateController
                                                                  .text);
                                                        },
                                                        child: Text("Update")),
                                                  ],
                                                ),
                                              );
                                            });
                                      },
                                      icon: Icon(Icons.edit)),
                                  IconButton(
                                      onPressed: () {
                                        myBox!.deleteAt(index);
                                      },
                                      icon: Icon(Icons.delete))
                                ],
                              ),
                            ),
                          ));
                    });
              },
            ))
          ],
        ),
      ),
    );
  }
}
