import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../onboarding/cubit/onboarding_cubit.dart';
import '../../../core/theme/theme.dart';
import '../../../core/translation/option_translations.dart';

class EditPartnerPreferenceScreen extends StatelessWidget {
  const EditPartnerPreferenceScreen({super.key});

  int _calculatePreferenceCompleteness(OnboardingState state) {
    int totalFields = 13;
    int filledFields = 0;

    if (state.preferredReligion != null) filledFields++;
    if (state.preferredCastes.isNotEmpty) filledFields++;
    if (state.preferredQualifications.isNotEmpty) filledFields++;
    if (state.preferredOccupations.isNotEmpty) filledFields++;
    if (state.preferredMinIncome != null) filledFields++;
    if (state.preferredMaxIncome != null) filledFields++;
    if (state.preferredEmploymentTypes.isNotEmpty) filledFields++;
    if (state.preferredEatingHabits.isNotEmpty) filledFields++;
    if (state.preferredSmokingHabits.isNotEmpty) filledFields++;
    if (state.preferredDrinkingHabits.isNotEmpty) filledFields++;
    if (state.preferredMaritalStatuses.isNotEmpty) filledFields++;
    if (state.preferredCountries.isNotEmpty) filledFields++;
    if (state.preferredMotherTongues.isNotEmpty) filledFields++;

    return ((filledFields / totalFields) * 100).round();
  }

  @override
  Widget build(BuildContext context) {
    final state = context.watch<OnboardingCubit>().state;
    final lang = state.langCode;
    final completeness = _calculatePreferenceCompleteness(state);

    return Scaffold(
      backgroundColor: KalyaThiruTheme.softIvory,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.5,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: KalyaThiruTheme.primaryMaroon),
          onPressed: () => context.pop(),
        ),
        title: Text(
          lang == 'ta' ? 'வாழ்க்கைத்துணை விருப்பங்கள்' : 'Partner Preferences',
          style: const TextStyle(
            color: KalyaThiruTheme.primaryMaroon,
            fontFamily: 'Source Serif 4',
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          // Language toggle
          TextButton.icon(
            onPressed: () => context.read<OnboardingCubit>().toggleLanguage(),
            icon: const Icon(Icons.language, color: KalyaThiruTheme.primaryMaroon, size: 18),
            label: Text(
              lang == 'en' ? 'தமிழ்' : 'English',
              style: const TextStyle(
                color: KalyaThiruTheme.primaryMaroon,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Preference Match Strength header
            Card(
              color: Colors.white,
              elevation: 0.5,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(4),
                side: BorderSide(color: KalyaThiruTheme.outlineBorder.withOpacity(0.15)),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          lang == 'ta' ? 'விருப்பத் தரம்' : 'Preference Match Strength',
                          style: const TextStyle(
                            fontWeight: FontWeight.bold, 
                            color: KalyaThiruTheme.darkCharcoal,
                            fontFamily: 'Nunito Sans',
                          ),
                        ),
                        Text(
                          '$completeness%',
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            color: KalyaThiruTheme.primaryMaroon,
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    LinearProgressIndicator(
                      value: completeness / 100.0,
                      backgroundColor: KalyaThiruTheme.outlineVariant,
                      color: KalyaThiruTheme.primaryMaroon,
                      minHeight: 6,
                      borderRadius: BorderRadius.circular(3),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      lang == 'ta' 
                          ? 'விருப்பங்களைச் சரியாகத் தேர்ந்தெடுப்பது பொருத்தமான வரன்களைக் கண்டறிய உதவும்.' 
                          : 'Defining more preferences yields highly relevant and matching profiles.',
                      style: const TextStyle(fontSize: 12, color: KalyaThiruTheme.mutedGray),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Card 1: Basic Demographics
            _buildPreferenceSectionCard(
              context: context,
              title: lang == 'ta' ? 'அடிப்படை வரன் தேவைகள்' : 'Basic Demographics',
              sectionKey: 'basic',
              lang: lang,
              compulsoryFields: state.preferredCompulsoryFields,
              details: {
                lang == 'ta' ? 'வயது வரம்பு' : 'Age Range': 
                    lang == 'ta'
                        ? '${state.preferredMinAge} - ${state.preferredMaxAge} ஆண்டுகள்'
                        : '${state.preferredMinAge} - ${state.preferredMaxAge} Yrs',
                lang == 'ta' ? 'உயரம் வரம்பு' : 'Height Range': 
                    lang == 'ta'
                        ? '${state.preferredMinHeight.toStringAsFixed(1)}அடி - ${state.preferredMaxHeight.toStringAsFixed(1)}அடி'
                        : '${state.preferredMinHeight.toStringAsFixed(1)}ft - ${state.preferredMaxHeight.toStringAsFixed(1)}ft',
                lang == 'ta' ? 'திருமணம் நிலை' : 'Marital Status': 
                    state.preferredMaritalStatuses,
              },
            ),

            // Card 2: Religious & Astro
            _buildPreferenceSectionCard(
              context: context,
              title: lang == 'ta' ? 'சமயம் & ஜாதக விருப்பங்கள்' : 'Religious & Astro Details',
              sectionKey: 'religion',
              lang: lang,
              compulsoryFields: state.preferredCompulsoryFields,
              details: {
                lang == 'ta' ? 'மதம்' : 'Religion': state.preferredReligion,
                lang == 'ta' ? 'சாதி' : 'Caste': state.preferredCastes.isEmpty
                    ? (state.preferredCasteNoBar ? (lang == 'ta' ? 'தடையில்லை' : 'Caste No Bar') : null)
                    : state.preferredCastes,
                lang == 'ta' ? 'உட்பிரிவு' : 'Subcaste': state.preferredSubcaste,
                if (state.preferredReligion == 'Hindu') ...{
                  lang == 'ta' ? 'கோத்திரம்' : 'Gothram': state.preferredGothram,
                  lang == 'ta' ? 'ராசி' : 'Raasi': state.preferredRaasi,
                  lang == 'ta' ? 'நட்சத்திரம்' : 'Star': state.preferredStar,
                  lang == 'ta' ? 'தோஷம்' : 'Dosham': state.preferredDosham,
                }
              },
            ),

            // Card 3: Education
            _buildPreferenceSectionCard(
              context: context,
              title: lang == 'ta' ? 'கல்வித் தகுதிகள்' : 'Education Details',
              sectionKey: 'education',
              lang: lang,
              compulsoryFields: state.preferredCompulsoryFields,
              details: {
                lang == 'ta' ? 'கல்வித் தகுதி' : 'Qualifications': state.preferredQualifications,
              },
            ),

            // Card 4: Professional
            _buildPreferenceSectionCard(
              context: context,
              title: lang == 'ta' ? 'தொழில் & வருமானம்' : 'Professional Details',
              sectionKey: 'professional',
              lang: lang,
              compulsoryFields: state.preferredCompulsoryFields,
              details: {
                lang == 'ta' ? 'பணி வகை' : 'Employment Type': state.preferredEmploymentTypes,
                lang == 'ta' ? 'தொழில்' : 'Occupations': state.preferredOccupations,
                lang == 'ta' ? 'குறைந்தபட்ச வருமானம்' : 'Min Annual Income': state.preferredMinIncome,
                lang == 'ta' ? 'அதிகபட்ச வருமானம்' : 'Max Annual Income': state.preferredMaxIncome,
              },
            ),

            // Card 5: Lifestyle
            _buildPreferenceSectionCard(
              context: context,
              title: lang == 'ta' ? 'வாழ்க்கை முறை விருப்பங்கள்' : 'Lifestyle Details',
              sectionKey: 'lifestyle',
              lang: lang,
              compulsoryFields: state.preferredCompulsoryFields,
              details: {
                lang == 'ta' ? 'உணவுப் பழக்கம்' : 'Eating Habits': state.preferredEatingHabits,
                lang == 'ta' ? 'புகைபிடித்தல்' : 'Smoking': state.preferredSmokingHabits,
                lang == 'ta' ? 'மது அருந்துதல்' : 'Drinking': state.preferredDrinkingHabits,
                lang == 'ta' ? 'உடல் நிலை' : 'Physical Status': state.preferredPhysicalStatuses,
              },
            ),

            // Card 6: Location
            _buildPreferenceSectionCard(
              context: context,
              title: lang == 'ta' ? 'இருப்பிடம்' : 'Location Details',
              sectionKey: 'location',
              lang: lang,
              compulsoryFields: state.preferredCompulsoryFields,
              details: {
                lang == 'ta' ? 'நாடு' : 'Countries': state.preferredCountries,
                lang == 'ta' ? 'மாநிலம்' : 'States': state.preferredStates,
                lang == 'ta' ? 'நகரம்' : 'Cities': state.preferredCities,
              },
            ),

            // Card 7: Mother Tongue
            _buildPreferenceSectionCard(
              context: context,
              title: lang == 'ta' ? 'தாய்மொழி' : 'Mother Tongue Details',
              sectionKey: 'mother_tongue',
              lang: lang,
              compulsoryFields: state.preferredCompulsoryFields,
              details: {
                lang == 'ta' ? 'தாய்மொழி' : 'Mother Tongues': state.preferredMotherTongues,
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPreferenceSectionCard({
    required BuildContext context,
    required String title,
    required String sectionKey,
    required String lang,
    required List<String> compulsoryFields,
    required Map<String, dynamic> details,
  }) {
    final isCompulsory = compulsoryFields.contains(sectionKey);

    // Filter out entries that have empty lists, null strings, or empty strings
    final validEntries = details.entries.where((e) {
      final val = e.value;
      if (val == null) return false;
      if (val is String && val.trim().isEmpty) return false;
      if (val is List && val.isEmpty) return false;
      return true;
    }).toList();

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(4),
        border: Border.all(
          color: KalyaThiruTheme.outlineBorder.withOpacity(0.15),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Header
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: const BoxDecoration(
              border: Border(
                left: BorderSide(color: KalyaThiruTheme.primaryMaroon, width: 4),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Text(
                      title,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontFamily: 'Source Serif 4',
                            fontWeight: FontWeight.bold,
                            color: KalyaThiruTheme.primaryMaroon,
                          ),
                    ),
                    if (isCompulsory) ...[
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(
                          color: KalyaThiruTheme.antiqueGold.withValues(alpha: 0.15),
                          borderRadius: BorderRadius.circular(2),
                          border: Border.all(color: KalyaThiruTheme.antiqueGold, width: 0.5),
                        ),
                        child: Text(
                          lang == 'ta' ? 'கட்டாயம்' : 'Compulsory',
                          style: const TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                            color: KalyaThiruTheme.antiqueGold,
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
                IconButton(
                  icon: const Icon(Icons.edit, color: KalyaThiruTheme.primaryMaroon, size: 20),
                  onPressed: () {
                    context.push('/edit_partner_preference/section?section=$sectionKey');
                  },
                ),
              ],
            ),
          ),
          const Divider(height: 1, color: KalyaThiruTheme.outlineVariant),
          
          // Body
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: validEntries.isEmpty
                ? Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: Text(
                      lang == 'ta' ? 'விருப்பங்கள் ஏதுமில்லை. திருத்த ஐகானை அழுத்தவும்.' : 'No preferences set. Tap edit to configure.',
                      style: const TextStyle(color: KalyaThiruTheme.mutedGray, fontStyle: FontStyle.italic),
                    ),
                  )
                : Column(
                    children: validEntries.map((entry) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 6.0),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              flex: 4,
                              child: Padding(
                                padding: const EdgeInsets.only(top: 4.0),
                                child: Text(
                                  entry.key,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w600,
                                    color: KalyaThiruTheme.mutedGray,
                                    fontSize: 13,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              flex: 7,
                              child: _buildPreferenceValues(entry.value, lang),
                            ),
                          ],
                        ),
                      );
                    }).toList(),
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildPreferenceValues(dynamic value, String lang) {
    if (value is List) {
      return Wrap(
        spacing: 6,
        runSpacing: 6,
        children: value.map((val) {
          final translated = translateOption(val.toString(), lang);
          return Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: KalyaThiruTheme.primaryMaroon.withOpacity(0.08),
              borderRadius: BorderRadius.circular(100),
              border: Border.all(
                color: KalyaThiruTheme.primaryMaroon.withOpacity(0.15),
                width: 0.5,
              ),
            ),
            child: Text(
              translated,
              style: const TextStyle(
                color: KalyaThiruTheme.primaryMaroon,
                fontSize: 11,
                fontWeight: FontWeight.bold,
              ),
            ),
          );
        }).toList(),
      );
    } else {
      final translated = translateOption(value.toString(), lang);
      return Wrap(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: KalyaThiruTheme.antiqueGold.withValues(alpha: 0.08),
              borderRadius: BorderRadius.circular(100),
              border: Border.all(
                color: KalyaThiruTheme.antiqueGold.withValues(alpha: 0.2),
                width: 0.5,
              ),
            ),
            child: Text(
              translated,
              style: const TextStyle(
                color: KalyaThiruTheme.antiqueGold,
                fontSize: 11,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      );
    }
  }
}
