import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../features/auth/screens/language_selection_screen.dart';
import '../../features/auth/screens/splash_screen.dart';
import '../../features/auth/screens/entry_screen.dart';
import '../../features/auth/screens/phone_verification_screen.dart';
import '../../features/auth/screens/email_verification_screen.dart';
import '../../features/auth/screens/phone_welcome_back_screen.dart';
import '../../features/auth/screens/email_welcome_back_screen.dart';
import '../../features/auth/screens/phone_otp_screen.dart';
import '../../features/auth/screens/email_otp_screen.dart';
import '../../features/onboarding/screens/onboarding_screens.dart';
import '../../features/home/screens/home_screen.dart';
import '../../features/profile/models/profile_model.dart';
import '../../features/profile/screens/profile_detail_screen.dart';
import '../../features/communication/screens/communication_center_screen.dart';
import '../../features/interests/screens/interests_screen.dart';
import '../../features/profile/screens/profile_menu_screen.dart';
import '../../features/profile/screens/settings_screen.dart';
import '../../features/profile/screens/matches_feed_screen.dart';
import '../../features/profile/screens/selected_matches_screen.dart';

class AppRoutes {
  static CustomTransitionPage _slideTransition(BuildContext context, GoRouterState state, Widget child) {
    return CustomTransitionPage(
      key: state.pageKey,
      child: child,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        return SlideTransition(
          position: animation.drive(
            Tween<Offset>(
              begin: const Offset(1.0, 0.0),
              end: Offset.zero,
            ).chain(CurveTween(curve: Curves.easeInOut)),
          ),
          child: child,
        );
      },
    );
  }

  static final GoRouter router = GoRouter(
    initialLocation: '/home',
    routes: [
      // Language Selection (New first screen)
      GoRoute(
        path: '/',
        pageBuilder: (context, state) => _slideTransition(
          context,
          state,
          const LanguageSelectionScreen(),
        ),
      ),
      // Splash Screen
      GoRoute(
        path: '/splash',
        pageBuilder: (context, state) => _slideTransition(
          context,
          state,
          const SplashScreen(),
        ),
      ),
      // Entry Landing Screen
      GoRoute(
        path: '/entry',
        pageBuilder: (context, state) => _slideTransition(
          context,
          state,
          const EntryScreen(),
        ),
      ),
      // Phone Login (Default /login)
      GoRoute(
        path: '/login',
        pageBuilder: (context, state) => _slideTransition(
          context,
          state,
          const PhoneWelcomeBackScreen(),
        ),
      ),
      // Alternate Auth routes matching Stitch designs
      GoRoute(
        path: '/login/phone',
        pageBuilder: (context, state) => _slideTransition(
          context,
          state,
          const PhoneWelcomeBackScreen(),
        ),
      ),
      GoRoute(
        path: '/login/email',
        pageBuilder: (context, state) => _slideTransition(
          context,
          state,
          const EmailWelcomeBackScreen(),
        ),
      ),
      GoRoute(
        path: '/register/phone',
        pageBuilder: (context, state) => _slideTransition(
          context,
          state,
          const PhoneVerificationScreen(),
        ),
      ),
      GoRoute(
        path: '/register/email',
        pageBuilder: (context, state) => _slideTransition(
          context,
          state,
          const EmailVerificationScreen(),
        ),
      ),
      // Default OTP route
      GoRoute(
        path: '/otp',
        pageBuilder: (context, state) => _slideTransition(
          context,
          state,
          const PhoneOtpScreen(),
        ),
      ),
      GoRoute(
        path: '/otp/phone',
        pageBuilder: (context, state) => _slideTransition(
          context,
          state,
          const PhoneOtpScreen(),
        ),
      ),
      GoRoute(
        path: '/otp/email',
        pageBuilder: (context, state) => _slideTransition(
          context,
          state,
          const EmailOtpScreen(),
        ),
      ),
      // Onboarding Screens (Steps 1 to 11)
      GoRoute(
        path: '/onboarding/step1',
        pageBuilder: (context, state) => _slideTransition(context, state, const OnboardingStep1Screen()),
      ),
      GoRoute(
        path: '/onboarding/step2',
        pageBuilder: (context, state) => _slideTransition(context, state, const OnboardingStep2Screen()),
      ),
      GoRoute(
        path: '/onboarding/step3',
        pageBuilder: (context, state) => _slideTransition(context, state, const OnboardingStep3Screen()),
      ),
      GoRoute(
        path: '/onboarding/step4',
        pageBuilder: (context, state) => _slideTransition(context, state, const OnboardingStep4Screen()),
      ),
      GoRoute(
        path: '/onboarding/step5',
        pageBuilder: (context, state) => _slideTransition(context, state, const OnboardingStep5Screen()),
      ),
      GoRoute(
        path: '/onboarding/step6',
        pageBuilder: (context, state) => _slideTransition(context, state, const OnboardingStep6Screen()),
      ),
      GoRoute(
        path: '/onboarding/step7',
        pageBuilder: (context, state) => _slideTransition(context, state, const OnboardingStep7Screen()),
      ),
      GoRoute(
        path: '/onboarding/step8',
        pageBuilder: (context, state) => _slideTransition(context, state, const OnboardingStep8Screen()),
      ),
      GoRoute(
        path: '/onboarding/step9',
        pageBuilder: (context, state) => _slideTransition(context, state, const OnboardingStep9Screen()),
      ),
      GoRoute(
        path: '/onboarding/step10',
        pageBuilder: (context, state) => _slideTransition(context, state, const OnboardingStep10Screen()),
      ),
      GoRoute(
        path: '/onboarding/step11',
        pageBuilder: (context, state) => _slideTransition(context, state, const OnboardingStep11Screen()),
      ),
      // Home Dashboard Feed Screen
      GoRoute(
        path: '/home',
        pageBuilder: (context, state) => _slideTransition(
          context,
          state,
          const HomeScreen(),
        ),
      ),
      // Profile Detail Screen
      GoRoute(
        path: '/profile',
        pageBuilder: (context, state) {
          final profile = state.extra as ProfileModel;
          return _slideTransition(
            context,
            state,
            ProfileDetailScreen(profile: profile),
          );
        },
      ),
      // Communication Center Screen
      GoRoute(
        path: '/communication',
        pageBuilder: (context, state) {
          final extra = state.extra as Map<String, dynamic>?;
          final isPaid = extra?['isPaidMember'] as bool? ?? false;
          return _slideTransition(
            context,
            state,
            CommunicationCenterScreen(isPaidMember: isPaid),
          );
        },
      ),
      // Interests Screen
      GoRoute(
        path: '/interests',
        pageBuilder: (context, state) {
          final extra = state.extra as Map<String, dynamic>?;
          final isPaid = extra?['isPaidMember'] as bool? ?? false;
          return _slideTransition(
            context,
            state,
            InterestsScreen(isPaidMember: isPaid),
          );
        },
      ),
      // Profile Menu (Sandwich Screen)
      GoRoute(
        path: '/profile_menu',
        pageBuilder: (context, state) => _slideTransition(
          context,
          state,
          const ProfileMenuScreen(),
        ),
      ),
      // Settings Screen
      GoRoute(
        path: '/settings',
        pageBuilder: (context, state) => _slideTransition(
          context,
          state,
          const SettingsScreen(),
        ),
      ),
      // Matches Feed Screen
      GoRoute(
        path: '/matches',
        pageBuilder: (context, state) {
          final extra = state.extra as Map<String, dynamic>?;
          final isPaid = extra?['isPaidMember'] as bool? ?? false;
          return _slideTransition(
            context,
            state,
            MatchesFeedScreen(isPaidMember: isPaid),
          );
        },
      ),
      // Selected Matches Screen
      GoRoute(
        path: '/selected_matches',
        pageBuilder: (context, state) {
          final extra = state.extra as Map<String, dynamic>?;
          final isPaid = extra?['isPaidMember'] as bool? ?? false;
          final title = extra?['title'] as String? ?? 'Preferred Matches';
          final List<ProfileModel>? profiles = extra?['profiles'] as List<ProfileModel>?;
          return _slideTransition(
            context,
            state,
            SelectedMatchesScreen(
              isPaidMember: isPaid,
              sectionTitle: title,
              initialProfiles: profiles,
            ),
          );
        },
      ),
    ],
  );
}
