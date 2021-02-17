import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:commons/commons.dart';
import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:my_todo/main.dart';
import 'package:my_todo/screens/logIn.dart';
import 'package:my_todo/services/autharisation.dart';
import 'package:my_todo/services/dataBase.dart';
import 'package:my_todo/shared/buttonTemplate.dart';
import 'package:my_todo/shared/loading.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

//Variable fields
String task;
DataBaseService _db = DataBaseService();
bool loading = false;
var taskDate = DateTime.now();
var date = DateTime.now().day.toString() +
    "/" +
    DateTime.now().month.toString() +
    "/" +
    DateTime.now().year.toString();
final _formState = GlobalKey<FormState>();

class _HomePageState extends State<HomePage> {
  bool showInternetError = false;
  int i = 0;
  @override
  void initState() {
    super.initState();
    try {
      InternetAddress.lookup('google.com').then((result) {
        print("result " + result.toString());
        if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
          // internet conn available
          print("connected");
          showInternetError = false;
        } else {
          // no connection
          showInternetError = true;
        }
      }).catchError((error) {
        //no connection
        showInternetError = true;
      });
    } on SocketException catch (_) {
      // no internet
      print("result error " + _.toString());
      showInternetError = true;
    }

    Connectivity().onConnectivityChanged.listen((event) {
      print(event.toString());
      if (event != ConnectivityResult.none) {
        //internet is connected
        showInternetError = false;
      } else {
        //no internet
        showInternetError = true;
      }
      setState(() {
        print("showInternetError " + showInternetError.toString());
        if (showInternetError == true) {
          _showInternetErrorDialog();
        } else {
          if (i == 1) {
            print("fuck");
            Navigator.pop(context);
          } else {
            i++;
          }
        }
      });
    });
  }

  //disposing the connectivity package

  void _showInternetErrorDialog() {
    errorDialog(context, "No internet connection", neutralText: "Exit",
        neutralAction: () {
      print("exitting");
      SystemNavigator.pop();
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Stack(
        children: [
          Scaffold(
            //app bar
            appBar: AppBar(
              centerTitle: true,
              title: Text("My Todo"),
              actions: [
                FlatButton.icon(
                    onPressed: () {
                      Auth().signOut();
                      Navigator.pushReplacement(context,
                          MaterialPageRoute(builder: (context) => LogIn()));
                    },
                    icon: Icon(Icons.exit_to_app_rounded),
                    label: Text("Sign-Out")),
              ],
            ),
            body: _ItemLists(),
            floatingActionButton: FloatingActionButton(
              onPressed: () {
                showDialog(
                    context: context,
                    builder: (context) {
                      return _AddTaskDialog();
                    });
              },
              elevation: 10,
              tooltip: "Add Task",
              child: Text(
                "+",
                style: TextStyle(fontSize: 40),
              ),
            ),
          ),
          loading == true ? ShowLoading() : Text(""),
        ],
      ),
    );
  }
}

class _ItemLists extends StatelessWidget {
  const _ItemLists({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: FirebaseFirestore.instance
          .collection(userUid)
          .orderBy('time', descending: false)
          .snapshots(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.data == null || snapshot.data.docs.toList().length == 0) {
          print("no data");
          return Center(
            child: Text(
              "Empty",
              style: TextStyle(fontSize: 40),
            ),
          );
        } else {
          return ListView(
            children: snapshot.data.docs.map(
              (document) {
                return Padding(
                  padding: EdgeInsets.symmetric(horizontal: 10, vertical: 2),
                  child: InkWell(
                    splashColor: Colors.green,
                    onLongPress: () async {
                      print(document.id);
                      await _db.deleteTask(userUid, document.id);
                    },
                    onTap: () {
                      infoDialog(
                        context,
                        "Date : " +
                            DateTime.fromMicrosecondsSinceEpoch(
                                    document['time'].microsecondsSinceEpoch)
                                .day
                                .toString() +
                            "/" +
                            DateTime.fromMicrosecondsSinceEpoch(
                                    document['time'].microsecondsSinceEpoch)
                                .month
                                .toString() +
                            "/" +
                            DateTime.fromMicrosecondsSinceEpoch(
                                    document['time'].microsecondsSinceEpoch)
                                .year
                                .toString() +
                            "\n" +
                            "Task : " +
                            document['tasks'],
                        title: "Task Details",
                      );
                    },
                    child: Container(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          color: Colors.red),
                      margin: EdgeInsets.only(top: 5, bottom: 5),
                      padding:
                          EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                      width: MediaQuery.of(context).size.width - 50,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Text(
                                "Date : ",
                                style: TextStyle(
                                    fontSize: 24, color: Colors.yellow),
                              ),
                              Text(
                                DateTime.fromMicrosecondsSinceEpoch(
                                            document['time']
                                                .microsecondsSinceEpoch)
                                        .day
                                        .toString() +
                                    "/" +
                                    DateTime.fromMicrosecondsSinceEpoch(
                                            document['time']
                                                .microsecondsSinceEpoch)
                                        .month
                                        .toString() +
                                    "/" +
                                    DateTime.fromMicrosecondsSinceEpoch(
                                            document['time']
                                                .microsecondsSinceEpoch)
                                        .year
                                        .toString(),
                                style: TextStyle(
                                  fontSize: 24,
                                ),
                              ),
                            ],
                          ),
                          Divider(
                            thickness: 3,
                            color: Colors.black,
                          ),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Task : ",
                                style: TextStyle(
                                    fontSize: 24, color: Colors.yellow),
                              ),
                              Flexible(
                                child: Text(
                                  document['tasks'],
                                  style: TextStyle(fontSize: 24),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ).toList(),
          );
        }
      },
    );
  }
}

class _AddTaskDialog extends StatefulWidget {
  @override
  __AddTaskDialogState createState() => __AddTaskDialogState();
}

class __AddTaskDialogState extends State<_AddTaskDialog> {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(
          Radius.circular(20.0),
        ),
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            "Add Task",
            style: TextStyle(fontSize: 36, fontWeight: FontWeight.w600),
          ),
          Divider(),
          Form(
            key: _formState,
            child: TextFormField(
              validator: (value) {
                if (value.isEmpty) {
                  return "Task can't be empty";
                } else {
                  return null;
                }
              },
              textInputAction: TextInputAction.next,
              decoration: InputDecoration(
                labelText: "task",
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide(color: Colors.greenAccent),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide(color: Colors.greenAccent),
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              onChanged: (value) {
                task = value;
              },
            ),
          ),
          InkWell(
            onTap: () async {
              taskDate = await showDatePicker(
                  context: context,
                  initialDate: DateTime.now(),
                  firstDate: DateTime(DateTime.now().year),
                  lastDate: DateTime(2025));
              var dateString = taskDate.day.toString() +
                  "/" +
                  taskDate.month.toString() +
                  "/" +
                  taskDate.year.toString();
              setState(() {
                date = dateString;
              });
            },
            child: Container(
              height: 60,
              width: double.infinity,
              margin: EdgeInsets.only(top: 10),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                border: Border.all(
                  color: Colors.greenAccent,
                ),
              ),
              child: Center(
                child: Text(
                  "Date : " + date,
                  textAlign: TextAlign.start,
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ),
          Divider(),
          ButtonTemp(
            s: "Add",
            c: Colors.blueAccent,
            fun: () async {
              if (_formState.currentState.validate()) {
                Navigator.pop(context);
                loading = true;
                await _db.addTodo(task, taskDate, userUid);
                loading = false;
                print("task added successfully");
              }
            },
            h: 50,
          ),
        ],
      ),
    );
  }
}
