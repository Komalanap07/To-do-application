import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: const HomeScreen(),
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primarySwatch: Colors.indigo),
    );
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Map<String, dynamic>> todoList = [];
  String singlevalue = "";

  @override
  void initState() {
    super.initState();
    loadTasks(); // Load tasks when app starts
  }

  Future<void> loadTasks() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? tasks = prefs.getString('todoList');
    if (tasks != null) {
      setState(() {
        todoList = List<Map<String, dynamic>>.from(
          json.decode(tasks) as List,
        );
      });
    }
  }

  Future<void> saveTasks() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('todoList', json.encode(todoList));
  }

  void addString(String content) {
    setState(() {
      singlevalue = content;
    });
  }

  void addList() {
    if (singlevalue.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Task cannot be empty')),
      );
      return;
    }
    setState(() {
      todoList.add({"value": singlevalue, "completed": false});
      singlevalue = "";
      saveTasks(); // Save tasks whenever a new one is added
    });
  }

  void deleteItem(int index) {
    setState(() {
      todoList.removeAt(index);
      saveTasks(); // Save after deletion
    });
  }

  void toggleCompletion(int index) {
    setState(() {
      todoList[index]['completed'] = !todoList[index]['completed'];
      saveTasks(); // Save after toggling completion status
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "To do Application",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 25,
          ),
        ),
        centerTitle: true,
        toolbarHeight: 75,
        leading: IconButton(
          icon: const Icon(Icons.menu),
          onPressed: () {},
        ),
        elevation: 0,
      ),
      body: Container(
        margin: const EdgeInsets.all(10),
        child: Column(
          children: [
            Expanded(
              flex: 90,
              child: ListView.builder(
                  itemCount: todoList.length,
                  itemBuilder: (context, index) {
                    return Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                      color: Colors.blue[900],
                      child: SizedBox(
                        height: 50,
                        width: double.infinity,
                        child: Container(
                          margin: const EdgeInsets.only(left: 20),
                          alignment: Alignment.center,
                          padding: const EdgeInsets.all(10),
                          child: Row(
                            children: [
                              Expanded(
                                flex: 10,
                                child: Checkbox(
                                  value: todoList[index]['completed'],
                                  onChanged: (bool? value) {
                                    toggleCompletion(index);
                                  },
                                ),
                              ),
                              Expanded(
                                flex: 70,
                                child: Text(
                                  todoList[index]['value'].toString(),
                                  style: TextStyle(
                                    color: todoList[index]['completed']
                                        ? Colors.green
                                        : Colors.white,
                                    fontWeight: FontWeight.bold,
                                    decoration: todoList[index]['completed']
                                        ? TextDecoration.lineThrough
                                        : TextDecoration.none,
                                  ),
                                ),
                              ),
                              Expanded(
                                  flex: 20,
                                  child: CircleAvatar(
                                    radius: 30,
                                    backgroundColor: Colors.white,
                                    child: TextButton(
                                      onPressed: () {
                                        deleteItem(index);
                                      },
                                      child: const Icon(
                                        Icons.delete,
                                        color: Colors.black,
                                      ),
                                    ),
                                  )),
                            ],
                          ),
                        ),
                      ),
                    );
                  }),
            ),
            Expanded(
                flex: 10,
                child: Row(
                  children: [
                    Expanded(
                      flex: 70,
                      child: SizedBox(
                        height: 40,
                        child: TextFormField(
                          onChanged: (content) {
                            addString(content);
                          },
                          decoration: InputDecoration(
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(15),
                              ),
                              fillColor: Colors.blue[300],
                              filled: true,
                              labelText: 'Create Task....',
                              labelStyle: TextStyle(
                                color: Colors.indigo[900],
                                fontWeight: FontWeight.bold,
                              )),
                        ),
                      ),
                    ),
                    const Expanded(
                        flex: 3,
                        child: SizedBox(
                          width: 5,
                        )),
                    Expanded(
                        flex: 27,
                        child: ElevatedButton(
                          onPressed: () {
                            addList();
                          },
                          child: Container(
                              height: 15,
                              width: double.infinity,
                              alignment: Alignment.center,
                              child: const Text("Add")),
                        )),
                  ],
                )),
          ],
        ),
      ),
    );
  }
}





// import 'dart:convert';

// import 'package:flutter/material.dart';
// import 'package:shared_preferences/shared_preferences.dart';

// void main() {
//   runApp(const MyApp());
// }

// class MyApp extends StatelessWidget {
//   const MyApp({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       home: const HomeScreen(),
//       debugShowCheckedModeBanner: false,
//       theme: ThemeData(primarySwatch: Colors.indigo),
//     );
//   }
// }

// class HomeScreen extends StatefulWidget {
//   const HomeScreen({super.key});

//   @override
//   State<HomeScreen> createState() => _HomeScreenState();
// }

// class _HomeScreenState extends State<HomeScreen> {
//   List<Map<String, dynamic>> todoList = [];
//   final TextEditingController _controller = TextEditingController(); // Controller for the text field

//   @override
//   void initState() {
//     super.initState();
//     loadTasks(); // Load tasks when app starts
//   }

//   Future<void> loadTasks() async {
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//     String? tasks = prefs.getString('todoList');
//     if (tasks != null) {
//       setState(() {
//         todoList = List<Map<String, dynamic>>.from(
//           json.decode(tasks) as List,
//         );
//       });
//     }
//   }

//   Future<void> saveTasks() async {
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//     prefs.setString('todoList', json.encode(todoList));
//   }

//   void addList() {
//     String taskContent = _controller.text.trim(); // Get text from controller
//     if (taskContent.isEmpty) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text('Task cannot be empty')),
//       );
//       return;
//     }
//     setState(() {
//       todoList.add({"value": taskContent, "completed": false});
//       _controller.clear(); // Clear the text field after adding the task
//       saveTasks(); // Save tasks whenever a new one is added
//     });
//   }

//   void deleteItem(int index) {
//     setState(() {
//       todoList.removeAt(index);
//       saveTasks(); // Save after deletion
//     });
//   }

//   void toggleCompletion(int index) {
//     setState(() {
//       todoList[index]['completed'] = !todoList[index]['completed'];
//       saveTasks(); // Save after toggling completion status
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text(
//           "To-Do Application",
//           style: TextStyle(
//             fontWeight: FontWeight.bold,
//             fontSize: 25,
//           ),
//         ),
//         centerTitle: true,
//         toolbarHeight: 75,
//         leading: IconButton(
//           icon: const Icon(Icons.menu),
//           onPressed: () {},
//         ),
//         elevation: 0,
//       ),
//       body: Container(
//         margin: const EdgeInsets.all(10),
//         child: Column(
//           children: [
//             Expanded(
//               flex: 90,
//               child: ListView.builder(
//                 itemCount: todoList.length,
//                 itemBuilder: (context, index) {
//                   return Card(
//                     shape: RoundedRectangleBorder(
//                       borderRadius: BorderRadius.circular(15),
//                     ),
//                     color: Colors.blue[900],
//                     child: SizedBox(
//                       height: 50,
//                       width: double.infinity,
//                       child: Container(
//                         margin: const EdgeInsets.only(left: 20),
//                         alignment: Alignment.center,
//                         padding: const EdgeInsets.all(10),
//                         child: Row(
//                           children: [
//                             Expanded(
//                               flex: 10,
//                               child: Checkbox(
//                                 value: todoList[index]['completed'],
//                                 onChanged: (bool? value) {
//                                   toggleCompletion(index);
//                                 },
//                               ),
//                             ),
//                             Expanded(
//                               flex: 70,
//                               child: Text(
//                                 todoList[index]['value'].toString(),
//                                 style: TextStyle(
//                                   color: todoList[index]['completed']
//                                       ? Colors.green
//                                       : Colors.white,
//                                   fontWeight: FontWeight.bold,
//                                   decoration: todoList[index]['completed']
//                                       ? TextDecoration.lineThrough
//                                       : TextDecoration.none,
//                                 ),
//                               ),
//                             ),
//                             Expanded(
//                               flex: 20,
//                               child: CircleAvatar(
//                                 radius: 30,
//                                 backgroundColor: Colors.white,
//                                 child: TextButton(
//                                   onPressed: () {
//                                     deleteItem(index);
//                                   },
//                                   child: const Icon(
//                                     Icons.delete,
//                                     color: Colors.black,
//                                   ),
//                                 ),
//                               ),
//                             ),
//                           ],
//                         ),
//                       ),
//                     ),
//                   );
//                 },
//               ),
//             ),
//             Expanded(
//               flex: 10,
//               child: Row(
//                 children: [
//                   Expanded(
//                     flex: 70,
//                     child: SizedBox(
//                       height: 40,
//                       child: TextFormField(
//                         controller: _controller, // Set the controller here
//                         decoration: InputDecoration(
//                           border: OutlineInputBorder(
//                             borderRadius: BorderRadius.circular(15),
//                           ),
//                           fillColor: Colors.blue[300],
//                           filled: true,
//                           labelText: 'Create Task...',
//                           labelStyle: TextStyle(
//                             color: Colors.indigo[900],
//                             fontWeight: FontWeight.bold,
//                           ),
//                         ),
//                       ),
//                     ),
//                   ),
//                   const Expanded(
//                     flex: 3,
//                     child: SizedBox(
//                       width: 5,
//                     ),
//                   ),
//                   Expanded(
//                     flex: 27,
//                     child: ElevatedButton(
//                       onPressed: addList,
//                       child: Container(
//                         height: 15,
//                         width: double.infinity,
//                         alignment: Alignment.center,
//                         child: const Text("Add"),
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
