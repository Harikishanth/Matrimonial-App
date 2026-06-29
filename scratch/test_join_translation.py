from deep_translator import GoogleTranslator
import time

translator = GoogleTranslator(source='en', target='ta')
text_to_translate = "\n".join(["California", "Texas", "New York", "Florida"])

try:
    res = translator.translate(text_to_translate)
    items = res.split("\n")
    print(f"Success! Translated {len(items)} items:")
    for eng, tam in zip(["California", "Texas", "New York", "Florida"], items):
        # Print encoded or safe
        print(f"  {eng} -> ok")
except Exception as e:
    print(f"Failed: {e}")
