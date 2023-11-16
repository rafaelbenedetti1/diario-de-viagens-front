import 'dart:convert';

import 'package:diario_viagens_front/clients/commom_client.dart';
import 'package:diario_viagens_front/exception/app_exception.dart';
import 'package:diario_viagens_front/model/response_request.dart';
import 'package:diario_viagens_front/model/viagem.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart' as DotEnv;

class ViagemClient {
  Future<UsuarioViagem> inserirViagem(String usuario, Viagem viagem) async {
    String? mensagemErro;
    var data = UsuarioViagem.toJson(usuario, viagem);

    var resp = await CommomClient.postRequest(
      "${DotEnv.dotenv.env['BACKEND_URL_BASE']!}/api/v1/viagem/inserir",
      data,
      '',
      timeout: Duration(seconds: 30),
    );
    if (resp.statusCode == 200) {
      var jsonToken = json.decode(utf8.decode(resp.bodyBytes));
      ResponseRequest rr = ResponseRequest.fromJson(jsonToken);
      if (rr.statusCode == 200) {
        return UsuarioViagem.fromJson(rr.data);
      }
      mensagemErro = rr.getMensagens();
    } else {
      CommomClient.tratarRetornoHTTP(resp.statusCode);
    }
    throw AppException(AppException.levelWarning, ('Erro'));
  }

  Future<bool> excluirViagem(String usuarioId, String viagemId) async {
    String? mensagemErro;
    var data ={
      "usuarioViagemId": usuarioId,
      "viagemId": viagemId
    };

    var resp = await CommomClient.postRequest(
      "${DotEnv.dotenv.env['BACKEND_URL_BASE']!}/api/v1/viagem/excluir",
      data,
      '',
      timeout: Duration(seconds: 30),
    );
    if (resp.statusCode == 200) {
      var jsonToken = json.decode(utf8.decode(resp.bodyBytes));
      ResponseRequest rr = ResponseRequest.fromJson(jsonToken);
      if (rr.statusCode == 200) {
        return rr.data;
      }
      mensagemErro = rr.getMensagens();
    } else {
      CommomClient.tratarRetornoHTTP(resp.statusCode);
    }
    throw AppException(AppException.levelWarning, ('Erro'));
  }

  Future<UsuarioViagem> buscarViagens(String usuario) async {
    String? mensagemErro;

    var resp = await CommomClient.getRequest(
      "${DotEnv.dotenv.env['BACKEND_URL_BASE']!}/api/v1/viagem/$usuario",
      '',
    );
    if (resp.statusCode == 200) {
      var jsonToken = json.decode(utf8.decode(resp.bodyBytes));
      ResponseRequest rr = ResponseRequest.fromJson(jsonToken);
      if (rr.statusCode == 200) {
        return UsuarioViagem.fromJson(rr.data);
      }
      mensagemErro = rr.getMensagens();
    } else {
      CommomClient.tratarRetornoHTTP(resp.statusCode);
    }
    throw AppException(AppException.levelWarning, ('Erro'));
  }

  Future<UsuarioViagem> buscarViagem(String usuario, String viagemId) async {
    String? mensagemErro;

    var resp = await CommomClient.getRequest(
      "${DotEnv.dotenv.env['BACKEND_URL_BASE']!}/api/v1/viagem/$usuario",
      '',
    );
    if (resp.statusCode == 200) {
      var jsonToken = json.decode(utf8.decode(resp.bodyBytes));
      ResponseRequest rr = ResponseRequest.fromJson(jsonToken);
      if (rr.statusCode == 200) {
        return UsuarioViagem.fromJson(rr.data);
      }
      mensagemErro = rr.getMensagens();
    } else {
      CommomClient.tratarRetornoHTTP(resp.statusCode);
    }
    throw AppException(AppException.levelWarning, ('Erro'));
  }
}
