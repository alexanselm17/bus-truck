import 'package:dio/dio.dart';
import '../services/NavigationService.dart';
import 'constants.dart';
import 'user_shared_pref.dart';

import '../service_locator.dart';

class ApiBaseHelper {
  static final String url = AppConstants.baseUrl;
  static bool redirected = false;
  static BaseOptions opts = BaseOptions(
    baseUrl: url,
    followRedirects: false,
    responseType: ResponseType.json,
  );

  static Dio createDio() {
    return Dio(opts);
  }

  static Dio addInterceptors(Dio dio) {
    return dio
      ..interceptors.add(
        InterceptorsWrapper(onRequest: (RequestOptions options, handler) {
          requestInterceptor(options);
          return handler.next(options);
        }, onError: (DioError e, handler) async {
          print([
            "error",
            e.response!.data,
            e.response!.statusCode,
            e.response!.requestOptions.uri
          ]);
          if (e.response!.statusCode == 401 && redirected != true) {
            //notify listener that user an authenicated.use this.
            redirected = true;
            locator<NavigationService>()
                .navigateTo('login'); //navigateTo('login');
          }
          return handler.next(e);
        }, onResponse: (response, handler) {
          return handler.next(response);
        }),
      );
  }

  static dynamic requestInterceptor(RequestOptions options) async {
    String token = await UserPreferences().getToken();
    options.headers.addAll({
      "Authorization": "Bearer $token",
      "Content-Type": "application/json",
      "Accept": "application/json",
    });
    return options;
  }

  static final dio = createDio();
  static final baseAPI = addInterceptors(dio);

  getHTTP(String url) async {
    try {
      Response response = await baseAPI.get(
        url,
      );
      return response;
    } on DioError catch (e) {
      print(e);
      return e;
      // Handle error
    }
  }

  postHTTP(String url, dynamic data) async {
    try {
      Response response = await baseAPI.post(url, data: data);
      return response;
    } on DioError catch (e) {
      print('main catch $e');
      return e;
      // Handle error
    }
  }

  putHTTP(String url, dynamic data) async {
    try {
      Response response = await baseAPI.put(url, data: data);
      return response;
    } on DioError catch (e) {
      print('main catch $e');

      // Handle error
    }
  }

  deleteHTTP(String url) async {
    try {
      Response response = await baseAPI.delete(url);
      return response;
    } on DioError {
      // Handle error
    }
  }
}
