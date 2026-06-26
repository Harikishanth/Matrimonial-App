import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/theme/theme.dart';
import '../../onboarding/cubit/onboarding_cubit.dart';

class AdvancedSettingsScreen extends StatefulWidget {
  const AdvancedSettingsScreen({super.key});

  @override
  State<AdvancedSettingsScreen> createState() => _AdvancedSettingsScreenState();
}

class _AdvancedSettingsScreenState extends State<AdvancedSettingsScreen> {
  // Mock data for Blocked profiles
  final List<Map<String, dynamic>> _blockedProfiles = [
    {
      'id': '1',
      'name': 'Abhirami K.',
      'isVerified': true,
      'imageUrl': 'https://images.unsplash.com/photo-1544005313-94ddf0286df2?w=200&h=200&fit=crop',
    },
    {
      'id': '2',
      'name': 'Sundaram P.',
      'isVerified': false,
      'imageUrl': 'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=200&h=200&fit=crop',
    },
  ];

  // Mock data for Hidden profiles
  final List<Map<String, dynamic>> _hiddenProfiles = [
    {
      'id': '3',
      'name': 'Meenakshi V.',
      'isVerified': true,
      'imageUrl': 'https://images.unsplash.com/photo-1494790108377-be9c29b29330?w=200&h=200&fit=crop',
    },
  ];

  void _unblockProfile(Map<String, dynamic> profile, String lang) {
    setState(() {
      _blockedProfiles.removeWhere((p) => p['id'] == profile['id']);
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          lang == 'en'
              ? '${profile['name']} has been unblocked.'
              : '${profile['name']} முடக்கம் நீக்கப்பட்டது.',
          style: GoogleFonts.nunitoSans(fontSize: 14, color: Colors.white),
        ),
        backgroundColor: KalyaThiruTheme.primaryMaroon,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _unhideProfile(Map<String, dynamic> profile, String lang) {
    setState(() {
      _hiddenProfiles.removeWhere((p) => p['id'] == profile['id']);
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          lang == 'en'
              ? '${profile['name']} is now visible.'
              : '${profile['name']} இப்போது காட்டப்படுகிறது.',
          style: GoogleFonts.nunitoSans(fontSize: 14, color: Colors.white),
        ),
        backgroundColor: KalyaThiruTheme.primaryMaroon,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<OnboardingCubit, OnboardingState>(
      builder: (context, state) {
        final lang = state.langCode;
        final screenWidth = MediaQuery.of(context).size.width;
        final isDesktop = screenWidth > 600;

        return Scaffold(
          backgroundColor: KalyaThiruTheme.softIvory,
          appBar: AppBar(
            backgroundColor: KalyaThiruTheme.softIvory,
            elevation: 0,
            scrolledUnderElevation: 0,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back, color: KalyaThiruTheme.primaryMaroon),
              onPressed: () => context.pop(),
            ),
            titleSpacing: 0,
            title: Text(
              lang == 'en' ? 'Advanced' : 'மேம்பட்ட',
              style: GoogleFonts.sourceSerif4(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: KalyaThiruTheme.primaryMaroon,
              ),
            ),
            actions: [
              IconButton(
                icon: const Icon(Icons.more_vert, color: KalyaThiruTheme.primaryMaroon),
                onPressed: () {},
              ),
            ],
            bottom: PreferredSize(
              preferredSize: const Size.fromHeight(1.0),
              child: Container(
                color: KalyaThiruTheme.outlineVariant,
                height: 1.0,
              ),
            ),
          ),
          body: ListView(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
            children: [
              Text(
                lang == 'en' ? 'Advanced Settings' : 'மேம்பட்ட அமைப்புகள்',
                style: GoogleFonts.sourceSerif4(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: KalyaThiruTheme.darkCharcoal,
                  height: 1.25,
                ),
              ),
              const SizedBox(height: 32),

              // Blocked Profiles Section
              _buildSectionHeader(
                icon: Icons.block,
                title: lang == 'en' ? 'Blocked Profiles' : 'முடக்கப்பட்டவை',
                lang: lang,
              ),
              const SizedBox(height: 16),
              if (_blockedProfiles.isEmpty)
                _buildEmptyState(
                  lang == 'en' ? 'No blocked profiles' : 'முடக்கப்பட்ட சுயவிவரங்கள் இல்லை',
                )
              else if (isDesktop)
                GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 16,
                    mainAxisSpacing: 16,
                    mainAxisExtent: 84,
                  ),
                  itemCount: _blockedProfiles.length,
                  itemBuilder: (context, index) {
                    final profile = _blockedProfiles[index];
                    return _buildBlockedCard(profile, lang);
                  },
                )
              else
                ListView.separated(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: _blockedProfiles.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 12),
                  itemBuilder: (context, index) {
                    final profile = _blockedProfiles[index];
                    return _buildBlockedCard(profile, lang);
                  },
                ),

              const SizedBox(height: 40),

              // Hidden Profiles Section
              _buildSectionHeader(
                icon: Icons.visibility_off,
                title: lang == 'en' ? 'Hidden Profiles' : 'மறைக்கப்பட்டவை',
                lang: lang,
              ),
              const SizedBox(height: 16),
              if (_hiddenProfiles.isEmpty)
                _buildEmptyState(
                  lang == 'en' ? 'No hidden profiles' : 'மறைக்கப்பட்ட சுயவிவரங்கள் இல்லை',
                )
              else if (isDesktop)
                GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 16,
                    mainAxisSpacing: 16,
                    mainAxisExtent: 84,
                  ),
                  itemCount: _hiddenProfiles.length,
                  itemBuilder: (context, index) {
                    final profile = _hiddenProfiles[index];
                    return _buildHiddenCard(profile, lang);
                  },
                )
              else
                ListView.separated(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: _hiddenProfiles.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 12),
                  itemBuilder: (context, index) {
                    final profile = _hiddenProfiles[index];
                    return _buildHiddenCard(profile, lang);
                  },
                ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildSectionHeader({
    required IconData icon,
    required String title,
    required String lang,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icon, color: KalyaThiruTheme.primaryMaroon, size: 22),
            const SizedBox(width: 8),
            Text(
              title,
              style: GoogleFonts.sourceSerif4(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: KalyaThiruTheme.primaryMaroon,
              ),
            ),
          ],
        ),
        const SizedBox(height: 4),
        const Divider(color: KalyaThiruTheme.outlineVariant, height: 1),
      ],
    );
  }

  Widget _buildEmptyState(String text) {
    return Container(
      padding: const EdgeInsets.all(24),
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: KalyaThiruTheme.outlineBorder.withValues(alpha: 0.1),
        ),
      ),
      child: Text(
        text,
        style: GoogleFonts.nunitoSans(
          fontSize: 14,
          color: KalyaThiruTheme.mutedGray,
          fontStyle: FontStyle.italic,
        ),
      ),
    );
  }

  Widget _buildBlockedCard(Map<String, dynamic> profile, String lang) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: KalyaThiruTheme.outlineBorder.withValues(alpha: 0.1),
        ),
      ),
      child: Row(
        children: [
          Stack(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.network(
                  profile['imageUrl'],
                  width: 56,
                  height: 56,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      width: 56,
                      height: 56,
                      color: KalyaThiruTheme.outlineVariant,
                      child: const Icon(Icons.person, color: KalyaThiruTheme.mutedGray),
                    );
                  },
                ),
              ),
              if (profile['isVerified'])
                Positioned(
                  top: -2,
                  right: -2,
                  child: Container(
                    decoration: const BoxDecoration(
                      color: KalyaThiruTheme.antiqueGold,
                      shape: BoxShape.circle,
                    ),
                    padding: const EdgeInsets.all(2),
                    child: const Icon(
                      Icons.verified,
                      size: 10,
                      color: Colors.white,
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  profile['name'],
                  style: GoogleFonts.sourceSerif4(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: KalyaThiruTheme.darkCharcoal,
                  ),
                ),
                const SizedBox(height: 4),
                if (profile['isVerified'])
                  Container(
                    decoration: BoxDecoration(
                      gradient: KalyaThiruTheme.auraGold,
                      borderRadius: BorderRadius.circular(4),
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                    child: Text(
                      lang == 'en' ? 'VERIFIED' : 'சரிபார்க்கப்பட்டது',
                      style: GoogleFonts.nunitoSans(
                        fontSize: 9,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        letterSpacing: 0.5,
                      ),
                    ),
                  )
                else
                  Container(
                    decoration: BoxDecoration(
                      color: KalyaThiruTheme.mutedGray.withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                    child: Text(
                      lang == 'en' ? 'UNVERIFIED' : 'சரிபார்க்கப்படாதது',
                      style: GoogleFonts.nunitoSans(
                        fontSize: 9,
                        fontWeight: FontWeight.bold,
                        color: KalyaThiruTheme.darkCharcoal.withValues(alpha: 0.7),
                        letterSpacing: 0.5,
                      ),
                    ),
                  ),
              ],
            ),
          ),
          IconButton(
            icon: const Icon(Icons.settings_backup_restore, color: KalyaThiruTheme.primaryMaroon),
            tooltip: lang == 'en' ? 'Unblock' : 'முடக்கம் நீக்கு',
            onPressed: () => _unblockProfile(profile, lang),
          ),
        ],
      ),
    );
  }

  Widget _buildHiddenCard(Map<String, dynamic> profile, String lang) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: KalyaThiruTheme.outlineBorder.withValues(alpha: 0.1),
        ),
      ),
      child: Row(
        children: [
          Stack(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.network(
                  profile['imageUrl'],
                  width: 56,
                  height: 56,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      width: 56,
                      height: 56,
                      color: KalyaThiruTheme.outlineVariant,
                      child: const Icon(Icons.person, color: KalyaThiruTheme.mutedGray),
                    );
                  },
                ),
              ),
              if (profile['isVerified'])
                Positioned(
                  top: -2,
                  right: -2,
                  child: Container(
                    decoration: const BoxDecoration(
                      color: KalyaThiruTheme.antiqueGold,
                      shape: BoxShape.circle,
                    ),
                    padding: const EdgeInsets.all(2),
                    child: const Icon(
                      Icons.verified,
                      size: 10,
                      color: Colors.white,
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  profile['name'],
                  style: GoogleFonts.sourceSerif4(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: KalyaThiruTheme.darkCharcoal,
                  ),
                ),
                const SizedBox(height: 4),
                if (profile['isVerified'])
                  Container(
                    decoration: BoxDecoration(
                      gradient: KalyaThiruTheme.auraGold,
                      borderRadius: BorderRadius.circular(4),
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                    child: Text(
                      lang == 'en' ? 'VERIFIED' : 'சரிபார்க்கப்பட்டது',
                      style: GoogleFonts.nunitoSans(
                        fontSize: 9,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        letterSpacing: 0.5,
                      ),
                    ),
                  )
                else
                  Container(
                    decoration: BoxDecoration(
                      color: KalyaThiruTheme.mutedGray.withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                    child: Text(
                      lang == 'en' ? 'UNVERIFIED' : 'சரிபார்க்கப்படாதது',
                      style: GoogleFonts.nunitoSans(
                        fontSize: 9,
                        fontWeight: FontWeight.bold,
                        color: KalyaThiruTheme.darkCharcoal.withValues(alpha: 0.7),
                        letterSpacing: 0.5,
                      ),
                    ),
                  ),
              ],
            ),
          ),
          OutlinedButton(
            style: OutlinedButton.styleFrom(
              side: const BorderSide(color: KalyaThiruTheme.outlineBorder, width: 1),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            ),
            onPressed: () => _unhideProfile(profile, lang),
            child: Text(
              lang == 'en' ? 'Unhide' : 'காட்டு',
              style: GoogleFonts.nunitoSans(
                fontSize: 13,
                fontWeight: FontWeight.bold,
                color: KalyaThiruTheme.primaryMaroon,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
