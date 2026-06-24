import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../core/theme/theme.dart';
import '../../onboarding/cubit/onboarding_cubit.dart';
import '../models/profile_model.dart';

class ProfileDetailScreen extends StatefulWidget {
  final ProfileModel profile;

  const ProfileDetailScreen({
    Key? key,
    required this.profile,
  }) : super(key: key);

  @override
  State<ProfileDetailScreen> createState() => _ProfileDetailScreenState();
}

class _ProfileDetailScreenState extends State<ProfileDetailScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  bool _isPaidMember = false;
  bool _isInterestSent = false;
  bool _isShortlisted = false;

  // Localized string helpers based on langCode
  String _t(String en, String ta, String lang) => lang == 'ta' ? ta : en;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 7, vsync: this);
    _loadPremiumState();
  }

  Future<void> _loadPremiumState() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _isPaidMember = prefs.getBool('is_paid_member') ?? false;
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  // Parse height text to double for numerical comparison
  double _parseHeight(String? heightStr) {
    if (heightStr == null) return 5.0;
    try {
      final clean = heightStr.replaceAll(RegExp(r'[^0-9.]'), '');
      if (clean.contains('.')) {
        return double.parse(clean);
      }
      // Check for feet/inches format, e.g. 5'4"
      if (heightStr.contains("'")) {
        final parts = heightStr.split("'");
        final ft = double.parse(parts[0].trim());
        final inchStr = parts[1].replaceAll('"', '').trim();
        final inch = inchStr.isNotEmpty ? double.parse(inchStr) : 0.0;
        return ft + (inch / 12.0);
      }
    } catch (_) {}
    return 5.5;
  }

  // Parse annual income to numeric rank/value
  double _parseIncome(String? incomeStr) {
    if (incomeStr == null) return 0.0;
    final lower = incomeStr.toLowerCase();
    if (lower.contains('under 3 lakhs') || lower.contains('3 லட்சத்திற்கும் கீழ்')) return 2.0;
    if (lower.contains('3 - 5 lakhs') || lower.contains('3-5')) return 4.0;
    if (lower.contains('5 - 7 lakhs') || lower.contains('5-7')) return 6.0;
    if (lower.contains('7 - 10 lakhs') || lower.contains('7-10') || lower.contains('9-10')) return 9.0;
    if (lower.contains('10 - 15 lakhs') || lower.contains('10-15')) return 12.0;
    if (lower.contains('15L+') || lower.contains('15 லட்சத்திற்கு மேல்')) return 18.0;
    return 5.0;
  }

  // Check compatibility criteria helper
  bool _checkMatch({
    required String criterion,
    required dynamic expected,
    required dynamic actual,
  }) {
    if (expected == null || expected == '' || (expected is List && expected.isEmpty)) {
      return true; // No preference specified is an automatic match
    }

    final String actualStr = actual?.toString().toLowerCase().trim() ?? '';

    switch (criterion) {
      case 'religion':
        return actualStr.contains(expected.toString().toLowerCase().trim());
      case 'caste':
        if (expected is List) {
          if (expected.isEmpty) return true;
          return expected.any((e) => actualStr.contains(e.toString().toLowerCase().trim()));
        }
        return actualStr.contains(expected.toString().toLowerCase().trim());
      case 'marital_status':
        if (expected is List) {
          if (expected.isEmpty) return true;
          return expected.any((e) => actualStr.contains(e.toString().toLowerCase().trim()));
        }
        return actualStr.contains(expected.toString().toLowerCase().trim());
      case 'star':
        if (expected is List) {
          if (expected.isEmpty) return true;
          return expected.any((e) => actualStr.contains(e.toString().toLowerCase().trim()));
        }
        return actualStr.contains(expected.toString().toLowerCase().trim());
      case 'qualification':
        if (expected is List) {
          if (expected.isEmpty) return true;
          return expected.any((e) => actualStr.contains(e.toString().toLowerCase().trim()));
        }
        return actualStr.contains(expected.toString().toLowerCase().trim());
      case 'occupation':
        if (expected is List) {
          if (expected.isEmpty) return true;
          return expected.any((e) => actualStr.contains(e.toString().toLowerCase().trim()));
        }
        return actualStr.contains(expected.toString().toLowerCase().trim());
      case 'eating_habits':
        if (expected is List) {
          if (expected.isEmpty) return true;
          return expected.any((e) => actualStr.contains(e.toString().toLowerCase().trim()));
        }
        return actualStr.contains(expected.toString().toLowerCase().trim());
      case 'age':
        try {
          final int actualAge = int.parse(actual.toString());
          if (expected is Map<String, int>) {
            final min = expected['min'] ?? 20;
            final max = expected['max'] ?? 40;
            return actualAge >= min && actualAge <= max;
          }
        } catch (_) {}
        return true;
      case 'height':
        try {
          final double actualHt = _parseHeight(actual.toString());
          if (expected is Map<String, double>) {
            final min = expected['min'] ?? 4.5;
            final max = expected['max'] ?? 7.0;
            return actualHt >= min && actualHt <= max;
          }
        } catch (_) {}
        return true;
      case 'income':
        try {
          final double actualIncVal = _parseIncome(actual.toString());
          final double expectedMinVal = _parseIncome(expected.toString());
          return actualIncVal >= expectedMinVal;
        } catch (_) {}
        return true;
      default:
        return actualStr.contains(expected.toString().toLowerCase().trim());
    }
  }

  void _showSubscriptionSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return Container(
          decoration: const BoxDecoration(
            color: KalyaThiruTheme.softIvory,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20),
              topRight: Radius.circular(20),
            ),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 48,
                height: 5,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              const SizedBox(height: 24),
              ShaderMask(
                shaderCallback: (bounds) => KalyaThiruTheme.auraGold.createShader(bounds),
                child: const Icon(Icons.stars, size: 64, color: Colors.white),
              ),
              const SizedBox(height: 16),
              Text(
                'UPGRADE TO PREMIUM',
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      color: KalyaThiruTheme.primaryDark,
                      fontWeight: FontWeight.bold,
                    ),
              ),
              const SizedBox(height: 8),
              Text(
                'Unlock unlimited contact numbers, direct WhatsApp chats, horoscope matches, and premium profile highlights.',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: KalyaThiruTheme.mutedGray),
              ),
              const SizedBox(height: 24),
              // Premium benefits list
              _buildBenefitRow(Icons.check_circle, 'View verified Phone & WhatsApp numbers directly'),
              _buildBenefitRow(Icons.check_circle, 'Send unlimited personalized messages & interests'),
              _buildBenefitRow(Icons.check_circle, 'See mutual horoscopes and star compatibility scores'),
              const SizedBox(height: 32),
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: () async {
                    final prefs = await SharedPreferences.getInstance();
                    await prefs.setBool('is_paid_member', true);
                    setState(() {
                      _isPaidMember = true;
                    });
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Thank you! Premium activated. (பிரிமியம் சேவை செயல்படுத்தப்பட்டது!)'),
                        backgroundColor: Colors.green,
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: KalyaThiruTheme.primaryMaroon,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  ),
                  child: const Text('ACTIVATE NOW - ₹1,499 / 3 Months'),
                ),
              ),
              const SizedBox(height: 12),
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Maybe Later', style: TextStyle(color: KalyaThiruTheme.mutedGray)),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildBenefitRow(IconData icon, String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6.0),
      child: Row(
        children: [
          Icon(icon, size: 20, color: KalyaThiruTheme.antiqueGold),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: KalyaThiruTheme.darkCharcoal),
            ),
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final state = context.watch<OnboardingCubit>().state;
    final String lang = state.langCode;
    final p = widget.profile;

    return Scaffold(
      backgroundColor: KalyaThiruTheme.softIvory,
      body: Stack(
        children: [
          Positioned.fill(
            child: SingleChildScrollView(
              padding: const EdgeInsets.only(bottom: 100),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // 1. Profile Hero Section
                  Stack(
                    children: [
                      Hero(
                        tag: 'profile_pic_${p.id}',
                        child: Container(
                          height: 380,
                          width: double.infinity,
                          decoration: BoxDecoration(
                            image: DecorationImage(
                              image: NetworkImage(p.photoUrl ?? 'https://images.unsplash.com/photo-1544005313-94ddf0286df2?w=600'),
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      ),
                      // Gradient overlay
                      Container(
                        height: 380,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              Colors.black.withOpacity(0.5),
                              Colors.transparent,
                              Colors.black.withOpacity(0.6),
                            ],
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                          ),
                        ),
                      ),
                      // Top actions bar
                      SafeArea(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              CircleAvatar(
                                backgroundColor: Colors.black38,
                                child: IconButton(
                                  icon: const Icon(Icons.arrow_back, color: Colors.white),
                                  onPressed: () => Navigator.pop(context),
                                ),
                              ),
                              Row(
                                children: [
                                  CircleAvatar(
                                    backgroundColor: Colors.black38,
                                    child: IconButton(
                                      icon: Icon(
                                        _isShortlisted ? Icons.bookmark : Icons.bookmark_border,
                                        color: Colors.white,
                                      ),
                                      onPressed: () {
                                        setState(() {
                                          _isShortlisted = !_isShortlisted;
                                        });
                                        ScaffoldMessenger.of(context).showSnackBar(
                                          SnackBar(
                                            content: Text(_isShortlisted
                                                ? _t('Profile Shortlisted', 'விவரம் சேமிக்கப்பட்டது', lang)
                                                : _t('Profile removed from shortlist', 'விவரம் சேமிப்பிலிருந்து நீக்கப்பட்டது', lang)),
                                          ),
                                        );
                                      },
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  CircleAvatar(
                                    backgroundColor: Colors.black38,
                                    child: IconButton(
                                      icon: const Icon(Icons.share, color: Colors.white),
                                      onPressed: () {
                                        ScaffoldMessenger.of(context).showSnackBar(
                                          SnackBar(content: Text(_t('Sharing profile link...', 'சுயவிவர இணைப்பு பகிரப்படுகிறது...', lang))),
                                        );
                                      },
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                      // Bottom details on image
                      Positioned(
                        bottom: 16,
                        left: 16,
                        right: 16,
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  if (p.isVerified)
                                    Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                      margin: const EdgeInsets.only(bottom: 8),
                                      decoration: BoxDecoration(
                                        color: KalyaThiruTheme.antiqueGold,
                                        borderRadius: BorderRadius.circular(4),
                                      ),
                                      child: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          const Icon(Icons.verified, size: 14, color: KalyaThiruTheme.primaryDark),
                                          const SizedBox(width: 4),
                                          Text(
                                            _t('VERIFIED', 'சரிபார்க்கப்பட்டது', lang),
                                            style: const TextStyle(
                                              fontFamily: 'Source Serif 4',
                                              fontSize: 11,
                                              fontWeight: FontWeight.bold,
                                              color: KalyaThiruTheme.primaryDark,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  Text(
                                    p.name,
                                    style: const TextStyle(
                                      fontSize: 28,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                      shadows: [Shadow(color: Colors.black54, blurRadius: 4, offset: Offset(0, 2))],
                                    ),
                                  ),
                                  Text(
                                    '${p.id} • ${p.lastSeen ?? _t('Online', 'உடனடி இணைப்பு', lang)}',
                                    style: const TextStyle(
                                      color: Colors.white70,
                                      fontSize: 13,
                                      shadows: [Shadow(color: Colors.black54, blurRadius: 4, offset: Offset(0, 1))],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),

                  // Quick details strip
                  Container(
                    color: Colors.white,
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Expanded(child: _buildQuickInfo(Icons.person_outline, '${p.age} Yrs, ${p.height}')),
                            Expanded(child: _buildQuickInfo(Icons.favorite_border, _t(p.maritalStatus, p.maritalStatus, lang))),
                          ],
                        ),
                        const SizedBox(height: 12),
                        Row(
                          children: [
                            Expanded(child: _buildQuickInfo(Icons.business_center_outlined, p.occupation)),
                            Expanded(child: _buildQuickInfo(Icons.location_on_outlined, '${p.city}, ${p.state}')),
                          ],
                        ),
                        const SizedBox(height: 12),
                        Row(
                          children: [
                            Expanded(child: _buildQuickInfo(Icons.menu_book_outlined, '${p.religion} - ${p.caste}')),
                            Expanded(child: _buildQuickInfo(Icons.translate_outlined, _t(p.motherTongue, p.motherTongue, lang))),
                          ],
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 12),

                  // 2. Horizontally scrollable Tab Bar
                  Container(
                    color: Colors.white,
                    child: TabBar(
                      controller: _tabController,
                      isScrollable: true,
                      labelColor: KalyaThiruTheme.primaryMaroon,
                      unselectedLabelColor: KalyaThiruTheme.mutedGray,
                      indicatorColor: KalyaThiruTheme.primaryMaroon,
                      indicatorWeight: 3,
                      tabs: [
                        _buildTab(_t('PERSONAL', 'தனிப்பட்டவை', lang)),
                        _buildTab(_t('FAMILY', 'குடும்பம்', lang)),
                        _buildTab(_t('PROFESSIONAL', 'தொழில்முறை', lang)),
                        _buildTab(_t('CONTACT', 'தொடர்பு', lang)),
                        _buildTab(_t('PREFERENCES', 'விருப்பங்கள்', lang)),
                        _buildTab(_t('AM I THEIR MATCH?', 'நான் பொருந்துவேனா?', lang)),
                        _buildTab(_t('ARE THEY MY MATCH?', 'அவர்கள் பொருந்துவரா?', lang)),
                      ],
                    ),
                  ),

                  // Tab Contents Container
                  AnimatedBuilder(
                    animation: _tabController,
                    builder: (context, child) {
                      return AnimatedSwitcher(
                        duration: const Duration(milliseconds: 250),
                        child: Container(
                          key: ValueKey<int>(_tabController.index),
                          color: Colors.transparent,
                          child: _buildActiveTabContent(_tabController.index, state, lang),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),

          // 3. Sticky Bottom action bar
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 10,
                    offset: const Offset(0, -4),
                  )
                ],
              ),
              child: SafeArea(
                top: false,
                child: Row(
                  children: [
                    Expanded(
                      flex: 2,
                      child: OutlinedButton(
                        onPressed: () {
                          // Toggle interest state
                          setState(() {
                            _isInterestSent = !_isInterestSent;
                          });
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(_isInterestSent
                                  ? _t('Interest sent successfully!', 'ஆர்வம் வெற்றிகரமாக அனுப்பப்பட்டது!', lang)
                                  : _t('Interest cancelled.', 'ஆர்வம் ரத்து செய்யப்பட்டது.', lang)),
                              backgroundColor: KalyaThiruTheme.primaryMaroon,
                            ),
                          );
                        },
                        style: OutlinedButton.styleFrom(
                          side: BorderSide(
                            color: _isInterestSent ? Colors.green : KalyaThiruTheme.primaryMaroon,
                            width: 1.5,
                          ),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
                          padding: const EdgeInsets.symmetric(vertical: 14),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              _isInterestSent ? Icons.check_circle : Icons.favorite_border,
                              color: _isInterestSent ? Colors.green : KalyaThiruTheme.primaryMaroon,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              _isInterestSent
                                  ? _t('INTEREST SENT', 'அனுப்பப்பட்டது', lang)
                                  : _t('SEND INTEREST', 'ஆர்வம் காட்டு', lang),
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: _isInterestSent ? Colors.green : KalyaThiruTheme.primaryMaroon,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      flex: 1,
                      child: ElevatedButton(
                        onPressed: () {
                          if (!_isPaidMember) {
                            _showSubscriptionSheet();
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text(_t('Opening Chat...', 'அரட்டை திறக்கப்படுகிறது...', lang))),
                            );
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: KalyaThiruTheme.primaryMaroon,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
                          padding: const EdgeInsets.symmetric(vertical: 14),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(Icons.chat_bubble_outline),
                            const SizedBox(width: 8),
                            Text(
                              _t('CHAT', 'அரட்டை', lang),
                              style: const TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget _buildTab(String title) {
    return Tab(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 4.0),
        child: Text(
          title,
          style: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.bold,
            letterSpacing: 0.8,
          ),
        ),
      ),
    );
  }

  Widget _buildQuickInfo(IconData icon, String text) {
    return Row(
      children: [
        Icon(icon, size: 18, color: KalyaThiruTheme.mutedGray),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            text,
            style: const TextStyle(
              fontSize: 14,
              color: KalyaThiruTheme.darkCharcoal,
              fontWeight: FontWeight.w600,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }

  // Router for rendering tab body content dynamically
  Widget _buildActiveTabContent(int index, OnboardingState userState, String lang) {
    final p = widget.profile;
    switch (index) {
      case 0:
        return _buildPersonalTab(p, lang);
      case 1:
        return _buildFamilyTab(p, lang);
      case 2:
        return _buildProfessionalTab(p, lang);
      case 3:
        return _buildContactTab(p, lang);
      case 4:
        return _buildPreferencesTab(p, lang);
      case 5:
        return _buildAmITheirMatchTab(p, userState, lang);
      case 6:
        return _buildAreTheyMyMatchTab(p, userState, lang);
      default:
        return const SizedBox();
    }
  }

  // TAB CONTENT: PERSONAL
  Widget _buildPersonalTab(ProfileModel p, String lang) {
    return Container(
      color: Colors.transparent,
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // About Myself
          if (p.bioSelf != null) ...[
            Text(
              _t('About Myself', 'என்னைப் பற்றி', lang),
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: KalyaThiruTheme.primaryMaroon, fontFamily: 'Source Serif 4'),
            ),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(6),
                border: Border.all(color: KalyaThiruTheme.outlineVariant),
              ),
              child: Text(
                p.bioSelf!,
                style: const TextStyle(fontSize: 14, height: 1.5, color: KalyaThiruTheme.darkCharcoal),
              ),
            ),
            const SizedBox(height: 20),
          ],

          Text(
            _t('Personal Details', 'தனிப்பட்ட விவரங்கள்', lang),
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: KalyaThiruTheme.primaryMaroon, fontFamily: 'Source Serif 4'),
          ),
          const SizedBox(height: 12),
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(6),
              border: Border.all(color: KalyaThiruTheme.outlineVariant),
            ),
            child: Column(
              children: [
                _buildInfoDetailRow(_t('Age / DOB', 'வயது / பிறந்த தேதி', lang), '${p.age} Yrs • ${p.dob ?? "N/A"}'),
                _buildInfoDetailRow(_t('Height / Weight', 'உயரம் / எடை', lang), '${p.height} • ${p.weight ?? "N/A"}'),
                _buildInfoDetailRow(_t('Marital Status', 'திருமண நிலை', lang), p.maritalStatus),
                _buildInfoDetailRow(_t('Mother Tongue', 'தாய்மொழி', lang), p.motherTongue),
                _buildInfoDetailRow(_t('Religion / Caste', 'மதம் / சாதி', lang), '${p.religion} / ${p.caste}'),
                _buildInfoDetailRow(_t('Subcaste', 'உட்பிரிவு', lang), p.subcaste ?? 'N/A'),
                _buildInfoDetailRow(_t('Gothram', 'கோத்திரம்', lang), p.gothram ?? 'N/A'),
                _buildInfoDetailRow(_t('Raasi / Nakshatra', 'ராசி / நட்சத்திரம்', lang), '${p.raasi ?? "N/A"} / ${p.nakshatra ?? "N/A"}'),
                _buildInfoDetailRow(_t('Dosham', 'தோஷம்', lang), p.dosham ?? 'None'),
                _buildInfoDetailRow(_t('Diet Preference', 'உணவு பழக்கம்', lang), p.eatingHabits ?? 'N/A'),
              ],
            ),
          ),

          if (p.traits.isNotEmpty) ...[
            const SizedBox(height: 20),
            Text(
              _t('Personality Traits', 'குணநலன்கள்', lang),
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: KalyaThiruTheme.primaryMaroon, fontFamily: 'Source Serif 4'),
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: p.traits.map((trait) {
                return Chip(
                  label: Text(
                    trait,
                    style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: KalyaThiruTheme.primaryMaroon),
                  ),
                  backgroundColor: const Color(0xFFFDE8E9),
                  side: BorderSide.none,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                );
              }).toList(),
            ),
          ]
        ],
      ),
    );
  }

  // TAB CONTENT: FAMILY
  Widget _buildFamilyTab(ProfileModel p, String lang) {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (p.bioFamily != null) ...[
            Text(
              _t('About My Family', 'குடும்பத்தைப் பற்றி', lang),
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: KalyaThiruTheme.primaryMaroon, fontFamily: 'Source Serif 4'),
            ),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(6),
                border: Border.all(color: KalyaThiruTheme.outlineVariant),
              ),
              child: Text(
                p.bioFamily!,
                style: const TextStyle(fontSize: 14, height: 1.5, color: KalyaThiruTheme.darkCharcoal),
              ),
            ),
            const SizedBox(height: 20),
          ],
          Text(
            _t('Family Details', 'குடும்ப பின்னணி', lang),
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: KalyaThiruTheme.primaryMaroon, fontFamily: 'Source Serif 4'),
          ),
          const SizedBox(height: 12),
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(6),
              border: Border.all(color: KalyaThiruTheme.outlineVariant),
            ),
            child: Column(
              children: [
                _buildInfoDetailRow(_t('Family Values', 'குடும்ப வழக்கம்', lang), p.familyValues ?? 'Traditional'),
                _buildInfoDetailRow(_t('Family Status', 'குடும்ப நிலை', lang), p.familyStatus ?? 'Upper Middle Class'),
                _buildInfoDetailRow(_t('Family Wealth', 'குடும்ப சொத்து விவரம்', lang), p.familyWealth ?? 'N/A'),
                _buildInfoDetailRow(_t('Parents Details', 'பெற்றோர் விவரம்', lang), p.parentsInfo ?? 'N/A'),
                _buildInfoDetailRow(_t('Brothers count', 'சகோதரர்கள் எண்ணிக்கை', lang), p.brothers ?? 'None'),
                _buildInfoDetailRow(_t('Sisters count', 'சகோதரிகள் எண்ணிக்கை', lang), p.sisters ?? 'None'),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // TAB CONTENT: PROFESSIONAL
  Widget _buildProfessionalTab(ProfileModel p, String lang) {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            _t('Education & Career', 'கல்வி மற்றும் தொழில்', lang),
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: KalyaThiruTheme.primaryMaroon, fontFamily: 'Source Serif 4'),
          ),
          const SizedBox(height: 12),
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(6),
              border: Border.all(color: KalyaThiruTheme.outlineVariant),
            ),
            child: Column(
              children: [
                _buildInfoDetailRow(_t('Education Degree', 'கல்வி தகுதி', lang), p.education ?? p.qualification),
                _buildInfoDetailRow(_t('Employment Sector', 'பணிபுரியும் துறை', lang), p.employmentType ?? 'Private Sector'),
                _buildInfoDetailRow(_t('Occupation / Role', 'பணி / பதவி', lang), p.occupation),
                _buildInfoDetailRow(_t('Annual Income', 'ஆண்டு வருமானம்', lang), p.annualIncome),
                _buildInfoDetailRow(_t('Work Country', 'வேலை நாடு', lang), p.country),
                _buildInfoDetailRow(_t('Work State / City', 'வேலை மாநிலம் / நகரம்', lang), '${p.state} / ${p.city}'),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // TAB CONTENT: CONTACT
  Widget _buildContactTab(ProfileModel p, String lang) {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            _t('Contact Information', 'தொடர்பு விவரங்கள்', lang),
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: KalyaThiruTheme.primaryMaroon, fontFamily: 'Source Serif 4'),
          ),
          const SizedBox(height: 12),
          Stack(
            children: [
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(6),
                  border: Border.all(color: KalyaThiruTheme.outlineVariant),
                ),
                child: Column(
                  children: [
                    _buildInfoDetailRow(_t('Mobile Phone', 'மொபைல் எண்', lang), p.mobileNumber ?? '+91 98765 43210'),
                    _buildInfoDetailRow(_t('WhatsApp Number', 'வாட்ஸ்அப் எண்', lang), p.whatsappNumber ?? '+91 98765 43210'),
                    _buildInfoDetailRow(_t('Address / Locality', 'முகவரி / இருப்பிடம்', lang), '${p.city}, ${p.state}, ${p.country}'),
                  ],
                ),
              ),
              if (!_isPaidMember)
                Positioned.fill(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(6),
                    child: BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 5.0, sigmaY: 5.0),
                      child: Container(
                        color: Colors.white.withOpacity(0.4),
                        alignment: Alignment.center,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(Icons.lock, size: 28, color: KalyaThiruTheme.primaryMaroon),
                            const SizedBox(height: 8),
                            Text(
                              _t('Contact locked', 'தொடர்பு விவரங்கள் பூட்டப்பட்டுள்ளது', lang),
                              style: const TextStyle(fontWeight: FontWeight.bold, color: KalyaThiruTheme.darkCharcoal, fontSize: 15),
                            ),
                            const SizedBox(height: 8),
                            ElevatedButton(
                              onPressed: _showSubscriptionSheet,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: KalyaThiruTheme.primaryMaroon,
                                foregroundColor: Colors.white,
                                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
                              ),
                              child: Text(_t('Upgrade to View', 'பிரிமியம் பெறுக', lang)),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }

  // TAB CONTENT: PREFERENCES (THEIR PARTNER EXPECTATIONS)
  Widget _buildPreferencesTab(ProfileModel p, String lang) {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            _t('Their Partner Preferences', 'அவர்களின் வாழ்க்கைத்துணை விருப்பம்', lang),
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: KalyaThiruTheme.primaryMaroon, fontFamily: 'Source Serif 4'),
          ),
          const SizedBox(height: 12),
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(6),
              border: Border.all(color: KalyaThiruTheme.outlineVariant),
            ),
            child: Column(
              children: [
                _buildInfoDetailRow(_t('Partner Age Range', 'வயது வரம்பு', lang), '${p.prefMinAge} to ${p.prefMaxAge} Yrs'),
                _buildInfoDetailRow(_t('Partner Height Range', 'உயரம் வரம்பு', lang), '${p.prefMinHeight} to ${p.prefMaxHeight}'),
                _buildInfoDetailRow(_t('Partner Religion', 'மதம்', lang), p.prefReligion ?? 'Any'),
                _buildInfoDetailRow(_t('Partner Caste', 'சாதி', lang), p.prefCaste ?? 'Any'),
                _buildInfoDetailRow(_t('Partner Subcaste', 'உட்பிரிவு விருப்பம்', lang), p.prefSubcaste ?? 'Any'),
                _buildInfoDetailRow(_t('Partner Education', 'கல்வி விருப்பம்', lang), p.prefEducation ?? 'Any'),
                _buildInfoDetailRow(_t('Employment Type', 'வேலை விருப்பம்', lang), p.prefEmployment ?? 'Any'),
                _buildInfoDetailRow(_t('Min Annual Income', 'குறைந்தபட்ச வருமானம்', lang), p.prefMinIncome ?? 'Any'),
                _buildInfoDetailRow(_t('Work Country', 'நாடு', lang), p.prefCountry ?? 'India'),
                _buildInfoDetailRow(_t('Dosham Preference', 'தோஷம் விருப்பம்', lang), p.prefDosham ?? 'Any'),
                _buildInfoDetailRow(_t('Star Preference', 'நட்சத்திரம் விருப்பம்', lang), p.prefStar ?? 'Any'),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // TAB CONTENT: AM I THEIR MATCH? (USER'S FEATURES VS TARGET'S PREFERENCES)
  Widget _buildAmITheirMatchTab(ProfileModel p, OnboardingState userState, String lang) {
    // 1. Compile comparison points (how user state meets this profile's expectations)
    final userAge = userState.dob != null ? (DateTime.now().year - DateTime.parse(userState.dob!).year) : 25;
    final userHeightStr = userState.height ?? "5'6\"";
    final userReligion = userState.religion ?? 'Hindu';
    final userCaste = userState.caste ?? 'Any';
    final userEducation = userState.qualification ?? 'B.Tech';
    final userEmployment = userState.employmentType ?? 'Private';
    final userIncome = userState.annualIncome ?? 'Under ₹3 Lakhs';
    final userCountry = userState.country ?? 'India';
    final userDosham = userState.dosham ?? 'no';

    final List<Map<String, dynamic>> comparisonPoints = [
      {
        'label': _t('Age Preference', 'வயது விருப்பம்', lang),
        'expected': '${p.prefMinAge} - ${p.prefMaxAge} Yrs',
        'actual': '$userAge Yrs',
        'isMatch': _checkMatch(
          criterion: 'age',
          expected: {'min': p.prefMinAge, 'max': p.prefMaxAge},
          actual: userAge,
        ),
      },
      {
        'label': _t('Height Preference', 'உயரம் விருப்பம்', lang),
        'expected': '${p.prefMinHeight} - ${p.prefMaxHeight}',
        'actual': userHeightStr,
        'isMatch': _checkMatch(
          criterion: 'height',
          expected: {'min': _parseHeight(p.prefMinHeight), 'max': _parseHeight(p.prefMaxHeight)},
          actual: userHeightStr,
        ),
      },
      {
        'label': _t('Religion Preference', 'மதம் விருப்பம்', lang),
        'expected': p.prefReligion ?? 'Any',
        'actual': userReligion,
        'isMatch': _checkMatch(criterion: 'religion', expected: p.prefReligion, actual: userReligion),
      },
      {
        'label': _t('Caste Preference', 'சாதி விருப்பம்', lang),
        'expected': p.prefCaste ?? 'Any',
        'actual': userCaste,
        'isMatch': p.prefCasteNoBar ? true : _checkMatch(criterion: 'caste', expected: p.prefCaste, actual: userCaste),
      },
      {
        'label': _t('Education Preference', 'கல்வி விருப்பம்', lang),
        'expected': p.prefEducation ?? 'Any',
        'actual': userEducation,
        'isMatch': _checkMatch(criterion: 'qualification', expected: p.prefEducation, actual: userEducation),
      },
      {
        'label': _t('Employment Sector', 'பணி விருப்பம்', lang),
        'expected': p.prefEmployment ?? 'Any',
        'actual': userEmployment,
        'isMatch': _checkMatch(criterion: 'occupation', expected: p.prefEmployment, actual: userEmployment),
      },
      {
        'label': _t('Income Preference', 'வருமானம் விருப்பம்', lang),
        'expected': p.prefMinIncome ?? 'Any',
        'actual': userIncome,
        'isMatch': _checkMatch(criterion: 'income', expected: p.prefMinIncome, actual: userIncome),
      },
      {
        'label': _t('Work Country', 'பணிபுரியும் நாடு', lang),
        'expected': p.prefCountry ?? 'Any',
        'actual': userCountry,
        'isMatch': _checkMatch(criterion: 'country', expected: p.prefCountry, actual: userCountry),
      },
      {
        'label': _t('Dosham Preference', 'தோஷம் விருப்பம்', lang),
        'expected': p.prefDosham ?? 'Any',
        'actual': userDosham,
        'isMatch': _checkMatch(criterion: 'dosham', expected: p.prefDosham, actual: userDosham),
      },
    ];

    final matchedCount = comparisonPoints.where((pt) => pt['isMatch'] == true).length;
    final totalCount = comparisonPoints.length;

    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Score summary card
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: KalyaThiruTheme.primaryDark,
              borderRadius: BorderRadius.circular(8),
              boxShadow: [
                BoxShadow(
                  color: KalyaThiruTheme.primaryDark.withOpacity(0.2),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                )
              ],
            ),
            child: Column(
              children: [
                Text(
                  _t('YOUR FIT WITH THEM', 'அவர்களின் விருப்பத்துடன் உங்கள் பொருத்தம்', lang),
                  style: const TextStyle(color: Colors.white70, fontSize: 12, fontWeight: FontWeight.bold, letterSpacing: 1.0),
                ),
                const SizedBox(height: 12),
                Text(
                  '$matchedCount / $totalCount',
                  style: const TextStyle(color: KalyaThiruTheme.antiqueGold, fontSize: 44, fontWeight: FontWeight.bold, fontFamily: 'Source Serif 4'),
                ),
                const SizedBox(height: 8),
                Text(
                  _t(
                    'You satisfy $matchedCount of their $totalCount partner preference criteria.',
                    'அவர்களின் $totalCount எதிர்பார்ப்புகளில் $matchedCount தகுதிகள் உங்களுக்குப் பொருந்துகிறது.',
                    lang,
                  ),
                  textAlign: TextAlign.center,
                  style: const TextStyle(color: Colors.white, fontSize: 13, height: 1.4),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          Text(
            _t('Comparison Details', 'ஒப்பீட்டு விவரங்கள்', lang),
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: KalyaThiruTheme.primaryMaroon, fontFamily: 'Source Serif 4'),
          ),
          const SizedBox(height: 12),
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(6),
              border: Border.all(color: KalyaThiruTheme.outlineVariant),
            ),
            child: Column(
              children: comparisonPoints.map((pt) => _buildMatchIndicatorRow(pt)).toList(),
            ),
          ),
        ],
      ),
    );
  }

  // TAB CONTENT: ARE THEY MY MATCH? (TARGET'S FEATURES VS USER'S PREFERENCES)
  Widget _buildAreTheyMyMatchTab(ProfileModel p, OnboardingState userState, String lang) {
    // 1. Get user preferences from OnboardingState
    final prefMinAge = userState.preferredMinAge;
    final prefMaxAge = userState.preferredMaxAge;
    final prefMinHeight = userState.preferredMinHeight;
    final prefMaxHeight = userState.preferredMaxHeight;
    final prefReligion = userState.preferredReligion ?? 'Any';
    final prefCastes = userState.preferredCastes;
    final prefQualifications = userState.preferredQualifications;
    final prefOccupations = userState.preferredOccupations;
    final prefMinIncome = userState.preferredMinIncome ?? 'Any';
    final prefEatingHabits = userState.preferredEatingHabits;
    final prefDosham = userState.preferredDosham ?? 'Any';

    // Target profile info
    final targetAge = p.age;
    final targetHeightStr = p.height;
    final targetReligion = p.religion;
    final targetCaste = p.caste;
    final targetEducation = p.education ?? p.qualification;
    final targetOccupation = p.occupation;
    final targetIncome = p.annualIncome;
    final targetCountry = p.country;
    final targetEatingHabits = p.eatingHabits ?? 'Non-vegetarian';
    final targetDosham = p.dosham ?? 'None';

    final List<Map<String, dynamic>> comparisonPoints = [
      {
        'label': _t('Age Expectation', 'வயது எதிர்பார்ப்பு', lang),
        'expected': '$prefMinAge - $prefMaxAge Yrs',
        'actual': '$targetAge Yrs',
        'isMatch': _checkMatch(
          criterion: 'age',
          expected: {'min': prefMinAge, 'max': prefMaxAge},
          actual: targetAge,
        ),
      },
      {
        'label': _t('Height Expectation', 'உயரம் எதிர்பார்ப்பு', lang),
        'expected': "${prefMinHeight.toStringAsFixed(1)}' to ${prefMaxHeight.toStringAsFixed(1)}'",
        'actual': targetHeightStr,
        'isMatch': _checkMatch(
          criterion: 'height',
          expected: {'min': prefMinHeight, 'max': prefMaxHeight},
          actual: targetHeightStr,
        ),
      },
      {
        'label': _t('Religion Expectation', 'மதம் எதிர்பார்ப்பு', lang),
        'expected': prefReligion,
        'actual': targetReligion,
        'isMatch': _checkMatch(criterion: 'religion', expected: prefReligion, actual: targetReligion),
      },
      {
        'label': _t('Caste Expectation', 'சாதி எதிர்பார்ப்பு', lang),
        'expected': prefCastes.isEmpty ? 'Any' : prefCastes.join(', '),
        'actual': targetCaste,
        'isMatch': userState.preferredCasteNoBar ? true : _checkMatch(criterion: 'caste', expected: prefCastes, actual: targetCaste),
      },
      {
        'label': _t('Education Expectation', 'கல்வி எதிர்பார்ப்பு', lang),
        'expected': prefQualifications.isEmpty ? 'Any' : prefQualifications.join(', '),
        'actual': targetEducation,
        'isMatch': _checkMatch(criterion: 'qualification', expected: prefQualifications, actual: targetEducation),
      },
      {
        'label': _t('Occupation Expectation', 'வேலை எதிர்பார்ப்பு', lang),
        'expected': prefOccupations.isEmpty ? 'Any' : prefOccupations.join(', '),
        'actual': targetOccupation,
        'isMatch': _checkMatch(criterion: 'occupation', expected: prefOccupations, actual: targetOccupation),
      },
      {
        'label': _t('Min Income Expectation', 'வருமான எதிர்பார்ப்பு', lang),
        'expected': prefMinIncome,
        'actual': targetIncome,
        'isMatch': _checkMatch(criterion: 'income', expected: prefMinIncome, actual: targetIncome),
      },
      {
        'label': _t('Eating Habits', 'உணவு பழக்கம்', lang),
        'expected': prefEatingHabits.isEmpty ? 'Any' : prefEatingHabits.join(', '),
        'actual': targetEatingHabits,
        'isMatch': _checkMatch(criterion: 'eating_habits', expected: prefEatingHabits, actual: targetEatingHabits),
      },
      {
        'label': _t('Dosham Expectation', 'தோஷ எதிர்பார்ப்பு', lang),
        'expected': prefDosham,
        'actual': targetDosham,
        'isMatch': _checkMatch(criterion: 'dosham', expected: prefDosham, actual: targetDosham),
      },
    ];

    final matchedCount = comparisonPoints.where((pt) => pt['isMatch'] == true).length;
    final totalCount = comparisonPoints.length;

    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Score summary card
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: KalyaThiruTheme.primaryDark,
              borderRadius: BorderRadius.circular(8),
              boxShadow: [
                BoxShadow(
                  color: KalyaThiruTheme.primaryDark.withOpacity(0.2),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                )
              ],
            ),
            child: Column(
              children: [
                Text(
                  _t('THEIR FIT WITH YOU', 'உங்கள் விருப்பத்துடன் அவர்களின் பொருத்தம்', lang),
                  style: const TextStyle(color: Colors.white70, fontSize: 12, fontWeight: FontWeight.bold, letterSpacing: 1.0),
                ),
                const SizedBox(height: 12),
                Text(
                  '$matchedCount / $totalCount',
                  style: const TextStyle(color: KalyaThiruTheme.antiqueGold, fontSize: 44, fontWeight: FontWeight.bold, fontFamily: 'Source Serif 4'),
                ),
                const SizedBox(height: 8),
                Text(
                  _t(
                    'They satisfy $matchedCount of your $totalCount partner preference criteria.',
                    'உங்கள் $totalCount எதிர்பார்ப்புகளில் $matchedCount தகுதிகள் இவருக்குப் பொருந்துகிறது.',
                    lang,
                  ),
                  textAlign: TextAlign.center,
                  style: const TextStyle(color: Colors.white, fontSize: 13, height: 1.4),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          Text(
            _t('Comparison Details', 'ஒப்பீட்டு விவரங்கள்', lang),
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: KalyaThiruTheme.primaryMaroon, fontFamily: 'Source Serif 4'),
          ),
          const SizedBox(height: 12),
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(6),
              border: Border.all(color: KalyaThiruTheme.outlineVariant),
            ),
            child: Column(
              children: comparisonPoints.map((pt) => _buildMatchIndicatorRow(pt)).toList(),
            ),
          ),
        ],
      ),
    );
  }

  // Row builder for each criteria item with check or X
  Widget _buildMatchIndicatorRow(Map<String, dynamic> pt) {
    final bool isMatch = pt['isMatch'] == true;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: KalyaThiruTheme.outlineVariant)),
      ),
      child: Row(
        children: [
          Icon(
            isMatch ? Icons.check_circle : Icons.cancel,
            color: isMatch ? Colors.green : const Color(0xFFBA1A1A),
            size: 20,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  pt['label'],
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: KalyaThiruTheme.darkCharcoal,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  'Expected: ${pt['expected']} • Actual: ${pt['actual']}',
                  style: const TextStyle(fontSize: 12, color: KalyaThiruTheme.mutedGray),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoDetailRow(String label, String value) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: KalyaThiruTheme.outlineVariant)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 2,
            child: Text(
              label,
              style: const TextStyle(
                fontSize: 14,
                color: KalyaThiruTheme.mutedGray,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          Expanded(
            flex: 3,
            child: Text(
              value,
              style: const TextStyle(
                fontSize: 14,
                color: KalyaThiruTheme.darkCharcoal,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
