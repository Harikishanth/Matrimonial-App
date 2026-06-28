import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/theme.dart';
import '../../../core/translation/translations.dart';
import '../../onboarding/cubit/onboarding_cubit.dart';

class LanguageSelectionScreen extends StatelessWidget {
  const LanguageSelectionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<OnboardingCubit>();

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 32.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Spacer(flex: 2),
              // Top Mandala Icon
              Center(
                child: Container(
                  width: 120,
                  height: 120,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: KalyaThiruTheme.auraGold,
                    boxShadow: [
                      BoxShadow(
                        color: KalyaThiruTheme.antiqueGold.withValues(alpha: 0.3),
                        blurRadius: 16,
                        spreadRadius: 2,
                      )
                    ],
                  ),
                  child: const Icon(
                    Icons.temple_hindu,
                    size: 60,
                    color: KalyaThiruTheme.primaryMaroon,
                  ),
                ),
              ),
              const SizedBox(height: 40),
              // Main Headings
              Center(
                child: Text(
                  'KalyaThiru',
                  style: Theme.of(context).textTheme.displayLarge?.copyWith(
                        color: KalyaThiruTheme.primaryMaroon,
                      ),
                ),
              ),
              const SizedBox(height: 8),
              Center(
                child: Text(
                  'Heritage Matchmaking (பாரம்பரிய வரன் தேடல்)',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: KalyaThiruTheme.mutedGray,
                        fontWeight: FontWeight.bold,
                      ),
                  textAlign: TextAlign.center,
                ),
              ),
              const Spacer(),
              // Instruction
              Text(
                'Choose Your Language / மொழியைத் தேர்ந்தெடுக்கவும்',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      color: KalyaThiruTheme.primaryDark,
                      fontWeight: FontWeight.bold,
                    ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              // Language Selection Cards
              _buildLanguageCard(
                context,
                title: 'English',
                subtitle: 'Continue in English',
                onTap: () {
                  cubit.updateLanguage('en');
                  context.go('/splash');
                },
              ),
              const SizedBox(height: 16),
              _buildLanguageCard(
                context,
                title: 'தமிழ்',
                subtitle: 'தமிழில் தொடரவும்',
                onTap: () {
                  cubit.updateLanguage('ta');
                  context.go('/splash');
                },
              ),
              const Spacer(flex: 2),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLanguageCard(
    BuildContext context, {
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(4),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(color: KalyaThiruTheme.outlineBorder, width: 1.2),
          borderRadius: BorderRadius.circular(4),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                        color: KalyaThiruTheme.primaryMaroon,
                        fontWeight: FontWeight.bold,
                      ),
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: KalyaThiruTheme.mutedGray,
                      ),
                ),
              ],
            ),
            const Icon(
              Icons.arrow_forward_ios,
              color: KalyaThiruTheme.antiqueGold,
              size: 18,
            ),
          ],
        ),
      ),
    );
  }
}
