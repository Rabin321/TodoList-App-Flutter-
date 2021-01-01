import 'package:dynamic_theme/dynamic_theme.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Homescreen extends StatefulWidget {
  @override
  _HomescreenState createState() => _HomescreenState();
}

class _HomescreenState extends State<Homescreen> {
  String todoTitle = "todoo";

  createTodos() {
    DocumentReference documentReference =
        FirebaseFirestore.instance.collection("MyTodos").doc(todoTitle);
    Map<String, String> todos = {"todoTitle": todoTitle};
    documentReference.set(todos).whenComplete(() {
      print("$todoTitle created");
    });
  }

  deleteTodos(item) {
    DocumentReference documentReference =
        FirebaseFirestore.instance.collection("MyTodos").doc(item);
    documentReference.delete().whenComplete(() {
      print("$item deleted");
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        drawer: Drawer(
            child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              Container(
                width: double.infinity,
                padding: EdgeInsets.all(7.0),
                color: Colors.grey,
                child: Center(
                  child: Column(
                    children: <Widget>[
                      Container(
                        height: 42.0,
                        width: 50.0,
                      ),
                      Text(
                        "Todo list",
                        style: TextStyle(
                            fontSize: 21.0, fontWeight: FontWeight.w700),
                      ),
                    ],
                  ),
                ),
              ),
              ListTile(
                leading: Icon(Icons.wb_sunny),
                title: Text(
                  "My Day",
                  style: TextStyle(fontSize: 15.0),
                ),
                onTap: () {},
              ),
              ListTile(
                leading: Icon(Icons.star),
                title: Text(
                  "Important",
                  style: TextStyle(
                    fontSize: 15.0,
                  ),
                ),
                onTap: () {},
              ),
              ListTile(
                leading: Icon(Icons.calendar_today),
                title: Text(
                  "Planned",
                  style: TextStyle(fontSize: 15.0),
                ),
                onTap: () {},
              ),
              ListTile(
                leading: Icon(Icons.home),
                title: Text(
                  "Tasks",
                  style: TextStyle(fontSize: 15.0),
                ),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) {
                      return Homescreen();
                    }),
                  );
                },
              )
            ],
          ),
        )),
        appBar: AppBar(
          title: Text(
            "Todo List",
            style: TextStyle(
              fontSize: 21,
              fontWeight: FontWeight.w700,
            ),
          ),
          centerTitle: true,
          actions: <Widget>[
            IconButton(
                icon: Icon(Theme.of(context).brightness == Brightness.light
                    ? Icons.lightbulb_outline
                    : Icons.highlight),
                onPressed: () {
                  DynamicTheme.of(context).setBrightness(
                      Theme.of(context).brightness == Brightness.light
                          ? Brightness.dark
                          : Brightness.light);
                })
          ],
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(9)),
                    title: Text("Add Todolist"),
                    content: TextField(
                      onChanged: (String value) {
                        todoTitle = value;
                      },
                    ),
                    actions: <Widget>[
                      FlatButton(
                          onPressed: () {
                            createTodos();
                            Navigator.of(context).pop();
                          },
                          child: Text("Add"))
                    ],
                  );
                });
          },
          child: Icon(
            Icons.add,
            color: Colors.black,
          ),
        ),
        body: StreamBuilder(
            stream:
                FirebaseFirestore.instance.collection("MyTodos").snapshots(),
            builder:
                (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
              return ListView.builder(
                  shrinkWrap: true,
                  itemCount: snapshot.data.docs.length,
                  itemBuilder: (context, index) {
                    DocumentSnapshot documentSnapshot =
                        snapshot.data.docs[index];
                    return Dismissible(
                        onDismissed: (direction) {
                          deleteTodos(documentSnapshot.data()["todoTitle"]);
                        },
                        key: Key(documentSnapshot.data()["todoTitle"]),
                        child: Card(
                          elevation: 5,
                          margin: EdgeInsets.all(5),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(7)),
                          child: ListTile(
                            title: Text(documentSnapshot.data()["todoTitle"]),
                            trailing: IconButton(
                                icon: Icon(Icons.delete),
                                onPressed: () {
                                  setState(() {
                                    deleteTodos(
                                        documentSnapshot.data()["todoTitle"]);
                                  });
                                }),
                          ),
                        ));
                  });
            }));
  }
}
