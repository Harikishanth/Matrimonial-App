import json
import os
import time
import urllib.request
import urllib.parse

pub_cache_dir = r"C:\Users\NSEIT\AppData\Local\Pub\Cache\hosted\pub.dev\country_state_city-0.1.6\lib\assets"
cache_file = "scratch/geo_cache_fast.json"

if os.path.exists(cache_file):
    with open(cache_file, "r", encoding="utf-8") as f:
        geo_cache = json.load(f)
else:
    geo_cache = {}

with open(f"{pub_cache_dir}/country.json", "r", encoding="utf-8") as f:
    countries = json.load(f)
with open(f"{pub_cache_dir}/state.json", "r", encoding="utf-8") as f:
    states = json.load(f)
with open(f"{pub_cache_dir}/city.json", "r", encoding="utf-8") as f:
    cities = json.load(f)

# Countries to get all states/cities
target_countries = {"IN", "PT", "LK", "US", "GB", "AE", "SA", "MY", "SG", "AU", "CA"}

names_to_translate = set()

# 1. Add all country names
for c in countries:
    names_to_translate.add(c["name"])

# 2. Add states for target countries
for s in states:
    cc = s["countryCode"]
    if cc in target_countries:
        names_to_translate.add(s["name"])

# 3. Add cities
cities_by_state = {}
for city in cities:
    cc = city["countryCode"]
    sc = city["stateCode"]
    key = (cc, sc)
    if key not in cities_by_state:
        cities_by_state[key] = []
    cities_by_state[key].append(city["name"])

for (cc, sc), city_list in cities_by_state.items():
    if cc == "IN":
        # Keep first 200 cities for India
        for name in city_list[:200]:
            names_to_translate.add(name)
    elif cc == "PT":
        # Keep all cities for Portugal
        for name in city_list:
            names_to_translate.add(name)
    elif cc == "LK":
        # Keep first 50 cities for Sri Lanka
        for name in city_list[:50]:
            names_to_translate.add(name)
    elif cc in target_countries:
        # Keep top 5 cities per state for other target countries
        for name in city_list[:5]:
            names_to_translate.add(name)
    else:
        # Keep top 1 city per state for rest of the world
        for name in city_list[:1]:
            names_to_translate.add(name)

pending_names = sorted(list(names_to_translate - set(geo_cache.keys())))

print(f"Total unique names: {len(names_to_translate)}")
print(f"Already translated: {len(geo_cache)}")
print(f"Pending translation: {len(pending_names)}")

def translate_ta(text):
    url = "https://translate.googleapis.com/translate_a/single?client=gtx&sl=en&tl=ta&dt=t&q=" + urllib.parse.quote(text)
    req = urllib.request.Request(
        url, 
        headers={'User-Agent': 'Mozilla/5.0 (Windows NT 10.0; Win64; x64)'}
    )
    with urllib.request.urlopen(req, timeout=10) as response:
        data = json.loads(response.read().decode('utf-8'))
        translated = "".join([part[0] for part in data[0] if part[0]])
        return translated

# Translate
if pending_names:
    batch_size = 50
    for i in range(0, len(pending_names), batch_size):
        batch = pending_names[i:i+batch_size]
        print(f"Translating batch {i // batch_size + 1} / {(len(pending_names) - 1) // batch_size + 1}... ({len(batch)} items)")
        
        joined_text = "\n".join(batch)
        retries = 3
        success = False
        while retries > 0 and not success:
            try:
                res = translate_ta(joined_text)
                translated_items = res.split("\n")
                if len(translated_items) == len(batch):
                    for eng, tam in zip(batch, translated_items):
                        geo_cache[eng] = tam.strip()
                    success = True
                else:
                    print(f"Mismatched line count: got {len(translated_items)}, expected {len(batch)}. Retrying individually for this batch...")
                    for item in batch:
                        try:
                            geo_cache[item] = translate_ta(item).strip()
                            time.sleep(0.2)
                        except Exception as e2:
                            print(f"Failed to translate {item}: {e2}")
                            geo_cache[item] = item
                    success = True
            except Exception as e:
                print(f"Error: {e}. Retrying in 3 seconds...")
                retries -= 1
                time.sleep(3)
                
        if not success:
            print("Batch failed. Exiting.")
            break
            
        with open(cache_file, "w", encoding="utf-8") as f:
            json.dump(geo_cache, f, ensure_ascii=False, indent=2)
            
        time.sleep(0.5)

# Generate Dart file
print("Generating Dart file...")
dart_lines = [
    "// AUTO-GENERATED GEOGRAPHIC TRANSLATIONS TA",
    "// Generated on " + time.strftime("%Y-%m-%d %H:%M:%S"),
    "const Map<String, String> geographicTranslationsTa = {"
]

for eng in sorted(geo_cache.keys()):
    tam = geo_cache[eng]
    if not tam:
        continue
    escaped_eng = eng.replace("'", "\\'")
    escaped_tam = tam.replace("'", "\\'")
    dart_lines.append(f"  '{escaped_eng}': '{escaped_tam}',")

dart_lines.append("};")

os.makedirs("lib/core/translation", exist_ok=True)
with open("lib/core/translation/geographic_translations.dart", "w", encoding="utf-8") as f:
    f.write("\n".join(dart_lines))

print("Geographic translations Dart file generated successfully!")
print(f"Total entries: {len(geo_cache)}")
