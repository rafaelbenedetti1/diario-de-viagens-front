import 'package:diario_viagens_front/model/viagem.dart';
import 'package:mobx/mobx.dart';

part 'visitas_mobx.g.dart';

class VisitasMobx = _VisitasMobx with _$VisitasMobx;

abstract class _VisitasMobx with Store {

  @observable
  List<Visita> visitas = [];
  
  @action
  adicionaVisita(Visita visita) => visitas.add(visita);
}