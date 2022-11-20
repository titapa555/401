import 'dart:convert';

import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'package:http/http.dart' as http;

import 'location.dart';
import 'weather.dart';

Future<Weather> forecast() async {
  const url = 'https://data.tmd.go.th/nwpapi/v1/forecast/location/hourly/at';
  const token = 'eyJ0eXAiOiJKV1QiLCJhbGciOiJSUzI1NiIsImp0aSI6Ijk4NmIwMGM0ODIxMzI0MmNhYzk2NDA1MTk1ZjM2NmRjNzU5MjRiZTUwMDM2ODk1NTBkODhmYWYxZTNkNjkwMGJmNTFiMDdhN2FmM2E4YjgwIn0.eyJhdWQiOiIyIiwianRpIjoiOTg2YjAwYzQ4MjEzMjQyY2FjOTY0MDUxOTVmMzY2ZGM3NTkyNGJlNTAwMzY4OTU1MGQ4OGZhZjFlM2Q2OTAwYmY1MWIwN2E3YWYzYThiODAiLCJpYXQiOjE2Njg5MzM1MDcsIm5iZiI6MTY2ODkzMzUwNywiZXhwIjoxNzAwNDY5NTA3LCJzdWIiOiIyMjc1Iiwic2NvcGVzIjpbXX0.Huqy74-W1a0jkp01j3A_lsnW_nUYHl4xIJSFpoac0RJ3NG5TJ6oPRxjbPhfysSTkr_ONmTxB_qZ8d3PXI1rndsQvb-3xVaOsleVyq3DwdlchttCxcyC2aajscL_8m0mvz5r1WOYjP793km0HSiY9bQzN65LxkF4bSU2Rde35foQGkV8tI-asRO_nX4N6LGhDXEOfoz8hC_Cj2nv4qoFRcNjkZDecHzxADKxwai6DqeYLSx_rgyVYosoPGyoVH1YwxUCyJ5KE_6HdcKR4Le8MSskJlprNIeyg8ZUmApg2o1vj7nQEBVTtAcRZw6YQTNUJ3IOYIAK49XAI0SB9YmItxAUiH_cqA3LLyC5qs_-A_Koc8mbdtqM2QeuVScMBTp2RbI4HYDDhXNhOpanStxHE2pEZxWo_m7ZLLXa5N360repPz1cdeZhloXby5AlmeOV35_9svV2Lxeh1r8GkRDUhnPk-HMy6ROlBxq57fV6P5iRvEKori5bo9LEy59qUcHRRZxNiPIdwY4bzpCx18g_G1qWgsLX9CVuSPt-tvyTpYdqger3cY7p6ctK_5gzEPOEUI_PLBd-NbPTJ78kCcuHsfVrQzvGLBZu26KZGv61pCwR_r9CehvZi5oxYvQVdVoIch6vLL3lAdjohhifz3J0SlzGCSlK0mLZW_3QRujiQ9Dw';

  try {
  Position location = await getCurrentLocation();
  http.Response response = await http.get(
    Uri.parse('$url?lat=${location.latitude}&lon=${location.longitude}&fields=tc,cond'), 
    headers: {
      'accept': 'application/json',
      'authorization': 'Bearer $token',
    }
);
    if(response.statusCode == 200) {
      var result = jsonDecode(response.body)['WeatherForecasts'][0]['forecasts'][0]['data'];
      Placemark address = (await placemarkFromCoordinates(location.latitude, location.longitude)).first;
      return Weather(
        address: '${address.subLocality}\n${address.administrativeArea}',
        temperature: result['tc'],
        cond: result['cond'],
      );
    } else {
      return Future.error(response.statusCode);
    }
  } catch (e) {
    return Future.error(e);
  }
}