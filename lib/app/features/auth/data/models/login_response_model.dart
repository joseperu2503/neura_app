class AuthResponseModel {
  final String accessToken;

  AuthResponseModel({required this.accessToken});

  factory AuthResponseModel.fromJson(Map<String, dynamic> json) =>
      AuthResponseModel(accessToken: json["accessToken"]);
}
