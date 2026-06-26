import 'dart:convert';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

class OnboardingState {
  final String langCode; // 'en' or 'ta'
  final int currentStep;
  final String? profileFor;
  final String? firstName;
  final String? middleName;
  final String? lastName;
  final String? gender;
  final String? dob; // YYYY-MM-DD
  final bool horoscopeConsent;
  final String? religion;
  final String? caste;
  final bool casteNoBar;
  final String? subcaste;
  final String? dosham; // 'yes', 'no', 'none'
  final String? qualification;
  final String? institution;
  final String? yearCompleted;
  // Detailed Education fields
  final String? doctorateSpecialization;
  final String? doctorateUniversity;
  final String? doctorateYear;
  final String? pgDegree;
  final String? pgSpecialization;
  final String? pgInstitution;
  final String? pgYear;
  final String? ugDegree;
  final String? ugMajor;
  final String? ugInstitution;
  final String? ugYear;
  final String? diplomaStream;
  final String? diplomaInstitution;
  final String? diplomaYear;
  final String? schoolingName;
  final String? schoolingBoard;
  final String? schoolingYear;
  final String? preUgType; // 'Schooling' or 'Diploma'
  final String? citizenship;
  final String? country;
  final String? livingSince;
  final String? state;
  final String? city;
  final String? employmentType;
  final String? occupation;
  final String? annualIncome;
  final String? familyStatus;
  final String? familyWealth;
  final String? bio;
  final String? photoPath;
  final String? motherTongue;
  final String? gothram;
  final String? raasi;
  final String? nakshatra;
  
  // Custom Edit Profile Fields
  final String? eatingHabits;
  final String? drinkingHabits;
  final String? smokingHabits;
  final String? bodyType;
  final String? ancestralOrigin;
  final String? familyValues;
  final String? familyType;
  final String? parentsInfo;
  final String? brothers;
  final String? sisters;
  final String? brothersMarried;
  final String? sistersMarried;
  final String? mobileNumber;
  final String? whatsappNumber;
  
  // Physical & Marital Status
  final String? height;
  final String? weight;
  final String? physicalStatus;
  final String? maritalStatus;
  final String? childrenCount;
  
  // Preferences
  final String? preferredGothram;
  final String? preferredRaasi;
  final String? preferredStar;
  final String? preferredDosham;
  final String? preferredMinIncome;

  // Step 10 Partner Preferences
  final int preferredMinAge;
  final int preferredMaxAge;
  final double preferredMinHeight;
  final double preferredMaxHeight;
  final List<String> preferredMaritalStatuses;
  final String? preferredReligion;
  final List<String> preferredCastes;
  final bool preferredCasteNoBar;
  final String? preferredSubcaste;
  final List<String> preferredStars;
  final List<String> preferredQualifications;
  final List<String> preferredOccupations;
  final List<String> preferredEatingHabits;
  final List<String> preferredFoodPreferences;
  final List<String> preferredPhysicalTypes;
  final List<String> preferredFamilyWealths;
  final String? preferredMaxIncome;
  final List<String> preferredSmokingHabits;
  final List<String> preferredDrinkingHabits;

  // Interests and Hobbies
  final List<String> selectedHobbies;
  final List<String> selectedInterests;
  final Map<String, List<String>> selectedSubInterests; // e.g. {'Reading': ['CS Books', 'Novels']}
  final String? trait;

  OnboardingState({
    this.langCode = 'en',
    this.currentStep = 1,
    this.profileFor,
    this.firstName,
    this.middleName,
    this.lastName,
    this.gender,
    this.dob,
    this.horoscopeConsent = false,
    this.religion,
    this.caste,
    this.casteNoBar = false,
    this.subcaste,
    this.dosham = 'none',
    this.qualification,
    this.institution,
    this.yearCompleted,
    this.doctorateSpecialization,
    this.doctorateUniversity,
    this.doctorateYear,
    this.pgDegree,
    this.pgSpecialization,
    this.pgInstitution,
    this.pgYear,
    this.ugDegree,
    this.ugMajor,
    this.ugInstitution,
    this.ugYear,
    this.diplomaStream,
    this.diplomaInstitution,
    this.diplomaYear,
    this.schoolingName,
    this.schoolingBoard,
    this.schoolingYear,
    this.preUgType,
    this.citizenship,
    this.country,
    this.livingSince,
    this.state,
    this.city,
    this.employmentType,
    this.occupation,
    this.annualIncome,
    this.familyStatus,
    this.familyWealth,
    this.bio,
    this.photoPath,
    this.motherTongue,
    this.gothram,
    this.raasi,
    this.nakshatra,
    this.eatingHabits,
    this.drinkingHabits,
    this.smokingHabits,
    this.bodyType,
    this.ancestralOrigin,
    this.familyValues,
    this.familyType,
    this.parentsInfo,
    this.brothers,
    this.sisters,
    this.brothersMarried,
    this.sistersMarried,
    this.mobileNumber,
    this.whatsappNumber,
    this.height,
    this.weight,
    this.physicalStatus,
    this.maritalStatus,
    this.childrenCount,
    this.preferredGothram,
    this.preferredRaasi,
    this.preferredStar,
    this.preferredDosham,
    this.preferredMinIncome,
    // Partner Preference Defaults
    this.preferredMinAge = 21,
    this.preferredMaxAge = 35,
    this.preferredMinHeight = 5.0,
    this.preferredMaxHeight = 6.5,
    this.preferredMaritalStatuses = const [],
    this.preferredReligion,
    this.preferredCastes = const [],
    this.preferredCasteNoBar = false,
    this.preferredSubcaste,
    this.preferredStars = const [],
    this.preferredQualifications = const [],
    this.preferredOccupations = const [],
    this.preferredEatingHabits = const [],
    this.preferredFoodPreferences = const [],
    this.preferredPhysicalTypes = const [],
    this.preferredFamilyWealths = const [],
    this.preferredMaxIncome,
    this.preferredSmokingHabits = const [],
    this.preferredDrinkingHabits = const [],
    this.selectedHobbies = const [],
    this.selectedInterests = const [],
    this.selectedSubInterests = const {},
    this.trait,
  });

  OnboardingState copyWith({
    String? langCode,
    int? currentStep,
    String? profileFor,
    String? firstName,
    String? middleName,
    String? lastName,
    String? gender,
    String? dob,
    bool? horoscopeConsent,
    String? religion,
    String? caste,
    bool? casteNoBar,
    String? subcaste,
    String? dosham,
    String? qualification,
    String? institution,
    String? yearCompleted,
    String? doctorateSpecialization,
    String? doctorateUniversity,
    String? doctorateYear,
    String? pgDegree,
    String? pgSpecialization,
    String? pgInstitution,
    String? pgYear,
    String? ugDegree,
    String? ugMajor,
    String? ugInstitution,
    String? ugYear,
    String? diplomaStream,
    String? diplomaInstitution,
    String? diplomaYear,
    String? schoolingName,
    String? schoolingBoard,
    String? schoolingYear,
    String? preUgType,
    String? citizenship,
    String? country,
    String? livingSince,
    String? state,
    String? city,
    String? employmentType,
    String? occupation,
    String? annualIncome,
    String? familyStatus,
    String? familyWealth,
    String? bio,
    String? photoPath,
    String? motherTongue,
    String? gothram,
    String? raasi,
    String? nakshatra,
    String? eatingHabits,
    String? drinkingHabits,
    String? smokingHabits,
    String? bodyType,
    String? ancestralOrigin,
    String? familyValues,
    String? familyType,
    String? parentsInfo,
    String? brothers,
    String? sisters,
    String? brothersMarried,
    String? sistersMarried,
    String? mobileNumber,
    String? whatsappNumber,
    String? height,
    String? weight,
    String? physicalStatus,
    String? maritalStatus,
    String? childrenCount,
    String? preferredGothram,
    String? preferredRaasi,
    String? preferredStar,
    String? preferredDosham,
    String? preferredMinIncome,
    // Step 10 Preferences
    int? preferredMinAge,
    int? preferredMaxAge,
    double? preferredMinHeight,
    double? preferredMaxHeight,
    List<String>? preferredMaritalStatuses,
    String? preferredReligion,
    List<String>? preferredCastes,
    bool? preferredCasteNoBar,
    String? preferredSubcaste,
    List<String>? preferredStars,
    List<String>? preferredQualifications,
    List<String>? preferredOccupations,
    List<String>? preferredEatingHabits,
    List<String>? preferredFoodPreferences,
    List<String>? preferredPhysicalTypes,
    List<String>? preferredFamilyWealths,
    String? preferredMaxIncome,
    List<String>? preferredSmokingHabits,
    List<String>? preferredDrinkingHabits,
    List<String>? selectedHobbies,
    List<String>? selectedInterests,
    Map<String, List<String>>? selectedSubInterests,
    String? trait,
  }) {
    return OnboardingState(
      langCode: langCode ?? this.langCode,
      currentStep: currentStep ?? this.currentStep,
      profileFor: profileFor ?? this.profileFor,
      firstName: firstName ?? this.firstName,
      middleName: middleName ?? this.middleName,
      lastName: lastName ?? this.lastName,
      gender: gender ?? this.gender,
      dob: dob ?? this.dob,
      horoscopeConsent: horoscopeConsent ?? this.horoscopeConsent,
      religion: religion ?? this.religion,
      caste: caste ?? this.caste,
      casteNoBar: casteNoBar ?? this.casteNoBar,
      subcaste: subcaste ?? this.subcaste,
      dosham: dosham ?? this.dosham,
      qualification: qualification ?? this.qualification,
      institution: institution ?? this.institution,
      yearCompleted: yearCompleted ?? this.yearCompleted,
      doctorateSpecialization: doctorateSpecialization ?? this.doctorateSpecialization,
      doctorateUniversity: doctorateUniversity ?? this.doctorateUniversity,
      doctorateYear: doctorateYear ?? this.doctorateYear,
      pgDegree: pgDegree ?? this.pgDegree,
      pgSpecialization: pgSpecialization ?? this.pgSpecialization,
      pgInstitution: pgInstitution ?? this.pgInstitution,
      pgYear: pgYear ?? this.pgYear,
      ugDegree: ugDegree ?? this.ugDegree,
      ugMajor: ugMajor ?? this.ugMajor,
      ugInstitution: ugInstitution ?? this.ugInstitution,
      ugYear: ugYear ?? this.ugYear,
      diplomaStream: diplomaStream ?? this.diplomaStream,
      diplomaInstitution: diplomaInstitution ?? this.diplomaInstitution,
      diplomaYear: diplomaYear ?? this.diplomaYear,
      schoolingName: schoolingName ?? this.schoolingName,
      schoolingBoard: schoolingBoard ?? this.schoolingBoard,
      schoolingYear: schoolingYear ?? this.schoolingYear,
      preUgType: preUgType ?? this.preUgType,
      citizenship: citizenship ?? this.citizenship,
      country: country ?? this.country,
      livingSince: livingSince ?? this.livingSince,
      state: state ?? this.state,
      city: city ?? this.city,
      employmentType: employmentType ?? this.employmentType,
      occupation: occupation ?? this.occupation,
      annualIncome: annualIncome ?? this.annualIncome,
      familyStatus: familyStatus ?? this.familyStatus,
      familyWealth: familyWealth ?? this.familyWealth,
      bio: bio ?? this.bio,
      photoPath: photoPath ?? this.photoPath,
      motherTongue: motherTongue ?? this.motherTongue,
      gothram: gothram ?? this.gothram,
      raasi: raasi ?? this.raasi,
      nakshatra: nakshatra ?? this.nakshatra,
      eatingHabits: eatingHabits ?? this.eatingHabits,
      drinkingHabits: drinkingHabits ?? this.drinkingHabits,
      smokingHabits: smokingHabits ?? this.smokingHabits,
      bodyType: bodyType ?? this.bodyType,
      ancestralOrigin: ancestralOrigin ?? this.ancestralOrigin,
      familyValues: familyValues ?? this.familyValues,
      familyType: familyType ?? this.familyType,
      parentsInfo: parentsInfo ?? this.parentsInfo,
      brothers: brothers ?? this.brothers,
      sisters: sisters ?? this.sisters,
      brothersMarried: brothersMarried ?? this.brothersMarried,
      sistersMarried: sistersMarried ?? this.sistersMarried,
      mobileNumber: mobileNumber ?? this.mobileNumber,
      whatsappNumber: whatsappNumber ?? this.whatsappNumber,
      height: height ?? this.height,
      weight: weight ?? this.weight,
      physicalStatus: physicalStatus ?? this.physicalStatus,
      maritalStatus: maritalStatus ?? this.maritalStatus,
      childrenCount: childrenCount ?? this.childrenCount,
      preferredGothram: preferredGothram ?? this.preferredGothram,
      preferredRaasi: preferredRaasi ?? this.preferredRaasi,
      preferredStar: preferredStar ?? this.preferredStar,
      preferredDosham: preferredDosham ?? this.preferredDosham,
      preferredMinIncome: preferredMinIncome ?? this.preferredMinIncome,
      // Step 10 Preferences
      preferredMinAge: preferredMinAge ?? this.preferredMinAge,
      preferredMaxAge: preferredMaxAge ?? this.preferredMaxAge,
      preferredMinHeight: preferredMinHeight ?? this.preferredMinHeight,
      preferredMaxHeight: preferredMaxHeight ?? this.preferredMaxHeight,
      preferredMaritalStatuses: preferredMaritalStatuses ?? this.preferredMaritalStatuses,
      preferredReligion: preferredReligion ?? this.preferredReligion,
      preferredCastes: preferredCastes ?? this.preferredCastes,
      preferredCasteNoBar: preferredCasteNoBar ?? this.preferredCasteNoBar,
      preferredSubcaste: preferredSubcaste ?? this.preferredSubcaste,
      preferredStars: preferredStars ?? this.preferredStars,
      preferredQualifications: preferredQualifications ?? this.preferredQualifications,
      preferredOccupations: preferredOccupations ?? this.preferredOccupations,
      preferredEatingHabits: preferredEatingHabits ?? this.preferredEatingHabits,
      preferredFoodPreferences: preferredFoodPreferences ?? this.preferredFoodPreferences,
      preferredPhysicalTypes: preferredPhysicalTypes ?? this.preferredPhysicalTypes,
      preferredFamilyWealths: preferredFamilyWealths ?? this.preferredFamilyWealths,
      preferredMaxIncome: preferredMaxIncome ?? this.preferredMaxIncome,
      preferredSmokingHabits: preferredSmokingHabits ?? this.preferredSmokingHabits,
      preferredDrinkingHabits: preferredDrinkingHabits ?? this.preferredDrinkingHabits,
      selectedHobbies: selectedHobbies ?? this.selectedHobbies,
      selectedInterests: selectedInterests ?? this.selectedInterests,
      selectedSubInterests: selectedSubInterests ?? this.selectedSubInterests,
      trait: trait ?? this.trait,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'langCode': langCode,
      'currentStep': currentStep,
      'profileFor': profileFor,
      'firstName': firstName,
      'middleName': middleName,
      'lastName': lastName,
      'gender': gender,
      'dob': dob,
      'horoscopeConsent': horoscopeConsent,
      'religion': religion,
      'caste': caste,
      'casteNoBar': casteNoBar,
      'subcaste': subcaste,
      'dosham': dosham,
      'qualification': qualification,
      'institution': institution,
      'yearCompleted': yearCompleted,
      'doctorateSpecialization': doctorateSpecialization,
      'doctorateUniversity': doctorateUniversity,
      'doctorateYear': doctorateYear,
      'pgDegree': pgDegree,
      'pgSpecialization': pgSpecialization,
      'pgInstitution': pgInstitution,
      'pgYear': pgYear,
      'ugDegree': ugDegree,
      'ugMajor': ugMajor,
      'ugInstitution': ugInstitution,
      'ugYear': ugYear,
      'diplomaStream': diplomaStream,
      'diplomaInstitution': diplomaInstitution,
      'diplomaYear': diplomaYear,
      'schoolingName': schoolingName,
      'schoolingBoard': schoolingBoard,
      'schoolingYear': schoolingYear,
      'preUgType': preUgType,
      'citizenship': citizenship,
      'country': country,
      'livingSince': livingSince,
      'state': state,
      'city': city,
      'employmentType': employmentType,
      'occupation': occupation,
      'annualIncome': annualIncome,
      'familyStatus': familyStatus,
      'familyWealth': familyWealth,
      'bio': bio,
      'photoPath': photoPath,
      'motherTongue': motherTongue,
      'gothram': gothram,
      'raasi': raasi,
      'nakshatra': nakshatra,
      'eatingHabits': eatingHabits,
      'drinkingHabits': drinkingHabits,
      'smokingHabits': smokingHabits,
      'bodyType': bodyType,
      'ancestralOrigin': ancestralOrigin,
      'familyValues': familyValues,
      'familyType': familyType,
      'parentsInfo': parentsInfo,
      'brothers': brothers,
      'sisters': sisters,
      'brothersMarried': brothersMarried,
      'sistersMarried': sistersMarried,
      'mobileNumber': mobileNumber,
      'whatsappNumber': whatsappNumber,
      'height': height,
      'weight': weight,
      'physicalStatus': physicalStatus,
      'maritalStatus': maritalStatus,
      'childrenCount': childrenCount,
      'preferredGothram': preferredGothram,
      'preferredRaasi': preferredRaasi,
      'preferredStar': preferredStar,
      'preferredDosham': preferredDosham,
      'preferredMinIncome': preferredMinIncome,
      // Step 10
      'preferredMinAge': preferredMinAge,
      'preferredMaxAge': preferredMaxAge,
      'preferredMinHeight': preferredMinHeight,
      'preferredMaxHeight': preferredMaxHeight,
      'preferredMaritalStatuses': preferredMaritalStatuses,
      'preferredReligion': preferredReligion,
      'preferredCastes': preferredCastes,
      'preferredCasteNoBar': preferredCasteNoBar,
      'preferredSubcaste': preferredSubcaste,
      'preferredStars': preferredStars,
      'preferredQualifications': preferredQualifications,
      'preferredOccupations': preferredOccupations,
      'preferredEatingHabits': preferredEatingHabits,
      'preferredFoodPreferences': preferredFoodPreferences,
      'preferredPhysicalTypes': preferredPhysicalTypes,
      'preferredFamilyWealths': preferredFamilyWealths,
      'preferredMaxIncome': preferredMaxIncome,
      'preferredSmokingHabits': preferredSmokingHabits,
      'preferredDrinkingHabits': preferredDrinkingHabits,
      'selectedHobbies': selectedHobbies,
      'selectedInterests': selectedInterests,
      'selectedSubInterests': selectedSubInterests.map((k, v) => MapEntry(k, v)),
      'trait': trait,
    };
  }

  factory OnboardingState.fromMap(Map<String, dynamic> map) {
    return OnboardingState(
      langCode: map['langCode'] ?? 'en',
      currentStep: map['currentStep'] ?? 1,
      profileFor: map['profileFor'],
      firstName: map['firstName'],
      middleName: map['middleName'],
      lastName: map['lastName'],
      gender: map['gender'],
      dob: map['dob'],
      horoscopeConsent: map['horoscopeConsent'] ?? false,
      religion: map['religion'],
      caste: map['caste'],
      casteNoBar: map['casteNoBar'] ?? false,
      subcaste: map['subcaste'],
      dosham: map['dosham'] ?? 'none',
      qualification: map['qualification'],
      institution: map['institution'],
      yearCompleted: map['yearCompleted'],
      doctorateSpecialization: map['doctorateSpecialization'],
      doctorateUniversity: map['doctorateUniversity'],
      doctorateYear: map['doctorateYear'],
      pgDegree: map['pgDegree'],
      pgSpecialization: map['pgSpecialization'],
      pgInstitution: map['pgInstitution'],
      pgYear: map['pgYear'],
      ugDegree: map['ugDegree'],
      ugMajor: map['ugMajor'],
      ugInstitution: map['ugInstitution'],
      ugYear: map['ugYear'],
      diplomaStream: map['diplomaStream'],
      diplomaInstitution: map['diplomaInstitution'],
      diplomaYear: map['diplomaYear'],
      schoolingName: map['schoolingName'],
      schoolingBoard: map['schoolingBoard'],
      schoolingYear: map['schoolingYear'],
      preUgType: map['preUgType'],
      citizenship: map['citizenship'],
      country: map['country'],
      livingSince: map['livingSince'],
      state: map['state'],
      city: map['city'],
      employmentType: map['employmentType'],
      occupation: map['occupation'],
      annualIncome: map['annualIncome'],
      familyStatus: map['familyStatus'],
      familyWealth: map['familyWealth'],
      bio: map['bio'],
      photoPath: map['photoPath'],
      motherTongue: map['motherTongue'],
      gothram: map['gothram'],
      raasi: map['raasi'],
      nakshatra: map['nakshatra'],
      eatingHabits: map['eatingHabits'],
      drinkingHabits: map['drinkingHabits'],
      smokingHabits: map['smokingHabits'],
      bodyType: map['bodyType'],
      ancestralOrigin: map['ancestralOrigin'],
      familyValues: map['familyValues'],
      familyType: map['familyType'],
      parentsInfo: map['parentsInfo'],
      brothers: map['brothers'],
      sisters: map['sisters'],
      brothersMarried: map['brothersMarried'],
      sistersMarried: map['sistersMarried'],
      mobileNumber: map['mobileNumber'],
      whatsappNumber: map['whatsappNumber'],
      height: map['height'],
      weight: map['weight'],
      physicalStatus: map['physicalStatus'],
      maritalStatus: map['maritalStatus'],
      childrenCount: map['childrenCount'],
      preferredGothram: map['preferredGothram'],
      preferredRaasi: map['preferredRaasi'],
      preferredStar: map['preferredStar'],
      preferredDosham: map['preferredDosham'],
      preferredMinIncome: map['preferredMinIncome'],
      // Step 10
      preferredMinAge: map['preferredMinAge'] ?? 21,
      preferredMaxAge: map['preferredMaxAge'] ?? 35,
      preferredMinHeight: (map['preferredMinHeight'] as num?)?.toDouble() ?? 5.0,
      preferredMaxHeight: (map['preferredMaxHeight'] as num?)?.toDouble() ?? 6.5,
      preferredMaritalStatuses: List<String>.from(map['preferredMaritalStatuses'] ?? []),
      preferredReligion: map['preferredReligion'],
      preferredCastes: List<String>.from(map['preferredCastes'] ?? []),
      preferredCasteNoBar: map['preferredCasteNoBar'] ?? false,
      preferredSubcaste: map['preferredSubcaste'],
      preferredStars: List<String>.from(map['preferredStars'] ?? []),
      preferredQualifications: List<String>.from(map['preferredQualifications'] ?? []),
      preferredOccupations: List<String>.from(map['preferredOccupations'] ?? []),
      preferredEatingHabits: List<String>.from(map['preferredEatingHabits'] ?? []),
      preferredFoodPreferences: List<String>.from(map['preferredFoodPreferences'] ?? []),
      preferredPhysicalTypes: List<String>.from(map['preferredPhysicalTypes'] ?? []),
      preferredFamilyWealths: List<String>.from(map['preferredFamilyWealths'] ?? []),
      preferredMaxIncome: map['preferredMaxIncome'],
      preferredSmokingHabits: List<String>.from(map['preferredSmokingHabits'] ?? []),
      preferredDrinkingHabits: List<String>.from(map['preferredDrinkingHabits'] ?? []),
      selectedHobbies: List<String>.from(map['selectedHobbies'] ?? []),
      selectedInterests: List<String>.from(map['selectedInterests'] ?? []),
      selectedSubInterests: (map['selectedSubInterests'] as Map<String, dynamic>?)?.map(
            (k, v) => MapEntry(k, List<String>.from(v)),
          ) ??
          {},
      trait: map['trait'],
    );
  }
}

class OnboardingCubit extends Cubit<OnboardingState> {
  OnboardingCubit() : super(OnboardingState()) {
    _loadFromPrefs();
  }

  static const String _prefKey = 'kalyathiru_onboarding_state';

  Future<void> _loadFromPrefs() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final jsonStr = prefs.getString(_prefKey);
      if (jsonStr != null) {
        final map = json.decode(jsonStr) as Map<String, dynamic>;
        emit(OnboardingState.fromMap(map));
      }
    } catch (_) {}
  }

  Future<void> _saveToPrefs() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final jsonStr = json.encode(state.toMap());
      await prefs.setString(_prefKey, jsonStr);
    } catch (_) {}
  }

  void updateLanguage(String langCode) {
    emit(state.copyWith(langCode: langCode));
    _saveToPrefs();
  }

  void toggleLanguage() {
    final nextLang = state.langCode == 'en' ? 'ta' : 'en';
    emit(state.copyWith(langCode: nextLang));
    _saveToPrefs();
  }

  void updateStep(int step) {
    emit(state.copyWith(currentStep: step));
    _saveToPrefs();
  }

  void updateFields({
    String? profileFor,
    String? firstName,
    String? middleName,
    String? lastName,
    String? gender,
    String? dob,
    bool? horoscopeConsent,
    String? religion,
    String? caste,
    bool? casteNoBar,
    String? subcaste,
    String? dosham,
    String? qualification,
    String? institution,
    String? yearCompleted,
    String? doctorateSpecialization,
    String? doctorateUniversity,
    String? doctorateYear,
    String? pgDegree,
    String? pgSpecialization,
    String? pgInstitution,
    String? pgYear,
    String? ugDegree,
    String? ugMajor,
    String? ugInstitution,
    String? ugYear,
    String? diplomaStream,
    String? diplomaInstitution,
    String? diplomaYear,
    String? schoolingName,
    String? schoolingBoard,
    String? schoolingYear,
    String? preUgType,
    String? citizenship,
    String? country,
    String? livingSince,
    String? state,
    String? city,
    String? employmentType,
    String? occupation,
    String? annualIncome,
    String? familyStatus,
    String? familyWealth,
    String? bio,
    String? photoPath,
    String? motherTongue,
    String? gothram,
    String? raasi,
    String? nakshatra,
    String? eatingHabits,
    String? drinkingHabits,
    String? smokingHabits,
    String? bodyType,
    String? ancestralOrigin,
    String? familyValues,
    String? familyType,
    String? parentsInfo,
    String? brothers,
    String? sisters,
    String? brothersMarried,
    String? sistersMarried,
    String? mobileNumber,
    String? whatsappNumber,
    String? height,
    String? weight,
    String? physicalStatus,
    String? maritalStatus,
    String? childrenCount,
    String? preferredGothram,
    String? preferredRaasi,
    String? preferredStar,
    String? preferredDosham,
    String? preferredMinIncome,
    // Step 10 Preferences
    int? preferredMinAge,
    int? preferredMaxAge,
    double? preferredMinHeight,
    double? preferredMaxHeight,
    List<String>? preferredMaritalStatuses,
    String? preferredReligion,
    List<String>? preferredCastes,
    bool? preferredCasteNoBar,
    String? preferredSubcaste,
    List<String>? preferredStars,
    List<String>? preferredQualifications,
    List<String>? preferredOccupations,
    List<String>? preferredEatingHabits,
    List<String>? preferredFoodPreferences,
    List<String>? preferredPhysicalTypes,
    List<String>? preferredFamilyWealths,
    String? preferredMaxIncome,
    List<String>? preferredSmokingHabits,
    List<String>? preferredDrinkingHabits,
    List<String>? selectedHobbies,
    List<String>? selectedInterests,
    Map<String, List<String>>? selectedSubInterests,
    String? trait,
  }) {
    emit(this.state.copyWith(
      profileFor: profileFor ?? this.state.profileFor,
      firstName: firstName ?? this.state.firstName,
      middleName: middleName ?? this.state.middleName,
      lastName: lastName ?? this.state.lastName,
      gender: gender ?? this.state.gender,
      dob: dob ?? this.state.dob,
      horoscopeConsent: horoscopeConsent ?? this.state.horoscopeConsent,
      religion: religion ?? this.state.religion,
      caste: caste ?? this.state.caste,
      casteNoBar: casteNoBar ?? this.state.casteNoBar,
      subcaste: subcaste ?? this.state.subcaste,
      dosham: dosham ?? this.state.dosham,
      qualification: qualification ?? this.state.qualification,
      institution: institution ?? this.state.institution,
      yearCompleted: yearCompleted ?? this.state.yearCompleted,
      doctorateSpecialization: doctorateSpecialization ?? this.state.doctorateSpecialization,
      doctorateUniversity: doctorateUniversity ?? this.state.doctorateUniversity,
      doctorateYear: doctorateYear ?? this.state.doctorateYear,
      pgDegree: pgDegree ?? this.state.pgDegree,
      pgSpecialization: pgSpecialization ?? this.state.pgSpecialization,
      pgInstitution: pgInstitution ?? this.state.pgInstitution,
      pgYear: pgYear ?? this.state.pgYear,
      ugDegree: ugDegree ?? this.state.ugDegree,
      ugMajor: ugMajor ?? this.state.ugMajor,
      ugInstitution: ugInstitution ?? this.state.ugInstitution,
      ugYear: ugYear ?? this.state.ugYear,
      diplomaStream: diplomaStream ?? this.state.diplomaStream,
      diplomaInstitution: diplomaInstitution ?? this.state.diplomaInstitution,
      diplomaYear: diplomaYear ?? this.state.diplomaYear,
      schoolingName: schoolingName ?? this.state.schoolingName,
      schoolingBoard: schoolingBoard ?? this.state.schoolingBoard,
      schoolingYear: schoolingYear ?? this.state.schoolingYear,
      preUgType: preUgType ?? this.state.preUgType,
      citizenship: citizenship ?? this.state.citizenship,
      country: country ?? this.state.country,
      livingSince: livingSince ?? this.state.livingSince,
      state: state ?? this.state.state,
      city: city ?? this.state.city,
      employmentType: employmentType ?? this.state.employmentType,
      occupation: occupation ?? this.state.occupation,
      annualIncome: annualIncome ?? this.state.annualIncome,
      familyStatus: familyStatus ?? this.state.familyStatus,
      familyWealth: familyWealth ?? this.state.familyWealth,
      bio: bio ?? this.state.bio,
      photoPath: photoPath ?? this.state.photoPath,
      motherTongue: motherTongue ?? this.state.motherTongue,
      gothram: gothram ?? this.state.gothram,
      raasi: raasi ?? this.state.raasi,
      nakshatra: nakshatra ?? this.state.nakshatra,
      eatingHabits: eatingHabits ?? this.state.eatingHabits,
      drinkingHabits: drinkingHabits ?? this.state.drinkingHabits,
      smokingHabits: smokingHabits ?? this.state.smokingHabits,
      bodyType: bodyType ?? this.state.bodyType,
      ancestralOrigin: ancestralOrigin ?? this.state.ancestralOrigin,
      familyValues: familyValues ?? this.state.familyValues,
      familyType: familyType ?? this.state.familyType,
      parentsInfo: parentsInfo ?? this.state.parentsInfo,
      brothers: brothers ?? this.state.brothers,
      sisters: sisters ?? this.state.sisters,
      brothersMarried: brothersMarried ?? this.state.brothersMarried,
      sistersMarried: sistersMarried ?? this.state.sistersMarried,
      mobileNumber: mobileNumber ?? this.state.mobileNumber,
      whatsappNumber: whatsappNumber ?? this.state.whatsappNumber,
      height: height ?? this.state.height,
      weight: weight ?? this.state.weight,
      physicalStatus: physicalStatus ?? this.state.physicalStatus,
      maritalStatus: maritalStatus ?? this.state.maritalStatus,
      childrenCount: childrenCount ?? this.state.childrenCount,
      preferredGothram: preferredGothram ?? this.state.preferredGothram,
      preferredRaasi: preferredRaasi ?? this.state.preferredRaasi,
      preferredStar: preferredStar ?? this.state.preferredStar,
      preferredDosham: preferredDosham ?? this.state.preferredDosham,
      preferredMinIncome: preferredMinIncome ?? this.state.preferredMinIncome,
      // Step 10 Preferences
      preferredMinAge: preferredMinAge ?? this.state.preferredMinAge,
      preferredMaxAge: preferredMaxAge ?? this.state.preferredMaxAge,
      preferredMinHeight: preferredMinHeight ?? this.state.preferredMinHeight,
      preferredMaxHeight: preferredMaxHeight ?? this.state.preferredMaxHeight,
      preferredMaritalStatuses: preferredMaritalStatuses ?? this.state.preferredMaritalStatuses,
      preferredReligion: preferredReligion ?? this.state.preferredReligion,
      preferredCastes: preferredCastes ?? this.state.preferredCastes,
      preferredCasteNoBar: preferredCasteNoBar ?? this.state.preferredCasteNoBar,
      preferredSubcaste: preferredSubcaste ?? this.state.preferredSubcaste,
      preferredStars: preferredStars ?? this.state.preferredStars,
      preferredQualifications: preferredQualifications ?? this.state.preferredQualifications,
      preferredOccupations: preferredOccupations ?? this.state.preferredOccupations,
      preferredEatingHabits: preferredEatingHabits ?? this.state.preferredEatingHabits,
      preferredFoodPreferences: preferredFoodPreferences ?? this.state.preferredFoodPreferences,
      preferredPhysicalTypes: preferredPhysicalTypes ?? this.state.preferredPhysicalTypes,
      preferredFamilyWealths: preferredFamilyWealths ?? this.state.preferredFamilyWealths,
      preferredMaxIncome: preferredMaxIncome ?? this.state.preferredMaxIncome,
      preferredSmokingHabits: preferredSmokingHabits ?? this.state.preferredSmokingHabits,
      preferredDrinkingHabits: preferredDrinkingHabits ?? this.state.preferredDrinkingHabits,
      selectedHobbies: selectedHobbies ?? this.state.selectedHobbies,
      selectedInterests: selectedInterests ?? this.state.selectedInterests,
      selectedSubInterests: selectedSubInterests ?? this.state.selectedSubInterests,
      trait: trait ?? this.state.trait,
    ));
    _saveToPrefs();
  }

  void updateSubInterest(String category, List<String> genres) {
    final updatedMap = Map<String, List<String>>.from(state.selectedSubInterests);
    updatedMap[category] = genres;
    emit(state.copyWith(selectedSubInterests: updatedMap));
    _saveToPrefs();
  }

  Future<void> clearState() async {
    emit(OnboardingState(langCode: state.langCode));
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(_prefKey);
    } catch (_) {}
  }
}
