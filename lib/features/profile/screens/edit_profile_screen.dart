import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../onboarding/cubit/onboarding_cubit.dart';
import '../../../core/theme/theme.dart';
import '../../../core/translation/option_translations.dart';
import '../../../core/widgets/notched_text_field.dart';

class EditProfileScreen extends StatelessWidget {
  const EditProfileScreen({super.key});

  int _calculateCompleteness(OnboardingState state) {
    final fields = [
      state.firstName,
      state.dob,
      state.gender,
      state.motherTongue,
      state.religion,
      state.caste,
      state.nakshatra,
      state.gothram,
      state.raasi,
      state.employmentType,
      state.occupation,
      state.annualIncome,
      state.qualification,
      state.institution,
      state.country,
      state.state,
      state.city,
      state.familyValues,
      state.familyType,
      state.familyStatus,
      state.familyWealth,
      state.photoPath,
    ];

    int filled = fields.where((f) => f != null && f.toString().trim().isNotEmpty).length;
    if (state.selectedHobbies.isNotEmpty) {
      filled += 1;
    }

    final total = fields.length + 1; // 23 fields total
    return ((filled / total) * 100).toInt();
  }

  void _showPhotoSheet(BuildContext context, String lang) {
    final cubit = context.read<OnboardingCubit>();
    showModalBottomSheet(
      context: context,
      backgroundColor: KalyaThiruTheme.softIvory,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(Icons.photo_library, color: KalyaThiruTheme.primaryMaroon),
                title: Text(lang == 'ta' ? 'கேலரியில் இருந்து தேர்வு செய்யவும்' : 'Choose from Gallery'),
                onTap: () {
                  cubit.updateFields(photoPath: 'assets/avatar_placeholder.png'); // simulated upload
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(lang == 'ta' ? 'புகைப்படம் வெற்றிகரமாக மாற்றப்பட்டது!' : 'Photo updated successfully!'),
                      backgroundColor: KalyaThiruTheme.primaryMaroon,
                    ),
                  );
                },
              ),
              ListTile(
                leading: const Icon(Icons.camera_alt, color: KalyaThiruTheme.primaryMaroon),
                title: Text(lang == 'ta' ? 'கேமரா மூலம் படம் எடுக்கவும்' : 'Take a Photo'),
                onTap: () {
                  cubit.updateFields(photoPath: 'assets/avatar_placeholder.png'); // simulated upload
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(lang == 'ta' ? 'புகைப்படம் வெற்றிகரமாக மாற்றப்பட்டது!' : 'Photo updated successfully!'),
                      backgroundColor: KalyaThiruTheme.primaryMaroon,
                    ),
                  );
                },
              ),
              if (cubit.state.photoPath != null)
                ListTile(
                  leading: const Icon(Icons.delete, color: Colors.red),
                  title: Text(lang == 'ta' ? 'புகைப்படத்தை நீக்கவும்' : 'Remove Photo'),
                  onTap: () {
                    cubit.updateFields(photoPath: '');
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(lang == 'ta' ? 'புகைப்படம் நீக்கப்பட்டது!' : 'Photo removed successfully!'),
                        backgroundColor: KalyaThiruTheme.primaryMaroon,
                      ),
                    );
                  },
                ),
            ],
          ),
        );
      },
    );
  }

  void _showContactSheet(BuildContext context, OnboardingState state, String lang) {
    final mobileController = TextEditingController(text: state.mobileNumber ?? '');
    final whatsappController = TextEditingController(text: state.whatsappNumber ?? '');

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: KalyaThiruTheme.softIvory,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom + 20,
            left: 20,
            right: 20,
            top: 20,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                lang == 'ta' ? 'தொடர்பு விவரங்களைத் திருத்தவும்' : 'Edit Contact Info',
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      color: KalyaThiruTheme.primaryMaroon,
                      fontFamily: 'Source Serif 4',
                    ),
              ),
              const SizedBox(height: 20),
              NotchedTextField(
                labelText: lang == 'ta' ? 'கைபேசி எண்' : 'Mobile Number',
                controller: mobileController,
                keyboardType: TextInputType.phone,
              ),
              const SizedBox(height: 16),
              NotchedTextField(
                labelText: lang == 'ta' ? 'வாட்ஸ்அப் எண்' : 'WhatsApp Number',
                controller: whatsappController,
                keyboardType: TextInputType.phone,
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: KalyaThiruTheme.primaryMaroon,
                  foregroundColor: Colors.white,
                  minimumSize: const Size(double.infinity, 50),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
                onPressed: () {
                  context.read<OnboardingCubit>().updateFields(
                        mobileNumber: mobileController.text,
                        whatsappNumber: whatsappController.text,
                      );
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(lang == 'ta' ? 'தொடர்பு விவரங்கள் புதுப்பிக்கப்பட்டன!' : 'Contact details updated!'),
                      backgroundColor: KalyaThiruTheme.primaryMaroon,
                    ),
                  );
                },
                child: Text(lang == 'ta' ? 'சேமிக்கவும்' : 'Save Info'),
              ),
            ],
          ),
        );
      },
    );
  }

  void _showAddPhotosSheet(BuildContext context, String lang) {
    showModalBottomSheet(
      context: context,
      backgroundColor: KalyaThiruTheme.softIvory,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  lang == 'ta' ? 'கூடுதல் புகைப்படங்களைச் சேர்க்கவும்' : 'Add Multiple Photos',
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                        color: KalyaThiruTheme.primaryMaroon,
                        fontFamily: 'Source Serif 4',
                      ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 20),
                Container(
                  height: 150,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(color: KalyaThiruTheme.outlineBorder.withOpacity(0.3)),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.cloud_upload, size: 48, color: KalyaThiruTheme.primaryMaroon),
                        const SizedBox(height: 8),
                        Text(
                          lang == 'ta' ? 'புகைப்படங்களை இழுத்து விடவும் அல்லது பதிவேற்றவும்' : 'Drag & drop or upload photos',
                          style: const TextStyle(color: KalyaThiruTheme.mutedGray),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: KalyaThiruTheme.primaryMaroon,
                    minimumSize: const Size(double.infinity, 45),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
                  ),
                  onPressed: () {
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(lang == 'ta' ? 'புகைப்படங்கள் வெற்றிகரமாகச் சேர்க்கப்பட்டன!' : 'Photos added successfully!'),
                        backgroundColor: KalyaThiruTheme.primaryMaroon,
                      ),
                    );
                  },
                  child: Text(lang == 'ta' ? 'முடிந்தது' : 'Done'),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final state = context.watch<OnboardingCubit>().state;
    final lang = state.langCode;
    final completeness = _calculateCompleteness(state);

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
          lang == 'ta' ? 'சுயவிவரத்தைத் திருத்தவும்' : 'Edit Profile',
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
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Avatar and header block
            Card(
              color: Colors.white,
              elevation: 0.5,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(4),
                side: BorderSide(color: KalyaThiruTheme.outlineBorder.withOpacity(0.15)),
              ),
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  children: [
                    // Large square avatar (4px radius) with pencil icon overlay
                    Stack(
                      children: [
                        Container(
                          width: 120,
                          height: 120,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(4),
                            border: Border.all(color: KalyaThiruTheme.primaryMaroon, width: 2),
                            image: DecorationImage(
                              image: (state.photoPath != null && state.photoPath!.isNotEmpty)
                                  ? const AssetImage('assets/avatar_placeholder.png') as ImageProvider
                                  : const AssetImage('assets/avatar_placeholder.png'),
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        Positioned(
                          bottom: 0,
                          right: 0,
                          child: InkWell(
                            onTap: () => _showPhotoSheet(context, lang),
                            child: Container(
                              padding: const EdgeInsets.all(6),
                              decoration: const BoxDecoration(
                                color: KalyaThiruTheme.primaryMaroon,
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(Icons.camera_alt, color: Colors.white, size: 18),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Text(
                      '${state.firstName ?? "User"} ${state.lastName ?? ""}',
                      style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                            fontFamily: 'Source Serif 4',
                            color: KalyaThiruTheme.primaryMaroon,
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                    if (state.dob != null) ...[
                      const SizedBox(height: 4),
                      Text(
                        '${lang == 'ta' ? "பிறப்பு" : "DOB"}: ${state.dob}',
                        style: const TextStyle(color: KalyaThiruTheme.mutedGray),
                      ),
                    ],
                    const SizedBox(height: 16),
                    // Action Buttons (Add Photos & Edit Contact)
                    Row(
                      children: [
                        Expanded(
                          child: OutlinedButton.icon(
                            style: OutlinedButton.styleFrom(
                              foregroundColor: KalyaThiruTheme.primaryMaroon,
                              side: const BorderSide(color: KalyaThiruTheme.primaryMaroon),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
                              padding: const EdgeInsets.symmetric(vertical: 12),
                            ),
                            icon: const Icon(Icons.add_photo_alternate_outlined),
                            label: Text(lang == 'ta' ? 'புகைப்படம் சேர்' : 'Add Photos'),
                            onPressed: () => _showAddPhotosSheet(context, lang),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: ElevatedButton.icon(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: KalyaThiruTheme.primaryMaroon,
                              foregroundColor: Colors.white,
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
                              padding: const EdgeInsets.symmetric(vertical: 12),
                            ),
                            icon: const Icon(Icons.contact_phone_outlined),
                            label: Text(lang == 'ta' ? 'தொடர்பு எண்' : 'Edit Contact'),
                            onPressed: () => _showContactSheet(context, state, lang),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Profile Completeness Progress Header
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
                          lang == 'ta' ? 'சுயவிவரம் நிறைவுற்றது' : 'Profile Completeness',
                          style: const TextStyle(fontWeight: FontWeight.bold, color: KalyaThiruTheme.darkCharcoal),
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
                      lang == 'ta' ? 'சிறந்த பொருத்தங்களை பெற சுயவிவரத்தை முழுமையாக நிரப்பவும்' : 'Fill more details to receive highly matches.',
                      style: const TextStyle(fontSize: 12, color: KalyaThiruTheme.mutedGray),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Profile Sections List
            _buildSectionCard(
              context: context,
              title: lang == 'ta' ? 'தனிப்பட்ட விவரங்கள்' : 'Personal Info',
              sectionKey: 'personal',
              lang: lang,
              items: {
                lang == 'ta' ? 'உறவுமுறை' : 'Profile For': state.profileFor,
                lang == 'ta' ? 'பாலினம்' : 'Gender': state.gender,
                lang == 'ta' ? 'உயரம்' : 'Height': state.height,
                lang == 'ta' ? 'எடை' : 'Weight': state.weight,
                lang == 'ta' ? 'திருமண நிலை' : 'Marital Status': state.maritalStatus,
                lang == 'ta' ? 'தாய்மொழி' : 'Mother Tongue': state.motherTongue,
                lang == 'ta' ? 'உடல் நிலை' : 'Physical Status': state.physicalStatus,
                lang == 'ta' ? 'உடல்வாகு' : 'Body Type': state.bodyType,
                lang == 'ta' ? 'உணவு பழக்கம்' : 'Diet Preference': state.eatingHabits,
                lang == 'ta' ? 'மது பழக்கம்' : 'Drinking Habit': state.drinkingHabits,
                lang == 'ta' ? 'புகை பழக்கம்' : 'Smoking Habit': state.smokingHabits,
                lang == 'ta' ? 'சுய அறிமுகம்' : 'About Yourself': state.bio,
              },
            ),

            _buildSectionCard(
              context: context,
              title: lang == 'ta' ? 'சமய விவரங்கள்' : 'Religious Info',
              sectionKey: 'religion',
              lang: lang,
              items: {
                lang == 'ta' ? 'மதம்' : 'Religion': state.religion,
                lang == 'ta' ? 'ஜாதி' : 'Caste / Sect': state.caste,
                lang == 'ta' ? 'உட்பிரிவு' : 'Subcaste': state.subcaste,
                lang == 'ta' ? 'கோத்திரம்' : 'Gothram': state.gothram,
                lang == 'ta' ? 'ராசி' : 'Raasi': state.raasi,
                lang == 'ta' ? 'நட்சத்திரம்' : 'Star': state.nakshatra,
                lang == 'ta' ? 'தோஷம்' : 'Dosham': state.dosham,
              },
            ),

            _buildSectionCard(
              context: context,
              title: lang == 'ta' ? 'கல்வி விவரங்கள்' : 'Education Details',
              sectionKey: 'education',
              lang: lang,
              items: {
                lang == 'ta' ? 'கல்வி தகுதி' : 'Highest Qualification': state.qualification,
                if (state.qualification == 'Doctorate (Ph.D / Research)') ...{
                  lang == 'ta' ? 'ஆராய்ச்சிப் பிரிவு' : 'Specialization': state.doctorateSpecialization,
                  lang == 'ta' ? 'பல்கலைக்கழகம்' : 'University': state.doctorateUniversity,
                  lang == 'ta' ? 'தேர்ச்சி பெற்ற ஆண்டு' : 'Completed Year': state.doctorateYear,
                } else if (state.qualification == 'Post-Graduation (MA, MSc, MBA, ME, etc.)') ...{
                  lang == 'ta' ? 'பட்டம்' : 'Degree': state.pgDegree,
                  lang == 'ta' ? 'பிரிவு' : 'Specialization': state.pgSpecialization,
                  lang == 'ta' ? 'நிறுவனம்' : 'Institution': state.pgInstitution,
                  lang == 'ta' ? 'தேர்ச்சி பெற்ற ஆண்டு' : 'Completed Year': state.pgYear,
                } else if (state.qualification == 'Graduation / Bachelors (BA, BSc, BE, BTech, etc.)') ...{
                  lang == 'ta' ? 'பட்டம்' : 'Degree': state.ugDegree,
                  lang == 'ta' ? 'பாடம்' : 'Major': state.ugMajor,
                  lang == 'ta' ? 'நிறுவனம்' : 'Institution': state.ugInstitution,
                  lang == 'ta' ? 'தேர்ச்சி பெற்ற ஆண்டு' : 'Completed Year': state.ugYear,
                } else if (state.qualification == 'Diploma') ...{
                  lang == 'ta' ? 'பிரிவு' : 'Stream': state.diplomaStream,
                  lang == 'ta' ? 'நிறுவனம்' : 'Institution': state.diplomaInstitution,
                  lang == 'ta' ? 'தேர்ச்சி பெற்ற ஆண்டு' : 'Completed Year': state.diplomaYear,
                } else if (state.qualification == 'Schooling (HSC / SSLC)') ...{
                  lang == 'ta' ? 'பள்ளியின் பெயர்' : 'School Name': state.schoolingName,
                  lang == 'ta' ? 'கல்வி வாரியம்' : 'Board': state.schoolingBoard,
                  lang == 'ta' ? 'தேர்ச்சி பெற்ற ஆண்டு' : 'Completed Year': state.schoolingYear,
                },
              },
            ),

            _buildSectionCard(
              context: context,
              title: lang == 'ta' ? 'தொழில் விவரங்கள்' : 'Professional Info',
              sectionKey: 'professional',
              lang: lang,
              items: {
                lang == 'ta' ? 'வேலை வகை' : 'Employment Type': state.employmentType,
                lang == 'ta' ? 'தொழில்' : 'Occupation': state.occupation,
                lang == 'ta' ? 'தொழில் விவரம்' : 'Occupation Details': state.trait,
                lang == 'ta' ? 'நிறுவனத்தின் பெயர்' : 'Organization': state.institution,
                lang == 'ta' ? 'ஆண்டு வருமானம்' : 'Annual Income': state.annualIncome,
              },
            ),

            _buildSectionCard(
              context: context,
              title: lang == 'ta' ? 'இருப்பிட விவரங்கள்' : 'Location Info',
              sectionKey: 'location',
              lang: lang,
              items: {
                lang == 'ta' ? 'குடியுரிமை' : 'Citizenship': state.citizenship,
                lang == 'ta' ? 'நாடு' : 'Country': state.country,
                lang == 'ta' ? 'மாநிலம்' : 'State': state.state,
                lang == 'ta' ? 'நகரம்' : 'City': state.city,
                lang == 'ta' ? 'பரம்பரை இருப்பிடம்' : 'Ancestral Origin': state.ancestralOrigin,
              },
            ),

            _buildSectionCard(
              context: context,
              title: lang == 'ta' ? 'குடும்ப விவரங்கள்' : 'Family Details',
              sectionKey: 'family',
              lang: lang,
              items: {
                lang == 'ta' ? 'குடும்ப விழுமியங்கள்' : 'Family Values': state.familyValues,
                lang == 'ta' ? 'குடும்ப வகை' : 'Family Type': state.familyType,
                lang == 'ta' ? 'குடும்ப நிலை' : 'Family Status': state.familyStatus,
                lang == 'ta' ? 'குடும்ப சொத்து விவரம்' : 'Family Wealth': state.familyWealth,
                lang == 'ta' ? 'பெற்றோர் விவரம் / தொழில்' : 'Parents Info': state.parentsInfo,
                lang == 'ta' ? 'சகோதரர்கள்' : 'Brothers': (state.brothers != null && state.brothers != '0')
                    ? '${state.brothers} (${lang == 'ta' ? "திருமணமானவர்" : "married"}: ${state.brothersMarried ?? "0"})'
                    : state.brothers,
                lang == 'ta' ? 'சகோதரிகள்' : 'Sisters': (state.sisters != null && state.sisters != '0')
                    ? '${state.sisters} (${lang == 'ta' ? "திருமணமானவர்" : "married"}: ${state.sistersMarried ?? "0"})'
                    : state.sisters,
              },
            ),

            _buildHobbiesCard(
              context: context,
              title: lang == 'ta' ? 'சுய விருப்பங்கள் & பொழுதுபோக்கு' : 'Hobbies & Interests',
              lang: lang,
              hobbies: state.selectedHobbies,
              subInterests: state.selectedSubInterests,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionCard({
    required BuildContext context,
    required String title,
    required String sectionKey,
    required String lang,
    required Map<String, String?> items,
  }) {
    // Filter out null or empty values from items for a cleaner display
    final displayedItems = items.entries.where((e) => e.value != null && e.value!.trim().isNotEmpty).toList();

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
          // Header of the card with maroon left accent
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
                Text(
                  title,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontFamily: 'Source Serif 4',
                        fontWeight: FontWeight.bold,
                        color: KalyaThiruTheme.primaryMaroon,
                      ),
                ),
                IconButton(
                  icon: const Icon(Icons.edit, color: KalyaThiruTheme.primaryMaroon, size: 20),
                  onPressed: () {
                    context.push('/edit_profile/section?section=$sectionKey');
                  },
                ),
              ],
            ),
          ),
          const Divider(height: 1, color: KalyaThiruTheme.outlineVariant),
          // Content body
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: displayedItems.isEmpty
                ? Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: Text(
                      lang == 'ta' ? 'தகவல் ஏதுமில்லை. சேர்க்க தட்டவும்.' : 'No details added yet. Tap edit to add.',
                      style: const TextStyle(color: KalyaThiruTheme.mutedGray, fontStyle: FontStyle.italic),
                    ),
                  )
                : Column(
                    children: displayedItems.map((entry) {
                      final translatedVal = translateOption(entry.value, lang);
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 6.0),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              flex: 4,
                              child: Text(
                                entry.key,
                                style: const TextStyle(
                                  fontWeight: FontWeight.w600,
                                  color: KalyaThiruTheme.mutedGray,
                                  fontSize: 13,
                                ),
                              ),
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              flex: 6,
                              child: Text(
                                translatedVal,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: KalyaThiruTheme.darkCharcoal,
                                  fontSize: 14,
                                ),
                              ),
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

  Widget _buildHobbiesCard({
    required BuildContext context,
    required String title,
    required String lang,
    required List<String> hobbies,
    required Map<String, List<String>> subInterests,
  }) {
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
                Text(
                  title,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontFamily: 'Source Serif 4',
                        fontWeight: FontWeight.bold,
                        color: KalyaThiruTheme.primaryMaroon,
                      ),
                ),
                IconButton(
                  icon: const Icon(Icons.edit, color: KalyaThiruTheme.primaryMaroon, size: 20),
                  onPressed: () {
                    context.push('/edit_profile/section?section=hobbies');
                  },
                ),
              ],
            ),
          ),
          const Divider(height: 1, color: KalyaThiruTheme.outlineVariant),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: hobbies.isEmpty
                ? Text(
                    lang == 'ta' ? 'தகவல் ஏதுமில்லை. சேர்க்க தட்டவும்.' : 'No details added yet. Tap edit to add.',
                    style: const TextStyle(color: KalyaThiruTheme.mutedGray, fontStyle: FontStyle.italic),
                  )
                : Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: hobbies.map((hobby) {
                      final displayTitle = translateOption(hobby, lang);
                      final genres = subInterests[hobby] ?? [];
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              displayTitle,
                              style: const TextStyle(fontWeight: FontWeight.bold, color: KalyaThiruTheme.darkCharcoal),
                            ),
                            if (genres.isNotEmpty) ...[
                              const SizedBox(height: 6),
                              Wrap(
                                spacing: 6,
                                runSpacing: 4,
                                children: genres.map((genre) {
                                  return Chip(
                                    label: Text(
                                      translateOption(genre, lang),
                                      style: const TextStyle(fontSize: 11, color: KalyaThiruTheme.primaryMaroon),
                                    ),
                                    backgroundColor: KalyaThiruTheme.softIvory,
                                    padding: EdgeInsets.zero,
                                    materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                  );
                                }).toList(),
                              ),
                            ],
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
}
