---
name: Heritage & Kaapi
colors:
  surface: '#fef8f4'
  surface-dim: '#dfd9d5'
  surface-bright: '#fef8f4'
  surface-container-lowest: '#ffffff'
  surface-container-low: '#f9f2ef'
  surface-container: '#f3ede9'
  surface-container-high: '#ede7e3'
  surface-container-highest: '#e7e1de'
  on-surface: '#1d1b19'
  on-surface-variant: '#584141'
  inverse-surface: '#32302e'
  inverse-on-surface: '#f6f0ec'
  outline: '#8c7071'
  outline-variant: '#e0bfbf'
  surface-tint: '#af2b3e'
  primary: '#570013'
  on-primary: '#ffffff'
  primary-container: '#800020'
  on-primary-container: '#ff828a'
  inverse-primary: '#ffb3b5'
  secondary: '#735c00'
  on-secondary: '#ffffff'
  secondary-container: '#fed65b'
  on-secondary-container: '#745c00'
  tertiary: '#501000'
  on-tertiary: '#ffffff'
  tertiary-container: '#761c00'
  on-tertiary-container: '#ff8663'
  error: '#ba1a1a'
  on-error: '#ffffff'
  error-container: '#ffdad6'
  on-error-container: '#93000a'
  primary-fixed: '#ffdada'
  primary-fixed-dim: '#ffb3b5'
  on-primary-fixed: '#40000b'
  on-primary-fixed-variant: '#8e0f28'
  secondary-fixed: '#ffe088'
  secondary-fixed-dim: '#e9c349'
  on-secondary-fixed: '#241a00'
  on-secondary-fixed-variant: '#574500'
  tertiary-fixed: '#ffdbd1'
  tertiary-fixed-dim: '#ffb5a0'
  on-tertiary-fixed: '#3b0900'
  on-tertiary-fixed-variant: '#872100'
  background: '#fef8f4'
  on-background: '#1d1b19'
  surface-variant: '#e7e1de'
typography:
  display-lg:
    fontFamily: Source Serif 4
    fontSize: 48px
    fontWeight: '700'
    lineHeight: 56px
    letterSpacing: -0.02em
  headline-lg:
    fontFamily: Source Serif 4
    fontSize: 32px
    fontWeight: '600'
    lineHeight: 40px
  headline-lg-mobile:
    fontFamily: Source Serif 4
    fontSize: 28px
    fontWeight: '600'
    lineHeight: 36px
  headline-md:
    fontFamily: Source Serif 4
    fontSize: 24px
    fontWeight: '600'
    lineHeight: 32px
  body-lg:
    fontFamily: Nunito Sans
    fontSize: 18px
    fontWeight: '400'
    lineHeight: 28px
  body-md:
    fontFamily: Nunito Sans
    fontSize: 16px
    fontWeight: '400'
    lineHeight: 24px
  label-lg:
    fontFamily: Nunito Sans
    fontSize: 14px
    fontWeight: '700'
    lineHeight: 20px
    letterSpacing: 0.05em
  label-md:
    fontFamily: Nunito Sans
    fontSize: 12px
    fontWeight: '600'
    lineHeight: 16px
  aura-tag:
    fontFamily: Nunito Sans
    fontSize: 13px
    fontWeight: '700'
    lineHeight: 16px
rounded:
  sm: 0.125rem
  DEFAULT: 0.25rem
  md: 0.375rem
  lg: 0.5rem
  xl: 0.75rem
  full: 9999px
spacing:
  base: 8px
  container-max: 1200px
  gutter: 24px
  margin-mobile: 16px
  margin-desktop: 40px
  stack-sm: 4px
  stack-md: 12px
  stack-lg: 24px
---

## Brand & Style

The brand personality is a sophisticated intersection of **Heritage Trust** and **Modern Social**. It targets a demographic that values traditional Tamil roots—represented by the architectural stability of temple motifs—while demanding the seamless, vibrant social experience of a modern matchmaking platform.

The design style is **Corporate / Modern** with a refined **Editorial** edge. It avoids excessive shadows or depth in favor of flat, authoritative structural elements that suggest reliability and institutional permanence. The emotional response should be one of "Warm Trust": the warmth of a morning kaapi (coffee) session combined with the serious, high-stakes nature of matrimonial alliances.

Visuals are characterized by clean, high-contrast layouts, generous use of negative space (Soft Ivory), and purposeful accents of Antique Gold to signal premium status and "Trust Seals."

## Colors

The palette is rooted in the cultural iconography of Tamil Nadu.

*   **Primary (Temple Maroon - #800020):** Used for primary actions, headers, and key branding moments. It represents maturity and tradition.
*   **Secondary (Antique Gold - #D4AF37):** Reserved for "Trust Seals," premium memberships, and verified badges. It adds a layer of prestige.
*   **Tertiary (Marigold Orange - #E64A19):** An energetic accent color used for social interactions, "New" notifications, and community-driven features.
*   **Neutral (Charcoal Gray - #211F1D):** Used for high-legibility body text and grounding structural borders.
*   **Surface (Soft Ivory - #FDFBF7):** The canvas of the design system, providing a warmer, more welcoming alternative to clinical white.

## Typography

The typography strategy balances the academic authority of **Source Serif 4** with the approachable clarity of **Nunito Sans**.

Source Serif 4 is used for all headlines and display text to evoke the feeling of heritage documents and classic publishing. It should be used with tighter letter-spacing in larger sizes to maintain a modern, "premium" feel.

Nunito Sans is used for all functional UI elements, body copy, and the "Aura Tags." Its slightly rounded terminals soften the authoritative serif, ensuring the social aspect of the app remains inviting. "Aura Tags" use a bold, slightly smaller weight to distinguish themselves as metadata without overwhelming the primary narrative text.

## Layout & Spacing

This design system utilizes a **Fixed Grid** model for desktop to maintain a sense of structured, architectural order. On mobile, it transitions to a fluid model with consistent safe-area margins.

*   **Desktop:** 12-column grid with a 1200px max-width. Columns are used to separate profile imagery from bio data and trust indicators.
*   **Mobile:** A single-column flow with a focus on vertical stackability.
*   **Spacing Rhythm:** An 8px linear scale is strictly followed. Components use `stack-md` (12px) for internal padding to maintain a compact, "information-rich" feel typical of institutional platforms.
*   **Verticality:** High-priority "Trust Seals" are often placed in a dedicated sidebar or top-aligned right-hand corner to ensure they are the first point of ocular entry.

## Elevation & Depth

This design system employs a **Low-Contrast Outline** approach to convey hierarchy, avoiding the "floaty" feel of heavy shadows in favor of grounded stability.

*   **Surfaces:** Elements are distinguished by subtle tonal shifts from the Soft Ivory background to a pure white or very light gray surface.
*   **Borders:** Use a 1px Charcoal Gray border at 10-15% opacity for standard containers. For "Authoritative" sections (like Verified Profiles), use a 2px Temple Maroon or Antique Gold border.
*   **Interactive State:** On hover or active states, use a very subtle ambient shadow (4px blur, 5% opacity) only to provide tactile feedback, never as a primary means of separation.
*   **Trust Seals:** These should appear "stamped" onto the surface rather than floating above it, achieved through flat fills and crisp borders.

## Shapes

The shape language is disciplined and professional. A **Soft (4px)** radius is applied to all primary containers, buttons, and input fields. This provides just enough friendliness to be "modern" without losing the "institutional" rigor required for a matrimony app.

*   **Buttons:** 4px radius. Large buttons may occasionally use a 2px radius for a sharper, more "legalistic" appearance in footer or agreement sections.
*   **Aura Tags:** These are the exception; they may use a higher roundedness (Pill-shaped) to distinguish them as interactive/removable metadata chips, contrasting against the rigid structure of the profile card.
*   **Avatars:** Always displayed as squares with the standard 4px radius to maximize the visible area of the photograph, which is crucial for matrimonial profiles.

## Components

### Buttons
Primary buttons utilize Temple Maroon with Soft Ivory text. Secondary buttons are outlined in Charcoal Gray. All buttons use the 4px radius and bold Nunito Sans labels.

### Aura Tags (Discord-style)
Aura tags are small, high-contrast chips used to denote personality traits or interests (e.g., "Classic Carnatic," "Tech-Savvy," "Traditionalist"). They use Marigold Orange or light tints of Maroon as background colors with dark text to stand out against the Ivory background.

### Trust Seals
These are distinctive badges, often in Antique Gold, featuring an icon and the word "VERIFIED." They should be placed in the top-right corner of profile cards or next to the user's name. They use Source Serif 4 for the text to emphasize authority.

### Profile Cards
The central component of the design system. It features a large, 4px-radius image, a clear hierarchy with the name in Source Serif 4, and a grid of Aura Tags below. The card itself has a 1px low-opacity Charcoal border.

### Input Fields
Strictly rectangular with a 4px radius. Use Charcoal Gray for labels and Temple Maroon for the active focus border. Errors are highlighted in Marigold Orange rather than standard red to stay within the brand's warm palette.