import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../core/theme/theme.dart';
import '../../../core/translation/option_translations.dart';
import '../../onboarding/cubit/onboarding_cubit.dart';
import '../../profile/models/profile_model.dart';

// ─── Constants: Option Lists ─────────────────────────────────────────────────

const List<String> _kReligions = [
  'Muslim - All', 'Buddhist', 'Christian', 'Hindu', 'Inter-Religion',
  'Jain - All', 'Jain - Digambar', 'Jain - Others', 'Jain - Shwetambar',
  'Jewish', 'Muslim - Others', 'Muslim - Shia', 'Muslim - Sunni',
  'No Religious Belief', 'Parsi', 'Sikh', 'Spiritual - not religious', 'Other',
];

const List<String> _kCastes = [
  'Mudaliar', 'Pillai', 'Vanniyar', 'Gounder', 'Nadar', 'Chettiar',
  'Adidravidar', 'Thevar', 'Iyer', 'Iyengar', 'Brahmins',
  'Roman Catholic', 'Protestant', 'Pentecostal', 'Syrian Christian',
  'Sunni', 'Shia', 'Lebbai', 'Rawther', 'Marakayar', 'Mapilla',
  'Shafi', 'Hanafi', 'Maliki', 'Hanbali', 'Other',
];

const List<String> _kOccupations = [
  'Any', 'Administration', 'Agriculture', 'Airline', 'Architecture & Design',
  'Banking & Finance', 'Beauty & Fashion', 'BPO & Customer Service',
  'Civil Services', 'Corporate Professionals', 'Defence', 'Doctor',
  'Education & Training', 'Engineering', 'Hospitality', 'IT & Software',
  'Legal', 'Media & Entertainment', 'Medical & Healthcare - Other',
  'Merchant Navy', 'Police / Law Enforcement', 'Scientist',
  'Senior Management', 'Not Working', 'Others',
];

const List<String> _kAnnualIncome = [
  'Any', 'Under ₹3 Lakhs', '₹3 - ₹5 Lakhs', '₹5 - ₹8 Lakhs',
  '₹8 - ₹12 Lakhs', '₹12 - ₹18 Lakhs', '₹18 - ₹25 Lakhs',
  '₹25 - ₹40 Lakhs', '₹40 Lakhs+',
];

const List<String> _kEmploymentTypes = [
  'Any', 'Business', 'Defence', 'Government / PSU',
  'Not Working', 'Private', 'Self Employed',
];

const List<String> _kEducation = [
  'Any', "Bachelor's - Arts / Science / Commerce",
  "Bachelor's - Engineering / Computer Science", "Bachelor's - Legal",
  "Bachelor's - Management",
  "Bachelor's - Medicine - General / Dental / Surgeon",
  "Bachelor's - Pharmacy / Nursing", 'Doctorates',
  'Finance - ICWAI / CA / CS / CFA',
  "Master's - Arts / Science / Commerce",
  "Master's - Engineering / Computer Science", "Master's - Legal",
  "Master's - Management",
  "Master's - Medicine - General / Dental / Surgeon",
  "Master's - Pharmacy / Nursing", 'Civil Services',
  'Diploma / Polytechnic', 'Higher Secondary / Secondary', 'Other',
];

const List<String> _kCountries = [
  'India', 'United States', 'United Kingdom', 'Canada', 'Australia',
  'Singapore', 'United Arab Emirates', 'Germany', 'Malaysia',
  'New Zealand', 'Sri Lanka', 'South Africa', 'France', 'Italy',
  'Japan', 'Saudi Arabia', 'Qatar', 'Kuwait', 'Bahrain', 'Oman',
  'Other',
];

const List<String> _kEatingHabits = [
  "Doesn't Matter", 'Vegetarian', 'Non-Vegetarian', 'Eggetarian', 'Vegan',
];

const List<String> _kSmokingDrinking = [
  "Doesn't Matter", 'No', 'Occasional', 'Yes',
];

const List<String> _kFamilyStatus = [
  'Any', 'Rich / Affluent', 'Upper Middle Class', 'Middle Class',
  'Lower Middle Class',
];

const List<String> _kFamilyType = [
  'Any', 'Joint Family', 'Nuclear Family',
];

const List<String> _kFamilyValues = [
  'Any', 'Traditional', 'Moderate', 'Liberal',
];

const List<String> _kProfileCreatedBy = [
  'Any', 'Self', 'Parents', 'Sibling', 'Relative', 'Friend',
];

const List<String> _kMaritalStatus = [
  'Any', 'Never Married', 'Widowed', 'Divorced', 'Separated',
];

const List<String> _kMotherTongues = [
  "Doesn't Matter", 'Tamil', 'Telugu', 'Kannada', 'Malayalam', 'Hindi',
  'English', 'Bengali', 'Marathi', 'Gujarati', 'Punjabi', 'Urdu', 'Odia',
];

const List<String> _kPhysicalStatus = [
  "Doesn't Matter", 'Normal', 'Physically Challenged',
];

const List<String> _kDontShowProfiles = [
  'Already Contacted', 'Shortlisted', 'Ignored', 'Already Viewed',
];

const List<String> _kCitizenship = [
  'Any', 'India', 'United States', 'United Kingdom', 'Canada',
  'Australia', 'Singapore', 'UAE', 'Germany', 'Malaysia', 'Other',
];

// ─── Main Screen ─────────────────────────────────────────────────────────────

class AiSearchScreen extends StatefulWidget {
  final bool isPaidMember;
  const AiSearchScreen({super.key, this.isPaidMember = false});

  @override
  State<AiSearchScreen> createState() => _AiSearchScreenState();
}

class _AiSearchScreenState extends State<AiSearchScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  bool _isPaid = false;

  // ── Select Criteria state ──
  // Basic Details
  double _ageMin = 19, _ageMax = 26;
  double _heightMin = 4.67, _heightMax = 5.67; // 4'8" – 5'8"
  Set<String> _profileCreatedBy = {'Any'};
  Set<String> _maritalStatus = {'Any'};
  Set<String> _motherTongue = {"Doesn't Matter"};
  Set<String> _physicalStatus = {"Doesn't Matter"};
  bool _basicViewMore = false;

  // Religious Details
  Set<String> _religion = {};
  Set<String> _caste = {};
  bool _profilesWithHoroscope = false; // Premium unlocked

  // Professional Details
  Set<String> _occupation = {'Any'};
  Set<String> _annualIncome = {'Any'};
  Set<String> _employmentType = {'Any'};
  Set<String> _education = {};
  String _institutionDetails = 'Any'; // Premium unlocked
  String _organizationDetails = 'Any'; // Premium unlocked
  
  // Location Details
  bool _nearbyProfiles = false;
  Set<String> _country = {};
  Set<String> _citizenship = {};
  bool _locationViewMore = false;

  // Lifestyle
  Set<String> _eatingHabits = {};
  Set<String> _smokingHabits = {"Doesn't Matter"};
  Set<String> _drinkingHabits = {"Doesn't Matter"};
  bool _lifestyleViewMore = false;

  // Family Details
  Set<String> _familyStatus = {'Any'};
  Set<String> _familyType = {'Any'};
  Set<String> _familyValues = {'Any'};
  bool _familyViewMore = false;

  // Recently Created Profiles
  String _profileCreatedRecency = 'Any time';

  // Profile Type
  bool _profilesWithPhoto = false;
  Set<String> _dontShowProfiles = {};

  // By Profile ID
  final TextEditingController _profileIdController = TextEditingController();

  // Match count (simulated)
  int _matchCount = 676;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _isPaid = widget.isPaidMember;
    _loadPaidStatus();
  }

  Future<void> _loadPaidStatus() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _isPaid = prefs.getBool('is_paid_member') ?? widget.isPaidMember;
    });
  }

  Future<void> _togglePaidState(bool val) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('is_paid_member', val);
    setState(() {
      _isPaid = val;
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    _profileIdController.dispose();
    super.dispose();
  }

  String _heightToString(double val) {
    final feet = val.toInt();
    final inches = ((val - feet) * 12).round();
    return "$feet'$inches\"";
  }

  String _summarize(Set<String> items, {int max = 2}) {
    if (items.isEmpty) return 'Any';
    if (items.length <= max) return items.join(', ');
    return '${items.take(max).join(', ')}...';
  }

  void _clearAll() {
    setState(() {
      _ageMin = 19; _ageMax = 26;
      _heightMin = 4.67; _heightMax = 5.67;
      _profileCreatedBy = {'Any'};
      _maritalStatus = {'Any'};
      _motherTongue = {"Doesn't Matter"};
      _physicalStatus = {"Doesn't Matter"};
      _religion = {}; _caste = {};
      _profilesWithHoroscope = false;
      _occupation = {'Any'};
      _annualIncome = {'Any'};
      _employmentType = {'Any'};
      _education = {};
      _institutionDetails = 'Any';
      _organizationDetails = 'Any';
      _nearbyProfiles = false;
      _country = {}; _citizenship = {};
      _eatingHabits = {};
      _smokingHabits = {"Doesn't Matter"};
      _drinkingHabits = {"Doesn't Matter"};
      _familyStatus = {'Any'};
      _familyType = {'Any'};
      _familyValues = {'Any'};
      _profileCreatedRecency = 'Any time';
      _profilesWithPhoto = false;
      _dontShowProfiles = {};
      _matchCount = 676;
    });
  }

  // ─── Multi-Select Bottom Sheet ──────────────────────────────────────────────

  void _openMultiSelectSheet({
    required String title,
    required List<String> options,
    required Set<String> selected,
    required ValueChanged<Set<String>> onApply,
    bool hasSearch = false,
  }) {
    Set<String> tempSelected = Set<String>.from(selected);
    String searchQuery = '';

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) {
        return StatefulBuilder(
          builder: (ctx, setSheetState) {
            final filtered = searchQuery.isEmpty
                ? options
                : options
                    .where((o) =>
                        o.toLowerCase().contains(searchQuery.toLowerCase()))
                    .toList();

            return Container(
              height: MediaQuery.of(context).size.height * 0.75,
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
              ),
              child: Column(
                children: [
                  // Title bar
                  Padding(
                    padding: const EdgeInsets.fromLTRB(20, 16, 12, 0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          title,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: KalyaThiruTheme.darkCharcoal,
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.close,
                              color: KalyaThiruTheme.darkCharcoal),
                          onPressed: () => Navigator.pop(ctx),
                        ),
                      ],
                    ),
                  ),

                  // Search field
                  if (hasSearch)
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 8),
                      child: TextField(
                        onChanged: (val) {
                          setSheetState(() => searchQuery = val);
                        },
                        decoration: InputDecoration(
                          hintText: 'Search $title',
                          hintStyle:
                              const TextStyle(color: KalyaThiruTheme.mutedGray),
                          prefixIcon: const Icon(Icons.search,
                              color: KalyaThiruTheme.mutedGray),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(24),
                            borderSide: const BorderSide(
                                color: KalyaThiruTheme.outlineBorder),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(24),
                            borderSide: const BorderSide(
                                color: KalyaThiruTheme.outlineBorder),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(24),
                            borderSide: const BorderSide(
                                color: KalyaThiruTheme.primaryMaroon),
                          ),
                          contentPadding:
                              const EdgeInsets.symmetric(vertical: 10),
                          filled: true,
                          fillColor: const Color(0xFFF8F6F4),
                        ),
                      ),
                    ),

                  const Divider(height: 1),

                  // Options list
                  Expanded(
                    child: ListView.separated(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      itemCount: filtered.length,
                      separatorBuilder: (_, __) =>
                          const Divider(height: 1, color: Color(0xFFEEEAE7)),
                      itemBuilder: (_, i) {
                        final opt = filtered[i];
                        final isChecked = tempSelected.contains(opt);
                        return InkWell(
                          onTap: () {
                            setSheetState(() {
                              if (isChecked) {
                                tempSelected.remove(opt);
                              } else {
                                tempSelected.add(opt);
                              }
                            });
                          },
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            child: Row(
                              children: [
                                Container(
                                  width: 22,
                                  height: 22,
                                  decoration: BoxDecoration(
                                    color: isChecked
                                        ? KalyaThiruTheme.primaryMaroon
                                        : Colors.transparent,
                                    borderRadius: BorderRadius.circular(4),
                                    border: Border.all(
                                      color: isChecked
                                          ? KalyaThiruTheme.primaryMaroon
                                          : const Color(0xFFBDBDBD),
                                      width: 2,
                                    ),
                                  ),
                                  child: isChecked
                                      ? const Icon(Icons.check,
                                          color: Colors.white, size: 16)
                                      : null,
                                ),
                                const SizedBox(width: 16),
                                Expanded(
                                  child: Text(
                                    opt,
                                    style: const TextStyle(
                                      fontSize: 15,
                                      color: KalyaThiruTheme.darkCharcoal,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),

                  // Bottom action bar
                  Container(
                    decoration: BoxDecoration(
                      color: const Color(0xFFF5F2F0),
                      border: Border(
                        top: BorderSide(color: Colors.grey[300]!),
                      ),
                    ),
                    padding: const EdgeInsets.fromLTRB(20, 12, 20, 20),
                    child: Row(
                      children: [
                        // Match count
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              '$_matchCount',
                              style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: KalyaThiruTheme.darkCharcoal,
                              ),
                            ),
                            const Text(
                              'matches',
                              style: TextStyle(
                                fontSize: 12,
                                color: KalyaThiruTheme.mutedGray,
                              ),
                            ),
                          ],
                        ),
                        const Spacer(),
                        // Reset
                        OutlinedButton(
                          onPressed: () {
                            setSheetState(() => tempSelected.clear());
                          },
                          style: OutlinedButton.styleFrom(
                            side: const BorderSide(
                                color: KalyaThiruTheme.outlineBorder),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                            padding: const EdgeInsets.symmetric(
                                horizontal: 20, vertical: 12),
                          ),
                          child: const Text(
                            'Reset',
                            style: TextStyle(
                              color: KalyaThiruTheme.darkCharcoal,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        // Apply
                        ElevatedButton(
                          onPressed: () {
                            onApply(tempSelected);
                            Navigator.pop(ctx);
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: KalyaThiruTheme.primaryMaroon,
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                            padding: const EdgeInsets.symmetric(
                                horizontal: 24, vertical: 12),
                          ),
                          child: const Text(
                            'Apply',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  // ─── Subscription bottom sheet ─────────────────────────────────────────────

  void _showSubscriptionSheet() {
    final lang = context.read<OnboardingCubit>().state.langCode;
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
          ),
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Text(
                lang == 'en' ? 'Upgrade Membership' : 'உறுப்பினர் சேர்க்கையை மேம்படுத்தவும்',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      color: KalyaThiruTheme.primaryMaroon,
                      fontWeight: FontWeight.bold,
                    ),
              ),
              const SizedBox(height: 8),
              Text(
                lang == 'en'
                    ? 'Unlock unlimited features and connect instantly with verification-first matches.'
                    : 'வரம்பற்ற வசதிகளைப் பெறவும் மற்றும் சரிபார்க்கப்பட்ட வரன்களுடன் உடனடியாக இணையவும்.',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: KalyaThiruTheme.mutedGray,
                    ),
              ),
              const SizedBox(height: 24),
              // Plan Cards
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  border: Border.all(color: KalyaThiruTheme.outlineBorder),
                  borderRadius: BorderRadius.circular(4),
                  color: KalyaThiruTheme.softIvory,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            lang == 'en' ? 'Gold Elite Plan (3 Months)' : 'தங்க எலைட் திட்டம் (3 மாதங்கள்)',
                            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                  color: KalyaThiruTheme.primaryMaroon,
                                ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            lang == 'en'
                                ? '₹4,500  (Save 61% - Limited offer)'
                                : '₹4,500  (61% சேமிப்பு - வரையறுக்கப்பட்ட சலுகை)',
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              color: KalyaThiruTheme.antiqueGold,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const Icon(Icons.check_circle, color: KalyaThiruTheme.primaryMaroon),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: () {
                  _togglePaidState(true);
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        lang == 'en'
                            ? 'Plan Upgraded successfully!'
                            : 'திட்டம் வெற்றிகரமாக மேம்படுத்தப்பட்டது!',
                      ),
                      backgroundColor: KalyaThiruTheme.primaryMaroon,
                    ),
                  );
                },
                child: Text(lang == 'en' ? 'ACTIVATE NOW' : 'இப்போது செயல்படுத்தவும்'),
              ),
              const SizedBox(height: 12),
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text(
                  lang == 'en' ? 'Maybe Later' : 'பிறகு செய்கிறேன்',
                  style: const TextStyle(color: KalyaThiruTheme.mutedGray),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  // ─── Text Input Sheet ──────────────────────────────────────────────────────

  void _openTextInputSheet({
    required String title,
    required String currentValue,
    required ValueChanged<String> onApply,
    required String lang,
  }) {
    final textController = TextEditingController(text: currentValue == 'Any' ? '' : currentValue);
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) {
        return Padding(
          padding: EdgeInsets.only(bottom: MediaQuery.of(ctx).viewInsets.bottom),
          child: Container(
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
            ),
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: KalyaThiruTheme.darkCharcoal,
                  ),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: textController,
                  autofocus: true,
                  decoration: InputDecoration(
                    hintText: lang == 'en' ? 'Enter details...' : 'விவரங்களை உள்ளிடவும்...',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    onApply(textController.text.trim());
                    Navigator.pop(ctx);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: KalyaThiruTheme.primaryMaroon,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 14),
                  ),
                  child: Text(
                    lang == 'en' ? 'Apply' : 'பொருந்து',
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  // ─── BUILD ─────────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    final lang = context.watch<OnboardingCubit>().state.langCode;

    return Scaffold(
      backgroundColor: KalyaThiruTheme.softIvory,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.5,
        centerTitle: false,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back,
              color: KalyaThiruTheme.darkCharcoal),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          lang == 'en' ? 'Search' : 'தேடல்',
          style: const TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: KalyaThiruTheme.darkCharcoal,
          ),
        ),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(48),
          child: ClipRect(
            child: TabBar(
              controller: _tabController,
              isScrollable: true,
              tabAlignment: TabAlignment.start,
              labelPadding: const EdgeInsets.symmetric(horizontal: 12.0),
              indicatorColor: KalyaThiruTheme.primaryMaroon,
              indicatorWeight: 2.5,
              labelColor: KalyaThiruTheme.primaryMaroon,
              unselectedLabelColor: KalyaThiruTheme.mutedGray,
              labelStyle:
                  const TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
              unselectedLabelStyle:
                  const TextStyle(fontSize: 13, fontWeight: FontWeight.normal),
              tabs: [
                Tab(text: lang == 'en' ? 'By Criteria' : 'அளவுகோல்'),
                Tab(text: lang == 'en' ? 'By Profile ID' : 'சுயவிவர ID'),
                Tab(
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(lang == 'en' ? 'Saved Search' : 'சேமிப்புகள்'),
                      const SizedBox(width: 6),
                      Container(
                        padding:
                            const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(
                          color: KalyaThiruTheme.primaryMaroon,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: const Text(
                          '0',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildByCriteriaTab(lang),
          _buildByProfileIdTab(lang),
          _buildSavedSearchTab(lang),
        ],
      ),
    );
  }

  // ─── TAB 1: BY CRITERIA ────────────────────────────────────────────────────

  Widget _buildByCriteriaTab(String lang) {
    return Column(
      children: [
        // Subtitle
        Container(
          width: double.infinity,
          color: Colors.white,
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 12),
          child: Text(
            lang == 'en'
                ? 'Search profiles using the below criteria'
                : 'கீழ்க்கண்ட அளவுகோல்களைப் பயன்படுத்தி தேடவும்',
            style: const TextStyle(
              fontSize: 13,
              color: KalyaThiruTheme.mutedGray,
            ),
          ),
        ),

        // Scrollable criteria sections
        Expanded(
          child: SingleChildScrollView(
            child: Column(
              children: [
                // 1. Basic Details
                _buildSectionHeader(lang == 'en' ? 'Basic Details' : 'அடிப்படை விவரங்கள்'),
                _buildWhiteCard([
                  _buildCriteriaRow(
                    label: lang == 'en' ? 'Age' : 'வயது',
                    value: '${_ageMin.toInt()} Yrs - ${_ageMax.toInt()} Yrs',
                    onTap: () => _openAgeSheet(lang),
                  ),
                  const Divider(height: 1, color: Color(0xFFEEEAE7)),
                  _buildCriteriaRow(
                    label: lang == 'en' ? 'Height' : 'உயரம்',
                    value: '${_heightToString(_heightMin)} - ${_heightToString(_heightMax)}',
                    onTap: () => _openHeightSheet(lang),
                  ),
                  const Divider(height: 1, color: Color(0xFFEEEAE7)),
                  _buildCriteriaRow(
                    label: lang == 'en' ? 'Profile Created By' : 'சுயவிவரம் உருவாக்கியவர்',
                    value: _summarize(_profileCreatedBy),
                    onTap: () => _openMultiSelectSheet(
                      title: 'Profile Created By',
                      options: _kProfileCreatedBy,
                      selected: _profileCreatedBy,
                      onApply: (v) => setState(() => _profileCreatedBy = v),
                    ),
                  ),
                  if (_basicViewMore) ...[
                    const Divider(height: 1, color: Color(0xFFEEEAE7)),
                    _buildCriteriaRow(
                      label: lang == 'en' ? 'Marital Status' : 'திருமண நிலை',
                      value: _summarize(_maritalStatus),
                      onTap: () => _openMultiSelectSheet(
                        title: 'Marital Status',
                        options: _kMaritalStatus,
                        selected: _maritalStatus,
                        onApply: (v) => setState(() => _maritalStatus = v),
                      ),
                    ),
                    const Divider(height: 1, color: Color(0xFFEEEAE7)),
                    _buildCriteriaRow(
                      label: lang == 'en' ? 'Mother Tongue' : 'தாய்மொழி',
                      value: _summarize(_motherTongue),
                      onTap: () => _openMultiSelectSheet(
                        title: 'Mother Tongue',
                        options: _kMotherTongues,
                        selected: _motherTongue,
                        onApply: (v) => setState(() => _motherTongue = v),
                        hasSearch: true,
                      ),
                    ),
                    const Divider(height: 1, color: Color(0xFFEEEAE7)),
                    _buildCriteriaRow(
                      label: lang == 'en' ? 'Physical Status' : 'உடல் நிலை',
                      value: _summarize(_physicalStatus),
                      onTap: () => _openMultiSelectSheet(
                        title: 'Physical Status',
                        options: _kPhysicalStatus,
                        selected: _physicalStatus,
                        onApply: (v) => setState(() => _physicalStatus = v),
                      ),
                    ),
                  ],
                  _buildViewMoreToggle(
                    expanded: _basicViewMore,
                    onTap: () => setState(() => _basicViewMore = !_basicViewMore),
                    lang: lang,
                  ),
                ]),

                // 2. Religious Details
                _buildSectionHeader(lang == 'en' ? 'Religious Details' : 'மத விவரங்கள்'),
                _buildWhiteCard([
                  _buildCriteriaRow(
                    label: lang == 'en' ? 'Religion' : 'மதம்',
                    value: _summarize(_religion),
                    onTap: () => _openMultiSelectSheet(
                      title: 'Religion',
                      options: _kReligions,
                      selected: _religion,
                      onApply: (v) => setState(() => _religion = v),
                      hasSearch: true,
                    ),
                  ),
                  const Divider(height: 1, color: Color(0xFFEEEAE7)),
                  _buildCriteriaRow(
                    label: lang == 'en' ? 'Caste' : 'சாதி',
                    value: _summarize(_caste),
                    onTap: () => _openMultiSelectSheet(
                      title: 'Caste',
                      options: _kCastes,
                      selected: _caste,
                      onApply: (v) => setState(() => _caste = v),
                      hasSearch: true,
                    ),
                  ),
                  
                  // Paid check or Lock card for Horoscope
                  if (_isPaid) ...[
                    const Divider(height: 1, color: Color(0xFFEEEAE7)),
                    InkWell(
                      onTap: () => setState(() => _profilesWithHoroscope = !_profilesWithHoroscope),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
                        child: Row(
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    lang == 'en' ? 'Profiles with horoscope' : 'ஜாதகத்துடன் கூடிய சுயவிவரங்கள்',
                                    style: const TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.w600,
                                      color: KalyaThiruTheme.darkCharcoal,
                                    ),
                                  ),
                                  const SizedBox(height: 2),
                                  Text(
                                    lang == 'en'
                                        ? 'Matches who have added horoscope'
                                        : 'ஜாதகம் சேர்த்த வரன்கள்',
                                    style: const TextStyle(
                                      fontSize: 11,
                                      color: KalyaThiruTheme.mutedGray,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              width: 22,
                              height: 22,
                              decoration: BoxDecoration(
                                color: _profilesWithHoroscope
                                    ? KalyaThiruTheme.primaryMaroon
                                    : Colors.transparent,
                                borderRadius: BorderRadius.circular(4),
                                border: Border.all(
                                  color: _profilesWithHoroscope
                                      ? KalyaThiruTheme.primaryMaroon
                                      : const Color(0xFFBDBDBD),
                                  width: 2,
                                ),
                              ),
                              child: _profilesWithHoroscope
                                  ? const Icon(Icons.check, color: Colors.white, size: 16)
                                  : null,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ] else ...[
                    const Divider(height: 1, color: Color(0xFFEEEAE7)),
                    _buildPremiumLockedCard(
                      title: lang == 'en' ? 'Profiles with horoscope' : 'ஜாதகத்துடன் கூடிய சுயவிவரங்கள்',
                      subtitle: lang == 'en' ? 'Matches who have added horoscope' : 'ஜாதகம் சேர்த்த வரன்கள்',
                      lang: lang,
                      lockMessage: lang == 'en' ? 'Horoscope Locked' : 'ஜாதகம் பூட்டப்பட்டுள்ளது',
                    ),
                  ],
                ]),

                // 3. Professional Details
                _buildSectionHeader(lang == 'en' ? 'Professional Details' : 'தொழில்முறை விவரங்கள்'),
                _buildWhiteCard([
                  _buildCriteriaRow(
                    label: lang == 'en' ? 'Occupation' : 'தொழில்',
                    value: _summarize(_occupation),
                    onTap: () => _openMultiSelectSheet(
                      title: 'Occupation',
                      options: _kOccupations,
                      selected: _occupation,
                      onApply: (v) => setState(() => _occupation = v),
                      hasSearch: true,
                    ),
                  ),
                  const Divider(height: 1, color: Color(0xFFEEEAE7)),
                  _buildCriteriaRow(
                    label: lang == 'en' ? 'Annual Income' : 'ஆண்டு வருமானம்',
                    value: _summarize(_annualIncome),
                    onTap: () => _openMultiSelectSheet(
                      title: 'Annual Income',
                      options: _kAnnualIncome,
                      selected: _annualIncome,
                      onApply: (v) => setState(() => _annualIncome = v),
                    ),
                  ),
                  const Divider(height: 1, color: Color(0xFFEEEAE7)),
                  _buildCriteriaRow(
                    label: lang == 'en' ? 'Employment Type' : 'வேலை வகை',
                    value: _summarize(_employmentType),
                    onTap: () => _openMultiSelectSheet(
                      title: 'Employment Type',
                      options: _kEmploymentTypes,
                      selected: _employmentType,
                      onApply: (v) => setState(() => _employmentType = v),
                    ),
                  ),
                  const Divider(height: 1, color: Color(0xFFEEEAE7)),
                  _buildCriteriaRow(
                    label: lang == 'en' ? 'Education' : 'கல்வி',
                    value: _summarize(_education),
                    onTap: () => _openMultiSelectSheet(
                      title: 'Education',
                      options: _kEducation,
                      selected: _education,
                      onApply: (v) => setState(() => _education = v),
                      hasSearch: true,
                    ),
                  ),

                  // Paid check or Lock card for Institution & Organization
                  if (_isPaid) ...[
                    const Divider(height: 1, color: Color(0xFFEEEAE7)),
                    _buildCriteriaRow(
                      label: lang == 'en' ? 'Institution Details' : 'கல்வி நிறுவனம்',
                      value: _institutionDetails,
                      onTap: () => _openTextInputSheet(
                        title: lang == 'en' ? 'Institution Details' : 'கல்வி நிறுவனம்',
                        currentValue: _institutionDetails,
                        onApply: (v) => setState(() => _institutionDetails = v.isEmpty ? 'Any' : v),
                        lang: lang,
                      ),
                    ),
                    const Divider(height: 1, color: Color(0xFFEEEAE7)),
                    _buildCriteriaRow(
                      label: lang == 'en' ? 'Organization Details' : 'அமைப்பு விவரங்கள்',
                      value: _organizationDetails,
                      onTap: () => _openTextInputSheet(
                        title: lang == 'en' ? 'Organization Details' : 'அமைப்பு விவரங்கள்',
                        currentValue: _organizationDetails,
                        onApply: (v) => setState(() => _organizationDetails = v.isEmpty ? 'Any' : v),
                        lang: lang,
                      ),
                    ),
                  ] else ...[
                    const Divider(height: 1, color: Color(0xFFEEEAE7)),
                    _buildPremiumLockedCard(
                      title: lang == 'en' ? 'Institution Details' : 'கல்வி நிறுவனம்',
                      subtitle: lang == 'en' ? 'Organization Details' : 'அமைப்பு விவரங்கள்',
                      lang: lang,
                      showSecondRow: true,
                      lockMessage: lang == 'en' ? 'Institution & Organization Details Locked' : 'கல்வி நிறுவனம் & அமைப்பு விவரங்கள் பூட்டப்பட்டுள்ளன',
                    ),
                  ],
                ]),

                // 4. Location Details
                _buildSectionHeader(lang == 'en' ? 'Location Details' : 'இருப்பிட விவரங்கள்'),
                _buildWhiteCard([
                  // Nearby Profiles checkbox
                  InkWell(
                    onTap: () => setState(() => _nearbyProfiles = !_nearbyProfiles),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 14),
                      child: Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  lang == 'en' ? 'Nearby Profiles' : 'அருகிலுள்ள சுயவிவரங்கள்',
                                  style: const TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.w600,
                                    color: KalyaThiruTheme.darkCharcoal,
                                  ),
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  lang == 'en'
                                      ? 'Matches near your location'
                                      : 'உங்கள் இருப்பிடத்திற்கு அருகிலுள்ள வரன்கள்',
                                  style: const TextStyle(
                                    fontSize: 11,
                                    color: KalyaThiruTheme.mutedGray,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            width: 22,
                            height: 22,
                            decoration: BoxDecoration(
                              color: _nearbyProfiles
                                  ? KalyaThiruTheme.primaryMaroon
                                  : Colors.transparent,
                              borderRadius: BorderRadius.circular(4),
                              border: Border.all(
                                color: _nearbyProfiles
                                    ? KalyaThiruTheme.primaryMaroon
                                    : const Color(0xFFBDBDBD),
                                width: 2,
                              ),
                            ),
                            child: _nearbyProfiles
                                ? const Icon(Icons.check,
                                    color: Colors.white, size: 16)
                                : null,
                          ),
                        ],
                      ),
                    ),
                  ),
                  const Divider(height: 1, color: Color(0xFFEEEAE7)),
                  _buildCriteriaRow(
                    label: lang == 'en' ? 'Country' : 'நாடு',
                    value: _summarize(_country),
                    onTap: () => _openMultiSelectSheet(
                      title: 'Country',
                      options: _kCountries,
                      selected: _country,
                      onApply: (v) => setState(() => _country = v),
                      hasSearch: true,
                    ),
                  ),
                  if (_locationViewMore) ...[
                    const Divider(height: 1, color: Color(0xFFEEEAE7)),
                    _buildCriteriaRow(
                      label: lang == 'en' ? 'Citizenship' : 'குடியுரிமை',
                      value: _summarize(_citizenship),
                      onTap: () => _openMultiSelectSheet(
                        title: 'Citizenship',
                        options: _kCitizenship,
                        selected: _citizenship,
                        onApply: (v) => setState(() => _citizenship = v),
                        hasSearch: true,
                      ),
                    ),
                  ],
                  _buildViewMoreToggle(
                    expanded: _locationViewMore,
                    onTap: () => setState(() => _locationViewMore = !_locationViewMore),
                    lang: lang,
                  ),
                ]),

                // 5. Lifestyle
                _buildSectionHeader(lang == 'en' ? 'Lifestyle' : 'வாழ்க்கை முறை'),
                _buildWhiteCard([
                  _buildCriteriaRow(
                    label: lang == 'en' ? 'Eating Habits' : 'உணவுப் பழக்கம்',
                    value: _summarize(_eatingHabits),
                    onTap: () => _openMultiSelectSheet(
                      title: 'Eating Habits',
                      options: _kEatingHabits,
                      selected: _eatingHabits,
                      onApply: (v) => setState(() => _eatingHabits = v),
                    ),
                  ),
                  if (_lifestyleViewMore) ...[
                    const Divider(height: 1, color: Color(0xFFEEEAE7)),
                    _buildCriteriaRow(
                      label: lang == 'en' ? 'Smoking Habits' : 'புகைபிடிக்கும் பழக்கம்',
                      value: _summarize(_smokingHabits),
                      onTap: () => _openMultiSelectSheet(
                        title: 'Smoking Habits',
                        options: _kSmokingDrinking,
                        selected: _smokingHabits,
                        onApply: (v) => setState(() => _smokingHabits = v),
                      ),
                    ),
                    const Divider(height: 1, color: Color(0xFFEEEAE7)),
                    _buildCriteriaRow(
                      label: lang == 'en' ? 'Drinking Habits' : 'மது அருந்தும் பழக்கம்',
                      value: _summarize(_drinkingHabits),
                      onTap: () => _openMultiSelectSheet(
                        title: 'Drinking Habits',
                        options: _kSmokingDrinking,
                        selected: _drinkingHabits,
                        onApply: (v) => setState(() => _drinkingHabits = v),
                      ),
                    ),
                  ],
                  _buildViewMoreToggle(
                    expanded: _lifestyleViewMore,
                    onTap: () => setState(() => _lifestyleViewMore = !_lifestyleViewMore),
                    lang: lang,
                  ),
                ]),

                // 6. Family Details
                _buildSectionHeader(lang == 'en' ? 'Family Details' : 'குடும்ப விவரங்கள்'),
                _buildWhiteCard([
                  _buildCriteriaRow(
                    label: lang == 'en' ? 'Family Status' : 'குடும்ப நிலை',
                    value: _summarize(_familyStatus),
                    onTap: () => _openMultiSelectSheet(
                      title: 'Family Status',
                      options: _kFamilyStatus,
                      selected: _familyStatus,
                      onApply: (v) => setState(() => _familyStatus = v),
                    ),
                  ),
                  if (_familyViewMore) ...[
                    const Divider(height: 1, color: Color(0xFFEEEAE7)),
                    _buildCriteriaRow(
                      label: lang == 'en' ? 'Family Type' : 'குடும்ப வகை',
                      value: _summarize(_familyType),
                      onTap: () => _openMultiSelectSheet(
                        title: 'Family Type',
                        options: _kFamilyType,
                        selected: _familyType,
                        onApply: (v) => setState(() => _familyType = v),
                      ),
                    ),
                    const Divider(height: 1, color: Color(0xFFEEEAE7)),
                    _buildCriteriaRow(
                      label: lang == 'en' ? 'Family Values' : 'குடும்ப பண்புகள்',
                      value: _summarize(_familyValues),
                      onTap: () => _openMultiSelectSheet(
                        title: 'Family Values',
                        options: _kFamilyValues,
                        selected: _familyValues,
                        onApply: (v) => setState(() => _familyValues = v),
                      ),
                    ),
                  ],
                  _buildViewMoreToggle(
                    expanded: _familyViewMore,
                    onTap: () => setState(() => _familyViewMore = !_familyViewMore),
                    lang: lang,
                  ),
                ]),

                // 7. Recently Created Profiles
                _buildSectionHeader(lang == 'en' ? 'Recently created profiles' : 'சமீபத்தில் உருவாக்கப்பட்ட சுயவிவரங்கள்'),
                _buildWhiteCard([
                  Padding(
                    padding: const EdgeInsets.fromLTRB(20, 14, 20, 8),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          lang == 'en' ? 'Profile Created' : 'சுயவிவரம் உருவாக்கப்பட்டது',
                          style: const TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                            color: KalyaThiruTheme.darkCharcoal,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          lang == 'en'
                              ? 'Profiles based on created date'
                              : 'உருவாக்கப்பட்ட தேதியின் அடிப்படையில்',
                          style: const TextStyle(
                            fontSize: 11,
                            color: KalyaThiruTheme.mutedGray,
                          ),
                        ),
                        const SizedBox(height: 12),
                        Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          children: [
                            'Any time', 'Today', 'Last 3 days', 'One week', 'One month'
                          ].map((opt) {
                            final isSelected = _profileCreatedRecency == opt;
                            return GestureDetector(
                              onTap: () => setState(() => _profileCreatedRecency = opt),
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 16, vertical: 10),
                                decoration: BoxDecoration(
                                  color: isSelected
                                      ? const Color(0xFFFFECE0)
                                      : Colors.white,
                                  borderRadius: BorderRadius.circular(8),
                                  border: Border.all(
                                    color: isSelected
                                        ? KalyaThiruTheme.primaryMaroon
                                        : const Color(0xFFE0E0E0),
                                  ),
                                ),
                                child: Text(
                                  opt,
                                  style: TextStyle(
                                    fontSize: 13,
                                    fontWeight: isSelected
                                        ? FontWeight.bold
                                        : FontWeight.normal,
                                    color: isSelected
                                        ? KalyaThiruTheme.primaryMaroon
                                        : KalyaThiruTheme.darkCharcoal,
                                  ),
                                ),
                              ),
                            );
                          }).toList(),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 12),
                ]),

                // 8. Profile Type
                _buildSectionHeader(lang == 'en' ? 'Profile Type' : 'சுயவிவர வகை'),
                _buildWhiteCard([
                  // Profiles with photo
                  InkWell(
                    onTap: () => setState(() => _profilesWithPhoto = !_profilesWithPhoto),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 14),
                      child: Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  lang == 'en' ? 'Profiles with photo' : 'புகைப்படங்களுடன் கூடிய சுயவிவரங்கள்',
                                  style: const TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.w600,
                                    color: KalyaThiruTheme.darkCharcoal,
                                  ),
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  lang == 'en'
                                      ? 'Matches who have added photos'
                                      : 'புகைப்படங்கள் சேர்த்த வரன்கள்',
                                  style: const TextStyle(
                                    fontSize: 11,
                                    color: KalyaThiruTheme.mutedGray,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            width: 22,
                            height: 22,
                            decoration: BoxDecoration(
                              color: _profilesWithPhoto
                                  ? KalyaThiruTheme.primaryMaroon
                                  : Colors.transparent,
                              borderRadius: BorderRadius.circular(4),
                              border: Border.all(
                                color: _profilesWithPhoto
                                    ? KalyaThiruTheme.primaryMaroon
                                    : const Color(0xFFBDBDBD),
                                width: 2,
                              ),
                            ),
                            child: _profilesWithPhoto
                                ? const Icon(Icons.check,
                                    color: Colors.white, size: 16)
                                : null,
                          ),
                        ],
                      ),
                    ),
                  ),
                  const Divider(height: 1, color: Color(0xFFEEEAE7)),
                  _buildCriteriaRow(
                    label: lang == 'en' ? "Don't Show Profiles" : 'காட்ட வேண்டாம்',
                    value: _summarize(_dontShowProfiles),
                    onTap: () => _openMultiSelectSheet(
                      title: "Don't Show Profiles",
                      options: _kDontShowProfiles,
                      selected: _dontShowProfiles,
                      onApply: (v) => setState(() => _dontShowProfiles = v),
                    ),
                  ),
                ]),

                const SizedBox(height: 16),
              ],
            ),
          ),
        ),

        // ── Bottom Action Bar ─────────────────────────────────────────────
        _buildCriteriaBottomBar(lang),
      ],
    );
  }

  // ── Bottom Action Bar ──────────────────────────────────────────────────────

  Widget _buildCriteriaBottomBar(String lang) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(color: Colors.grey[200]!)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      padding: const EdgeInsets.fromLTRB(16, 10, 16, 16),
      child: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Match count text
            Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: RichText(
                text: TextSpan(
                  children: [
                    TextSpan(
                      text: '$_matchCount  ',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: KalyaThiruTheme.darkCharcoal,
                      ),
                    ),
                    TextSpan(
                      text: lang == 'en'
                          ? 'matches based on your search criteria'
                          : 'தேடல் அளவுகோல்களின் அடிப்படையிலான வரன்கள்',
                      style: const TextStyle(
                        fontSize: 13,
                        color: KalyaThiruTheme.mutedGray,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            // 3 Action Buttons
            Row(
              children: [
                // Clear All
                Expanded(
                  child: OutlinedButton(
                    onPressed: _clearAll,
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(color: KalyaThiruTheme.outlineBorder),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(24)),
                      padding: const EdgeInsets.symmetric(vertical: 14),
                    ),
                    child: Text(
                      lang == 'en' ? 'Clear All' : 'அனைத்தையும் அழி',
                      style: const TextStyle(
                        color: KalyaThiruTheme.darkCharcoal,
                        fontWeight: FontWeight.bold,
                        fontSize: 13,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                // Save & Search (filled premium yellow)
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(lang == 'en'
                              ? 'Search criteria saved!'
                              : 'தேடல் அளவுகோல் சேமிக்கப்பட்டது!'),
                          backgroundColor: KalyaThiruTheme.antiqueGold,
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFD4A843),
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(24)),
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      elevation: 0,
                    ),
                    child: Text(
                      lang == 'en' ? 'Save & Search' : 'சேமி & தேடு',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 13,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                // Search (filled maroon)
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      context.push('/selected_matches', extra: {
                        'isPaidMember': _isPaid,
                        'title': 'Search Results',
                        'profiles': SampleProfiles.matchesForYou,
                      });
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: KalyaThiruTheme.primaryMaroon,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(24)),
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      elevation: 0,
                    ),
                    child: Text(
                      lang == 'en' ? 'Search' : 'தேடு',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 13,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // ─── TAB 2: BY PROFILE ID ─────────────────────────────────────────────────

  Widget _buildByProfileIdTab(String lang) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          const Spacer(flex: 1),
          // Matrimony ID Input
          TextField(
            controller: _profileIdController,
            decoration: InputDecoration(
              labelText: lang == 'en' ? 'Enter Matrimony ID' : 'மேட்ரிமனி ID உள்ளிடவும்',
              hintText: 'E.g. M123456',
              hintStyle: const TextStyle(color: KalyaThiruTheme.mutedGray),
              labelStyle: const TextStyle(color: KalyaThiruTheme.primaryMaroon),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: KalyaThiruTheme.primaryMaroon),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: KalyaThiruTheme.primaryMaroon),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(
                    color: KalyaThiruTheme.primaryMaroon, width: 2),
              ),
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
            ),
          ),
          const Spacer(flex: 6),
          // View Profile Button
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                final id = _profileIdController.text.trim();
                if (id.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(lang == 'en'
                          ? 'Please enter a Matrimony ID'
                          : 'தயவுசெய்து மேட்ரிமனி ID உள்ளிடவும்'),
                    ),
                  );
                  return;
                }
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(lang == 'en'
                        ? 'Searching profile: $id'
                        : 'சுயவிவரத்தைத் தேடுகிறது: $id'),
                    backgroundColor: KalyaThiruTheme.primaryMaroon,
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: KalyaThiruTheme.primaryMaroon,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(24)),
                padding: const EdgeInsets.symmetric(vertical: 16),
                elevation: 0,
              ),
              child: Text(
                lang == 'en' ? 'View Profile' : 'சுயவிவரத்தைக் காண்க',
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ),
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }

  // ─── TAB 3: SAVED SEARCH ──────────────────────────────────────────────────

  Widget _buildSavedSearchTab(String lang) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Empty state icon
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: const Color(0xFFF3E8E9),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.saved_search,
                color: KalyaThiruTheme.primaryMaroon,
                size: 48,
              ),
            ),
            const SizedBox(height: 24),
            Text(
              lang == 'en'
                  ? 'No saved searches yet. Click below to create your search criteria'
                  : 'இதுவரை சேமிக்கப்பட்ட தேடல்கள் இல்லை. கீழே கிளிக் செய்து தேடல் அளவுகோலை உருவாக்கவும்',
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 15,
                color: KalyaThiruTheme.darkCharcoal,
                height: 1.5,
              ),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () {
                _tabController.animateTo(0);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: KalyaThiruTheme.primaryMaroon,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(24)),
                padding:
                    const EdgeInsets.symmetric(horizontal: 32, vertical: 14),
                elevation: 0,
              ),
              child: Text(
                lang == 'en' ? 'Go to search' : 'தேடலுக்குச் செல்',
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 15,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ─── Shared Builders ───────────────────────────────────────────────────────

  /// Section header filled with brand yellow
  Widget _buildSectionHeader(String title) {
    return Container(
      width: double.infinity,
      decoration: const BoxDecoration(
        color: Color(0xFFFAF1D6), // Premium light brand gold background
        border: Border(
          left: BorderSide(color: KalyaThiruTheme.primaryMaroon, width: 4),
        ),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 15,
          fontWeight: FontWeight.bold,
          color: KalyaThiruTheme.primaryMaroon,
          letterSpacing: 0.5,
        ),
      ),
    );
  }

  /// White card container wrapping a list of widgets
  Widget _buildWhiteCard(List<Widget> children) {
    return Container(
      width: double.infinity,
      color: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: children,
      ),
    );
  }

  /// A criteria row with label on left, value + dropdown arrow on right
  Widget _buildCriteriaRow({
    required String label,
    required String value,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        child: Row(
          children: [
            Expanded(
              flex: 2,
              child: Text(
                label,
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  color: KalyaThiruTheme.darkCharcoal,
                ),
              ),
            ),
            Expanded(
              flex: 3,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Flexible(
                    child: Text(
                      value,
                      textAlign: TextAlign.right,
                      style: const TextStyle(
                        fontSize: 13,
                        color: KalyaThiruTheme.mutedGray,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  const SizedBox(width: 8),
                  const Icon(
                    Icons.keyboard_arrow_down,
                    color: KalyaThiruTheme.mutedGray,
                    size: 20,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// View more / View less toggle
  Widget _buildViewMoreToggle({
    required bool expanded,
    required VoidCallback onTap,
    required String lang,
  }) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        child: Row(
          children: [
            Text(
              expanded
                  ? (lang == 'en' ? 'View less' : 'குறைவாக காண்க')
                  : (lang == 'en' ? 'View more' : 'மேலும் காண்க'),
              style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.bold,
                color: KalyaThiruTheme.primaryMaroon,
              ),
            ),
            const SizedBox(width: 4),
            Icon(
              expanded ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down,
              color: KalyaThiruTheme.primaryMaroon,
              size: 18,
            ),
          ],
        ),
      ),
    );
  }

  /// Premium locked section card matching Image 2 premium style
  Widget _buildPremiumLockedCard({
    required String title,
    required String subtitle,
    required String lang,
    required String lockMessage,
    bool showSecondRow = false,
  }) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE0D6D0)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.02),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(
            Icons.lock_outline,
            color: KalyaThiruTheme.primaryMaroon,
            size: 36,
          ),
          const SizedBox(height: 10),
          Text(
            lockMessage,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: KalyaThiruTheme.darkCharcoal,
            ),
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () => context.push('/upgrade'),
            style: ElevatedButton.styleFrom(
              backgroundColor: KalyaThiruTheme.primaryMaroon,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
              elevation: 0,
            ),
            child: Text(
              lang == 'en' ? 'Upgrade to View' : 'பார்க்க மேம்படுத்தவும்',
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 14,
              ),
            ),
          ),
          const SizedBox(height: 16),
          const Divider(height: 1, color: Color(0xFFEEEAE7)),
          _buildLockedRow(title, lang),
          if (showSecondRow) ...[
            const Divider(height: 1, color: Color(0xFFEEEAE7)),
            _buildLockedRow(subtitle, lang),
          ],
        ],
      ),
    );
  }

  Widget _buildLockedRow(String label, String lang) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Row(
        children: [
          Expanded(
            child: Text(
              label,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: KalyaThiruTheme.darkCharcoal,
              ),
            ),
          ),
          const Text(
            'Any',
            style: TextStyle(fontSize: 13, color: KalyaThiruTheme.mutedGray),
          ),
          const SizedBox(width: 8),
          const Icon(Icons.lock_outline, color: KalyaThiruTheme.primaryMaroon, size: 16),
        ],
      ),
    );
  }

  // ─── Age & Height Sheets ───────────────────────────────────────────────────

  void _openAgeSheet(String lang) {
    double tempMin = _ageMin;
    double tempMax = _ageMax;
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (ctx) {
        return StatefulBuilder(
          builder: (ctx, setSheetState) {
            return Container(
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
              ),
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    lang == 'en' ? 'Select Age Range' : 'வயது வரம்பைத் தேர்ந்தெடுக்கவும்',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: KalyaThiruTheme.darkCharcoal,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    '${tempMin.toInt()} Yrs - ${tempMax.toInt()} Yrs',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: KalyaThiruTheme.primaryMaroon,
                    ),
                  ),
                  RangeSlider(
                    values: RangeValues(tempMin, tempMax),
                    min: 18,
                    max: 80,
                    activeColor: KalyaThiruTheme.primaryMaroon,
                    onChanged: (val) {
                      setSheetState(() {
                        tempMin = val.start;
                        tempMax = val.end;
                      });
                    },
                  ),
                  const SizedBox(height: 16),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        setState(() {
                          _ageMin = tempMin;
                          _ageMax = tempMax;
                        });
                        Navigator.pop(ctx);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: KalyaThiruTheme.primaryMaroon,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(24)),
                        padding: const EdgeInsets.symmetric(vertical: 14),
                      ),
                      child: Text(
                        lang == 'en' ? 'Apply' : 'பொருந்து',
                        style: const TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 15),
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  void _openHeightSheet(String lang) {
    double tempMin = _heightMin;
    double tempMax = _heightMax;
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (ctx) {
        return StatefulBuilder(
          builder: (ctx, setSheetState) {
            return Container(
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
              ),
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    lang == 'en' ? 'Select Height Range' : 'உயர வரம்பைத் தேர்ந்தெடுக்கவும்',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: KalyaThiruTheme.darkCharcoal,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    '${_heightToString(tempMin)} - ${_heightToString(tempMax)}',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: KalyaThiruTheme.primaryMaroon,
                    ),
                  ),
                  RangeSlider(
                    values: RangeValues(tempMin, tempMax),
                    min: 4.0,
                    max: 7.0,
                    divisions: 36,
                    activeColor: KalyaThiruTheme.primaryMaroon,
                    onChanged: (val) {
                      setSheetState(() {
                        tempMin = val.start;
                        tempMax = val.end;
                      });
                    },
                  ),
                  const SizedBox(height: 16),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        setState(() {
                          _heightMin = tempMin;
                          _heightMax = tempMax;
                        });
                        Navigator.pop(ctx);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: KalyaThiruTheme.primaryMaroon,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(24)),
                        padding: const EdgeInsets.symmetric(vertical: 14),
                      ),
                      child: Text(
                        lang == 'en' ? 'Apply' : 'பொருந்து',
                        style: const TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 15),
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }
}
