/// Global profile data model used across the app
/// (Daily Picks, Matches, Who Viewed You, etc.)
class ProfileModel {
  final String id;
  final String name;
  final String? photoUrl;
  final bool isVerified;
  final String? lastSeen;

  // Quick info strip
  final int age;
  final String height;
  final String maritalStatus;
  final String profileCreatedBy; // "Self", "Parents", "Friend"
  final String religion;
  final String caste;
  final bool casteNoBar;
  final String qualification;
  final String occupation;
  final String annualIncome;
  final String city;
  final String state;
  final String country;
  final String motherTongue;

  // Personal
  final String? gender;
  final String? dob;
  final String? physicalStatus;
  final String? eatingHabits;
  final String? gothram;
  final String? raasi;
  final String? nakshatra;
  final String? dosham;
  final String? subcaste;
  final String? weight;
  final String? smokingHabits;
  final String? drinkingHabits;

  // About sections
  final String? bioSelf;       // "About Myself"
  final String? bioFamily;     // "About by Family/Friend"

  // Family
  final String? familyStatus;
  final String? familyWealth;
  final String? parentsInfo;   // e.g. "Father employed, Mother homemaker"
  final String? brothers;
  final String? sisters;
  final String? familyValues;  // "Traditional", "Moderate", "Liberal"

  // Professional
  final String? employmentType;
  final String? education;

  // Contact (shown only for paid users)
  final String? mobileNumber;
  final String? whatsappNumber;

  // This person's partner preferences (shown in PREFERENCES tab)
  final String? prefReligion;
  final String? prefCaste;
  final bool prefCasteNoBar;
  final String? prefSubcaste;
  final String? prefDosham;
  final String? prefStar;
  final String? prefMinIncome;
  final String? prefMaxIncome;
  final String? prefEducation;
  final String? prefEmployment;
  final String? prefImportance;  // "Professional", "Traditional", etc.
  final String? prefCountry;
  final int prefMinAge;
  final int prefMaxAge;
  final String prefMinHeight;
  final String prefMaxHeight;

  // Personality traits (Aura tags)
  final List<String> traits;

  const ProfileModel({
    required this.id,
    required this.name,
    this.photoUrl,
    this.isVerified = false,
    this.lastSeen,
    required this.age,
    required this.height,
    this.maritalStatus = 'Never Married',
    this.profileCreatedBy = 'Self',
    this.religion = '',
    this.caste = '',
    this.casteNoBar = false,
    this.qualification = '',
    this.occupation = '',
    this.annualIncome = '',
    this.city = '',
    this.state = '',
    this.country = 'India',
    this.motherTongue = 'Tamil',
    this.gender,
    this.dob,
    this.physicalStatus,
    this.eatingHabits,
    this.gothram,
    this.raasi,
    this.nakshatra,
    this.dosham,
    this.subcaste,
    this.weight,
    this.smokingHabits = 'No',
    this.drinkingHabits = 'No',
    this.bioSelf,
    this.bioFamily,
    this.familyStatus,
    this.familyWealth,
    this.parentsInfo,
    this.brothers,
    this.sisters,
    this.familyValues,
    this.employmentType,
    this.education,
    this.mobileNumber,
    this.whatsappNumber,
    this.prefReligion,
    this.prefCaste,
    this.prefCasteNoBar = false,
    this.prefSubcaste,
    this.prefDosham,
    this.prefStar,
    this.prefMinIncome,
    this.prefMaxIncome,
    this.prefEducation,
    this.prefEmployment,
    this.prefImportance,
    this.prefCountry,
    this.prefMinAge = 22,
    this.prefMaxAge = 32,
    this.prefMinHeight = "5'0\"",
    this.prefMaxHeight = "6'0\"",
    this.traits = const [],
  });
}

/// Simulated sample profiles used across the app for demo purposes
class SampleProfiles {
  static final List<ProfileModel> dailyPicks = [
    ProfileModel(
      id: 'M11346613',
      name: 'Afrin Zulfia',
      photoUrl: 'https://images.unsplash.com/photo-1544005313-94ddf0286df2?w=600',
      isVerified: true,
      lastSeen: 'Last seen a few hours ago',
      age: 26,
      height: "5'2\"",
      maritalStatus: 'Never Married',
      profileCreatedBy: 'Parents',
      religion: 'Muslim',
      caste: 'Shafi (Caste No Bar)',
      casteNoBar: true,
      qualification: 'M.Tech',
      occupation: 'Research Assistant',
      annualIncome: '₹9 - 10 lakhs per annum',
      city: 'Chennai',
      state: 'Tamil Nadu',
      country: 'India',
      motherTongue: 'Tamil',
      gender: 'Female',
      eatingHabits: 'Non-vegetarian',
      gothram: 'N/A',
      raasi: 'Rishabam',
      nakshatra: 'Rohini',
      dosham: 'None',
      bioSelf:
          '"My daughter is a research assistant with a master\'s degree currently working in private sector. We belong to Upper middle class & Nuclear family with traditional values and residing at Chennai."',
      bioFamily:
          'A well-settled family with strong traditional values. Looking for a match who shares our values and vision for a happy family life.',
      familyStatus: 'Upper Middle Class',
      familyWealth: '₹50 Lakhs - ₹1 Cr',
      parentsInfo: 'Father is employed. Mother is a home maker.',
      brothers: '1 brother',
      sisters: 'None',
      familyValues: 'Traditional',
      employmentType: 'Works in Private Sector',
      education: 'M.Tech',
      mobileNumber: '+91 98*******',
      whatsappNumber: '+91 98*******',
      prefReligion: 'Muslim - Shafi',
      prefCaste: 'Any',
      prefCasteNoBar: true,
      prefDosham: 'No',
      prefStar: "Doesn't matter",
      prefMinIncome: '₹10L+',
      prefMaxIncome: 'No limit',
      prefEducation: "Master's or above",
      prefEmployment: 'Private/Government',
      prefImportance: 'Professional',
      prefCountry: 'India',
      prefMinAge: 27,
      prefMaxAge: 34,
      prefMinHeight: "5'6\"",
      prefMaxHeight: "6'2\"",
      traits: ['Traditional Values', 'Academic Focus', 'Chennai Resident', 'Research Professional'],
    ),
    ProfileModel(
      id: 'M22567821',
      name: 'Priyanka R.',
      photoUrl: 'https://images.unsplash.com/photo-1524504388940-b1c1722653e1?w=600',
      isVerified: true,
      lastSeen: 'Last seen today',
      age: 24,
      height: "5'4\"",
      maritalStatus: 'Never Married',
      profileCreatedBy: 'Self',
      religion: 'Hindu',
      caste: 'Brahmin',
      qualification: 'B.Tech',
      occupation: 'Software Engineer',
      annualIncome: '₹8 - 12 lakhs per annum',
      city: 'Bangalore',
      state: 'Karnataka',
      country: 'India',
      motherTongue: 'Tamil',
      eatingHabits: 'Vegetarian',
      gothram: 'Bharadwaj',
      raasi: 'Mithuna',
      nakshatra: 'Arudra',
      bioSelf: '"Passionate software engineer who loves coding and classical music. Looking for a like-minded partner to build a beautiful life together."',
      familyStatus: 'Middle Class',
      familyValues: 'Moderate',
      parentsInfo: 'Father is a retired government employee. Mother is a school teacher.',
      brothers: 'None',
      sisters: '1 sister',
      employmentType: 'Private Sector',
      mobileNumber: '+91 77*******',
      prefReligion: 'Hindu',
      prefMinAge: 25,
      prefMaxAge: 32,
      prefEducation: 'B.Tech or above',
      prefEmployment: 'Private/Government',
      prefCountry: 'India',
      traits: ['Tech-Savvy', 'Carnatic Music', 'Vegetarian', 'Bangalore Based'],
    ),
    ProfileModel(
      id: 'M33891045',
      name: 'Divya P.',
      photoUrl: 'https://images.unsplash.com/photo-1494790108377-be9c29b29330?w=600',
      isVerified: false,
      lastSeen: 'Last seen 2 days ago',
      age: 23,
      height: "5'3\"",
      maritalStatus: 'Never Married',
      profileCreatedBy: 'Parents',
      religion: 'Hindu',
      caste: 'Vellalar',
      qualification: 'B.A.',
      occupation: 'IAS Aspirant',
      annualIncome: 'Under ₹3 Lakhs',
      city: 'Coimbatore',
      state: 'Tamil Nadu',
      country: 'India',
      motherTongue: 'Tamil',
      eatingHabits: 'Vegetarian',
      gothram: 'Kasyapa',
      raasi: 'Kataka',
      nakshatra: 'Poosam',
      bioSelf: '"Determined and focused on civil services. My passion is to serve the nation. Looking for a partner who respects my ambitions."',
      familyStatus: 'Middle Class',
      familyValues: 'Traditional',
      parentsInfo: 'Father is a farmer. Mother is a homemaker.',
      brothers: '2 brothers',
      employmentType: 'Not Working / Student',
      mobileNumber: '+91 63*******',
      prefReligion: 'Hindu',
      prefMinAge: 25,
      prefMaxAge: 35,
      prefEducation: 'Graduate or above',
      prefCountry: 'India',
      traits: ['Ambitious', 'Traditional Values', 'Bookworm', 'Tamil Heritage'],
    ),
  ];

  static List<ProfileModel> get matchesForYou => dailyPicks;
  static List<ProfileModel> get whoViewedYou => dailyPicks.reversed.toList();
}
