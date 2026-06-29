import 'package:country_state_city/country_state_city.dart' as csc;

class GeographicHelper {
  static List<csc.Country>? _countries;
  static List<csc.State>? _states;
  static List<csc.City>? _cities;

  static Future<List<csc.Country>> getAllCountries() async {
    if (_countries != null) return _countries!;
    _countries = await csc.getAllCountries();
    _countries!.sort((a, b) => a.name.compareTo(b.name));
    return _countries!;
  }

  static Future<List<csc.State>> getAllStates() async {
    if (_states != null) return _states!;
    _states = await csc.getAllStates();
    _states!.sort((a, b) => a.name.compareTo(b.name));
    return _states!;
  }

  static Future<List<csc.City>> getAllCities() async {
    if (_cities != null) return _cities!;
    _cities = await csc.getAllCities();
    _cities!.sort((a, b) => a.name.compareTo(b.name));
    return _cities!;
  }

  static Future<List<csc.State>> getStatesOfCountry(String countryCode) async {
    final all = await getAllStates();
    return all.where((s) => s.countryCode == countryCode).toList();
  }

  static Future<List<csc.City>> getStateCities(String countryCode, String stateCode) async {
    final all = await getAllCities();
    return all.where((c) => c.countryCode == countryCode && c.stateCode == stateCode).toList();
  }

  static Future<List<csc.City>> getCountryCities(String countryCode) async {
    final all = await getAllCities();
    return all.where((c) => c.countryCode == countryCode).toList();
  }
}
