import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../core/theme/theme.dart';
import '../../onboarding/cubit/onboarding_cubit.dart';

class NotificationsSettingsScreen extends StatefulWidget {
  const NotificationsSettingsScreen({super.key});

  @override
  State<NotificationsSettingsScreen> createState() => _NotificationsSettingsScreenState();
}

class _NotificationsSettingsScreenState extends State<NotificationsSettingsScreen> {
  bool _pushNotifications = true;
  bool _emailAlerts = true;
  bool _matchAlerts = true;
  bool _phoneNumberViews = false;
  bool _shortlists = false;
  bool _chats = false;
  bool _moreAlerts = false;

  bool _newMatches = true;
  bool _dailyMatches = false;
  bool _basedOnActivity = false;

  bool _membershipOffers = false;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _pushNotifications = prefs.getBool('settings_push_notifications') ?? true;
      _emailAlerts = prefs.getBool('settings_email_alerts') ?? true;
      _matchAlerts = prefs.getBool('settings_match_alerts') ?? true;
      _phoneNumberViews = prefs.getBool('settings_phone_number_views') ?? false;
      _shortlists = prefs.getBool('settings_shortlists') ?? false;
      _chats = prefs.getBool('settings_chats') ?? false;
      _moreAlerts = prefs.getBool('settings_more_alerts') ?? false;

      _newMatches = prefs.getBool('settings_new_matches') ?? true;
      _dailyMatches = prefs.getBool('settings_daily_matches') ?? false;
      _basedOnActivity = prefs.getBool('settings_based_on_activity') ?? false;

      _membershipOffers = prefs.getBool('settings_membership_offers') ?? false;
      _isLoading = false;
    });
  }

  Future<void> _saveSetting(String key, bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(key, value);
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<OnboardingCubit, OnboardingState>(
      builder: (context, state) {
        final lang = state.langCode;
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
              lang == 'en' ? 'Notifications' : 'அறிவிப்புகள்',
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
          body: _isLoading
              ? const Center(child: CircularProgressIndicator(color: KalyaThiruTheme.primaryMaroon))
              : ListView(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
                  children: [
                    Text(
                      lang == 'en' ? 'Notifications' : 'அறிவிப்புகள்',
                      style: GoogleFonts.sourceSerif4(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: KalyaThiruTheme.darkCharcoal,
                        height: 1.25,
                      ),
                    ),
                    const SizedBox(height: 24),
                    // General Section Card
                    _buildSettingsCard([
                      _buildSwitchTile(
                        title: lang == 'en' ? 'Push Notifications' : 'புஷ் அறிவிப்புகள்',
                        subtitle: lang == 'en'
                            ? 'Get instant updates on your device'
                            : 'உங்கள் சாதனத்தில் உடனடி அறிவிப்புகளைப் பெறுங்கள்',
                        value: _pushNotifications,
                        onChanged: (val) {
                          setState(() => _pushNotifications = val);
                          _saveSetting('settings_push_notifications', val);
                        },
                      ),
                      _buildSwitchTile(
                        title: lang == 'en' ? 'Email Alerts' : 'மின்னஞ்சல் அறிவிப்புகள்',
                        subtitle: lang == 'en'
                            ? 'Receive alerts in your inbox'
                            : 'உங்கள் மின்னஞ்சல் முகவரிக்கு அறிவிப்புகளைப் பெறுங்கள்',
                        value: _emailAlerts,
                        onChanged: (val) {
                          setState(() => _emailAlerts = val);
                          _saveSetting('settings_email_alerts', val);
                        },
                      ),
                      _buildSwitchTile(
                        title: lang == 'en' ? 'Match Alerts' : 'வரன் எச்சரிக்கைகள்',
                        subtitle: lang == 'en'
                            ? 'Get notifications when a new match is found'
                            : 'புதிய வரன் கண்டறியப்படும்போது அறிவிப்புகளைப் பெறுங்கள்',
                        value: _matchAlerts,
                        onChanged: (val) {
                          setState(() => _matchAlerts = val);
                          _saveSetting('settings_match_alerts', val);
                        },
                      ),
                      _buildSwitchTile(
                        title: lang == 'en' ? 'Phone Number Views' : 'தொலைபேசி எண் பார்வைகள்',
                        subtitle: lang == 'en'
                            ? 'Get notified when someone views your phone number'
                            : 'யாராவது உங்கள் தொலைபேசி எண்ணைப் பார்க்கும்போது அறிவிப்பைப் பெறுங்கள்',
                        value: _phoneNumberViews,
                        onChanged: (val) {
                          setState(() => _phoneNumberViews = val);
                          _saveSetting('settings_phone_number_views', val);
                        },
                      ),
                      _buildSwitchTile(
                        title: lang == 'en' ? 'Shortlists' : 'விருப்பப்பட்டியல்கள்',
                        subtitle: lang == 'en'
                            ? 'Get notified when someone shortlists your profile'
                            : 'யாராவது உங்கள் சுயவிவரத்தை விருப்பப்பட்டியலிடும்போது அறிவிப்பைப் பெறுங்கள்',
                        value: _shortlists,
                        onChanged: (val) {
                          setState(() => _shortlists = val);
                          _saveSetting('settings_shortlists', val);
                        },
                      ),
                      _buildSwitchTile(
                        title: lang == 'en' ? 'Chats' : 'அரட்டைகள்',
                        subtitle: lang == 'en'
                            ? 'Get notified of new incoming messages'
                            : 'புதிய உள்வரும் செய்திகளின் அறிவிப்புகளைப் பெறுங்கள்',
                        value: _chats,
                        onChanged: (val) {
                          setState(() => _chats = val);
                          _saveSetting('settings_chats', val);
                        },
                      ),
                      _buildSwitchTile(
                        title: lang == 'en' ? 'More Alerts' : 'கூடுதல் அறிவிப்புகள்',
                        subtitle: lang == 'en'
                            ? 'Other updates and general notifications'
                            : 'பிற புதுப்பிப்புகள் மற்றும் பொதுவான அறிவிப்புகள்',
                        value: _moreAlerts,
                        onChanged: (val) {
                          setState(() => _moreAlerts = val);
                          _saveSetting('settings_more_alerts', val);
                        },
                      ),
                    ]),
                    const SizedBox(height: 24),
                    // Matches Section
                    Text(
                      lang == 'en' ? 'Matches' : 'வரன்கள்',
                      style: GoogleFonts.sourceSerif4(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: KalyaThiruTheme.darkCharcoal,
                      ),
                    ),
                    const SizedBox(height: 12),
                    _buildSettingsCard([
                      _buildSwitchTile(
                        title: lang == 'en' ? 'New Matches' : 'புதிய வரன்கள்',
                        subtitle: lang == 'en'
                            ? 'Alerts for newly registered matching profiles'
                            : 'புதிதாகப் பதிவுசெய்யப்பட்ட பொருத்தமான வரன்களுக்கான அறிவிப்புகள்',
                        value: _newMatches,
                        onChanged: (val) {
                          setState(() => _newMatches = val);
                          _saveSetting('settings_new_matches', val);
                        },
                      ),
                      _buildSwitchTile(
                        title: lang == 'en' ? 'Daily Matches' : 'தினசரி வரன்கள்',
                        subtitle: lang == 'en'
                            ? 'Daily match recommendation digest'
                            : 'தினசரி வரன் பரிந்துரைத் தொகுப்பு',
                        value: _dailyMatches,
                        onChanged: (val) {
                          setState(() => _dailyMatches = val);
                          _saveSetting('settings_daily_matches', val);
                        },
                      ),
                      _buildSwitchTile(
                        title: lang == 'en' ? 'Based on Activity' : 'நடவடிக்கை அடிப்படையில்',
                        subtitle: lang == 'en'
                            ? 'Alerts based on your interaction patterns'
                            : 'உங்கள் தொடர்பு முறைகளின் அடிப்படையிலான அறிவிப்புகள்',
                        value: _basedOnActivity,
                        onChanged: (val) {
                          setState(() => _basedOnActivity = val);
                          _saveSetting('settings_based_on_activity', val);
                        },
                      ),
                    ]),
                    const SizedBox(height: 24),
                    // Premium Section
                    Text(
                      lang == 'en' ? 'Premium' : 'பிரிமியம்',
                      style: GoogleFonts.sourceSerif4(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: KalyaThiruTheme.darkCharcoal,
                      ),
                    ),
                    const SizedBox(height: 12),
                    _buildSettingsCard([
                      _buildSwitchTile(
                        title: lang == 'en' ? 'Membership Offers' : 'உறுப்பினர் சலுகைகள்',
                        subtitle: lang == 'en'
                            ? 'Discount campaigns and upgrade offers'
                            : 'தள்ளுபடி பிரச்சாரங்கள் மற்றும் மேம்படுத்தல் சலுகைகள்',
                        value: _membershipOffers,
                        onChanged: (val) {
                          setState(() => _membershipOffers = val);
                          _saveSetting('settings_membership_offers', val);
                        },
                      ),
                    ]),
                    const SizedBox(height: 24),
                  ],
                ),
        );
      },
    );
  }

  Widget _buildSettingsCard(List<Widget> children) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: KalyaThiruTheme.outlineBorder.withValues(alpha: 0.1),
          width: 1.0,
        ),
      ),
      child: Column(
        children: children,
      ),
    );
  }

  Widget _buildSwitchTile({
    required String title,
    required String subtitle,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: GoogleFonts.nunitoSans(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: KalyaThiruTheme.darkCharcoal,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  subtitle,
                  style: GoogleFonts.nunitoSans(
                    fontSize: 12,
                    color: KalyaThiruTheme.mutedGray,
                  ),
                ),
              ],
            ),
          ),
          Switch(
            value: value,
            onChanged: onChanged,
            activeThumbColor: Colors.white,
            activeTrackColor: KalyaThiruTheme.primaryMaroon,
            inactiveThumbColor: Colors.white,
            inactiveTrackColor: const Color(0xFFE7E1DE),
            trackOutlineColor: WidgetStateProperty.all(Colors.transparent),
          ),
        ],
      ),
    );
  }
}
