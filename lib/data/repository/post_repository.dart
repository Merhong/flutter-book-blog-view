import 'package:dio/dio.dart';
import 'package:flutter_blog/_core/constants/http.dart';
import 'package:flutter_blog/data/dto/post_request.dart';
import 'package:flutter_blog/data/dto/response_dto.dart';
import 'package:flutter_blog/data/model/post.dart';
import 'package:logger/logger.dart';

/* M-V-VM 패턴 */
// Repository는 통신과 파싱만 한다!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
// View -> Provider(전역Provider or ViewModel) -> Repository
class PostRepository {
  // 통신엔 무조건 try-catch문 사용
  // PostList
  Future<ResponseDTO> fetchPostList(String jwt) async {
    try {
      // 1. 통신 : 헤더의 jwt를 전달해야한다. ref 사용시 SRP 위반
      final response = await dio.get("/post",
          options: Options(headers: {"Authorization": "${jwt}"}));

      // 2. ResponseDTO 파싱 : DTO에 담기 -> data가 dynamic인 Map 타입
      ResponseDTO responseDTO = ResponseDTO.fromJson(response.data);

      // 3. ResponseDTo의 data 파싱
      List<dynamic> mapList = responseDTO.data as List<dynamic>;
      List<Post> postList = mapList.map((e) => Post.fromJson(e)).toList();

      // 4. 파싱된 데이터를 다시 공통 DTO로 덮어씌우기
      // 다시 responseDTO의 data에 파싱된 postList를 덮어씌운다.
      // 즉, dynamic인 Post 타입이 된다.
      responseDTO.data = postList;

      return responseDTO;
    } catch (e) {
      // 통신코드 200이 아니면 catch를 탄다.
      return ResponseDTO(-1, "게시글 목록 불러오기 실패.", null);
    }
  }

  Future<ResponseDTO> fetchPost(String jwt, PostSaveReqDTO dto) async {
    try {
      // 1. 통신
      final response = await dio.post("/post",
          data: dto.toJson(),
          options: Options(headers: {"Authorization": "${jwt}"}));

      Logger().d(response.data);

      // 2. ResponseDTO 파싱
      ResponseDTO responseDTO = ResponseDTO.fromJson(response.data);
      Logger().d(responseDTO.data);

      // 3. ResponseDTO의 data 파싱
      Post post = Post.fromJson(responseDTO.data);

      // 4. 파싱된 데이터를 다시 공통 DTO로 덮어씌우기
      responseDTO.data = post;

      return responseDTO;
    } catch (e) {
      return ResponseDTO(-1, "게시글 작성 실패", null);
    }
  }
}
