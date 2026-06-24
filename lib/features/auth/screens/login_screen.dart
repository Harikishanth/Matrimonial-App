import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/theme.dart';
import '../../../core/translation/translations.dart';
import '../../../core/widgets/notched_text_field.dart';
import '../../../core/widgets/regal_button.dart';
import '../../onboarding/cubit/onboarding_cubit.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _phoneController = TextEditingController();
  final _emailController = TextEditingController();
  bool _isPhoneMode = true;

  @override
  void dispose() {
    _phoneController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  void _submit() {
    if (_formKey.currentState!.validate()) {
      context.push('/otp');
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
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 8.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 24),
              // Header title
              Text(
                AppTranslations.translate('login_title', lang),
                style: Theme.of(context).textTheme.headlineLarge,
              ),
              const SizedBox(height: 8),
              Text(
                AppTranslations.translate('login_subtitle', lang),
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: KalyaThiruTheme.mutedGray,
                    ),
              ),
              const SizedBox(height: 36),
              // Sliding toggle switcher
              Container(
                height: 50,
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(color: KalyaThiruTheme.outlineBorder, width: 0.8),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: InkWell(
                        onTap: () => setState(() => _isPhoneMode = true),
                        child: Container(
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            color: _isPhoneMode ? KalyaThiruTheme.primaryMaroon : Colors.transparent,
                            borderRadius: BorderRadius.circular(3),
                          ),
                          child: Text(
                            AppTranslations.translate('phone_label', lang),
                            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                  color: _isPhoneMode ? Colors.white : KalyaThiruTheme.primaryMaroon,
                                  fontWeight: FontWeight.bold,
                                ),
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: InkWell(
                        onTap: () => setState(() => _isPhoneMode = false),
                        child: Container(
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            color: !_isPhoneMode ? KalyaThiruTheme.primaryMaroon : Colors.transparent,
                            borderRadius: BorderRadius.circular(3),
                          ),
                          child: Text(
                            AppTranslations.translate('email_label', lang),
                            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                  color: !_isPhoneMode ? Colors.white : KalyaThiruTheme.primaryMaroon,
                                  fontWeight: FontWeight.bold,
                                ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 32),
              // Input switcher animation
              AnimatedSize(
                duration: const Duration(milliseconds: 200),
                curve: Curves.easeInOut,
                child: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 250),
                  child: _isPhoneMode
                      ? NotchedTextField(
                          key: const ValueKey('phone_input'),
                          labelText: AppTranslations.translate('phone_label', lang),
                          controller: _phoneController,
                          keyboardType: TextInputType.phone,
                          validator: (val) {
                            if (val == null || val.isEmpty) {
                              return lang == 'en' ? 'Phone is required' : 'தொலைபேசி எண் தேவை';
                            }
                            if (val.length < 10) {
                              return lang == 'en' ? 'Enter a valid 10-digit number' : 'சரியான தொலைபேசி எண்ணை உள்ளிடவும்';
                            }
                            return null;
                          },
                        )
                      : NotchedTextField(
                          key: const ValueKey('email_input'),
                          labelText: AppTranslations.translate('email_label', lang),
                          controller: _emailController,
                          keyboardType: TextInputType.emailAddress,
                          validator: (val) {
                            if (val == null || val.isEmpty) {
                              return lang == 'en' ? 'Email is required' : 'மின்னஞ்சல் தேவை';
                            }
                            final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
                            if (!emailRegex.hasMatch(val)) {
                              return lang == 'en' ? 'Enter a valid email address' : 'சரியான மின்னஞ்சலை உள்ளிடவும்';
                            }
                            return null;
                          },
                        ),
                ),
              ),
              const SizedBox(height: 48),
              RegalButton(
                label: AppTranslations.translate('get_otp', lang),
                onPressed: _submit,
              ),
              const SizedBox(height: 24),
              // Mode swap helper text
              Center(
                child: TextButton(
                  onPressed: () {
                    setState(() => _isPhoneMode = !_isPhoneMode);
                  },
                  child: Text(
                    _isPhoneMode
                        ? AppTranslations.translate('use_email', lang)
                        : AppTranslations.translate('use_phone', lang),
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
      ),
    );
  }
}
