class Organization {
  final int? id;
  final String name;

  Organization({this.id, required this.name});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
    };
  }
}

class Message {
  final int? id;
  final int organizationId;
  final String sender;
  final String message;
  final String timestamp;

  Message(
      {this.id,
      required this.organizationId,
      required this.sender,
      required this.message,
      required this.timestamp});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'organizationId': organizationId,
      'sender': sender,
      'message': message,
      'timestamp': timestamp,
    };
  }
}
