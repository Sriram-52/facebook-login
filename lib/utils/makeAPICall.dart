import 'package:dio/dio.dart';

class HTTPService {
  late Dio _dio;

  HTTPService({String? token}) {
    final baseUrl = "https://us-central1-atelia-dev-env.cloudfunctions.net/api";
    var customHeaders = {'Authorization': "Bearer $token"};
    _dio = Dio(BaseOptions(
        baseUrl: baseUrl,
        headers: customHeaders,
        contentType: 'application/json',
        connectTimeout: 2 * 60 * 1000));
    initializeInterceptors();
  }

  initializeInterceptors() {
    _dio.interceptors.add(InterceptorsWrapper(onError: (err, handler) {
      print(err.message);
      handler.next(err);
    }, onRequest: (requestOptions, handler) {
      print("${requestOptions.method} ${requestOptions.path}");
      handler.next(requestOptions);
    }, onResponse: (response, handler) {
      //print(response.data);
      handler.next(response);
    }));
  }

  Future getRequest({required String url}) async {
    try {
      //dio.options.baseUrl = UriParser.BASEURL;
      var response = await _dio.get(url);
      return response.data;
    } on DioError catch (e) {
      if (DioErrorType.receiveTimeout == e.type ||
          DioErrorType.connectTimeout == e.type) {
        throw CommunicationTimeoutException();
      } else if (DioErrorType.response == e.type) {
        throw CommunicationTimeoutException();
      } else if (DioErrorType.other == e.type) {
        if (e.message.contains('SocketException')) {
          throw CommunicationTimeoutException();
        }
      } else {
        throw CommunicationException();
      }
    }
  }

  Future postRequest(
      {required String url, required Map<String, dynamic> payload}) async {
    try {
      var response = await _dio.post(url, data: payload);
      return response.data;
    } on DioError catch (e) {
      if (DioErrorType.receiveTimeout == e.type ||
          DioErrorType.connectTimeout == e.type) {
        throw CommunicationTimeoutException();
      } else if (DioErrorType.response == e.type) {
        throw CommunicationTimeoutException(
            e.response?.data["message"] ?? "Something went wrong");
      } else if (DioErrorType.other == e.type) {
        if (e.message.contains('SocketException')) {
          throw CommunicationTimeoutException();
        }
      } else {
        throw CommunicationException();
      }
    }
  }

  Future putRequest({required String url, required Map<String, dynamic> payload}) async {
    try {
      var response = await _dio.put(url, data: payload);
      return response.data;
    } on DioError catch (e) {
      if (DioErrorType.receiveTimeout == e.type || DioErrorType.connectTimeout == e.type) {
        throw CommunicationTimeoutException();
      } else if (DioErrorType.response == e.type) {
        throw CommunicationTimeoutException(e.response?.data["message"] ?? "Something went wrong");
      } else if (DioErrorType.other == e.type) {
        if (e.message.contains('SocketException')) {
          throw CommunicationTimeoutException();
        }
      } else {
        throw CommunicationException();
      }
    }
  }
}

class CommunicationTimeoutException implements Exception {
  String _message =
      "Server is not reachable. Please verify your internet connection and try again";
  CommunicationTimeoutException([String? message]) {
    this._message = message ?? _message;
  }

  @override
  String toString() {
    return _message;
  }
}

class CommunicationException implements Exception {
  String _message = "Problem connecting to the server. Please try again.";
  CommunicationException([String? message]) {
    this._message = message ?? _message;
  }

  @override
  String toString() {
    return _message;
  }
}
