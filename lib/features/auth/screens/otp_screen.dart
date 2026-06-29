import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/theme.dart';
import '../../../core/translation/translations.dart';
import '../../../core/widgets/regal_button.dart';
import '../../onboarding/cubit/onboarding_cubit.dart';

class OtpScreen extends StatefulWidget {
  const OtpScreen({Key? key}) : super(key: key);

  @override
  State<OtpScreen> createState() => _OtpScreenState();
}

class _OtpScreenState extends State<OtpScreen> {
  final List<TextEditingController> _controllers = List.generate(4, (_) => TextEditingController());
  final List<FocusNode> _focusNodes = List.generate(4, (_) => FocusNode());

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
    // Collect the digits entered
    String otp = _controllers.map((c) => c.text).join();
    // Allow any code for test prototyping, fallback to '1234' if empty
    if (otp.length < 4) {
      otp = '1234';
    }
    final isCompleted = context.read<OnboardingCubit>().state.isOnboardingCompleted;
    if (isCompleted) {
      context.go('/home');
    } else {
      context.go('/onboarding/step1');
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = context.watch<OnboardingCubit>().state;
    final cubit = context.read<OnboardingCubit>();
    final String lang = state.langCode;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: KalyaThiruTheme.primaryMaroon),
          onPressed: () => context.pop(),
        ),
        actions: [
          TextButton.icon(
            onPressed: () => cubit.toggleLanguage(),
            icon: const Icon(Icons.language, color: KalyaThiruTheme.primaryMaroon, size: 20),
            label: Text(
              lang == 'en' ? 'தமிழ்' : 'English',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: KalyaThiruTheme.primaryMaroon,
                    fontWeight: FontWeight.bold,
                  ),
            ),
          ),
          const SizedBox(width: 16),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: 24),
            Text(
              AppTranslations.translate('otp_title', lang),
              style: Theme.of(context).textTheme.headlineLarge,
            ),
            const SizedBox(height: 8),
            Text(
              AppTranslations.translate('otp_subtitle', lang),
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: KalyaThiruTheme.mutedGray,
                  ),
            ),
            const SizedBox(height: 48),
            // 4 boxes for verification code digits
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: List.generate(4, (index) {
                return SizedBox(
                  width: 60,
                  height: 60,
                  child: TextField(
                    controller: _controllers[index],
                    focusNode: _focusNodes[index],
                    keyboardType: TextInputType.number,
                    textAlign: TextAlign.center,
                    maxLength: 1,
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                    cursorColor: KalyaThiruTheme.primaryMaroon,
                    decoration: InputDecoration(
                      counterText: '',
                      contentPadding: EdgeInsets.zero,
                      enabledBorder: OutlineInputBorder(
                        borderSide: const BorderSide(color: KalyaThiruTheme.outlineBorder, width: 1.5),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: const BorderSide(color: KalyaThiruTheme.primaryMaroon, width: 2.0),
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                    onChanged: (value) {
                      if (value.isNotEmpty) {
                        if (index < 3) {
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
            const SizedBox(height: 56),
            RegalButton(
              label: AppTranslations.translate('verify_btn', lang),
              onPressed: _verify,
            ),
            const SizedBox(height: 32),
            // Resend Option
            Center(
              child: TextButton(
                onPressed: () {
                  // Simulate OTP re-sending
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        lang == 'en' ? 'OTP sent successfully' : 'OTP வெற்றிகரமாக அனுப்பப்பட்டது',
                        style: const TextStyle(fontFamily: 'Nunito Sans'),
                      ),
                      backgroundColor: KalyaThiruTheme.primaryMaroon,
                      duration: const Duration(seconds: 2),
                    ),
                  );
                },
                child: Text(
                  AppTranslations.translate('resend_otp', lang),
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: KalyaThiruTheme.primaryMaroon,
                        fontWeight: FontWeight.bold,
                      ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
