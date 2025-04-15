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
                  return ListTile(
                    leading: CircleAvatar(
                      backgroundColor: Colors.grey,
                      child: Text(
                        person.name[0],
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
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: Icon(Icons.edit, color: Colors.blue),
                          onPressed: () {
                            final person = persons[index];

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
                                            style: TextStyle(
                                              color: Colors.black,
                                            ),
                                          ),
                                        ),
                                        TextButton(
                                          onPressed: () {
                                            _updatePerson(person.id!);
                                          },
                                          child: Text(
                                            'Save',
                                            style: TextStyle(
                                              color: Colors.black,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                );
                              },
                            );
                          },
                        ),

                        IconButton(
                          icon: Icon(Icons.delete, color: Colors.red),
                          onPressed: () => _deletePerson(person.id!),
                        ),
                      ],
                    ),
                  );
                },
              ),
    );
  }
}
