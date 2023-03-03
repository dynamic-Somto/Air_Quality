import 'dart:convert';

ThingSpeakData thingSpeakDataFromMap(String str) => ThingSpeakData.fromMap(json.decode(str));

class ThingSpeakData {
  ThingSpeakData({
    required this.createdAt,
    required this.entryId,
  });

  DateTime createdAt;
  int entryId;

  factory ThingSpeakData.fromMap(Map<String, dynamic> json) => ThingSpeakData(
    createdAt: DateTime.parse(json['created_at']??DateTime.now().toIso8601String()),
    entryId: json['entry_id']??0,
  );
}
