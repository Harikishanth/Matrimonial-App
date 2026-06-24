import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/theme/theme.dart';
import '../../onboarding/cubit/onboarding_cubit.dart';

class EmailVerificationScreen extends StatefulWidget {
  const EmailVerificationScreen({Key? key}) : super(key: key);

  @override
  State<EmailVerificationScreen> createState() => _EmailVerificationScreenState();
}

class _EmailVerificationScreenState extends State<EmailVerificationScreen> {
  final _emailController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _isFocused = false;

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  void _submit() {
    if (_formKey.currentState!.validate()) {
      context.push('/otp/email');
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
                const SizedBox(height: 24),

                // 1. Main Content Card
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(
                      color: KalyaThiruTheme.outlineBorder.withOpacity(0.25),
                      width: 1.2,
                    ),
                    borderRadius: BorderRadius.circular(8),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.03),
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
                        // Mail Envelope Icon inside a light gold square container
                        Center(
                          child: Container(
                            width: 64,
                            height: 64,
                            decoration: BoxDecoration(
                              color: KalyaThiruTheme.antiqueGold.withOpacity(0.12),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: const Icon(
                              Icons.mail,
                              color: Color(0xFF735C00), // Dark Gold / Olive
                              size: 28,
                            ),
                          ),
                        ),
                        const SizedBox(height: 24),

                        Text(
                          currentLang == 'en' ? 'Email Verification' : 'மின்னஞ்சல் சரிபார்ப்பு',
                          style: GoogleFonts.sourceSerif4(
                            fontSize: 20,
                            fontWeight: FontWeight.w600,
                            color: KalyaThiruTheme.darkCharcoal,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          currentLang == 'en'
                              ? 'Enter your email address to secure your account and receive important match alerts tailored to your heritage.'
                              : 'உங்கள் கணக்கைப் பாதுகாக்கவும், உங்கள் பாரம்பரியத்திற்கு ஏற்ப முக்கியமான வரன் விபரங்களைப் பெறவும் மின்னஞ்சல் முகவரியை உள்ளிடவும்.',
                          style: GoogleFonts.nunitoSans(
                            fontSize: 14,
                            color: KalyaThiruTheme.mutedGray,
                            height: 1.4,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 32),

                        // Input label
                        Text(
                          'PRIMARY EMAIL ADDRESS',
                          style: GoogleFonts.nunitoSans(
                            fontWeight: FontWeight.bold,
                            fontSize: 11,
                            letterSpacing: 0.8,
                            color: KalyaThiruTheme.mutedGray,
                          ),
                        ),
                        const SizedBox(height: 8),

                        // Email Input Field Container
                        Focus(
                          onFocusChange: (focus) {
                            setState(() {
                              _isFocused = focus;
                            });
                          },
                          child: Container(
                            height: 56,
                            decoration: BoxDecoration(
                              color: KalyaThiruTheme.softIvory.withOpacity(0.4),
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(
                                color: _isFocused
                                    ? KalyaThiruTheme.primaryMaroon
                                    : KalyaThiruTheme.outlineBorder.withOpacity(0.4),
                                width: _isFocused ? 1.5 : 1.0,
                              ),
                            ),
                            child: Row(
                              children: [
                                const Padding(
                                  padding: EdgeInsets.symmetric(horizontal: 16.0),
                                  child: Icon(
                                    Icons.email_outlined,
                                    size: 20,
                                    color: KalyaThiruTheme.mutedGray,
                                  ),
                                ),
                                Expanded(
                                  child: TextFormField(
                                    controller: _emailController,
                                    keyboardType: TextInputType.emailAddress,
                                    style: GoogleFonts.nunitoSans(
                                      fontSize: 16,
                                      color: KalyaThiruTheme.darkCharcoal,
                                    ),
                                    cursorColor: KalyaThiruTheme.primaryMaroon,
                                    decoration: InputDecoration(
                                      border: InputBorder.none,
                                      enabledBorder: InputBorder.none,
                                      focusedBorder: InputBorder.none,
                                      contentPadding: const EdgeInsets.symmetric(vertical: 14),
                                      hintText: 'e.g. aditya.kumar@example.com',
                                      hintStyle: GoogleFonts.nunitoSans(
                                        fontSize: 15,
                                        color: KalyaThiruTheme.mutedGray.withOpacity(0.4),
                                      ),
                                    ),
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return currentLang == 'en'
                                            ? 'Email is required'
                                            : 'மின்னஞ்சல் முகவரி தேவை';
                                      }
                                      final emailRegex = RegExp(
                                          r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
                                      if (!emailRegex.hasMatch(value)) {
                                        return currentLang == 'en'
                                            ? 'Enter a valid email address'
                                            : 'சரியான மின்னஞ்சலை உள்ளிடவும்';
                                      }
                                      return null;
                                    },
                                  ),
                                ),
                              ],
                            ),
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
                                  color: KalyaThiruTheme.primaryMaroon.withOpacity(0.2),
                                  blurRadius: 10,
                                  offset: const Offset(0, 4),
                                ),
                              ],
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  currentLang == 'en' ? 'Get OTP on Email' : 'மின்னஞ்சலுக்கு OTP பெறுக',
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
                        const SizedBox(height: 32),

                        // Toggle Option: Mobile Verification
                        InkWell(
                          onTap: () {
                            context.push('/register/phone');
                          },
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(
                                Icons.phone_android_outlined,
                                size: 18,
                                color: KalyaThiruTheme.primaryMaroon,
                              ),
                              const SizedBox(width: 8),
                              Text(
                                currentLang == 'en'
                                    ? 'Prefer using your phone? Verify via Mobile Number'
                                    : 'தொலைபேசி எண் மூலம் சரிபார்க்க விரும்புகிறீர்களா?',
                                style: GoogleFonts.nunitoSans(
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                  color: KalyaThiruTheme.primaryMaroon,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 48),

                // 2. Trust Seals Grid
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _buildTrustBadge(Icons.check_circle_outline, '100% SECURE & VERIFIED'),
                    _buildTrustBadge(Icons.security, 'DATA ENCRYPTED'),
                    _buildTrustBadge(Icons.people_outline, 'TAMIL ROOTS'),
                  ],
                ),
                const SizedBox(height: 48),

                // 3. Footer Links
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
                          color: KalyaThiruTheme.mutedGray.withOpacity(0.7),
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

  Widget _buildTrustBadge(IconData icon, String text) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          icon,
          size: 20,
          color: KalyaThiruTheme.antiqueGold,
        ),
        const SizedBox(height: 6),
        Text(
          text,
          style: GoogleFonts.nunitoSans(
            fontSize: 9,
            fontWeight: FontWeight.bold,
            letterSpacing: 0.5,
            color: KalyaThiruTheme.mutedGray,
          ),
        ),
      ],
    );
  }
}
