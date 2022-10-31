import 'dart:io';

import 'package:part1/part1.dart';
import 'package:test/test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:http/http.dart' as http;
import 'part1_test.mocks.dart';

// dart run build_runner build
@GenerateMocks([http.Client, MyReadLine])
void main() {
  group('fetchStation', () {
    const GET_ALL_STATIONS = "https://staging.revolvair.org/api/revolvair/stations/";

    test("Returns stations data list if the http call completes successfully", () async {
      final client = MockClient();
   
      when(client
        .get(Uri.parse(GET_ALL_STATIONS)))
        .thenAnswer((_) async =>
          http.Response('{ "data": [{"id": 0,"slug": "string","description": "string","lat": 0,"long": 0,"activate": 0,"outdoor": 0,"comment_count": 0,"alert_count": 0,"measure_count": 0,"user_id": 0}, {"id": 1,"slug": "string2","description": "string2","lat": 0,"long": 0,"activate": 0,"outdoor": 0,"comment_count": 0,"alert_count": 0,"measure_count": 0,"user_id": 1}]}', 200));

      expect(await fetchStation(client, GET_ALL_STATIONS), isA<List<Station>>());
    });

    test("Returns stations datas with error", () async {
      final client = MockClient();

      when(client
        .get(Uri.parse(GET_ALL_STATIONS)))
        .thenAnswer((_) async => http.Response('Not Found', 404));

      expect(fetchStation(client, GET_ALL_STATIONS), throwsException);
    });
  });
}
