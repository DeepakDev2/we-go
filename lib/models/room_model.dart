class RoomModel {
  final String roomId;
  final String password;
  final List members;
  final String ownerId;

  const RoomModel({
    required this.roomId,
    required this.password,
    required this.members,
    required this.ownerId,
  });

  factory RoomModel.fromMap(Map<String, dynamic> map) {
    return RoomModel(
      roomId: map["roomId"] as String,
      password: map["password"] as String,
      members: map["members"] as List,
      ownerId: map["ownerId"] as String,
    );
  }
}
