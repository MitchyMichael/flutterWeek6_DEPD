part of 'services.dart';

class MasterDataService {
  // Province ------------------------------------------------------
  static Future<List<Province>> getProvince() async {
    var respose = await http.get(
      Uri.https(Const.baseUrl, "/starter/province"),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'key': Const.apiKey,
      },
    );

    var job = json.decode(respose.body);

    List<Province> result = [];
    if (respose.statusCode == 200) {
      result = (job['rajaongkir']['results'] as List)
          .map((e) => Province.fromJson(e))
          .toList();
    }
    return result;
  }

  // City -----------------------------------------------------
  static Future<List<City>> getCity(var provId) async {
    var respose = await http.get(
      Uri.https(Const.baseUrl, "/starter/city"),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'key': Const.apiKey,
      },
    );

    var job = json.decode(respose.body);

    List<City> result = [];
    if (respose.statusCode == 200) {
      result = (job['rajaongkir']['results'] as List)
          .map((e) => City.fromJson(e))
          .toList();
    }

    List<City> selectedCity = [];

    for (var c in result){
      if (c.provinceId == provId){
        selectedCity.add(c);
      }
    }
    
    return selectedCity;
  }
}
