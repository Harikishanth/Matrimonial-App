import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../core/theme/theme.dart';
import '../../onboarding/cubit/onboarding_cubit.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _isAccountExpanded = false;

  void _toggleAccount() {
    setState(() {
      _isAccountExpanded = !_isAccountExpanded;
    });
  }

  void _showChangePasswordDialog(String lang) {
    final oldPasswordController = TextEditingController();
    final newPasswordController = TextEditingController();
    final confirmPasswordController = TextEditingController();
    final formKey = GlobalKey<FormState>();

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          surfaceTintColor: Colors.transparent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
            side: const BorderSide(color: KalyaThiruTheme.outlineBorder, width: 1),
          ),
          title: Text(
            lang == 'en' ? 'Change Password' : 'கடவுச்சொல்லை மாற்றவும்',
            style: GoogleFonts.sourceSerif4(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: KalyaThiruTheme.primaryMaroon,
            ),
          ),
          content: Form(
            key: formKey,
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextFormField(
                    controller: oldPasswordController,
                    obscureText: true,
                    decoration: InputDecoration(
                      labelText: lang == 'en' ? 'Old Password' : 'பழைய கடவுச்சொல்',
                      labelStyle: GoogleFonts.nunitoSans(color: KalyaThiruTheme.mutedGray),
                      focusedBorder: const UnderlineInputBorder(
                        borderSide: BorderSide(color: KalyaThiruTheme.primaryMaroon),
                      ),
                    ),
                    validator: (val) {
                      if (val == null || val.isEmpty) {
                        return lang == 'en' ? 'Please enter old password' : 'பழைய கடவுச்சொல்லை உள்ளிடவும்';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    controller: newPasswordController,
                    obscureText: true,
                    decoration: InputDecoration(
                      labelText: lang == 'en' ? 'New Password' : 'புதிய கடவுச்சொல்',
                      labelStyle: GoogleFonts.nunitoSans(color: KalyaThiruTheme.mutedGray),
                      focusedBorder: const UnderlineInputBorder(
                        borderSide: BorderSide(color: KalyaThiruTheme.primaryMaroon),
                      ),
                    ),
                    validator: (val) {
                      if (val == null || val.isEmpty) {
                        return lang == 'en' ? 'Please enter new password' : 'புதிய கடவுச்சொல்லை உள்ளிடவும்';
                      }
                      if (val.length < 6) {
                        return lang == 'en'
                            ? 'Password must be at least 6 characters'
                            : 'கடவுச்சொல் குறைந்தது 6 எழுத்துக்கள் இருக்க வேண்டும்';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    controller: confirmPasswordController,
                    obscureText: true,
                    decoration: InputDecoration(
                      labelText: lang == 'en' ? 'Confirm New Password' : 'புதிய கடவுச்சொல்லை உறுதிப்படுத்தவும்',
                      labelStyle: GoogleFonts.nunitoSans(color: KalyaThiruTheme.mutedGray),
                      focusedBorder: const UnderlineInputBorder(
                        borderSide: BorderSide(color: KalyaThiruTheme.primaryMaroon),
                      ),
                    ),
                    validator: (val) {
                      if (val == null || val.isEmpty) {
                        return lang == 'en' ? 'Please confirm new password' : 'கடவுச்சொல்லை உறுதிப்படுத்தவும்';
                      }
                      if (val != newPasswordController.text) {
                        return lang == 'en' ? 'Passwords do not match' : 'கடவுச்சொற்கள் பொருந்தவில்லை';
                      }
                      return null;
                    },
                  ),
                ],
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(
                lang == 'en' ? 'Cancel' : 'ரத்துசெய்',
                style: GoogleFonts.nunitoSans(color: KalyaThiruTheme.mutedGray),
              ),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: KalyaThiruTheme.primaryMaroon,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              onPressed: () {
                if (formKey.currentState!.validate()) {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        lang == 'en'
                            ? 'Password changed successfully.'
                            : 'கடவுச்சொல் வெற்றிகரமாக மாற்றப்பட்டது.',
                        style: GoogleFonts.nunitoSans(color: Colors.white),
                      ),
                      backgroundColor: KalyaThiruTheme.primaryMaroon,
                      behavior: SnackBarBehavior.floating,
                    ),
                  );
                }
              },
              child: Text(
                lang == 'en' ? 'Change' : 'மாற்றவும்',
                style: GoogleFonts.nunitoSans(color: Colors.white, fontWeight: FontWeight.bold),
              ),
            ),
          ],
        );
      },
    );
  }

  void _showLogoutDialog(String lang) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          surfaceTintColor: Colors.transparent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
            side: const BorderSide(color: KalyaThiruTheme.outlineBorder, width: 1),
          ),
          title: Text(
            lang == 'en' ? 'Logout' : 'வெளியேறு',
            style: GoogleFonts.sourceSerif4(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: KalyaThiruTheme.primaryMaroon,
            ),
          ),
          content: Text(
            lang == 'en'
                ? 'Are you sure you want to logout?'
                : 'நீங்கள் நிச்சயமாக வெளியேற வேண்டுமா?',
            style: GoogleFonts.nunitoSans(
              fontSize: 15,
              color: KalyaThiruTheme.darkCharcoal,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(
                lang == 'en' ? 'Cancel' : 'ரத்துசெய்',
                style: GoogleFonts.nunitoSans(color: KalyaThiruTheme.mutedGray),
              ),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: KalyaThiruTheme.primaryMaroon,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              onPressed: () async {
                final router = GoRouter.of(context);
                Navigator.pop(context);
                final prefs = await SharedPreferences.getInstance();
                await prefs.clear();
                router.go('/');
              },
              child: Text(
                lang == 'en' ? 'Logout' : 'வெளியேறு',
                style: GoogleFonts.nunitoSans(color: Colors.white, fontWeight: FontWeight.bold),
              ),
            ),
          ],
        );
      },
    );
  }

  void _showDeleteProfileDialog(String lang) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          surfaceTintColor: Colors.transparent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
            side: const BorderSide(color: Colors.redAccent, width: 1),
          ),
          title: Text(
            lang == 'en' ? 'Delete Profile' : 'சுயவிவரத்தை நீக்கவும்',
            style: GoogleFonts.sourceSerif4(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.red[800],
            ),
          ),
          content: Text(
            lang == 'en'
                ? 'Are you sure you want to delete your profile? This action is permanent and cannot be undone.'
                : 'உங்கள் சுயவிவரத்தை நீக்க வேண்டுமா? இந்த நடவடிக்கை நிரந்தரமானது மற்றும் மாற்ற முடியாது.',
            style: GoogleFonts.nunitoSans(
              fontSize: 15,
              color: KalyaThiruTheme.darkCharcoal,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(
                lang == 'en' ? 'Cancel' : 'ரத்துசெய்',
                style: GoogleFonts.nunitoSans(color: KalyaThiruTheme.mutedGray),
              ),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red[800],
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              onPressed: () async {
                final router = GoRouter.of(context);
                Navigator.pop(context);
                final prefs = await SharedPreferences.getInstance();
                await prefs.clear();
                router.go('/');
              },
              child: Text(
                lang == 'en' ? 'Delete' : 'நீக்கு',
                style: GoogleFonts.nunitoSans(color: Colors.white, fontWeight: FontWeight.bold),
              ),
            ),
          ],
        );
      },
    );
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
              lang == 'en' ? 'KalyaThiru' : 'கல்யாதிரு',
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
                lang == 'en' ? 'Settings' : 'அமைப்புகள்',
                style: GoogleFonts.sourceSerif4(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: KalyaThiruTheme.darkCharcoal,
                  height: 1.25,
                ),
              ),
              const SizedBox(height: 24),

              // Privacy Settings item
              _buildSettingOption(
                icon: Icons.lock,
                title: lang == 'en' ? 'Privacy Settings' : 'தனியுரிமை அமைப்புகள்',
                subtitle: lang == 'en'
                    ? 'Manage mobile, photo, and horoscope visibility'
                    : 'கைபேசி, புகைப்படம் மற்றும் ஜாதகத் தெரிவுநிலையை நிர்வகிக்கவும்',
                onTap: () => context.push('/settings/privacy'),
              ),
              const SizedBox(height: 12),

              // Notifications item
              _buildSettingOption(
                icon: Icons.notifications,
                title: lang == 'en' ? 'Notifications' : 'அறிவிப்புகள்',
                subtitle: lang == 'en'
                    ? 'Customize email, push, and match alerts'
                    : 'மின்னஞ்சல், புஷ் மற்றும் வரன் அறிவிப்புகளைத் தனிப்பயனாக்கவும்',
                onTap: () => context.push('/settings/notifications'),
              ),
              const SizedBox(height: 12),

              // Advanced Settings item
              _buildSettingOption(
                icon: Icons.settings_suggest,
                title: lang == 'en' ? 'Advanced Settings' : 'மேம்பட்ட அமைப்புகள்',
                subtitle: lang == 'en'
                    ? 'View blocked and hidden profiles'
                    : 'முடக்கப்பட்ட மற்றும் மறைக்கப்பட்ட சுயவிவரங்களைக் காண்க',
                onTap: () => context.push('/settings/advanced'),
              ),
              const SizedBox(height: 12),

              // Account Accordion card
              _buildAccountAccordion(lang),
            ],
          ),
        );
      },
    );
  }

  Widget _buildSettingOption({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: KalyaThiruTheme.outlineBorder.withValues(alpha: 0.1),
        ),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: KalyaThiruTheme.primaryMaroon.withValues(alpha: 0.05),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(icon, color: KalyaThiruTheme.primaryMaroon, size: 20),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: GoogleFonts.nunitoSans(
                          fontSize: 16,
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
                const Icon(
                  Icons.chevron_right,
                  color: KalyaThiruTheme.mutedGray,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildAccountAccordion(String lang) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: KalyaThiruTheme.outlineBorder.withValues(alpha: 0.1),
        ),
      ),
      child: Column(
        children: [
          Material(
            color: Colors.transparent,
            child: InkWell(
              borderRadius: BorderRadius.only(
                topLeft: const Radius.circular(12),
                topRight: const Radius.circular(12),
                bottomLeft: Radius.circular(_isAccountExpanded ? 0 : 12),
                bottomRight: Radius.circular(_isAccountExpanded ? 0 : 12),
              ),
              onTap: _toggleAccount,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: KalyaThiruTheme.primaryMaroon.withValues(alpha: 0.05),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Icon(Icons.account_circle,
                          color: KalyaThiruTheme.primaryMaroon, size: 20),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            lang == 'en' ? 'Account' : 'கணக்கு',
                            style: GoogleFonts.nunitoSans(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: KalyaThiruTheme.darkCharcoal,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            lang == 'en' ? 'Manage your credentials' : 'உங்கள் சான்றுகளை நிர்வகிக்கவும்',
                            style: GoogleFonts.nunitoSans(
                              fontSize: 12,
                              color: KalyaThiruTheme.mutedGray,
                            ),
                          ),
                        ],
                      ),
                    ),
                    AnimatedRotation(
                      turns: _isAccountExpanded ? 0.5 : 0.0,
                      duration: const Duration(milliseconds: 200),
                      child: const Icon(
                        Icons.expand_more,
                        color: KalyaThiruTheme.mutedGray,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          AnimatedCrossFade(
            firstChild: const SizedBox.shrink(),
            secondChild: Container(
              width: double.infinity,
              decoration: const BoxDecoration(
                border: Border(
                  top: BorderSide(
                    color: KalyaThiruTheme.outlineVariant,
                    width: 1.0,
                  ),
                ),
              ),
              padding: const EdgeInsets.all(8),
              child: Column(
                children: [
                  _buildSubMenuItem(
                    icon: Icons.lock_reset,
                    title: lang == 'en' ? 'Change Password' : 'கடவுச்சொல்லை மாற்றவும்',
                    subtitle: lang == 'en' ? 'Update your account password' : 'உங்கள் கணக்கு கடவுச்சொல்லைப் புதுப்பிக்கவும்',
                    onTap: () => _showChangePasswordDialog(lang),
                  ),
                  _buildSubMenuItem(
                    icon: Icons.logout,
                    title: lang == 'en' ? 'Logout' : 'வெளியேறு',
                    subtitle: lang == 'en' ? 'Sign out of your account' : 'உங்கள் கணக்கிலிருந்து வெளியேறவும்',
                    onTap: () => _showLogoutDialog(lang),
                  ),
                  _buildSubMenuItem(
                    icon: Icons.delete_forever,
                    title: lang == 'en' ? 'Delete Profile' : 'சுயவிவரத்தை நீக்கவும்',
                    subtitle: lang == 'en' ? 'Permanently delete your profile' : 'உங்கள் சுயவிவரத்தை நிரந்தரமாக நீக்கவும்',
                    isDanger: true,
                    onTap: () => _showDeleteProfileDialog(lang),
                  ),
                ],
              ),
            ),
            crossFadeState:
                _isAccountExpanded ? CrossFadeState.showSecond : CrossFadeState.showFirst,
            duration: const Duration(milliseconds: 250),
          ),
        ],
      ),
    );
  }

  Widget _buildSubMenuItem({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
    bool isDanger = false,
  }) {
    final Color textColor = isDanger ? Colors.red[800]! : KalyaThiruTheme.darkCharcoal;
    final Color iconColor = isDanger ? Colors.red[800]! : KalyaThiruTheme.primaryMaroon;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(8),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Row(
            children: [
              Icon(icon, color: iconColor, size: 20),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: GoogleFonts.nunitoSans(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: textColor,
                      ),
                    ),
                    const SizedBox(height: 1),
                    Text(
                      subtitle,
                      style: GoogleFonts.nunitoSans(
                        fontSize: 10,
                        color: isDanger ? Colors.red[300] : KalyaThiruTheme.mutedGray,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
