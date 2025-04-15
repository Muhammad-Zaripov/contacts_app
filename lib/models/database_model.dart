class Person {
  final int? id;
  final String name;
  final String number;
  Person({this.id, required this.name, required this.number});

  Map<String, dynamic> toMap() {
    return {'id': id, 'name': name, 'number': number};
  }

  factory Person.fromMap(Map<String, dynamic> map) {
    return Person(
      id: map['id'] as int,
      name: map['name'] as String,
      number: map['number'] as String,
    );
  }
}
