# Implementation Plan - KalyaThiru Flutter App (Updated)

This plan outlines the end-to-end development of the **KalyaThiru** matrimonial mobile application in Flutter for Android, using Android 16 (Baklava) and a Pixel 8 Pro device profile.

## User Review Required

Please review the updated routing pathway and translation design.

> [!IMPORTANT]
> - **KYC & Verification:** Government ID, professional sync (LinkedIn), and Video KYC verification steps are deferred to later versions. The dashboard feed will display mock-verified profile badges to show the visual state, but no onboarding uploads are required for them now.
> - **Bilingual Toggle & Initial Selector:** We will add a new initial route `/language_selection` as the first screen. A persistent language toggle button (English <-> தமிழ்) will be placed in the top header bar of the onboarding screens, updating the UI strings dynamically using state management.

## Open Questions
All questions resolved! Let's proceed to execution.

---

## Proposed Changes

### [Flutter Project Setup]

#### [NEW] [pubspec.yaml](file:///d:/Matrimonial%20App/pubspec.yaml)
Initialize the project dependencies:
```yaml
dependencies:
  flutter:
    sdk: flutter
  google_fonts: ^6.1.0
  flutter_bloc: ^8.1.3
  go_router: ^13.2.0
  shared_preferences: ^2.2.2
  uuid: ^4.3.3
```

#### [NEW] [lib/main.dart](file:///d:/Matrimonial%20App/lib/main.dart)
App entry point establishing the global theme, Cubit provider, and routing engine.

---

### [Component & Translation Layer]

#### [NEW] [lib/core/theme/theme.dart](file:///d:/Matrimonial%20App/lib/core/theme/theme.dart)
Contains the `ThemeData` configuration mapping Temple Maroon, Soft Ivory, and Lora/Nunito Sans fonts.

#### [NEW] [lib/core/translation/translations.dart](file:///d:/Matrimonial%20App/lib/core/translation/translations.dart)
A structured bilingual dictionary (English/Tamil strings) mapped to keys, allowing instant UI language toggles.

#### [NEW] [lib/core/widgets/regal_button.dart](file:///d:/Matrimonial%20App/lib/core/widgets/regal_button.dart)
Premium styled button with gold shimmer animation overlays and click scaling.

#### [NEW] [lib/core/widgets/notched_text_field.dart](file:///d:/Matrimonial%20App/lib/core/widgets/notched_text_field.dart)
Text input with floating labels intersecting the border boundary.

#### [NEW] [lib/core/widgets/bottom_sheet_selector.dart](file:///d:/Matrimonial%20App/lib/core/widgets/bottom_sheet_selector.dart)
Replacing default dropdowns: A text field that opens a custom search-enabled bottom drawer.

#### [NEW] [lib/core/widgets/sub_interest_sheet.dart](file:///d:/Matrimonial%20App/lib/core/widgets/sub_interest_sheet.dart)
Popup panel to collect detailed sub-genres when selecting interests/hobbies.

---

### [State Management & Routing]

#### [NEW] [lib/features/onboarding/cubit/onboarding_cubit.dart](file:///d:/Matrimonial%20App/lib/features/onboarding/cubit/onboarding_cubit.dart)
Cubit and State definition to store onboarding state, current step, and selected language (English vs Tamil).

#### [NEW] [lib/core/navigation/routes.dart](file:///d:/Matrimonial%20App/lib/core/navigation/routes.dart)
`GoRouter` setup mapping all routes:
*   `/` $\rightarrow$ Initial Language Selection Screen
*   `/splash` $\rightarrow$ Branding Splash Screen (with selected language)
*   `/entry` $\rightarrow$ Entry Gateway (Register / Login)
*   `/login` $\rightarrow$ Login (Phone/Email options)
*   `/otp` $\rightarrow$ OTP input screen
*   `/onboarding/step<N>` $\rightarrow$ Steps 1 to 11
*   `/home` $\rightarrow$ Home Dashboard

---

### [Screen Layer]

#### [NEW] [lib/features/auth/screens/](file:///d:/Matrimonial%20App/lib/features/auth/screens/)
Contains:
- `language_selection_screen.dart` (Initial custom branding selection page)
- `splash_screen.dart` (Tamil-themed premium logo intro)
- `entry_screen.dart` (Welcome CTA buttons)
- `login_screen.dart` & `otp_screen.dart` (Login inputs and auto-advancing OTP fields)

#### [NEW] [lib/features/onboarding/screens/](file:///d:/Matrimonial%20App/lib/features/onboarding/screens/)
Implements steps 1 to 11 including the conditional branching logic (Self vs Other details), custom bottom sheets, and the sub-interest modal popups.

#### [NEW] [lib/features/home/screens/home_screen.dart](file:///d:/Matrimonial%20App/lib/features/home/screens/home_screen.dart)
The main Dashboard with profile completeness indicators, premium banners, and verified profile cards.

---

## Verification Plan

### Automated Tests
- Run `flutter analyze` to check Dart syntax.
- Run `flutter test` for component-level widget unit validation.

### Manual Verification
- Deploy to the Pixel 8 Pro Android Emulator running Android 16 (Baklava).
- Verify the scrolling animations, bottom sheet search functionality, and sub-interest popups.
- Verify transition logic from Onboarding Step 1 to Step 11 and final redirection to Home page.
