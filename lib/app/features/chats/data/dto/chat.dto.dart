class ChatDto {
  final String id;
  final String? userId;
  final List<MessageDto> messages;
  final String title;
  final DateTime createdAt;
  final DateTime updatedAt;
  final int v;

  ChatDto({
    required this.id,
    required this.userId,
    required this.messages,
    required this.title,
    required this.createdAt,
    required this.updatedAt,
    required this.v,
  });

  factory ChatDto.fromJson(Map<String, dynamic> json) => ChatDto(
        id: json["_id"],
        userId: json["userId"],
        messages: List<MessageDto>.from(
            json["messages"].map((x) => MessageDto.fromJson(x))),
        title: json["title"],
        createdAt: DateTime.parse(json["createdAt"]),
        updatedAt: DateTime.parse(json["updatedAt"]),
        v: json["__v"],
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "userId": userId,
        "messages": List<dynamic>.from(messages.map((x) => x.toJson())),
        "title": title,
        "createdAt": createdAt.toIso8601String(),
        "updatedAt": updatedAt.toIso8601String(),
        "__v": v,
      };
}

class MessageDto {
  final String role;
  final String content;
  final DateTime createdAt;

  MessageDto({
    required this.role,
    required this.content,
    required this.createdAt,
  });

  factory MessageDto.fromJson(Map<String, dynamic> json) => MessageDto(
        role: json["role"],
        content: json["content"],
        createdAt: DateTime.parse(json["createdAt"]),
      );

  Map<String, dynamic> toJson() => {
        "role": role,
        "content": content,
        "createdAt": createdAt.toIso8601String(),
      };
}
