import 'package:flutter/material.dart';
import 'package:flutter_blog/_core/constants/http.dart';
import 'package:flutter_blog/_core/constants/move.dart';
import 'package:flutter_blog/data/dto/response_dto.dart';
import 'package:flutter_blog/data/dto/user_request.dart';
import 'package:flutter_blog/data/model/user.dart';
import 'package:flutter_blog/data/repository/user_repository.dart';
import 'package:flutter_blog/main.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Provider는 비지니스 로직을 처리한다!!!!!!!!!!!!!!!!!!!!!!!
// Provider 만드는 패턴 (① -> ② -> ③)
// ① 창고 데이터
class SessionUser {
  // 1-1. 화면 Context에 접근하는 방법 (이게 엄청 쉬운 방법임)
  final mContext = navigatorKey.currentContext;

  User? user;
  String? jwt;
  bool isLogin; // jwt가 있어도 무조건 로그인된건 아니다. jwt 시간 만료시 사라지니까

  SessionUser({this.user, this.jwt, this.isLogin = false});

  // StateNotifierProvider(SNP)에서는 아래 부분이 창고에 들어가야함.
  // 회원가입
  Future<void> join(JoinReqDTO joinReqDTO) async {
    // 1. 통신 코드
    ResponseDTO responseDTO = await UserRepository().fetchJoin(joinReqDTO);

    // 2. 비지니스 로직
    // 2-1. 회원가입 성공
    if (responseDTO.code == 1) {
      Navigator.pushNamed(mContext!, Move.loginPage); // !는 무조건 있다는 말
    }
    // 2-2. 회원가입 실패 (-1)
    else {
      ScaffoldMessenger.of(mContext!)
          .showSnackBar(SnackBar(content: Text(responseDTO.msg)));
    }
  }

  // 로그인
  // void인 이유? 화면으로 응답을 안해줄꺼니까!!!
  Future<void> login(LoginReqDTO loginReqDTO) async {
    // 1. 통신 코드
    ResponseDTO responseDTO = await UserRepository().fetchLogin(loginReqDTO);

    // 2. 비지니스 로직
    // 2-1. 로그인 성공
    if (responseDTO.code == 1) {
      // 2-1-1. 세션값 갱신
      this.user = responseDTO.data as User; // dynamic data를 User타입으로 다운캐스팅
      this.jwt = responseDTO.token; // DTO에 담긴 토큰값 할당
      this.isLogin = true;

      // 2-1-2. 디바이스에 JWT 저장
      await secureStorage.write(key: "jwt", value: responseDTO.token);

      // 로그인 성공시 페이지 이동
      Navigator.pushNamed(mContext!, Move.postListPage); // !는 무조건 값이 있다는 말
    }
    // 2-2. 로그인 실패 (code == -1)
    else {
      ScaffoldMessenger.of(mContext!)
          .showSnackBar(SnackBar(content: Text(responseDTO.msg)));
    }
  }

  // 로그아웃
  // JWT는 로그아웃할 때 서버측으로 요청할 필요가 없음!!!
  Future<void> logout() async {
    // 1. 통신 코드

    // 2. 비지니스 로직
    this.jwt = null;
    this.isLogin = false;
    this.user = null;

    // 자동로그인 해지하기 I/O가 발생할 수 있으니 await을 붙인다.
    await secureStorage.delete(key: "jwt");

    // 다 처리하면 화면 이동
    Navigator.pushNamedAndRemoveUntil(mContext!, "/login", (route) => false);
  }

// 회원수정에도 필요하지만 여기는 수정이 없으므로 생략
}

// ② 창고 (전역 Provider는 상태 관리를 하지 않으니 필요없음!!!)

// ③ 창고 관리자
final sessionProvider = Provider<SessionUser>((ref) {
  return SessionUser();
});
