import 'package:sqflite/sqflite.dart';
import '../models/database_model.dart';

class LocalDatabase {
  factory LocalDatabase() => _singleton;

  static final _singleton = LocalDatabase._();
  LocalDatabase._();

  Database? _database;

  Future<void> init() async {
    _database ??= await _initDatabase();
  }

  Future<Database?> _initDatabase() async {
    final databasePath = await getDatabasesPath();
    final path = '$databasePath/persons.db';
    return await openDatabase(path, version: 1, onCreate: _createDatabase);
  }

  Future<void> _createDatabase(Database db, int version) async {
    return await db.execute('''
    CREATE TABLE persons
        (id INTEGER PRIMARY KEY AUTOINCREMENT,
         name TEXT NOT NULL,
         number TEXT NOT NULL)''');
  }

  Future<Database> get database async {
    if (_database != null) {
      return _database!;
    }
    _database = await _initDatabase();
    return _database!;
  }

  Future<int> addPerson(Person person) async {
    final db = await database;
    return await db.insert('persons', person.toMap());
  }

  Future<List<Person>> getAllPersons() async {
    final db = await database;
    final List<Map<String, dynamic>> result = await db.query('persons');
    return result.map((map) => Person.fromMap(map)).toList();
  }

  Future<int> updatePerson(Person person) async {
    final db = await database;
    return await db.update(
      'persons',
      person.toMap(),
      where: 'id = ${person.id}',
    );
  }

  Future<int> deletePerson(int id) async {
    final db = await database;
    return await db.delete('persons', where: 'id = $id');
  }

  Future<void> close() async {
    _database?.close();
  }
}
