class CreateChatGuestResponseDto {
  final dynamic userId;
  final List<dynamic>? messages;
  final String? title;
  final String? id;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final int? v;

  CreateChatGuestResponseDto({
    this.userId,
    this.messages,
    this.title,
    this.id,
    this.createdAt,
    this.updatedAt,
    this.v,
  });

  factory CreateChatGuestResponseDto.fromJson(
    Map<String, dynamic> json,
  ) => CreateChatGuestResponseDto(
    userId: json["userId"],
    messages:
        json["messages"] == null
            ? []
            : List<dynamic>.from(json["messages"]!.map((x) => x)),
    title: json["title"],
    id: json["_id"],
    createdAt:
        json["createdAt"] == null ? null : DateTime.parse(json["createdAt"]),
    updatedAt:
        json["updatedAt"] == null ? null : DateTime.parse(json["updatedAt"]),
    v: json["__v"],
  );
}
