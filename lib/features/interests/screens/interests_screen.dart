import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/theme.dart';
import '../../../core/translation/translations.dart';
import '../../onboarding/cubit/onboarding_cubit.dart';
import '../../communication/screens/chat_screen.dart';

enum InterestStatus { accepted, pending, declined }
enum InterestSection { received, sent }

class InterestProfile {
  final String id;
  final String name;
  final String photoUrl;
  final String age;
  final String height;
  final String education;
  final String occupation;
  final String location;
  final String matchScore;
  final String lastSeen;
  final bool isOnline;
  final bool isPaid;
  final InterestStatus status;
  final bool isRead;

  InterestProfile({
    required this.id,
    required this.name,
    required this.photoUrl,
    required this.age,
    required this.height,
    required this.education,
    required this.occupation,
    required this.location,
    required this.matchScore,
    required this.lastSeen,
    required this.isOnline,
    required this.isPaid,
    required this.status,
    required this.isRead,
  });

  InterestProfile copyWith({bool? isRead}) {
    return InterestProfile(
      id: id,
      name: name,
      photoUrl: photoUrl,
      age: age,
      height: height,
      education: education,
      occupation: occupation,
      location: location,
      matchScore: matchScore,
      lastSeen: lastSeen,
      isOnline: isOnline,
      isPaid: isPaid,
      status: status,
      isRead: isRead ?? this.isRead,
    );
  }
}

class InterestsScreen extends StatefulWidget {
  final bool isPaidMember;

  const InterestsScreen({super.key, this.isPaidMember = false});

  @override
  State<InterestsScreen> createState() => _InterestsScreenState();
}

class _InterestsScreenState extends State<InterestsScreen> with SingleTickerProviderStateMixin {
  late TabController _sectionTabController;
  int _currentSectionIndex = 0; // 0 = Received, 1 = Sent
  String _activeSubTab = 'all'; // 'all', 'pending', 'accepted', 'declined'
  
  bool _isSearchActive = false;
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  // Filter values
  bool _filterUnread = false;
  bool _filterRead = false;
  bool _filterAccepted = false;
  bool _filterDeclined = false;

  late List<InterestProfile> _receivedProfiles;
  late List<InterestProfile> _sentProfiles;

  @override
  void initState() {
    super.initState();
    _sectionTabController = TabController(length: 2, vsync: this);
    _sectionTabController.addListener(() {
      if (_sectionTabController.indexIsChanging) return;
      setState(() {
        _currentSectionIndex = _sectionTabController.index;
      });
    });

    _receivedProfiles = [
      InterestProfile(
        id: 'KT92841',
        name: 'Ananya Iyer',
        photoUrl: 'https://images.unsplash.com/photo-1494790108377-be9c29b29330?w=200',
        age: '26',
        height: "5'4\"",
        education: 'B.Tech IT',
        occupation: 'Software Engineer',
        location: 'Chennai, Tamil Nadu',
        matchScore: '8.5/10',
        lastSeen: 'Online now',
        isOnline: true,
        isPaid: true,
        status: InterestStatus.accepted,
        isRead: true,
      ),
      InterestProfile(
        id: 'KT92842',
        name: 'Priyanka Rao',
        photoUrl: 'https://images.unsplash.com/photo-1534528741775-53994a69daeb?w=200',
        age: '27',
        height: "5'5\"",
        education: 'B.Des',
        occupation: 'Graphic Designer',
        location: 'Bangalore, Karnataka',
        matchScore: '9.1/10',
        lastSeen: 'Last seen yesterday',
        isOnline: false,
        isPaid: false,
        status: InterestStatus.pending,
        isRead: false,
      ),
      InterestProfile(
        id: 'KT92843',
        name: 'Deepika Sundar',
        photoUrl: 'https://images.unsplash.com/photo-1544005313-94ddf0286df2?w=200',
        age: '25',
        height: "5'3\"",
        education: 'M.Sc Data Science',
        occupation: 'Data Analyst',
        location: 'Coimbatore, Tamil Nadu',
        matchScore: '7.9/10',
        lastSeen: 'Online now',
        isOnline: true,
        isPaid: false,
        status: InterestStatus.declined,
        isRead: true,
      ),
    ];

    _sentProfiles = [
      InterestProfile(
        id: 'KT92844',
        name: 'Sneha Reddy',
        photoUrl: 'https://images.unsplash.com/photo-1524504388940-b1c1722653e1?w=200',
        age: '26',
        height: "5'4\"",
        education: 'MBA',
        occupation: 'Product Manager',
        location: 'Hyderabad, Telangana',
        matchScore: '8.8/10',
        lastSeen: 'Online now',
        isOnline: true,
        isPaid: true,
        status: InterestStatus.accepted,
        isRead: true,
      ),
      InterestProfile(
        id: 'KT92845',
        name: 'Kavitha Nair',
        photoUrl: 'https://images.unsplash.com/photo-1517841905240-472988babdf9?w=200',
        age: '25',
        height: "5'2\"",
        education: 'MA English',
        occupation: 'Content Writer',
        location: 'Kochi, Kerala',
        matchScore: '8.2/10',
        lastSeen: 'Last seen 3 hours ago',
        isOnline: false,
        isPaid: false,
        status: InterestStatus.pending,
        isRead: false,
      ),
      InterestProfile(
        id: 'KT92846',
        name: 'Meera Pillai',
        photoUrl: 'https://images.unsplash.com/photo-1488426862026-3ee34a7d66df?w=200',
        age: '28',
        height: "5'6\"",
        education: 'PhD Biotechnology',
        occupation: 'Research Scientist',
        location: 'Trivandrum, Kerala',
        matchScore: '7.5/10',
        lastSeen: 'Last seen 1 day ago',
        isOnline: false,
        isPaid: false,
        status: InterestStatus.declined,
        isRead: true,
      ),
    ];
  }

  @override
  void dispose() {
    _sectionTabController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  void _showUpgradeDialog(String lang) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (ctx) {
        return Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          ),
          padding: const EdgeInsets.fromLTRB(24, 12, 24, 24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(height: 20),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: const BoxDecoration(
                  color: Color(0xFFFFF9E6),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.phone,
                  color: KalyaThiruTheme.primaryMaroon,
                  size: 36,
                ),
              ),
              const SizedBox(height: 16),
              Text(
                AppTranslations.translate('comm_upgrade_title', lang),
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: KalyaThiruTheme.primaryMaroon,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                AppTranslations.translate('comm_upgrade_desc', lang),
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 13,
                  color: KalyaThiruTheme.mutedGray,
                  height: 1.5,
                ),
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => Navigator.pop(ctx),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: KalyaThiruTheme.primaryMaroon,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: Text(
                    AppTranslations.translate('comm_upgrade_btn', lang),
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: Colors.white),
                  ),
                ),
              ),
              const SizedBox(height: 12),
              TextButton(
                onPressed: () => Navigator.pop(ctx),
                child: Text(
                  AppTranslations.translate('comm_maybe_later', lang),
                  style: const TextStyle(color: KalyaThiruTheme.mutedGray),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void _showFilterSheet(String lang) {
    bool tempUnread = _filterUnread;
    bool tempRead = _filterRead;
    bool tempAccepted = _filterAccepted;
    bool tempDeclined = _filterDeclined;

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (ctx) {
        return StatefulBuilder(
          builder: (ctx, setSheetState) {
            Widget buildCheckboxRow(String titleKey, String descKey, bool value, ValueChanged<bool?> onChanged) {
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            AppTranslations.translate(titleKey, lang),
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: KalyaThiruTheme.darkCharcoal,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            AppTranslations.translate(descKey, lang),
                            style: const TextStyle(
                              fontSize: 11,
                              color: KalyaThiruTheme.mutedGray,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Checkbox(
                      value: value,
                      onChanged: onChanged,
                      activeColor: KalyaThiruTheme.primaryMaroon,
                    ),
                  ],
                ),
              );
            }

            return Container(
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
              ),
              padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
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
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        AppTranslations.translate('interests_filter', lang),
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: KalyaThiruTheme.darkCharcoal,
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.close, size: 20),
                        onPressed: () => Navigator.pop(ctx),
                      ),
                    ],
                  ),
                  const Divider(),
                  buildCheckboxRow('filter_unread', 'filter_unread_desc', tempUnread, (val) {
                    setSheetState(() => tempUnread = val ?? false);
                  }),
                  buildCheckboxRow('filter_read', 'filter_read_desc', tempRead, (val) {
                    setSheetState(() => tempRead = val ?? false);
                  }),
                  buildCheckboxRow('filter_accepted', 'filter_accepted_desc', tempAccepted, (val) {
                    setSheetState(() => tempAccepted = val ?? false);
                  }),
                  buildCheckboxRow('filter_declined', 'filter_declined_desc', tempDeclined, (val) {
                    setSheetState(() => tempDeclined = val ?? false);
                  }),
                  const SizedBox(height: 20),
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () {
                            setSheetState(() {
                              tempUnread = false;
                              tempRead = false;
                              tempAccepted = false;
                              tempDeclined = false;
                            });
                          },
                          style: OutlinedButton.styleFrom(
                            side: const BorderSide(color: KalyaThiruTheme.primaryMaroon),
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          child: Text(
                            AppTranslations.translate('interests_clear', lang),
                            style: const TextStyle(
                              color: KalyaThiruTheme.primaryMaroon,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () {
                            setState(() {
                              _filterUnread = tempUnread;
                              _filterRead = tempRead;
                              _filterAccepted = tempAccepted;
                              _filterDeclined = tempDeclined;
                            });
                            Navigator.pop(ctx);
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: KalyaThiruTheme.primaryMaroon,
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          child: Text(
                            AppTranslations.translate('interests_apply', lang),
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  void _showProfileOptions(InterestProfile profile, String lang) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (ctx) {
        return Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          ),
          padding: const EdgeInsets.symmetric(vertical: 20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(Icons.share, color: KalyaThiruTheme.darkCharcoal),
                title: Text(
                  AppTranslations.translate('interests_share', lang),
                  style: const TextStyle(fontWeight: FontWeight.w600),
                ),
                onTap: () {
                  Navigator.pop(ctx);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Shared profile: ${profile.name} (${profile.id})')),
                  );
                },
              ),
              ListTile(
                leading: const Icon(Icons.delete, color: Colors.red),
                title: Text(
                  AppTranslations.translate('interests_delete', lang),
                  style: const TextStyle(color: Colors.red, fontWeight: FontWeight.w600),
                ),
                onTap: () {
                  Navigator.pop(ctx);
                  setState(() {
                    if (_currentSectionIndex == 0) {
                      _receivedProfiles.removeWhere((p) => p.id == profile.id);
                    } else {
                      _sentProfiles.removeWhere((p) => p.id == profile.id);
                    }
                  });
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Deleted profile: ${profile.name}')),
                  );
                },
              ),
            ],
          ),
        );
      },
    );
  }

  List<InterestProfile> _getFilteredProfiles() {
    List<InterestProfile> list = _currentSectionIndex == 0 ? _receivedProfiles : _sentProfiles;

    // Filter by sub-tab category
    if (_activeSubTab == 'pending') {
      list = list.where((p) => p.status == InterestStatus.pending).toList();
    } else if (_activeSubTab == 'accepted') {
      list = list.where((p) => p.status == InterestStatus.accepted).toList();
    } else if (_activeSubTab == 'declined') {
      list = list.where((p) => p.status == InterestStatus.declined).toList();
    }

    // Filter by bottom sheet checkboxes (only apply filter if at least one checkbox is selected)
    final bool anyFilterChecked = _filterUnread || _filterRead || _filterAccepted || _filterDeclined;
    if (anyFilterChecked) {
      list = list.where((p) {
        bool match = false;
        if (_filterUnread && !p.isRead) match = true;
        if (_filterRead && p.isRead) match = true;
        if (_filterAccepted && p.status == InterestStatus.accepted) match = true;
        if (_filterDeclined && p.status == InterestStatus.declined) match = true;
        return match;
      }).toList();
    }

    // Filter by Profile ID search
    if (_searchQuery.isNotEmpty) {
      list = list.where((p) => p.id.toLowerCase().contains(_searchQuery.toLowerCase())).toList();
    }

    return list;
  }

  @override
  Widget build(BuildContext context) {
    final lang = context.watch<OnboardingCubit>().state.langCode;
    final filteredProfiles = _getFilteredProfiles();

    Widget buildSubTabButton(String labelKey, String value) {
      final bool isSelected = _activeSubTab == value;
      return GestureDetector(
        onTap: () {
          setState(() {
            _activeSubTab = value;
          });
        },
        child: Container(
          margin: const EdgeInsets.only(right: 8),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            color: isSelected ? KalyaThiruTheme.primaryMaroon : Colors.white,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: isSelected ? KalyaThiruTheme.primaryMaroon : KalyaThiruTheme.outlineBorder,
            ),
          ),
          child: Text(
            AppTranslations.translate(labelKey, lang),
            style: TextStyle(
              color: isSelected ? Colors.white : KalyaThiruTheme.darkCharcoal,
              fontSize: 12,
              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
            ),
          ),
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
        ],
        bottom: TabBar(
          controller: _sectionTabController,
          indicatorColor: KalyaThiruTheme.primaryMaroon,
          indicatorWeight: 2.5,
          labelColor: KalyaThiruTheme.primaryMaroon,
          unselectedLabelColor: KalyaThiruTheme.mutedGray,
          labelStyle: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
          unselectedLabelStyle: const TextStyle(fontSize: 14, fontWeight: FontWeight.normal),
          tabs: [
            Tab(text: AppTranslations.translate('interests_received', lang)),
            Tab(text: AppTranslations.translate('interests_sent', lang)),
          ],
        ),
      ),
      body: Column(
        children: [
          // Sub-tabs list (All, Pending, Accepted, Declined)
          Container(
            color: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Row(
              children: [
                buildSubTabButton('interests_all', 'all'),
                buildSubTabButton('interests_pending', 'pending'),
                buildSubTabButton('interests_accepted', 'accepted'),
                buildSubTabButton('interests_declined', 'declined'),
              ],
            ),
          ),

          // Header with filter, search icons
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        _activeSubTab == 'all'
                            ? AppTranslations.translate('interests_all', lang) + ' ' + AppTranslations.translate('interests_received', lang).split(' ').last
                            : AppTranslations.translate('interests_' + _activeSubTab, lang) + ' ' + AppTranslations.translate('interests_received', lang).split(' ').last,
                        style: const TextStyle(
                          fontSize: 18,
                          fontFamily: 'Source Serif 4',
                          fontWeight: FontWeight.bold,
                          color: KalyaThiruTheme.primaryMaroon,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        AppTranslations.translate(
                          _currentSectionIndex == 0
                              ? 'interests_' + _activeSubTab + '_history_received'
                              : 'interests_' + _activeSubTab + '_history_sent',
                          lang,
                        ),
                        style: const TextStyle(fontSize: 11, color: KalyaThiruTheme.mutedGray),
                      ),
                    ],
                  ),
                ),
                Row(
                  children: [
                    IconButton(
                      icon: Icon(
                        _isSearchActive ? Icons.close : Icons.search,
                        color: KalyaThiruTheme.darkCharcoal,
                      ),
                      onPressed: () {
                        setState(() {
                          _isSearchActive = !_isSearchActive;
                          if (!_isSearchActive) {
                            _searchQuery = '';
                            _searchController.clear();
                          }
                        });
                      },
                    ),
                    IconButton(
                      icon: const Icon(Icons.tune, color: KalyaThiruTheme.darkCharcoal),
                      onPressed: () => _showFilterSheet(lang),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // Search bar
          if (_isSearchActive)
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: KalyaThiruTheme.outlineBorder),
              ),
              child: TextField(
                controller: _searchController,
                onChanged: (val) {
                  setState(() {
                    _searchQuery = val;
                  });
                },
                decoration: InputDecoration(
                  hintText: AppTranslations.translate('interests_search_id', lang),
                  prefixIcon: const Icon(Icons.search, color: KalyaThiruTheme.mutedGray),
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.symmetric(vertical: 12),
                ),
              ),
            ),

          // Profiles list
          Expanded(
            child: filteredProfiles.isEmpty
                ? _buildEmptyState(lang)
                : ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    itemCount: filteredProfiles.length,
                    itemBuilder: (context, index) {
                      final profile = filteredProfiles[index];
                      return _buildProfileCard(profile, lang);
                    },
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState(String lang) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: Colors.grey[200],
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.favorite_border,
                size: 64,
                color: Colors.grey[400],
              ),
            ),
            const SizedBox(height: 24),
            Text(
              AppTranslations.translate('interests_no_profiles', lang),
              style: const TextStyle(
                fontFamily: 'Source Serif 4',
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: KalyaThiruTheme.primaryMaroon,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              AppTranslations.translate(
                _currentSectionIndex == 0 ? 'interests_no_received_desc' : 'interests_no_sent_desc',
                lang,
              ),
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 13,
                color: KalyaThiruTheme.mutedGray,
                height: 1.5,
              ),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () => Navigator.pop(context),
              style: ElevatedButton.styleFrom(
                backgroundColor: KalyaThiruTheme.primaryMaroon,
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    AppTranslations.translate('interests_explore_matches', lang),
                    style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(width: 8),
                  const Icon(Icons.arrow_forward, color: Colors.white, size: 16),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileCard(InterestProfile profile, String lang) {
    // Determine status subtitle translation
    String statusText = '';
    if (profile.status == InterestStatus.accepted) {
      statusText = AppTranslations.translate(
        _currentSectionIndex == 0 ? 'interests_status_accepted_sent' : 'interests_status_accepted_received',
        lang,
      );
    } else if (profile.status == InterestStatus.pending) {
      statusText = AppTranslations.translate(
        _currentSectionIndex == 0 ? 'interests_status_pending_received' : 'interests_status_pending_sent',
        lang,
      );
    } else {
      statusText = AppTranslations.translate(
        _currentSectionIndex == 0 ? 'interests_status_declined_received' : 'interests_status_declined_sent',
        lang,
      );
    }

    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: const BorderSide(color: KalyaThiruTheme.outlineBorder),
      ),
      color: Colors.white,
      elevation: 0,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Profile Avatar with online badge
                Stack(
                  children: [
                    CircleAvatar(
                      radius: 36,
                      backgroundColor: Colors.grey[200],
                      backgroundImage: NetworkImage(profile.photoUrl),
                    ),
                    if (profile.isOnline)
                      Positioned(
                        bottom: 0,
                        right: 2,
                        child: Container(
                          width: 14,
                          height: 14,
                          decoration: BoxDecoration(
                            color: Colors.green,
                            shape: BoxShape.circle,
                            border: Border.all(color: Colors.white, width: 2),
                          ),
                        ),
                      ),
                  ],
                ),
                const SizedBox(width: 12),
                // Profile details
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Text(
                              profile.name,
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: KalyaThiruTheme.primaryMaroon,
                              ),
                            ),
                          ),
                           IconButton(
                            icon: const Icon(Icons.more_vert, color: KalyaThiruTheme.mutedGray),
                            onPressed: () => _showProfileOptions(profile, lang),
                            padding: EdgeInsets.zero,
                            constraints: const BoxConstraints(),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '${profile.age} yrs, ${profile.height} • ${profile.occupation}',
                        style: const TextStyle(
                          fontSize: 12,
                          color: KalyaThiruTheme.darkCharcoal,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        profile.location,
                        style: const TextStyle(
                          fontSize: 12,
                          color: KalyaThiruTheme.mutedGray,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          
          // Status Notification Strip
          Container(
            width: double.infinity,
            margin: const EdgeInsets.symmetric(horizontal: 12),
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: const Color(0xFFFFFDF6),
              borderRadius: BorderRadius.circular(6),
              border: Border.all(color: const Color(0xFFFFF0C2), width: 0.5),
            ),
            child: Row(
              children: [
                const Icon(Icons.info_outline, size: 14, color: Colors.orange),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    statusText,
                    style: const TextStyle(
                      fontSize: 11,
                      color: KalyaThiruTheme.darkCharcoal,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                ),
              ],
            ),
          ),
          
          // Action Buttons
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Row(
              children: [
                // Send Message
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () {
                      // Mark interest as read
                      setState(() {
                        if (_currentSectionIndex == 0) {
                          final idx = _receivedProfiles.indexWhere((p) => p.id == profile.id);
                          if (idx != -1) {
                            _receivedProfiles[idx] = _receivedProfiles[idx].copyWith(isRead: true);
                          }
                        } else {
                          final idx = _sentProfiles.indexWhere((p) => p.id == profile.id);
                          if (idx != -1) {
                            _sentProfiles[idx] = _sentProfiles[idx].copyWith(isRead: true);
                          }
                        }
                      });

                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => ChatScreen(
                            personName: profile.name,
                            personPhotoUrl: profile.photoUrl,
                            isPaidMember: widget.isPaidMember,
                            isOnline: profile.isOnline,
                            lastSeen: profile.lastSeen,
                          ),
                        ),
                      );
                    },
                    icon: const Icon(Icons.chat_bubble_outline, size: 16, color: KalyaThiruTheme.primaryMaroon),
                    label: Text(
                      AppTranslations.translate('interests_send_msg', lang),
                      style: const TextStyle(
                        color: KalyaThiruTheme.primaryMaroon,
                        fontWeight: FontWeight.bold,
                        fontSize: 11,
                      ),
                    ),
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(color: KalyaThiruTheme.primaryMaroon),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                // Call
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () {
                      if (widget.isPaidMember) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('${AppTranslations.translate('comm_calling', lang)} ${profile.name}...'),
                          ),
                        );
                      } else {
                        _showUpgradeDialog(lang);
                      }
                    },
                    icon: const Icon(Icons.phone, size: 16, color: KalyaThiruTheme.primaryMaroon),
                    label: Text(
                      AppTranslations.translate('interests_call', lang),
                      style: const TextStyle(
                        color: KalyaThiruTheme.primaryMaroon,
                        fontWeight: FontWeight.bold,
                        fontSize: 11,
                      ),
                    ),
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(color: KalyaThiruTheme.primaryMaroon),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
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
