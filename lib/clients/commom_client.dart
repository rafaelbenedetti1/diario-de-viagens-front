import 'dart:convert';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:diario_viagens_front/exception/app_exception.dart';
import 'package:http/http.dart' as http;

class CommomClient {
  static Future<http.Response> getRequest(String url, String token,
      {Duration timeout = const Duration(seconds: 10)}) async {
    Map<String, String> headers = new Map();
    if (token != null) {
      headers['Authorization'] = 'bearer $token';
    }

    http.Response response = await http.get(Uri.parse(url), headers: headers).timeout(timeout);
    return response;
  }

  static Future<http.Response> postRequest(String url, Map data, String token,
      {Duration timeout = const Duration(seconds: 10)}) async {

      var body;
      if (data != null) body = json.encode(data);
      var headers = {
        'Content-Type': 'application/json',
      };
      if (token != null) {
        headers['Authorization'] = "Bearer $token";
      }
      http.Response response = await http.post(Uri.parse(url), body: body, headers: headers).timeout(timeout);
      return response;
    
  }

  static Future<http.Response> deleteRequest(String url, Map data, String token,
      {Duration timeout = const Duration(seconds: 10)}) async {
    var body;
    if (data != null) body = json.encode(data);
    var headers = {
      'Content-Type': 'application/json',
    };
    if (token != null) {
      headers['Authorization'] = "Bearer $token";
    }
    http.Response response = await http.delete(Uri.parse(url), body: body, headers: headers).timeout(timeout);
    return response;
  }

  static Future<http.Response> postForm(String url, Map data,
      {Duration timeout = const Duration(seconds: 10), Map? customHeader}) async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (ConnectivityResult.none == connectivityResult) {
      throw AppException(AppException.levelWarning, "É necessário conexão com a internet para continuar");
    }
    var headers = {'Content-Type': 'application/x-www-form-urlencoded'};
    // TODO: Validar se esse cast não vai dar erro
    if (customHeader != null) headers.addAll(customHeader as Map<String, String>);
    http.Response response = await http.post(Uri.parse(url), body: data, headers: headers).timeout(timeout);
    return response;
  }

  static tratarRetornoHTTP(int statusCode) {
    switch (statusCode) {
      case 200:
      case 201:
        return null;
      case 500:
        throw AppException(AppException.levelWarning, "Erro no servidor ao processar a requisição.",
            codeError: "erro_500");
      case 404:
        throw AppException(AppException.levelWarning, "Serviço está fora do ar.", codeError: "erro_404");
      case 401:
        throw AppException(AppException.levelWarning, "O app não está mais logado, faça o login novamente.",
            codeError: "erro_401");
      default:
        throw AppException(AppException.levelWarning, "Erro $statusCode ao processar a requisição.");
    }
  }
}
