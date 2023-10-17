import 'package:flutter/material.dart';
import 'package:flutter_blog/ui/pages/auth/join_page/join_page.dart';
import 'package:flutter_blog/ui/pages/auth/login_page/login_page.dart';
import 'package:flutter_blog/ui/pages/post/list_page/post_list_page.dart';
import 'package:flutter_blog/ui/pages/post/write_page/post_write_page.dart';

// 실수하지 말라고 static으로 만들어둠.
// Move안에 모아둔 이유? 관리하기 편해서
class Move {
  static String loginPage = "/login";
  static String joinPage = "/join";
  static String postListPage = "/post/list";
  static String postWritePage = "/post/write";
  static String userInfoPage = "/user/info";
}

// Router는 Map타입 리턴 받아야함
// function대신 dynamic으로 적어도 된다.
Map<String, Widget Function(BuildContext)> getRouters() {
  return {
    Move.loginPage: (context) => const LoginPage(),
    Move.joinPage: (context) => const JoinPage(),
    Move.postListPage: (context) => PostListPage(),
    Move.postWritePage: (context) => const PostWritePage(),
  };
}
