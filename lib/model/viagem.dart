class UsuarioViagem {
  String? id;
  String usuario = '';
  List<Viagem> viagens = [];

  UsuarioViagem.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    usuario = json['usuario'];
    json['viagens'].forEach((v) {
      viagens.add(Viagem.fromJson(v));
    });
  }

  static Map<String, dynamic> toJson(String usuario, Viagem viagem) {
    return {
      'usuario': usuario,
      'viagem': Viagem.toJson(viagem)
    };
  }
}

class Viagem {
  String? id;
  Localizacao? localizacao;
  String imagemCapa = '';
  List<String> imagens = [];
  List<Visita> visitas = [];
  String? dataInicio;
  String? dataFim;
  double? avaliacao;

  Viagem({this.id,this.localizacao, required this.imagemCapa, required this.imagens, required this.visitas, this.dataInicio, this.dataFim, required this.avaliacao});

  Viagem.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    localizacao = Localizacao.fromJson(json['localizacao']);
    imagemCapa = json['imagemCapa'];
    imagens = json['imagens'].cast<String>();
    json['visitas'].forEach((v) {
      visitas.add(Visita.fromJson(v));
    });
    dataInicio = json['dataInicio'];
    dataFim = json['dataFim'];
    avaliacao = json['avaliacao'];
  }

  static Map<String, dynamic> toJson(Viagem viagem) {
    return {
      'id': viagem.id,
      'localizacao': Localizacao.toJson(viagem.localizacao!),
      'imagemCapa': viagem.imagemCapa,
      'imagens': viagem.imagens,
      'visitas': viagem.visitas.map((e) => Visita.toJson(e)).toList(),
      'dataInicio': viagem.dataInicio,
      'dataFim': viagem.dataFim,
      'avaliacao': viagem.avaliacao
    };
  }
}

class Visita {
  String nomeLocal = '';
  String imagem = '';
  String data = '';

  Visita({required this.nomeLocal, required this.data, required this.imagem});

  Visita.fromJson(Map<String, dynamic> json) {
    nomeLocal = json['nomeLocal'];
    imagem = json['imagens'];
    data = json['data'];
  }

  static Map<String, dynamic> toJson(Visita visita) {
    return {
      'nomeLocal': visita.nomeLocal,
      'imagens': visita.imagem,
      'data': visita.data,
    };
  }
}

class Localizacao {
  String cidade = '';
  String estado = '';
  String pais = '';

  Localizacao({required this.cidade, required this.estado, required this.pais});

  Localizacao.fromJson(Map<String, dynamic> json) {
    cidade = json['cidade'];
    estado = json['estado'];
    pais = json['pais'];
  }

  static Map<String, dynamic> toJson(Localizacao localizacao) {
    return {
      'cidade': localizacao.cidade,
      'estado': localizacao.estado,
      'pais': localizacao.pais,
    };
  }
}
