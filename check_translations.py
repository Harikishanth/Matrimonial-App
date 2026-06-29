import re

def parse_dart_list(file_content, var_name):
    pattern = rf"(?:static\s+(?:const\s+)?List<String>|static\s+const\s+List<String>)\s+{var_name}\s*=\s*\[(.*?)\];"
    match = re.search(pattern, file_content, re.DOTALL)
    if not match:
        pattern2 = rf"(?:const\s+|List<String>\s+)?(?:List<String>)?\s*{var_name}\s*=\s*\[(.*?)\];"
        match = re.search(pattern2, file_content, re.DOTALL)
        if not match:
            return []
    items_str = match.group(1)
    items = re.findall(r"'(.*?)'|\"(.*?)\"", items_str)
    res = [i[0] if i[0] else i[1] for i in items]
    return [r for r in res if r.strip()]

def main():
    with open("lib/features/profile/models/edit_profile_options.dart", "r", encoding="utf-8") as f:
        options_content = f.read()

    with open("lib/core/translation/option_translations.dart", "r", encoding="utf-8") as f:
        trans_content = f.read()

    # Strip comments first
    trans_content_no_comments = re.sub(r"//.*", "", trans_content)

    map_match = re.search(r"const\s+Map<String,\s*String>\s+optionTranslationsTa\s*=\s*\{(.*?)\};", trans_content_no_comments, re.DOTALL)
    trans_map = {}
    if map_match:
        lines = map_match.group(1).split(",")
        for line in lines:
            line = line.strip()
            if not line:
                continue
            match = re.match(r"['\"](.*?)['\"]\s*:\s*['\"](.*?)['\"]", line)
            if match:
                trans_map[match.group(1)] = match.group(2)
            else:
                # Try handling escaped quotes or double quotes
                match2 = re.match(r"['\"](.*?)['\"]\s*:\s*\"(.*?)\"", line)
                if match2:
                    trans_map[match2.group(1)] = match2.group(2)

    print(f"Loaded {len(trans_map)} keys from optionTranslationsTa map.")

    lists_to_check = [
        'maritalStatuses', 'physicalStatuses', 'bodyTypes',
        'motherTongues', 'eatingHabits', 'drinkingHabits', 'smokingHabits',
        'religions', '_hinduCastes', '_muslimCastes',
        '_christianCastes', '_sikhCastes', '_jainCastes', '_buddhistCastes',
        'doshams', 'doshamTypes', 'gothrams', 'raasis', 'stars', 'qualifications',
        'pgDegrees', 'ugDegrees', 'schoolingBoards', 'employmentTypes', 'occupations',
        'annualIncomes', 'allCountries', 'states', 'cities', 'citizenships',
        'familyValuesList', 'familyTypes', 'familyStatusList', 'hobbies'
    ]

    all_missing = 0
    for name in lists_to_check:
        items = parse_dart_list(options_content, name)
        missing = []
        for item in items:
            if item in ["Doesn't Matter", "Doesn't matter", "Other", "None", "Yes", "No", "Occasionally", "Any Caste", "Caste No Bar"]:
                continue
            # Also strip single quotes escapes in item name if any
            clean_item = item.replace("\\'", "'")
            if clean_item not in trans_map:
                missing.append(item)
        if missing:
            all_missing += len(missing)
            print(f"Missing in {name} ({len(missing)} items):")
            for m in missing:
                print(f"  - '{m}'")

    print(f"Total missing translation keys: {all_missing}")

if __name__ == "__main__":
    main()
