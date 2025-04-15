import 'package:flutter/material.dart';

import '../../models/database_model.dart';
import '../../services/local_database_service.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final nameController = TextEditingController();
  final numberController = TextEditingController();
  final newNameController = TextEditingController();
  final newNumberController = TextEditingController();
  List<Person> persons = [];
  @override
  void initState() {
    super.initState();
    _loadPersons();
  }

  Future<void> _loadPersons() async {
    await LocalDatabase().init();
    persons = await LocalDatabase().getAllPersons();
    setState(() {});
  }

  Future<void> _deletePerson(int id) async {
    await LocalDatabase().deletePerson(id);
    _loadPersons();
  }

  Future<void> _addPerson() async {
    await LocalDatabase().addPerson(
      Person(name: nameController.text, number: numberController.text),
    );
    _loadPersons();
    Navigator.pop(context);
    nameController.clear();
    numberController.clear();
  }

  Future<void> _updatePerson(int id) async {
    await LocalDatabase().updatePerson(
      Person(
        id: id,
        name: newNameController.text,
        number: newNumberController.text,
      ),
    );
    _loadPersons();
    Navigator.pop(context);
    newNameController.clear();
    newNumberController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Text(
          'Contacts',
          style: TextStyle(color: Colors.white, fontSize: 25),
        ),
        actions: [
          IconButton(
            onPressed: () {
              showDialog(
                barrierDismissible: false,
                context: context,
                builder: (context) {
                  return AlertDialog(
                    backgroundColor: Colors.grey,
                    content: Column(
                      spacing: 20,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        TextField(
                          controller: nameController,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(),
                          ),
                        ),
                        TextField(
                          controller: numberController,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(),
                          ),
                        ),
                      ],
                    ),
                    actions: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          TextButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            child: Text(
                              'Cancel',
                              style: TextStyle(color: Colors.black),
                            ),
                          ),
                          TextButton(
                            onPressed: _addPerson,
                            child: Text(
                              'Add',
                              style: TextStyle(color: Colors.black),
                            ),
                          ),
                        ],
                      ),
                    ],
                  );
                },
              );
            },
            icon: Icon(Icons.add, color: Colors.blue, size: 35),
          ),
        ],
      ),
      body:
          persons.isEmpty
              ? Center(
                child: Text(
                  "No contacts",
                  style: TextStyle(color: Colors.white),
                ),
              )
              : ListView.builder(
                itemCount: persons.length,
                itemBuilder: (context, index) {
                  final person = persons[index];
                  return Dismissible(
                    key: Key(person.id.toString()),
                    background: Container(
                      color: Colors.blue,
                      alignment: Alignment.centerLeft,
                      padding: EdgeInsets.only(left: 20),
                      child: Row(
                        spacing: 20,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.edit, color: Colors.white),
                          Text(
                            'Edit',
                            style: TextStyle(color: Colors.white, fontSize: 20),
                          ),
                        ],
                      ),
                    ),
                    secondaryBackground: Container(
                      color: Colors.red,
                      alignment: Alignment.centerRight,
                      padding: EdgeInsets.only(right: 20),
                      child: Row(
                        spacing: 20,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            'Delete',
                            style: TextStyle(color: Colors.white, fontSize: 20),
                          ),
                          Icon(Icons.delete, color: Colors.white),
                        ],
                      ),
                    ),
                    confirmDismiss: (direction) async {
                      if (direction == DismissDirection.startToEnd) {
                        showDialog(
                          barrierDismissible: false,
                          context: context,
                          builder: (context) {
                            return AlertDialog(
                              backgroundColor: Colors.grey,
                              content: Column(
                                spacing: 20,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  TextField(
                                    controller: newNameController,
                                    decoration: InputDecoration(
                                      hintText: person.name,
                                      border: OutlineInputBorder(),
                                    ),
                                  ),
                                  TextField(
                                    controller: newNumberController,
                                    decoration: InputDecoration(
                                      hintText: person.number,
                                      border: OutlineInputBorder(),
                                    ),
                                  ),
                                ],
                              ),
                              actions: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    TextButton(
                                      onPressed: () {
                                        Navigator.pop(context);
                                      },
                                      child: Text(
                                        'Cancel',
                                        style: TextStyle(color: Colors.black),
                                      ),
                                    ),
                                    TextButton(
                                      onPressed: () {
                                        _updatePerson(person.id!);
                                      },
                                      child: Text(
                                        'Save',
                                        style: TextStyle(color: Colors.black),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            );
                          },
                        );
                        return false;
                      } else if (direction == DismissDirection.endToStart) {
                        await _deletePerson(person.id!);
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('${person.name} deleted')),
                        );
                        return true;
                      }
                      return false;
                    },
                    child: ListTile(
                      leading: CircleAvatar(
                        backgroundColor: Colors.grey,
                        child: Text(
                          person.name.isNotEmpty ? person.name[0] : '?',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                      title: Text(
                        person.name,
                        style: TextStyle(color: Colors.white, fontSize: 20),
                      ),
                      subtitle: Text(
                        person.number,
                        style: TextStyle(color: Colors.grey, fontSize: 16),
                      ),
                    ),
                  );
                },
              ),
    );
  }
}
