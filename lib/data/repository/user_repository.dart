import 'package:flutter_blog/_core/constants/http.dart';
import 'package:flutter_blog/data/dto/response_dto.dart';
import 'package:flutter_blog/data/dto/user_request.dart';
import 'package:flutter_blog/data/model/user.dart';

/* M-V-VM 패턴 */
// View -> Provider(전역Provider or ViewModel) -> Repository
class UserRepository {
  // 통신엔 무조건 try-catch문 사용
  Future<ResponseDTO> fetchJoin(JoinReqDTO requestDTO) async {
    try {
      final response = await dio.post("/join", data: requestDTO.toJson());
      // DTO에 담기 -> data가 dynamic인 Map 타입
      ResponseDTO responseDTO = ResponseDTO.fromJson(response.data);
      // 다시 responseDTO의 data에 파싱된 user를 덮어씌운다.
      // 즉, dynamic인 user 타입이 된다.
      // responseDTO.data = User.fromJson(responseDTO.data);
      return responseDTO;

    } catch (e) {
      // 통신코드 200이 아니면 catch를 탄다.
      return ResponseDTO(-1, "중복되는 유저명입니다.", null);
    }
  }
}
