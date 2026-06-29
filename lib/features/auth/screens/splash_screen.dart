import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/theme.dart';
import '../../../core/translation/translations.dart';
import '../../onboarding/cubit/onboarding_cubit.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1800),
    )..repeat(reverse: true);

    _scaleAnimation = Tween<double>(begin: 0.95, end: 1.05).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );

    _navigateToNext();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  Future<void> _navigateToNext() async {
    await Future.delayed(const Duration(milliseconds: 2500));
    if (mounted) {
      context.go('/entry');
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = context.watch<OnboardingCubit>().state;
    final String welcomeText = AppTranslations.translate('welcome_title', state.langCode);

    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          // Background soft gradient
          Container(color: KalyaThiruTheme.softIvory),
          // Pulsing Logo and Title
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ScaleTransition(
                scale: _scaleAnimation,
                child: Container(
                  width: 140,
                  height: 140,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: KalyaThiruTheme.auraGold,
                    boxShadow: [
                      BoxShadow(
                        color: KalyaThiruTheme.antiqueGold.withValues(alpha: 0.3),
                        blurRadius: 24,
                        spreadRadius: 4,
                      )
                    ],
                  ),
                  child: const Icon(
                    Icons.temple_hindu,
                    size: 70,
                    color: KalyaThiruTheme.primaryMaroon,
                  ),
                ),
              ),
              const SizedBox(height: 32),
              Text(
                welcomeText,
                style: Theme.of(context).textTheme.displayLarge?.copyWith(
                      color: KalyaThiruTheme.primaryMaroon,
                      letterSpacing: 1.5,
                    ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 12),
              Text(
                AppTranslations.translate('welcome_pitch', state.langCode),
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: KalyaThiruTheme.mutedGray,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 0.8,
                    ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
          // Footer
          Positioned(
            bottom: 40,
            left: 0,
            right: 0,
            child: Text(
              AppTranslations.translate('heritage_trust_note', state.langCode),
              style: Theme.of(context).textTheme.labelMedium?.copyWith(
                    letterSpacing: 0.5,
                  ),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }
}
