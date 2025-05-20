import 'package:RESALATY/constants.dart';

class Message {
  final String message;
  final String from;
  final String to;

  Message(this.message, this.from, this.to);

  factory Message.fromJeson(Map<String, dynamic> jsonData) {
    return Message(
      jsonData[kmessage] ?? '',
      jsonData['from'] ?? '',
      jsonData['to'] ?? '',
    );
  }
}
