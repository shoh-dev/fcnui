import 'package:dio/dio.dart';
import 'package:fpdart/fpdart.dart';

const String kBaseUrl = 'http://localhost:3000/api/';

typedef Result<T> = Either<String, T>;

class ApiClient {
  ApiClient() {
    initialize();
  }

  late final Dio dio;

  void initialize() {
    dio = Dio(BaseOptions(baseUrl: kBaseUrl));
  }

  Future<Result> findComponent(List<String> componentNames) async {
    try {
      final response = await dio
          .post("ui/component", data: {"componentNames": componentNames});
      return right(response.data);
    } on DioException catch (e) {
      print('dio exception');
      return left(e.error.toString());
    } catch (e, st) {
      print('exception');
      print(st);
      return left(e.toString());
    }
  }
}
