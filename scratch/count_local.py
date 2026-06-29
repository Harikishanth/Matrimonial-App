import json

pub_cache_dir = r"C:\Users\NSEIT\AppData\Local\Pub\Cache\hosted\pub.dev\country_state_city-0.1.6\lib\assets"

with open(f"{pub_cache_dir}/country.json", "r", encoding="utf-8") as f:
    countries = json.load(f)
with open(f"{pub_cache_dir}/state.json", "r", encoding="utf-8") as f:
    states = json.load(f)
with open(f"{pub_cache_dir}/city.json", "r", encoding="utf-8") as f:
    cities = json.load(f)

print(f"Total countries: {len(countries)}")
print(f"Total states: {len(states)}")
print(f"Total cities: {len(cities)}")

target_countries = {"IN", "PT", "US", "GB", "AE", "SA", "MY", "SG", "AU", "CA"}

selected_cities = []
cities_by_state = {}

for city in cities:
    cc = city.get("countryCode")
    sc = city.get("stateCode")
    key = (cc, sc)
    if cc in target_countries:
        selected_cities.append(city)
    else:
        if key not in cities_by_state:
            cities_by_state[key] = []
        if len(cities_by_state[key]) < 3:
            cities_by_state[key].append(city)
            selected_cities.append(city)

print(f"Selected cities count: {len(selected_cities)}")
