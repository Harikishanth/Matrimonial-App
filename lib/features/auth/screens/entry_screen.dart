import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/theme/theme.dart';
import '../../../core/translation/translations.dart';
import '../../onboarding/cubit/onboarding_cubit.dart';

class EntryScreen extends StatelessWidget {
  const EntryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final state = context.watch<OnboardingCubit>().state;
    final cubit = context.read<OnboardingCubit>();
    final String currentLang = state.langCode;

    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          // 1. Hero Background Layer (Traditional South Indian temple interior corridor)
          Image.network(
            'https://images.unsplash.com/photo-1542157585-ef20fbce81e6?ixlib=rb-4.0.3&auto=format&fit=crop&w=1200&q=80',
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) {
              return Container(color: KalyaThiruTheme.softIvory);
            },
          ),
          
          // 2. Opacity and Blend layer to replicate mix-blend-multiply of HTML design
          Container(
            color: KalyaThiruTheme.softIvory.withValues(alpha: 0.55),
          ),

          // 3. Vignette & text protection gradients
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    KalyaThiruTheme.softIvory,
                    KalyaThiruTheme.softIvory.withValues(alpha: 0.8),
                    KalyaThiruTheme.softIvory.withValues(alpha: 0.3),
                    Colors.transparent,
                  ],
                  begin: Alignment.bottomCenter,
                  end: Alignment.topCenter,
                  stops: const [0.0, 0.45, 0.75, 1.0],
                ),
              ),
            ),
          ),
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    KalyaThiruTheme.softIvory.withValues(alpha: 0.35),
                    Colors.transparent,
                  ],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
            ),
          ),

          // 4. Content Canvas
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 24.0),
              child: Column(
                children: [
                  // Top Spacer (replaces the App Bar to give editorial breathing room)
                  const Spacer(flex: 2),

                  // Heritage Motif / Trust Seal representation
                  Container(
                    width: 110,
                    height: 110,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: KalyaThiruTheme.softIvory.withValues(alpha: 0.6),
                      border: Border.all(
                        color: KalyaThiruTheme.antiqueGold.withValues(alpha: 0.4),
                        width: 2,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.04),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: KalyaThiruTheme.antiqueGold.withValues(alpha: 0.25),
                          width: 1,
                        ),
                      ),
                      child: const Center(
                        child: Icon(
                          Icons.temple_hindu,
                          size: 52,
                          color: KalyaThiruTheme.primaryMaroon,
                        ),
                      ),
                    ),
                  ),
                  
                  const SizedBox(height: 24),

                  // Brand Typography
                  Text(
                    'KALYATHIRU',
                    style: GoogleFonts.sourceSerif4(
                      fontSize: 42,
                      fontWeight: FontWeight.w700,
                      color: KalyaThiruTheme.primaryMaroon,
                      letterSpacing: -0.5,
                      height: 1.1,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  
                  const SizedBox(height: 12),

                  // Tagline / Editorial title
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Text(
                      currentLang == 'en'
                          ? 'Where Trust Meets Tamil Tradition'
                          : 'நிச்சயிக்கப்பட்ட நம்பிக்கையின் சங்கமம்',
                      style: GoogleFonts.sourceSerif4(
                        fontSize: 22,
                        fontWeight: FontWeight.w600,
                        color: KalyaThiruTheme.darkCharcoal,
                        height: 1.3,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),

                  const SizedBox(height: 20),

                  // Divider element (Line - Circle - Line)
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        width: 36,
                        height: 1,
                        color: KalyaThiruTheme.outlineBorder.withValues(alpha: 0.3),
                      ),
                      const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 8.0),
                        child: CircleAvatar(
                          radius: 3.5,
                          backgroundColor: KalyaThiruTheme.antiqueGold,
                        ),
                      ),
                      Container(
                        width: 36,
                        height: 1,
                        color: KalyaThiruTheme.outlineBorder.withValues(alpha: 0.3),
                      ),
                    ],
                  ),

                  const Spacer(flex: 3),

                  // Bottom CTA Area
                  ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 400),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        // Primary CTA: Register
                        InkWell(
                          onTap: () {
                            cubit.clearState();
                            context.push('/register/phone');
                          },
                          child: Container(
                            height: 54,
                            decoration: BoxDecoration(
                              color: KalyaThiruTheme.primaryMaroon,
                              borderRadius: BorderRadius.circular(4),
                              boxShadow: [
                                BoxShadow(
                                  color: KalyaThiruTheme.primaryMaroon.withValues(alpha: 0.25),
                                  blurRadius: 12,
                                  offset: const Offset(0, 4),
                                ),
                              ],
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  currentLang == 'en'
                                      ? 'REGISTER / REGISTRATION'
                                      : 'பதிவு செய்யுங்கள்',
                                  style: GoogleFonts.nunitoSans(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14,
                                    letterSpacing: 1.2,
                                    color: Colors.white,
                                  ),
                                ),
                                const SizedBox(width: 8),
                                const Icon(
                                  Icons.arrow_right_alt,
                                  color: Colors.white,
                                  size: 20,
                                ),
                              ],
                            ),
                          ),
                        ),
                        
                        const SizedBox(height: 16),

                        // Secondary CTA: Login
                        InkWell(
                          onTap: () {
                            context.push('/login');
                          },
                          child: Container(
                            height: 54,
                            decoration: BoxDecoration(
                              color: KalyaThiruTheme.softIvory.withValues(alpha: 0.8),
                              borderRadius: BorderRadius.circular(4),
                              border: Border.all(
                                color: KalyaThiruTheme.outlineBorder.withValues(alpha: 0.3),
                                width: 1.2,
                              ),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Icon(
                                  Icons.login,
                                  color: KalyaThiruTheme.darkCharcoal,
                                  size: 18,
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  currentLang == 'en'
                                      ? 'Already have an account? Login'
                                      : 'உள்நுழைக',
                                  style: GoogleFonts.nunitoSans(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14,
                                    color: KalyaThiruTheme.darkCharcoal,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  
                  const SizedBox(height: 24),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

