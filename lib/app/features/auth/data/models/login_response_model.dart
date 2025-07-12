class AuthResponseModel {
  final String token;

  AuthResponseModel({
    required this.token,
  });

  factory AuthResponseModel.fromJson(Map<String, dynamic> json) =>
      AuthResponseModel(
        token: json["token"],
      );
}
