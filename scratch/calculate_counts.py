import urllib.request
import json
import os

os.makedirs("scratch", exist_ok=True)

if not os.path.exists("scratch/cities.json"):
    print("Downloading cities.json...")
    urllib.request.urlretrieve("https://github.com/dr5hn/countries-states-cities-database/raw/master/json/cities.json", "scratch/cities.json")
    print("cities.json downloaded.")

if not os.path.exists("scratch/countries.json"):
    print("Downloading countries.json...")
    urllib.request.urlretrieve("https://github.com/dr5hn/countries-states-cities-database/raw/master/json/countries.json", "scratch/countries.json")

if not os.path.exists("scratch/states.json"):
    print("Downloading states.json...")
    urllib.request.urlretrieve("https://github.com/dr5hn/countries-states-cities-database/raw/master/json/states.json", "scratch/states.json")

with open("scratch/countries.json", "r", encoding="utf-8") as f:
    countries = json.load(f)
with open("scratch/states.json", "r", encoding="utf-8") as f:
    states = json.load(f)
with open("scratch/cities.json", "r", encoding="utf-8") as f:
    cities = json.load(f)

print(f"Total countries: {len(countries)}")
print(f"Total states: {len(states)}")
print(f"Total cities: {len(cities)}")

target_countries = {"IN", "PT", "US", "GB", "AE", "SA", "MY", "SG", "AU", "CA"}

selected_cities = []
cities_by_state = {}

for city in cities:
    cc = city.get("country_code")
    sc = city.get("state_code")
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
