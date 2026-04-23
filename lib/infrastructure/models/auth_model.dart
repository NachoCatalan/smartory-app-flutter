
class AuthModel {

  String token;
  String refreshToken;

  AuthModel({
    required this.token,
    required this.refreshToken,
  });

  factory AuthModel.fromJson( Map<String,dynamic> json) => AuthModel(
    token: json['token'] ?? '',
    refreshToken: json['refreshToken'] ?? ''
  );

}
