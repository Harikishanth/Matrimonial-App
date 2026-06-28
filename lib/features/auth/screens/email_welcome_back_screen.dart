import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/theme/theme.dart';
import '../../onboarding/cubit/onboarding_cubit.dart';

class EmailWelcomeBackScreen extends StatefulWidget {
  const EmailWelcomeBackScreen({super.key});

  @override
  State<EmailWelcomeBackScreen> createState() => _EmailWelcomeBackScreenState();
}

class _EmailWelcomeBackScreenState extends State<EmailWelcomeBackScreen> {
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

                // Card Container
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
                        // Temple building silhouette icon in small rounded container
                        Center(
                          child: Container(
                            width: 64,
                            height: 64,
                            decoration: BoxDecoration(
                              color: KalyaThiruTheme.primaryMaroon.withValues(alpha: 0.08),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: const Icon(
                              Icons.apartment_outlined, // Temple shape approximation
                              color: KalyaThiruTheme.primaryMaroon,
                              size: 32,
                            ),
                          ),
                        ),
                        const SizedBox(height: 24),

                        Text(
                          currentLang == 'en' ? 'Welcome Back' : 'மீண்டும் வருக',
                          style: GoogleFonts.sourceSerif4(
                            fontSize: 26,
                            fontWeight: FontWeight.bold,
                            color: KalyaThiruTheme.primaryMaroon,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          currentLang == 'en'
                              ? 'Enter your registered email address to login'
                              : 'உள்நுழைய உங்கள் மின்னஞ்சல் முகவரியை உள்ளிடவும்',
                          style: GoogleFonts.nunitoSans(
                            fontSize: 14,
                            color: KalyaThiruTheme.mutedGray,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 28),

                        // Input Label
                        Text(
                          'REGISTERED EMAIL',
                          style: GoogleFonts.nunitoSans(
                            fontWeight: FontWeight.bold,
                            fontSize: 11,
                            letterSpacing: 0.8,
                            color: KalyaThiruTheme.mutedGray,
                          ),
                        ),
                        const SizedBox(height: 8),

                        // Input Field Container
                        Focus(
                          onFocusChange: (focus) {
                            setState(() {
                              _isFocused = focus;
                            });
                          },
                          child: Container(
                            height: 56,
                            decoration: BoxDecoration(
                              color: KalyaThiruTheme.softIvory.withValues(alpha: 0.4),
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(
                                color: _isFocused
                                    ? KalyaThiruTheme.primaryMaroon
                                    : KalyaThiruTheme.outlineBorder.withValues(alpha: 0.4),
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
                                      hintText: 'name@example.com',
                                      hintStyle: GoogleFonts.nunitoSans(
                                        fontSize: 15,
                                        color: KalyaThiruTheme.mutedGray.withValues(alpha: 0.4),
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
                        const SizedBox(height: 20),

                        // OR divider
                        Row(
                          children: [
                            Expanded(
                              child: Container(
                                height: 1.0,
                                color: KalyaThiruTheme.outlineBorder.withValues(alpha: 0.15),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 16.0),
                              child: Text(
                                'OR',
                                style: GoogleFonts.nunitoSans(
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                  color: KalyaThiruTheme.mutedGray,
                                ),
                              ),
                            ),
                            Expanded(
                              child: Container(
                                height: 1.0,
                                color: KalyaThiruTheme.outlineBorder.withValues(alpha: 0.15),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),

                        // Login via Mobile Number button
                        OutlinedButton.icon(
                          onPressed: () {
                            context.push('/login/phone');
                          },
                          icon: const Icon(
                            Icons.phone_android_outlined,
                            size: 18,
                            color: KalyaThiruTheme.primaryMaroon,
                          ),
                          label: Text(
                            currentLang == 'en' ? 'Login via Mobile Number' : 'கைப்பேசி எண் மூலம் உள்நுழைக',
                            style: GoogleFonts.nunitoSans(
                              fontWeight: FontWeight.bold,
                              fontSize: 13,
                              color: KalyaThiruTheme.darkCharcoal,
                            ),
                          ),
                          style: OutlinedButton.styleFrom(
                            side: BorderSide(
                              color: KalyaThiruTheme.outlineBorder.withValues(alpha: 0.3),
                              width: 1.0,
                            ),
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                        ),
                        const SizedBox(height: 24),

                        // Register CTA Link
                        Center(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                currentLang == 'en' ? "Don't have an account? " : 'கணக்கு இல்லையா? ',
                                style: GoogleFonts.nunitoSans(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w600,
                                  color: KalyaThiruTheme.darkCharcoal,
                                ),
                              ),
                              TextButton(
                                onPressed: () {
                                  context.push('/register/phone');
                                },
                                style: TextButton.styleFrom(
                                  padding: EdgeInsets.zero,
                                  minimumSize: Size.zero,
                                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                ),
                                child: Text(
                                  currentLang == 'en' ? 'Register Now' : 'இப்போதே பதிவு செய்யவும்',
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
                        const SizedBox(height: 24),

                        // Secure Badges INSIDE the card container
                        Container(
                          padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 8.0),
                          decoration: BoxDecoration(
                            color: KalyaThiruTheme.softIvory,
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              Row(
                                children: [
                                  const Icon(
                                    Icons.lock_outline,
                                    size: 16,
                                    color: KalyaThiruTheme.antiqueGold,
                                  ),
                                  const SizedBox(width: 6),
                                  Text(
                                    '100% SECURE',
                                    style: GoogleFonts.nunitoSans(
                                      fontSize: 11,
                                      fontWeight: FontWeight.bold,
                                      color: KalyaThiruTheme.darkCharcoal,
                                      letterSpacing: 0.5,
                                    ),
                                  ),
                                ],
                              ),
                              Row(
                                children: [
                                  const Icon(
                                    Icons.verified_user_outlined,
                                    size: 16,
                                    color: KalyaThiruTheme.antiqueGold,
                                  ),
                                  const SizedBox(width: 6),
                                  Text(
                                    'VERIFIED PROFILES',
                                    style: GoogleFonts.nunitoSans(
                                      fontSize: 11,
                                      fontWeight: FontWeight.bold,
                                      color: KalyaThiruTheme.darkCharcoal,
                                      letterSpacing: 0.5,
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
                ),
                const SizedBox(height: 24),

                // Terms disclaimer (below the card)
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Text(
                    currentLang == 'en'
                        ? 'By continuing, you agree to our Terms of Service and Privacy Policy.'
                        : 'தொடர்வதன் மூலம், எங்கள் சேவை விதிமுறைகள் மற்றும் தனியுரிமைக் கொள்கையை நீங்கள் ஒப்புக்கொள்கிறீர்கள்.',
                    style: GoogleFonts.nunitoSans(
                      fontSize: 11,
                      color: KalyaThiruTheme.mutedGray.withValues(alpha: 0.8),
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                const SizedBox(height: 24),

                // Footer Links & Copyright Info
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
