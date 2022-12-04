
import 'dart:convert';

import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'package:http/http.dart' as http;

import 'location.dart';
import 'weather.dart';

Future<Weather> forecast() async {
  const url = 'https://data.tmd.go.th/nwpapi/v1/forecast/location/hourly/at';
const token = 'eyJ0eXAiOiJKV1QiLCJhbGciOiJSUzI1NiIsImp0aSI6ImJhMTZmZjIyNzEwY2IwYzJiMzFiMTdhYzRmMmFjNGEwZjEzOGM1ZjNiMDllNmFmNGJiNGJmNjcwZTJkZDhjODY4ZjBiY2JiNTFiNDNkM2E2In0.eyJhdWQiOiIyIiwianRpIjoiYmExNmZmMjI3MTBjYjBjMmIzMWIxN2FjNGYyYWM0YTBmMTM4YzVmM2IwOWU2YWY0YmI0YmY2NzBlMmRkOGM4NjhmMGJjYmI1MWI0M2QzYTYiLCJpYXQiOjE2Njg5MzM1MDgsIm5iZiI6MTY2ODkzMzUwOCwiZXhwIjoxNzAwNDY5NTA4LCJzdWIiOiIyMjgxIiwic2NvcGVzIjpbXX0.uep3bYJ-v26k-eptenuLhk8hUC226bvCCjKWWTJLWuzWCvPkaxadcrA3LDNq5al4Yuf9LAfmKWiJOSK4xkm9RsQw5N68bNACD-BfvdS1toG0CfmLn8JATEBrH9h2eumCvOFqe_EFxyPpa51OBJlQ_fdfusMj9epTPRJ1zJdNOfSToSVHgzrPCXJie-Ywedtp1UJPTEJ--I6hK6YbFDMIwJDmnH61TANYVYW8orRxjT0KHelWIn-lTa0zA72S03PJFfBTyiprN_jEvlHYKlZS6KyrK5L19nt3in0Y-WJ3QO7G-8I_ynhtxeGwtqQRQe8jCkvy5iXXzGDK7SnGrfExV7fAvEkDHsiQpAANMjWsCk8nbdHqPdwO6VlJbeGmhZmK9djJB1NFhBdMeghtwGnxhJ2ksgx-LuTBPVKIraWP3DFUWwe0IRmHXfXGGbIB05IncOb12rFQXCw_KfO4IRIDDKDRbzhr7-dxDlYK55KUoGqPN7kUjT_WYvj6BpqCdi2hTI5LHu-Efgo8ySVO8BBRIJiTVHNDLKt69RvY3BKJiP-sSrso71MH6PfTxZnekveqJeMqTZQ1VyZ4SHWWByNLSNU6nGj6G19-l6kpF641Y4ybYF7XSPEOzaP1nQDWNXDTtxDHpSkrl72GwEa3BjSKjlGZNcLNAm-Czo3xssb0CRo';
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