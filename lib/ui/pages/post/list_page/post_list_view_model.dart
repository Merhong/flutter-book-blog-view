import 'package:flutter_blog/data/dto/response_dto.dart';
import 'package:flutter_blog/data/model/post.dart';
import 'package:flutter_blog/data/provider/session_provider.dart';
import 'package:flutter_blog/data/repository/post_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// 1. 창고 데이터
class PostListModel {
  List<Post> posts;

  PostListModel(this.posts);
}

// 2. 창고
class PostListViewModel extends StateNotifier<PostListModel?> {
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
}

// 3. 창고 관리자 (View 빌드되기 직전에 생성됨)
// ref watch는 지속적 구독, autoDispose는 필요없어지는 화면 자동으로 삭제해줌
final postListProvider =
    StateNotifierProvider.autoDispose<PostListViewModel, PostListModel?>(
  (ref) {
    return PostListViewModel(null, ref)..notifyInit();
  },
);
