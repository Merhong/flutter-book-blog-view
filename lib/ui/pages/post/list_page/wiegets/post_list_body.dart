import 'package:flutter/material.dart';
import 'package:flutter_blog/data/model/post.dart';
import 'package:flutter_blog/data/provider/param_store.dart';
import 'package:flutter_blog/ui/pages/post/detail_page/post_detail_page.dart';
import 'package:flutter_blog/ui/pages/post/detail_page/post_detail_view_model.dart';
import 'package:flutter_blog/ui/pages/post/list_page/post_list_view_model.dart';
import 'package:flutter_blog/ui/pages/post/list_page/wiegets/post_list_item.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class PostListBody extends ConsumerWidget {
  const PostListBody({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // 구독 (PostListViewModel의 창고관리자 실행)
    PostListModel? model = ref.watch(postListProvider); // state == null
    // 디테일

    List<Post> posts = [];
    // 1초
    // 2초
    // 3초

    if (model != null) {
      posts = model.posts;
    }

    return ListView.separated(
      // ListView에 구분선을 추가해준다.
      itemCount: posts.length,
      itemBuilder: (context, index) {
        return InkWell(
          onTap: () {
            // 1. ParamStore에 postId를 전달
            ParamStore paramStore = ref.read(paramProvider);
            paramStore.postDetailId = posts[index].id;
            // 2. 화면 이동
            Navigator.push(
                context, MaterialPageRoute(builder: (_) => PostDetailPage()));
          },
          child: PostListItem(posts[index]),
        );
      },
      separatorBuilder: (context, index) {
        return const Divider();
      },
    );
  }
}
