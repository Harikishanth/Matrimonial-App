import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:country_state_city/country_state_city.dart' as csc;
import '../../../core/theme/theme.dart';
import '../../../core/translation/translations.dart';
import '../../../core/translation/option_translations.dart';
import '../../../core/translation/geographic_helper.dart';
import '../../../core/widgets/notched_text_field.dart';
import '../../../core/widgets/regal_button.dart';
import '../../../core/widgets/bottom_sheet_selector.dart';
import '../../../core/widgets/sub_interest_sheet.dart';
import '../cubit/onboarding_cubit.dart';

// --- SHARED ONBOARDING LAYOUT WRAPPER ---
class OnboardingLayoutWrapper extends StatelessWidget {
  final int step;
  final String stepIndicator;
  final String title;
  final Widget child;
  final VoidCallback onContinue;
  final bool isContinueEnabled;

  const OnboardingLayoutWrapper({
    super.key,
    required this.step,
    required this.stepIndicator,
    required this.title,
    required this.child,
    required this.onContinue,
    this.isContinueEnabled = true,
  });

  @override
  Widget build(BuildContext context) {
    final state = context.watch<OnboardingCubit>().state;
    final cubit = context.read<OnboardingCubit>();
    final String lang = state.langCode;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: KalyaThiruTheme.primaryMaroon),
          onPressed: () {
            if (step > 1) {
              cubit.updateStep(step - 1);
              context.go('/onboarding/step${step - 1}');
            } else {
              context.go('/entry');
            }
          },
        ),
        title: Text(
          stepIndicator,
          style: Theme.of(context).textTheme.labelLarge,
        ),
        centerTitle: false,
        actions: [
          TextButton.icon(
            onPressed: () => cubit.toggleLanguage(),
            icon: const Icon(Icons.language, color: KalyaThiruTheme.primaryMaroon, size: 18),
            label: Text(
              lang == 'en' ? 'தமிழ்' : 'English',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: KalyaThiruTheme.primaryMaroon,
                    fontWeight: FontWeight.bold,
                  ),
            ),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: Column(
        children: [
          // Linear Progress Indicator
          LinearProgressIndicator(
            value: step / 11.0,
            backgroundColor: KalyaThiruTheme.outlineVariant,
            color: KalyaThiruTheme.primaryMaroon,
            minHeight: 3,
          ),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    title,
                    style: Theme.of(context).textTheme.headlineLarge,
                  ),
                  const SizedBox(height: 24),
                  child,
                ],
              ),
            ),
          ),
          // Continue Button Footer Bar
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
              child: RegalButton(
                label: AppTranslations.translate('continue', lang),
                onPressed: isContinueEnabled ? onContinue : null,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// --- STEP 1: PROFILE FOR ---
class OnboardingStep1Screen extends StatelessWidget {
  const OnboardingStep1Screen({super.key});

  @override
  Widget build(BuildContext context) {
    final state = context.watch<OnboardingCubit>().state;
    final cubit = context.read<OnboardingCubit>();
    final String lang = state.langCode;

    // 9 profile relations with bilingual labels
    final List<Map<String, dynamic>> options = [
      {
        'key': 'myself',
        'icon': Icons.person,
        'labelEn': 'Myself',
        'labelTa': 'எனக்காக',
      },
      {
        'key': 'daughter',
        'icon': Icons.girl,
        'labelEn': 'Daughter',
        'labelTa': 'மகளுக்காக',
      },
      {
        'key': 'son',
        'icon': Icons.boy,
        'labelEn': 'Son',
        'labelTa': 'மகனுக்காக',
      },
      {
        'key': 'sister',
        'icon': Icons.person_outline,
        'labelEn': 'Sister',
        'labelTa': 'சகோதரிக்காக',
      },
      {
        'key': 'brother',
        'icon': Icons.person_outline,
        'labelEn': 'Brother',
        'labelTa': 'சகோதரனுக்காக',
      },
      {
        'key': 'relative',
        'icon': Icons.people_outline,
        'labelEn': 'Relative',
        'labelTa': 'உறவினருக்காக',
      },
      {
        'key': 'friend',
        'icon': Icons.emoji_people,
        'labelEn': 'Friend',
        'labelTa': 'நண்பருக்காக',
      },
      {
        'key': 'father',
        'icon': Icons.elderly,
        'labelEn': 'Father',
        'labelTa': 'தந்தைக்கு',
      },
      {
        'key': 'mother',
        'icon': Icons.elderly_woman,
        'labelEn': 'Mother',
        'labelTa': 'தாய்க்கு',
      },
    ];

    final List<String> motherTonguesList = [
      'Tamil (தமிழ்)',
      'Telugu (தெலுங்கு)',
      'Kannada (கன்னடம்)',
      'Malayalam (மலையாளம்)',
      'Hindi (இந்தி)',
      'Urdu (உருது)',
      'English (ஆங்கிலம்)',
      'Marathi (மராத்தி)',
      'Gujarati (குஜராத்தி)',
      'Bengali (பெங்காலி)',
      'Punjabi (பஞ்சாபி)',
      'Odia (ஒடியா)',
      'Other (இதர)',
    ];

    return OnboardingLayoutWrapper(
      step: 1,
      stepIndicator: AppTranslations.translate('step1_indicator', lang),
      title: AppTranslations.translate('step1_title', lang),
      isContinueEnabled: state.profileFor != null && state.motherTongue != null,
      onContinue: () {
        cubit.updateStep(2);
        context.go('/onboarding/step2');
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            AppTranslations.translate('step1_subtitle', lang),
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: KalyaThiruTheme.mutedGray,
                  fontSize: 14,
                ),
          ),
          const SizedBox(height: 24),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              childAspectRatio: 0.95, // fits the illustration container and bilingual labels comfortably
            ),
            itemCount: options.length,
            itemBuilder: (context, index) {
              final opt = options[index];
              final String key = opt['key'];
              final String labelEn = opt['labelEn'];
              final String labelTa = opt['labelTa'];
              final bool isSelected = state.profileFor == key;

              return InkWell(
                onTap: () => cubit.updateFields(profileFor: key),
                borderRadius: BorderRadius.circular(8),
                child: Container(
                  decoration: BoxDecoration(
                    color: isSelected ? const Color(0xFFFDFBF7) : Colors.white,
                    border: Border.all(
                      color: isSelected ? KalyaThiruTheme.primaryMaroon : KalyaThiruTheme.outlineBorder.withValues(alpha: 0.4),
                      width: isSelected ? 2.0 : 1.0,
                    ),
                    borderRadius: BorderRadius.circular(8),
                    boxShadow: isSelected
                        ? [
                            BoxShadow(
                              color: KalyaThiruTheme.primaryMaroon.withValues(alpha: 0.06),
                              blurRadius: 6,
                              offset: const Offset(0, 2),
                            )
                          ]
                        : [],
                  ),
                  child: Stack(
                    children: [
                      // Content of the card
                      Center(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 8.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              // Cream rounded-circle background container for the illustration
                              Container(
                                width: 56,
                                height: 56,
                                decoration: BoxDecoration(
                                  color: const Color(0xFFF3EDE9), // Sandalwood / Cream background matching design
                                  borderRadius: BorderRadius.circular(28),
                                ),
                                padding: const EdgeInsets.all(6),
                                child: Image.asset(
                                  'assets/images/onboarding/$key.png',
                                  fit: BoxFit.contain,
                                  errorBuilder: (context, error, stackTrace) {
                                    // Fallback Icon if asset fails to load
                                    return Icon(
                                      opt['icon'],
                                      color: isSelected ? KalyaThiruTheme.primaryMaroon : KalyaThiruTheme.mutedGray,
                                      size: 24,
                                    );
                                  },
                                ),
                              ),
                              const SizedBox(height: 12),
                              Text(
                                lang == 'en' ? labelEn : labelTa,
                                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                      fontWeight: isSelected ? FontWeight.bold : FontWeight.w600,
                                      color: isSelected ? KalyaThiruTheme.primaryMaroon : KalyaThiruTheme.darkCharcoal,
                                      fontSize: 14,
                                    ),
                                textAlign: TextAlign.center,
                              ),
                              const SizedBox(height: 2),
                              Text(
                                lang == 'en' ? labelTa : labelEn,
                                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                      fontSize: 11,
                                      color: isSelected
                                          ? KalyaThiruTheme.primaryMaroon.withValues(alpha: 0.6)
                                          : KalyaThiruTheme.mutedGray,
                                    ),
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                        ),
                      ),
                      // Top-right Antique Gold selection checkmark
                      if (isSelected)
                        const Positioned(
                          top: 8,
                          right: 8,
                          child: Icon(
                            Icons.check_circle,
                            color: Color(0xFFD4AF37), // Antique gold
                            size: 18,
                          ),
                        ),
                    ],
                  ),
                ),
              );
            },
          ),
          const SizedBox(height: 32),

          // Mother Tongue Selection
          Text(
            lang == 'en' ? 'MOTHER TONGUE *' : 'தாய்மொழி *',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 11,
              letterSpacing: 0.8,
              color: KalyaThiruTheme.mutedGray,
            ),
          ),
          const SizedBox(height: 8),
          BottomSheetSelector(
            labelText: lang == 'en' ? 'Select Mother Tongue' : 'தாய்மொழி தேர்ந்தெடுக்கவும்',
            selectedValue: state.motherTongue,
            options: motherTonguesList,
            onSelected: (val) {
              cubit.updateFields(motherTongue: val);
            },
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }
}


// --- STEP 2: PERSONAL DETAILS ---
class OnboardingStep2Screen extends StatefulWidget {
  const OnboardingStep2Screen({super.key});

  @override
  State<OnboardingStep2Screen> createState() => _OnboardingStep2ScreenState();
}

class _OnboardingStep2ScreenState extends State<OnboardingStep2Screen> {
  final _formKey = GlobalKey<FormState>();
  final _firstController = TextEditingController();
  final _middleController = TextEditingController();
  final _lastController = TextEditingController();
  final _dobController = TextEditingController();
  String? _gender;

  @override
  void initState() {
    super.initState();
    final state = context.read<OnboardingCubit>().state;
    _firstController.text = state.firstName ?? '';
    _middleController.text = state.middleName ?? '';
    _lastController.text = state.lastName ?? '';
    _dobController.text = state.dob ?? '';
    _gender = state.gender;

    _firstController.addListener(_onTextChanged);
    _lastController.addListener(_onTextChanged);
    _dobController.addListener(_onTextChanged);
  }

  void _onTextChanged() {
    setState(() {});
  }

  @override
  void dispose() {
    _firstController.removeListener(_onTextChanged);
    _lastController.removeListener(_onTextChanged);
    _dobController.removeListener(_onTextChanged);
    _firstController.dispose();
    _middleController.dispose();
    _lastController.dispose();
    _dobController.dispose();
    super.dispose();
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
        _dobController.text = "${picked.year}-${picked.month.toString().padLeft(2, '0')}-${picked.day.toString().padLeft(2, '0')}";
      });
    }
  }

  void _saveAndContinue() {
    final state = context.read<OnboardingCubit>().state;
    final isSelf = state.profileFor == 'myself';
    if (_formKey.currentState!.validate() && (isSelf || _gender != null)) {
      context.read<OnboardingCubit>().updateFields(
            firstName: _firstController.text,
            middleName: _middleController.text,
            lastName: _lastController.text,
            dob: _dobController.text,
            gender: isSelf ? 'Male' : _gender, // Default self to Male or custom if needed
          );
      context.read<OnboardingCubit>().updateStep(3);
      context.go('/onboarding/step3');
    }
  }

  Widget _buildGenderCard(String value, IconData icon, String label) {
    final isSelected = _gender == value;
    return Expanded(
      child: InkWell(
        onTap: () {
          setState(() {
            _gender = value;
          });
        },
        borderRadius: BorderRadius.circular(8),
        child: Container(
          height: 50,
          decoration: BoxDecoration(
            color: isSelected ? KalyaThiruTheme.softIvory : Colors.white,
            border: Border.all(
              color: isSelected ? KalyaThiruTheme.primaryMaroon : KalyaThiruTheme.outlineBorder.withValues(alpha: 0.4),
              width: isSelected ? 1.5 : 1.0,
            ),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                size: 18,
                color: isSelected ? KalyaThiruTheme.primaryMaroon : KalyaThiruTheme.mutedGray,
              ),
              const SizedBox(width: 6),
              Text(
                label,
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.w600,
                  color: isSelected ? KalyaThiruTheme.primaryMaroon : KalyaThiruTheme.darkCharcoal,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final state = context.watch<OnboardingCubit>().state;
    final String lang = state.langCode;
    final isSelf = state.profileFor == 'myself';

    final subtitleText = isSelf
        ? (lang == 'en' ? 'Tell us a bit about yourself' : 'உங்களைப் பற்றி கொஞ்சம் சொல்லுங்கள்')
        : (lang == 'en' ? 'Tell us a bit about the person' : 'நம்பகமான வரன் தேடலுக்கு இவரின் விவரங்கள் தேவை');

    final bool isContinueEnabled = _firstController.text.trim().isNotEmpty &&
        _lastController.text.trim().isNotEmpty &&
        _dobController.text.trim().isNotEmpty &&
        (isSelf || _gender != null);

    return OnboardingLayoutWrapper(
      step: 2,
      stepIndicator: AppTranslations.translate('step2_indicator', lang),
      title: AppTranslations.translate('step2_title', lang),
      isContinueEnabled: isContinueEnabled,
      onContinue: _saveAndContinue,
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              subtitleText,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: KalyaThiruTheme.mutedGray,
                    fontSize: 14,
                  ),
            ),
            const SizedBox(height: 24),
            NotchedTextField(
              labelText: AppTranslations.translate('first_name', lang),
              controller: _firstController,
              validator: (v) => v == null || v.isEmpty ? 'First Name required' : null,
            ),
            const SizedBox(height: 20),
            NotchedTextField(
              labelText: AppTranslations.translate('middle_name', lang),
              controller: _middleController,
            ),
            const SizedBox(height: 20),
            NotchedTextField(
              labelText: AppTranslations.translate('last_name', lang),
              controller: _lastController,
              validator: (v) => v == null || v.isEmpty ? 'Last Name required' : null,
            ),
            const SizedBox(height: 20),
            // Date of birth notched selector
            NotchedTextField(
              labelText: AppTranslations.translate('dob', lang),
              controller: _dobController,
              readOnly: true,
              onTap: () => _selectDate(context),
              suffixIcon: const Icon(Icons.calendar_today, color: KalyaThiruTheme.mutedGray, size: 20),
              validator: (v) => v == null || v.isEmpty ? 'DOB required' : null,
            ),
            const SizedBox(height: 24),

            // Gender Segmented Selection (Hidden if Myself)
            if (!isSelf) ...[
              Text(
                lang == 'en' ? 'GENDER *' : 'பாலினம் *',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 11,
                  letterSpacing: 0.8,
                  color: KalyaThiruTheme.mutedGray,
                ),
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  _buildGenderCard('Male', Icons.male, lang == 'en' ? 'Male' : 'ஆண்'),
                  const SizedBox(width: 8),
                  _buildGenderCard('Female', Icons.female, lang == 'en' ? 'Female' : 'பெண்'),
                  const SizedBox(width: 8),
                  _buildGenderCard('Other', Icons.transgender, lang == 'en' ? 'Other' : 'இதர'),
                ],
              ),
              const SizedBox(height: 24),
            ],

            // Gold Shield Privacy Box
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFFFFFBF2),
                border: Border.all(
                  color: KalyaThiruTheme.antiqueGold.withValues(alpha: 0.4),
                  width: 1.0,
                ),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Icon(
                    Icons.gpp_good_outlined,
                    color: KalyaThiruTheme.antiqueGold,
                    size: 24,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          lang == 'en' ? 'Privacy Guaranteed' : 'தனியுரிமை உறுதி செய்யப்பட்டது',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 13,
                            color: KalyaThiruTheme.primaryMaroon,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          lang == 'en'
                              ? 'Your identity remains hidden until you grant access. Standard security procedures apply.'
                              : 'நீங்கள் அணுகல் அனுமதி வழங்கும் வரை உங்கள் விவரங்கள் யாருக்கும் தெரியாது.',
                          style: TextStyle(
                            fontSize: 11,
                            color: KalyaThiruTheme.mutedGray,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}


// --- STEP 3: PHYSICAL & MARITAL STATUS ---
class OnboardingStep3Screen extends StatefulWidget {
  const OnboardingStep3Screen({super.key});

  @override
  State<OnboardingStep3Screen> createState() => _OnboardingStep3ScreenState();
}

class _OnboardingStep3ScreenState extends State<OnboardingStep3Screen> {
  final _formKey = GlobalKey<FormState>();
  String? _height;
  String? _weight;
  String? _physicalStatus;
  String? _maritalStatus;
  String? _childrenCount;

  @override
  void initState() {
    super.initState();
    final state = context.read<OnboardingCubit>().state;
    _height = state.height;
    _weight = state.weight;
    _physicalStatus = state.physicalStatus;
    _maritalStatus = state.maritalStatus;
    _childrenCount = state.childrenCount;
  }

  void _saveAndContinue() {
    if (_formKey.currentState!.validate()) {
      context.read<OnboardingCubit>().updateFields(
            height: _height,
            weight: _weight,
            physicalStatus: _physicalStatus,
            maritalStatus: _maritalStatus,
            childrenCount: (_maritalStatus == 'Never Married' || _maritalStatus == 'திருமணமாகாதவர்') ? null : _childrenCount,
          );
      context.read<OnboardingCubit>().updateStep(4);
      context.go('/onboarding/step4');
    }
  }

  Widget _buildSelectionBlockCard(String label, bool isSelected, VoidCallback onTap, {double height = 65}) {
    return Expanded(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(4),
        child: Container(
          height: height,
          padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
          decoration: BoxDecoration(
            color: isSelected ? KalyaThiruTheme.primaryMaroon : Colors.white,
            border: Border.all(
              color: isSelected ? KalyaThiruTheme.primaryMaroon : KalyaThiruTheme.outlineBorder.withValues(alpha: 0.4),
              width: isSelected ? 1.5 : 1.0,
            ),
            borderRadius: BorderRadius.circular(4),
          ),
          child: Center(
            child: Text(
              label,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 13,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.w600,
                color: isSelected ? Colors.white : KalyaThiruTheme.darkCharcoal,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSmallNumberCard(String label, bool isSelected, VoidCallback onTap) {
    return Expanded(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(4),
        child: Container(
          height: 48,
          decoration: BoxDecoration(
            color: isSelected ? KalyaThiruTheme.primaryMaroon : Colors.white,
            border: Border.all(
              color: isSelected ? KalyaThiruTheme.primaryMaroon : KalyaThiruTheme.outlineBorder.withValues(alpha: 0.4),
              width: isSelected ? 1.5 : 1.0,
            ),
            borderRadius: BorderRadius.circular(4),
          ),
          child: Center(
            child: Text(
              label,
              style: TextStyle(
                fontSize: 14,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.w600,
                color: isSelected ? Colors.white : KalyaThiruTheme.darkCharcoal,
              ),
            ),
          ),
        ),
      ),
    );
  }

  String _getMaritalStatusLabel(int index, String lang, bool isMale, bool isFemale) {
    if (lang == 'ta') {
      switch (index) {
        case 0: return 'திருமணம் ஆகாதவர்';
        case 1: return isMale ? 'மனைவியை இழந்தவர்' : (isFemale ? 'கணவரை இழந்தவர்' : 'துணையை இழந்தவர்');
        case 2: return 'விவாகரத்து பெற்றவர்';
        case 3: return 'விவாகரத்தை எதிர்பார்ப்பவர்';
        default: return '';
      }
    } else {
      switch (index) {
        case 0: return 'Never Married';
        case 1: return isMale ? 'Widower' : (isFemale ? 'Widow' : 'Widowed');
        case 2: return 'Divorced';
        case 3: return 'Awaiting Divorce';
        default: return '';
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = context.watch<OnboardingCubit>().state;
    final String lang = state.langCode;

    final gender = state.gender;
    final isMale = gender == 'Male' || gender == 'male' || gender == 'M' || gender == 'm' || 
                   state.profileFor == 'Son' || state.profileFor == 'Brother' || state.profileFor == 'Father';
    final isFemale = gender == 'Female' || gender == 'female' || gender == 'F' || gender == 'f' || 
                     state.profileFor == 'Daughter' || state.profileFor == 'Sister' || state.profileFor == 'Mother';

    final List<String> heightOptions = List.generate(37, (i) {
      final inchesTotal = 48 + i;
      final ft = inchesTotal ~/ 12;
      final inch = inchesTotal % 12;
      final cm = (inchesTotal * 2.54).round();
      return "$ft ft $inch in ($cm cm)";
    });

    final List<String> weightOptions = List.generate(116, (i) => "${35 + i} kg");

    final physicalStatusLabels = lang == 'en'
        ? {'normal': 'Normal', 'challenged': 'Physically Challenged'}
        : {'normal': 'சாதாரண', 'challenged': 'மாற்றுத்திறனாளி'};

    final isNeverMarried = _maritalStatus == 'Never Married' || _maritalStatus == 'திருமணமாகாதவர்';
    final isWidowed = _maritalStatus == 'Widowed' || _maritalStatus == 'Widower' || _maritalStatus == 'Widow' || _maritalStatus == 'துணையை இழந்தவர்';
    final isAwaitingDivorce = _maritalStatus == 'Awaiting Divorce' || _maritalStatus == 'விவாகரத்துக்காக காத்திருப்பவர்';
    final isDivorced = _maritalStatus == 'Divorced' || _maritalStatus == 'விவாகரத்தானவர்';

    final showChildrenField = _maritalStatus != null && !isNeverMarried;

    final isContinueEnabled = _height != null && 
        _weight != null && 
        _physicalStatus != null && 
        _maritalStatus != null &&
        (!showChildrenField || _childrenCount != null);

    return OnboardingLayoutWrapper(
      step: 3,
      stepIndicator: AppTranslations.translate('step3_indicator', lang),
      title: AppTranslations.translate('step3_title', lang),
      isContinueEnabled: isContinueEnabled,
      onContinue: _saveAndContinue,
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              AppTranslations.translate('step3_subtitle', lang),
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: KalyaThiruTheme.mutedGray,
                    fontSize: 14,
                  ),
            ),
            const SizedBox(height: 24),

            // Height Selector
            BottomSheetSelector(
              labelText: AppTranslations.translate('height_label', lang),
              selectedValue: _height,
              options: heightOptions,
              onSelected: (val) => setState(() => _height = val),
            ),
            const SizedBox(height: 20),

            // Weight Selector
            BottomSheetSelector(
              labelText: AppTranslations.translate('weight_label', lang),
              selectedValue: _weight,
              options: weightOptions,
              onSelected: (val) => setState(() => _weight = val),
            ),
            const SizedBox(height: 20),

            // Physical Status Segmented selector wrapped in InputDecorator
            InputDecorator(
              decoration: InputDecoration(
                labelText: AppTranslations.translate('physical_status_label', lang),
                contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
              ),
              child: Padding(
                padding: const EdgeInsets.only(top: 8),
                child: Row(
                  children: [
                    _buildSelectionBlockCard(
                      physicalStatusLabels['normal']!,
                      _physicalStatus == 'normal',
                      () => setState(() => _physicalStatus = 'normal'),
                      height: 52,
                    ),
                    const SizedBox(width: 12),
                    _buildSelectionBlockCard(
                      physicalStatusLabels['challenged']!,
                      _physicalStatus == 'challenged',
                      () => setState(() => _physicalStatus = 'challenged'),
                      height: 52,
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),

            // Marital Status Selector (2x2 custom cards)
            InputDecorator(
              decoration: InputDecoration(
                labelText: AppTranslations.translate('marital_status_label', lang),
                contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
              ),
              child: Padding(
                padding: const EdgeInsets.only(top: 8),
                child: Column(
                  children: [
                    Row(
                      children: [
                        _buildSelectionBlockCard(
                          _getMaritalStatusLabel(0, lang, isMale, isFemale),
                          isNeverMarried,
                          () {
                            setState(() {
                              _maritalStatus = 'Never Married';
                              _childrenCount = null;
                            });
                          },
                        ),
                        const SizedBox(width: 12),
                        _buildSelectionBlockCard(
                          _getMaritalStatusLabel(1, lang, isMale, isFemale),
                          isWidowed,
                          () {
                            setState(() {
                              _maritalStatus = isMale ? 'Widower' : (isFemale ? 'Widow' : 'Widowed');
                            });
                          },
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        _buildSelectionBlockCard(
                          _getMaritalStatusLabel(3, lang, isMale, isFemale),
                          isAwaitingDivorce,
                          () {
                            setState(() {
                              _maritalStatus = 'Awaiting Divorce';
                            });
                          },
                        ),
                        const SizedBox(width: 12),
                        _buildSelectionBlockCard(
                          _getMaritalStatusLabel(2, lang, isMale, isFemale),
                          isDivorced,
                          () {
                            setState(() {
                              _maritalStatus = 'Divorced';
                            });
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            // No. of Children Selector (Conditional with smooth dropdown animation)
            AnimatedSize(
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeInOut,
              clipBehavior: Clip.hardEdge,
              child: showChildrenField
                  ? Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        const SizedBox(height: 20),
                        InputDecorator(
                          decoration: InputDecoration(
                            labelText: AppTranslations.translate('children_count_label', lang),
                            contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.only(top: 8),
                            child: Row(
                              children: [
                                _buildSmallNumberCard(
                                  lang == 'en' ? 'None' : 'எவருமில்லை',
                                  _childrenCount == 'None' || _childrenCount == 'None (எவருமில்லை)' || _childrenCount == 'எவருமில்லை',
                                  () => setState(() => _childrenCount = 'None'),
                                ),
                                const SizedBox(width: 8),
                                _buildSmallNumberCard(
                                  '1',
                                  _childrenCount == '1',
                                  () => setState(() => _childrenCount = '1'),
                                ),
                                const SizedBox(width: 8),
                                _buildSmallNumberCard(
                                  '2',
                                  _childrenCount == '2',
                                  () => setState(() => _childrenCount = '2'),
                                ),
                                const SizedBox(width: 8),
                                _buildSmallNumberCard(
                                  '3+',
                                  _childrenCount == '3+',
                                  () => setState(() => _childrenCount = '3+'),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    )
                  : const SizedBox(width: double.infinity, height: 0),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}

// --- STEP 4: RELIGION & CASTE ---
class OnboardingStep4Screen extends StatefulWidget {
  const OnboardingStep4Screen({super.key});

  @override
  State<OnboardingStep4Screen> createState() => _OnboardingStep4ScreenState();
}

class _OnboardingStep4ScreenState extends State<OnboardingStep4Screen> {
  String? _religion;
  String? _caste;
  bool _casteNoBar = false;
  final _subcasteController = TextEditingController();
  String? _dosham;
  String? _gothram;
  String? _raasi;
  String? _nakshatra;

  @override
  void initState() {
    super.initState();
    final state = context.read<OnboardingCubit>().state;
    _religion = state.religion;
    _caste = state.caste;
    _casteNoBar = state.casteNoBar;
    _subcasteController.text = state.subcaste ?? '';
    _dosham = state.dosham;
    if (_dosham == 'none') {
      _dosham = 'None';
    }
    _gothram = state.gothram;
    _raasi = state.raasi;
    _nakshatra = state.nakshatra;
  }

  @override
  void dispose() {
    _subcasteController.dispose();
    super.dispose();
  }

  void _saveAndContinue() {
    context.read<OnboardingCubit>().updateFields(
          religion: _religion,
          caste: _casteNoBar ? 'Caste No Bar' : _caste,
          casteNoBar: _casteNoBar,
          subcaste: _subcasteController.text,
          dosham: _religion == 'Hindu' ? _dosham : null,
          gothram: _religion == 'Hindu' ? _gothram : null,
          raasi: _religion == 'Hindu' ? _raasi : null,
          nakshatra: _religion == 'Hindu' ? _nakshatra : null,
        );
    context.read<OnboardingCubit>().updateStep(5);
    context.go('/onboarding/step5');
  }

  List<String> _getCastesForReligion() {
    if (_religion == 'Hindu') {
      return ['Mudaliar', 'Pillai', 'Vanniyar', 'Gounder', 'Nadar', 'Chettiar', 'Adidravidar', 'Thevar', 'Iyer', 'Iyengar', 'Brahmins'];
    } else if (_religion == 'Christian') {
      return ['Roman Catholic', 'Protestant', 'Pentecostal', 'Syrian Christian', 'Other Christian'];
    } else if (_religion == 'Muslim') {
      return ['Sunni', 'Shia', 'Lebbai', 'Rawther', 'Marakayar', 'Mapilla', 'Other Muslim'];
    } else {
      return ['Other'];
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = context.watch<OnboardingCubit>().state;
    final String lang = state.langCode;

    final religions = ['Hindu', 'Christian', 'Muslim', 'Sikh', 'Buddhist', 'Jain', 'Other'];
    final doshams = ['None', 'Chevvai (Mars) Dosham', 'Rahu Ketu Dosham', 'Kala Sarpa Dosham', 'Don\'t Know', 'Doesn\'t Matter'];
    final gothrams = ['Shiva', 'Vishnu', 'Kashyapa', 'Bharadwaja', 'Gautama', 'Vashishta', 'Agastya', 'Atri', 'Angirasa', 'Other', 'Doesn\'t Matter'];
    final raasis = ['Mesham (Aries)', 'Rishabam (Taurus)', 'Mithunam (Gemini)', 'Katakam (Cancer)', 'Simham (Leo)', 'Kanni (Virgo)', 'Thulam (Libra)', 'Vrishchikam (Scorpio)', 'Dhanusu (Sagittarius)', 'Makaram (Capricorn)', 'Kumbham (Aquarius)', 'Meenam (Pisces)', 'Doesn\'t Matter'];
    final stars = ['Aswini', 'Bharani', 'Krittika', 'Rohini', 'Mrigashirsha', 'Arudra', 'Punarvasu', 'Pushya', 'Ashlesha', 'Magha', 'Poorva Phalguni', 'Uttara Phalguni', 'Hasta', 'Chitra', 'Swati', 'Visakha', 'Anuradha', 'Jyeshta', 'Moola', 'Poorvashada', 'Uttarashada', 'Sravana', 'Dhanishta', 'Shatabhisha', 'Poorvabhadrapada', 'Uttarabhadrapada', 'Revati', 'Don\'t Know', 'Doesn\'t Matter'];

    final Map<String, String> doshamLabels = lang == 'en'
        ? {
            'None': 'None',
            'Chevvai (Mars) Dosham': 'Chevvai (Mars) Dosham',
            'Rahu Ketu Dosham': 'Rahu Ketu Dosham',
            'Kala Sarpa Dosham': 'Kala Sarpa Dosham',
            'Don\'t Know': 'Don\'t Know',
            'Doesn\'t Matter': 'Doesn\'t Matter'
          }
        : {
            'None': 'எதுவுமில்லை',
            'Chevvai (Mars) Dosham': 'செவ்வாய் தோஷம்',
            'Rahu Ketu Dosham': 'ராகு கேது தோஷம்',
            'Kala Sarpa Dosham': 'கால சர்ப்ப தோஷம்',
            'Don\'t Know': 'தெரியாது',
            'Doesn\'t Matter': 'முக்கியமில்லை'
          };

    final castesList = _getCastesForReligion();
    final bool isHindu = _religion == 'Hindu';

    final isContinueEnabled = _religion != null && 
        (_casteNoBar || _caste != null) && 
        (!isHindu || (_dosham != null && _gothram != null && _raasi != null && _nakshatra != null));

    return OnboardingLayoutWrapper(
      step: 4,
      stepIndicator: AppTranslations.translate('step4_indicator', lang),
      title: AppTranslations.translate('step4_title', lang),
      isContinueEnabled: isContinueEnabled,
      onContinue: _saveAndContinue,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Religion BottomSheetSelector
          BottomSheetSelector(
            labelText: AppTranslations.translate('religion', lang),
            selectedValue: _religion,
            options: religions,
            onSelected: (val) {
              setState(() {
                _religion = val;
                _caste = null; // Reset caste when religion changes
                if (val != 'Hindu') {
                  _dosham = null;
                  _gothram = null;
                  _raasi = null;
                  _nakshatra = null;
                } else {
                  _dosham ??= 'None';
                }
              });
            },
          ),
          const SizedBox(height: 20),

          // Caste No Bar Switch card
          Card(
            elevation: 0,
            color: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
              side: BorderSide(color: KalyaThiruTheme.outlineBorder.withValues(alpha: 0.3)),
            ),
            child: CheckboxListTile(
              title: Text(
                AppTranslations.translate('caste_no_bar', lang),
                style: TextStyle(fontWeight: FontWeight.bold, color: KalyaThiruTheme.primaryMaroon, fontSize: 14),
              ),
              subtitle: Text(
                AppTranslations.translate('caste_no_bar_desc', lang),
                style: const TextStyle(fontSize: 12),
              ),
              value: _casteNoBar,
              activeColor: KalyaThiruTheme.primaryMaroon,
              onChanged: (val) {
                if (val != null) {
                  setState(() {
                    _casteNoBar = val;
                    if (val) _caste = null;
                  });
                }
              },
            ),
          ),
          const SizedBox(height: 20),

          // Caste selector (Only if Caste No Bar is false and religion is selected)
          if (!_casteNoBar && _religion != null) ...[
            BottomSheetSelector(
              labelText: AppTranslations.translate('caste', lang),
              selectedValue: _caste,
              options: castesList,
              onSelected: (val) => setState(() => _caste = val),
            ),
            const SizedBox(height: 20),
          ],
          NotchedTextField(
            labelText: '${AppTranslations.translate('subcaste', lang)} (Optional)',
            controller: _subcasteController,
          ),

          // Astrological Details (Conditional with smooth dropdown animation when Religion is Hindu)
          AnimatedSize(
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOut,
            clipBehavior: Clip.hardEdge,
            child: isHindu
                ? Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const SizedBox(height: 20),
                      Text(
                        AppTranslations.translate('dosham', lang),
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 11,
                          letterSpacing: 0.8,
                          color: KalyaThiruTheme.mutedGray,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: doshams.map((dosh) {
                          final isSelected = _dosham == dosh;
                          return ChoiceChip(
                            label: Text(doshamLabels[dosh] ?? dosh),
                            selected: isSelected,
                            onSelected: (selected) {
                              setState(() {
                                _dosham = selected ? dosh : null;
                              });
                            },
                            selectedColor: KalyaThiruTheme.softIvory,
                            backgroundColor: Colors.white,
                            labelStyle: TextStyle(
                              color: isSelected ? KalyaThiruTheme.primaryMaroon : KalyaThiruTheme.darkCharcoal,
                              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                              fontSize: 12,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                              side: BorderSide(
                                color: isSelected ? KalyaThiruTheme.primaryMaroon : KalyaThiruTheme.outlineBorder.withValues(alpha: 0.4),
                                width: isSelected ? 1.5 : 1.0,
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                      const SizedBox(height: 20),
                      BottomSheetSelector(
                        labelText: AppTranslations.translate('gothram', lang),
                        selectedValue: _gothram,
                        options: gothrams,
                        onSelected: (val) => setState(() => _gothram = val),
                      ),
                      const SizedBox(height: 20),
                      BottomSheetSelector(
                        labelText: AppTranslations.translate('raasi', lang),
                        selectedValue: _raasi,
                        options: raasis,
                        onSelected: (val) => setState(() => _raasi = val),
                      ),
                      const SizedBox(height: 20),
                      BottomSheetSelector(
                        labelText: AppTranslations.translate('nakshatra', lang),
                        selectedValue: _nakshatra,
                        options: stars,
                        onSelected: (val) => setState(() => _nakshatra = val),
                      ),
                    ],
                  )
                : const SizedBox(width: double.infinity, height: 0),
          ),
          const SizedBox(height: 24),

          // Community Trust Info Box
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: KalyaThiruTheme.outlineBorder.withValues(alpha: 0.3)),
            ),
            child: Row(
              children: [
                const Icon(Icons.info_outline, color: KalyaThiruTheme.antiqueGold),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    AppTranslations.translate('community_trust_desc', lang),
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          fontSize: 12,
                          color: KalyaThiruTheme.mutedGray,
                        ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// --- STEP 5: EDUCATION ---
class OnboardingStep5Screen extends StatefulWidget {
  const OnboardingStep5Screen({super.key});

  @override
  State<OnboardingStep5Screen> createState() => _OnboardingStep5ScreenState();
}

class _OnboardingStep5ScreenState extends State<OnboardingStep5Screen> {
  final _formKey = GlobalKey<FormState>();

  String? _qualification;

  // Doctorate details
  final _docSpecializationController = TextEditingController();
  final _docUniversityController = TextEditingController();
  String? _doctorateYear;

  // Postgraduate details
  String? _pgDegree;
  final _pgSpecializationController = TextEditingController();
  final _pgInstitutionController = TextEditingController();
  String? _pgYear; // Only used if PG is highest

  // Undergraduate details
  String? _ugDegree;
  final _ugMajorController = TextEditingController();
  final _ugInstitutionController = TextEditingController();
  String? _ugYear; // Only used if UG is highest

  // Diploma details
  final _diplomaStreamController = TextEditingController();
  final _diplomaInstitutionController = TextEditingController();
  String? _diplomaYear;

  // Schooling details
  final _schoolingNameController = TextEditingController();
  String? _schoolingBoard;
  String? _schoolingYear;

  // Pre-UG Toggle
  String? _preUgType; // 'schooling' or 'diploma'

  // Temporary mirror variables for UI tracking
  String? _doctorateSpecialization;
  String? _doctorateUniversity;
  String? _pgSpecialization;
  String? _pgInstitution;
  String? _ugMajor;
  String? _ugInstitution;
  String? _diplomaStream;
  String? _diplomaInstitution;
  String? _schoolingName;

  @override
  void initState() {
    super.initState();
    final state = context.read<OnboardingCubit>().state;
    _qualification = state.qualification;
    _doctorateSpecialization = state.doctorateSpecialization;
    _doctorateUniversity = state.doctorateUniversity;
    _doctorateYear = state.doctorateYear;
    _pgDegree = state.pgDegree;
    _pgSpecialization = state.pgSpecialization;
    _pgInstitution = state.pgInstitution;
    _pgYear = state.pgYear;
    _ugDegree = state.ugDegree;
    _ugMajor = state.ugMajor;
    _ugInstitution = state.ugInstitution;
    _ugYear = state.ugYear;
    _diplomaStream = state.diplomaStream;
    _diplomaInstitution = state.diplomaInstitution;
    _diplomaYear = state.diplomaYear;
    _schoolingName = state.schoolingName;
    _schoolingBoard = state.schoolingBoard;
    _schoolingYear = state.schoolingYear;
    _preUgType = state.preUgType ?? 'schooling';

    _docSpecializationController.text = _doctorateSpecialization ?? '';
    _docUniversityController.text = _doctorateUniversity ?? '';
    _pgSpecializationController.text = _pgSpecialization ?? '';
    _pgInstitutionController.text = _pgInstitution ?? '';
    _ugMajorController.text = _ugMajor ?? '';
    _ugInstitutionController.text = _ugInstitution ?? '';
    _diplomaStreamController.text = _diplomaStream ?? '';
    _diplomaInstitutionController.text = _diplomaInstitution ?? '';
    _schoolingNameController.text = _schoolingName ?? '';

    // Listeners to rebuild on text change (for continue button activation)
    _docSpecializationController.addListener(_onTextChanged);
    _docUniversityController.addListener(_onTextChanged);
    _pgSpecializationController.addListener(_onTextChanged);
    _pgInstitutionController.addListener(_onTextChanged);
    _ugMajorController.addListener(_onTextChanged);
    _ugInstitutionController.addListener(_onTextChanged);
    _diplomaStreamController.addListener(_onTextChanged);
    _diplomaInstitutionController.addListener(_onTextChanged);
    _schoolingNameController.addListener(_onTextChanged);
  }

  void _onTextChanged() {
    setState(() {
      _doctorateSpecialization = _docSpecializationController.text;
      _doctorateUniversity = _docUniversityController.text;
      _pgSpecialization = _pgSpecializationController.text;
      _pgInstitution = _pgInstitutionController.text;
      _ugMajor = _ugMajorController.text;
      _ugInstitution = _ugInstitutionController.text;
      _diplomaStream = _diplomaStreamController.text;
      _diplomaInstitution = _diplomaInstitutionController.text;
      _schoolingName = _schoolingNameController.text;
    });
  }

  @override
  void dispose() {
    _docSpecializationController.removeListener(_onTextChanged);
    _docUniversityController.removeListener(_onTextChanged);
    _pgSpecializationController.removeListener(_onTextChanged);
    _pgInstitutionController.removeListener(_onTextChanged);
    _ugMajorController.removeListener(_onTextChanged);
    _ugInstitutionController.removeListener(_onTextChanged);
    _diplomaStreamController.removeListener(_onTextChanged);
    _diplomaInstitutionController.removeListener(_onTextChanged);
    _schoolingNameController.removeListener(_onTextChanged);

    _docSpecializationController.dispose();
    _docUniversityController.dispose();
    _pgSpecializationController.dispose();
    _pgInstitutionController.dispose();
    _ugMajorController.dispose();
    _ugInstitutionController.dispose();
    _diplomaStreamController.dispose();
    _diplomaInstitutionController.dispose();
    _schoolingNameController.dispose();
    super.dispose();
  }

  void _saveAndContinue() {
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

    context.read<OnboardingCubit>().updateFields(
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
    context.read<OnboardingCubit>().updateStep(6);
    context.go('/onboarding/step6');
  }

  Widget _buildSelectionCard(String value, String label, bool isSelected, VoidCallback onTap) {
    return Expanded(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(4),
        child: Container(
          height: 48,
          decoration: BoxDecoration(
            color: isSelected ? KalyaThiruTheme.softIvory : Colors.white,
            border: Border.all(
              color: isSelected ? KalyaThiruTheme.primaryMaroon : KalyaThiruTheme.outlineBorder.withValues(alpha: 0.4),
              width: isSelected ? 1.5 : 1.0,
            ),
            borderRadius: BorderRadius.circular(4),
          ),
          child: Center(
            child: Text(
              label,
              style: TextStyle(
                fontSize: 13,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.w600,
                color: isSelected ? KalyaThiruTheme.primaryMaroon : KalyaThiruTheme.darkCharcoal,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.only(top: 8.0, bottom: 16.0),
      child: Text(
        title.toUpperCase(),
        style: const TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 12,
          letterSpacing: 0.8,
          color: KalyaThiruTheme.primaryMaroon,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final state = context.watch<OnboardingCubit>().state;
    final String lang = state.langCode;

    final years = List.generate(49, (index) => (2028 - index).toString());

    final qualificationMap = {
      'Doctorate (Ph.D / Research)': 'முனைவர் பட்டம் (Ph.D / ஆராய்ச்சி)',
      'Post-Graduation (MA, MSc, MBA, ME, etc.)': 'முதுகலை (MA, MSc, MBA, ME, etc.)',
      'Graduation / Bachelors (BA, BSc, BE, BTech, etc.)': 'இளங்கலை (BA, BSc, BE, BTech, etc.)',
      'Diploma': 'டிப்ளமோ',
      'Schooling (HSC / SSLC)': 'பள்ளிப்படிப்பு (HSC / SSLC)',
      'None': 'ஏதுமில்லை',
    };

    final pgDegreeMap = {
      'M.A': 'M.A (முதுகலை கலைஞர்)',
      'M.Sc': 'M.Sc (முதுகலை அறிவியல்)',
      'M.Com': 'M.Com (முதுகலை வணிகவியல்)',
      'M.B.A': 'M.B.A (நிர்வாக மேலாண்மை)',
      'M.E / M.Tech': 'M.E / M.Tech (முதுகலை பொறியியல்)',
      'M.C.A': 'M.C.A (கணினி பயன்பாடு)',
      'M.D / M.S': 'M.D / M.S (முதுகலை மருத்துவம்)',
      'Other': 'இதர முதுகலை',
    };

    final ugDegreeMap = {
      'B.A': 'B.A (இளங்கலை கலைஞர்)',
      'B.Sc': 'B.Sc (இளங்கலை அறிவியல்)',
      'B.Com': 'B.Com (இளங்கலை வணிகவியல்)',
      'B.B.A': 'B.B.A (நிர்வாக மேலாண்மை)',
      'B.E / B.Tech': 'B.E / B.Tech (இளங்கலை பொறியியல்)',
      'B.C.A': 'B.C.A (கணினி பயன்பாடு)',
      'M.B.B.S / B.D.S': 'M.B.B.S / B.D.S (மருத்துவம்)',
      'Other': 'இதர இளங்கலை',
    };

    final boardMap = {
      'State Board': 'மாநில பாடத்திட்டம் (State Board)',
      'CBSE': 'மத்திய பாடத்திட்டம் (CBSE)',
      'ICSE': 'ஐசிஎஸ்இ (ICSE)',
      'Matriculation': 'மெட்ரிகுலேஷன் (Matriculation)',
      'Other': 'இதர வாரியம்',
    };

    final qualificationsList = lang == 'en' ? qualificationMap.keys.toList() : qualificationMap.values.toList();
    final pgDegreesList = lang == 'en' ? pgDegreeMap.keys.toList() : pgDegreeMap.values.toList();
    final ugDegreesList = lang == 'en' ? ugDegreeMap.keys.toList() : ugDegreeMap.values.toList();
    final boardsList = lang == 'en' ? boardMap.keys.toList() : boardMap.values.toList();

    // Setup selected values mapped appropriately for bilingual display
    final String selectedQual = lang == 'en' ? (_qualification ?? '') : (qualificationMap[_qualification] ?? '');
    final String selectedPgDegree = lang == 'en' ? (_pgDegree ?? '') : (pgDegreeMap[_pgDegree] ?? '');
    final String selectedUgDegree = lang == 'en' ? (_ugDegree ?? '') : (ugDegreeMap[_ugDegree] ?? '');
    final String selectedBoard = lang == 'en' ? (_schoolingBoard ?? '') : (boardMap[_schoolingBoard] ?? '');

    // Dynamic visibility checks
    final bool isNone = _qualification == 'None';
    final bool hasDoc = _qualification == 'Doctorate (Ph.D / Research)';
    final bool hasPg = hasDoc || _qualification == 'Post-Graduation (MA, MSc, MBA, ME, etc.)';
    final bool hasUg = hasPg || _qualification == 'Graduation / Bachelors (BA, BSc, BE, BTech, etc.)';
    
    // Toggle for Pre-UG pathway choice (Schooling or Diploma)
    final bool showPreUgToggle = hasUg;
    
    // Schooling vs Diploma visibility details
    final bool hasDiploma = (_qualification == 'Diploma') || (showPreUgToggle && _preUgType == 'diploma');
    final bool hasSchooling = (_qualification == 'Schooling (HSC / SSLC)') || (_qualification == 'Diploma') || (showPreUgToggle && _preUgType == 'schooling');

    // Validation for continue button
    final String qual = _qualification ?? '';
    bool isContinueEnabled = false;

    if (qual == 'None') {
      isContinueEnabled = true;
    } else if (qual == 'Schooling (HSC / SSLC)') {
      isContinueEnabled = _schoolingName != null &&
          _schoolingName!.trim().isNotEmpty &&
          _schoolingBoard != null &&
          _schoolingYear != null;
    } else if (qual == 'Diploma') {
      isContinueEnabled = _diplomaStream != null &&
          _diplomaStream!.trim().isNotEmpty &&
          _diplomaInstitution != null &&
          _diplomaInstitution!.trim().isNotEmpty &&
          _diplomaYear != null;
    } else if (qual == 'Graduation / Bachelors (BA, BSc, BE, BTech, etc.)') {
      final bool ugComplete = _ugDegree != null &&
          _ugMajor != null &&
          _ugMajor!.trim().isNotEmpty &&
          _ugInstitution != null &&
          _ugInstitution!.trim().isNotEmpty &&
          _ugYear != null;
      bool preUgComplete = false;
      if (_preUgType == 'schooling') {
        preUgComplete = _schoolingName != null &&
            _schoolingName!.trim().isNotEmpty &&
            _schoolingBoard != null &&
            _schoolingYear != null;
      } else if (_preUgType == 'diploma') {
        preUgComplete = _diplomaStream != null &&
            _diplomaStream!.trim().isNotEmpty &&
            _diplomaInstitution != null &&
            _diplomaInstitution!.trim().isNotEmpty &&
            _diplomaYear != null;
      }
      isContinueEnabled = ugComplete && preUgComplete;
    } else if (qual == 'Post-Graduation (MA, MSc, MBA, ME, etc.)') {
      final bool pgComplete = _pgDegree != null &&
          _pgSpecialization != null &&
          _pgSpecialization!.trim().isNotEmpty &&
          _pgInstitution != null &&
          _pgInstitution!.trim().isNotEmpty &&
          _pgYear != null;
      final bool ugComplete = _ugDegree != null &&
          _ugMajor != null &&
          _ugMajor!.trim().isNotEmpty &&
          _ugInstitution != null &&
          _ugInstitution!.trim().isNotEmpty;
      bool preUgComplete = false;
      if (_preUgType == 'schooling') {
        preUgComplete = _schoolingName != null &&
            _schoolingName!.trim().isNotEmpty &&
            _schoolingBoard != null &&
            _schoolingYear != null;
      } else if (_preUgType == 'diploma') {
        preUgComplete = _diplomaStream != null &&
            _diplomaStream!.trim().isNotEmpty &&
            _diplomaInstitution != null &&
            _diplomaInstitution!.trim().isNotEmpty &&
            _diplomaYear != null;
      }
      isContinueEnabled = pgComplete && ugComplete && preUgComplete;
    } else if (qual == 'Doctorate (Ph.D / Research)') {
      final bool docComplete = _doctorateSpecialization != null &&
          _doctorateSpecialization!.trim().isNotEmpty &&
          _doctorateUniversity != null &&
          _doctorateUniversity!.trim().isNotEmpty &&
          _doctorateYear != null;
      final bool pgComplete = _pgDegree != null &&
          _pgSpecialization != null &&
          _pgSpecialization!.trim().isNotEmpty &&
          _pgInstitution != null &&
          _pgInstitution!.trim().isNotEmpty;
      final bool ugComplete = _ugDegree != null &&
          _ugMajor != null &&
          _ugMajor!.trim().isNotEmpty &&
          _ugInstitution != null &&
          _ugInstitution!.trim().isNotEmpty;
      bool preUgComplete = false;
      if (_preUgType == 'schooling') {
        preUgComplete = _schoolingName != null &&
            _schoolingName!.trim().isNotEmpty &&
            _schoolingBoard != null &&
            _schoolingYear != null;
      } else if (_preUgType == 'diploma') {
        preUgComplete = _diplomaStream != null &&
            _diplomaStream!.trim().isNotEmpty &&
            _diplomaInstitution != null &&
            _diplomaInstitution!.trim().isNotEmpty &&
            _diplomaYear != null;
      }
      isContinueEnabled = docComplete && pgComplete && ugComplete && preUgComplete;
    }

    return OnboardingLayoutWrapper(
      step: 5,
      stepIndicator: AppTranslations.translate('step5_indicator', lang),
      title: AppTranslations.translate('step5_title', lang),
      isContinueEnabled: isContinueEnabled,
      onContinue: _saveAndContinue,
      child: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Highest Qualification Selector
              BottomSheetSelector(
                labelText: AppTranslations.translate('qualification', lang),
                selectedValue: selectedQual.isNotEmpty ? selectedQual : null,
                options: qualificationsList,
                onSelected: (val) {
                  setState(() {
                    if (lang == 'ta') {
                      _qualification = qualificationMap.entries
                          .firstWhere((e) => e.value == val, orElse: () => MapEntry(val, val))
                          .key;
                    } else {
                      _qualification = val;
                    }
                  });
                },
              ),

              // --- DOCTORATE SECTION ---
              AnimatedSection(
                visible: hasDoc,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const SizedBox(height: 12),
                    const Divider(),
                    _buildSectionHeader(AppTranslations.translate('doctorate_details', lang)),
                    NotchedTextField(
                      labelText: lang == 'en' ? 'Specialization *' : 'சிறப்புப் பிரிவு *',
                      controller: _docSpecializationController,
                      suffixIcon: const Icon(Icons.search, size: 20, color: KalyaThiruTheme.mutedGray),
                    ),
                    const SizedBox(height: 20),
                    NotchedTextField(
                      labelText: lang == 'en' ? 'University/Institution *' : 'பல்கலைக்கழகம் / கல்வி நிறுவனம் *',
                      controller: _docUniversityController,
                      suffixIcon: const Icon(Icons.search, size: 20, color: KalyaThiruTheme.mutedGray),
                    ),
                    const SizedBox(height: 20),
                    BottomSheetSelector(
                      labelText: '${AppTranslations.translate('year_of_completion', lang)} *',
                      selectedValue: _doctorateYear,
                      options: years,
                      suffixIcon: const Icon(Icons.calendar_today, size: 18, color: KalyaThiruTheme.mutedGray),
                      onSelected: (val) => setState(() => _doctorateYear = val),
                    ),
                  ],
                ),
              ),

              // --- POSTGRADUATE SECTION ---
              AnimatedSection(
                visible: hasPg,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const SizedBox(height: 12),
                    const Divider(),
                    _buildSectionHeader(AppTranslations.translate('pg_details', lang)),
                    BottomSheetSelector(
                      labelText: '${AppTranslations.translate('degree', lang)} *',
                      selectedValue: selectedPgDegree.isNotEmpty ? selectedPgDegree : null,
                      options: pgDegreesList,
                      onSelected: (val) {
                        setState(() {
                          if (lang == 'ta') {
                            _pgDegree = pgDegreeMap.entries
                                .firstWhere((e) => e.value == val, orElse: () => MapEntry(val, val))
                                .key;
                          } else {
                            _pgDegree = val;
                          }
                        });
                      },
                    ),
                    const SizedBox(height: 20),
                    NotchedTextField(
                      labelText: '${AppTranslations.translate('specialization', lang)} *',
                      controller: _pgSpecializationController,
                      suffixIcon: const Icon(Icons.search, size: 20, color: KalyaThiruTheme.mutedGray),
                    ),
                    const SizedBox(height: 20),
                    NotchedTextField(
                      labelText: '${AppTranslations.translate('institution_name', lang)} *',
                      controller: _pgInstitutionController,
                      suffixIcon: const Icon(Icons.search, size: 20, color: KalyaThiruTheme.mutedGray),
                    ),
                    // Show Year of Completion only if PG is the highest qualification
                    if (_qualification == 'Post-Graduation (MA, MSc, MBA, ME, etc.)') ...[
                      const SizedBox(height: 20),
                      BottomSheetSelector(
                        labelText: '${AppTranslations.translate('year_of_completion', lang)} *',
                        selectedValue: _pgYear,
                        options: years,
                        suffixIcon: const Icon(Icons.calendar_today, size: 18, color: KalyaThiruTheme.mutedGray),
                        onSelected: (val) => setState(() => _pgYear = val),
                      ),
                    ],
                  ],
                ),
              ),

              // --- UNDERGRADUATE SECTION ---
              AnimatedSection(
                visible: hasUg,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const SizedBox(height: 12),
                    const Divider(),
                    _buildSectionHeader(AppTranslations.translate('ug_details', lang)),
                    BottomSheetSelector(
                      labelText: '${AppTranslations.translate('degree', lang)} *',
                      selectedValue: selectedUgDegree.isNotEmpty ? selectedUgDegree : null,
                      options: ugDegreesList,
                      onSelected: (val) {
                        setState(() {
                          if (lang == 'ta') {
                            _ugDegree = ugDegreeMap.entries
                                .firstWhere((e) => e.value == val, orElse: () => MapEntry(val, val))
                                .key;
                          } else {
                            _ugDegree = val;
                          }
                        });
                      },
                    ),
                    const SizedBox(height: 20),
                    NotchedTextField(
                      labelText: '${AppTranslations.translate('course_major', lang)} *',
                      controller: _ugMajorController,
                      suffixIcon: const Icon(Icons.search, size: 20, color: KalyaThiruTheme.mutedGray),
                    ),
                    const SizedBox(height: 20),
                    NotchedTextField(
                      labelText: '${AppTranslations.translate('institution_name', lang)} *',
                      controller: _ugInstitutionController,
                      suffixIcon: const Icon(Icons.search, size: 20, color: KalyaThiruTheme.mutedGray),
                    ),
                    // Show Year of Completion only if UG is the highest qualification
                    if (_qualification == 'Graduation / Bachelors (BA, BSc, BE, BTech, etc.)') ...[
                      const SizedBox(height: 20),
                      BottomSheetSelector(
                        labelText: '${AppTranslations.translate('year_of_completion', lang)} *',
                        selectedValue: _ugYear,
                        options: years,
                        suffixIcon: const Icon(Icons.calendar_today, size: 18, color: KalyaThiruTheme.mutedGray),
                        onSelected: (val) => setState(() => _ugYear = val),
                      ),
                    ],
                  ],
                ),
              ),

              // --- PRE-UG PATHWAY TOGGLE CARD ---
              AnimatedSection(
                visible: showPreUgToggle,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const SizedBox(height: 12),
                    const Divider(),
                    Text(
                      AppTranslations.translate('pre_university_pathway', lang).toUpperCase(),
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 11,
                        letterSpacing: 0.8,
                        color: KalyaThiruTheme.mutedGray,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        _buildSelectionCard(
                          'schooling',
                          lang == 'en' ? 'Schooling (12th / HSC)' : 'பள்ளிப்படிப்பு (HSC)',
                          _preUgType == 'schooling',
                          () => setState(() => _preUgType = 'schooling'),
                        ),
                        const SizedBox(width: 8),
                        _buildSelectionCard(
                          'diploma',
                          lang == 'en' ? 'Diploma' : 'டிப்ளமோ',
                          _preUgType == 'diploma',
                          () => setState(() => _preUgType = 'diploma'),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              // --- DIPLOMA DETAILS ---
              AnimatedSection(
                visible: hasDiploma,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const SizedBox(height: 12),
                    const Divider(),
                    _buildSectionHeader(AppTranslations.translate('diploma_details', lang)),
                    NotchedTextField(
                      labelText: '${AppTranslations.translate('diploma_stream', lang)} *',
                      controller: _diplomaStreamController,
                      suffixIcon: const Icon(Icons.search, size: 20, color: KalyaThiruTheme.mutedGray),
                    ),
                    const SizedBox(height: 20),
                    NotchedTextField(
                      labelText: '${AppTranslations.translate('polytechnic_name', lang)} *',
                      controller: _diplomaInstitutionController,
                      suffixIcon: const Icon(Icons.search, size: 20, color: KalyaThiruTheme.mutedGray),
                    ),
                    const SizedBox(height: 20),
                    BottomSheetSelector(
                      labelText: '${AppTranslations.translate('year_of_completion', lang)} *',
                      selectedValue: _diplomaYear,
                      options: years,
                      suffixIcon: const Icon(Icons.calendar_today, size: 18, color: KalyaThiruTheme.mutedGray),
                      onSelected: (val) => setState(() => _diplomaYear = val),
                    ),
                  ],
                ),
              ),

              // --- SCHOOLING DETAILS ---
              AnimatedSection(
                visible: hasSchooling,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const SizedBox(height: 12),
                    const Divider(),
                    // If highest is schooling, show school heading, otherwise 10th/12th schooling heading
                    _buildSectionHeader(
                      _qualification == 'Schooling (HSC / SSLC)'
                          ? AppTranslations.translate('schooling_details', lang)
                          : (lang == 'en' ? 'SCHOOLING DETAILS (10th / 12th)' : 'பள்ளி விவரங்கள் (10-12ஆம் வகுப்பு)'),
                    ),
                    NotchedTextField(
                      labelText: '${AppTranslations.translate('school_name', lang)} *',
                      controller: _schoolingNameController,
                      suffixIcon: const Icon(Icons.search, size: 20, color: KalyaThiruTheme.mutedGray),
                    ),
                    const SizedBox(height: 20),
                    BottomSheetSelector(
                      labelText: '${AppTranslations.translate('board_of_education', lang)} *',
                      selectedValue: selectedBoard.isNotEmpty ? selectedBoard : null,
                      options: boardsList,
                      onSelected: (val) {
                        setState(() {
                          if (lang == 'ta') {
                            _schoolingBoard = boardMap.entries
                                .firstWhere((e) => e.value == val, orElse: () => MapEntry(val, val))
                                .key;
                          } else {
                            _schoolingBoard = val;
                          }
                        });
                      },
                    ),
                    const SizedBox(height: 20),
                    BottomSheetSelector(
                      labelText: '${AppTranslations.translate('year_of_completion', lang)} *',
                      selectedValue: _schoolingYear,
                      options: years,
                      suffixIcon: const Icon(Icons.calendar_today, size: 18, color: KalyaThiruTheme.mutedGray),
                      onSelected: (val) => setState(() => _schoolingYear = val),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}

class AnimatedSection extends StatelessWidget {
  final bool visible;
  final Widget child;

  const AnimatedSection({
    super.key,
    required this.visible,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedSize(
      duration: const Duration(milliseconds: 350),
      curve: Curves.easeInOut,
      alignment: Alignment.topCenter,
      child: visible ? child : const SizedBox.shrink(),
    );
  }
}

// --- STEP 6: RESIDENCY ---
class OnboardingStep6Screen extends StatefulWidget {
  const OnboardingStep6Screen({super.key});

  @override
  State<OnboardingStep6Screen> createState() => _OnboardingStep6ScreenState();
}

class _OnboardingStep6ScreenState extends State<OnboardingStep6Screen> {
  String? _citizenship;
  String? _country;
  String? _livingSince;
  String? _stateVal;
  String? _cityVal;

  List<csc.Country> _allCountries = [];
  List<csc.State> _allStates = [];
  List<csc.City> _allCities = [];
  bool _loadingLocations = false;

  @override
  void initState() {
    super.initState();
    final state = context.read<OnboardingCubit>().state;
    _citizenship = state.citizenship;
    _country = state.country;
    _livingSince = state.livingSince;
    _stateVal = state.state;
    _cityVal = state.city;

    _initGeographicData();
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
        _allStates.sort((a, b) => a.name.compareTo(b.name));
        if (_stateVal != null) {
          final stateModel = _allStates.firstWhere(
            (s) => s.name == _stateVal,
            orElse: () => _allStates.first,
          );
          _allCities = await GeographicHelper.getStateCities(countryModel.isoCode, stateModel.isoCode);
          _allCities.sort((a, b) => a.name.compareTo(b.name));
        }
      }
    } catch (e) {
      debugPrint("Error initializing geographic data in onboarding: $e");
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
      debugPrint("Error loading states in onboarding: $e");
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
      debugPrint("Error loading cities in onboarding: $e");
    } finally {
      if (mounted) {
        setState(() => _loadingLocations = false);
      }
    }
  }

  void _saveAndContinue() {
    context.read<OnboardingCubit>().updateFields(
          citizenship: _citizenship,
          country: _country,
          livingSince: _livingSince,
          state: _stateVal,
          city: _cityVal,
        );
    context.read<OnboardingCubit>().updateStep(7);
    context.go('/onboarding/step7');
  }

  @override
  Widget build(BuildContext context) {
    final state = context.watch<OnboardingCubit>().state;
    final String lang = state.langCode;

    final citizenships = ['Indian Citizen', 'NRI / Permanent Resident', 'Foreign National'];
    final countryOptions = _allCountries.isNotEmpty
        ? _allCountries.map((c) => c.name).toList()
        : const ['India', 'United States', 'United Kingdom', 'Singapore', 'Malaysia', 'United Arab Emirates', 'Canada', 'Australia'];
    
    final stateOptions = _allStates.isNotEmpty
        ? _allStates.map((s) => s.name).toList()
        : const ['Other'];

    final cityOptions = _allCities.isNotEmpty
        ? _allCities.map((c) => c.name).toList()
        : const ['Other'];

    final years = List.generate(60, (index) => (2028 - index).toString());

    final bool isNonIndian = _citizenship != null && _citizenship != 'Indian Citizen';
    final bool isContinueEnabled = _citizenship != null &&
        _country != null &&
        (!isNonIndian || _livingSince != null) &&
        _stateVal != null &&
        _stateVal!.trim().isNotEmpty &&
        _cityVal != null &&
        _cityVal!.trim().isNotEmpty;

    return OnboardingLayoutWrapper(
      step: 6,
      stepIndicator: AppTranslations.translate('step6_indicator', lang),
      title: AppTranslations.translate('step6_title', lang),
      isContinueEnabled: isContinueEnabled,
      onContinue: _saveAndContinue,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          BottomSheetSelector(
            labelText: AppTranslations.translate('citizenship', lang),
            selectedValue: _citizenship,
            options: citizenships,
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
            labelText: AppTranslations.translate('country', lang),
            selectedValue: _country,
            options: countryOptions,
            onSelected: (val) => _onCountryChanged(val),
          ),
          const SizedBox(height: 20),
          if (_citizenship != 'Indian Citizen') ...[
            BottomSheetSelector(
              labelText: AppTranslations.translate('living_since', lang),
              selectedValue: _livingSince,
              options: years,
              onSelected: (val) => setState(() => _livingSince = val),
            ),
            const SizedBox(height: 20),
          ],
          BottomSheetSelector(
            labelText: AppTranslations.translate('state', lang),
            selectedValue: _stateVal,
            options: stateOptions,
            onSelected: (val) => _onStateChanged(val),
          ),
          const SizedBox(height: 20),
          BottomSheetSelector(
            labelText: AppTranslations.translate('city', lang),
            selectedValue: _cityVal,
            options: cityOptions,
            onSelected: (val) => setState(() => _cityVal = val),
          ),
        ],
      ),
    );
  }
}

// --- STEP 7: PROFESSIONAL ---
class OnboardingStep7Screen extends StatefulWidget {
  const OnboardingStep7Screen({super.key});

  @override
  State<OnboardingStep7Screen> createState() => _OnboardingStep7ScreenState();
}

class _OnboardingStep7ScreenState extends State<OnboardingStep7Screen> {
  String? _empType;
  String? _occupation;
  String? _income;

  @override
  void initState() {
    super.initState();
    final state = context.read<OnboardingCubit>().state;
    _empType = state.employmentType;
    _occupation = state.occupation;
    _income = state.annualIncome;
  }

  void _saveAndContinue() {
    context.read<OnboardingCubit>().updateFields(
          employmentType: _empType,
          occupation: _occupation,
          annualIncome: _income,
        );
    context.read<OnboardingCubit>().updateStep(8);
    context.go('/onboarding/step8');
  }

  @override
  Widget build(BuildContext context) {
    final state = context.watch<OnboardingCubit>().state;
    final String lang = state.langCode;

    final empTypes = ['Private Sector Job', 'Government / PSU Job', 'Business / Self-Employed', 'Not Working / Student'];
    final occupations = ['Software Engineer', 'Doctor / Surgeon', 'IAS / IPS / Civil Services', 'Chartered Accountant', 'Professor / Teacher', 'Business Owner', 'Architect', 'Banker', 'Defence Personnel', 'Other'];
    final incomes = ['Under ₹3 Lakhs', '₹3 - ₹5 Lakhs', '₹5 - ₹8 Lakhs', '₹8 - ₹12 Lakhs', '₹12 - ₹18 Lakhs', '₹18 - ₹25 Lakhs', '₹25 - ₹40 Lakhs', '₹40 Lakhs+'];

    final bool isContinueEnabled = _empType != null && _occupation != null && _income != null;

    return OnboardingLayoutWrapper(
      step: 7,
      stepIndicator: AppTranslations.translate('step7_indicator', lang),
      title: AppTranslations.translate('step7_title', lang),
      isContinueEnabled: isContinueEnabled,
      onContinue: _saveAndContinue,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          BottomSheetSelector(
            labelText: AppTranslations.translate('employment_type', lang),
            selectedValue: _empType,
            options: empTypes,
            onSelected: (val) => setState(() => _empType = val),
          ),
          const SizedBox(height: 20),
          BottomSheetSelector(
            labelText: AppTranslations.translate('occupation', lang),
            selectedValue: _occupation,
            options: occupations,
            onSelected: (val) => setState(() => _occupation = val),
          ),
          const SizedBox(height: 20),
          BottomSheetSelector(
            labelText: AppTranslations.translate('income_label', lang),
            selectedValue: _income,
            options: incomes,
            onSelected: (val) => setState(() => _income = val),
          ),
        ],
      ),
    );
  }
}

// --- STEP 8: FAMILY DETAILS ---
class OnboardingStep8Screen extends StatefulWidget {
  const OnboardingStep8Screen({super.key});

  @override
  State<OnboardingStep8Screen> createState() => _OnboardingStep8ScreenState();
}

class _OnboardingStep8ScreenState extends State<OnboardingStep8Screen> {
  String? _familyStatus;
  String? _familyWealth;
  final _bioController = TextEditingController();

  @override
  void initState() {
    super.initState();
    final state = context.read<OnboardingCubit>().state;
    _familyStatus = state.familyStatus;
    _familyWealth = state.familyWealth;
    _bioController.text = state.bio ?? '';

    _bioController.addListener(_onTextChanged);
  }

  void _onTextChanged() {
    setState(() {});
  }

  @override
  void dispose() {
    _bioController.removeListener(_onTextChanged);
    _bioController.dispose();
    super.dispose();
  }

  void _saveAndContinue() {
    context.read<OnboardingCubit>().updateFields(
          familyStatus: _familyStatus,
          familyWealth: _familyWealth,
          bio: _bioController.text,
        );
    if (context.read<OnboardingCubit>().state.isOnboardingCompleted) {
      context.go('/home');
    } else {
      context.read<OnboardingCubit>().updateStep(9);
      context.go('/onboarding/step9');
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = context.watch<OnboardingCubit>().state;
    final String lang = state.langCode;

    final statuses = ['Middle Class', 'Upper Middle Class', 'Affluent / Rich', 'Royal / High Heritage'];
    final wealths = ['Below ₹50 Lakhs', '₹50 Lakhs - ₹1 Crore', '₹1 Crore - ₹3 Crores', '₹3 Crores - ₹5 Crores', '₹5 Crores - ₹10 Crores', '₹10 Crores+'];

    final bool isContinueEnabled = _familyStatus != null &&
        _familyWealth != null &&
        _bioController.text.trim().isNotEmpty;

    return OnboardingLayoutWrapper(
      step: 8,
      stepIndicator: AppTranslations.translate('step8_indicator', lang),
      title: AppTranslations.translate('step8_title', lang),
      isContinueEnabled: isContinueEnabled,
      onContinue: _saveAndContinue,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          BottomSheetSelector(
            labelText: AppTranslations.translate('family_status', lang),
            selectedValue: _familyStatus,
            options: statuses,
            onSelected: (val) => setState(() => _familyStatus = val),
          ),
          const SizedBox(height: 20),
          BottomSheetSelector(
            labelText: AppTranslations.translate('family_wealth', lang),
            selectedValue: _familyWealth,
            options: wealths,
            onSelected: (val) => setState(() => _familyWealth = val),
          ),
          const SizedBox(height: 20),
          // Bio field (multi-line)
          TextFormField(
            controller: _bioController,
            maxLines: 5,
            keyboardType: TextInputType.multiline,
            style: Theme.of(context).textTheme.bodyLarge,
            cursorColor: KalyaThiruTheme.primaryMaroon,
            decoration: InputDecoration(
              labelText: AppTranslations.translate('bio_label', lang),
              alignLabelWithHint: true,
            ),
          ),
        ],
      ),
    );
  }
}

// --- STEP 9: ADD PHOTO ---
class OnboardingStep9Screen extends StatefulWidget {
  const OnboardingStep9Screen({super.key});

  @override
  State<OnboardingStep9Screen> createState() => _OnboardingStep9ScreenState();
}

class _OnboardingStep9ScreenState extends State<OnboardingStep9Screen> {
  bool _isUploaded = false;

  @override
  void initState() {
    super.initState();
    final state = context.read<OnboardingCubit>().state;
    _isUploaded = state.photoPath != null && state.photoPath!.isNotEmpty;
  }

  void _simulateUpload() {
    setState(() => _isUploaded = true);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Photo uploaded successfully (Simulated)'),
        backgroundColor: KalyaThiruTheme.primaryMaroon,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final state = context.watch<OnboardingCubit>().state;
    final cubit = context.read<OnboardingCubit>();
    final String lang = state.langCode;

    return OnboardingLayoutWrapper(
      step: 9,
      stepIndicator: AppTranslations.translate('step9_indicator', lang),
      title: AppTranslations.translate('step9_title', lang),
      isContinueEnabled: _isUploaded,
      onContinue: () {
        cubit.updateFields(photoPath: _isUploaded ? 'assets/avatar_placeholder.png' : null);
        if (context.read<OnboardingCubit>().state.isOnboardingCompleted) {
          context.go('/home');
        } else {
          cubit.updateStep(10);
          context.go('/onboarding/step10');
        }
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            AppTranslations.translate('upload_instructions', lang),
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: KalyaThiruTheme.mutedGray),
          ),
          const SizedBox(height: 48),
          Center(
            child: Stack(
              children: [
                Container(
                  width: 180,
                  height: 180,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                    border: Border.all(color: KalyaThiruTheme.outlineBorder, width: 2),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.05),
                        blurRadius: 10,
                        spreadRadius: 2,
                      )
                    ],
                  ),
                  child: ClipOval(
                    child: _isUploaded
                        ? Image.network(
                            'https://images.unsplash.com/photo-1494790108377-be9c29b29330?w=400',
                            fit: BoxFit.cover,
                          )
                        : const Icon(
                            Icons.person,
                            size: 100,
                            color: KalyaThiruTheme.mutedGray,
                          ),
                  ),
                ),
                Positioned(
                  bottom: 0,
                  right: 12,
                  child: InkWell(
                    onTap: _simulateUpload,
                    child: Container(
                      padding: const EdgeInsets.all(12),
                      decoration: const BoxDecoration(
                        color: KalyaThiruTheme.primaryMaroon,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.camera_alt,
                        color: Colors.white,
                        size: 24,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 40),
          if (!_isUploaded)
            OutlinedButton(
              onPressed: _simulateUpload,
              style: OutlinedButton.styleFrom(
                side: const BorderSide(color: KalyaThiruTheme.primaryMaroon),
                padding: const EdgeInsets.symmetric(vertical: 14),
              ),
              child: const Text(
                'Simulate Upload Photo',
                style: TextStyle(color: KalyaThiruTheme.primaryMaroon, fontWeight: FontWeight.bold),
              ),
            ),
        ],
      ),
    );
  }
}

// --- STEP 10: PARTNER PREFERENCES ---
class OnboardingStep10Screen extends StatefulWidget {
  const OnboardingStep10Screen({super.key});

  @override
  State<OnboardingStep10Screen> createState() => _OnboardingStep10ScreenState();
}

class _OnboardingStep10ScreenState extends State<OnboardingStep10Screen> {
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

  void _saveAndContinue() {
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
    context.read<OnboardingCubit>().updateStep(11);
    context.go('/onboarding/step11');
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
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
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

    final bool isHindu = _prefReligion == 'Hindu';
    final bool isContinueEnabled = _prefReligion != null &&
        (_prefCasteNoBar || _prefCastes.isNotEmpty) &&
        (!isHindu || (_prefGothram != null && _prefRaasi != null && _prefStar != null && _prefDosham != null)) &&
        _prefMinIncome != null;

    return OnboardingLayoutWrapper(
      step: 10,
      stepIndicator: AppTranslations.translate('step10_indicator', lang),
      title: AppTranslations.translate('step10_title', lang),
      isContinueEnabled: isContinueEnabled,
      onContinue: _saveAndContinue,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Section 1: Demographics
          Text(
            lang == 'en' ? 'BASIC DEMOGRAPHICS' : 'அடிப்படை வரன் தேவைகள்',
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 12,
              letterSpacing: 0.8,
              color: KalyaThiruTheme.primaryMaroon,
            ),
          ),
          const SizedBox(height: 16),
          // Age Range Slider
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                lang == 'en' ? 'Age Range' : 'வயது வரம்பு',
                style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: KalyaThiruTheme.darkCharcoal),
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
            inactiveColor: KalyaThiruTheme.outlineBorder.withValues(alpha: 0.3),
            onChanged: (RangeValues values) {
              setState(() {
                _prefMinAge = values.start;
                _prefMaxAge = values.end;
              });
            },
          ),
          const SizedBox(height: 12),
          // Height Range Slider
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                lang == 'en' ? 'Height Range' : 'உயர வரம்பு',
                style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: KalyaThiruTheme.darkCharcoal),
              ),
              Text(
                '${_prefMinHeight.toStringAsFixed(1)} - ${_prefMaxHeight.toStringAsFixed(1)} Ft',
                style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: KalyaThiruTheme.primaryMaroon),
              ),
            ],
          ),
          RangeSlider(
            values: RangeValues(_prefMinHeight, _prefMaxHeight),
            min: 4.0,
            max: 7.0,
            divisions: 30,
            activeColor: KalyaThiruTheme.primaryMaroon,
            inactiveColor: KalyaThiruTheme.outlineBorder.withValues(alpha: 0.3),
            onChanged: (RangeValues values) {
              setState(() {
                _prefMinHeight = values.start;
                _prefMaxHeight = values.end;
              });
            },
          ),
          const SizedBox(height: 24),

          // Section 2: Religion & Caste
          Text(
            lang == 'en' ? 'RELIGIOUS PREFERENCES' : 'மதம் & சாதி முன்னுரிமைகள்',
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 12,
              letterSpacing: 0.8,
              color: KalyaThiruTheme.primaryMaroon,
            ),
          ),
          const SizedBox(height: 16),
          // Preferred Religion
          BottomSheetSelector(
            labelText: lang == 'en' ? 'Preferred Religion' : 'விருப்பமான மதம்',
            selectedValue: _prefReligion,
            options: religions,
            onSelected: (val) {
              setState(() {
                _prefReligion = val;
                _prefCastes = []; // Clear selected castes
                if (val != 'Hindu') {
                  _prefGothram = null;
                  _prefRaasi = null;
                  _prefStar = null;
                  _prefDosham = null;
                }
              });
            },
          ),
          const SizedBox(height: 16),
          // Caste No Bar Switch card
          Card(
            elevation: 0,
            color: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
              side: BorderSide(color: KalyaThiruTheme.outlineBorder.withValues(alpha: 0.3)),
            ),
            child: CheckboxListTile(
              title: Text(
                lang == 'en' ? 'Caste No Bar' : 'சாதி தடையற்றது',
                style: TextStyle(fontWeight: FontWeight.bold, color: KalyaThiruTheme.primaryMaroon, fontSize: 13),
              ),
              subtitle: Text(
                lang == 'en' ? 'Open to matches from any caste' : 'எந்த சாதியை சேர்ந்தவராகவும் இருக்கலாம்',
                style: const TextStyle(fontSize: 11),
              ),
              value: _prefCasteNoBar,
              activeColor: KalyaThiruTheme.primaryMaroon,
              onChanged: (val) {
                if (val != null) {
                  setState(() {
                    _prefCasteNoBar = val;
                    if (val) _prefCastes = [];
                  });
                }
              },
            ),
          ),
          const SizedBox(height: 16),
          // Caste selector (Only if Caste No Bar is false and religion is selected)
          if (!_prefCasteNoBar && _prefReligion != null) ...[
            InkWell(
              onTap: () => _openCasteMultiSelect(lang),
              borderRadius: BorderRadius.circular(8),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(color: KalyaThiruTheme.outlineBorder.withValues(alpha: 0.4)),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            lang == 'en' ? 'Preferred Castes *' : 'விருப்பமான சாதிகள் *',
                            style: const TextStyle(fontSize: 11, color: KalyaThiruTheme.mutedGray, fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            _prefCastes.isEmpty
                                ? (lang == 'en' ? 'Select Preferred Castes' : 'சாதிகளைத் தேர்ந்தெடுக்கவும்')
                                : _prefCastes.map((c) => translateOption(c, lang)).join(', '),
                            style: TextStyle(
                              fontSize: 14,
                              color: _prefCastes.isEmpty ? KalyaThiruTheme.mutedGray : KalyaThiruTheme.darkCharcoal,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                    const Icon(Icons.arrow_drop_down, color: KalyaThiruTheme.mutedGray),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
          ],
          // Subcaste preference text field
          NotchedTextField(
            labelText: lang == 'en' ? 'Preferred Subcaste (Optional)' : 'விருப்பமான உட்பிரிவு (விருப்பத்திற்குரியது)',
            controller: _prefSubcasteController,
          ),
          const SizedBox(height: 24),

          // Section 3: Horoscope & Income
          Text(
            lang == 'en' ? 'ASTROLOGY & INCOME' : 'ஜாதகம் & வருமானம்',
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 12,
              letterSpacing: 0.8,
              color: KalyaThiruTheme.primaryMaroon,
            ),
          ),
          const SizedBox(height: 16),
          // Astrological Details (Conditional with smooth dropdown animation when Preferred Religion is Hindu)
          AnimatedSize(
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOut,
            clipBehavior: Clip.hardEdge,
            child: _prefReligion == 'Hindu'
                ? Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      BottomSheetSelector(
                        labelText: AppTranslations.translate('preferred_gothram', lang),
                        selectedValue: _prefGothram,
                        options: gothrams,
                        onSelected: (val) => setState(() => _prefGothram = val),
                      ),
                      const SizedBox(height: 16),
                      BottomSheetSelector(
                        labelText: AppTranslations.translate('preferred_raasi', lang),
                        selectedValue: _prefRaasi,
                        options: prefRaasis,
                        onSelected: (val) => setState(() => _prefRaasi = val),
                      ),
                      const SizedBox(height: 16),
                      BottomSheetSelector(
                        labelText: AppTranslations.translate('preferred_star', lang),
                        selectedValue: _prefStar,
                        options: stars,
                        onSelected: (val) => setState(() => _prefStar = val),
                      ),
                      const SizedBox(height: 16),
                      BottomSheetSelector(
                        labelText: AppTranslations.translate('preferred_dosham', lang),
                        selectedValue: _prefDosham,
                        options: prefDoshams,
                        onSelected: (val) => setState(() => _prefDosham = val),
                      ),
                      const SizedBox(height: 16),
                    ],
                  )
                : const SizedBox(width: double.infinity, height: 0),
          ),
          BottomSheetSelector(
            labelText: AppTranslations.translate('preferred_income', lang),
            selectedValue: _prefMinIncome,
            options: incomes,
            onSelected: (val) => setState(() => _prefMinIncome = val),
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }
}

// --- STEP 11: HOBBIES, BENTO INTERESTS & TRAITS ---
class OnboardingStep11Screen extends StatefulWidget {
  const OnboardingStep11Screen({super.key});

  @override
  State<OnboardingStep11Screen> createState() => _OnboardingStep11ScreenState();
}

class _OnboardingStep11ScreenState extends State<OnboardingStep11Screen> {
  List<String> _selectedHobbies = [];
  List<String> _selectedInterests = [];
  String? _trait;

  // Pre-configured hierarchical sub-interests
  final Map<String, Map<String, dynamic>> _hobbyHierarchy = {
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

  @override
  void initState() {
    super.initState();
    final state = context.read<OnboardingCubit>().state;
    _selectedHobbies = List.from(state.selectedHobbies);
    _selectedInterests = List.from(state.selectedInterests);
    _trait = state.trait;
  }

  void _openSubInterestSheet(String hobby) {
    final details = _hobbyHierarchy[hobby]!;
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
          tamilTitle: details['tamil'],
          availableGenres: List<String>.from(details['genres']),
          selectedGenres: List<String>.from(selectedSub),
          onSaved: (genres) {
            context.read<OnboardingCubit>().updateSubInterest(hobby, genres);
            setState(() {}); // Refresh chips listing sub-interest tags
          },
        );
      },
    );
  }

  void _toggleHobby(String hobby) {
    setState(() {
      if (_selectedHobbies.contains(hobby)) {
        _selectedHobbies.remove(hobby);
        // Clean up sub-interests
        final Map<String, List<String>> currentSub = Map.from(context.read<OnboardingCubit>().state.selectedSubInterests);
        currentSub.remove(hobby);
        context.read<OnboardingCubit>().updateFields(selectedSubInterests: currentSub);
      } else {
        _selectedHobbies.add(hobby);
        // Auto open sub-interest deep dive!
        WidgetsBinding.instance.addPostFrameCallback((_) {
          _openSubInterestSheet(hobby);
        });
      }
    });
  }

  void _toggleInterest(String interest) {
    setState(() {
      if (_selectedInterests.contains(interest)) {
        _selectedInterests.remove(interest);
      } else {
        _selectedInterests.add(interest);
      }
    });
  }

  void _completeOnboarding() {
    // Save selections
    context.read<OnboardingCubit>().updateFields(
          selectedHobbies: _selectedHobbies,
          selectedInterests: _selectedInterests,
          trait: _trait,
          isOnboardingCompleted: true,
        );
    // Redirect to Home Dashboard Screen
    context.go('/home');
  }

  @override
  Widget build(BuildContext context) {
    final state = context.watch<OnboardingCubit>().state;
    final String lang = state.langCode;

    final interests = ['Philosophy', 'Tamil Literature', 'Technology', 'Ancient History', 'Nature & Travel', 'Art & Painting', 'Social Service', 'Astrophotography'];
    final traits = ['Introverted & Calm', 'Extroverted & Social', 'Analytical & Thinker', 'Creative & Expressive', 'Empathetic & Caregiver', 'Practical & Grounded'];

    final bool isContinueEnabled = _selectedHobbies.isNotEmpty &&
        _selectedInterests.isNotEmpty &&
        _trait != null;

    return OnboardingLayoutWrapper(
      step: 11,
      stepIndicator: AppTranslations.translate('step11_indicator', lang),
      title: AppTranslations.translate('step11_title', lang),
      isContinueEnabled: isContinueEnabled,
      onContinue: _completeOnboarding,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Section 1: Hobbies with sub-interest indicators
          Text(
            AppTranslations.translate('hobbies_label', lang),
            style: Theme.of(context).textTheme.titleLarge?.copyWith(fontSize: 16),
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8.0,
            runSpacing: 8.0,
            children: _hobbyHierarchy.keys.map((hobby) {
              final bool isSelected = _selectedHobbies.contains(hobby);
              final List<String> subSelected = state.selectedSubInterests[hobby] ?? [];

              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  ChoiceChip(
                    label: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(lang == 'ta' ? _hobbyHierarchy[hobby]!['tamil'] : hobby),
                        if (isSelected) ...[
                          const SizedBox(width: 6),
                          const Icon(Icons.settings, size: 14, color: Colors.white),
                        ]
                      ],
                    ),
                    selected: isSelected,
                    onSelected: (_) => _toggleHobby(hobby),
                    selectedColor: KalyaThiruTheme.primaryMaroon,
                    labelStyle: TextStyle(
                      color: isSelected ? Colors.white : KalyaThiruTheme.primaryMaroon,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  // Display selected sub-genres tags
                  if (isSelected && subSelected.isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.only(left: 4.0, top: 4.0, bottom: 8.0),
                      child: Wrap(
                        spacing: 4.0,
                        children: subSelected.map((sub) {
                          return Container(
                            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                            decoration: BoxDecoration(
                              color: KalyaThiruTheme.antiqueGold.withValues(alpha: 0.15),
                              border: Border.all(color: KalyaThiruTheme.antiqueGold, width: 0.5),
                              borderRadius: BorderRadius.circular(2),
                            ),
                            child: Text(
                              translateOption(sub, lang),
                              style: const TextStyle(fontSize: 10, color: KalyaThiruTheme.primaryDark),
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                ],
              );
            }).toList(),
          ),
          const SizedBox(height: 28),

          // Section 2: Bento-style Interests Grid
          Text(
            AppTranslations.translate('interests_label', lang),
            style: Theme.of(context).textTheme.titleLarge?.copyWith(fontSize: 16),
          ),
          const SizedBox(height: 12),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
              childAspectRatio: 2.2,
            ),
            itemCount: interests.length,
            itemBuilder: (context, index) {
              final interest = interests[index];
              final bool isSelected = _selectedInterests.contains(interest);

              return InkWell(
                onTap: () => _toggleInterest(interest),
                borderRadius: BorderRadius.circular(4),
                child: Container(
                  alignment: Alignment.center,
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  decoration: BoxDecoration(
                    color: isSelected ? KalyaThiruTheme.primaryDark : Colors.white,
                    border: Border.all(
                      color: isSelected ? KalyaThiruTheme.primaryDark : KalyaThiruTheme.outlineBorder,
                      width: 0.8,
                    ),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    translateOption(interest, lang),
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: isSelected ? Colors.white : KalyaThiruTheme.darkCharcoal,
                          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                        ),
                    textAlign: TextAlign.center,
                  ),
                ),
              );
            },
          ),
          const SizedBox(height: 28),

          // Section 3: Personality Trait single-select
          Text(
            AppTranslations.translate('traits_label', lang),
            style: Theme.of(context).textTheme.titleLarge?.copyWith(fontSize: 16),
          ),
          const SizedBox(height: 12),
          BottomSheetSelector(
            labelText: AppTranslations.translate('traits_label', lang),
            selectedValue: _trait,
            options: traits,
            onSelected: (val) => setState(() => _trait = val),
          ),
        ],
      ),
    );
  }
}
