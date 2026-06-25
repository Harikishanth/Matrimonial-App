import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/theme/theme.dart';
import '../../onboarding/cubit/onboarding_cubit.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<OnboardingCubit, OnboardingState>(
      builder: (context, state) {
        final lang = state.langCode;
        return Scaffold(
          backgroundColor: KalyaThiruTheme.softIvory,
          appBar: AppBar(
            backgroundColor: KalyaThiruTheme.softIvory,
            elevation: 0,
            scrolledUnderElevation: 0,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back, color: KalyaThiruTheme.primaryMaroon),
              onPressed: () => context.pop(),
            ),
            titleSpacing: 0,
            title: Text(
              lang == 'en' ? 'Settings' : 'அமைப்புகள்',
              style: GoogleFonts.sourceSerif4(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: KalyaThiruTheme.primaryMaroon,
              ),
            ),
            bottom: PreferredSize(
              preferredSize: const Size.fromHeight(1.0),
              child: Container(
                color: KalyaThiruTheme.outlineVariant,
                height: 1.0,
              ),
            ),
          ),
          body: ListView(
            padding: const EdgeInsets.symmetric(vertical: 12),
            children: [
              _buildSettingItem(
                context,
                icon: Icons.lock_outline,
                title: lang == 'en' ? 'Privacy Settings' : 'தனியுரிமை அமைப்புகள்',
                onTap: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Privacy settings page coming soon!')),
                  );
                },
              ),
              const Divider(height: 1, color: KalyaThiruTheme.outlineVariant),
              _buildSettingItem(
                context,
                icon: Icons.notifications_active_outlined,
                title: lang == 'en' ? 'Communication Settings' : 'தொடர்பு அமைப்புகள்',
                onTap: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Communication settings page coming soon!')),
                  );
                },
              ),
              const Divider(height: 1, color: KalyaThiruTheme.outlineVariant),
              _buildSettingItem(
                context,
                icon: Icons.manage_accounts_outlined,
                title: lang == 'en' ? 'Account Settings' : 'கணக்கு அமைப்புகள்',
                onTap: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Account settings page coming soon!')),
                  );
                },
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildSettingItem(
    BuildContext context, {
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: Icon(icon, color: KalyaThiruTheme.primaryMaroon),
      title: Text(
        title,
        style: GoogleFonts.nunitoSans(
          fontSize: 14,
          fontWeight: FontWeight.w600,
          color: KalyaThiruTheme.darkCharcoal,
        ),
      ),
      trailing: const Icon(Icons.chevron_right, color: KalyaThiruTheme.outlineBorder),
      onTap: onTap,
    );
  }
}
