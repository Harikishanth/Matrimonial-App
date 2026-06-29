import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../core/theme/theme.dart';
import '../../../core/translation/option_translations.dart';
import '../../onboarding/cubit/onboarding_cubit.dart';

class UpgradeScreen extends StatefulWidget {
  const UpgradeScreen({super.key});

  @override
  State<UpgradeScreen> createState() => _UpgradeScreenState();
}

class _UpgradeScreenState extends State<UpgradeScreen> {
  int _selectedTab = 0; // 0: Gold, 1: Prime Gold, 2: Till U Marry

  Future<void> _activatePremium() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('is_paid_member', true);
  }

  // ── Show Payment Methods bottom sheet ──────────────────────────────────────

  void _showPaymentOptionsSheet(String planName, String price) {
    final lang = context.read<OnboardingCubit>().state.langCode;
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) {
        return Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
          ),
          padding: const EdgeInsets.fromLTRB(24, 20, 24, 32),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Sheet handle
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
              const SizedBox(height: 20),
              Text(
                lang == 'en' ? 'Select Payment Method' : 'பணம் செலுத்தும் முறையைத் தேர்வுசெய்க',
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: KalyaThiruTheme.darkCharcoal,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                '$planName - $price',
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: KalyaThiruTheme.primaryMaroon,
                ),
              ),
              const SizedBox(height: 24),

              // UPI Option
              _buildPaymentTile(
                icon: Icons.qr_code_scanner,
                title: lang == 'en' ? 'UPI (Google Pay, PhonePe, Paytm)' : 'UPI (கூகுள் பே, போன்பே, பேடிஎம்)',
                subtitle: lang == 'en' ? 'Pay instantly using UPI apps' : 'UPI செயலிகள் மூலம் உடனடியாகச் செலுத்தலாம்',
                onTap: () => _processPayment(ctx, planName),
              ),
              const Divider(height: 1, color: Color(0xFFEEEAE7)),

              // Card Option
              _buildPaymentTile(
                icon: Icons.credit_card,
                title: lang == 'en' ? 'Credit / Debit Card' : 'கிரெடிட் / டெபிட் கார்டு',
                subtitle: lang == 'en' ? 'Visa, MasterCard, RuPay, Maestro' : 'விசா, மாஸ்டர்கார்டு, ரூபே',
                onTap: () => _processPayment(ctx, planName),
              ),
              const Divider(height: 1, color: Color(0xFFEEEAE7)),

              // Netbanking Option
              _buildPaymentTile(
                icon: Icons.account_balance,
                title: lang == 'en' ? 'Net Banking' : 'நெட் பேங்கிங்',
                subtitle: lang == 'en' ? 'All major Indian banks supported' : 'அனைத்து முக்கிய இந்திய வங்கிகளும்',
                onTap: () => _processPayment(ctx, planName),
              ),
              const SizedBox(height: 20),

              // Cancel button
              OutlinedButton(
                onPressed: () => Navigator.pop(ctx),
                style: OutlinedButton.styleFrom(
                  side: const BorderSide(color: KalyaThiruTheme.outlineBorder),
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
                ),
                child: Text(
                  lang == 'en' ? 'Cancel' : 'ரத்துசெய்',
                  style: const TextStyle(
                    color: KalyaThiruTheme.darkCharcoal,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildPaymentTile({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(vertical: 8),
      leading: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: const Color(0xFFFBF8F5),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: const Color(0xFFEEEAE7)),
        ),
        child: Icon(icon, color: KalyaThiruTheme.primaryMaroon, size: 24),
      ),
      title: Text(
        title,
        style: const TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 15,
          color: KalyaThiruTheme.darkCharcoal,
        ),
      ),
      subtitle: Text(
        subtitle,
        style: const TextStyle(fontSize: 12, color: KalyaThiruTheme.mutedGray),
      ),
      trailing: const Icon(Icons.chevron_right, color: KalyaThiruTheme.mutedGray),
      onTap: onTap,
    );
  }

  Future<void> _processPayment(BuildContext ctx, String planName) async {
    Navigator.pop(ctx); // Close sheet
    // Show success dialog
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.check_circle, color: Colors.green, size: 64),
              const SizedBox(height: 16),
              const Text(
                'Payment Successful',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: KalyaThiruTheme.darkCharcoal,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Your membership has been upgraded to $planName.',
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 14, color: KalyaThiruTheme.mutedGray),
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () async {
                    await _activatePremium();
                    if (context.mounted) {
                      Navigator.pop(context); // Close dialog
                      context.go('/home'); // Redirect home to refresh states
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: KalyaThiruTheme.primaryMaroon,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                    padding: const EdgeInsets.symmetric(vertical: 14),
                  ),
                  child: const Text('OK', style: TextStyle(fontWeight: FontWeight.bold)),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  // ─── BUILD ─────────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    final lang = context.watch<OnboardingCubit>().state.langCode;

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
          lang == 'en' ? 'Upgrade Membership' : 'உறுப்பினர் மேம்பாடு',
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: KalyaThiruTheme.darkCharcoal,
            fontFamily: 'Source Serif 4',
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // 1. Red Header Special Offer Banner
            Container(
              margin: const EdgeInsets.all(16),
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                gradient: const LinearGradient(
                  colors: [
                    KalyaThiruTheme.primaryMaroon,
                    KalyaThiruTheme.primaryDark,
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                boxShadow: [
                  BoxShadow(
                    color: KalyaThiruTheme.primaryMaroon.withOpacity(0.2),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Stack(
                children: [
                  // Gold star watermark
                  Positioned(
                    right: -10,
                    bottom: -10,
                    child: Opacity(
                      opacity: 0.08,
                      child: Icon(
                        Icons.star_outline_sharp,
                        size: 130,
                        color: KalyaThiruTheme.antiqueGold,
                      ),
                    ),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                            lang == 'en' ? 'SPECIAL OFFER' : 'சிறப்பு சலுகை',
                            style: const TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              color: KalyaThiruTheme.antiqueGold,
                              letterSpacing: 1,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                            decoration: BoxDecoration(
                              color: const Color(0xFFF9E8B6),
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Text(
                              lang == 'en' ? 'LIMITED TIME' : 'வரையறுக்கப்பட்ட நேரம்',
                              style: const TextStyle(
                                fontSize: 9,
                                fontWeight: FontWeight.bold,
                                color: KalyaThiruTheme.primaryDark,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Text(
                        lang == 'en' ? 'Save upto 61%' : '61% வரை சேமிப்பு',
                        style: const TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.w900,
                          color: KalyaThiruTheme.antiqueGold,
                        ),
                      ),
                      const SizedBox(height: 16),
                      Row(
                        children: [
                          Container(
                            width: 1,
                            height: 36,
                            color: Colors.white24,
                          ),
                          const SizedBox(width: 12),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                lang == 'en' ? 'Heritage Trust' : 'பாரம்பரிய நம்பிக்கை',
                                style: const TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                lang == 'en'
                                    ? '15 Days Return Guarantee!'
                                    : '15 நாட்கள் கட்டணம் திரும்பப் பெறும் உத்தரவாதம்!',
                                style: const TextStyle(
                                  fontSize: 11,
                                  color: Colors.white70,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // 2. Sub Tabs Bar (Gold, Prime Gold, Till U Marry)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                children: [
                  _buildSubTabItem(0, 'Gold', lang),
                  const SizedBox(width: 8),
                  _buildSubTabItem(1, 'Prime Gold', lang),
                  const SizedBox(width: 8),
                  _buildSubTabItem(2, 'Till U Marry', lang),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // 3. Plan details card
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: _buildSelectedPlanCard(lang),
            ),
            const SizedBox(height: 24),

            // 4. Trust Footer Text
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Text(
                lang == 'en'
                    ? 'Heritage Matrimony ensures 100% verified profiles and secure communication for your trust'
                    : 'ஹெரிடேஜ் மேட்ரிமனி 100% சரிபார்க்கப்பட்ட சுயவிவரங்கள் மற்றும் பாதுகாப்பான தொடர்பை உறுதி செய்கிறது',
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 11,
                  fontStyle: FontStyle.italic,
                  color: KalyaThiruTheme.mutedGray,
                  height: 1.4,
                ),
              ),
            ),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  Widget _buildSubTabItem(int index, String title, String lang) {
    final isSelected = _selectedTab == index;
    return Expanded(
      child: GestureDetector(
        onTap: () => setState(() => _selectedTab = index),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 10),
          decoration: BoxDecoration(
            color: isSelected ? KalyaThiruTheme.primaryMaroon : Colors.white,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: KalyaThiruTheme.primaryMaroon),
          ),
          child: Text(
            translateOption(title, lang),
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: isSelected ? Colors.white : KalyaThiruTheme.primaryMaroon,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSelectedPlanCard(String lang) {
    if (_selectedTab == 0) {
      // Gold Plan Card
      return _buildPlanCardLayout(
        title: 'Gold',
        subtitle: lang == 'en' ? 'Essential Connection' : 'அடிப்படை இணைப்பு',
        discountPercent: '47% OFF!',
        validityNote: lang == 'en' ? 'Valid for today' : 'இன்று மட்டுமே செல்லுபடியாகும்',
        originalPrice: '₹5,500',
        offerPrice: '₹999',
        pricePerMonth: lang == 'en' ? '₹83 per month' : 'மாதத்திற்கு ₹83',
        features: [
          lang == 'en' ? 'Valid for 3 months' : '3 மாதங்கள் செல்லுபடியாகும்',
          lang == 'en' ? 'View up to 25 Mobile Nos*' : '25 தொலைபேசி எண்கள் வரை பார்க்கலாம்*',
          lang == 'en' ? 'Send unlimited messages' : 'வரம்பற்ற செய்திகளை அனுப்பலாம்',
        ],
        onPayPressed: () => _showPaymentOptionsSheet('Gold Plan', '₹999'),
      );
    } else if (_selectedTab == 1) {
      // Prime Gold Plan Card
      return _buildPlanCardLayout(
        title: 'Prime Gold',
        subtitle: lang == 'en' ? 'Maximum Trust & Visibility' : 'அதிகபட்ச நம்பிக்கை & தெரிவுநிலை',
        discountPercent: '54% OFF!',
        validityNote: lang == 'en' ? 'Valid for today' : 'இன்று மட்டுமே செல்லுபடியாகும்',
        originalPrice: '₹7,900',
        offerPrice: '₹2,500',
        pricePerMonth: lang == 'en' ? '₹1,200 per month' : 'மாதத்திற்கு ₹1,200',
        features: [
          lang == 'en' ? 'Valid for 3 months' : '3 மாதங்கள் செல்லுபடியாகும்',
          lang == 'en' ? 'View unlimited Phone Nos*' : 'வரம்பற்ற தொலைபேசி எண்களைக் காணலாம்*',
          lang == 'en' ? 'Send unlimited messages' : 'வரம்பற்ற செய்திகளை அனுப்பலாம்',
          lang == 'en' ? 'View verified profiles with photos' : 'புகைப்படங்களுடன் சரிபார்க்கப்பட்ட வரன்களைக் காணலாம்',
        ],
        onPayPressed: () => _showPaymentOptionsSheet('Prime Gold Plan', '₹2,500'),
      );
    } else {
      // Till U Marry Plan Card
      return _buildPlanCardLayout(
        title: 'Till U Marry',
        subtitle: lang == 'en' ? 'Lifetime Heritage Support' : 'திருமணம் ஆகும் வரை வாழ்நாள் ஆதரவு',
        discountPercent: '61% OFF!',
        validityNote: lang == 'en' ? 'Limited time' : 'வரையறுக்கப்பட்ட காலம்',
        originalPrice: '₹23,700',
        offerPrice: '₹4,999',
        pricePerMonth: lang == 'en' ? '₹417 per month' : 'மாதத்திற்கு ₹417',
        features: [
          lang == 'en' ? 'Longest validity plan' : 'மிக நீண்ட காலம் செல்லுபடியாகும் திட்டம்',
          lang == 'en' ? 'View unlimited Phone Nos*' : 'வரம்பற்ற தொலைபேசி எண்களைக் காணலாம்*',
          lang == 'en' ? 'Personalized matchmaking assistant' : 'தனிப்பயனாக்கப்பட்ட மேட்ச்மேக்கிங் உதவியாளர்',
        ],
        hasStarIcon: true,
        showKnowMore: true,
        onPayPressed: () => _showPaymentOptionsSheet('Till U Marry Plan', '₹4,999'),
      );
    }
  }

  Widget _buildPlanCardLayout({
    required String title,
    required String subtitle,
    required String discountPercent,
    required String validityNote,
    required String originalPrice,
    required String offerPrice,
    required String pricePerMonth,
    required List<String> features,
    required VoidCallback onPayPressed,
    bool hasStarIcon = false,
    bool showKnowMore = false,
  }) {
    final lang = context.read<OnboardingCubit>().state.langCode;
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFEFECE9), width: 1.5),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Title row
          Row(
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: KalyaThiruTheme.primaryMaroon,
                  fontFamily: 'Source Serif 4',
                ),
              ),
              if (hasStarIcon) ...[
                const SizedBox(width: 6),
                const Icon(Icons.star_border, color: KalyaThiruTheme.antiqueGold, size: 20),
              ]
            ],
          ),
          const SizedBox(height: 2),
          Text(
            subtitle,
            style: const TextStyle(
              fontSize: 12,
              color: KalyaThiruTheme.mutedGray,
            ),
          ),
          const SizedBox(height: 20),

          // Offer price box
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color(0xFFFAF6F2),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      discountPercent,
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: KalyaThiruTheme.primaryMaroon,
                      ),
                    ),
                    const SizedBox(width: 6),
                    Text(
                      validityNote,
                      style: const TextStyle(
                        fontSize: 12,
                        color: KalyaThiruTheme.mutedGray,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.baseline,
                  textBaseline: TextBaseline.alphabetic,
                  children: [
                    Text(
                      originalPrice,
                      style: const TextStyle(
                        fontSize: 16,
                        color: KalyaThiruTheme.mutedGray,
                        decoration: TextDecoration.lineThrough,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      offerPrice,
                      style: const TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                        color: KalyaThiruTheme.primaryMaroon,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(4),
                    border: Border.all(color: const Color(0xFFEFECE9)),
                  ),
                  child: Text(
                    pricePerMonth,
                    style: const TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      color: KalyaThiruTheme.mutedGray,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),

          // Features List
          ...features.map((feature) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Icon(
                    Icons.check_circle,
                    color: KalyaThiruTheme.primaryMaroon,
                    size: 18,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      feature,
                      style: const TextStyle(
                        fontSize: 14,
                        color: KalyaThiruTheme.darkCharcoal,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
            );
          }),
          
          if (showKnowMore) ...[
            const SizedBox(height: 8),
            GestureDetector(
              onTap: () {},
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    lang == 'en' ? 'Know More' : 'மேலும் அறியவும்',
                    style: const TextStyle(
                      color: KalyaThiruTheme.primaryMaroon,
                      fontWeight: FontWeight.bold,
                      fontSize: 13,
                    ),
                  ),
                  const SizedBox(width: 4),
                  const Icon(Icons.chevron_right, color: KalyaThiruTheme.primaryMaroon, size: 16),
                ],
              ),
            ),
          ],
          const SizedBox(height: 24),

          // Pay Now Button
          ElevatedButton(
            onPressed: onPayPressed,
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF530315), // Deep rich maroon
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              padding: const EdgeInsets.symmetric(vertical: 16),
              elevation: 0,
            ),
            child: Text(
              lang == 'en' ? 'Pay Now' : 'இப்போது செலுத்துக',
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
