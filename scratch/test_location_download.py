import urllib.request
import json
import os

os.makedirs("scratch", exist_ok=True)

print("Downloading countries.json...")
urllib.request.urlretrieve("https://github.com/dr5hn/countries-states-cities-database/raw/master/json/countries.json", "scratch/countries.json")

print("Downloading states.json...")
urllib.request.urlretrieve("https://github.com/dr5hn/countries-states-cities-database/raw/master/json/states.json", "scratch/states.json")

print("Files downloaded successfully.")
with open("scratch/countries.json", "r", encoding="utf-8") as f:
    countries = json.load(f)
print(f"Loaded {len(countries)} countries.")

with open("scratch/states.json", "r", encoding="utf-8") as f:
    states = json.load(f)
print(f"Loaded {len(states)} states.")
