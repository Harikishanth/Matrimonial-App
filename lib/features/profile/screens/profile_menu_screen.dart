import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../core/theme/theme.dart';
import '../../onboarding/cubit/onboarding_cubit.dart';
import '../../../core/translation/option_translations.dart';

class ProfileMenuScreen extends StatefulWidget {
  const ProfileMenuScreen({super.key});

  @override
  State<ProfileMenuScreen> createState() => _ProfileMenuScreenState();
}

class _ProfileMenuScreenState extends State<ProfileMenuScreen> {
  bool _isPaidMember = false;
  bool _isVerified = false;

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
  }

  Future<void> _togglePaidState(bool val) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('is_paid_member', val);
    setState(() {
      _isPaidMember = val;
    });
  }

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
                style: GoogleFonts.sourceSerif4(
                  color: KalyaThiruTheme.primaryMaroon,
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                lang == 'en'
                    ? 'Unlock unlimited features and connect instantly with verification-first matches.'
                    : 'வரம்பற்ற வசதிகளைப் பெறவும் மற்றும் சரிபார்க்கப்பட்ட வரன்களுடன் உடனடியாக இணையவும்.',
                textAlign: TextAlign.center,
                style: GoogleFonts.nunitoSans(
                  color: KalyaThiruTheme.mutedGray,
                  fontSize: 14,
                ),
              ),
              const SizedBox(height: 24),
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
                            style: GoogleFonts.sourceSerif4(
                              color: KalyaThiruTheme.primaryMaroon,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
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
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<OnboardingCubit, OnboardingState>(
      builder: (context, state) {
        final lang = state.langCode;
        final name = state.firstName != null && state.firstName!.isNotEmpty
            ? translateOption('${state.firstName} ${state.lastName ?? ""}', lang)
            : translateOption('Ananth Raman', lang);
        final int completeness = _calculateCompleteness(state);

        return Scaffold(
          backgroundColor: KalyaThiruTheme.softIvory,
          appBar: AppBar(
            backgroundColor: KalyaThiruTheme.softIvory,
            elevation: 0,
            scrolledUnderElevation: 0,
            leading: IconButton(
              icon: const Icon(Icons.close, color: KalyaThiruTheme.primaryMaroon),
              onPressed: () => context.pop(),
            ),
            titleSpacing: 0,
            title: Text(
              'KalyaThiru',
              style: GoogleFonts.sourceSerif4(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: KalyaThiruTheme.primaryMaroon,
              ),
            ),
            actions: [
              IconButton(
                icon: const Icon(Icons.notifications_none_outlined, color: KalyaThiruTheme.darkCharcoal),
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('No new notifications')),
                  );
                },
              ),
              IconButton(
                icon: const Icon(Icons.headset_mic_outlined, color: KalyaThiruTheme.darkCharcoal),
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Support Center coming soon!')),
                  );
                },
              ),
              const SizedBox(width: 8),
            ],
            bottom: PreferredSize(
              preferredSize: const Size.fromHeight(1.0),
              child: Container(
                color: KalyaThiruTheme.outlineVariant,
                height: 1.0,
              ),
            ),
          ),
          body: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Profile header card
                Container(
                  color: Colors.white,
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Row(
                        children: [
                          Stack(
                            children: [
                              Container(
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  border: Border.all(color: KalyaThiruTheme.antiqueGold, width: 2),
                                ),
                                child: CircleAvatar(
                                  radius: 36,
                                  backgroundImage: NetworkImage(
                                    state.photoPath != null
                                        ? state.photoPath!
                                        : 'https://lh3.googleusercontent.com/aida-public/AB6AXuD6xNeJz919l4dAetbhf5NS4FPHU-v5fq7rmuM7zRN1i0XwG5zD_LJ4YSkUv1asNAcezAF7mpQ_gE419Rq0yCIjHddkGsa2V4DKFti9eiiBST0CIm_89DmXwqL1tUgyDd8beR2avnt9oHwA4f9iZd2xAPF9jUjZSWyOg6Sp6YWlrECmG6qBof3WR2YEnG-BDXZsm_wrqTxkByaiBvsNKJY159mtuNZU2IIsUG83fAcvalu2L-u_Opomj-xcdTa3Xk9CxtuybbCehN8',
                                  ),
                                ),
                              ),
                              Positioned(
                                bottom: 0,
                                right: 0,
                                child: Container(
                                  padding: const EdgeInsets.all(4),
                                  decoration: const BoxDecoration(
                                    color: KalyaThiruTheme.primaryMaroon,
                                    shape: BoxShape.circle,
                                  ),
                                  child: const Icon(
                                    Icons.edit,
                                    size: 12,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  name,
                                  style: GoogleFonts.sourceSerif4(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: KalyaThiruTheme.primaryMaroon,
                                  ),
                                ),
                                const SizedBox(height: 2),
                                const Text(
                                  'Heritage ID: AR992014',
                                  style: TextStyle(
                                    color: KalyaThiruTheme.mutedGray,
                                    fontSize: 12,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Wrap(
                                  spacing: 8,
                                  runSpacing: 4,
                                  crossAxisAlignment: WrapCrossAlignment.center,
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                                      decoration: BoxDecoration(
                                        color: Colors.grey[100],
                                        borderRadius: BorderRadius.circular(4),
                                      ),
                                      child: Text(
                                        _isPaidMember
                                            ? (lang == 'en' ? 'Elite Member' : 'எலைட் உறுப்பினர்')
                                            : (lang == 'en' ? 'Free Member' : 'இலவச உறுப்பினர்'),
                                        style: const TextStyle(
                                          color: KalyaThiruTheme.darkCharcoal,
                                          fontSize: 10,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ),
                                    if (!_isPaidMember)
                                      GestureDetector(
                                        onTap: _showSubscriptionSheet,
                                        child: Text(
                                          lang == 'en' ? 'Upgrade Now' : 'இப்போது மேம்படுத்தவும்',
                                          style: const TextStyle(
                                            color: KalyaThiruTheme.primaryMaroon,
                                            fontSize: 11,
                                            fontWeight: FontWeight.bold,
                                            decoration: TextDecoration.underline,
                                          ),
                                        ),
                                      ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      // Profile Completion
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            lang == 'en' ? 'Profile Completion' : 'சுயவிவரம் பூர்த்தி',
                            style: const TextStyle(
                              color: KalyaThiruTheme.darkCharcoal,
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            '$completeness%',
                            style: const TextStyle(
                              color: KalyaThiruTheme.primaryMaroon,
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(4),
                        child: LinearProgressIndicator(
                          value: completeness / 100.0,
                          backgroundColor: const Color(0xFFE7E1DE),
                          valueColor: const AlwaysStoppedAnimation<Color>(KalyaThiruTheme.primaryMaroon),
                          minHeight: 8,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 8),
                // Options list
                _buildMenuOption(
                  icon: Icons.verified_user,
                  title: lang == 'en'
                      ? 'Verify Your Profile'
                      : 'உங்கள் சுயவிவரத்தை சரிபார்க்கவும்',
                  iconColor: Colors.white,
                  iconBg: KalyaThiruTheme.antiqueGold,
                  trailing: const Icon(Icons.chevron_right, color: KalyaThiruTheme.outlineBorder),
                  onTap: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Verification system coming soon!')),
                    );
                  },
                ),
                _buildMenuOption(
                  icon: Icons.people_outline,
                  title: lang == 'en' ? 'Matches' : 'பொருத்தங்கள்',
                  onTap: () => context.pop(),
                ),
                _buildMenuOption(
                  icon: Icons.favorite_border,
                  title: lang == 'en' ? 'Interests' : 'ஆர்வங்கள்',
                  onTap: () {
                    context.push('/interests', extra: {'isPaidMember': _isPaidMember});
                  },
                ),
                _buildMenuOption(
                  icon: Icons.auto_awesome_outlined,
                  title: lang == 'en' ? 'Daily Recommendation' : 'தினசரி பரிந்துரை',
                  onTap: () {
                    context.pop();
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Daily Recommendations feature coming soon!')),
                    );
                  },
                ),
                _buildMenuOption(
                  icon: Icons.chat_bubble_outline,
                  title: lang == 'en' ? 'Messages' : 'செய்திகள்',
                  onTap: () {
                    context.push('/communication', extra: {'isPaidMember': _isPaidMember});
                  },
                ),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16.0),
                  child: Divider(color: KalyaThiruTheme.outlineVariant),
                ),
                _buildMenuOption(
                  icon: Icons.person_outline,
                  title: lang == 'en' ? 'Edit Profile' : 'சுயவிவரத்தைத் திருத்தவும்',
                  onTap: () {
                    context.push('/edit_profile');
                  },
                ),
                _buildMenuOption(
                  icon: Icons.settings_accessibility,
                  title: lang == 'en'
                      ? 'Edit Partner Preference'
                      : 'துணை விருப்பங்களைத் திருத்தவும்',
                  onTap: () {
                    context.push('/edit_partner_preference');
                  },
                ),
                _buildUpgradeOption(lang),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16.0),
                  child: Divider(color: KalyaThiruTheme.outlineVariant),
                ),
                // Single Settings Option linking to SettingsScreen
                _buildMenuOption(
                  icon: Icons.settings,
                  title: lang == 'en' ? 'Settings' : 'அமைப்புகள்',
                  trailing: const Icon(Icons.chevron_right, color: KalyaThiruTheme.outlineBorder),
                  onTap: () => context.push('/settings'),
                ),
                _buildMenuOption(
                  icon: Icons.star_border,
                  title: lang == 'en' ? 'Rate Us' : 'எங்களை மதிப்பிடவும்',
                  onTap: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Thank you for rating us!')),
                    );
                  },
                ),
                _buildMenuOption(
                  icon: Icons.help_outline,
                  title: lang == 'en' ? '24x7 Help Center' : '24x7 உதவி மையம்',
                  onTap: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Connecting to help center...')),
                    );
                  },
                ),
                // Footer
                Container(
                  padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
                  color: Colors.white,
                  child: Column(
                    children: [
                      Wrap(
                        alignment: WrapAlignment.center,
                        spacing: 16,
                        runSpacing: 8,
                        children: [
                          GestureDetector(
                            onTap: () {},
                            child: Text(
                              lang == 'en' ? 'Terms & Conditions' : 'விதிமுறைகள் மற்றும் நிபந்தனைகள்',
                              style: const TextStyle(
                                fontSize: 12,
                                decoration: TextDecoration.underline,
                                color: KalyaThiruTheme.mutedGray,
                              ),
                            ),
                          ),
                          GestureDetector(
                            onTap: () {},
                            child: Text(
                              lang == 'en' ? 'Privacy Policy' : 'தனியுரிமைக் கொள்கை',
                              style: const TextStyle(
                                fontSize: 12,
                                decoration: TextDecoration.underline,
                                color: KalyaThiruTheme.mutedGray,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Text(
                        lang == 'en' ? 'App version 11.8.232.108' : 'பயன்பாட்டு பதிப்பு 11.8.232.108',
                        style: const TextStyle(
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
        );
      },
    );
  }

  Widget _buildMenuOption({
    required IconData icon,
    required String title,
    Color? iconColor,
    Color? iconBg,
    Widget? trailing,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: iconBg ?? Colors.transparent,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                icon,
                color: iconColor ?? KalyaThiruTheme.darkCharcoal.withValues(alpha: 0.7),
                size: 20,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                title,
                style: GoogleFonts.nunitoSans(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: KalyaThiruTheme.darkCharcoal,
                ),
              ),
            ),
            if (trailing != null) trailing,
          ],
        ),
      ),
    );
  }

  Widget _buildUpgradeOption(String lang) {
    return InkWell(
      onTap: _showSubscriptionSheet,
      child: Container(
        color: KalyaThiruTheme.primaryMaroon.withValues(alpha: 0.05),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        child: Row(
          children: [
            const Icon(
              Icons.star,
              color: KalyaThiruTheme.primaryMaroon,
              size: 24,
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                lang == 'en' ? 'Upgrade Now' : 'இப்போது மேம்படுத்தவும்',
                style: GoogleFonts.nunitoSans(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: KalyaThiruTheme.primaryMaroon,
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: KalyaThiruTheme.antiqueGold,
                borderRadius: BorderRadius.circular(4),
              ),
              child: const Text(
                '61% OFF',
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
    );
  }
}
