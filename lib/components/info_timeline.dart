import 'package:flutter/material.dart';

class OrderInfo {
  const OrderInfo({
    required this.date,
    required this.deliveryProcesses,
  });

  final DateTime date;
  final List<DeliveryProcess> deliveryProcesses;
  
}

class DeliveryProcess {
  const DeliveryProcess(
    this.tituloVisita, {
    this.messages = const [],
  });

  const DeliveryProcess.complete()
      : this.tituloVisita = 'Done',
        this.messages = const [];

  final String tituloVisita;
  final List<dynamic> messages;

  bool get isCompleted => tituloVisita == 'Done';
}

class DeliveryMessage {
  const DeliveryMessage(this.message);

  final String message;

  @override
  String toString() {
    return ' $message';
  }
}

deliveryImage(String imageAsset) {
  return Image.asset(imageAsset);
}