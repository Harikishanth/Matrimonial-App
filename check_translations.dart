import 'dart:io';
import 'package:flutter/foundation.dart';
import 'lib/features/profile/models/edit_profile_options.dart';
import 'lib/core/translation/option_translations.dart';

void main() {
  print("=== STARTING TRANSLATION CHECK ===");
  final missing = <String, List<String>>{};

  void checkList(String name, List<String> list) {
    final listMissing = <String>[];
    for (final item in list) {
      if (item == "Doesn't Matter" || item == "Doesn't matter" || item == "Other" || item == "None" || item == "Yes" || item == "No" || item == "Occasionally") {
        continue;
      }
      // Check if item has translation
      final translated = translateOption(item, 'ta');
      if (translated == item) {
        listMissing.add(item);
      }
    }
    if (listMissing.isNotEmpty) {
      missing[name] = listMissing;
    }
  }

  checkList('maritalStatuses', EditProfileOptions.maritalStatuses);
  checkList('physicalStatuses', EditProfileOptions.physicalStatuses);
  checkList('bodyTypes', EditProfileOptions.bodyTypes);
  checkList('motherTongues', EditProfileOptions.motherTongues);
  checkList('eatingHabits', EditProfileOptions.eatingHabits);
  checkList('drinkingHabits', EditProfileOptions.drinkingHabits);
  checkList('smokingHabits', EditProfileOptions.smokingHabits);
  checkList('religions', EditProfileOptions.religions);
  checkList('qualifications', EditProfileOptions.qualifications);
  checkList('pgDegrees', EditProfileOptions.pgDegrees);
  checkList('ugDegrees', EditProfileOptions.ugDegrees);
  checkList('schoolingBoards', EditProfileOptions.schoolingBoards);
  checkList('employmentTypes', EditProfileOptions.employmentTypes);
  checkList('occupations', EditProfileOptions.occupations);
  checkList('annualIncomes', EditProfileOptions.annualIncomes);
  checkList('allCountries', EditProfileOptions.allCountries);
  checkList('states', EditProfileOptions.states);
  checkList('cities', EditProfileOptions.cities);
  checkList('citizenships', EditProfileOptions.citizenships);
  checkList('familyValuesList', EditProfileOptions.familyValuesList);
  checkList('familyTypes', EditProfileOptions.familyTypes);
  checkList('familyStatusList', EditProfileOptions.familyStatusList);
  checkList('hobbies', EditProfileOptions.hobbies);

  if (missing.isEmpty) {
    print("ALL OK! No missing translations.");
  } else {
    missing.forEach((category, items) {
      print("\nMissing in $category (${items.length} items):");
      for (final item in items) {
        print("  - '$item'");
      }
    });
  }
  print("=== TRANSLATION CHECK COMPLETE ===");
}
