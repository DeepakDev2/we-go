class UserModel {
  const UserModel({
    required this.name,
    required this.email,
    this.rooms = const [],
    this.myRooms = const [],
  });

  final String name;
  final String email;
  final List rooms;
  final List myRooms;

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      email: map["email"] as String,
      name: map["name"] as String,
      rooms: map["rooms"] as List,
      myRooms: map["myRooms"] as List,
    );
  }
  Map<String, dynamic> toMap() {
    return {"name": name, "email": email, "rooms": rooms, "myRooms": myRooms};
  }
}
