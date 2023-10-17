import 'package:flutter/material.dart';
import 'package:flutter_blog/_core/constants/move.dart';
import 'package:flutter_blog/data/dto/response_dto.dart';
import 'package:flutter_blog/data/dto/user_request.dart';
import 'package:flutter_blog/data/model/user.dart';
import 'package:flutter_blog/data/repository/user_repository.dart';
import 'package:flutter_blog/main.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Provider 만드는 패턴 (① -> ② -> ③)
// 1. 창고 데이터
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
  Future<void> login() async {
    // 1. 통신 코드

    // 2. 비지니스 로직
  }

  // 로그아웃
  Future<void> logout() async {
    // 1. 통신 코드

    // 2. 비지니스 로직
  }

// 회원수정에도 필요하지만 여기는 수정이 없으므로 생략
}

// 2. 창고 (그냥 Provider는 상태 관리를 하지 않으니 필요없음!!!)

// 3. 창고 관리자
final sessionProvider = Provider<SessionUser>((ref) {
  return SessionUser();
});
