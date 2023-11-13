class ResponseRequest {
  String? status; //OK
  String? message;
  List? messages;
  dynamic data;
  int? statusCode; //200

  ResponseRequest.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    messages = json['messages'];
    data = json['data'];
    statusCode = json['statusCode'];
  }

  String getMensagens() {
    String msg = "";
    if (messages != null) {
      for (var m in messages!) {
        if (msg.isNotEmpty) {
          msg += "\n";
        }
        msg += m;
      }
    }

    if (message != null) {
      msg += message!;
    }
    return msg;
  }
}
