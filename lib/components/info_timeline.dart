import 'package:flutter/material.dart';

class OrderInfo {
  const OrderInfo({
    required this.deliveryProcesses,
  });

  final List<DeliveryProcess> deliveryProcesses;
}

class DeliveryProcess {
  const DeliveryProcess(
    this.tituloVisita, {
    this.messages = const [],
  });

  const DeliveryProcess.complete()
      : tituloVisita = 'Done',
        messages = const [];

  final String tituloVisita;
  final List<Widget> messages;

  bool get isCompleted => tituloVisita == 'Done';
}
