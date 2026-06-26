import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../onboarding/cubit/onboarding_cubit.dart';
import '../../../core/theme/theme.dart';
import '../../../core/translation/option_translations.dart';
import '../../../core/widgets/bottom_sheet_selector.dart';
import '../../../core/widgets/notched_text_field.dart';

class EditPartnerPreferenceScreen extends StatefulWidget {
  const EditPartnerPreferenceScreen({super.key});

  @override
  State<EditPartnerPreferenceScreen> createState() => _EditPartnerPreferenceScreenState();
}

class _EditPartnerPreferenceScreenState extends State<EditPartnerPreferenceScreen> {
  final _formKey = GlobalKey<FormState>();
  
  double _prefMinAge = 21;
  double _prefMaxAge = 35;
  double _prefMinHeight = 5.0;
  double _prefMaxHeight = 6.5;
  String? _prefReligion;
  List<String> _prefCastes = [];
  bool _prefCasteNoBar = false;
  final _prefSubcasteController = TextEditingController();
  String? _prefGothram;
  String? _prefStar;
  String? _prefMinIncome;
  String? _prefRaasi;
  String? _prefDosham;

  @override
  void initState() {
    super.initState();
    final state = context.read<OnboardingCubit>().state;
    _prefMinAge = state.preferredMinAge.toDouble();
    _prefMaxAge = state.preferredMaxAge.toDouble();
    _prefMinHeight = state.preferredMinHeight;
    _prefMaxHeight = state.preferredMaxHeight;
    _prefReligion = state.preferredReligion;
    _prefCastes = List.from(state.preferredCastes);
    _prefCasteNoBar = state.preferredCasteNoBar;
    _prefSubcasteController.text = state.preferredSubcaste ?? '';
    _prefGothram = state.preferredGothram;
    _prefStar = state.preferredStar;
    _prefMinIncome = state.preferredMinIncome;
    _prefRaasi = state.preferredRaasi;
    _prefDosham = state.preferredDosham;
  }

  @override
  void dispose() {
    _prefSubcasteController.dispose();
    super.dispose();
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

  void _openCasteMultiSelect(String lang) {
    final castes = _getCastesForReligion(_prefReligion);
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
                      lang == 'en' ? 'Select Preferred Castes' : 'விருப்பமான சாதிகளைத் தேர்ந்தெடுக்கவும்',
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
                        itemCount: castes.length,
                        itemBuilder: (context, index) {
                          final caste = castes[index];
                          final isSelected = _prefCastes.contains(caste);
                          return CheckboxListTile(
                            title: Text(translateOption(caste, lang), style: const TextStyle(fontSize: 14)),
                            value: isSelected,
                            activeColor: KalyaThiruTheme.primaryMaroon,
                            onChanged: (val) {
                              setModalState(() {
                                if (val == true) {
                                  _prefCastes.add(caste);
                                } else {
                                  _prefCastes.remove(caste);
                                }
                              });
                              setState(() {}); // Refresh parent screen
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
      context.read<OnboardingCubit>().updateFields(
            preferredMinAge: _prefMinAge.round(),
            preferredMaxAge: _prefMaxAge.round(),
            preferredMinHeight: _prefMinHeight,
            preferredMaxHeight: _prefMaxHeight,
            preferredReligion: _prefReligion,
            preferredCastes: _prefCastes,
            preferredCasteNoBar: _prefCasteNoBar,
            preferredSubcaste: _prefSubcasteController.text,
            preferredGothram: _prefReligion == 'Hindu' ? _prefGothram : null,
            preferredRaasi: _prefReligion == 'Hindu' ? _prefRaasi : null,
            preferredStar: _prefReligion == 'Hindu' ? _prefStar : null,
            preferredDosham: _prefReligion == 'Hindu' ? _prefDosham : null,
            preferredMinIncome: _prefMinIncome,
          );
      
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            context.read<OnboardingCubit>().state.langCode == 'ta'
                ? 'வாழ்க்கைத்துணை விருப்பங்கள் வெற்றிகரமாக சேமிக்கப்பட்டன!'
                : 'Partner preferences saved successfully!',
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

    final religions = ['Hindu', 'Christian', 'Muslim', 'Sikh', 'Buddhist', 'Jain', 'Other'];
    final gothrams = ['Shiva', 'Vishnu', 'Kashyapa', 'Bharadwaja', 'Gautama', 'Vashishta', 'Agastya', 'Atri', 'Angirasa', 'Any Gothram / Open', 'Doesn\'t Matter'];
    final prefRaasis = ['Mesham (Aries)', 'Rishabam (Taurus)', 'Mithunam (Gemini)', 'Katakam (Cancer)', 'Simham (Leo)', 'Kanni (Virgo)', 'Thulam (Libra)', 'Vrishchikam (Scorpio)', 'Dhanusu (Sagittarius)', 'Makaram (Capricorn)', 'Kumbham (Aquarius)', 'Meenam (Pisces)', 'Any Raasi / Open', 'Doesn\'t Matter'];
    final stars = ['Aswini', 'Bharani', 'Krittika', 'Rohini', 'Mrigashirsha', 'Arudra', 'Punarvasu', 'Pushya', 'Ashlesha', 'Magha', 'Poorva Phalguni', 'Uttara Phalguni', 'Hasta', 'Chitra', 'Swati', 'Visakha', 'Anuradha', 'Jyeshta', 'Moola', 'Poorvashada', 'Uttarashada', 'Sravana', 'Dhanishta', 'Shatabhisha', 'Poorvabhadrapada', 'Uttarabhadrapada', 'Revati', 'Any Star / Open', 'Doesn\'t Matter'];
    final prefDoshams = ['None', 'Chevvai (Mars) Dosham', 'Rahu Ketu Dosham', 'Kala Sarpa Dosham', 'Any / Open', 'Don\'t Know', 'Doesn\'t Matter'];
    final incomes = ['Under ₹3 Lakhs', '₹5 Lakhs+', '₹10 Lakhs+', '₹15 Lakhs+', '₹20 Lakhs+', '₹30 Lakhs+', 'No Preference'];

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
          lang == 'ta' ? 'துணை விருப்பங்களைத் திருத்தவும்' : 'Edit Partner Preference',
          style: const TextStyle(
            color: KalyaThiruTheme.primaryMaroon,
            fontFamily: 'Source Serif 4',
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          // Language toggle
          TextButton.icon(
            onPressed: () => context.read<OnboardingCubit>().toggleLanguage(),
            icon: const Icon(Icons.language, color: KalyaThiruTheme.primaryMaroon, size: 18),
            label: Text(
              lang == 'en' ? 'தமிழ்' : 'English',
              style: const TextStyle(
                color: KalyaThiruTheme.primaryMaroon,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: Form(
        key: _formKey,
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
                // Section Header
                Text(
                  lang == 'en' ? 'DEMOGRAPHICS & RELIGION' : 'இருப்பிடம் மற்றும் சமய விருப்பங்கள்',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 13,
                    color: KalyaThiruTheme.primaryMaroon,
                    letterSpacing: 0.8,
                  ),
                ),
                const SizedBox(height: 24),

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

                // Religion Selection
                BottomSheetSelector(
                  labelText: lang == 'en' ? 'Preferred Religion' : 'விருப்பமான மதம்',
                  selectedValue: _prefReligion,
                  options: religions,
                  onSelected: (val) {
                    setState(() {
                      _prefReligion = val;
                      _prefCastes = []; // Reset castes on change
                    });
                  },
                ),
                const SizedBox(height: 20),

                // Caste Selection Multi-Select trigger
                InkWell(
                  onTap: () => _openCasteMultiSelect(lang),
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
                      onChanged: (val) {
                        setState(() {
                          _prefCasteNoBar = val;
                        });
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 20),

                // Subcaste Text Field
                NotchedTextField(
                  labelText: lang == 'en' ? 'Preferred Subcaste' : 'விருப்பமான உட்பிரிவு',
                  controller: _prefSubcasteController,
                ),
                const SizedBox(height: 24),

                // Hindu Conditional Fields
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
                  const SizedBox(height: 24),
                ],

                const Divider(color: KalyaThiruTheme.outlineVariant),
                const SizedBox(height: 16),
                Text(
                  lang == 'en' ? 'FINANCIAL PREFERENCES' : 'வருமான வரம்புகள்',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 13,
                    color: KalyaThiruTheme.primaryMaroon,
                    letterSpacing: 0.8,
                  ),
                ),
                const SizedBox(height: 24),

                BottomSheetSelector(
                  labelText: lang == 'en' ? 'Minimum Annual Income' : 'குறைந்தபட்ச ஆண்டு வருமானம்',
                  selectedValue: _prefMinIncome,
                  options: incomes,
                  onSelected: (val) => setState(() => _prefMinIncome = val),
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
                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
