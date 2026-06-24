import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'core/theme/theme.dart';
import 'core/navigation/routes.dart';
import 'features/onboarding/cubit/onboarding_cubit.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const KalyaThiruApp());
}

class KalyaThiruApp extends StatelessWidget {
  const KalyaThiruApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider<OnboardingCubit>(
      create: (_) => OnboardingCubit(),
      child: MaterialApp.router(
        title: 'KalyaThiru',
        debugShowCheckedModeBanner: false,
        theme: KalyaThiruTheme.lightTheme,
        routerConfig: AppRoutes.router,
      ),
    );
  }
}
