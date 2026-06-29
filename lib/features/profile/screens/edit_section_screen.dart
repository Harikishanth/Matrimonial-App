import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../onboarding/cubit/onboarding_cubit.dart';
import '../../../core/theme/theme.dart';
import '../../../core/translation/option_translations.dart';
import '../../../core/translation/geographic_helper.dart';
import 'package:country_state_city/country_state_city.dart' as csc;
import '../../../core/widgets/bottom_sheet_selector.dart';
import '../../../core/widgets/notched_text_field.dart';
import '../../../core/widgets/sub_interest_sheet.dart';
import '../models/edit_profile_options.dart';

class EditSectionScreen extends StatefulWidget {
  final String section;

  const EditSectionScreen({
    super.key,
    required this.section,
  });

  @override
  State<EditSectionScreen> createState() => _EditSectionScreenState();
}

class _EditSectionScreenState extends State<EditSectionScreen> {
  final _formKey = GlobalKey<FormState>();

  // Personal Info Form Variables
  late TextEditingController _firstNameController;
  late TextEditingController _middleNameController;
  late TextEditingController _lastNameController;
  late TextEditingController _bioController;
  late TextEditingController _dobController;
  String? _profileFor;
  String? _gender;
  String? _height;
  String? _weight;
  String? _maritalStatus;
  String? _motherTongue;
  String? _physicalStatus;
  String? _bodyType;
  String? _eatingHabits;
  String? _drinkingHabits;
  String? _smokingHabits;

  // Religious Info Form Variables
  String? _religion;
  String? _caste;
  late TextEditingController _subcasteController;
  String? _dosham;
  String? _gothram;
  String? _raasi;
  String? _star;

  // Education Details Form Variables
  String? _qualification;
  late TextEditingController _docSpecializationController;
  late TextEditingController _docUniversityController;
  String? _doctorateYear;
  String? _pgDegree;
  late TextEditingController _pgSpecializationController;
  late TextEditingController _pgInstitutionController;
  String? _pgYear;
  String? _ugDegree;
  late TextEditingController _ugMajorController;
  late TextEditingController _ugInstitutionController;
  String? _ugYear;
  String? _preUgType; // 'schooling' or 'diploma'
  late TextEditingController _diplomaStreamController;
  late TextEditingController _diplomaInstitutionController;
  String? _diplomaYear;
  late TextEditingController _schoolingNameController;
  String? _schoolingBoard;
  String? _schoolingYear;

  // Professional Info Form Variables
  String? _employmentType;
  String? _occupation;
  late TextEditingController _occupationDetailController;
  late TextEditingController _organizationController;
  String? _annualIncome;

  // Location Info Form Variables
  String? _country;
  String? _stateVal;
  String? _cityVal;
  String? _citizenship;
  late TextEditingController _ancestralOriginController;

  List<csc.Country> _allCountries = [];
  List<csc.State> _allStates = [];
  List<csc.City> _allCities = [];
  bool _loadingLocations = false;

  // Family Details Form Variables
  String? _familyValues;
  String? _familyType;
  String? _familyStatus;
  String? _familyWealth;
  late TextEditingController _parentsInfoController;
  String? _brothers;
  String? _brothersMarried;
  String? _sisters;
  String? _sistersMarried;

  // Hobbies are managed dynamically via cubit state

  @override
  void initState() {
    super.initState();
    final state = context.read<OnboardingCubit>().state;

    // Personal Info Initializers
    _firstNameController = TextEditingController(text: state.firstName ?? '');
    _middleNameController = TextEditingController(text: state.middleName ?? '');
    _lastNameController = TextEditingController(text: state.lastName ?? '');
    _bioController = TextEditingController(text: state.bio ?? '');
    _dobController = TextEditingController(text: state.dob ?? '');
    _profileFor = state.profileFor;
    _gender = state.gender;
    _height = state.height;
    _weight = state.weight;
    _maritalStatus = state.maritalStatus;
    _motherTongue = state.motherTongue;
    _physicalStatus = state.physicalStatus;
    _bodyType = state.bodyType;
    _eatingHabits = state.eatingHabits;
    _drinkingHabits = state.drinkingHabits;
    _smokingHabits = state.smokingHabits;

    // Religious Info Initializers
    _religion = state.religion;
    _caste = state.caste;
    _subcasteController = TextEditingController(text: state.subcaste ?? '');
    _dosham = state.dosham;
    _gothram = state.gothram;
    _raasi = state.raasi;
    _star = state.nakshatra; // Stored as nakshatra in state

    // Education Details Initializers
    _qualification = state.qualification;
    _docSpecializationController = TextEditingController(text: state.doctorateSpecialization ?? '');
    _docUniversityController = TextEditingController(text: state.doctorateUniversity ?? '');
    _doctorateYear = state.doctorateYear;
    _pgDegree = state.pgDegree;
    _pgSpecializationController = TextEditingController(text: state.pgSpecialization ?? '');
    _pgInstitutionController = TextEditingController(text: state.pgInstitution ?? '');
    _pgYear = state.pgYear;
    _ugDegree = state.ugDegree;
    _ugMajorController = TextEditingController(text: state.ugMajor ?? '');
    _ugInstitutionController = TextEditingController(text: state.ugInstitution ?? '');
    _ugYear = state.ugYear;
    _preUgType = state.preUgType ?? 'schooling';
    _diplomaStreamController = TextEditingController(text: state.diplomaStream ?? '');
    _diplomaInstitutionController = TextEditingController(text: state.diplomaInstitution ?? '');
    _diplomaYear = state.diplomaYear;
    _schoolingNameController = TextEditingController(text: state.schoolingName ?? '');
    _schoolingBoard = state.schoolingBoard;
    _schoolingYear = state.schoolingYear;

    // Professional Info Initializers
    _employmentType = state.employmentType;
    _occupation = state.occupation;
    _occupationDetailController = TextEditingController(text: state.trait ?? ''); // Stored under trait or we can map occupation detail
    _organizationController = TextEditingController(text: state.institution ?? ''); // Reusing institution or similar
    _annualIncome = state.annualIncome;

    // Location Info Initializers
    _country = state.country;
    _stateVal = state.state;
    _cityVal = state.city;
    _citizenship = state.citizenship;
    _ancestralOriginController = TextEditingController(text: state.ancestralOrigin ?? '');

    // Family Details Initializers
    _familyValues = state.familyValues;
    _familyType = state.familyType;
    _familyStatus = state.familyStatus;
    _familyWealth = state.familyWealth;
    _parentsInfoController = TextEditingController(text: state.parentsInfo ?? '');
    _brothers = state.brothers;
    _brothersMarried = state.brothersMarried;
    _sisters = state.sisters;
    _sistersMarried = state.sistersMarried;

    if (widget.section == 'location') {
      _initGeographicData();
    }
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _middleNameController.dispose();
    _lastNameController.dispose();
    _bioController.dispose();
    _dobController.dispose();
    _subcasteController.dispose();
    _docSpecializationController.dispose();
    _docUniversityController.dispose();
    _pgSpecializationController.dispose();
    _pgInstitutionController.dispose();
    _ugMajorController.dispose();
    _ugInstitutionController.dispose();
    _diplomaStreamController.dispose();
    _diplomaInstitutionController.dispose();
    _schoolingNameController.dispose();
    _occupationDetailController.dispose();
    _organizationController.dispose();
    _ancestralOriginController.dispose();
    _parentsInfoController.dispose();
    super.dispose();
  }

  Future<void> _initGeographicData() async {
    setState(() => _loadingLocations = true);
    try {
      _allCountries = await GeographicHelper.getAllCountries();
      if (_country != null) {
        final countryModel = _allCountries.firstWhere(
          (c) => c.name == _country,
          orElse: () => _allCountries.first,
        );
        _allStates = await GeographicHelper.getStatesOfCountry(countryModel.isoCode);
        if (_stateVal != null) {
          final stateModel = _allStates.firstWhere(
            (s) => s.name == _stateVal,
            orElse: () => _allStates.first,
          );
          _allCities = await GeographicHelper.getStateCities(countryModel.isoCode, stateModel.isoCode);
        }
      }
    } catch (e) {
      debugPrint("Error initializing geographic data: $e");
    } finally {
      if (mounted) {
        setState(() => _loadingLocations = false);
      }
    }
  }

  Future<void> _onCountryChanged(String val) async {
    setState(() {
      _country = val;
      _stateVal = null;
      _cityVal = null;
      _allStates = [];
      _allCities = [];
      _loadingLocations = true;
    });
    try {
      final countryModel = _allCountries.firstWhere(
        (c) => c.name == val,
        orElse: () => _allCountries.first,
      );
      final states = await GeographicHelper.getStatesOfCountry(countryModel.isoCode);
      states.sort((a, b) => a.name.compareTo(b.name));
      if (mounted) {
        setState(() {
          _allStates = states;
          if (_allStates.isEmpty) {
            _stateVal = 'Other';
            _cityVal = 'Other';
          }
        });
      }
    } catch (e) {
      debugPrint("Error loading states: $e");
    } finally {
      if (mounted) {
        setState(() => _loadingLocations = false);
      }
    }
  }

  Future<void> _onStateChanged(String val) async {
    setState(() {
      _stateVal = val;
      _cityVal = null;
      _allCities = [];
      if (val == 'Other') {
        _cityVal = 'Other';
      } else {
        _loadingLocations = true;
      }
    });
    if (val == 'Other') return;
    try {
      final countryModel = _allCountries.firstWhere(
        (c) => c.name == _country,
        orElse: () => _allCountries.first,
      );
      final stateModel = _allStates.firstWhere(
        (s) => s.name == val,
        orElse: () => _allStates.first,
      );
      final cities = await GeographicHelper.getStateCities(countryModel.isoCode, stateModel.isoCode);
      cities.sort((a, b) => a.name.compareTo(b.name));
      if (mounted) {
        setState(() {
          _allCities = cities;
          if (_allCities.isEmpty) {
            _cityVal = 'Other';
          }
        });
      }
    } catch (e) {
      debugPrint("Error loading cities: $e");
    } finally {
      if (mounted) {
        setState(() => _loadingLocations = false);
      }
    }
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime(2000),
      firstDate: DateTime(1950),
      lastDate: DateTime(2008),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: KalyaThiruTheme.primaryMaroon,
              onPrimary: Colors.white,
              onSurface: KalyaThiruTheme.darkCharcoal,
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null) {
      setState(() {
        _dobController.text =
            "${picked.year}-${picked.month.toString().padLeft(2, '0')}-${picked.day.toString().padLeft(2, '0')}";
      });
    }
  }

  void _save(BuildContext context) {
    if (_formKey.currentState!.validate()) {
      final cubit = context.read<OnboardingCubit>();
      final state = cubit.state;
      final lang = state.langCode;

      if (widget.section == 'personal') {
        cubit.updateFields(
          firstName: _firstNameController.text,
          middleName: _middleNameController.text,
          lastName: _lastNameController.text,
          bio: _bioController.text,
          dob: _dobController.text,
          profileFor: _profileFor,
          gender: _gender,
          height: _height,
          weight: _weight,
          maritalStatus: _maritalStatus,
          motherTongue: _motherTongue,
          physicalStatus: _physicalStatus,
          bodyType: _bodyType,
          eatingHabits: _eatingHabits,
          drinkingHabits: _drinkingHabits,
          smokingHabits: _smokingHabits,
        );
      } else if (widget.section == 'religion') {
        cubit.updateFields(
          religion: _religion,
          caste: _caste,
          subcaste: _subcasteController.text,
          dosham: _dosham,
          gothram: _gothram,
          raasi: _raasi,
          nakshatra: _star,
        );
      } else if (widget.section == 'education') {
        String? finalInst;
        String? finalYear;

        if (_qualification == 'Doctorate (Ph.D / Research)') {
          finalInst = _docUniversityController.text;
          finalYear = _doctorateYear;
        } else if (_qualification == 'Post-Graduation (MA, MSc, MBA, ME, etc.)') {
          finalInst = _pgInstitutionController.text;
          finalYear = _pgYear;
        } else if (_qualification == 'Graduation / Bachelors (BA, BSc, BE, BTech, etc.)') {
          finalInst = _ugInstitutionController.text;
          finalYear = _ugYear;
        } else if (_qualification == 'Diploma') {
          finalInst = _diplomaInstitutionController.text;
          finalYear = _diplomaYear;
        } else if (_qualification == 'Schooling (HSC / SSLC)') {
          finalInst = _schoolingNameController.text;
          finalYear = _schoolingYear;
        }

        cubit.updateFields(
          qualification: _qualification,
          institution: finalInst,
          yearCompleted: finalYear,
          doctorateSpecialization: _docSpecializationController.text,
          doctorateUniversity: _docUniversityController.text,
          doctorateYear: _doctorateYear,
          pgDegree: _pgDegree,
          pgSpecialization: _pgSpecializationController.text,
          pgInstitution: _pgInstitutionController.text,
          pgYear: _pgYear,
          ugDegree: _ugDegree,
          ugMajor: _ugMajorController.text,
          ugInstitution: _ugInstitutionController.text,
          ugYear: _ugYear,
          diplomaStream: _diplomaStreamController.text,
          diplomaInstitution: _diplomaInstitutionController.text,
          diplomaYear: _diplomaYear,
          schoolingName: _schoolingNameController.text,
          schoolingBoard: _schoolingBoard,
          schoolingYear: _schoolingYear,
          preUgType: _preUgType,
        );
      } else if (widget.section == 'professional') {
        cubit.updateFields(
          employmentType: _employmentType,
          occupation: _occupation,
          trait: _occupationDetailController.text, // Reusing trait or saving separately
          institution: _organizationController.text, // Reusing institution or saving separately
          annualIncome: _annualIncome,
        );
      } else if (widget.section == 'location') {
        cubit.updateFields(
          country: _country,
          state: _stateVal,
          city: _cityVal,
          citizenship: _citizenship,
          ancestralOrigin: _ancestralOriginController.text,
        );
      } else if (widget.section == 'family') {
        cubit.updateFields(
          familyValues: _familyValues,
          familyType: _familyType,
          familyStatus: _familyStatus,
          familyWealth: _familyWealth,
          parentsInfo: _parentsInfoController.text,
          brothers: _brothers,
          brothersMarried: _brothersMarried,
          sisters: _sisters,
          sistersMarried: _sistersMarried,
        );
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            lang == 'ta' ? 'விவரங்கள் வெற்றிகரமாக சேமிக்கப்பட்டன!' : 'Details saved successfully!',
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          backgroundColor: KalyaThiruTheme.primaryMaroon,
        ),
      );
      context.pop();
    }
  }

  String _getSectionTitle(String lang) {
    if (lang == 'ta') {
      switch (widget.section) {
        case 'personal':
          return 'தனிப்பட்ட விவரங்கள்';
        case 'religion':
          return 'சமய விவரங்கள்';
        case 'education':
          return 'கல்வி விவரங்கள்';
        case 'professional':
          return 'தொழில் விவரங்கள்';
        case 'location':
          return 'இருப்பிட விவரங்கள்';
        case 'family':
          return 'குடும்ப விவரங்கள்';
        case 'hobbies':
          return 'சுய விருப்பங்கள் & பொழுதுபோக்கு';
        default:
          return 'விவரங்களைத் திருத்தவும்';
      }
    } else {
      switch (widget.section) {
        case 'personal':
          return 'Personal Info';
        case 'religion':
          return 'Religious Info';
        case 'education':
          return 'Education Details';
        case 'professional':
          return 'Professional Info';
        case 'location':
          return 'Location Info';
        case 'family':
          return 'Family Details';
        case 'hobbies':
          return 'Hobbies & Interests';
        default:
          return 'Edit Details';
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = context.watch<OnboardingCubit>().state;
    final lang = state.langCode;
    final years = List.generate(49, (index) => (2028 - index).toString());

    return Scaffold(
      backgroundColor: KalyaThiruTheme.softIvory,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.5,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: KalyaThiruTheme.primaryMaroon),
          onPressed: () => context.pop(),
        ),
        title: Text(
          _getSectionTitle(lang),
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                color: KalyaThiruTheme.primaryMaroon,
                fontFamily: 'Source Serif 4',
                fontWeight: FontWeight.bold,
              ),
        ),
        actions: [
          if (widget.section != 'hobbies')
            IconButton(
              icon: const Icon(Icons.check, color: KalyaThiruTheme.primaryMaroon),
              onPressed: () => _save(context),
            ),
        ],
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20.0),
          child: Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(4),
              border: Border.all(
                color: KalyaThiruTheme.outlineBorder.withOpacity(0.15),
                width: 1,
              ),
            ),
            child: _buildFormFields(lang, years),
          ),
        ),
      ),
      bottomNavigationBar: widget.section != 'hobbies'
          ? SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: KalyaThiruTheme.primaryMaroon,
                    foregroundColor: Colors.white,
                    minimumSize: const Size(double.infinity, 50),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                  onPressed: () => _save(context),
                  child: Text(
                    lang == 'ta' ? 'சேமிக்கவும்' : 'Save Details',
                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            )
          : null,
    );
  }

  Widget _buildFormFields(String lang, List<String> years) {
    switch (widget.section) {
      case 'personal':
        return _buildPersonalInfoForm(lang);
      case 'religion':
        return _buildReligiousInfoForm(lang);
      case 'education':
        return _buildEducationDetailsForm(lang, years);
      case 'professional':
        return _buildProfessionalInfoForm(lang);
      case 'location':
        return _buildLocationInfoForm(lang);
      case 'family':
        return _buildFamilyDetailsForm(lang);
      case 'hobbies':
        return _buildHobbiesForm(lang);
      default:
        return const SizedBox.shrink();
    }
  }

  Widget _buildPersonalInfoForm(String lang) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        NotchedTextField(
          labelText: lang == 'ta' ? 'முதல் பெயர்' : 'First Name',
          controller: _firstNameController,
          validator: (val) => val == null || val.trim().isEmpty ? (lang == 'ta' ? 'முதல் பெயர் தேவை' : 'First name is required') : null,
        ),
        const SizedBox(height: 20),
        NotchedTextField(
          labelText: lang == 'ta' ? 'நடுப்பெயர்' : 'Middle Name',
          controller: _middleNameController,
        ),
        const SizedBox(height: 20),
        NotchedTextField(
          labelText: lang == 'ta' ? 'இறுதிப் பெயர்' : 'Last Name',
          controller: _lastNameController,
          validator: (val) => val == null || val.trim().isEmpty ? (lang == 'ta' ? 'இறுதிப் பெயர் தேவை' : 'Last name is required') : null,
        ),
        const SizedBox(height: 20),
        NotchedTextField(
          labelText: lang == 'ta' ? 'பிறந்த தேதி' : 'Date of Birth',
          controller: _dobController,
          readOnly: true,
          onTap: () => _selectDate(context),
          suffixIcon: const Icon(Icons.calendar_today, color: KalyaThiruTheme.mutedGray),
        ),
        const SizedBox(height: 20),
        BottomSheetSelector(
          labelText: lang == 'ta' ? 'உறவுமுறை' : 'Profile Created By',
          selectedValue: _profileFor,
          options: EditProfileOptions.profileCreatedByOptions,
          onSelected: (val) => setState(() => _profileFor = val),
        ),
        const SizedBox(height: 20),
        BottomSheetSelector(
          labelText: lang == 'ta' ? 'பாலினம்' : 'Gender',
          selectedValue: _gender,
          options: const ['Male', 'Female'],
          onSelected: (val) => setState(() => _gender = val),
        ),
        const SizedBox(height: 20),
        BottomSheetSelector(
          labelText: lang == 'ta' ? 'உயரம்' : 'Height',
          selectedValue: _height,
          options: EditProfileOptions.heights,
          onSelected: (val) => setState(() => _height = val),
        ),
        const SizedBox(height: 20),
        BottomSheetSelector(
          labelText: lang == 'ta' ? 'எடை' : 'Weight',
          selectedValue: _weight,
          options: EditProfileOptions.weights,
          onSelected: (val) => setState(() => _weight = val),
        ),
        const SizedBox(height: 20),
        BottomSheetSelector(
          labelText: lang == 'ta' ? 'திருமண நிலை' : 'Marital Status',
          selectedValue: _maritalStatus,
          options: EditProfileOptions.maritalStatuses,
          onSelected: (val) => setState(() => _maritalStatus = val),
        ),
        const SizedBox(height: 20),
        BottomSheetSelector(
          labelText: lang == 'ta' ? 'தாய்மொழி' : 'Mother Tongue',
          selectedValue: _motherTongue,
          options: EditProfileOptions.motherTongues,
          onSelected: (val) => setState(() => _motherTongue = val),
        ),
        const SizedBox(height: 20),
        BottomSheetSelector(
          labelText: lang == 'ta' ? 'உடல் நிலை' : 'Physical Status',
          selectedValue: _physicalStatus,
          options: EditProfileOptions.physicalStatuses,
          onSelected: (val) => setState(() => _physicalStatus = val),
        ),
        const SizedBox(height: 20),
        BottomSheetSelector(
          labelText: lang == 'ta' ? 'உடல்வாகு' : 'Body Type',
          selectedValue: _bodyType,
          options: EditProfileOptions.bodyTypes,
          onSelected: (val) => setState(() => _bodyType = val),
        ),
        const SizedBox(height: 20),
        BottomSheetSelector(
          labelText: lang == 'ta' ? 'உணவு பழக்கம்' : 'Diet Preference',
          selectedValue: _eatingHabits,
          options: EditProfileOptions.eatingHabits,
          onSelected: (val) => setState(() => _eatingHabits = val),
        ),
        const SizedBox(height: 20),
        BottomSheetSelector(
          labelText: lang == 'ta' ? 'மது அருந்தும் பழக்கம்' : 'Drinking Habit',
          selectedValue: _drinkingHabits,
          options: EditProfileOptions.drinkingHabits,
          onSelected: (val) => setState(() => _drinkingHabits = val),
        ),
        const SizedBox(height: 20),
        BottomSheetSelector(
          labelText: lang == 'ta' ? 'புகைபிடிக்கும் பழக்கம்' : 'Smoking Habit',
          selectedValue: _smokingHabits,
          options: EditProfileOptions.smokingHabits,
          onSelected: (val) => setState(() => _smokingHabits = val),
        ),
        const SizedBox(height: 20),
        TextFormField(
          controller: _bioController,
          maxLines: 5,
          keyboardType: TextInputType.multiline,
          style: Theme.of(context).textTheme.bodyLarge,
          cursorColor: KalyaThiruTheme.primaryMaroon,
          decoration: InputDecoration(
            labelText: lang == 'ta' ? 'சுய அறிமுகம்' : 'About Yourself',
            alignLabelWithHint: true,
          ),
        ),
      ],
    );
  }

  Widget _buildReligiousInfoForm(String lang) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        BottomSheetSelector(
          labelText: lang == 'ta' ? 'மதம்' : 'Religion',
          selectedValue: _religion,
          options: EditProfileOptions.religions,
          onSelected: (val) => setState(() {
            _religion = val;
            _caste = null; // reset caste on religion switch
          }),
        ),
        const SizedBox(height: 20),
        BottomSheetSelector(
          labelText: lang == 'ta' ? 'ஜாதி' : 'Caste / Sect',
          selectedValue: _caste,
          options: EditProfileOptions.getCastesForReligion(_religion),
          onSelected: (val) => setState(() => _caste = val),
        ),
        const SizedBox(height: 20),
        NotchedTextField(
          labelText: lang == 'ta' ? 'உட்பிரிவு' : 'Subcaste',
          controller: _subcasteController,
        ),
        const SizedBox(height: 20),
        BottomSheetSelector(
          labelText: lang == 'ta' ? 'கோத்திரம்' : 'Gothram',
          selectedValue: _gothram,
          options: EditProfileOptions.gothrams,
          onSelected: (val) => setState(() => _gothram = val),
        ),
        const SizedBox(height: 20),
        BottomSheetSelector(
          labelText: lang == 'ta' ? 'ராசி' : 'Raasi',
          selectedValue: _raasi,
          options: EditProfileOptions.raasis,
          onSelected: (val) => setState(() => _raasi = val),
        ),
        const SizedBox(height: 20),
        BottomSheetSelector(
          labelText: lang == 'ta' ? 'நட்சத்திரம்' : 'Star',
          selectedValue: _star,
          options: EditProfileOptions.stars,
          onSelected: (val) => setState(() => _star = val),
        ),
        const SizedBox(height: 20),
        BottomSheetSelector(
          labelText: lang == 'ta' ? 'தோஷம்' : 'Dosham',
          selectedValue: _dosham,
          options: EditProfileOptions.doshams,
          onSelected: (val) => setState(() => _dosham = val),
        ),
      ],
    );
  }

  Widget _buildEducationDetailsForm(String lang, List<String> years) {
    final bool hasDoc = _qualification == 'Doctorate (Ph.D / Research)';
    final bool hasPg = hasDoc || _qualification == 'Post-Graduation (MA, MSc, MBA, ME, etc.)';
    final bool hasUg = hasPg || _qualification == 'Graduation / Bachelors (BA, BSc, BE, BTech, etc.)';
    final bool showPreUgToggle = hasUg;
    final bool hasDiploma = (_qualification == 'Diploma') || (showPreUgToggle && _preUgType == 'diploma');
    final bool hasSchooling = (_qualification == 'Schooling (HSC / SSLC)') || (_qualification == 'Diploma') || (showPreUgToggle && _preUgType == 'schooling');

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        BottomSheetSelector(
          labelText: lang == 'ta' ? 'கல்வித் தகுதி' : 'Highest Qualification',
          selectedValue: _qualification,
          options: EditProfileOptions.qualifications,
          onSelected: (val) => setState(() => _qualification = val),
        ),
        if (hasDoc) ...[
          const SizedBox(height: 24),
          Text(
            lang == 'ta' ? 'முனைவர் பட்ட விவரங்கள்' : 'DOCTORATE DETAILS',
            style: const TextStyle(fontWeight: FontWeight.bold, color: KalyaThiruTheme.primaryMaroon, fontSize: 13),
          ),
          const SizedBox(height: 12),
          NotchedTextField(
            labelText: lang == 'ta' ? 'ஆராய்ச்சிப் பிரிவு' : 'Doctorate Specialization',
            controller: _docSpecializationController,
          ),
          const SizedBox(height: 16),
          NotchedTextField(
            labelText: lang == 'ta' ? 'பல்கலைக்கழகம்' : 'Doctorate University',
            controller: _docUniversityController,
          ),
          const SizedBox(height: 16),
          BottomSheetSelector(
            labelText: lang == 'ta' ? 'தேர்ச்சி பெற்ற ஆண்டு' : 'Doctorate Completed Year',
            selectedValue: _doctorateYear,
            options: years,
            onSelected: (val) => setState(() => _doctorateYear = val),
          ),
        ],
        if (hasPg) ...[
          const SizedBox(height: 24),
          Text(
            lang == 'ta' ? 'முதுகலை விவரங்கள்' : 'POSTGRADUATE DETAILS',
            style: const TextStyle(fontWeight: FontWeight.bold, color: KalyaThiruTheme.primaryMaroon, fontSize: 13),
          ),
          const SizedBox(height: 12),
          BottomSheetSelector(
            labelText: lang == 'ta' ? 'முதுகலை பட்டம்' : 'Postgraduate Degree',
            selectedValue: _pgDegree,
            options: EditProfileOptions.pgDegrees,
            onSelected: (val) => setState(() => _pgDegree = val),
          ),
          const SizedBox(height: 16),
          NotchedTextField(
            labelText: lang == 'ta' ? 'துறை' : 'Postgraduate Specialization',
            controller: _pgSpecializationController,
          ),
          const SizedBox(height: 16),
          NotchedTextField(
            labelText: lang == 'ta' ? 'கல்லூரி / பயின்ற இடம்' : 'Postgraduate Institution',
            controller: _pgInstitutionController,
          ),
          if (_qualification == 'Post-Graduation (MA, MSc, MBA, ME, etc.)') ...[
            const SizedBox(height: 16),
            BottomSheetSelector(
              labelText: lang == 'ta' ? 'தேர்ச்சி பெற்ற ஆண்டு' : 'Postgraduate Completed Year',
              selectedValue: _pgYear,
              options: years,
              onSelected: (val) => setState(() => _pgYear = val),
            ),
          ],
        ],
        if (hasUg) ...[
          const SizedBox(height: 24),
          Text(
            lang == 'ta' ? 'இளங்கலை விவரங்கள்' : 'UNDERGRADUATE DETAILS',
            style: const TextStyle(fontWeight: FontWeight.bold, color: KalyaThiruTheme.primaryMaroon, fontSize: 13),
          ),
          const SizedBox(height: 12),
          BottomSheetSelector(
            labelText: lang == 'ta' ? 'இளங்கலை பட்டம்' : 'Undergraduate Degree',
            selectedValue: _ugDegree,
            options: EditProfileOptions.ugDegrees,
            onSelected: (val) => setState(() => _ugDegree = val),
          ),
          const SizedBox(height: 16),
          NotchedTextField(
            labelText: lang == 'ta' ? 'முக்கிய பாடம்' : 'Undergraduate Major',
            controller: _ugMajorController,
          ),
          const SizedBox(height: 16),
          NotchedTextField(
            labelText: lang == 'ta' ? 'கல்லூரி / பயின்ற இடம்' : 'Undergraduate Institution',
            controller: _ugInstitutionController,
          ),
          if (_qualification == 'Graduation / Bachelors (BA, BSc, BE, BTech, etc.)') ...[
            const SizedBox(height: 16),
            BottomSheetSelector(
              labelText: lang == 'ta' ? 'தேர்ச்சி பெற்ற ஆண்டு' : 'Undergraduate Completed Year',
              selectedValue: _ugYear,
              options: years,
              onSelected: (val) => setState(() => _ugYear = val),
            ),
          ],
        ],
        if (showPreUgToggle) ...[
          const SizedBox(height: 24),
          Text(
            lang == 'ta' ? 'இளங்கலைக்கு முந்தைய கல்வி முறை' : 'PRE-UG PATHWAY',
            style: const TextStyle(fontWeight: FontWeight.bold, color: KalyaThiruTheme.primaryMaroon, fontSize: 13),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: ChoiceChip(
                  label: Center(child: Text(lang == 'ta' ? 'பள்ளிப்படிப்பு' : 'Schooling')),
                  selected: _preUgType == 'schooling',
                  selectedColor: KalyaThiruTheme.primaryMaroon.withOpacity(0.1),
                  labelStyle: TextStyle(
                    color: _preUgType == 'schooling' ? KalyaThiruTheme.primaryMaroon : Colors.black87,
                    fontWeight: FontWeight.bold,
                  ),
                  onSelected: (selected) {
                    if (selected) setState(() => _preUgType = 'schooling');
                  },
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: ChoiceChip(
                  label: Center(child: Text(lang == 'ta' ? 'டிப்ளமோ' : 'Diploma')),
                  selected: _preUgType == 'diploma',
                  selectedColor: KalyaThiruTheme.primaryMaroon.withOpacity(0.1),
                  labelStyle: TextStyle(
                    color: _preUgType == 'diploma' ? KalyaThiruTheme.primaryMaroon : Colors.black87,
                    fontWeight: FontWeight.bold,
                  ),
                  onSelected: (selected) {
                    if (selected) setState(() => _preUgType = 'diploma');
                  },
                ),
              ),
            ],
          ),
        ],
        if (hasDiploma) ...[
          const SizedBox(height: 24),
          Text(
            lang == 'ta' ? 'டிப்ளமோ விவரங்கள்' : 'DIPLOMA DETAILS',
            style: const TextStyle(fontWeight: FontWeight.bold, color: KalyaThiruTheme.primaryMaroon, fontSize: 13),
          ),
          const SizedBox(height: 12),
          NotchedTextField(
            labelText: lang == 'ta' ? 'துறை' : 'Diploma Stream',
            controller: _diplomaStreamController,
          ),
          const SizedBox(height: 16),
          NotchedTextField(
            labelText: lang == 'ta' ? 'பயின்ற நிறுவனம்' : 'Diploma Institution',
            controller: _diplomaInstitutionController,
          ),
          const SizedBox(height: 16),
          BottomSheetSelector(
            labelText: lang == 'ta' ? 'தேர்ச்சி பெற்ற ஆண்டு' : 'Diploma Completed Year',
            selectedValue: _diplomaYear,
            options: years,
            onSelected: (val) => setState(() => _diplomaYear = val),
          ),
        ],
        if (hasSchooling) ...[
          const SizedBox(height: 24),
          Text(
            lang == 'ta' ? 'பள்ளிப்படிப்பு விவரங்கள்' : 'SCHOOLING DETAILS',
            style: const TextStyle(fontWeight: FontWeight.bold, color: KalyaThiruTheme.primaryMaroon, fontSize: 13),
          ),
          const SizedBox(height: 12),
          NotchedTextField(
            labelText: lang == 'ta' ? 'பள்ளியின் பெயர்' : 'Schooling Name',
            controller: _schoolingNameController,
          ),
          const SizedBox(height: 16),
          BottomSheetSelector(
            labelText: lang == 'ta' ? 'கல்வி வாரியம்' : 'Schooling Board',
            selectedValue: _schoolingBoard,
            options: EditProfileOptions.schoolingBoards,
            onSelected: (val) => setState(() => _schoolingBoard = val),
          ),
          const SizedBox(height: 16),
          BottomSheetSelector(
            labelText: lang == 'ta' ? 'தேர்ச்சி பெற்ற ஆண்டு' : 'Schooling Completed Year',
            selectedValue: _schoolingYear,
            options: years,
            onSelected: (val) => setState(() => _schoolingYear = val),
          ),
        ],
      ],
    );
  }

  Widget _buildProfessionalInfoForm(String lang) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        BottomSheetSelector(
          labelText: lang == 'ta' ? 'வேலை வகை' : 'Employment Type',
          selectedValue: _employmentType,
          options: EditProfileOptions.employmentTypes,
          onSelected: (val) => setState(() => _employmentType = val),
        ),
        const SizedBox(height: 20),
        BottomSheetSelector(
          labelText: lang == 'ta' ? 'தொழில் / வேலை' : 'Occupation',
          selectedValue: _occupation,
          options: EditProfileOptions.occupations,
          onSelected: (val) => setState(() => _occupation = val),
        ),
        const SizedBox(height: 20),
        NotchedTextField(
          labelText: lang == 'ta' ? 'தொழில் விவரங்கள்' : 'Occupation Details',
          controller: _occupationDetailController,
        ),
        const SizedBox(height: 20),
        NotchedTextField(
          labelText: lang == 'ta' ? 'நிறுவனத்தின் பெயர்' : 'Organization Name',
          controller: _organizationController,
        ),
        const SizedBox(height: 20),
        BottomSheetSelector(
          labelText: lang == 'ta' ? 'ஆண்டு வருமானம்' : 'Annual Income',
          selectedValue: _annualIncome,
          options: EditProfileOptions.annualIncomes,
          onSelected: (val) => setState(() => _annualIncome = val),
        ),
      ],
    );
  }

  Widget _buildLocationInfoForm(String lang) {
    final countryOptions = _allCountries.isNotEmpty
        ? _allCountries.map((c) => c.name).toList()
        : EditProfileOptions.allCountries;

    final stateOptions = _allStates.isNotEmpty
        ? _allStates.map((s) => s.name).toList()
        : const ['Other'];

    final cityOptions = _allCities.isNotEmpty
        ? _allCities.map((c) => c.name).toList()
        : const ['Other'];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        BottomSheetSelector(
          labelText: lang == 'ta' ? 'குடியுரிமை' : 'Citizenship',
          selectedValue: _citizenship,
          options: EditProfileOptions.citizenships,
          onSelected: (val) => setState(() => _citizenship = val),
        ),
        const SizedBox(height: 20),
        if (_loadingLocations)
          const Padding(
            padding: EdgeInsets.only(bottom: 12.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  width: 14,
                  height: 14,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    valueColor: AlwaysStoppedAnimation<Color>(KalyaThiruTheme.primaryMaroon),
                  ),
                ),
                SizedBox(width: 8),
                Text(
                  "Loading locations...",
                  style: TextStyle(fontSize: 12, color: KalyaThiruTheme.primaryMaroon),
                ),
              ],
            ),
          ),
        BottomSheetSelector(
          labelText: lang == 'ta' ? 'நாடு' : 'Country',
          selectedValue: _country,
          options: countryOptions,
          onSelected: (val) => _onCountryChanged(val),
        ),
        const SizedBox(height: 20),
        BottomSheetSelector(
          labelText: lang == 'ta' ? 'மாநிலம்' : 'State',
          selectedValue: _stateVal,
          options: stateOptions,
          onSelected: (val) => _onStateChanged(val),
        ),
        const SizedBox(height: 20),
        BottomSheetSelector(
          labelText: lang == 'ta' ? 'நகரம்' : 'City',
          selectedValue: _cityVal,
          options: cityOptions,
          onSelected: (val) => setState(() => _cityVal = val),
        ),
        const SizedBox(height: 20),
        NotchedTextField(
          labelText: lang == 'ta' ? 'பரம்பரை இருப்பிடம்' : 'Ancestral Origin',
          controller: _ancestralOriginController,
        ),
      ],
    );
  }

  Widget _buildFamilyDetailsForm(String lang) {
    final siblingOptions = List.generate(5, (index) => index == 4 ? '4+' : index.toString());

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        BottomSheetSelector(
          labelText: lang == 'ta' ? 'குடும்ப விழுமியங்கள்' : 'Family Values',
          selectedValue: _familyValues,
          options: EditProfileOptions.familyValuesList,
          onSelected: (val) => setState(() => _familyValues = val),
        ),
        const SizedBox(height: 20),
        BottomSheetSelector(
          labelText: lang == 'ta' ? 'குடும்ப வகை' : 'Family Type',
          selectedValue: _familyType,
          options: EditProfileOptions.familyTypes,
          onSelected: (val) => setState(() => _familyType = val),
        ),
        const SizedBox(height: 20),
        BottomSheetSelector(
          labelText: lang == 'ta' ? 'குடும்ப நிலை' : 'Family Status',
          selectedValue: _familyStatus,
          options: EditProfileOptions.familyStatusList,
          onSelected: (val) => setState(() => _familyStatus = val),
        ),
        const SizedBox(height: 20),
        BottomSheetSelector(
          labelText: lang == 'ta' ? 'குடும்ப சொத்து விவரம்' : 'Family Wealth',
          selectedValue: _familyWealth,
          options: const ['Below ₹50 Lakhs', '₹50 Lakhs - ₹1 Crore', '₹1 Crore - ₹3 Crores', '₹3 Crores - ₹5 Crores', '₹5 Crores - ₹10 Crores', '₹10 Crores+'],
          onSelected: (val) => setState(() => _familyWealth = val),
        ),
        const SizedBox(height: 20),
        NotchedTextField(
          labelText: lang == 'ta' ? 'பெற்றோர் விவரம் / தொழில்' : 'Parents Info / Occupation',
          controller: _parentsInfoController,
        ),
        const SizedBox(height: 20),
        BottomSheetSelector(
          labelText: lang == 'ta' ? 'சகோதரர்கள் எண்ணிக்கை' : 'No. of Brothers',
          selectedValue: _brothers,
          options: siblingOptions,
          onSelected: (val) => setState(() {
            _brothers = val;
            if (val == '0') _brothersMarried = '0';
          }),
        ),
        const SizedBox(height: 20),
        BottomSheetSelector(
          labelText: lang == 'ta' ? 'திருமணமான சகோதரர்கள்' : 'Brothers Married',
          selectedValue: _brothersMarried,
          options: siblingOptions,
          onSelected: (val) => setState(() => _brothersMarried = val),
        ),
        const SizedBox(height: 20),
        BottomSheetSelector(
          labelText: lang == 'ta' ? 'சகோதரிகள் எண்ணிக்கை' : 'No. of Sisters',
          selectedValue: _sisters,
          options: siblingOptions,
          onSelected: (val) => setState(() {
            _sisters = val;
            if (val == '0') _sistersMarried = '0';
          }),
        ),
        const SizedBox(height: 20),
        BottomSheetSelector(
          labelText: lang == 'ta' ? 'திருமணமான சகோதரிகள்' : 'Sisters Married',
          selectedValue: _sistersMarried,
          options: siblingOptions,
          onSelected: (val) => setState(() => _sistersMarried = val),
        ),
      ],
    );
  }

  Widget _buildHobbiesForm(String lang) {
    final state = context.watch<OnboardingCubit>().state;
    final selectedHobbies = state.selectedHobbies;

    final hobbyHierarchy = {
      'Reading': {
        'tamil': 'வாசிப்பு',
        'genres': ['Novel & Literature', 'Tech & Computer Science', 'History & Biographies', 'Fiction & Fantasy', 'Self Help & Poetry']
      },
      'Music': {
        'tamil': 'இசை',
        'genres': ['Carnatic Classical', 'Tamil Cinema Pop', 'Instrumental & Flute', 'Rock & Indie', 'Western Classical']
      },
      'Cooking': {
        'tamil': 'சமையல்',
        'genres': ['Tamil Traditional', 'South Indian Chettinad', 'North Indian', 'Continental & Baking', 'Chinese & Asian']
      },
      'Gardening': {
        'tamil': 'தோட்டக்கலை',
        'genres': ['Organic Vegetables', 'Bonsai & Flowers', 'Terrace Gardening', 'Indoor Plants']
      },
      'Sports & Fitness': {
        'tamil': 'விளையாட்டு மற்றும் உடற்பயிற்சி',
        'genres': ['Cricket', 'Gym & Weight Training', 'Yoga & Meditation', 'Marathon & Running', 'Badminton / Tennis']
      },
    };

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          lang == 'ta' ? 'உங்கள் பொழுதுபோக்குகள் மற்றும் ஆர்வங்களைத் தேர்ந்தெடுக்கவும். துணை பிரிவுகளைத் தேர்ந்தெடுக்க எந்தப் பொழுதுபோக்கையும் தட்டவும்.' : 'Select your hobbies and interests. Tap any category to deep dive into sub-genres.',
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: KalyaThiruTheme.mutedGray,
              ),
        ),
        const SizedBox(height: 20),
        ...EditProfileOptions.hobbies.map((hobby) {
          final isSelected = selectedHobbies.contains(hobby);
          final details = hobbyHierarchy[hobby]!;
          final displayTitle = lang == 'ta' ? details['tamil'].toString() : hobby;
          final subInterests = state.selectedSubInterests[hobby] ?? [];

          return Card(
            margin: const EdgeInsets.only(bottom: 12),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(4),
              side: BorderSide(
                color: isSelected ? KalyaThiruTheme.primaryMaroon : KalyaThiruTheme.outlineBorder.withOpacity(0.15),
                width: isSelected ? 1.5 : 1,
              ),
            ),
            child: InkWell(
              onTap: () {
                final currentList = List<String>.from(selectedHobbies);
                if (currentList.contains(hobby)) {
                  currentList.remove(hobby);
                  context.read<OnboardingCubit>().updateFields(selectedHobbies: currentList);
                  // Also clean up sub-interests
                  context.read<OnboardingCubit>().updateSubInterest(hobby, []);
                } else {
                  currentList.add(hobby);
                  context.read<OnboardingCubit>().updateFields(selectedHobbies: currentList);
                  // Auto open sub-interest bottom sheet
                  WidgetsBinding.instance.addPostFrameCallback((_) {
                    _openSubInterestSheet(hobby, details);
                  });
                }
              },
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  children: [
                    Checkbox(
                      value: isSelected,
                      activeColor: KalyaThiruTheme.primaryMaroon,
                      onChanged: (val) {
                        final currentList = List<String>.from(selectedHobbies);
                        if (val == true) {
                          currentList.add(hobby);
                          context.read<OnboardingCubit>().updateFields(selectedHobbies: currentList);
                          _openSubInterestSheet(hobby, details);
                        } else {
                          currentList.remove(hobby);
                          context.read<OnboardingCubit>().updateFields(selectedHobbies: currentList);
                          context.read<OnboardingCubit>().updateSubInterest(hobby, []);
                        }
                      },
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            displayTitle,
                            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: isSelected ? KalyaThiruTheme.primaryMaroon : null,
                                ),
                          ),
                          if (isSelected && subInterests.isNotEmpty) ...[
                            const SizedBox(height: 8),
                            Wrap(
                              spacing: 6,
                              runSpacing: 4,
                              children: subInterests.map((sub) {
                                return Chip(
                                  label: Text(
                                    translateOption(sub, lang),
                                    style: const TextStyle(fontSize: 11, color: KalyaThiruTheme.primaryMaroon),
                                  ),
                                  backgroundColor: KalyaThiruTheme.softIvory,
                                  padding: EdgeInsets.zero,
                                  materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                );
                              }).toList(),
                            ),
                          ],
                        ],
                      ),
                    ),
                    if (isSelected)
                      IconButton(
                        icon: const Icon(Icons.edit_note, color: KalyaThiruTheme.primaryMaroon),
                        onPressed: () => _openSubInterestSheet(hobby, details),
                      ),
                  ],
                ),
              ),
            ),
          );
        }),
      ],
    );
  }

  void _openSubInterestSheet(String hobby, Map<String, dynamic> details) {
    final state = context.read<OnboardingCubit>().state;
    final selectedSub = state.selectedSubInterests[hobby] ?? [];

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: KalyaThiruTheme.softIvory,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) {
        return SubInterestSheet(
          title: 'Deep Dive: $hobby',
          tamilTitle: details['tamil']!,
          availableGenres: List<String>.from(details['genres']!),
          selectedGenres: List<String>.from(selectedSub),
          onSaved: (genres) {
            context.read<OnboardingCubit>().updateSubInterest(hobby, genres);
            setState(() {});
          },
        );
      },
    );
  }
}
