import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/theme/theme.dart';
import '../../onboarding/cubit/onboarding_cubit.dart';

class PhoneOtpScreen extends StatefulWidget {
  const PhoneOtpScreen({Key? key}) : super(key: key);

  @override
  State<PhoneOtpScreen> createState() => _PhoneOtpScreenState();
}

class _PhoneOtpScreenState extends State<PhoneOtpScreen> {
  final List<TextEditingController> _controllers = List.generate(6, (_) => TextEditingController());
  final List<FocusNode> _focusNodes = List.generate(6, (_) => FocusNode());

  @override
  void dispose() {
    for (var c in _controllers) {
      c.dispose();
    }
    for (var f in _focusNodes) {
      f.dispose();
    }
    super.dispose();
  }

  void _verify() {
    String otp = _controllers.map((c) => c.text).join();
    if (otp.length < 6) {
      // Prototype default fallback
      otp = '123456';
    }
    context.go('/onboarding/step1');
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
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      // Shield Check Icon inside soft red/pink circle
                      Center(
                        child: Container(
                          width: 64,
                          height: 64,
                          decoration: BoxDecoration(
                            color: const Color(0xFFFFE5E5), // Light pink/red
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.verified_user,
                            color: KalyaThiruTheme.primaryMaroon,
                            size: 28,
                          ),
                        ),
                      ),
                      const SizedBox(height: 24),

                      Text(
                        currentLang == 'en' ? 'Verify Your Number' : 'எண்ணை சரிபார்க்கவும்',
                        style: GoogleFonts.sourceSerif4(
                          fontSize: 26,
                          fontWeight: FontWeight.w600,
                          color: KalyaThiruTheme.primaryMaroon,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 12),

                      Text(
                        currentLang == 'en'
                            ? 'Enter the 6-digit code sent to +91 XXXXX XXXXX'
                            : '+91 XXXXX XXXXX எண்ணிற்கு அனுப்பப்பட்ட 6 இலக்க குறியீட்டை உள்ளிடவும்',
                        style: GoogleFonts.nunitoSans(
                          fontSize: 14,
                          color: KalyaThiruTheme.darkCharcoal,
                          height: 1.4,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 8),

                      // Edit Number
                      Center(
                        child: TextButton(
                          onPressed: () {
                            context.pop();
                          },
                          style: TextButton.styleFrom(
                            padding: EdgeInsets.zero,
                            minimumSize: Size.zero,
                            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                          ),
                          child: Text(
                            currentLang == 'en' ? 'Edit Number' : 'எண்ணைத் திருத்தவும்',
                            style: GoogleFonts.nunitoSans(
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                              color: KalyaThiruTheme.antiqueGold,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 28),

                      // 6 digit verification boxes
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: List.generate(6, (index) {
                          return SizedBox(
                            width: 44,
                            height: 52,
                            child: TextField(
                              controller: _controllers[index],
                              focusNode: _focusNodes[index],
                              keyboardType: TextInputType.number,
                              textAlign: TextAlign.center,
                              maxLength: 1,
                              style: GoogleFonts.nunitoSans(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: KalyaThiruTheme.darkCharcoal,
                              ),
                              cursorColor: KalyaThiruTheme.primaryMaroon,
                              decoration: InputDecoration(
                                counterText: '',
                                contentPadding: EdgeInsets.zero,
                                enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                    color: KalyaThiruTheme.outlineBorder.withOpacity(0.5),
                                    width: 1.2,
                                  ),
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: const BorderSide(
                                    color: KalyaThiruTheme.primaryMaroon,
                                    width: 1.8,
                                  ),
                                  borderRadius: BorderRadius.circular(4),
                                ),
                              ),
                              onChanged: (value) {
                                if (value.isNotEmpty) {
                                  if (index < 5) {
                                    _focusNodes[index + 1].requestFocus();
                                  } else {
                                    _focusNodes[index].unfocus();
                                  }
                                } else {
                                  if (index > 0) {
                                    _focusNodes[index - 1].requestFocus();
                                  }
                                }
                              },
                            ),
                          );
                        }),
                      ),
                      const SizedBox(height: 24),

                      // Resend Code
                      Center(
                        child: TextButton(
                          onPressed: () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                  currentLang == 'en' ? 'OTP Resent' : 'OTP மீண்டும் அனுப்பப்பட்டது',
                                  style: GoogleFonts.nunitoSans(),
                                ),
                                backgroundColor: KalyaThiruTheme.primaryMaroon,
                              ),
                            );
                          },
                          child: Text(
                            currentLang == 'en' ? 'Resend OTP Now' : 'OTP ஐ மீண்டும் அனுப்பவும்',
                            style: GoogleFonts.nunitoSans(
                              fontSize: 13,
                              fontWeight: FontWeight.bold,
                              color: KalyaThiruTheme.primaryMaroon,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 24),

                      // Verify & Proceed Button
                      InkWell(
                        onTap: _verify,
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
                          child: Center(
                            child: Text(
                              currentLang == 'en' ? 'VERIFY & PROCEED' : 'சரிபார்த்து தொடரவும்',
                              style: GoogleFonts.nunitoSans(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 13,
                                letterSpacing: 1.0,
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 24),

                      // Divider
                      Container(
                        height: 1.0,
                        color: KalyaThiruTheme.outlineBorder.withOpacity(0.15),
                      ),
                      const SizedBox(height: 16),

                      // Having trouble? Get Help
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            currentLang == 'en' ? 'Having trouble? ' : 'பிரச்சனை உள்ளதா? ',
                            style: GoogleFonts.nunitoSans(
                              fontSize: 13,
                              color: KalyaThiruTheme.mutedGray,
                            ),
                          ),
                          Text(
                            currentLang == 'en' ? 'Get Help' : 'உதவி பெறுக',
                            style: GoogleFonts.nunitoSans(
                              fontSize: 13,
                              fontWeight: FontWeight.bold,
                              color: KalyaThiruTheme.primaryMaroon,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 48),

                // Footer Bottom Branding
                Center(
                  child: Column(
                    children: [
                      Text(
                        'KalyaThiru',
                        style: GoogleFonts.sourceSerif4(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: KalyaThiruTheme.primaryMaroon,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Privacy Policy',
                            style: GoogleFonts.nunitoSans(
                              fontSize: 12,
                              color: KalyaThiruTheme.mutedGray,
                            ),
                          ),
                          const SizedBox(width: 16),
                          Text(
                            'Terms of Service',
                            style: GoogleFonts.nunitoSans(
                              fontSize: 12,
                              color: KalyaThiruTheme.mutedGray,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Text(
                        'Trust & Safety',
                        style: GoogleFonts.nunitoSans(
                          fontSize: 12,
                          color: KalyaThiruTheme.mutedGray,
                        ),
                      ),
                      const SizedBox(height: 24),
                      Text(
                        '© 2024 KalyaThiru Matrimony. All rights reserved.',
                        style: GoogleFonts.nunitoSans(
                          fontSize: 11,
                          color: KalyaThiruTheme.mutedGray.withOpacity(0.7),
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 24),
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
