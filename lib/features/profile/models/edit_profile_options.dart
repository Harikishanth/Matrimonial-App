class EditProfileOptions {
  // ─────────────────────────────────────────────────────────────────────────
  // PHYSICAL / BIOMETRIC
  // ─────────────────────────────────────────────────────────────────────────

  static const List<String> heights = [
    "4' 5\" (135 cm)", "4' 6\" (137 cm)", "4' 7\" (140 cm)",
    "4' 8\" (142 cm)", "4' 9\" (145 cm)", "4' 10\" (147 cm)",
    "4' 11\" (150 cm)", "5' 0\" (152 cm)", "5' 1\" (155 cm)",
    "5' 2\" (157 cm)", "5' 3\" (160 cm)", "5' 4\" (162 cm)",
    "5' 5\" (165 cm)", "5' 6\" (167 cm)", "5' 7\" (170 cm)",
    "5' 8\" (172 cm)", "5' 9\" (175 cm)", "5' 10\" (177 cm)",
    "5' 11\" (180 cm)", "6' 0\" (182 cm)", "6' 1\" (185 cm)",
    "6' 2\" (187 cm)", "6' 3\" (190 cm)", "6' 4\" (193 cm)",
    "6' 5\" (195 cm)", "6' 6\" (198 cm)", "6' 7\" (201 cm)",
    "6' 8\" (203 cm)", "6' 9\" (206 cm)", "6' 10\" (208 cm)",
    "6' 11\" (211 cm)", "7' 0\" (213 cm)",
  ];

  static const List<String> weights = [
    "40 kg (88 lbs)", "41 kg (90 lbs)", "42 kg (92 lbs)", "43 kg (94 lbs)",
    "44 kg (97 lbs)", "45 kg (99 lbs)", "46 kg (101 lbs)", "47 kg (103 lbs)",
    "48 kg (105 lbs)", "49 kg (108 lbs)", "50 kg (110 lbs)", "51 kg (112 lbs)",
    "52 kg (114 lbs)", "53 kg (116 lbs)", "54 kg (119 lbs)", "55 kg (121 lbs)",
    "56 kg (123 lbs)", "57 kg (125 lbs)", "58 kg (127 lbs)", "59 kg (130 lbs)",
    "60 kg (132 lbs)", "61 kg (134 lbs)", "62 kg (136 lbs)", "63 kg (138 lbs)",
    "64 kg (141 lbs)", "65 kg (143 lbs)", "66 kg (145 lbs)", "67 kg (147 lbs)",
    "68 kg (149 lbs)", "69 kg (152 lbs)", "70 kg (154 lbs)", "71 kg (156 lbs)",
    "72 kg (158 lbs)", "73 kg (160 lbs)", "74 kg (163 lbs)", "75 kg (165 lbs)",
    "76 kg (167 lbs)", "77 kg (169 lbs)", "78 kg (171 lbs)", "79 kg (174 lbs)",
    "80 kg (176 lbs)", "81 kg (178 lbs)", "82 kg (180 lbs)", "83 kg (182 lbs)",
    "84 kg (185 lbs)", "85 kg (187 lbs)", "86 kg (189 lbs)", "87 kg (191 lbs)",
    "88 kg (194 lbs)", "89 kg (196 lbs)", "90 kg (198 lbs)", "95 kg (209 lbs)",
    "100 kg (220 lbs)", "110 kg (242 lbs)", "120 kg (264 lbs)",
    "130 kg (286 lbs)", "140 kg (308 lbs)", "150 kg (330 lbs)",
  ];

  static const List<String> maritalStatuses = [
    'Never Married',
    'Divorced',
    'Widowed',
    'Awaiting Divorce',
  ];

  static const List<String> physicalStatuses = [
    'Normal',
    'Physically Challenged',
  ];

  static const List<String> bodyTypes = [
    'Slim',
    'Average',
    'Athletic',
    'Heavy',
  ];

  // ─────────────────────────────────────────────────────────────────────────
  // LANGUAGE / MOTHER TONGUE
  // ─────────────────────────────────────────────────────────────────────────

  static const List<String> motherTongues = [
    'Tamil', 'Telugu', 'Kannada', 'Malayalam', 'Hindi', 'Urdu',
    'Gujarati', 'Punjabi', 'Bengali', 'Marathi', 'Odia', 'Assamese',
    'Kashmiri', 'Sindhi', 'Sanskrit', 'Konkani', 'Nepali', 'English', 'Other',
  ];

  // ─────────────────────────────────────────────────────────────────────────
  // LIFESTYLE
  // ─────────────────────────────────────────────────────────────────────────

  static const List<String> eatingHabits = [
    'Vegetarian',
    'Non-Vegetarian',
    'Eggetarian',
    'Vegan',
    "Doesn't Matter",
  ];

  static const List<String> drinkingHabits = [
    'Never Drinks',
    'Drinks Occasionally',
    'Regular Drinker',
    "Doesn't Matter",
  ];

  static const List<String> smokingHabits = [
    'Non-Smoker',
    'Smokes Occasionally',
    'Regular Smoker',
    "Doesn't Matter",
  ];

  static const List<String> habits = ['Yes', 'No', 'Occasionally'];

  static const List<String> profileCreatedByOptions = [
    'Self', 'Parents', 'Sibling', 'Friend', 'Relative',
  ];

  // ─────────────────────────────────────────────────────────────────────────
  // RELIGION — with sub-denominations mirroring competitor audit
  // ─────────────────────────────────────────────────────────────────────────

  static const List<String> religions = [
    'Hindu',
    'Muslim - All', 'Muslim - Sunni', 'Muslim - Shia', 'Muslim - Others',
    'Christian',
    'Sikh',
    'Jain - All', 'Jain - Digambar', 'Jain - Shwetambar', 'Jain - Others',
    'Buddhist',
    'Parsi',
    'No Religious Belief',
    'Other',
  ];

  // ─────────────────────────────────────────────────────────────────────────
  // CASTE — full hierarchies per religion
  // ─────────────────────────────────────────────────────────────────────────

  static List<String> getCastesForReligion(String? religion) {
    if (religion == null) return ['Any Caste'];

    if (religion == 'Hindu') return _hinduCastes;
    if (religion.startsWith('Muslim')) return _muslimCastes;
    if (religion == 'Christian') return _christianCastes;
    if (religion == 'Sikh') return _sikhCastes;
    if (religion.startsWith('Jain')) return _jainCastes;
    if (religion == 'Buddhist') return _buddhistCastes;
    if (religion == 'Parsi') return ['Parsi', 'Any Caste'];
    return ['Any Caste', 'Caste No Bar'];
  }

  static const List<String> _hinduCastes = [
    'Any Caste',
    // Tamil Nadu
    'Adi Dravidar', 'Arunthathiyar', 'Brahmin - Iyer', 'Brahmin - Iyengar',
    'Brahmin - Others', 'Chettiar', 'Devandra Kula Vellalar',
    'Gounder', 'Gounder - Kongu Vellala', 'Gounder - Nattu Gounder',
    'Gounder - Urali Gounder', 'Gounder - Vettuva Gounder',
    'Gowda', 'Gowda - Kuruba Gowda',
    'Kallar', 'Kamma', 'Kappu', 'Kshatriya',
    'Kurumba', 'Mudaliar', 'Mudaliar - Arcot',
    'Mudaliar - Karkatta', 'Mudaliar - Saiva',
    'Mutharaiyar', 'Nadar', 'Naicker',
    'Padayachi', 'Pillai', 'Pillai - Nair', 'Pillai - Vellalar',
    'Reddiar', 'Saiva Vellalar', 'Sozhia Vellalar',
    'Thevar - Mukkulathor', 'Thevar - Agamudayar', 'Thevar - Kallar', 'Thevar - Maravar',
    'Vakkaligar', 'Vanniyar', 'Vanniyar - Pattali Makkal',
    'Vellalar', 'Vishwakarma', 'Yadav',
    // Pan-India
    'Agarwal', 'Arora', 'Bania', 'Brahmin - Saraswat', 'Gupta',
    'Jat', 'Jatav', 'Khatri', 'Kumhar', 'Kurmi',
    'Lodhi', 'Lohar', 'Mali', 'Maurya', 'Nair',
    'Patel', 'Rajput', 'Rawat', 'Sharma', 'Singh',
    'Sonar', 'Teli', 'Tiwari', 'Vaishnav', 'Verma',
    'Inter-caste', 'Caste No Bar',
  ];

  static const List<String> _muslimCastes = [
    'Any Caste',
    'Muslim - Ansari', 'Muslim - Arain', 'Muslim - Awan', 'Muslim - Bohra',
    'Muslim - Dekkani', 'Muslim - Dudekula', 'Muslim - Hanafi',
    'Muslim - Jat', 'Muslim - Khoja', 'Muslim - Lebbai', 'Muslim - Malik',
    'Muslim - Maniyani', 'Muslim - Mapilla (Kerala)', 'Muslim - Marakayar',
    'Muslim - Memon', 'Muslim - Pathan', 'Muslim - Qureshi',
    'Muslim - Rawther', 'Muslim - Sayyad', 'Muslim - Sheikh',
    'Muslim - Siddiqui', 'Muslim - Sufi', 'Muslim - Turk',
    'Muslim - Others', 'Caste No Bar',
  ];

  static const List<String> _christianCastes = [
    'Any Caste',
    'Christian - Anglican', 'Christian - Baptist', 'Christian - Born Again',
    'Christian - Catholic', 'Christian - Church of South India (CSI)',
    'Christian - Jacobite', 'Christian - Knanaya', 'Christian - Lutheran',
    'Christian - Methodist', 'Christian - Nadar', 'Christian - Pentecostal',
    'Christian - Presbyterian', 'Christian - Protestant',
    'Christian - Roman Catholic', 'Christian - Seventh Day Adventist',
    'Christian - Syrian Catholic', 'Christian - Syrian Orthodox',
    'Christian - Others', 'Caste No Bar',
  ];

  static const List<String> _sikhCastes = [
    'Any Caste',
    'Sikh - Ahluwalia', 'Sikh - Arora', 'Sikh - Bhatia', 'Sikh - Ghumar',
    'Sikh - Intercaste', 'Sikh - Jat', 'Sikh - Kamboj', 'Sikh - Khatri',
    'Sikh - Kshatriya', 'Sikh - Lubana', 'Sikh - Majabi',
    'Sikh - Mahton', 'Sikh - Nai', 'Sikh - Rajput', 'Sikh - Ramgharia',
    'Sikh - Ravidasia', 'Sikh - Saini', 'Sikh - Tonk Kshatriya',
    'Sikh - Others', 'Caste No Bar',
  ];

  static const List<String> _jainCastes = [
    'Any Caste',
    'Jain - Agarwal', 'Jain - Bania', 'Jain - Gujarati',
    'Jain - Khandelwal', 'Jain - Marwari', 'Jain - Oswal',
    'Jain - Porwal', 'Jain - Rajasthani', 'Jain - Shrimali',
    'Jain - Others', 'Caste No Bar',
  ];

  static const List<String> _buddhistCastes = [
    'Any Caste', 'Ambedkarite', 'Barua', 'Mahar', 'Navayana',
    'Others', 'Caste No Bar',
  ];

  // ─────────────────────────────────────────────────────────────────────────
  // ASTROLOGICAL
  // ─────────────────────────────────────────────────────────────────────────

  static const List<String> doshams = [
    "Doesn't Matter", 'No Dosham', 'Yes - Has Dosham',
  ];

  static const List<String> doshamTypes = [
    'Chevvai Dosham', 'Naga Dosham', 'Kala Sarpa Dosham',
    'Rahu Dosham', 'Kethu Dosham', 'Kalathra Dosham',
  ];

  static const List<String> gothrams = [
    'Shiva', 'Vishnu', 'Kashyapa', 'Bharadwaja', 'Gautama', 'Vashishta',
    'Agastya', 'Atri', 'Angirasa', 'Harita', 'Shandilya', 'Parasara',
    "Any Gothram / Doesn't Matter",
  ];

  static const List<String> raasis = [
    'Mesham (Aries)', 'Rishabam (Taurus)', 'Mithunam (Gemini)',
    'Katakam (Cancer)', 'Simham (Leo)', 'Kanni (Virgo)',
    'Thulam (Libra)', 'Vrishchikam (Scorpio)', 'Dhanusu (Sagittarius)',
    'Makaram (Capricorn)', 'Kumbham (Aquarius)', 'Meenam (Pisces)',
    "Doesn't Matter",
  ];

  static const List<String> stars = [
    'Aswini', 'Bharani', 'Krittika', 'Rohini', 'Mrigashirsha', 'Arudra',
    'Punarvasu', 'Pushya', 'Ashlesha', 'Magha', 'Poorva Phalguni',
    'Uttara Phalguni', 'Hasta', 'Chitra', 'Swati', 'Visakha',
    'Anuradha', 'Jyeshta', 'Moola', 'Poorvashada', 'Uttarashada',
    'Sravana', 'Dhanishta', 'Shatabhisha', 'Poorvabhadrapada',
    'Uttarabhadrapada', 'Revati', "Doesn't Matter",
  ];

  // ─────────────────────────────────────────────────────────────────────────
  // EDUCATION
  // ─────────────────────────────────────────────────────────────────────────

  static const List<String> qualifications = [
    'Doctorate (Ph.D / Research)',
    'Post-Graduation (MA, MSc, MBA, ME, etc.)',
    'Graduation / Bachelors (BA, BSc, BE, BTech, etc.)',
    'Diploma',
    'Schooling (HSC / SSLC)',
    'None',
  ];

  static const List<String> pgDegrees = [
    'M.A', 'M.Sc', 'M.Com', 'M.B.A', 'M.E / M.Tech',
    'M.C.A', 'M.D / M.S', 'M.Arch', 'M.Phil', 'LL.M', 'Other',
  ];

  static const List<String> ugDegrees = [
    'B.A', 'B.Sc', 'B.Com', 'B.B.A', 'B.E / B.Tech',
    'B.C.A', 'M.B.B.S / B.D.S', 'B.Arch', 'B.Pharm', 'LL.B', 'Other',
  ];

  static const List<String> schoolingBoards = [
    'State Board', 'CBSE', 'ICSE', 'Matriculation', 'Other',
  ];

  // ─────────────────────────────────────────────────────────────────────────
  // PROFESSIONAL — full industry-level occupation list (competitor parity)
  // ─────────────────────────────────────────────────────────────────────────

  static const List<String> employmentTypes = [
    'Private Sector',
    'Government / PSU',
    'Business / Self-Employed',
    'Defence / Armed Forces',
    'Not Working',
    'Student',
  ];

  /// Full occupation list — mirrors competitor's searchable industry grid
  static const List<String> occupations = [
    'Administration / Operations',
    'Agriculture / Farming',
    'Airline / Aerospace',
    'Architecture & Design',
    'Banking & Finance',
    'Beauty & Fashion',
    'BPO & Customer Service',
    'Civil Services / IAS / IPS',
    'Corporate Professional',
    'Defence & Armed Forces',
    'Doctor / Physician',
    'Education & Training',
    'Engineering',
    'Entertainment & Arts',
    'Entrepreneur / Business Owner',
    'Government / PSU Employee',
    'Healthcare & Medical',
    'Hospitality & Hotels',
    'IT & Software',
    'Journalism & Media',
    'Law & Legal',
    'Logistics & Supply Chain',
    'Management Consulting',
    'Manufacturing',
    'Marketing & Advertising',
    'Merchant Navy',
    'NGO & Social Work',
    'Pharma & Biotech',
    'Police & Law Enforcement',
    'Real Estate & Construction',
    'Research & Science',
    'Retail & Trading',
    'Sports & Fitness',
    'Telecom',
    'Transport & Driver',
    'Homemaker',
    'Not Working',
    'Other',
  ];

  // ─────────────────────────────────────────────────────────────────────────
  // INCOME
  // ─────────────────────────────────────────────────────────────────────────

  static const List<String> annualIncomes = [
    'No Preference',
    'Under ₹3 Lakhs / year',
    '₹3 – ₹5 Lakhs / year',
    '₹5 – ₹8 Lakhs / year',
    '₹8 – ₹12 Lakhs / year',
    '₹12 – ₹18 Lakhs / year',
    '₹18 – ₹25 Lakhs / year',
    '₹25 – ₹40 Lakhs / year',
    '₹40 – ₹60 Lakhs / year',
    '₹60 Lakhs – ₹1 Crore / year',
    'Above ₹1 Crore / year',
  ];

  // ─────────────────────────────────────────────────────────────────────────
  // LOCATION
  // ─────────────────────────────────────────────────────────────────────────

  /// Frequently-selected countries (shown at the top in the picker)
  static const List<String> frequentCountries = [
    'India', 'United States of America', 'United Arab Emirates',
    'Saudi Arabia', 'United Kingdom', 'Malaysia', 'Singapore',
    'Australia', 'Canada',
  ];

  static const List<String> allCountries = [
    'India', 'United States of America', 'United Arab Emirates',
    'Saudi Arabia', 'United Kingdom', 'Malaysia', 'Singapore',
    'Australia', 'Canada', 'Afghanistan', 'Albania', 'Algeria',
    'Andorra', 'Angola', 'Argentina', 'Armenia', 'Austria',
    'Azerbaijan', 'Bahrain', 'Bangladesh', 'Belgium', 'Bhutan',
    'Bolivia', 'Brazil', 'Brunei', 'Bulgaria', 'Cambodia',
    'China', 'Colombia', 'Croatia', 'Cyprus', 'Czech Republic',
    'Denmark', 'Egypt', 'Estonia', 'Ethiopia', 'Finland',
    'France', 'Georgia', 'Germany', 'Ghana', 'Greece',
    'Hong Kong', 'Hungary', 'Iceland', 'Indonesia', 'Iran',
    'Iraq', 'Ireland', 'Israel', 'Italy', 'Japan', 'Jordan',
    'Kazakhstan', 'Kenya', 'Kuwait', 'Latvia', 'Lebanon',
    'Lithuania', 'Luxembourg', 'Maldives', 'Malta', 'Mauritius',
    'Mexico', 'Myanmar', 'Nepal', 'Netherlands', 'New Zealand',
    'Nigeria', 'Norway', 'Oman', 'Pakistan', 'Philippines',
    'Poland', 'Portugal', 'Qatar', 'Romania', 'Russia',
    'Rwanda', 'Serbia', 'South Africa', 'South Korea', 'Spain',
    'Sri Lanka', 'Sweden', 'Switzerland', 'Taiwan', 'Thailand',
    'Tunisia', 'Turkey', 'Uganda', 'Ukraine', 'Uruguay',
    'Vietnam', 'Yemen', 'Zimbabwe', 'Other',
  ];

  static const List<String> states = [
    'Tamil Nadu', 'Karnataka', 'Kerala', 'Andhra Pradesh', 'Telangana',
    'Maharashtra', 'Delhi', 'Uttar Pradesh', 'Rajasthan', 'Gujarat',
    'Madhya Pradesh', 'West Bengal', 'Bihar', 'Punjab', 'Haryana',
    'Odisha', 'Assam', 'Jharkhand', 'Chhattisgarh', 'Himachal Pradesh',
    'Uttarakhand', 'Goa', 'Manipur', 'Meghalaya', 'Nagaland',
    'Tripura', 'Mizoram', 'Arunachal Pradesh', 'Sikkim',
    'Jammu & Kashmir', 'Ladakh', 'Puducherry', 'Other',
  ];

  static const List<String> cities = [
    'Chennai', 'Bangalore', 'Mumbai', 'Delhi', 'Hyderabad',
    'Coimbatore', 'Madurai', 'Trichy', 'Salem', 'Tirunelveli',
    'Erode', 'Vellore', 'Kochi', 'Trivandrum', 'Kozhikode',
    'Pune', 'Ahmedabad', 'Surat', 'Kolkata', 'Lucknow',
    'Chandigarh', 'Jaipur', 'Indore', 'Bhopal', 'Nagpur',
    'Visakhapatnam', 'Vijayawada', 'Warangal', 'Tirupati',
    'Other',
  ];

  static const List<String> citizenships = [
    'Indian Citizen',
    'NRI / Permanent Resident',
    'Foreign National',
  ];

  // ─────────────────────────────────────────────────────────────────────────
  // FAMILY
  // ─────────────────────────────────────────────────────────────────────────

  static const List<String> familyValuesList = [
    'Traditional', 'Moderate', 'Liberal',
  ];

  static const List<String> familyTypes = ['Nuclear', 'Joint'];

  static const List<String> familyStatusList = [
    'Middle Class', 'Upper Middle Class', 'Rich', 'Affluent',
  ];

  static const List<String> siblingCounts = ['0', '1', '2', '3', '4+'];

  // ─────────────────────────────────────────────────────────────────────────
  // HOBBIES & INTERESTS
  // ─────────────────────────────────────────────────────────────────────────

  static const List<String> hobbies = [
    'Reading', 'Music', 'Cooking', 'Gardening',
    'Sports & Fitness', 'Travel', 'Photography', 'Art & Painting',
    'Movies & TV', 'Dancing', 'Gaming', 'Yoga & Meditation',
  ];
}
