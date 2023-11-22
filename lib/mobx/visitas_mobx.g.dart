// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'visitas_mobx.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$VisitasMobx on _VisitasMobx, Store {
  late final _$visitasAtom =
      Atom(name: '_VisitasMobx.visitas', context: context);

  @override
  List<Visita> get visitas {
    _$visitasAtom.reportRead();
    return super.visitas;
  }

  @override
  set visitas(List<Visita> value) {
    _$visitasAtom.reportWrite(value, super.visitas, () {
      super.visitas = value;
    });
  }

  late final _$visitasWidgetAtom =
      Atom(name: '_VisitasMobx.visitasWidget', context: context);

  @override
  ValueNotifier<List<DeliveryProcess>> get visitasWidget {
    _$visitasWidgetAtom.reportRead();
    return super.visitasWidget;
  }

  @override
  set visitasWidget(ValueNotifier<List<DeliveryProcess>> value) {
    _$visitasWidgetAtom.reportWrite(value, super.visitasWidget, () {
      super.visitasWidget = value;
    });
  }

  late final _$_VisitasMobxActionController =
      ActionController(name: '_VisitasMobx', context: context);

  @override
  dynamic adicionaVisita(List<Visita> newList) {
    final _$actionInfo = _$_VisitasMobxActionController.startAction(
        name: '_VisitasMobx.adicionaVisita');
    try {
      return super.adicionaVisita(newList);
    } finally {
      _$_VisitasMobxActionController.endAction(_$actionInfo);
    }
  }

  @override
  dynamic setVisitas(List<DeliveryProcess> newList) {
    final _$actionInfo = _$_VisitasMobxActionController.startAction(
        name: '_VisitasMobx.setVisitas');
    try {
      return super.setVisitas(newList);
    } finally {
      _$_VisitasMobxActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
visitas: ${visitas},
visitasWidget: ${visitasWidget}
    ''';
  }
}
