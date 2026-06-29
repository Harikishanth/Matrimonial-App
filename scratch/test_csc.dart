import 'package:country_state_city/country_state_city.dart' as csc;

void main() async {
  print('Loading countries...');
  final countries = await csc.getAllCountries();
  print('Loaded ${countries.length} countries.');
  
  if (countries.isNotEmpty) {
    final first = countries.first;
    print('First country: ${first.name} (${first.isoCode})');
    
    print('Loading states for ${first.name}...');
    final states = await csc.getStatesOfCountry(first.isoCode);
    print('Loaded ${states.length} states.');
  }
}
