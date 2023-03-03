import 'dart:async';
import 'package:air_quality/data/model/api/thingspeak.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;

abstract class ThingSpeakService {
  Future<ThingSpeakData?> getLastReading();
  Stream<ThingSpeakData?> getStream();
}

class ThingSpeakServiceImpl implements ThingSpeakService {

  @override
  Future<ThingSpeakData?> getLastReading() async{
    try {
      final uri = Uri.parse('https://thingspeak.com/channels/1781959/fields/1/last.json?api_key=Z0ZAXSB9WS8D0W16');
      var response = await http.Client().get(uri, headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json'
      }).timeout(const Duration(seconds: 20),
          onTimeout: () => throw TimeoutException(
              'The connection has timed out, Please try again'));
      debugPrint(response.body);
      if (response.statusCode == 200) {
        ThingSpeakData thingSpeakData = thingSpeakDataFromMap(response.body);
        return thingSpeakData;
      } else {
        return null;
      }
    } catch (_) {
      return null;
    }
  }

  @override
  Stream<ThingSpeakData?> getStream() async*{
    while (true){
      ThingSpeakData? thingspeak = await getLastReading();
      yield thingspeak;
    }
  }
}