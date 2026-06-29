from deep_translator import GoogleTranslator

translator = GoogleTranslator(source='en', target='ta')
res = translator.translate("California")
print(f"Translation: {res}")

res_batch = translator.translate_batch(["California", "Texas", "New York"])
print(f"Batch: {res_batch}")
