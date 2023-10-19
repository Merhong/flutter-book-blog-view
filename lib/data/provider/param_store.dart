import 'package:flutter_blog/main.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/* 1. 창고 데이터 */
class RequestParam {
  int? postDetailId;

  RequestParam({this.postDetailId}); // 화면에 쓰이는 아이디
}

/* 2. 창고 (비지니스 로직) */
// 창고가 창고 데이터를 들고 있음
class ParamStore extends RequestParam {
  final mContext = navigatorKey.currentContext;

  // void movePostDetail(int postId) {
  //   // 1. Param 전달 받고
  //   this.postDetailId = postId; // super도 가능 자식이 들고 있으니
  //
  //   // 2. 화면 이동
  //   Navigator.push(
  //       context, MaterialPageRoute(builder: (_) => PostDetailPage()));
  // }
}

/* 3. 창고 관리자 */
final paramProvider = Provider<ParamStore>((ref) {
  return ParamStore();
});
