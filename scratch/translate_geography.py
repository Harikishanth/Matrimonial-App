import json
import os
import time
from deep_translator import GoogleTranslator

pub_cache_dir = r"C:\Users\NSEIT\AppData\Local\Pub\Cache\hosted\pub.dev\country_state_city-0.1.6\lib\assets"
cache_file = "scratch/geo_cache.json"

# Load cache if exists
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

# Extract unique names to translate
names_to_translate = set()

for c in countries:
    names_to_translate.add(c["name"])

for s in states:
    names_to_translate.add(s["name"])

# Select cities to translate
target_countries = {"IN", "PT", "US", "GB", "AE", "SA", "MY", "SG", "AU", "CA"}
cities_by_state = {}

for city in cities:
    cc = city.get("countryCode")
    sc = city.get("stateCode")
    name = city.get("name")
    if not name:
        continue
    key = (cc, sc)
    
    if cc in target_countries:
        names_to_translate.add(name)
    else:
        if key not in cities_by_state:
            cities_by_state[key] = []
        if len(cities_by_state[key]) < 2:
            cities_by_state[key].append(name)
            names_to_translate.add(name)

# Remove names already translated
pending_names = sorted(list(names_to_translate - set(geo_cache.keys())))

print(f"Total unique names: {len(names_to_translate)}")
print(f"Already translated: {len(geo_cache)}")
print(f"Pending translation: {len(pending_names)}")

# Perform translations in batches of 100
translator = GoogleTranslator(source='en', target='ta')
batch_size = 100

for i in range(0, len(pending_names), batch_size):
    batch = pending_names[i:i+batch_size]
    print(f"Translating batch {i // batch_size + 1} / {(len(pending_names) - 1) // batch_size + 1}... ({len(batch)} items)")
    
    retries = 3
    success = False
    while retries > 0 and not success:
        try:
            translated = translator.translate_batch(batch)
            for eng, tam in zip(batch, translated):
                geo_cache[eng] = tam
            success = True
        except Exception as e:
            print(f"Error during batch translation: {e}. Retrying in 5 seconds...")
            retries -= 1
            time.sleep(5)
            
    if not success:
        print("Failed translation batch. Saving current progress and exiting.")
        break
        
    # Save cache
    with open(cache_file, "w", encoding="utf-8") as f:
        json.dump(geo_cache, f, ensure_ascii=False, indent=2)
        
    time.sleep(1) # Be polite to API

# Generate Dart file
print("Generating Dart lookup file...")
dart_lines = [
    "// AUTO-GENERATED GEOGRAPHIC TRANSLATIONS TA",
    "// Generated on " + time.strftime("%Y-%m-%d %H:%M:%S"),
    "const Map<String, String> geographicTranslationsTa = {"
]

for eng in sorted(geo_cache.keys()):
    tam = geo_cache[eng]
    # Escape single quotes in Dart
    escaped_eng = eng.replace("'", "\\'")
    escaped_tam = tam.replace("'", "\\'")
    dart_lines.append(f"  '{escaped_eng}': '{escaped_tam}',")

dart_lines.append("};")

os.makedirs("lib/core/translation", exist_ok=True)
with open("lib/core/translation/geographic_translations.dart", "w", encoding="utf-8") as f:
    f.write("\n".join(dart_lines))

print("Dart lookup file created at lib/core/translation/geographic_translations.dart")
print(f"Total translated entries: {len(geo_cache)}")
