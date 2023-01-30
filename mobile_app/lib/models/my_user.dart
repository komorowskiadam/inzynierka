class MyUser {
  final int id;
  final String name;
  final String surname;

  const MyUser({required this.id, required this.name, required this.surname});

  factory MyUser.fromJson(Map<String, dynamic> json) {
    return MyUser(id: json['id'], name: json['name'], surname: json['surname']);
  }
}
