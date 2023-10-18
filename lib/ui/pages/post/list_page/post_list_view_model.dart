import 'package:flutter/material.dart';
import 'package:flutter_blog/data/dto/post_request.dart';
import 'package:flutter_blog/data/dto/response_dto.dart';
import 'package:flutter_blog/data/model/post.dart';
import 'package:flutter_blog/data/provider/session_provider.dart';
import 'package:flutter_blog/data/repository/post_repository.dart';
import 'package:flutter_blog/main.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// 1. 창고 데이터
class PostListModel {
  List<Post> posts;

  PostListModel(this.posts);
}

// 2. 창고
class PostListViewModel extends StateNotifier<PostListModel?> {
  final mContext = navigatorKey.currentContext;

  PostListViewModel(super._state, this.ref);

  Ref ref;

  // SNP의 Init 컨벤션
  Future<void> notifyInit() async {
    // jwt 가져오기
    SessionUser sessionUser = ref.read(sessionProvider);

    ResponseDTO responseDTO =
        await PostRepository().fetchPostList(sessionUser.jwt!);
    state = PostListModel(responseDTO.data);
  }

  // 글쓰기
  Future<void> notifyAdd(PostSaveReqDTO dto) async {
    SessionUser sessionUser = ref.read(sessionProvider);

    ResponseDTO responseDTO =
        await PostRepository().fetchPost(sessionUser.jwt!, dto);

    if (responseDTO.code == 1) {
      Post newPost =
          responseDTO.data as Post; // 1. dynamic(Post) 다운캐스팅 묵시적으로 해주지만 적어준거임.
      // List<Post> posts = state!.posts; // 상태값"의" posts가 posts다
      List<Post> newPosts = [
        newPost,
        ...state!.posts
      ]; // 2. 2. 기존 상태에 데이터 추가 [전개연산자] 새로 글쓰면 맨앞 번지에 나오게 설정
      state = PostListModel(
          newPosts); // 3. ViewModel(창고) 데이터 갱신이 완료 -> watch 구독자는 rebuild 됨.

      Navigator.pop(mContext!); // 4. 글쓰기 화면 pop
    } else {
      ScaffoldMessenger.of(mContext!).showSnackBar(
          SnackBar(content: Text("게시물 작성 실패 : ${responseDTO.msg}")));
    }
  }
}

// 3. 창고 관리자 (View 빌드되기 직전에 생성됨)
// ref watch는 지속적 구독, autoDispose는 필요없어지는 화면 자동으로 삭제해줌
final postListProvider =
    StateNotifierProvider.autoDispose<PostListViewModel, PostListModel?>(
  (ref) {
    return PostListViewModel(null, ref)..notifyInit();
  },
);
