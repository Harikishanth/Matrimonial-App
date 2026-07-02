import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../core/theme/theme.dart';
import '../../onboarding/cubit/onboarding_cubit.dart';
import '../../profile/models/profile_model.dart';
import '../../../core/translation/option_translations.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool _isPaidMember = false;
  bool _isVerified = false;
  int _navIndex = 0;

  @override
  void initState() {
    super.initState();
    _loadState();
  }

  Future<void> _loadState() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _isPaidMember = prefs.getBool('is_paid_member') ?? false;
      _isVerified = prefs.getBool('is_verified') ?? false;
    });

    // Check if the popup should show today
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _checkAndShowDailyPopup(prefs);
    });
  }

  void _checkAndShowDailyPopup(SharedPreferences prefs) {
    final today = DateTime.now().toIso8601String().substring(0, 10);
    final lastShown = prefs.getString('last_daily_popup_date') ?? '';
    if (lastShown != today) {
      _showDailyPopupSheet(prefs, today);
    }
  }

  void _showDailyPopupSheet(SharedPreferences prefs, String today) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        final lang = context.watch<OnboardingCubit>().state.langCode;
        return Container(
          decoration: const BoxDecoration(
            color: KalyaThiruTheme.softIvory,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20),
              topRight: Radius.circular(20),
            ),
          ),
          padding: const EdgeInsets.fromLTRB(20, 20, 20, 32),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      lang == 'en' ? "Today's Picks" : "இன்றைய தேர்வுகள்",
                      style: const TextStyle(
                        fontFamily: 'Source Serif 4',
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: KalyaThiruTheme.primaryMaroon,
                      ),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close, color: KalyaThiruTheme.darkCharcoal),
                    onPressed: () {
                      prefs.setString('last_daily_popup_date', today);
                      Navigator.pop(context);
                    },
                  ),
                ],
              ),
              const Divider(),
              const SizedBox(height: 12),
              // List of 3 profiles
              Column(
                children: SampleProfiles.dailyPicks.map((profile) {
                  return Card(
                    margin: const EdgeInsets.symmetric(vertical: 8),
                    elevation: 1,
                    color: Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                    child: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Row(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(6),
                            child: Image.network(
                              profile.photoUrl ?? 'https://images.unsplash.com/photo-1544005313-94ddf0286df2?w=100',
                              width: 60,
                              height: 60,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) {
                                return Container(
                                  width: 60,
                                  height: 60,
                                  color: Colors.grey[200],
                                  alignment: Alignment.center,
                                  child: const Icon(
                                    Icons.broken_image_outlined,
                                    color: Colors.grey,
                                    size: 20,
                                  ),
                                );
                              },
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  translateOption(profile.name, lang),
                                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: KalyaThiruTheme.darkCharcoal),
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  '${profile.age} ${lang == 'en' ? 'Yrs' : 'வயது'} • ${profile.height} • ${translateOption(profile.city, lang)}',
                                  style: const TextStyle(fontSize: 12, color: KalyaThiruTheme.mutedGray),
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  translateOption(profile.occupation, lang),
                                  style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: KalyaThiruTheme.primaryMaroon),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 8),
                          Column(
                            children: [
                              ElevatedButton(
                                onPressed: () {
                                  prefs.setString('last_daily_popup_date', today);
                                  Navigator.pop(context);
                                  context.push('/profile', extra: profile);
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: KalyaThiruTheme.softIvory,
                                  foregroundColor: KalyaThiruTheme.primaryMaroon,
                                  side: const BorderSide(color: KalyaThiruTheme.outlineBorder, width: 1),
                                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                                  minimumSize: Size.zero,
                                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
                                ),
                                child: Text(
                                  lang == 'en' ? 'View' : 'காண்க',
                                  style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold),
                                ),
                              ),
                              const SizedBox(height: 6),
                              Text(
                                lang == 'en' ? '95% Match' : '95% பொருத்தம்',
                                style: TextStyle(
                                  fontSize: 10,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.green[700],
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  );
                }).toList(),
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    prefs.setString('last_daily_popup_date', today);
                    Navigator.pop(context);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: KalyaThiruTheme.primaryMaroon,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
                    padding: const EdgeInsets.symmetric(vertical: 14),
                  ),
                  child: Text(
                    lang == 'en' ? 'VIEW ALL DAILY PICKS' : 'இன்றைய தேர்வுகள் அனைத்தையும் காண்க',
                    textAlign: TextAlign.center,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> _togglePaidState(bool val) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('is_paid_member', val);
    setState(() {
      _isPaidMember = val;
    });
  }

  Future<void> _toggleVerifiedState(bool val) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('is_verified', val);
    setState(() {
      _isVerified = val;
    });
  }

  // Calculate dynamic completeness based on filled onboarding fields
  int _calculateCompleteness(OnboardingState state) {
    int score = 35; // base percentage
    if (state.firstName != null && state.firstName!.isNotEmpty) score += 10;
    if (state.religion != null && state.religion!.isNotEmpty) score += 10;
    if (state.qualification != null && state.qualification!.isNotEmpty) score += 15;
    if (state.photoPath != null && state.photoPath!.isNotEmpty) score += 15;
    if (state.familyStatus != null && state.familyStatus!.isNotEmpty) score += 15;
    if (_isVerified) score += 15;
    return score > 100 ? 100 : score;
  }

  // Subscription Details Sheet
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
                  Navigator.pop(context);
                  context.push('/upgrade');
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

  // Simulation ID Verification Dialog
  void _showVerificationSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return Padding(
          padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
          child: Container(
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
                  'Verify Your Profile\n(உங்கள் சுயவிவரத்தை சரிபார்க்கவும்)',
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                        color: KalyaThiruTheme.primaryMaroon,
                        fontWeight: FontWeight.bold,
                      ),
                ),
                const SizedBox(height: 16),
                const TextField(
                  decoration: InputDecoration(
                    labelText: 'Aadhaar / ID Card Number',
                    hintText: 'Enter 12-digit Aadhaar number',
                  ),
                  keyboardType: TextInputType.number,
                ),
                const SizedBox(height: 24),
                ElevatedButton(
                  onPressed: () {
                    _toggleVerifiedState(true);
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('ID Verified successfully! (விவரங்கள் சரிபார்க்கப்பட்டது!)'),
                        backgroundColor: Colors.green,
                      ),
                    );
                  },
                  child: const Text('VERIFY NOW (சரிபார்க்கவும்)'),
                ),
                const SizedBox(height: 12),
              ],
            ),
          ),
        );
      },
    );
  }

  // Premium photo management bottom sheet
  void _showPhotoBottomSheet(BuildContext context, OnboardingState state, String lang) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        final isFemale = state.gender?.toLowerCase() == 'female';
        final hasCustomPhoto = state.photoPath != null && state.photoPath!.isNotEmpty;
        
        return Container(
          decoration: const BoxDecoration(
            color: Color(0xFFFEF8F4), // Heritage cream background
            borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
            boxShadow: [
              BoxShadow(
                color: Colors.black26,
                blurRadius: 10,
                offset: Offset(0, -2),
              ),
            ],
          ),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Premium handle bar
              Center(
                child: Container(
                  width: 44,
                  height: 4,
                  decoration: BoxDecoration(
                    color: KalyaThiruTheme.outlineVariant,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: 24),
              // Header
              Text(
                lang == 'en' ? 'Manage Profile Photo' : 'சுயவிவரப் புகைப்படம்',
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: KalyaThiruTheme.primaryMaroon,
                  fontFamily: 'Outfit',
                ),
              ),
              const SizedBox(height: 6),
              Text(
                lang == 'en' 
                    ? 'Upload or update your profile picture to get 3x higher matches.' 
                    : '3 மடங்கு அதிக வரன்களைப் பெற உங்கள் புகைப்படத்தைப் பதிவேற்றவும் அல்லது மாற்றவும்.',
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 13,
                  color: KalyaThiruTheme.mutedGray,
                ),
              ),
              const SizedBox(height: 24),
              
              // Camera option card
              InkWell(
                onTap: () {
                  // Simulate Camera Click: update state with a new premium face
                  final String newPhoto = isFemale
                      ? 'https://images.unsplash.com/photo-1544005313-94ddf0286df2?w=400' // Premium female face
                      : 'https://images.unsplash.com/photo-1506794778202-cad84cf45f1d?w=400'; // Premium male face
                  context.read<OnboardingCubit>().updateFields(photoPath: newPhoto);
                  Navigator.pop(context);
                  
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        lang == 'en' 
                            ? 'Camera photo uploaded successfully!' 
                            : 'புகைப்படம் வெற்றிகரமாகப் பதிவேற்றப்பட்டது!',
                      ),
                      backgroundColor: KalyaThiruTheme.primaryMaroon,
                    ),
                  );
                },
                borderRadius: BorderRadius.circular(12),
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    border: Border.all(color: KalyaThiruTheme.outlineBorder, width: 1.5),
                    borderRadius: BorderRadius.circular(12),
                    color: Colors.white,
                  ),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: const BoxDecoration(
                          color: Color(0xFFF3EDE9),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.camera_alt_outlined,
                          color: KalyaThiruTheme.primaryMaroon,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              lang == 'en' ? 'Take a Photo' : 'புகைப்படம் எடுக்கவும்',
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: KalyaThiruTheme.primaryMaroon,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              lang == 'en' ? 'Use camera to capture directly' : 'நேரடியாகக் படம் பிடிக்க கேமராவைப் பயன்படுத்தவும்',
                              style: const TextStyle(
                                fontSize: 12,
                                color: KalyaThiruTheme.mutedGray,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const Icon(Icons.chevron_right, color: KalyaThiruTheme.primaryMaroon),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 12),
              
              // Gallery option card
              InkWell(
                onTap: () {
                  // Simulate Gallery Pick: update state with a new premium face
                  final String newPhoto = isFemale
                      ? 'https://images.unsplash.com/photo-1494790108377-be9c29b29330?w=400' // Premium female face
                      : 'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=400'; // Premium male face
                  context.read<OnboardingCubit>().updateFields(photoPath: newPhoto);
                  Navigator.pop(context);
                  
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        lang == 'en' 
                            ? 'Gallery photo replaced successfully!' 
                            : 'கேலரி புகைப்படம் வெற்றிகரமாக மாற்றப்பட்டது!',
                      ),
                      backgroundColor: KalyaThiruTheme.primaryMaroon,
                    ),
                  );
                },
                borderRadius: BorderRadius.circular(12),
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    border: Border.all(color: KalyaThiruTheme.outlineBorder, width: 1.5),
                    borderRadius: BorderRadius.circular(12),
                    color: Colors.white,
                  ),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: const BoxDecoration(
                          color: Color(0xFFF3EDE9),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.photo_library_outlined,
                          color: KalyaThiruTheme.primaryMaroon,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              lang == 'en' ? 'Choose from Gallery' : 'கேலரியில் இருந்து தேர்ந்தெடுக்கவும்',
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: KalyaThiruTheme.primaryMaroon,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              lang == 'en' ? 'Pick a photo from your photo library' : 'உங்கள் கேலரியில் இருந்து ஒரு படத்தைத் தேர்ந்தெடுக்கவும்',
                              style: const TextStyle(
                                fontSize: 12,
                                color: KalyaThiruTheme.mutedGray,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const Icon(Icons.chevron_right, color: KalyaThiruTheme.primaryMaroon),
                    ],
                  ),
                ),
              ),
              
              // Delete Option (only visible if photo exists)
              if (hasCustomPhoto) ...[
                const SizedBox(height: 16),
                const Divider(color: KalyaThiruTheme.outlineVariant),
                const SizedBox(height: 8),
                TextButton.icon(
                  onPressed: () {
                    // Reset photo
                    context.read<OnboardingCubit>().updateFields(photoPath: '');
                    Navigator.pop(context);
                    
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          lang == 'en' 
                              ? 'Profile photo removed.' 
                              : 'சுயவிவரப் புகைப்படம் நீக்கப்பட்டது.',
                        ),
                        backgroundColor: KalyaThiruTheme.primaryMaroon,
                      ),
                    );
                  },
                  icon: const Icon(Icons.delete_outline, color: Colors.redAccent),
                  label: Text(
                    lang == 'en' ? 'Remove Current Photo' : 'தற்போதைய புகைப்படத்தை நீக்கு',
                    style: const TextStyle(
                      color: Colors.redAccent,
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
                    ),
                  ),
                ),
              ],
              const SizedBox(height: 16),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final state = context.watch<OnboardingCubit>().state;
    final cubit = context.read<OnboardingCubit>();
    final String lang = state.langCode;

    final int completenessPercent = _calculateCompleteness(state);
    final bool isProfileComplete = completenessPercent >= 100;

    // Matches scrollable sideways: limited to exactly 3 profiles as requested
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.5,
        centerTitle: false,
        title: Text(
          'KalyaThiru',
          style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                color: KalyaThiruTheme.primaryMaroon,
                fontWeight: FontWeight.bold,
              ),
        ),
        actions: [
          // Language Toggle Button
          GestureDetector(
            onTap: () => cubit.toggleLanguage(),
            child: Container(
              margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 4),
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                border: Border.all(color: KalyaThiruTheme.outlineBorder),
                borderRadius: BorderRadius.circular(4),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.language, size: 14, color: KalyaThiruTheme.primaryMaroon),
                  const SizedBox(width: 4),
                  Text(
                    lang == 'en' ? 'தமிழ்' : 'EN',
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: KalyaThiruTheme.primaryMaroon,
                    ),
                  ),
                ],
              ),
            ),
          ),
          // Notification Bell with Badge
          Stack(
            alignment: Alignment.center,
            children: [
              IconButton(
                icon: const Icon(Icons.notifications_none_outlined, color: KalyaThiruTheme.darkCharcoal),
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('No new notifications')),
                  );
                },
              ),
              Positioned(
                top: 12,
                right: 12,
                child: Container(
                  width: 8,
                  height: 8,
                  decoration: const BoxDecoration(
                    color: Color(0xFFBA1A1A),
                    shape: BoxShape.circle,
                  ),
                ),
              ),
            ],
          ),
          // Drawer menu trigger
          IconButton(
            icon: const Icon(Icons.menu, color: KalyaThiruTheme.darkCharcoal),
            onPressed: () => context.push('/profile_menu'),
          ),
          const SizedBox(width: 8),
        ],
      ),
      endDrawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: const BoxDecoration(color: KalyaThiruTheme.primaryMaroon),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'KalyaThiru Settings',
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(color: Colors.white),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Bilingual Simulation Mode',
                    style: TextStyle(color: Colors.white70, fontSize: 12),
                  ),
                ],
              ),
            ),
            ListTile(
              leading: const Icon(Icons.language, color: KalyaThiruTheme.primaryMaroon),
              title: Text(lang == 'en' ? 'Switch to Tamil (தமிழ்)' : 'Switch to English'),
              onTap: () {
                cubit.toggleLanguage();
                Navigator.pop(context);
              },
            ),
            SwitchListTile(
              secondary: const Icon(Icons.verified_user, color: KalyaThiruTheme.primaryMaroon),
              title: const Text('Simulate Verified Profile'),
              subtitle: const Text('Marks completeness at 100%'),
              value: _isVerified,
              onChanged: (val) {
                _toggleVerifiedState(val);
                Navigator.pop(context);
              },
            ),
            SwitchListTile(
              secondary: const Icon(Icons.star, color: KalyaThiruTheme.primaryMaroon),
              title: const Text('Simulate Paid/Premium State'),
              subtitle: const Text('Unblurs "Who Viewed You"'),
              value: _isPaidMember,
              onChanged: (val) {
                _togglePaidState(val);
                Navigator.pop(context);
              },
            ),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.restart_alt, color: Colors.red),
              title: const Text('Reset Onboarding'),
              subtitle: const Text('Clears state & restarts'),
              onTap: () {
                cubit.clearState();
                _togglePaidState(false);
                _toggleVerifiedState(false);
                Navigator.pop(context);
                context.go('/');
              },
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: 16),
            // 1. Profile Header Box
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(color: KalyaThiruTheme.outlineVariant),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    GestureDetector(
                      onTap: () => _showPhotoBottomSheet(context, state, lang),
                      child: MouseRegion(
                        cursor: SystemMouseCursors.click,
                        child: Stack(
                          children: [
                            CircleAvatar(
                              radius: 28,
                              backgroundImage: NetworkImage(
                                state.photoPath != null && state.photoPath!.isNotEmpty
                                    ? state.photoPath!
                                    : 'https://images.unsplash.com/photo-1500648767791-00dcc994a43e?w=400',
                              ),
                            ),
                            Positioned(
                              bottom: 0,
                              right: 0,
                              child: Container(
                                padding: const EdgeInsets.all(2),
                                decoration: BoxDecoration(
                                  color: _isVerified || isProfileComplete
                                      ? Colors.blue
                                      : KalyaThiruTheme.antiqueGold,
                                  shape: BoxShape.circle,
                                  border: Border.all(color: Colors.white, width: 1.5),
                                ),
                                child: Icon(
                                  _isVerified || isProfileComplete ? Icons.verified : Icons.add,
                                  color: Colors.white,
                                  size: 10,
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            state.firstName != null && state.firstName!.isNotEmpty
                                ? translateOption('${state.firstName} ${state.lastName ?? ""}', lang)
                                : translateOption('Ananth Raman', lang),
                            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            _isPaidMember
                                ? (lang == 'en' ? 'Elite Member' : 'எலைட் உறுப்பினர்')
                                : (lang == 'en' ? 'Free Member' : 'இலவச உறுப்பினர்'),
                            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                  color: KalyaThiruTheme.mutedGray,
                                ),
                          ),
                        ],
                      ),
                    ),
                    if (!_isPaidMember)
                      ElevatedButton(
                        onPressed: () => context.push('/upgrade'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFFFBF00),
                          foregroundColor: Colors.black,
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                          minimumSize: Size.zero,
                          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(4),
                          ),
                        ),
                        child: Text(
                          lang == 'en' ? 'UPGRADE' : 'மேம்படுத்தவும்',
                          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
                        ),
                      ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            // 2. Profile Completeness Progress Tracker (Hidden if 100% complete)
            if (!isProfileComplete) ...[
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(color: KalyaThiruTheme.outlineVariant),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Text(
                              lang == 'en'
                                  ? 'Complete Your Profile'
                                  : 'உங்கள் சுயவிவரத்தைப் பூர்த்தி செய்யவும்',
                              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                    fontWeight: FontWeight.bold,
                                  ),
                            ),
                          ),
                          Container(
                            width: 12,
                            height: 12,
                            decoration: const BoxDecoration(
                              color: Color(0xFFBA1A1A),
                              shape: BoxShape.circle,
                            ),
                          )
                        ],
                      ),
                      const SizedBox(height: 6),
                      Text(
                        lang == 'en'
                            ? 'Profile completeness score $completenessPercent%'
                            : 'சுயவிவர நிறைவு சதவீதம் $completenessPercent%',
                        style: const TextStyle(
                          color: KalyaThiruTheme.mutedGray,
                          fontSize: 12,
                        ),
                      ),
                      const SizedBox(height: 12),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(3),
                        child: LinearProgressIndicator(
                          value: completenessPercent / 100,
                          minHeight: 6,
                          backgroundColor: Colors.grey[200],
                          color: KalyaThiruTheme.primaryMaroon,
                        ),
                      ),
                      const SizedBox(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          _buildQuickActionButton(
                            icon: Icons.camera_alt_outlined,
                            bg: KalyaThiruTheme.primaryMaroon,
                            title: lang == 'en' ? 'Add Photo' : 'புகைப்படம்',
                            onTap: () => context.go('/edit_profile'),
                          ),
                          _buildQuickActionButton(
                            icon: Icons.verified_user_outlined,
                            bg: KalyaThiruTheme.antiqueGold,
                            title: lang == 'en' ? 'Verify Profile' : 'சரிபார்',
                            onTap: _showVerificationSheet,
                          ),
                          _buildQuickActionButton(
                            icon: Icons.people_outline,
                            bg: const Color(0xFF8B5A2B),
                            title: lang == 'en' ? 'Family Details' : 'குடும்ப விவரங்கள்',
                            onTap: () => context.go('/edit_profile'),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),
            ],

            // 3. Heritage Trust Elite Banner
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [KalyaThiruTheme.primaryDark, KalyaThiruTheme.primaryMaroon],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Column(
                  children: [
                    const Icon(Icons.star, color: KalyaThiruTheme.antiqueGold, size: 28),
                    const SizedBox(height: 12),
                    Text(
                      lang == 'en'
                          ? 'Heritage Trust Elite'
                          : 'பாரம்பரிய அறக்கட்டளை எலைட்',
                      style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      lang == 'en'
                          ? 'You qualify for our exclusive premium circle. Connect with highly compatible, verified elite matches.'
                          : 'எங்கள் பிரத்யேக பிரீமியம் வட்டத்திற்கு நீங்கள் தகுதியுடையவர். மிகவும் இணக்கமான, சரிபார்க்கப்பட்ட எலைட் வரன்களுடன் இணையுங்கள்.',
                      textAlign: TextAlign.center,
                      style: const TextStyle(color: Colors.white70, fontSize: 13, height: 1.4),
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Details confirmed!')),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFFFE599),
                        foregroundColor: KalyaThiruTheme.primaryDark,
                        elevation: 0,
                      ),
                      child: Text(
                        lang == 'en' ? 'Confirm Details' : 'விவரங்களை உறுதிப்படுத்தவும்',
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),

            // 3.5 Today's Picks Header & Carousel
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        lang == 'en' ? "Today's Picks" : "இன்றைய தேர்வுகள்",
                        style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        lang == 'en' ? 'Handpicked for you today' : 'இன்று உங்களுக்காக தேர்ந்தெடுக்கப்பட்டவை',
                        style: const TextStyle(color: KalyaThiruTheme.mutedGray, fontSize: 12),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),

            // Today's Picks Horizontal scrolling
            SizedBox(
              height: 280,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemCount: SampleProfiles.dailyPicks.length + 1,
                separatorBuilder: (context, index) => const SizedBox(width: 16),
                itemBuilder: (context, index) {
                  if (index == SampleProfiles.dailyPicks.length) {
                    return _buildViewAllCard(
                      context,
                      width: 200,
                      lang: lang,
                      onTap: _triggerDailyPopup,
                    );
                  }
                  final p = SampleProfiles.dailyPicks[index];
                  return GestureDetector(
                    onTap: () {
                      context.push('/profile', extra: p);
                    },
                    child: Container(
                      width: 200,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        border: Border.all(color: KalyaThiruTheme.outlineVariant),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Expanded(
                            child: Stack(
                              children: [
                                Container(
                                  decoration: BoxDecoration(
                                    borderRadius: const BorderRadius.vertical(top: Radius.circular(8)),
                                    image: DecorationImage(
                                      image: NetworkImage(p.photoUrl ?? 'https://images.unsplash.com/photo-1524504388940-b1c1722653e1?w=400'),
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                                Positioned(
                                  top: 8,
                                  left: 8,
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                    decoration: BoxDecoration(
                                      color: const Color(0xFFBA1A1A), // alert red accent
                                      borderRadius: BorderRadius.circular(2),
                                    ),
                                    child: Text(
                                      lang == 'en' ? '95% MATCH' : '95% பொருத்தம்',
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 9,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(12),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  translateOption(p.name, lang),
                                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  "${p.age} ${lang == 'en' ? 'Yrs' : 'வயது'}, ${p.height} • ${translateOption(p.city, lang)}",
                                  style: const TextStyle(color: KalyaThiruTheme.mutedGray, fontSize: 11),
                                ),
                                const SizedBox(height: 6),
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                  decoration: BoxDecoration(
                                    color: KalyaThiruTheme.softIvory,
                                    border: Border.all(color: KalyaThiruTheme.outlineBorder),
                                    borderRadius: BorderRadius.circular(2),
                                  ),
                                  child: Text(
                                    translateOption(p.occupation, lang),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: const TextStyle(
                                      color: KalyaThiruTheme.primaryMaroon,
                                      fontSize: 9,
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
                  );
                },
              ),
            ),
            const SizedBox(height: 24),

            // 4. Matches For You Header
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          lang == 'en' ? 'Matches For You' : 'உங்களுக்கான வரன்கள்',
                          style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          lang == 'en' ? 'Based on your preferences' : 'உங்கள் விருப்பங்களின் அடிப்படையில்',
                          style: const TextStyle(color: KalyaThiruTheme.mutedGray, fontSize: 12),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),

            // Matches For You Sideways Scrolling (Limited to 3)
            SizedBox(
              height: 280,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemCount: SampleProfiles.matchesForYou.length + 1,
                separatorBuilder: (context, index) => const SizedBox(width: 16),
                itemBuilder: (context, index) {
                  if (index == SampleProfiles.matchesForYou.length) {
                    return _buildViewAllCard(
                      context,
                      width: 200,
                      lang: lang,
                      onTap: () {
                        context.push('/selected_matches', extra: {
                          'isPaidMember': _isPaidMember,
                          'title': lang == 'en' ? 'Matches For You' : 'உங்களுக்கான வரன்கள்',
                          'profiles': SampleProfiles.matchesForYou,
                        });
                      },
                    );
                  }
                  final p = SampleProfiles.matchesForYou[index];
                  return GestureDetector(
                    onTap: () {
                      context.push('/profile', extra: p);
                    },
                    child: Container(
                      width: 200,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        border: Border.all(color: KalyaThiruTheme.outlineVariant),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Expanded(
                            child: Stack(
                              children: [
                                Container(
                                  decoration: BoxDecoration(
                                    borderRadius: const BorderRadius.vertical(top: Radius.circular(8)),
                                    image: DecorationImage(
                                      image: NetworkImage(p.photoUrl ?? 'https://images.unsplash.com/photo-1524504388940-b1c1722653e1?w=400'),
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                                if (p.isVerified)
                                  Positioned(
                                    top: 8,
                                    left: 8,
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                      decoration: BoxDecoration(
                                        color: const Color(0xFF6B8E23), // olive green
                                        borderRadius: BorderRadius.circular(2),
                                      ),
                                      child: Text(
                                        lang == 'en' ? 'VERIFIED' : 'சரிபார்க்கப்பட்டது',
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 9,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ),
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(12),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  translateOption(p.name, lang),
                                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  "${p.age} ${lang == 'en' ? 'Yrs' : 'வயது'}, ${p.height} • ${translateOption(p.city, lang)}",
                                  style: const TextStyle(color: KalyaThiruTheme.mutedGray, fontSize: 11),
                                ),
                                const SizedBox(height: 6),
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                  decoration: BoxDecoration(
                                    color: const Color(0xFFFDE8E9),
                                    borderRadius: BorderRadius.circular(2),
                                  ),
                                  child: Text(
                                    translateOption(p.occupation, lang),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: const TextStyle(
                                      color: Color(0xFFE05260),
                                      fontSize: 9,
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
                  );
                },
              ),
            ),
            const SizedBox(height: 24),

            // 5. Become a Paid Member & Save 61%
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: const Color(0xFFFFFDF5),
                  border: Border.all(color: const Color(0xFFF0E5D0)),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: const Color(0xFF5A1827),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: const Text(
                          'LIMITED OFFER',
                          style: TextStyle(color: Colors.white, fontSize: 8, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      lang == 'en'
                          ? 'Become a Paid Member & Save 61%'
                          : 'கட்டண உறுப்பினராகி 61% சேமிக்கவும்',
                      style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                            color: KalyaThiruTheme.primaryDark,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                    const SizedBox(height: 16),
                    _buildCheckPoint(
                      title: lang == 'en' ? 'Unlimited messaging' : 'வரம்பற்ற செய்திகள்',
                    ),
                    _buildCheckPoint(
                      title: lang == 'en' ? 'Call/WhatsApp verified matches' : 'அழைப்பு/வாட்ஸ்அப் வசதி',
                    ),
                    _buildCheckPoint(
                      title: lang == 'en' ? 'See who viewed you' : 'உங்களைப் பார்த்தவர்களைக் காணுங்கள்',
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: _showSubscriptionSheet,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: KalyaThiruTheme.primaryMaroon,
                        padding: const EdgeInsets.symmetric(vertical: 12),
                      ),
                      child: Text(
                        lang == 'en' ? 'See Membership Plans' : 'திட்டங்களைக் காண்க',
                        style: const TextStyle(fontSize: 14),
                      ),
                    ),
                    const SizedBox(height: 16),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(6),
                      child: Image.network(
                        'https://images.unsplash.com/photo-1515934751635-c81c6bc9a2d8?w=600',
                        height: 160,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return Container(
                            height: 160,
                            color: Colors.grey[200],
                            alignment: Alignment.center,
                            child: const Icon(
                              Icons.broken_image_outlined,
                              color: Colors.grey,
                              size: 48,
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),

            // 6. Who Viewed You (11) (Blurred / Lock Overlay if Free)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          lang == 'en' ? 'Who Viewed You (11)' : 'உங்களைப் பார்த்தவர்கள் (11)',
                          style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          lang == 'en' ? 'Upgrade to see their details' : 'விவரங்களைக் காண மேம்படுத்தவும்',
                          style: const TextStyle(color: KalyaThiruTheme.mutedGray, fontSize: 11),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),
            SizedBox(
              height: 200,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemCount: SampleProfiles.whoViewedYou.length + 1,
                separatorBuilder: (context, index) => const SizedBox(width: 16),
                itemBuilder: (context, index) {
                  if (index == SampleProfiles.whoViewedYou.length) {
                    return _buildViewAllCard(
                      context,
                      width: 130,
                      lang: lang,
                      onTap: () => context.push('/upgrade'),
                    );
                  }
                  final profile = SampleProfiles.whoViewedYou[index];
                  return InkWell(
                    onTap: _isPaidMember
                        ? () => context.push('/profile', extra: profile)
                        : () => context.push('/upgrade'),
                    child: Container(
                      width: 130,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        border: Border.all(color: KalyaThiruTheme.outlineVariant),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Expanded(
                            child: Stack(
                              children: [
                                Container(
                                  decoration: BoxDecoration(
                                    borderRadius: const BorderRadius.vertical(top: Radius.circular(8)),
                                    image: DecorationImage(
                                      image: NetworkImage(profile.photoUrl ?? 'https://images.unsplash.com/photo-1544005313-94ddf0286df2?w=400'),
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                                if (!_isPaidMember)
                                  Positioned.fill(
                                    child: ClipRRect(
                                      borderRadius: const BorderRadius.vertical(top: Radius.circular(8)),
                                      child: BackdropFilter(
                                        filter: ui.ImageFilter.blur(sigmaX: 8, sigmaY: 8),
                                        child: Container(
                                          color: const Color(0x1A000000),
                                          child: const Center(
                                            child: Icon(Icons.lock, color: Colors.white, size: 24),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  translateOption(profile.name, lang),
                                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  "${profile.age} ${lang == 'en' ? 'Yrs' : 'வயது'}, ${profile.height}",
                                  style: const TextStyle(color: KalyaThiruTheme.mutedGray, fontSize: 10),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 24),

            // 7. Profiles You Viewed (15)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      lang == 'en' ? 'Profiles You Viewed (15)' : 'உங்களால் பார்க்கப்பட்ட வரன்கள் (15)',
                      style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),
            SizedBox(
              height: 220,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemCount: SampleProfiles.dailyPicks.length + 1,
                separatorBuilder: (context, index) => const SizedBox(width: 16),
                itemBuilder: (context, index) {
                  if (index == SampleProfiles.dailyPicks.length) {
                    return _buildViewAllCard(
                      context,
                      width: 140,
                      lang: lang,
                      onTap: () {
                        context.push('/viewed_profiles', extra: {
                          'isPaidMember': _isPaidMember,
                          'title': lang == 'en' ? 'Profiles You Viewed' : 'உங்களால் பார்க்கப்பட்ட வரன்கள்',
                          'profiles': SampleProfiles.whoViewedYou,
                        });
                      },
                    );
                  }
                  final profile = SampleProfiles.dailyPicks[index];
                  return GestureDetector(
                    onTap: () => context.push('/profile', extra: profile),
                    child: Container(
                      width: 140,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        border: Border.all(color: KalyaThiruTheme.outlineVariant),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Expanded(
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: const BorderRadius.vertical(top: Radius.circular(8)),
                                image: DecorationImage(
                                  image: NetworkImage(profile.photoUrl ?? 'https://images.unsplash.com/photo-1494790108377-be9c29b29330?w=400'),
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  translateOption(profile.name, lang),
                                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  "${profile.age} ${lang == 'en' ? 'Yrs' : 'வயது'}, ${profile.height}",
                                  style: const TextStyle(color: KalyaThiruTheme.mutedGray, fontSize: 10),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  lang == 'en' ? '2 hours ago' : '2 மணிநேரத்திற்கு முன்பு',
                                  style: TextStyle(color: Colors.grey[400], fontSize: 8),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 12),

            // 8. Photo Requests Container
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: const Color(0xFFFDF7F8),
                  border: Border.all(color: const Color(0xFFF5E1E3)),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      lang == 'en' ? 'Photo Requests' : 'புகைப்படக் கோரிக்கைகள்',
                      style: const TextStyle(fontWeight: FontWeight.bold, color: KalyaThiruTheme.primaryDark),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      lang == 'en' ? 'Requests received (1)' : 'பெறப்பட்ட கோரிக்கைகள் (1)',
                      style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      lang == 'en'
                          ? '1 member has requested you to add a photo to your profile.'
                          : 'உங்கள் சுயவிவரத்தில் புகைப்படத்தைச் சேர்க்க 1 உறுப்பினர் கோரியுள்ளார்.',
                      style: const TextStyle(fontSize: 11, color: KalyaThiruTheme.mutedGray),
                    ),
                    const SizedBox(height: 12),
                    ElevatedButton(
                      onPressed: () => context.go('/edit_profile'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: KalyaThiruTheme.primaryMaroon,
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        minimumSize: Size.zero,
                      ),
                      child: Text(lang == 'en' ? 'Add Photo' : 'புகைப்படம் சேர்க்கவும்', style: const TextStyle(fontSize: 12)),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            // 9. Success Stories Container
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(color: KalyaThiruTheme.outlineVariant),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(
                      lang == 'en' ? 'Success Stories' : 'வெற்றிக் கதைகள்',
                      style: const TextStyle(fontWeight: FontWeight.bold, color: KalyaThiruTheme.primaryMaroon),
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        const CircleAvatar(
                          radius: 20,
                          backgroundImage: NetworkImage(
                            'https://images.unsplash.com/photo-1515934751635-c81c6bc9a2d8?w=100',
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                lang == 'en'
                                    ? '"Found my soulmate within 3 months! KalyaThiru verified profiles made it so easy."'
                                    : '"3 மாதங்களில் எனது வாழ்க்கைத்துணையை கண்டடைந்தேன்! கல்யாதிருவின் சரிபார்க்கப்பட்ட சுயவிவரங்கள் அதை எளிதாக்கியது."',
                                style: const TextStyle(fontStyle: FontStyle.italic, fontSize: 11, height: 1.3),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                lang == 'en' ? '— Anjali & Vikram' : '— அஞ்சலி & விக்ரம்',
                                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 10, color: Colors.grey[600]),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            // 10. Limca Book of Records Card
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(color: KalyaThiruTheme.outlineVariant),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: const Color(0xFFFFF9E6),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Icon(Icons.workspace_premium_outlined, color: KalyaThiruTheme.antiqueGold, size: 24),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            lang == 'en' ? 'Lakhs of Happy Marriages' : 'லட்சக்கணக்கான மகிழ்ச்சியான திருமணங்கள்',
                            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            lang == 'en'
                                ? 'Featured in the Limca Book of Records for the highest documented marriages.'
                                : 'அதிகமான திருமணங்களை பதிவு செய்ததற்காக லிம்கா சாதன புத்தகத்தில் இடம் பெற்றுள்ளது.',
                            style: const TextStyle(fontSize: 10, color: KalyaThiruTheme.mutedGray),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
      // Custom Premium BottomNavigationBar
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border(top: BorderSide(color: Colors.grey[200]!, width: 1)),
        ),
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: SafeArea(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildBottomNavItem(0, Icons.home, lang == 'en' ? 'Home' : 'முகப்பு'),
              _buildBottomNavItem(1, Icons.people_outline, lang == 'en' ? 'Matches' : 'வரன்கள்'),
              _buildBottomNavItem(2, Icons.favorite_border, lang == 'en' ? 'Interests' : 'ஆர்வங்கள்'),
              _buildBottomNavItem(3, Icons.auto_awesome_outlined, lang == 'en' ? 'AI Match' : 'AI பொருத்தம்'),
              _buildBottomNavItem(4, Icons.chat_bubble_outline, lang == 'en' ? 'Messages' : 'செய்திகள்'),
              _buildBottomNavItem(5, Icons.star_border, lang == 'en' ? 'Upgrade' : 'மேம்பாடு', isUpgrade: true),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildQuickActionButton({
    required IconData icon,
    required Color bg,
    required String title,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: bg,
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: Colors.white, size: 20),
          ),
          const SizedBox(height: 8),
          Text(
            title,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }

  Widget _buildCheckPoint({required String title}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Row(
        children: [
          const Icon(Icons.check_circle_outline, color: KalyaThiruTheme.antiqueGold, size: 16),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              title,
              style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomNavItem(int index, IconData icon, String label, {bool isUpgrade = false}) {
    final bool isActive = _navIndex == index;
    final Color color = isActive ? KalyaThiruTheme.primaryMaroon : KalyaThiruTheme.mutedGray;

    return Expanded(
      child: InkWell(
        onTap: () {
          setState(() {
            _navIndex = index;
          });
          if (isUpgrade) {
            context.push('/upgrade');
          } else if (index == 1) {
            // Matches Page
            context.push('/matches', extra: {'isPaidMember': _isPaidMember});
          } else if (index == 2) {
            // Interests Page
            context.push('/interests', extra: {'isPaidMember': _isPaidMember});
          } else if (index == 3) {
            // AI Match / AI Search
            context.push('/ai_search', extra: {'isPaidMember': _isPaidMember});
          } else if (index == 4) {
            // Messages / Communication Center
            context.push('/communication', extra: {'isPaidMember': _isPaidMember});
          } else if (index != 0) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('$label Feature coming soon!'),
                duration: const Duration(seconds: 1),
              ),
            );
          }
        },
        child: Stack(
          alignment: Alignment.center,
          clipBehavior: Clip.none,
          children: [
            Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(icon, color: color, size: 20),
                const SizedBox(height: 2),
                Text(
                  label,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: color,
                    fontSize: 9,
                    fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
                  ),
                ),
              ],
            ),
            if (isUpgrade)
              Positioned(
                top: -12,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 1),
                  decoration: BoxDecoration(
                    color: const Color(0xFFBA1A1A),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: const Text(
                    '61% OFF',
                    style: TextStyle(color: Colors.white, fontSize: 6, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
          ],
         ),
       ),
     );
   }

  Future<void> _triggerDailyPopup() async {
    final prefs = await SharedPreferences.getInstance();
    final today = DateTime.now().toIso8601String().substring(0, 10);
    _showDailyPopupSheet(prefs, today);
  }

  Widget _buildViewAllCard(
    BuildContext context, {
    required double width,
    required String lang,
    required VoidCallback onTap,
  }) {
    return Container(
      width: width,
      decoration: BoxDecoration(
        color: const Color(0xFFFBF8F6),
        border: Border.all(color: KalyaThiruTheme.outlineVariant),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(8),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: KalyaThiruTheme.primaryMaroon.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.arrow_forward,
                  color: KalyaThiruTheme.primaryMaroon,
                  size: 24,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                lang == 'en' ? 'View All' : 'அனைத்தும் காண்க',
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: KalyaThiruTheme.primaryMaroon,
                  fontWeight: FontWeight.bold,
                  fontSize: 13,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
