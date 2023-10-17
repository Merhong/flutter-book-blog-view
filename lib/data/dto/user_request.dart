
// 회원가입 요청DTO
// 응답 받을 일이 없으므로 fromJson이 없고 toJson만 있음!
class JoinReqDTO {
  final String username;
  final String password;
  final String email;

  JoinReqDTO(
      {required this.username, required this.password, required this.email});

  Map<String, dynamic> toJson() =>
      {"username": username, "password": password, "email": email};
}
