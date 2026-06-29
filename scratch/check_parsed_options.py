import re

with open('lib/features/profile/models/edit_profile_options.dart', 'r', encoding='utf-8') as f:
    content = f.read()

def parse_dart_list(file_content, var_name):
    pattern = rf"(?:static\s+(?:const\s+)?List<String>|static\s+const\s+List<String>)\s+{var_name}\s*=\s*\[(.*?)\];"
    match = re.search(pattern, file_content, re.DOTALL)
    if not match:
        return None
    items_str = match.group(1)
    items = re.findall(r"'(.*?)'|\"(.*?)\"", items_str)
    res = [i[0] if i[0] else i[1] for i in items]
    return [r for r in res if r.strip()]

for name in ['employmentTypes', 'occupations', 'motherTongues']:
    result = parse_dart_list(content, name)
    print(f'{name}: {result}')
