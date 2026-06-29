import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/theme/theme.dart';
import '../../onboarding/cubit/onboarding_cubit.dart';

class PhoneVerificationScreen extends StatefulWidget {
  const PhoneVerificationScreen({super.key});

  @override
  State<PhoneVerificationScreen> createState() => _PhoneVerificationScreenState();
}

class _PhoneVerificationScreenState extends State<PhoneVerificationScreen> {
  final _phoneController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _isValid = false;

  @override
  void dispose() {
    _phoneController.dispose();
    super.dispose();
  }

  void _onInputChanged(String value) {
    setState(() {
      _isValid = value.length == 10;
    });
  }

  void _submit() {
    if (_formKey.currentState!.validate()) {
      context.push('/otp/phone');
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = context.watch<OnboardingCubit>().state;
    final cubit = context.read<OnboardingCubit>();
    final String currentLang = state.langCode;

    return Scaffold(
      backgroundColor: KalyaThiruTheme.softIvory,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: KalyaThiruTheme.primaryMaroon),
          onPressed: () => context.pop(),
        ),
        title: Text(
          'KalyaThiru',
          style: GoogleFonts.sourceSerif4(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: KalyaThiruTheme.primaryMaroon,
          ),
        ),
        centerTitle: false,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: 12),
                // 1. Header Branding & Trust Signal
                Center(
                  child: Column(
                    children: [
                      Text(
                        currentLang == 'en' ? 'Phone Verification' : 'தொலைபேசி சரிபார்ப்பு',
                        style: GoogleFonts.sourceSerif4(
                          fontSize: 28,
                          fontWeight: FontWeight.w600,
                          color: KalyaThiruTheme.primaryMaroon,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(
                            Icons.verified_user,
                            size: 16,
                            color: KalyaThiruTheme.antiqueGold,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            '100% SECURE & VERIFIED',
                            style: GoogleFonts.nunitoSans(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 0.8,
                              color: KalyaThiruTheme.mutedGray,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),

                // 2. White Container Card
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(
                      color: KalyaThiruTheme.outlineBorder.withValues(alpha: 0.25),
                      width: 1.2,
                    ),
                    borderRadius: BorderRadius.circular(8),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.03),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  padding: const EdgeInsets.all(24.0),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Text(
                          currentLang == 'en' ? 'Create Your Account' : 'கணக்கை உருவாக்கவும்',
                          style: GoogleFonts.sourceSerif4(
                            fontSize: 22,
                            fontWeight: FontWeight.w600,
                            color: KalyaThiruTheme.darkCharcoal,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          currentLang == 'en'
                              ? 'Join TN Matrimony to find your perfect partner.'
                              : 'உங்கள் சரியான இணையைத் தேடத் தொடங்குங்கள்.',
                          style: GoogleFonts.nunitoSans(
                            fontSize: 14,
                            color: KalyaThiruTheme.mutedGray,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 24),

                        // Input label
                        Text(
                          'MOBILE NUMBER',
                          style: GoogleFonts.nunitoSans(
                            fontWeight: FontWeight.bold,
                            fontSize: 11,
                            letterSpacing: 0.8,
                            color: KalyaThiruTheme.mutedGray,
                          ),
                        ),
                        const SizedBox(height: 8),

                        // Phone Input Field Container
                        Container(
                          height: 56,
                          decoration: BoxDecoration(
                            color: KalyaThiruTheme.softIvory.withValues(alpha: 0.4),
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(
                              color: _isValid
                                  ? KalyaThiruTheme.primaryMaroon
                                  : KalyaThiruTheme.outlineBorder.withValues(alpha: 0.4),
                              width: _isValid ? 1.5 : 1.0,
                            ),
                          ),
                          child: Row(
                            children: [
                              // Icon & Country Prefix Area
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 12.0),
                                child: Row(
                                  children: [
                                    const Icon(
                                      Icons.call,
                                      size: 20,
                                      color: KalyaThiruTheme.mutedGray,
                                    ),
                                    const SizedBox(width: 8),
                                    Text(
                                      '+91',
                                      style: GoogleFonts.nunitoSans(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16,
                                        color: KalyaThiruTheme.darkCharcoal,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              // Vertical Separator
                              Container(
                                width: 1.0,
                                height: 28,
                                color: KalyaThiruTheme.outlineBorder.withValues(alpha: 0.3),
                              ),
                              const SizedBox(width: 12),
                              // Text Field
                              Expanded(
                                child: TextFormField(
                                  controller: _phoneController,
                                  keyboardType: TextInputType.phone,
                                  maxLength: 10,
                                  onChanged: _onInputChanged,
                                  style: GoogleFonts.nunitoSans(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: KalyaThiruTheme.darkCharcoal,
                                  ),
                                  cursorColor: KalyaThiruTheme.primaryMaroon,
                                  decoration: InputDecoration(
                                    counterText: '',
                                    border: InputBorder.none,
                                    enabledBorder: InputBorder.none,
                                    focusedBorder: InputBorder.none,
                                    contentPadding: const EdgeInsets.symmetric(vertical: 14),
                                    hintText: currentLang == 'en'
                                        ? 'Enter 10-digit number'
                                        : 'உங்களது கைப்பேசி எண்',
                                    hintStyle: GoogleFonts.nunitoSans(
                                      fontSize: 15,
                                      color: KalyaThiruTheme.mutedGray.withValues(alpha: 0.5),
                                      fontWeight: FontWeight.normal,
                                    ),
                                  ),
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return currentLang == 'en'
                                          ? 'Mobile number is required'
                                          : 'கைப்பேசி எண் தேவை';
                                    }
                                    if (value.length < 10) {
                                      return currentLang == 'en'
                                          ? 'Enter a valid 10-digit number'
                                          : 'சரியான கைப்பேசி எண்ணை உள்ளிடவும்';
                                    }
                                    return null;
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          currentLang == 'en'
                              ? '* We\'ll send an OTP to verify your account.'
                              : '* கணக்கைச் சரிபார்க்க OTP அனுப்புவோம்.',
                          style: GoogleFonts.nunitoSans(
                            fontSize: 11,
                            color: KalyaThiruTheme.mutedGray,
                            fontStyle: FontStyle.italic,
                          ),
                        ),
                        const SizedBox(height: 24),

                        // Get OTP Button
                        InkWell(
                          onTap: _submit,
                          child: Container(
                            height: 54,
                            decoration: BoxDecoration(
                              color: KalyaThiruTheme.primaryMaroon,
                              borderRadius: BorderRadius.circular(8),
                              boxShadow: [
                                BoxShadow(
                                  color: KalyaThiruTheme.primaryMaroon.withValues(alpha: 0.2),
                                  blurRadius: 10,
                                  offset: const Offset(0, 4),
                                ),
                              ],
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  currentLang == 'en' ? 'Get OTP' : 'OTP பெறுக',
                                  style: GoogleFonts.nunitoSans(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14,
                                    letterSpacing: 0.8,
                                  ),
                                ),
                                const SizedBox(width: 8),
                                const Icon(
                                  Icons.arrow_forward,
                                  color: Colors.white,
                                  size: 18,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 24),

                // 3. Alternative Registration Options
                Center(
                  child: Column(
                    children: [
                      Text(
                        currentLang == 'en'
                            ? "Don't have a phone handy?"
                            : "கைப்பேசி எண் இல்லையா?",
                        style: GoogleFonts.nunitoSans(
                          fontSize: 13,
                          color: KalyaThiruTheme.mutedGray,
                        ),
                      ),
                      const SizedBox(height: 4),
                      TextButton(
                        onPressed: () {
                          context.push('/register/email');
                        },
                        style: TextButton.styleFrom(
                          padding: EdgeInsets.zero,
                          minimumSize: Size.zero,
                          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        ),
                        child: Text(
                          currentLang == 'en' ? 'Verify via Email' : 'மின்னஞ்சல் மூலம் சரிபார்',
                          style: GoogleFonts.nunitoSans(
                            fontSize: 13,
                            fontWeight: FontWeight.bold,
                            color: KalyaThiruTheme.primaryMaroon,
                            decoration: TextDecoration.underline,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 36),

                // 4. Traditional South Indian Aesthetic Imagery Rows (Grayscale)
                Container(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: Row(
                    children: [
                      // Image 1: Gold Jewelry
                      Expanded(
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: ColorFiltered(
                            colorFilter: const ColorFilter.mode(
                              Colors.grey,
                              BlendMode.saturation,
                            ),
                            child: Image.network(
                              'https://lh3.googleusercontent.com/aida-public/AB6AXuA0VXyQolRsrsiiYYZV2PGiONlCON6P2F9ZwKItS8vKz4BZrI2qKKR0zFZAaYvyJSvFiDGYHzPLdVQsgJpgQ-fJp9EN-tQgUmRgZtQirXxDzBy_gIda764zNgvXuRh8iX1G8bSQ6IHHzvte0RV6yAQIn5__ZjqRENdq6YhAO7nNR1nxJYFgNZGcSP7LbVj7gukZEmz3FGq6PBzby8nK5glEAzL-rp8toAd7e-3S7XcXsxC6RHw5wliNHUry34Th5sE_N-pbAmlhhg4',
                              height: 100,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) =>
                                  Container(height: 100, color: Colors.grey[300]),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      // Image 2: Coffee Tumbler
                      Expanded(
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: ColorFiltered(
                            colorFilter: const ColorFilter.mode(
                              Colors.grey,
                              BlendMode.saturation,
                            ),
                            child: Image.network(
                              'https://lh3.googleusercontent.com/aida-public/AB6AXuC_J_RzyFKiAv9FPcfJNviRgE8ZUhugM6dE9LBLL_HZUg8VItSb2tejUyh4RA0l-o9c0kIJ7nXcrXcvw1p_Uw59JeJvOe1go02thYFr863aG2UWdi8KCuf9NSuDPI4hbv3r-50HT0JrfkPlqCKC5_9HZCAaHZpOniXIXUMa-cKtHeYb06eoCvKZFuIxLlMAHdiedOUISbEtIFAYP3Q_Jkd5hbPT3NtKVENGg1YsfhNXzTZmu58QGVKcuELpJwH0fHG1bCHVTMe1tdk',
                              height: 100,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) =>
                                  Container(height: 100, color: Colors.grey[300]),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      // Image 3: Temple Gopuram
                      Expanded(
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: ColorFiltered(
                            colorFilter: const ColorFilter.mode(
                              Colors.grey,
                              BlendMode.saturation,
                            ),
                            child: Image.network(
                              'https://lh3.googleusercontent.com/aida-public/AB6AXuBBs1ILsvA-i-pU6aLj10ktSUZu3l_kDjgU6dsGZg-JRAWOq1oZ73aT1gLZYZJGc-c2jMyNRc9wdYIY4LIrBYC61LdjQclREZsByEt7mLNj4Q1rrqAs_R9gw4kRGsU9g1eF8Y2rYpOEcwVVKb5ofdA_pxi4qhhVX1CqxlR4xgrBS6SgGJXzzCrUbr-sqoSMlkTvUQ14v7gGFLySDjVev7WAwfNjUOwMkiB3jsaTDLkGZQC-KCkmsaQo2dUgBM2u0pFTBxRLV64Gpys',
                              height: 100,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) =>
                                  Container(height: 100, color: Colors.grey[300]),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),

                // 5. Institutional Footer
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16.0),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Terms of Service',
                            style: GoogleFonts.nunitoSans(
                              fontSize: 12,
                              color: KalyaThiruTheme.mutedGray,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Text(
                            'Privacy Policy',
                            style: GoogleFonts.nunitoSans(
                              fontSize: 12,
                              color: KalyaThiruTheme.mutedGray,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Text(
                            'Trust & Safety',
                            style: GoogleFonts.nunitoSans(
                              fontSize: 12,
                              color: KalyaThiruTheme.mutedGray,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Text(
                        '© 2024 KalyaThiru Matrimony. All rights reserved.',
                        style: GoogleFonts.nunitoSans(
                          fontSize: 11,
                          color: KalyaThiruTheme.mutedGray.withValues(alpha: 0.7),
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
