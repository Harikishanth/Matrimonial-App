import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../core/theme/theme.dart';
import '../../onboarding/cubit/onboarding_cubit.dart';

class PrivacySettingsScreen extends StatefulWidget {
  const PrivacySettingsScreen({super.key});

  @override
  State<PrivacySettingsScreen> createState() => _PrivacySettingsScreenState();
}

class _PrivacySettingsScreenState extends State<PrivacySettingsScreen> {
  String _activeTab = 'mobile'; // 'mobile', 'photo', 'horoscope'

  // Options State
  String _mobilePrivacy = 'premium_call_directly';
  String _photoPrivacy = 'premium_only';
  String _horoscopePrivacy = 'premium_download_view';

  bool _isLoading = true;
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    _loadPrivacySettings();
  }

  Future<void> _loadPrivacySettings() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _mobilePrivacy = prefs.getString('privacy_mobile_settings') ?? 'premium_call_directly';
      _photoPrivacy = prefs.getString('privacy_photo_settings') ?? 'premium_only';
      _horoscopePrivacy = prefs.getString('privacy_horoscope_settings') ?? 'premium_download_view';
      _isLoading = false;
    });
  }

  Future<void> _savePrivacySettings(String lang) async {
    setState(() {
      _isSaving = true;
    });

    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('privacy_mobile_settings', _mobilePrivacy);
    await prefs.setString('privacy_photo_settings', _photoPrivacy);
    await prefs.setString('privacy_horoscope_settings', _horoscopePrivacy);

    // Simulate network latency for saving state to look premium
    await Future.delayed(const Duration(milliseconds: 400));

    if (mounted) {
      setState(() {
        _isSaving = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              const Icon(Icons.check_circle, color: Colors.greenAccent, size: 20),
              const SizedBox(width: 8),
              Text(
                lang == 'en' ? 'Settings updated successfully' : 'அமைப்புகள் வெற்றிகரமாக புதுப்பிக்கப்பட்டன',
                style: GoogleFonts.nunitoSans(fontSize: 14, color: Colors.white),
              ),
            ],
          ),
          backgroundColor: KalyaThiruTheme.darkCharcoal,
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
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
              lang == 'en' ? 'Privacy Settings' : 'தனியுரிமை அமைப்புகள்',
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
              : Column(
                  children: [
                    // Tab Bar
                    Container(
                      color: KalyaThiruTheme.softIvory,
                      child: Row(
                        children: [
                          _buildTabButton(
                            id: 'mobile',
                            labelEn: 'Mobile',
                            labelTa: 'கைபேசி',
                            lang: lang,
                          ),
                          _buildTabButton(
                            id: 'photo',
                            labelEn: 'Photo',
                            labelTa: 'புகைப்படம்',
                            lang: lang,
                          ),
                          _buildTabButton(
                            id: 'horoscope',
                            labelEn: 'Horoscope',
                            labelTa: 'ஜாதகம்',
                            lang: lang,
                          ),
                        ],
                      ),
                    ),
                    const Divider(height: 1, color: KalyaThiruTheme.outlineVariant),
                    Expanded(
                      child: ListView(
                        padding: const EdgeInsets.all(16),
                        children: [
                          // Tab Content Card
                          AnimatedSwitcher(
                            duration: const Duration(milliseconds: 200),
                            child: _buildActiveTabContent(lang),
                          ),
                          const SizedBox(height: 24),

                          // Trust Card
                          _buildTrustCard(lang),
                          const SizedBox(height: 24),
                        ],
                      ),
                    ),
                  ],
                ),
          bottomNavigationBar: SafeArea(
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: const BoxDecoration(
                color: Colors.white,
                border: Border(
                  top: BorderSide(color: KalyaThiruTheme.outlineVariant, width: 1),
                ),
              ),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: KalyaThiruTheme.primaryMaroon,
                  minimumSize: const Size(double.infinity, 50),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(4), // strictly 4px radius as per rules
                  ),
                ),
                onPressed: _isSaving ? null : () => _savePrivacySettings(lang),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    if (_isSaving)
                      const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          color: Colors.white,
                          strokeWidth: 2,
                        ),
                      )
                    else ...[
                      const Icon(Icons.save, color: Colors.white),
                      const SizedBox(width: 8),
                      Text(
                        lang == 'en' ? 'Save Settings' : 'அமைப்புகளைச் சேமிக்கவும்',
                        style: GoogleFonts.sourceSerif4(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildTabButton({
    required String id,
    required String labelEn,
    required String labelTa,
    required String lang,
  }) {
    final bool isActive = _activeTab == id;
    return Expanded(
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {
            setState(() {
              _activeTab = id;
            });
          },
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 16),
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(
                  color: isActive ? KalyaThiruTheme.primaryMaroon : Colors.transparent,
                  width: 3.0,
                ),
              ),
            ),
            child: Text(
              lang == 'en' ? labelEn : labelTa,
              textAlign: TextAlign.center,
              style: GoogleFonts.nunitoSans(
                fontSize: 14,
                fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
                color: isActive ? KalyaThiruTheme.primaryMaroon : KalyaThiruTheme.mutedGray,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildActiveTabContent(String lang) {
    switch (_activeTab) {
      case 'mobile':
        return _buildMobileContent(lang);
      case 'photo':
        return _buildPhotoContent(lang);
      case 'horoscope':
        return _buildHoroscopeContent(lang);
      default:
        return const SizedBox.shrink();
    }
  }

  Widget _buildMobileContent(String lang) {
    return Container(
      key: const ValueKey('mobile_content'),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: KalyaThiruTheme.outlineBorder.withValues(alpha: 0.1),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.phone_android, color: KalyaThiruTheme.primaryMaroon),
              const SizedBox(width: 8),
              Text(
                lang == 'en' ? 'Phone Number Privacy' : 'கைபேசி எண் தனியுரிமை',
                style: GoogleFonts.sourceSerif4(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: KalyaThiruTheme.primaryMaroon,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          _buildRadioOption(
            value: 'premium_call_directly',
            groupValue: _mobilePrivacy,
            titleEn: 'Premium members can view and call directly',
            titleTa: 'பிரீமியம் உறுப்பினர்கள் பார்க்கலாம் மற்றும் நேரடியாக அழைக்கலாம்',
            lang: lang,
            onChanged: (val) => setState(() => _mobilePrivacy = val!),
          ),
          const SizedBox(height: 12),
          _buildRadioOption(
            value: 'premium_view_only',
            groupValue: _mobilePrivacy,
            titleEn: 'Premium members can view but cannot call',
            titleTa: 'பிரீமியம் உறுப்பினர்கள் பார்க்கலாம் ஆனால் நேரடியாக அழைக்க முடியாது',
            lang: lang,
            onChanged: (val) => setState(() => _mobilePrivacy = val!),
          ),
          const SizedBox(height: 12),
          _buildRadioOption(
            value: 'visible_all',
            groupValue: _mobilePrivacy,
            titleEn: 'Visible to all members (Standard)',
            titleTa: 'அனைத்து உறுப்பினர்களுக்கும் தெரியும்',
            lang: lang,
            onChanged: (val) => setState(() => _mobilePrivacy = val!),
          ),
          const SizedBox(height: 12),
          _buildRadioOption(
            value: 'hide_free',
            groupValue: _mobilePrivacy,
            titleEn: 'Hide from free members',
            titleTa: 'இலவச உறுப்பினர்களிடமிருந்து மறைக்கவும்',
            lang: lang,
            onChanged: (val) => setState(() => _mobilePrivacy = val!),
          ),
        ],
      ),
    );
  }

  Widget _buildPhotoContent(String lang) {
    return Container(
      key: const ValueKey('photo_content'),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: KalyaThiruTheme.outlineBorder.withValues(alpha: 0.1),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.photo_camera, color: KalyaThiruTheme.primaryMaroon),
              const SizedBox(width: 8),
              Text(
                lang == 'en' ? 'Photo Visibility' : 'புகைப்படத் தெரிவுநிலை',
                style: GoogleFonts.sourceSerif4(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: KalyaThiruTheme.primaryMaroon,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          _buildRadioOption(
            value: 'premium_only',
            groupValue: _photoPrivacy,
            titleEn: 'Visible to Premium members only',
            titleTa: 'பிரீமியம் உறுப்பினர்களுக்கு மட்டும் தெரியும்',
            lang: lang,
            onChanged: (val) => setState(() => _photoPrivacy = val!),
          ),
          const SizedBox(height: 12),
          _buildRadioOption(
            value: 'visible_all',
            groupValue: _photoPrivacy,
            titleEn: 'Visible to all (Standard)',
            titleTa: 'அனைவருக்கும் தெரியும்',
            lang: lang,
            onChanged: (val) => setState(() => _photoPrivacy = val!),
          ),
          const SizedBox(height: 12),
          _buildRadioOption(
            value: 'hide_unliked',
            groupValue: _photoPrivacy,
            titleEn: 'Hide from profiles I have not liked',
            titleTa: 'நான் விரும்பாத சுயவிவரங்களிலிருந்து மறைக்கவும்',
            lang: lang,
            onChanged: (val) => setState(() => _photoPrivacy = val!),
          ),
        ],
      ),
    );
  }

  Widget _buildHoroscopeContent(String lang) {
    return Container(
      key: const ValueKey('horoscope_content'),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: KalyaThiruTheme.outlineBorder.withValues(alpha: 0.1),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.auto_stories, color: KalyaThiruTheme.primaryMaroon),
              const SizedBox(width: 8),
              Text(
                lang == 'en' ? 'Horoscope Access' : 'ஜாதக அணுகல்',
                style: GoogleFonts.sourceSerif4(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: KalyaThiruTheme.primaryMaroon,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          _buildRadioOption(
            value: 'premium_download_view',
            groupValue: _horoscopePrivacy,
            titleEn: 'Premium members can download and view',
            titleTa: 'பிரீமியம் உறுப்பினர்கள் பதிவிறக்கம் செய்து பார்க்கலாம்',
            lang: lang,
            onChanged: (val) => setState(() => _horoscopePrivacy = val!),
          ),
          const SizedBox(height: 12),
          _buildRadioOption(
            value: 'premium_online_only',
            groupValue: _horoscopePrivacy,
            titleEn: 'Premium members can view online only',
            titleTa: 'பிரீமியம் உறுப்பினர்கள் ஆன்லைனில் மட்டுமே பார்க்க முடியும்',
            lang: lang,
            onChanged: (val) => setState(() => _horoscopePrivacy = val!),
          ),
          const SizedBox(height: 12),
          _buildRadioOption(
            value: 'visible_all_verified',
            groupValue: _horoscopePrivacy,
            titleEn: 'Visible to all verified members',
            titleTa: 'அனைத்து சரிபார்க்கப்பட்ட உறுப்பினர்களுக்கும் தெரியும்',
            lang: lang,
            onChanged: (val) => setState(() => _horoscopePrivacy = val!),
          ),
        ],
      ),
    );
  }

  Widget _buildRadioOption({
    required String value,
    required String groupValue,
    required String titleEn,
    required String titleTa,
    required String lang,
    required ValueChanged<String?> onChanged,
  }) {
    final bool isSelected = value == groupValue;
    return GestureDetector(
      onTap: () => onChanged(value),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: isSelected ? KalyaThiruTheme.primaryMaroon.withValues(alpha: 0.02) : Colors.transparent,
          border: Border.all(
            color: isSelected ? KalyaThiruTheme.primaryMaroon : KalyaThiruTheme.outlineVariant,
            width: 1.0,
          ),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              margin: const EdgeInsets.only(top: 2),
              width: 18,
              height: 18,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: isSelected ? KalyaThiruTheme.primaryMaroon : KalyaThiruTheme.mutedGray,
                  width: 2.0,
                ),
              ),
              child: isSelected
                  ? Center(
                      child: Container(
                        width: 10,
                        height: 10,
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: KalyaThiruTheme.primaryMaroon,
                        ),
                      ),
                    )
                  : null,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                lang == 'en' ? titleEn : titleTa,
                style: GoogleFonts.nunitoSans(
                  fontSize: 14,
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                  color: KalyaThiruTheme.darkCharcoal,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTrustCard(String lang) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFFED65B).withValues(alpha: 0.08), // secondary-fixed color with opacity
        border: Border.all(
          color: const Color(0xFF735c00).withValues(alpha: 0.15),
        ),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(
            Icons.verified_user,
            color: Color(0xFF735c00), // secondary color
            size: 24,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  lang == 'en' ? 'Matrimonial Trust Seal' : 'திருமண பாதுகாப்பு முத்திரை',
                  style: GoogleFonts.nunitoSans(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: KalyaThiruTheme.primaryMaroon,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  lang == 'en'
                      ? 'Privacy settings are audited every 30 days to ensure your data remains secure and follows community standards.'
                      : 'உங்களின் தரவு பாதுகாப்பாக இருப்பதை உறுதி செய்யவும் மற்றும் சமூக தரநிலைகளை பின்பற்றவும் தனியுரிமை அமைப்புகள் ஒவ்வொரு 30 நாட்களுக்கு ஒருமுறை தணிக்கை செய்யப்படுகின்றன.',
                  style: GoogleFonts.nunitoSans(
                    fontSize: 12,
                    color: KalyaThiruTheme.darkCharcoal.withValues(alpha: 0.8),
                    height: 1.4,
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
