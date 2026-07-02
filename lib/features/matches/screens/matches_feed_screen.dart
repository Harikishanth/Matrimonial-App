import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/theme.dart';
import '../../../core/translation/option_translations.dart';
import '../../onboarding/cubit/onboarding_cubit.dart';
import '../../profile/models/profile_model.dart';

class MatchesFeedScreen extends StatefulWidget {
  final bool isPaidMember;

  const MatchesFeedScreen({super.key, this.isPaidMember = false});

  @override
  State<MatchesFeedScreen> createState() => _MatchesFeedScreenState();
}

class _MatchesFeedScreenState extends State<MatchesFeedScreen> {
  // Lists of profiles for each section
  late List<ProfileModel> _nearbyProfiles;
  late List<ProfileModel> _preferenceProfiles;
  late List<ProfileModel> _visitorProfiles;
  late List<ProfileModel> _globalProfiles;
  late List<ProfileModel> _educationProfiles;
  late List<ProfileModel> _professionalProfiles;

  @override
  void initState() {
    super.initState();

    _nearbyProfiles = [
      const ProfileModel(
        id: 'M_NEAR_1',
        name: 'Meena R.',
        age: 28,
        height: "5'4\"",
        photoUrl: 'https://images.unsplash.com/photo-1494790108377-be9c29b29330?w=400',
        occupation: 'Data Scientist',
        city: 'San Francisco',
        state: 'California',
        country: 'United States',
        religion: 'Hindu',
        caste: 'Pillai',
        isVerified: true,
        traits: ['Analytical & Thinker', 'Nature & Travel'],
      ),
      const ProfileModel(
        id: 'M_NEAR_2',
        name: 'Rajesh G.',
        age: 32,
        height: "5'10\"",
        photoUrl: 'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=400',
        occupation: 'VP Finance',
        city: 'Singapore',
        state: 'Singapore',
        country: 'Singapore',
        religion: 'Hindu',
        caste: 'Chettiar',
        isVerified: true,
        traits: ['Practical & Grounded', 'Philosophy'],
      ),
    ];

    _preferenceProfiles = [
      const ProfileModel(
        id: 'M_PREF_1',
        name: 'Ananya K.',
        age: 28,
        height: "5'4\"",
        photoUrl: 'https://images.unsplash.com/photo-1544005313-94ddf0286df2?w=400',
        occupation: 'Product Lead',
        city: 'Bangalore',
        state: 'Karnataka',
        country: 'India',
        religion: 'Hindu',
        caste: 'Mudaliar',
        isVerified: true,
        traits: ['Creative & Expressive', 'Musical'],
      ),
      const ProfileModel(
        id: 'M_PREF_2',
        name: 'Vignesh M.',
        age: 30,
        height: "5'11\"",
        photoUrl: 'https://images.unsplash.com/photo-1506794778202-cad84cf45f1d?w=400',
        occupation: 'Software Engineer',
        city: 'London',
        state: 'London',
        country: 'United Kingdom',
        religion: 'Hindu',
        caste: 'Iyer',
        isVerified: true,
        traits: ['Tech-Savvy', 'Foodie'],
      ),
    ];

    _visitorProfiles = [
      const ProfileModel(
        id: 'M_VIS_1',
        name: 'Arun Prakash',
        age: 29,
        height: "5'8\"",
        photoUrl: 'https://images.unsplash.com/photo-1500648767791-00dcc994a43e?w=400',
        occupation: 'IAS Aspirant',
        city: 'Chennai',
        state: 'Tamil Nadu',
        country: 'India',
        religion: 'Hindu',
        caste: 'Thevar',
        isVerified: true,
        traits: ['Analytical & Thinker', 'Tamil Literature'],
        lastSeen: 'Viewed 2h ago',
      ),
      const ProfileModel(
        id: 'M_VIS_2',
        name: 'Sivakami T.',
        age: 26,
        height: "5'4\"",
        photoUrl: 'https://images.unsplash.com/photo-1534528741775-53994a69daeb?w=400',
        occupation: 'Research Assistant',
        city: 'Coimbatore',
        state: 'Tamil Nadu',
        country: 'India',
        religion: 'Hindu',
        caste: 'Vanniyar',
        isVerified: true,
        traits: ['Introverted & Calm', 'Academic Focus'],
        lastSeen: 'Viewed 5h ago',
      ),
    ];

    _globalProfiles = _nearbyProfiles;
    _educationProfiles = _preferenceProfiles;
    
    _professionalProfiles = [
      const ProfileModel(
        id: 'M_PROF_1',
        name: 'Madhavan R.',
        age: 34,
        height: "5'11\"",
        photoUrl: 'https://images.unsplash.com/photo-1519085360753-af0119f7cbe7?w=400',
        occupation: 'Legal Partner',
        city: 'Chennai',
        state: 'Tamil Nadu',
        country: 'India',
        religion: 'Hindu',
        caste: 'Gounder',
        isVerified: true,
        traits: ['Practical & Grounded', 'Ancient History'],
      ),
      const ProfileModel(
        id: 'M_PROF_2',
        name: 'Janani L.',
        age: 30,
        height: "5'4\"",
        photoUrl: 'https://images.unsplash.com/photo-1488426862026-3ee34a7d66df?w=400',
        occupation: 'Cardiology',
        city: 'Coimbatore',
        state: 'Tamil Nadu',
        country: 'India',
        religion: 'Hindu',
        caste: 'Nadar',
        isVerified: true,
        traits: ['Empathetic & Caregiver', 'Social Service'],
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    final lang = context.watch<OnboardingCubit>().state.langCode;

    Widget buildHeaderSection(String titleKey, List<ProfileModel> profiles) {
      return Padding(
        padding: const EdgeInsets.fromLTRB(16, 20, 16, 12),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Text(
                translateOption(titleKey, lang),
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: KalyaThiruTheme.primaryMaroon,
                  fontFamily: 'Source Serif 4',
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            GestureDetector(
              onTap: () {
                context.push('/selected_matches', extra: {
                  'isPaidMember': widget.isPaidMember,
                  'title': titleKey,
                  'profiles': profiles,
                });
              },
              child: Text(
                translateOption('View All', lang),
                style: const TextStyle(
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

    Widget buildCarousel(List<ProfileModel> profiles, String sectionTitle) {
      return SizedBox(
        height: 300.0,
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.symmetric(horizontal: 16),
          itemCount: profiles.length + 1,
          itemBuilder: (context, index) {
            if (index == profiles.length) {
              return _buildDiscoverMoreCard(context, sectionTitle, profiles, lang, isNearby: true);
            }
            final p = profiles[index];
            return _buildCarouselCard(context, p, lang, isNearby: true);
          },
        ),
      );
    }

    return Scaffold(
      backgroundColor: KalyaThiruTheme.softIvory,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.5,
        centerTitle: false,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: KalyaThiruTheme.darkCharcoal),
          onPressed: () => Navigator.pop(context),
        ),
        title: Row(
          children: [
            CircleAvatar(
              radius: 16,
              backgroundImage: const NetworkImage(
                'https://images.unsplash.com/photo-1500648767791-00dcc994a43e?w=100',
              ),
            ),
            const SizedBox(width: 8),
            const Text(
              'KalyaThiru',
              style: TextStyle(
                fontFamily: 'Source Serif 4',
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: KalyaThiruTheme.primaryMaroon,
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_none_outlined, color: KalyaThiruTheme.darkCharcoal),
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(Icons.menu, color: KalyaThiruTheme.darkCharcoal),
            onPressed: () => context.push('/profile_menu'),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // ── 1. Nearby Matches ────────────────────────────────────────────
            buildHeaderSection('Nearby Matches', _nearbyProfiles),
            buildCarousel(_nearbyProfiles, 'Nearby Matches'),

            // ── 2. Preference Matches ─────────────────────────────────────────
            buildHeaderSection('Preference Matches', _preferenceProfiles),
            buildCarousel(_preferenceProfiles, 'Preference Matches'),

            // ── 3. Recent Visitors ────────────────────────────────────────────
            buildHeaderSection('Recent Visitors', _visitorProfiles),
            buildCarousel(_visitorProfiles, 'Recent Visitors'),

            // ── 4. Global Tamil (NRI) ─────────────────────────────────────────
            buildHeaderSection('Global Tamil (NRI)', _globalProfiles),
            buildCarousel(_globalProfiles, 'Global Tamil (NRI)'),

            // ── 5. Education Match ────────────────────────────────────────────
            buildHeaderSection('Education Match', _educationProfiles),
            buildCarousel(_educationProfiles, 'Education Match'),

            // ── 6. Professional Match ─────────────────────────────────────────
            buildHeaderSection('Professional Match', _professionalProfiles),
            buildCarousel(_professionalProfiles, 'Professional Match'),

            const SizedBox(height: 24),

            // ── Activity Hub ──────────────────────────────────────────────────
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    translateOption('Activity Hub', lang),
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: KalyaThiruTheme.primaryMaroon,
                      fontFamily: 'Source Serif 4',
                    ),
                  ),
                  const SizedBox(height: 12),
                  GridView.count(
                    crossAxisCount: 2,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    mainAxisSpacing: 12,
                    crossAxisSpacing: 12,
                    childAspectRatio: 1.2,
                    children: [
                      _buildActivityCard(
                        icon: Icons.bookmark_border,
                        titleKey: 'Bookmarked',
                        count: 12,
                        lang: lang,
                        onTap: () {
                          context.push('/selected_matches', extra: {
                            'isPaidMember': widget.isPaidMember,
                            'title': 'Bookmarked',
                            'profiles': _preferenceProfiles,
                          });
                        },
                      ),
                      _buildActivityCard(
                        icon: Icons.star_border,
                        titleKey: 'Bookmarked You',
                        count: 48,
                        lang: lang,
                        onTap: () {
                          context.push('/selected_matches', extra: {
                            'isPaidMember': widget.isPaidMember,
                            'title': 'Bookmarked You',
                            'profiles': _nearbyProfiles,
                          });
                        },
                      ),
                      _buildActivityCard(
                        icon: Icons.remove_red_eye_outlined,
                        titleKey: 'Recently Viewed',
                        count: 156,
                        lang: lang,
                        onTap: () {
                          context.push('/selected_matches', extra: {
                            'isPaidMember': widget.isPaidMember,
                            'title': 'Recently Viewed',
                            'profiles': _professionalProfiles,
                          });
                        },
                      ),
                      _buildActivityCard(
                        icon: Icons.visibility_off_outlined,
                        titleKey: 'Hidden Profiles',
                        count: 3,
                        lang: lang,
                        onTap: () {
                          context.push('/selected_matches', extra: {
                            'isPaidMember': widget.isPaidMember,
                            'title': 'Hidden Profiles',
                            'profiles': _visitorProfiles,
                          });
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  Widget _buildCarouselCard(BuildContext context, ProfileModel p, String lang, {required bool isNearby}) {
    const width = 200.0;
    return Container(
      width: width,
      margin: const EdgeInsets.only(right: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: InkWell(
        onTap: () {
          context.push('/profile', extra: p);
        },
        borderRadius: BorderRadius.circular(12),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: Stack(
            children: [
              // Full background image
              Positioned.fill(
                child: Image.network(
                  p.photoUrl ?? 'https://images.unsplash.com/photo-1544005313-94ddf0286df2?w=400',
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      color: Colors.grey[200],
                      alignment: Alignment.center,
                      child: const Icon(
                        Icons.broken_image_outlined,
                        color: Colors.grey,
                        size: 32,
                      ),
                    );
                  },
                ),
              ),
              // Bottom Gradient and text info
              Positioned(
                left: 0,
                right: 0,
                bottom: 0,
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        Colors.transparent,
                        Colors.black.withOpacity(0.9),
                      ],
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                    ),
                  ),
                  padding: const EdgeInsets.fromLTRB(12, 32, 12, 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        '${translateOption(p.name, lang)}, ${p.age}',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 2),
                      Text(
                        '${translateOption(p.occupation, lang)} • ${translateOption(p.city, lang)}',
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.9),
                          fontSize: 11,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 2),
                      Text(
                        p.caste.isNotEmpty
                            ? '${translateOption(p.religion, lang)} • ${translateOption(p.caste, lang)}'
                            : translateOption(p.religion, lang),
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.9),
                          fontSize: 11,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              ),
              // Badges
              // 1. Gold Trust badge for all
              Positioned(
                top: 10,
                right: 10,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xFFF9D976), Color(0xFFE9B646)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.2),
                        blurRadius: 4,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(
                        Icons.shield,
                        color: Colors.green,
                        size: 12,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        translateOption('98% Trust', lang),
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 9,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              // 2. Last Seen badge (Viewed 2h ago)
              if (p.lastSeen != null && p.lastSeen!.isNotEmpty)
                Positioned(
                  top: 10,
                  left: 10,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.6),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      p.lastSeen!,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 8,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDiscoverMoreCard(
    BuildContext context,
    String titleKey,
    List<ProfileModel> profiles,
    String lang, {
    required bool isNearby,
  }) {
    final width = isNearby ? 200.0 : 160.0;
    return Container(
      width: width,
      margin: const EdgeInsets.only(right: 12),
      decoration: BoxDecoration(
        color: const Color(0xFFF0ECE9),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: KalyaThiruTheme.outlineBorder),
      ),
      child: InkWell(
        onTap: () {
          context.push('/selected_matches', extra: {
            'isPaidMember': widget.isPaidMember,
            'title': titleKey,
            'profiles': profiles,
          });
        },
        borderRadius: BorderRadius.circular(12),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.add_circle_outline,
              size: 32,
              color: KalyaThiruTheme.primaryMaroon,
            ),
            const SizedBox(height: 8),
            Text(
              translateOption('Discover More', lang),
              style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.bold,
                color: KalyaThiruTheme.primaryMaroon,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              lang == 'en' ? 'Explore all matches' : 'அனைத்து வரன்களையும் காண்க',
              style: const TextStyle(
                fontSize: 9,
                color: KalyaThiruTheme.mutedGray,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActivityCard({
    required IconData icon,
    required String titleKey,
    required int count,
    required String lang,
    required VoidCallback onTap,
  }) {
    Color cardBg;
    Color iconBg;
    Color iconColor;
    IconData solidIcon;

    if (titleKey == 'Bookmarked') {
      cardBg = const Color(0xFFF5F3FF); // light violet
      iconBg = const Color(0xFFEDE9FE);
      iconColor = const Color(0xFF6D28D9);
      solidIcon = Icons.bookmark;
    } else if (titleKey == 'Bookmarked You') {
      cardBg = const Color(0xFFFFF1F2); // light rose
      iconBg = const Color(0xFFFFE4E6);
      iconColor = const Color(0xFFD01E68);
      solidIcon = Icons.star;
    } else if (titleKey == 'Recently Viewed') {
      cardBg = const Color(0xFFECFDF5); // light emerald
      iconBg = const Color(0xFFD1FAE5);
      iconColor = const Color(0xFF047857);
      solidIcon = Icons.visibility;
    } else { // Hidden Profiles
      cardBg = const Color(0xFFFFF7ED); // light orange/amber
      iconBg = const Color(0xFFFFEDD5);
      iconColor = const Color(0xFFC2410C);
      solidIcon = Icons.visibility_off;
    }

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: cardBg,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: iconColor.withOpacity(0.06),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: iconBg,
                shape: BoxShape.circle,
              ),
              child: Icon(solidIcon, color: iconColor, size: 20),
            ),
            const SizedBox(height: 8),
            Text(
              translateOption(titleKey, lang),
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: iconColor.withOpacity(0.9),
              ),
            ),
            const SizedBox(height: 4),
            Text(
              '$count',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: iconColor.withOpacity(0.95),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
