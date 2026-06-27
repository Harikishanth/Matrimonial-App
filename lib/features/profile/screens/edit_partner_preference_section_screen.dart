import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../onboarding/cubit/onboarding_cubit.dart';
import '../../../core/theme/theme.dart';
import '../../../core/translation/option_translations.dart';
import '../../../core/widgets/bottom_sheet_selector.dart';
import '../../../core/widgets/notched_text_field.dart';

class EditPartnerPreferenceSectionScreen extends StatefulWidget {
  final String section;

  const EditPartnerPreferenceSectionScreen({
    super.key,
    required this.section,
  });

  @override
  State<EditPartnerPreferenceSectionScreen> createState() => _EditPartnerPreferenceSectionScreenState();
}

class _EditPartnerPreferenceSectionScreenState extends State<EditPartnerPreferenceSectionScreen> {
  final _formKey = GlobalKey<FormState>();

  // Local Form States
  late double _prefMinAge;
  late double _prefMaxAge;
  late double _prefMinHeight;
  late double _prefMaxHeight;
  late List<String> _prefMaritalStatuses;
  late String? _prefReligion;
  late List<String> _prefCastes;
  late bool _prefCasteNoBar;
  late String? _prefSubcaste;
  late String? _prefGothram;
  late String? _prefRaasi;
  late String? _prefStar;
  late String? _prefDosham;
  late List<String> _prefQualifications;
  late List<String> _prefOccupations;
  late String? _prefMinIncome;
  late List<String> _prefEatingHabits;
  late List<String> _prefSmokingHabits;
  late List<String> _prefDrinkingHabits;
  late bool _isCompulsory;

  @override
  void initState() {
    super.initState();
    final state = context.read<OnboardingCubit>().state;
    
    _prefMinAge = state.preferredMinAge.toDouble();
    _prefMaxAge = state.preferredMaxAge.toDouble();
    _prefMinHeight = state.preferredMinHeight;
    _prefMaxHeight = state.preferredMaxHeight;
    _prefMaritalStatuses = List.from(state.preferredMaritalStatuses);
    _prefReligion = state.preferredReligion;
    _prefCastes = List.from(state.preferredCastes);
    _prefCasteNoBar = state.preferredCasteNoBar;
    _prefSubcaste = state.preferredSubcaste;
    _prefGothram = state.preferredGothram;
    _prefRaasi = state.preferredRaasi;
    _prefStar = state.preferredStar;
    _prefDosham = state.preferredDosham;
    _prefQualifications = List.from(state.preferredQualifications);
    _prefOccupations = List.from(state.preferredOccupations);
    _prefMinIncome = state.preferredMinIncome;
    _prefEatingHabits = List.from(state.preferredEatingHabits);
    _prefSmokingHabits = List.from(state.preferredSmokingHabits);
    _prefDrinkingHabits = List.from(state.preferredDrinkingHabits);
    _isCompulsory = state.preferredCompulsoryFields.contains(widget.section);
  }

  int _calculateMatches() {
    int baseMatches = 24850;
    
    // Deduct matches based on chosen strict preferences to simulate dynamic engine calculation
    if (widget.section == 'basic') {
      if (_prefMinAge > 20 || _prefMaxAge < 40) baseMatches -= 4200;
      if (_prefMinHeight > 5.2 || _prefMaxHeight < 6.8) baseMatches -= 3100;
      baseMatches -= (_prefMaritalStatuses.length * 1500);
    } else if (widget.section == 'religion') {
      if (_prefReligion != null) baseMatches -= 8500;
      baseMatches -= (_prefCastes.length * 900);
      if (_prefStar != null && _prefStar != 'Doesn\'t Matter') baseMatches -= 1800;
      if (_prefDosham != null && _prefDosham != 'Doesn\'t Matter') baseMatches -= 1200;
    } else if (widget.section == 'education') {
      baseMatches -= (_prefQualifications.length * 2100);
    } else if (widget.section == 'professional') {
      baseMatches -= (_prefOccupations.length * 1900);
      if (_prefMinIncome != null && _prefMinIncome != 'No Preference') baseMatches -= 3500;
    } else if (widget.section == 'lifestyle') {
      baseMatches -= (_prefEatingHabits.length * 1200);
      baseMatches -= (_prefSmokingHabits.length * 1500);
      baseMatches -= (_prefDrinkingHabits.length * 1400);
    }

    if (_isCompulsory) {
      baseMatches = (baseMatches * 0.75).round(); // Compulsory decreases general pool size
    }

    return baseMatches < 250 ? 250 : baseMatches; // Floor matching count
  }

  List<String> _getCastesForReligion(String? religion) {
    if (religion == 'Hindu') {
      return ['Mudaliar', 'Pillai', 'Vanniyar', 'Gounder', 'Nadar', 'Chettiar', 'Adidravidar', 'Thevar', 'Iyer', 'Iyengar', 'Brahmins'];
    } else if (religion == 'Christian') {
      return ['Roman Catholic', 'Protestant', 'Pentecostal', 'Syrian Christian', 'Other Christian'];
    } else if (religion == 'Muslim') {
      return ['Sunni', 'Shia', 'Lebbai', 'Rawther', 'Marakayar', 'Mapilla', 'Other Muslim'];
    } else {
      return ['Other'];
    }
  }

  void _openMultiSelectSheet({
    required BuildContext context,
    required String title,
    required List<String> allOptions,
    required List<String> selectedList,
    required Function(List<String>) onUpdated,
    required String lang,
  }) {
    showModalBottomSheet(
      context: context,
      backgroundColor: KalyaThiruTheme.softIvory,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: KalyaThiruTheme.primaryMaroon,
                        fontFamily: 'Source Serif 4',
                      ),
                    ),
                    const SizedBox(height: 12),
                    Expanded(
                      child: ListView.builder(
                        itemCount: allOptions.length,
                        itemBuilder: (context, index) {
                          final opt = allOptions[index];
                          final isSelected = selectedList.contains(opt);
                          return CheckboxListTile(
                            title: Text(translateOption(opt, lang), style: const TextStyle(fontSize: 14)),
                            value: isSelected,
                            activeColor: KalyaThiruTheme.primaryMaroon,
                            onChanged: (val) {
                              setModalState(() {
                                if (val == true) {
                                  selectedList.add(opt);
                                } else {
                                  selectedList.remove(opt);
                                }
                              });
                              setState(() {}); // Refresh parent match counter
                              onUpdated(List.from(selectedList));
                            },
                          );
                        },
                      ),
                    ),
                    const SizedBox(height: 12),
                    ElevatedButton(
                      onPressed: () => Navigator.pop(context),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: KalyaThiruTheme.primaryMaroon,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
                        padding: const EdgeInsets.symmetric(vertical: 14),
                      ),
                      child: Text(
                        lang == 'en' ? 'Done' : 'முடிந்தது',
                        style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  void _save(BuildContext context) {
    if (_formKey.currentState?.validate() ?? false) {
      final cubit = context.read<OnboardingCubit>();
      
      // Compute final compulsory fields
      final currentCompulsory = List<String>.from(cubit.state.preferredCompulsoryFields);
      if (_isCompulsory) {
        if (!currentCompulsory.contains(widget.section)) {
          currentCompulsory.add(widget.section);
        }
      } else {
        currentCompulsory.remove(widget.section);
      }

      // Update appropriate fields
      if (widget.section == 'basic') {
        cubit.updateFields(
          preferredMinAge: _prefMinAge.round(),
          preferredMaxAge: _prefMaxAge.round(),
          preferredMinHeight: _prefMinHeight,
          preferredMaxHeight: _prefMaxHeight,
          preferredMaritalStatuses: _prefMaritalStatuses,
          preferredCompulsoryFields: currentCompulsory,
        );
      } else if (widget.section == 'religion') {
        cubit.updateFields(
          preferredReligion: _prefReligion,
          preferredCastes: _prefCastes,
          preferredCasteNoBar: _prefCasteNoBar,
          preferredSubcaste: _prefSubcaste,
          preferredGothram: _prefReligion == 'Hindu' ? _prefGothram : null,
          preferredRaasi: _prefReligion == 'Hindu' ? _prefRaasi : null,
          preferredStar: _prefReligion == 'Hindu' ? _prefStar : null,
          preferredDosham: _prefReligion == 'Hindu' ? _prefDosham : null,
          preferredCompulsoryFields: currentCompulsory,
        );
      } else if (widget.section == 'education') {
        cubit.updateFields(
          preferredQualifications: _prefQualifications,
          preferredCompulsoryFields: currentCompulsory,
        );
      } else if (widget.section == 'professional') {
        cubit.updateFields(
          preferredOccupations: _prefOccupations,
          preferredMinIncome: _prefMinIncome,
          preferredCompulsoryFields: currentCompulsory,
        );
      } else if (widget.section == 'lifestyle') {
        cubit.updateFields(
          preferredEatingHabits: _prefEatingHabits,
          preferredSmokingHabits: _prefSmokingHabits,
          preferredDrinkingHabits: _prefDrinkingHabits,
          preferredCompulsoryFields: currentCompulsory,
        );
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            cubit.state.langCode == 'ta'
                ? 'மாற்றங்கள் வெற்றிகரமாகச் சேமிக்கப்பட்டன!'
                : 'Preferences saved successfully!',
          ),
          backgroundColor: KalyaThiruTheme.primaryMaroon,
        ),
      );
      context.pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = context.watch<OnboardingCubit>().state;
    final String lang = state.langCode;
    final matchCount = _calculateMatches();

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
          _getSectionTitle(widget.section, lang),
          style: const TextStyle(
            color: KalyaThiruTheme.primaryMaroon,
            fontFamily: 'Source Serif 4',
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Form(
        key: _formKey,
        child: Column(
          children: [
            // Sticky Match Count Banner (Editorial visual style)
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: KalyaThiruTheme.primaryMaroon.withValues(alpha: 0.06),
                border: const Border(
                  bottom: BorderSide(color: KalyaThiruTheme.outlineVariant, width: 0.5),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.people, color: KalyaThiruTheme.primaryMaroon, size: 18),
                  const SizedBox(width: 8),
                  Text(
                    lang == 'ta'
                        ? 'பொருத்தமான வரன்கள்: $matchCount'
                        : 'Matching Profiles: $matchCount',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      color: KalyaThiruTheme.primaryMaroon,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),

            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16.0),
                child: Container(
                  padding: const EdgeInsets.all(20.0),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(4),
                    border: Border.all(
                      color: KalyaThiruTheme.outlineBorder.withOpacity(0.15),
                      width: 1,
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      // Render forms dynamically
                      ..._buildFormFields(lang),

                      const SizedBox(height: 24),
                      const Divider(color: KalyaThiruTheme.outlineVariant),
                      const SizedBox(height: 16),

                      // Premium Compulsory Toggle Box
                      Container(
                        padding: const EdgeInsets.all(14),
                        decoration: BoxDecoration(
                          color: KalyaThiruTheme.antiqueGold.withValues(alpha: 0.04),
                          borderRadius: BorderRadius.circular(4),
                          border: Border.all(
                            color: KalyaThiruTheme.antiqueGold.withValues(alpha: 0.25),
                            width: 1,
                          ),
                        ),
                        child: Row(
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    lang == 'ta' ? 'கட்டாய வடிகட்டி' : 'Compulsory Filter',
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: KalyaThiruTheme.antiqueGold,
                                      fontSize: 13,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    lang == 'ta'
                                        ? 'இந்த வடிகட்டியைப் பூர்த்தி செய்யும் வரன்களை மட்டுமே காண்பி.'
                                        : 'Only show profiles matching these specific options strictly.',
                                    style: TextStyle(
                                      color: KalyaThiruTheme.darkCharcoal.withValues(alpha: 0.7),
                                      fontSize: 11,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Switch(
                              value: _isCompulsory,
                              activeColor: KalyaThiruTheme.antiqueGold,
                              onChanged: (val) {
                                setState(() {
                                  _isCompulsory = val;
                                });
                              },
                            ),
                          ],
                        ),
                      ),
                      
                      const SizedBox(height: 32),

                      ElevatedButton(
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
                          lang == 'ta' ? 'விருப்பங்களைச் சேமிக்கவும்' : 'Save Preferences',
                          style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _getSectionTitle(String section, String lang) {
    if (section == 'basic') {
      return lang == 'ta' ? 'அடிப்படை வரன் தேவைகள்' : 'Basic Demographics';
    } else if (section == 'religion') {
      return lang == 'ta' ? 'சமயத் தேவைகள்' : 'Religious Preferences';
    } else if (section == 'education') {
      return lang == 'ta' ? 'கல்வித் தகுதிகள்' : 'Education Details';
    } else if (section == 'professional') {
      return lang == 'ta' ? 'தொழில் & வருமானம்' : 'Professional Preferences';
    } else {
      return lang == 'ta' ? 'வாழ்க்கை முறை' : 'Lifestyle Preferences';
    }
  }

  List<Widget> _buildFormFields(String lang) {
    final religions = ['Hindu', 'Christian', 'Muslim', 'Sikh', 'Buddhist', 'Jain', 'Other'];
    final gothrams = ['Shiva', 'Vishnu', 'Kashyapa', 'Bharadwaja', 'Gautama', 'Vashishta', 'Agastya', 'Atri', 'Angirasa', 'Any Gothram / Open', 'Doesn\'t Matter'];
    final prefRaasis = ['Mesham (Aries)', 'Rishabam (Taurus)', 'Mithunam (Gemini)', 'Katakam (Cancer)', 'Simham (Leo)', 'Kanni (Virgo)', 'Thulam (Libra)', 'Vrishchikam (Scorpio)', 'Dhanusu (Sagittarius)', 'Makaram (Capricorn)', 'Kumbham (Aquarius)', 'Meenam (Pisces)', 'Any Raasi / Open', 'Doesn\'t Matter'];
    final stars = ['Aswini', 'Bharani', 'Krittika', 'Rohini', 'Mrigashirsha', 'Arudra', 'Punarvasu', 'Pushya', 'Ashlesha', 'Magha', 'Poorva Phalguni', 'Uttara Phalguni', 'Hasta', 'Chitra', 'Swati', 'Visakha', 'Anuradha', 'Jyeshta', 'Moola', 'Poorvashada', 'Uttarashada', 'Sravana', 'Dhanishta', 'Shatabhisha', 'Poorvabhadrapada', 'Uttarabhadrapada', 'Revati', 'Any Star / Open', 'Doesn\'t Matter'];
    final prefDoshams = ['None', 'Chevvai (Mars) Dosham', 'Rahu Ketu Dosham', 'Kala Sarpa Dosham', 'Any / Open', 'Don\'t Know', 'Doesn\'t Matter'];
    final incomes = ['Under ₹3 Lakhs', '₹5 Lakhs+', '₹10 Lakhs+', '₹15 Lakhs+', '₹20 Lakhs+', '₹30 Lakhs+', 'No Preference'];
    final maritalOptions = ['Single', 'Divorced', 'Widowed', 'Awaiting Divorce'];
    final qualificationOptions = ['Doctorate', 'Post Graduate', 'Under Graduate', 'Diploma', 'Schooling', 'None'];
    final occupationOptions = ['Software Professional', 'Doctor', 'Engineer', 'Manager', 'Business Owner', 'Teacher', 'Civil Services', 'Other', 'Not Employed'];
    final eatOptions = ['Vegetarian', 'Non-Vegetarian', 'Eggetarian', 'Vegan'];
    final smokeDrinkOptions = ['No', 'Yes', 'Occasionally'];

    if (widget.section == 'basic') {
      return [
        // Age Range Slider
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              lang == 'en' ? 'Age Range' : 'வயது வரம்பு',
              style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: KalyaThiruTheme.darkCharcoal),
            ),
            Text(
              '${_prefMinAge.round()} - ${_prefMaxAge.round()} Yrs',
              style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: KalyaThiruTheme.primaryMaroon),
            ),
          ],
        ),
        RangeSlider(
          values: RangeValues(_prefMinAge, _prefMaxAge),
          min: 18,
          max: 60,
          divisions: 42,
          activeColor: KalyaThiruTheme.primaryMaroon,
          inactiveColor: KalyaThiruTheme.outlineBorder.withOpacity(0.15),
          onChanged: (RangeValues values) {
            setState(() {
              _prefMinAge = values.start;
              _prefMaxAge = values.end;
            });
          },
        ),
        const SizedBox(height: 20),

        // Height Range Slider
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              lang == 'en' ? 'Height Range' : 'உயரம் வரம்பு',
              style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: KalyaThiruTheme.darkCharcoal),
            ),
            Text(
              '${_prefMinHeight.toStringAsFixed(1)}ft - ${_prefMaxHeight.toStringAsFixed(1)}ft',
              style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: KalyaThiruTheme.primaryMaroon),
            ),
          ],
        ),
        RangeSlider(
          values: RangeValues(_prefMinHeight, _prefMaxHeight),
          min: 4.0,
          max: 7.5,
          divisions: 35,
          activeColor: KalyaThiruTheme.primaryMaroon,
          inactiveColor: KalyaThiruTheme.outlineBorder.withOpacity(0.15),
          onChanged: (RangeValues values) {
            setState(() {
              _prefMinHeight = values.start;
              _prefMaxHeight = values.end;
            });
          },
        ),
        const SizedBox(height: 24),

        // Marital Status Chips
        Text(
          lang == 'en' ? 'Marital Status' : 'திருமண நிலை',
          style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: KalyaThiruTheme.darkCharcoal),
        ),
        const SizedBox(height: 10),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: maritalOptions.map((opt) {
            final isSelected = _prefMaritalStatuses.contains(opt);
            return FilterChip(
              label: Text(translateOption(opt, lang)),
              selected: isSelected,
              selectedColor: KalyaThiruTheme.primaryMaroon.withOpacity(0.15),
              checkmarkColor: KalyaThiruTheme.primaryMaroon,
              labelStyle: TextStyle(
                color: isSelected ? KalyaThiruTheme.primaryMaroon : KalyaThiruTheme.darkCharcoal,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(4),
                side: BorderSide(
                  color: isSelected ? KalyaThiruTheme.primaryMaroon : KalyaThiruTheme.outlineBorder.withOpacity(0.3),
                ),
              ),
              onSelected: (val) {
                setState(() {
                  if (val) {
                    _prefMaritalStatuses.add(opt);
                  } else {
                    _prefMaritalStatuses.remove(opt);
                  }
                });
              },
            );
          }).toList(),
        ),
      ];
    } 
    
    if (widget.section == 'religion') {
      return [
        // Preferred Religion
        BottomSheetSelector(
          labelText: lang == 'en' ? 'Preferred Religion' : 'விருப்பமான மதம்',
          selectedValue: _prefReligion,
          options: religions,
          onSelected: (val) {
            setState(() {
              _prefReligion = val;
              _prefCastes = []; // Cascade change: Reset castes selection instantly!
            });
          },
        ),
        const SizedBox(height: 20),

        // Caste Selection Multi-Select trigger (Dynamically updates based on Religion!)
        InkWell(
          onTap: () => _openMultiSelectSheet(
            context: context,
            title: lang == 'en' ? 'Select Preferred Castes' : 'விருப்பமான சாதிகளைத் தேர்ந்தெடுக்கவும்',
            allOptions: _getCastesForReligion(_prefReligion),
            selectedList: _prefCastes,
            onUpdated: (list) => setState(() => _prefCastes = list),
            lang: lang,
          ),
          child: InputDecorator(
            decoration: InputDecoration(
              labelText: lang == 'en' ? 'Preferred Castes' : 'விருப்பமான சாதி',
              suffixIcon: const Icon(Icons.arrow_drop_down),
            ),
            child: Text(
              _prefCastes.isEmpty
                  ? (lang == 'en' ? 'Select Preferred Castes' : 'தேர்ந்தெடுக்கவும்')
                  : _prefCastes.map((c) => translateOption(c, lang)).join(', '),
              style: TextStyle(
                fontSize: 14,
                color: _prefCastes.isEmpty ? KalyaThiruTheme.mutedGray : KalyaThiruTheme.darkCharcoal,
              ),
            ),
          ),
        ),
        const SizedBox(height: 20),

        // Caste No Bar Switch
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              lang == 'en' ? 'Caste No Bar' : 'சாதி தடை இல்லை',
              style: const TextStyle(fontWeight: FontWeight.bold, color: KalyaThiruTheme.darkCharcoal),
            ),
            Switch(
              value: _prefCasteNoBar,
              activeColor: KalyaThiruTheme.primaryMaroon,
              onChanged: (val) => setState(() => _prefCasteNoBar = val),
            ),
          ],
        ),
        const SizedBox(height: 20),

        // Subcaste Text Field
        NotchedTextField(
          labelText: lang == 'en' ? 'Preferred Subcaste' : 'விருப்பமான உட்பிரிவு',
          controller: TextEditingController(text: _prefSubcaste),
          onChanged: (val) => _prefSubcaste = val,
        ),
        const SizedBox(height: 24),

        // Astro Fields (conditional for Hindu)
        if (_prefReligion == 'Hindu') ...[
          const Divider(color: KalyaThiruTheme.outlineVariant),
          const SizedBox(height: 16),
          Text(
            lang == 'en' ? 'ASTROLOGICAL PREFERENCES' : 'ஜாதக விருப்பங்கள்',
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 13,
              color: KalyaThiruTheme.primaryMaroon,
              letterSpacing: 0.8,
            ),
          ),
          const SizedBox(height: 24),
          BottomSheetSelector(
            labelText: lang == 'en' ? 'Preferred Gothram' : 'கோத்திரம்',
            selectedValue: _prefGothram,
            options: gothrams,
            onSelected: (val) => setState(() => _prefGothram = val),
          ),
          const SizedBox(height: 20),
          BottomSheetSelector(
            labelText: lang == 'en' ? 'Preferred Raasi' : 'ராசி',
            selectedValue: _prefRaasi,
            options: prefRaasis,
            onSelected: (val) => setState(() => _prefRaasi = val),
          ),
          const SizedBox(height: 20),
          BottomSheetSelector(
            labelText: lang == 'en' ? 'Preferred Star' : 'நட்சத்திரம்',
            selectedValue: _prefStar,
            options: stars,
            onSelected: (val) => setState(() => _prefStar = val),
          ),
          const SizedBox(height: 20),
          BottomSheetSelector(
            labelText: lang == 'en' ? 'Preferred Dosham' : 'தோஷம்',
            selectedValue: _prefDosham,
            options: prefDoshams,
            onSelected: (val) => setState(() => _prefDosham = val),
          ),
        ]
      ];
    }

    if (widget.section == 'education') {
      return [
        // Education (Qualifications) Multi-Select
        InkWell(
          onTap: () => _openMultiSelectSheet(
            context: context,
            title: lang == 'en' ? 'Select Preferred Qualifications' : 'கல்வித் தகுதிகளைத் தேர்ந்தெடுக்கவும்',
            allOptions: qualificationOptions,
            selectedList: _prefQualifications,
            onUpdated: (list) => setState(() => _prefQualifications = list),
            lang: lang,
          ),
          child: InputDecorator(
            decoration: InputDecoration(
              labelText: lang == 'en' ? 'Preferred Qualifications' : 'விருப்பமான கல்வித் தகுதிகள்',
              suffixIcon: const Icon(Icons.arrow_drop_down),
            ),
            child: Text(
              _prefQualifications.isEmpty
                  ? (lang == 'en' ? 'Select Qualifications' : 'தேர்ந்தெடுக்கவும்')
                  : _prefQualifications.map((q) => translateOption(q, lang)).join(', '),
              style: TextStyle(
                fontSize: 14,
                color: _prefQualifications.isEmpty ? KalyaThiruTheme.mutedGray : KalyaThiruTheme.darkCharcoal,
              ),
            ),
          ),
        ),
      ];
    }

    if (widget.section == 'professional') {
      return [
        // Occupations Multi-Select
        InkWell(
          onTap: () => _openMultiSelectSheet(
            context: context,
            title: lang == 'en' ? 'Select Preferred Occupations' : 'பணிகளைத் தேர்ந்தெடுக்கவும்',
            allOptions: occupationOptions,
            selectedList: _prefOccupations,
            onUpdated: (list) => setState(() => _prefOccupations = list),
            lang: lang,
          ),
          child: InputDecorator(
            decoration: InputDecoration(
              labelText: lang == 'en' ? 'Preferred Occupations' : 'விருப்பமான பணிகள்',
              suffixIcon: const Icon(Icons.arrow_drop_down),
            ),
            child: Text(
              _prefOccupations.isEmpty
                  ? (lang == 'en' ? 'Select Occupations' : 'தேர்ந்தெடுக்கவும்')
                  : _prefOccupations.map((o) => translateOption(o, lang)).join(', '),
              style: TextStyle(
                fontSize: 14,
                color: _prefOccupations.isEmpty ? KalyaThiruTheme.mutedGray : KalyaThiruTheme.darkCharcoal,
              ),
            ),
          ),
        ),
        const SizedBox(height: 20),

        // Income Dropdown
        BottomSheetSelector(
          labelText: lang == 'en' ? 'Minimum Annual Income' : 'குறைந்தபட்ச ஆண்டு வருமானம்',
          selectedValue: _prefMinIncome,
          options: incomes,
          onSelected: (val) => setState(() => _prefMinIncome = val),
        ),
      ];
    }

    // Default: lifestyle section
    return [
      // Eating habits
      Text(
        lang == 'en' ? 'Preferred Eating Habits' : 'உணவுப் பழக்கவழக்கம்',
        style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: KalyaThiruTheme.darkCharcoal),
      ),
      const SizedBox(height: 10),
      Wrap(
        spacing: 8,
        runSpacing: 8,
        children: eatOptions.map((opt) {
          final isSelected = _prefEatingHabits.contains(opt);
          return FilterChip(
            label: Text(translateOption(opt, lang)),
            selected: isSelected,
            selectedColor: KalyaThiruTheme.primaryMaroon.withOpacity(0.15),
            checkmarkColor: KalyaThiruTheme.primaryMaroon,
            labelStyle: TextStyle(
              color: isSelected ? KalyaThiruTheme.primaryMaroon : KalyaThiruTheme.darkCharcoal,
              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(4),
              side: BorderSide(
                color: isSelected ? KalyaThiruTheme.primaryMaroon : KalyaThiruTheme.outlineBorder.withOpacity(0.3),
              ),
            ),
            onSelected: (val) {
              setState(() {
                if (val) {
                  _prefEatingHabits.add(opt);
                } else {
                  _prefEatingHabits.remove(opt);
                }
              });
            },
          );
        }).toList(),
      ),
      const SizedBox(height: 24),

      // Smoking habits
      Text(
        lang == 'en' ? 'Preferred Smoking Habits' : 'புகைப்பிடிக்கும் பழக்கம்',
        style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: KalyaThiruTheme.darkCharcoal),
      ),
      const SizedBox(height: 10),
      Wrap(
        spacing: 8,
        runSpacing: 8,
        children: smokeDrinkOptions.map((opt) {
          final isSelected = _prefSmokingHabits.contains(opt);
          return FilterChip(
            label: Text(translateOption(opt, lang)),
            selected: isSelected,
            selectedColor: KalyaThiruTheme.primaryMaroon.withOpacity(0.15),
            checkmarkColor: KalyaThiruTheme.primaryMaroon,
            labelStyle: TextStyle(
              color: isSelected ? KalyaThiruTheme.primaryMaroon : KalyaThiruTheme.darkCharcoal,
              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(4),
              side: BorderSide(
                color: isSelected ? KalyaThiruTheme.primaryMaroon : KalyaThiruTheme.outlineBorder.withOpacity(0.3),
              ),
            ),
            onSelected: (val) {
              setState(() {
                if (val) {
                  _prefSmokingHabits.add(opt);
                } else {
                  _prefSmokingHabits.remove(opt);
                }
              });
            },
          );
        }).toList(),
      ),
      const SizedBox(height: 24),

      // Drinking habits
      Text(
        lang == 'en' ? 'Preferred Drinking Habits' : 'மது அருந்தும் பழக்கம்',
        style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: KalyaThiruTheme.darkCharcoal),
      ),
      const SizedBox(height: 10),
      Wrap(
        spacing: 8,
        runSpacing: 8,
        children: smokeDrinkOptions.map((opt) {
          final isSelected = _prefDrinkingHabits.contains(opt);
          return FilterChip(
            label: Text(translateOption(opt, lang)),
            selected: isSelected,
            selectedColor: KalyaThiruTheme.primaryMaroon.withOpacity(0.15),
            checkmarkColor: KalyaThiruTheme.primaryMaroon,
            labelStyle: TextStyle(
              color: isSelected ? KalyaThiruTheme.primaryMaroon : KalyaThiruTheme.darkCharcoal,
              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(4),
              side: BorderSide(
                color: isSelected ? KalyaThiruTheme.primaryMaroon : KalyaThiruTheme.outlineBorder.withOpacity(0.3),
              ),
            ),
            onSelected: (val) {
              setState(() {
                if (val) {
                  _prefDrinkingHabits.add(opt);
                } else {
                  _prefDrinkingHabits.remove(opt);
                }
              });
            },
          );
        }).toList(),
      ),
    ];
  }
}
