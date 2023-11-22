import 'package:diario_viagens_front/components/info_timeline.dart';
import 'package:diario_viagens_front/model/viagem.dart';
import 'package:flutter/material.dart';
import 'package:mobx/mobx.dart';

part 'visitas_mobx.g.dart';

class VisitasMobx = _VisitasMobx with _$VisitasMobx;

abstract class _VisitasMobx with Store {

  @observable
  List<Visita> visitas = [];

  @observable
  ValueNotifier<List<DeliveryProcess>> visitasWidget = ValueNotifier<List<DeliveryProcess>>([]);

  
  @action
  adicionaVisita(List<Visita> newList ) => visitas = newList;

  @action
  setVisitas(List<DeliveryProcess> newList) => visitasWidget.value = newList;
}