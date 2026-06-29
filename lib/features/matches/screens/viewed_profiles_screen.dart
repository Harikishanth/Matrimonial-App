import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/theme.dart';
import '../../../core/translation/option_translations.dart';
import '../../onboarding/cubit/onboarding_cubit.dart';
import '../../profile/models/profile_model.dart';

class ViewedProfilesScreen extends StatefulWidget {
  final bool isPaidMember;
  final String sectionTitle;
  final List<ProfileModel>? initialProfiles;

  const ViewedProfilesScreen({
    super.key,
    this.isPaidMember = false,
    required this.sectionTitle,
    this.initialProfiles,
  });

  @override
  State<ViewedProfilesScreen> createState() => _ViewedProfilesScreenState();
}

class _ViewedProfilesScreenState extends State<ViewedProfilesScreen> {
  String? _activeSubTab; // Starts as null (no sub-tab selected by default)
  late List<ProfileModel> _allProfiles;
  late List<ProfileModel> _visibleProfiles;
  final Set<String> _connectedProfileIds = {};

  // ── Filters State variables ──
  double _filterMinAge = 18;
  double _filterMaxAge = 60;
  double _filterMinHeight = 4.0;
  double _filterMaxHeight = 7.0;
  String _filterCreatedBy = 'All';
  String _filterMaritalStatus = 'Any';
  String _filterMotherTongue = "Doesn't Matter";
  String _filterPhysicalStatus = "Doesn't Matter";
  String _filterReligion = 'All';
  String _filterCasteText = '';
  bool _filterCasteNoBar = false;
  bool _filterNearbyProfiles = false;
  String _filterCountry = 'All';
  String _filterEatingHabits = "Doesn't Matter";
  String _filterSmoking = "Doesn't Matter";
  String _filterDrinking = "Doesn't Matter";
  String _filterOccupation = 'Any';
  String _filterIncomeFrom = 'Any';
  String _filterIncomeTo = 'Any';
  String _filterEmploymentType = 'Any';
  String _filterEducation = 'Any';
  String _filterFamilyStatus = "Doesn't Matter";
  String _filterFamilyValues = 'Any';
  String _filterFamilyType = 'Any';
  String _filterRecency = 'Anytime';
  bool _filterMutualMatchesOnly = false;
  bool _filterProfilesWithPhotoOnly = false;

  // ── Sort State variables ──
  String _sortOption = 'None'; // 'None', 'Last Active', 'Recently Created', 'Latest Photos'

  // ── Location State variables ──
  bool _locSameCity = false;
  bool _locSameState = false;
  String _locSelectedCountry = 'All Countries';

  @override
  void initState() {
    super.initState();
    _allProfiles = widget.initialProfiles != null && widget.initialProfiles!.isNotEmpty
        ? List<ProfileModel>.from(widget.initialProfiles!)
        : List<ProfileModel>.from(SampleProfiles.whoViewedYou);
    _visibleProfiles = List<ProfileModel>.from(_allProfiles);
  }

  void _removeProfile(String id) {
    setState(() {
      _allProfiles.removeWhere((p) => p.id == id);
      _applyActiveFilter();
    });
  }

  void _applyActiveFilter() {
    List<ProfileModel> temp = List<ProfileModel>.from(_allProfiles);

    if (_filterMinAge > 18 || _filterMaxAge < 60) {
      temp = temp.where((p) => p.age >= _filterMinAge && p.age <= _filterMaxAge).toList();
    }
    
    double parseHeight(String h) {
      try {
        final clean = h.replaceAll('"', '').split("'");
        if (clean.length >= 2) {
          final feet = double.tryParse(clean[0]) ?? 5.0;
          final inches = double.tryParse(clean[1]) ?? 0.0;
          return feet + (inches / 12.0);
        }
      } catch (_) {}
      return 5.5;
    }

    if (_filterMinHeight > 4.0 || _filterMaxHeight < 7.0) {
      temp = temp.where((p) {
        final val = parseHeight(p.height);
        return val >= _filterMinHeight && val <= _filterMaxHeight;
      }).toList();
    }

    if (_filterCreatedBy != 'All') {
      temp = temp.where((p) => p.profileCreatedBy.toLowerCase() == _filterCreatedBy.toLowerCase()).toList();
    }

    if (_filterMaritalStatus != 'Any') {
      temp = temp.where((p) => p.maritalStatus.toLowerCase() == _filterMaritalStatus.toLowerCase()).toList();
    }

    if (_filterReligion != 'All') {
      temp = temp.where((p) => p.religion.toLowerCase() == _filterReligion.toLowerCase()).toList();
    }

    if (_filterCasteText.isNotEmpty) {
      temp = temp.where((p) => p.caste.toLowerCase().contains(_filterCasteText.toLowerCase())).toList();
    }

    if (_filterCountry != 'All') {
      temp = temp.where((p) => p.country.toLowerCase() == _filterCountry.toLowerCase()).toList();
    }

    if (_filterEatingHabits != "Doesn't Matter") {
      temp = temp.where((p) => p.eatingHabits?.toLowerCase() == _filterEatingHabits.toLowerCase()).toList();
    }

    if (_filterSmoking != "Doesn't Matter") {
      temp = temp.where((p) => p.smokingHabits?.toLowerCase() == _filterSmoking.toLowerCase()).toList();
    }

    if (_filterDrinking != "Doesn't Matter") {
      temp = temp.where((p) => p.drinkingHabits?.toLowerCase() == _filterDrinking.toLowerCase()).toList();
    }

    if (_filterFamilyValues != 'Any') {
      temp = temp.where((p) => p.familyValues?.toLowerCase() == _filterFamilyValues.toLowerCase()).toList();
    }

    if (_filterMotherTongue != "Doesn't Matter") {
      temp = temp.where((p) => p.motherTongue.toLowerCase() == _filterMotherTongue.toLowerCase()).toList();
    }

    if (_filterPhysicalStatus != "Doesn't Matter") {
      temp = temp.where((p) => p.physicalStatus?.toLowerCase() == _filterPhysicalStatus.toLowerCase()).toList();
    }

    if (_filterOccupation != 'Any') {
      temp = temp.where((p) => p.occupation.toLowerCase() == _filterOccupation.toLowerCase()).toList();
    }

    if (_filterEmploymentType != 'Any') {
      temp = temp.where((p) => p.employmentType?.toLowerCase() == _filterEmploymentType.toLowerCase()).toList();
    }

    if (_filterEducation != 'Any') {
      temp = temp.where((p) => p.education?.toLowerCase() == _filterEducation.toLowerCase()).toList();
    }

    if (_filterFamilyStatus != "Doesn't Matter") {
      temp = temp.where((p) => p.familyStatus?.toLowerCase() == _filterFamilyStatus.toLowerCase()).toList();
    }

    double parseIncome(String incomeStr) {
      final clean = incomeStr.replaceAll('₹', '').replaceAll('Lakhs', '').replaceAll('Lakh', '').trim();
      if (clean.toLowerCase().contains('under')) return 2.0;
      if (clean.contains('+')) {
        return double.tryParse(clean.replaceAll('+', '').trim()) ?? 40.0;
      }
      if (clean.contains('-')) {
        final parts = clean.split('-');
        return double.tryParse(parts[0].trim()) ?? 0.0;
      }
      return double.tryParse(clean) ?? 0.0;
    }

    double parseFilterIncome(String filterIncome) {
      final clean = filterIncome.replaceAll('₹', '').replaceAll('Lakhs', '').replaceAll('Lakh', '').replaceAll('+', '').trim();
      return double.tryParse(clean) ?? 0.0;
    }

    if (_filterIncomeFrom != 'Any') {
      temp = temp.where((p) => parseIncome(p.annualIncome) >= parseFilterIncome(_filterIncomeFrom)).toList();
    }

    if (_filterIncomeTo != 'Any') {
      temp = temp.where((p) => parseIncome(p.annualIncome) <= parseFilterIncome(_filterIncomeTo)).toList();
    }

    if (_filterMutualMatchesOnly) {
      temp = temp.where((p) => p.isVerified).toList();
    }

    if (_filterProfilesWithPhotoOnly) {
      temp = temp.where((p) => p.photoUrl != null).toList();
    }

    if (_locSameCity) {
      temp = temp.where((p) => p.city == 'Chennai' || p.city == 'Coimbatore' || p.city == 'Bangalore').toList();
    }
    if (_locSameState) {
      temp = temp.where((p) => p.state == 'Tamil Nadu' || p.state == 'Karnataka').toList();
    }
    if (_locSelectedCountry != 'All Countries') {
      temp = temp.where((p) {
        if (_locSelectedCountry == 'India') return p.country == 'India';
        if (_locSelectedCountry == 'United States of America') return p.country == 'United States' || p.country == 'USA';
        if (_locSelectedCountry == 'UK & Europe') return p.country == 'United Kingdom' || p.country == 'UK' || p.country == 'Germany' || p.country == 'France';
        if (_locSelectedCountry == 'United Arab Emirates') return p.country == 'UAE' || p.country == 'United Arab Emirates';
        if (_locSelectedCountry == 'Canada') return p.country == 'Canada';
        if (_locSelectedCountry == 'Australia') return p.country == 'Australia';
        return true;
      }).toList();
    }

    if (_activeSubTab == 'Horoscope Matches') {
      temp = temp.where((p) => p.religion == 'Hindu').toList();
    } else if (_activeSubTab == 'Profiles with Photo') {
      temp = temp.where((p) => p.photoUrl != null).toList();
    } else if (_activeSubTab == 'Location') {
      temp = temp.where((p) => p.country == 'India' || p.country == 'United States' || p.country == 'Singapore').toList();
    } else if (_activeSubTab == 'Mutual Match') {
      temp = temp.where((p) => p.isVerified).toList();
    }

    if (_sortOption == 'Last Active') {
      temp.sort((a, b) {
        final aActive = a.lastSeen?.contains('now') ?? false;
        final bActive = b.lastSeen?.contains('now') ?? false;
        if (aActive && !bActive) return -1;
        if (!aActive && bActive) return 1;
        return 0;
      });
    } else if (_sortOption == 'Recently Created') {
      temp.sort((a, b) => b.age.compareTo(a.age));
    } else if (_sortOption == 'Latest Photos') {
      temp.sort((a, b) {
        if (a.photoUrl != null && b.photoUrl == null) return -1;
        if (a.photoUrl == null && b.photoUrl != null) return 1;
        return 0;
      });
    }

    setState(() {
      _visibleProfiles = temp;
    });
  }

  void _openFiltersSheet(String lang) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) {
        return StatefulBuilder(
          builder: (ctx, setSheetState) {
            Widget buildSectionHeader(String titleKey) {
              return Padding(
                padding: const EdgeInsets.only(top: 20, bottom: 8),
                child: Text(
                  translateOption(titleKey, lang),
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: KalyaThiruTheme.primaryMaroon,
                  ),
                ),
              );
            }

            Widget buildPillButton(String text, String activeVal, VoidCallback onTap) {
              final bool isActive = activeVal == text;
              return ElevatedButton(
                onPressed: onTap,
                style: ElevatedButton.styleFrom(
                  backgroundColor: isActive ? KalyaThiruTheme.primaryMaroon : const Color(0xFFF3E8E9),
                  foregroundColor: isActive ? Colors.white : KalyaThiruTheme.darkCharcoal,
                  elevation: 0,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                ),
                child: Text(translateOption(text, lang), style: const TextStyle(fontSize: 12)),
              );
            }

            return Container(
              height: MediaQuery.of(context).size.height * 0.85,
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
              ),
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(20, 16, 20, 8),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            IconButton(
                              icon: const Icon(Icons.close, color: KalyaThiruTheme.darkCharcoal),
                              onPressed: () => Navigator.pop(ctx),
                            ),
                            const SizedBox(width: 8),
                            Text(
                              translateOption('Filters', lang),
                              style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: KalyaThiruTheme.darkCharcoal,
                              ),
                            ),
                          ],
                        ),
                        TextButton(
                          onPressed: () {
                            setSheetState(() {
                              _filterMinAge = 18;
                              _filterMaxAge = 60;
                              _filterMinHeight = 4.0;
                              _filterMaxHeight = 7.0;
                              _filterCreatedBy = 'All';
                              _filterMaritalStatus = 'Any';
                              _filterMotherTongue = "Doesn't Matter";
                              _filterPhysicalStatus = "Doesn't Matter";
                              _filterReligion = 'All';
                              _filterCasteText = '';
                              _filterCasteNoBar = false;
                              _filterNearbyProfiles = false;
                              _filterCountry = 'All';
                              _filterEatingHabits = "Doesn't Matter";
                              _filterSmoking = "Doesn't Matter";
                              _filterDrinking = "Doesn't Matter";
                              _filterOccupation = 'Any';
                              _filterIncomeFrom = 'Any';
                              _filterIncomeTo = 'Any';
                              _filterEmploymentType = 'Any';
                              _filterEducation = 'Any';
                              _filterFamilyStatus = "Doesn't Matter";
                              _filterFamilyValues = 'Any';
                              _filterFamilyType = 'Any';
                              _filterRecency = 'Anytime';
                              _filterMutualMatchesOnly = false;
                              _filterProfilesWithPhotoOnly = false;
                            });
                          },
                          child: Text(
                            lang == 'en' ? 'Reset' : 'மீட்டமை',
                            style: const TextStyle(color: KalyaThiruTheme.mutedGray),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Divider(height: 1),

                  Expanded(
                    child: ListView(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      children: [
                        Container(
                          margin: const EdgeInsets.only(top: 16),
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: const Color(0xFFBA1A1A),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                lang == 'en' ? 'PREMIUM ADVANTAGE' : 'பிரீமியம் நன்மைகள்',
                                style: const TextStyle(
                                  fontSize: 10,
                                  color: Colors.amber,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                lang == 'en' ? 'Refine by Institution & Company' : 'நிறுவனம் & அமைப்பின்படி வடிகட்டவும்',
                                style: const TextStyle(
                                  fontSize: 16,
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                lang == 'en'
                                    ? 'Find matches from IIT, NIT, IIM, or top organizations like Microsoft and TCS.'
                                    : 'IIT, NIT, IIM அல்லது மைக்ரோசாப்ட், TCS போன்ற முன்னணி நிறுவனங்களின் வரன்களைக் கண்டறியவும்.',
                                  style: const TextStyle(
                                  fontSize: 11,
                                  color: Colors.white70,
                                  height: 1.4,
                                ),
                              ),
                              const SizedBox(height: 12),
                              ElevatedButton(
                                  onPressed: () {},
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.amber,
                                    foregroundColor: KalyaThiruTheme.darkCharcoal,
                                    elevation: 0,
                                  ),
                                  child: Text(lang == 'en' ? 'Become a Paid Member' : 'கட்டண உறுப்பினராகுங்கள்'),
                              ),
                            ],
                          ),
                        ),

                        buildSectionHeader('Basic Details'),
                        Text(
                          '${translateOption('Age Range', lang)}: ${_filterMinAge.toInt()} - ${_filterMaxAge.toInt()} ${lang == 'en' ? 'Years' : 'வயது'}',
                          style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
                        ),
                        RangeSlider(
                          values: RangeValues(_filterMinAge, _filterMaxAge),
                          min: 18,
                          max: 80,
                          activeColor: KalyaThiruTheme.primaryMaroon,
                          onChanged: (val) {
                            setSheetState(() {
                              _filterMinAge = val.start;
                              _filterMaxAge = val.end;
                            });
                          },
                        ),

                        Text(
                          '${translateOption('Height Range', lang)}: ${_filterMinHeight.toStringAsFixed(1)}ft - ${_filterMaxHeight.toStringAsFixed(1)}ft',
                          style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
                        ),
                        RangeSlider(
                          values: RangeValues(_filterMinHeight, _filterMaxHeight),
                          min: 4.0,
                          max: 8.0,
                          activeColor: KalyaThiruTheme.primaryMaroon,
                          onChanged: (val) {
                            setSheetState(() {
                              _filterMinHeight = val.start;
                              _filterMaxHeight = val.end;
                            });
                          },
                        ),

                        const SizedBox(height: 12),
                        DropdownButtonFormField<String>(
                          initialValue: _filterCreatedBy,
                          decoration: InputDecoration(
                            labelText: translateOption('Profile Created By', lang),
                            border: const OutlineInputBorder(),
                          ),
                          items: ['All', 'Self', 'Parents', 'Sibling'].map((opt) {
                            return DropdownMenuItem(value: opt, child: Text(opt));
                          }).toList(),
                          onChanged: (val) {
                            setSheetState(() => _filterCreatedBy = val ?? 'All');
                          },
                        ),

                        const SizedBox(height: 16),
                        Text(
                          translateOption('Marital Status', lang),
                          style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 6),
                        Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          children: [
                            buildPillButton('Any', _filterMaritalStatus, () {
                              setSheetState(() => _filterMaritalStatus = 'Any');
                            }),
                            buildPillButton('Never Married', _filterMaritalStatus, () {
                              setSheetState(() => _filterMaritalStatus = 'Never Married');
                            }),
                            buildPillButton('Widowed', _filterMaritalStatus, () {
                              setSheetState(() => _filterMaritalStatus = 'Widowed');
                            }),
                            buildPillButton('Divorced', _filterMaritalStatus, () {
                              setSheetState(() => _filterMaritalStatus = 'Divorced');
                            }),
                          ],
                        ),

                        const SizedBox(height: 16),
                        DropdownButtonFormField<String>(
                          value: _filterMotherTongue,
                          decoration: InputDecoration(
                            labelText: translateOption('Mother Tongue', lang),
                            border: const OutlineInputBorder(),
                          ),
                          items: ["Doesn't Matter", 'Tamil', 'Telugu', 'Kannada', 'Malayalam', 'Hindi', 'English'].map((opt) {
                            return DropdownMenuItem(value: opt, child: Text(translateOption(opt, lang)));
                          }).toList(),
                          onChanged: (val) {
                            setSheetState(() => _filterMotherTongue = val ?? "Doesn't Matter");
                          },
                        ),

                        const SizedBox(height: 16),
                        DropdownButtonFormField<String>(
                          value: _filterPhysicalStatus,
                          decoration: InputDecoration(
                            labelText: translateOption('Physical Status', lang),
                            border: const OutlineInputBorder(),
                          ),
                          items: ["Doesn't Matter", 'Normal', 'Physically Challenged'].map((opt) {
                            return DropdownMenuItem(value: opt, child: Text(translateOption(opt, lang)));
                          }).toList(),
                          onChanged: (val) {
                            setSheetState(() => _filterPhysicalStatus = val ?? "Doesn't Matter");
                          },
                        ),

                        buildSectionHeader('Religious Details'),
                        DropdownButtonFormField<String>(
                          initialValue: _filterReligion,
                          decoration: InputDecoration(
                            labelText: translateOption('Religion', lang),
                            border: const OutlineInputBorder(),
                          ),
                          items: ['All', 'Hindu', 'Muslim', 'Christian'].map((opt) {
                            return DropdownMenuItem(value: opt, child: Text(opt));
                          }).toList(),
                          onChanged: (val) {
                            setSheetState(() => _filterReligion = val ?? 'All');
                          },
                        ),

                        const SizedBox(height: 12),
                        TextFormField(
                          initialValue: _filterCasteText,
                          decoration: InputDecoration(
                            labelText: lang == 'en' ? 'Caste Name' : 'சாதி பெயர்',
                            hintText: lang == 'en' ? 'Type Caste Name' : 'சாதி பெயரை தட்டச்சு செய்யவும்',
                            border: const OutlineInputBorder(),
                          ),
                          onChanged: (val) {
                            _filterCasteText = val;
                          },
                        ),

                        CheckboxListTile(
                          title: Text(translateOption('Caste No Bar', lang)),
                          value: _filterCasteNoBar,
                          activeColor: KalyaThiruTheme.primaryMaroon,
                          onChanged: (val) {
                            setSheetState(() => _filterCasteNoBar = val ?? false);
                          },
                        ),

                        buildSectionHeader('Location Details'),
                        CheckboxListTile(
                          title: Text(translateOption('Nearby Profiles', lang)),
                          value: _filterNearbyProfiles,
                          activeColor: KalyaThiruTheme.primaryMaroon,
                          onChanged: (val) {
                            setSheetState(() => _filterNearbyProfiles = val ?? false);
                          },
                        ),

                        DropdownButtonFormField<String>(
                          initialValue: _filterCountry,
                          decoration: InputDecoration(
                            labelText: lang == 'en' ? 'Country' : 'நாடு',
                            border: const OutlineInputBorder(),
                          ),
                          items: ['All', 'India', 'United States', 'Singapore', 'United Kingdom'].map((opt) {
                            return DropdownMenuItem(value: opt, child: Text(opt));
                          }).toList(),
                          onChanged: (val) {
                            setSheetState(() => _filterCountry = val ?? 'All');
                          },
                        ),

                        buildSectionHeader('Professional Details'),
                        DropdownButtonFormField<String>(
                          value: _filterOccupation,
                          decoration: InputDecoration(
                            labelText: translateOption('Occupation', lang),
                            border: const OutlineInputBorder(),
                          ),
                          items: ['Any', 'Software Engineer', 'Doctor / Surgeon', 'IAS / IPS / Civil Services', 'Chartered Accountant', 'Professor / Teacher', 'Business Owner', 'Architect', 'Banker', 'Defence Personnel'].map((opt) {
                            return DropdownMenuItem(value: opt, child: Text(translateOption(opt, lang)));
                          }).toList(),
                          onChanged: (val) {
                            setSheetState(() => _filterOccupation = val ?? 'Any');
                          },
                        ),

                        const SizedBox(height: 16),
                        DropdownButtonFormField<String>(
                          value: _filterEmploymentType,
                          decoration: InputDecoration(
                            labelText: translateOption('Employment Type', lang),
                            border: const OutlineInputBorder(),
                          ),
                          items: ['Any', 'Private Sector Job', 'Government / PSU Job', 'Business / Self-Employed', 'Not Working / Student'].map((opt) {
                            return DropdownMenuItem(value: opt, child: Text(translateOption(opt, lang)));
                          }).toList(),
                          onChanged: (val) {
                            setSheetState(() => _filterEmploymentType = val ?? 'Any');
                          },
                        ),

                        const SizedBox(height: 16),
                        DropdownButtonFormField<String>(
                          value: _filterEducation,
                          decoration: InputDecoration(
                            labelText: translateOption('Education', lang),
                            border: const OutlineInputBorder(),
                          ),
                          items: ['Any', 'Doctorate / PhD', 'Master\'s Degree', 'Bachelor\'s Degree', 'Diploma', 'High School'].map((opt) {
                            return DropdownMenuItem(value: opt, child: Text(translateOption(opt, lang)));
                          }).toList(),
                          onChanged: (val) {
                            setSheetState(() => _filterEducation = val ?? 'Any');
                          },
                        ),

                        const SizedBox(height: 16),
                        Text(
                          translateOption('Annual Income', lang),
                          style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            Expanded(
                              child: DropdownButtonFormField<String>(
                                value: _filterIncomeFrom,
                                decoration: InputDecoration(
                                  labelText: translateOption('Income From', lang),
                                  border: const OutlineInputBorder(),
                                ),
                                items: ['Any', '₹3 Lakhs', '₹5 Lakhs', '₹8 Lakhs', '₹12 Lakhs', '₹18 Lakhs', '₹25 Lakhs', '₹40 Lakhs'].map((opt) {
                                  return DropdownMenuItem(value: opt, child: Text(translateOption(opt, lang)));
                                }).toList(),
                                onChanged: (val) {
                                  setSheetState(() => _filterIncomeFrom = val ?? 'Any');
                                },
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: DropdownButtonFormField<String>(
                                value: _filterIncomeTo,
                                decoration: InputDecoration(
                                  labelText: translateOption('Income To', lang),
                                  border: const OutlineInputBorder(),
                                ),
                                items: ['Any', '₹3 Lakhs', '₹5 Lakhs', '₹8 Lakhs', '₹12 Lakhs', '₹18 Lakhs', '₹25 Lakhs', '₹40 Lakhs', '₹40 Lakhs+'].map((opt) {
                                  return DropdownMenuItem(value: opt, child: Text(translateOption(opt, lang)));
                                }).toList(),
                                onChanged: (val) {
                                  setSheetState(() => _filterIncomeTo = val ?? 'Any');
                                },
                              ),
                            ),
                          ],
                        ),

                        buildSectionHeader('Lifestyle'),
                        Text(
                          translateOption('Eating Habits', lang),
                          style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 6),
                        Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          children: [
                            buildPillButton("Doesn't Matter", _filterEatingHabits, () {
                              setSheetState(() => _filterEatingHabits = "Doesn't Matter");
                            }),
                            buildPillButton('Vegetarian', _filterEatingHabits, () {
                              setSheetState(() => _filterEatingHabits = 'Vegetarian');
                            }),
                            buildPillButton('Non-Veg', _filterEatingHabits, () {
                              setSheetState(() => _filterEatingHabits = 'Non-Veg');
                            }),
                            buildPillButton('Eggetarian', _filterEatingHabits, () {
                              setSheetState(() => _filterEatingHabits = 'Eggetarian');
                            }),
                          ],
                        ),

                        const SizedBox(height: 16),
                        Text(
                          translateOption('Smoking', lang),
                          style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 6),
                        Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          children: [
                            buildPillButton("Doesn't Matter", _filterSmoking, () {
                              setSheetState(() => _filterSmoking = "Doesn't Matter");
                            }),
                            buildPillButton('No', _filterSmoking, () {
                              setSheetState(() => _filterSmoking = 'No');
                            }),
                            buildPillButton('Occasional', _filterSmoking, () {
                              setSheetState(() => _filterSmoking = 'Occasional');
                            }),
                            buildPillButton('Yes', _filterSmoking, () {
                              setSheetState(() => _filterSmoking = 'Yes');
                            }),
                          ],
                        ),

                        const SizedBox(height: 16),
                        Text(
                          translateOption('Drinking', lang),
                          style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 6),
                        Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          children: [
                            buildPillButton("Doesn't Matter", _filterDrinking, () {
                              setSheetState(() => _filterDrinking = "Doesn't Matter");
                            }),
                            buildPillButton('No', _filterDrinking, () {
                              setSheetState(() => _filterDrinking = 'No');
                            }),
                            buildPillButton('Occasional', _filterDrinking, () {
                              setSheetState(() => _filterDrinking = 'Occasional');
                            }),
                            buildPillButton('Yes', _filterDrinking, () {
                              setSheetState(() => _filterDrinking = 'Yes');
                            }),
                          ],
                        ),

                        buildSectionHeader('Family Details'),
                        DropdownButtonFormField<String>(
                          value: _filterFamilyStatus,
                          decoration: InputDecoration(
                            labelText: translateOption('Family Status', lang),
                            border: const OutlineInputBorder(),
                          ),
                          items: ["Doesn't Matter", 'Rich / Affluent', 'Upper Middle Class', 'Middle Class', 'Lower Middle Class'].map((opt) {
                            return DropdownMenuItem(value: opt, child: Text(translateOption(opt, lang)));
                          }).toList(),
                          onChanged: (val) {
                            setSheetState(() => _filterFamilyStatus = val ?? "Doesn't Matter");
                          },
                        ),

                        const SizedBox(height: 16),
                        Text(
                          translateOption('Family Values', lang),
                          style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 6),
                        Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          children: [
                            buildPillButton('Any', _filterFamilyValues, () {
                              setSheetState(() => _filterFamilyValues = 'Any');
                            }),
                            buildPillButton('Traditional', _filterFamilyValues, () {
                              setSheetState(() => _filterFamilyValues = 'Traditional');
                            }),
                            buildPillButton('Moderate', _filterFamilyValues, () {
                              setSheetState(() => _filterFamilyValues = 'Moderate');
                            }),
                            buildPillButton('Liberal', _filterFamilyValues, () {
                              setSheetState(() => _filterFamilyValues = 'Liberal');
                            }),
                          ],
                        ),

                        buildSectionHeader('Recently Created Profiles'),
                        Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          children: [
                            buildPillButton('Anytime', _filterRecency, () {
                              setSheetState(() => _filterRecency = 'Anytime');
                            }),
                            buildPillButton('Today', _filterRecency, () {
                              setSheetState(() => _filterRecency = 'Today');
                            }),
                            buildPillButton('Last 3 days', _filterRecency, () {
                              setSheetState(() => _filterRecency = 'Last 3 days');
                            }),
                            buildPillButton('One week', _filterRecency, () {
                              setSheetState(() => _filterRecency = 'One week');
                            }),
                            buildPillButton('One month', _filterRecency, () {
                              setSheetState(() => _filterRecency = 'One month');
                            }),
                          ],
                        ),

                        const SizedBox(height: 16),
                        CheckboxListTile(
                          title: Text(translateOption('Mutual matches', lang)),
                          value: _filterMutualMatchesOnly,
                          activeColor: KalyaThiruTheme.primaryMaroon,
                          onChanged: (val) {
                            setSheetState(() => _filterMutualMatchesOnly = val ?? false);
                          },
                        ),

                        CheckboxListTile(
                          title: Text(translateOption('Profiles with Photo', lang)),
                          value: _filterProfilesWithPhotoOnly,
                          activeColor: KalyaThiruTheme.primaryMaroon,
                          onChanged: (val) {
                            setSheetState(() => _filterProfilesWithPhotoOnly = val ?? false);
                          },
                        ),
                        const SizedBox(height: 24),
                      ],
                    ),
                  ),

                  Container(
                    color: Colors.white,
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                    child: Row(
                      children: [
                        Expanded(
                          child: OutlinedButton(
                            onPressed: () {
                              setSheetState(() {
                                _filterMinAge = 18;
                                _filterMaxAge = 60;
                                _filterMinHeight = 4.0;
                                _filterMaxHeight = 7.0;
                                _filterCreatedBy = 'All';
                                _filterMaritalStatus = 'Any';
                                _filterMotherTongue = "Doesn't Matter";
                                _filterPhysicalStatus = "Doesn't Matter";
                                _filterReligion = 'All';
                                _filterCasteText = '';
                                _filterCasteNoBar = false;
                                _filterNearbyProfiles = false;
                                _filterCountry = 'All';
                                _filterEatingHabits = "Doesn't Matter";
                                _filterSmoking = "Doesn't Matter";
                                _filterDrinking = "Doesn't Matter";
                                _filterOccupation = 'Any';
                                _filterIncomeFrom = 'Any';
                                _filterIncomeTo = 'Any';
                                _filterEmploymentType = 'Any';
                                _filterEducation = 'Any';
                                _filterFamilyStatus = "Doesn't Matter";
                                _filterFamilyValues = 'Any';
                                _filterFamilyType = 'Any';
                                _filterRecency = 'Anytime';
                                _filterMutualMatchesOnly = false;
                                _filterProfilesWithPhotoOnly = false;
                              });
                            },
                            style: OutlinedButton.styleFrom(
                              side: const BorderSide(color: KalyaThiruTheme.primaryMaroon),
                              padding: const EdgeInsets.symmetric(vertical: 14),
                            ),
                            child: Text(
                              translateOption('Clear Filter', lang),
                              style: const TextStyle(color: KalyaThiruTheme.primaryMaroon, fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: ElevatedButton(
                            onPressed: () {
                              _applyActiveFilter();
                              Navigator.pop(ctx);
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: KalyaThiruTheme.primaryMaroon,
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(vertical: 14),
                            ),
                            child: Text(
                              translateOption('Apply', lang),
                              style: const TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  void _openSortSheet(String lang) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (ctx) {
        return StatefulBuilder(
          builder: (ctx, setSheetState) {
            Widget buildSortRadio(String optionText) {
              return RadioListTile<String>(
                title: Text(
                  translateOption(optionText, lang),
                  style: const TextStyle(fontWeight: FontWeight.bold, color: KalyaThiruTheme.darkCharcoal),
                ),
                value: optionText,
                groupValue: _sortOption,
                activeColor: KalyaThiruTheme.primaryMaroon,
                onChanged: (val) {
                  setSheetState(() {
                    _sortOption = val ?? 'None';
                  });
                },
              );
            }

            return Container(
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
              ),
              padding: const EdgeInsets.symmetric(vertical: 16),
              child: Column(
                mainAxisSize: MainAxisSize.min,
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
                  const SizedBox(height: 12),
                  Text(
                    translateOption('Sort By', lang),
                    style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: KalyaThiruTheme.darkCharcoal),
                  ),
                  const Divider(),
                  buildSortRadio('Last Active'),
                  buildSortRadio('Recently Created'),
                  buildSortRadio('Latest Photos'),
                  const SizedBox(height: 16),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    child: Row(
                      children: [
                        Expanded(
                          child: OutlinedButton(
                            onPressed: () {
                              setSheetState(() {
                                _sortOption = 'None';
                              });
                            },
                            style: OutlinedButton.styleFrom(
                              side: const BorderSide(color: KalyaThiruTheme.primaryMaroon),
                              padding: const EdgeInsets.symmetric(vertical: 12),
                            ),
                            child: Text(
                              translateOption('Clear Filter', lang),
                              style: const TextStyle(color: KalyaThiruTheme.primaryMaroon, fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: ElevatedButton(
                            onPressed: () {
                              _applyActiveFilter();
                              Navigator.pop(ctx);
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: KalyaThiruTheme.primaryMaroon,
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(vertical: 12),
                            ),
                            child: Text(
                              translateOption('Apply', lang),
                              style: const TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  void _openLocationSheet(String lang) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (ctx) {
        return StatefulBuilder(
          builder: (ctx, setSheetState) {
            Widget buildCountryPill(String name) {
              final bool isSelected = _locSelectedCountry == name;
              return GestureDetector(
                onTap: () {
                  setSheetState(() {
                    _locSelectedCountry = name;
                  });
                },
                child: Container(
                  margin: const EdgeInsets.only(right: 8, bottom: 8),
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                  decoration: BoxDecoration(
                    color: isSelected ? const Color(0xFFFFECE0) : Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: isSelected ? const Color(0xFFFF5722) : const Color(0xFFE0E0E0),
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        translateOption(name, lang),
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: isSelected ? const Color(0xFFFF5722) : KalyaThiruTheme.darkCharcoal,
                        ),
                      ),
                      if (isSelected) ...[
                        const SizedBox(width: 4),
                        const Icon(Icons.close, size: 12, color: Color(0xFFFF5722)),
                      ]
                    ],
                  ),
                ),
              );
            }

            return Container(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        translateOption('Location', lang),
                        style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: KalyaThiruTheme.darkCharcoal),
                      ),
                      IconButton(
                        icon: const Icon(Icons.close, color: KalyaThiruTheme.darkCharcoal),
                        onPressed: () => Navigator.pop(ctx),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  
                  CheckboxListTile(
                    title: Text(
                      translateOption('Same city', lang),
                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                    ),
                    subtitle: Text(
                      lang == 'en' ? 'Matches within your city' : 'உங்கள் நகரத்திற்குள் உள்ள வரன்கள்',
                      style: const TextStyle(fontSize: 11, color: KalyaThiruTheme.mutedGray),
                    ),
                    value: _locSameCity,
                    activeColor: const Color(0xFFFF5722),
                    onChanged: (val) {
                      setSheetState(() => _locSameCity = val ?? false);
                    },
                  ),

                  CheckboxListTile(
                    title: Text(
                      translateOption('Same state', lang),
                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                    ),
                    subtitle: Text(
                      lang == 'en' ? 'Matches from other cities/towns in your state' : 'உங்கள் மாநிலத்தின் மற்ற நகரங்களிலிருந்து வரும் வரன்கள்',
                      style: const TextStyle(fontSize: 11, color: KalyaThiruTheme.mutedGray),
                    ),
                    value: _locSameState,
                    activeColor: const Color(0xFFFF5722),
                    onChanged: (val) {
                      setSheetState(() => _locSameState = val ?? false);
                    },
                  ),

                  const SizedBox(height: 16),
                  Text(
                    translateOption('Matches from other countries', lang),
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: KalyaThiruTheme.darkCharcoal),
                  ),
                  const SizedBox(height: 12),
                  
                  Wrap(
                    children: [
                      buildCountryPill('United States of America'),
                      buildCountryPill('India'),
                      buildCountryPill('UK & Europe'),
                      buildCountryPill('United Arab Emirates'),
                      buildCountryPill('Canada'),
                      buildCountryPill('Australia'),
                      buildCountryPill('All Countries'),
                    ],
                  ),

                  const SizedBox(height: 24),
                  
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () {
                            setSheetState(() {
                              _locSameCity = false;
                              _locSameState = false;
                              _locSelectedCountry = 'All Countries';
                            });
                          },
                          style: OutlinedButton.styleFrom(
                            side: const BorderSide(color: Color(0xFFFF5722)),
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                          ),
                          child: Text(
                            translateOption('Clear Filter', lang),
                            style: const TextStyle(color: Color(0xFFFF5722), fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () {
                            _applyActiveFilter();
                            Navigator.pop(ctx);
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFFFF5722),
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                          ),
                          child: Text(
                            translateOption('Apply', lang),
                            style: const TextStyle(fontWeight: FontWeight.bold),
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

  @override
  Widget build(BuildContext context) {
    final lang = context.watch<OnboardingCubit>().state.langCode;

    final List<Map<String, dynamic>> subTabs = [
      {'key': 'Filters', 'icon': Icons.tune},
      {'key': 'Sort By', 'icon': Icons.sort},
      {'key': 'Horoscope Matches', 'icon': null},
      {'key': 'Profiles with Photo', 'icon': null},
      {'key': 'Location', 'icon': null},
      {'key': 'Mutual Match', 'icon': null},
    ];

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
        title: Text(
          translateOption(widget.sectionTitle, lang),
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: KalyaThiruTheme.darkCharcoal,
            fontFamily: 'Source Serif 4',
          ),
        ),
      ),
      body: Column(
        children: [
          Container(
            color: Colors.white,
            padding: const EdgeInsets.symmetric(vertical: 12),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                children: subTabs.map((tab) {
                  final String tabKey = tab['key'] as String;
                  final IconData? icon = tab['icon'] as IconData?;
                  final bool isSelected = _activeSubTab == tabKey;

                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        if (tabKey == 'Filters') {
                          _openFiltersSheet(lang);
                        } else if (tabKey == 'Sort By') {
                          _openSortSheet(lang);
                        } else if (tabKey == 'Location') {
                          _openLocationSheet(lang);
                        } else {
                          if (_activeSubTab == tabKey) {
                            _activeSubTab = null;
                          } else {
                            _activeSubTab = tabKey;
                          }
                          _applyActiveFilter();
                        }
                      });
                    },
                    child: Container(
                      margin: const EdgeInsets.only(right: 8),
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      decoration: BoxDecoration(
                        color: isSelected ? KalyaThiruTheme.primaryMaroon : const Color(0xFFF7F2FA),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: isSelected ? KalyaThiruTheme.primaryMaroon : const Color(0xFFE8DEF8),
                        ),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          if (icon != null) ...[
                            Icon(
                              icon,
                              size: 14,
                              color: isSelected ? Colors.white : KalyaThiruTheme.primaryMaroon,
                            ),
                            const SizedBox(width: 6),
                          ],
                          Text(
                            translateOption(tabKey, lang),
                            style: TextStyle(
                              color: isSelected ? Colors.white : KalyaThiruTheme.darkCharcoal,
                              fontSize: 12,
                              fontWeight: isSelected ? FontWeight.bold : FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
          ),

          Expanded(
            child: _visibleProfiles.isEmpty
                ? Center(
                    child: Text(
                      lang == 'en' ? 'No matches found' : 'வரன்கள் எதுவும் இல்லை',
                      style: const TextStyle(color: KalyaThiruTheme.mutedGray),
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: _visibleProfiles.length,
                    itemBuilder: (context, index) {
                      final profile = _visibleProfiles[index];
                      return _buildProfileCard(context, profile, lang);
                    },
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildProfileCard(BuildContext context, ProfileModel p, String lang) {
    return GestureDetector(
      onTap: () {
        context.push('/profile', extra: p);
      },
      child: Card(
        margin: const EdgeInsets.only(bottom: 16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: const BorderSide(color: KalyaThiruTheme.outlineBorder),
        ),
        color: Colors.white,
        elevation: 0,
        clipBehavior: Clip.antiAlias,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            AspectRatio(
              aspectRatio: 1.2,
              child: Stack(
                children: [
                  Positioned.fill(
                    child: Image.network(
                      p.photoUrl ?? 'https://images.unsplash.com/photo-1544005313-94ddf0286df2?w=600',
                      fit: BoxFit.cover,
                    ),
                  ),
                  if (p.isVerified)
                    Positioned(
                      top: 12,
                      left: 12,
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: const Color(0xFFD2AC47),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(Icons.verified, color: Colors.white, size: 10),
                            const SizedBox(width: 4),
                            Text(
                              lang == 'en' ? '98% TRUST' : '98% நம்பிக்கை',
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
                ],
              ),
            ),

            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          translateOption(p.name, lang),
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: KalyaThiruTheme.primaryMaroon,
                          ),
                        ),
                      ),
                      Row(
                        children: [
                          const Icon(Icons.star, size: 14, color: Colors.green),
                          const SizedBox(width: 4),
                          Text(
                            translateOption('Highly Compatible', lang),
                            style: const TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                              color: Colors.green,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Text(
                    '${p.age} yrs • ${p.height} • ${translateOption(p.city, lang)}',
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: KalyaThiruTheme.darkCharcoal,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    '${translateOption(p.occupation, lang)} • ${translateOption(p.religion, lang)} - ${translateOption(p.caste, lang)}',
                    style: const TextStyle(
                      fontSize: 12,
                      color: KalyaThiruTheme.mutedGray,
                    ),
                  ),
                  
                  const SizedBox(height: 12),
                  
                  Wrap(
                    spacing: 8,
                    children: p.traits.take(2).map((trait) {
                      return Chip(
                        label: Text(
                          translateOption(trait, lang),
                          style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold),
                        ),
                        backgroundColor: const Color(0xFFF3E8E9),
                        side: BorderSide.none,
                        padding: EdgeInsets.zero,
                        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      );
                    }).toList(),
                  ),
                  
                  const SizedBox(height: 16),
                  const Divider(height: 1),
                  const SizedBox(height: 12),

                  Row(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.bookmark_border, color: KalyaThiruTheme.primaryMaroon),
                        onPressed: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('Bookmarked ${p.name}'),
                              duration: const Duration(seconds: 1),
                            ),
                          );
                        },
                      ),
                      const SizedBox(width: 8),

                      Expanded(
                        child: OutlinedButton(
                          onPressed: () => _removeProfile(p.id),
                          style: OutlinedButton.styleFrom(
                            side: const BorderSide(color: KalyaThiruTheme.primaryMaroon),
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
                          ),
                          child: Text(
                            translateOption('Don\'t Show', lang),
                            style: const TextStyle(
                              color: KalyaThiruTheme.primaryMaroon,
                              fontWeight: FontWeight.bold,
                              fontSize: 13,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),

                      Expanded(
                        child: _connectedProfileIds.contains(p.id)
                            ? OutlinedButton(
                                onPressed: () {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text(lang == 'en'
                                          ? 'Interest already sent to ${p.name}!'
                                          : 'ஆர்வ விருப்பம் ஏற்கனவே ${p.name} இற்கு அனுப்பப்பட்டது!'),
                                      duration: const Duration(seconds: 1),
                                    ),
                                  );
                                },
                                style: OutlinedButton.styleFrom(
                                  side: const BorderSide(color: Colors.green, width: 1.5),
                                  backgroundColor: const Color(0xFFE8F5E9),
                                  padding: const EdgeInsets.symmetric(vertical: 12),
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    const Icon(Icons.check, color: Colors.green, size: 16),
                                    const SizedBox(width: 4),
                                    Text(
                                      lang == 'en' ? 'Interest Sent' : 'ஆர்வத்தை அனுப்பியது',
                                      style: const TextStyle(
                                        color: Colors.green,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 12,
                                      ),
                                    ),
                                  ],
                                ),
                              )
                            : ElevatedButton(
                                onPressed: () {
                                  setState(() {
                                    _connectedProfileIds.add(p.id);
                                  });
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text('Interest sent to ${p.name}!'),
                                      duration: const Duration(seconds: 1),
                                    ),
                                  );
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: KalyaThiruTheme.primaryMaroon,
                                  padding: const EdgeInsets.symmetric(vertical: 12),
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
                                ),
                                child: Text(
                                  translateOption('Connect', lang),
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 13,
                                  ),
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
      ),
    );
  }
}
