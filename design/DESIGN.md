---
name: Stravun
notes: |
  SOURCE OF TRUTH: For all feature specs, data values, and business logic, refer to documentation.md in the parent directory. This file (DESIGN.md) covers visual design only.
  UNITS: All measurements in the app use METRIC (km, kcal, min/km). Do NOT use miles.
  MOCKUP IMAGES: Visual layout references are in the same folder as this file:
    - home.png — Home page layout
    - leaderboard.png — Leaderboard tab layout
    - forum.png — Forum feed layout
    - new post.png — Create post screen layout
  These mockups are AI-generated. Some values shown (point amounts, units) may differ from documentation.md. Always follow documentation.md for correct values.
colors:
  surface: '#121319'
  surface-dim: '#121319'
  surface-bright: '#38393f'
  surface-container-lowest: '#0c0e14'
  surface-container-low: '#1a1b21'
  surface-container: '#1e1f25'
  surface-container-high: '#282a30'
  surface-container-highest: '#33343b'
  on-surface: '#e2e2ea'
  on-surface-variant: '#c2caad'
  inverse-surface: '#e2e2ea'
  inverse-on-surface: '#2f3037'
  outline: '#8c9479'
  outline-variant: '#424a33'
  surface-tint: '#9bd900'
  primary: '#ffffff'
  on-primary: '#243600'
  primary-container: '#b2f800'
  on-primary-container: '#4d6e00'
  inverse-primary: '#486800'
  secondary: '#c7c5cf'
  on-secondary: '#303037'
  secondary-container: '#46464e'
  on-secondary-container: '#b6b4bd'
  tertiary: '#ffffff'
  on-tertiary: '#303034'
  tertiary-container: '#e4e1e7'
  on-tertiary-container: '#656469'
  error: '#ffb4ab'
  on-error: '#690005'
  error-container: '#93000a'
  on-error-container: '#ffdad6'
  primary-fixed: '#b2f800'
  primary-fixed-dim: '#9bd900'
  on-primary-fixed: '#131f00'
  on-primary-fixed-variant: '#364e00'
  secondary-fixed: '#e4e1eb'
  secondary-fixed-dim: '#c7c5cf'
  on-secondary-fixed: '#1b1b22'
  on-secondary-fixed-variant: '#46464e'
  tertiary-fixed: '#e4e1e7'
  tertiary-fixed-dim: '#c8c5cb'
  on-tertiary-fixed: '#1b1b1f'
  on-tertiary-fixed-variant: '#47464b'
  background: '#121319'          # NOTE: This is a Stitch-generated token. Use background-deep (#25252C) as the actual primary background.
  on-background: '#e2e2ea'
  surface-variant: '#33343b'
  # === PRIMARY COLORS (use these for the app) ===
  background-deep: '#25252C'     # Primary background (Obsidian) — USE THIS
  surface-card: '#19191D'        # Card/nav background (Ink) — USE THIS
  neon-accent: '#B7FF00'         # Primary accent (Volt)
  border-muted: '#3A3A42'        # Borders, dividers
  tier-bronze: '#CD7F32'
  tier-silver: '#C0C0C0'
  tier-gold: '#FFD700'
  status-error: '#FF4C4C'
typography:
  display-stat:
    fontFamily: Outfit
    fontSize: 48px
    fontWeight: '700'
    lineHeight: 56px
    letterSpacing: -0.02em
  headline-lg:
    fontFamily: Outfit
    fontSize: 32px
    fontWeight: '700'
    lineHeight: 40px
  headline-lg-mobile:
    fontFamily: Outfit
    fontSize: 28px
    fontWeight: '700'
    lineHeight: 36px
  headline-md:
    fontFamily: Outfit
    fontSize: 24px
    fontWeight: '600'
    lineHeight: 32px
  body-lg:
    fontFamily: Inter
    fontSize: 18px
    fontWeight: '400'
    lineHeight: 28px
  body-md:
    fontFamily: Inter
    fontSize: 16px
    fontWeight: '400'
    lineHeight: 24px
  label-md:
    fontFamily: Inter
    fontSize: 14px
    fontWeight: '600'
    lineHeight: 20px
    letterSpacing: 0.01em
  label-sm:
    fontFamily: Inter
    fontSize: 12px
    fontWeight: '500'
    lineHeight: 16px
rounded:
  sm: 0.25rem
  DEFAULT: 0.5rem
  md: 0.75rem
  lg: 1rem
  xl: 1.5rem
  full: 9999px
spacing:
  container-margin: 1rem
  gutter: 1rem
  stack-sm: 0.5rem
  stack-md: 1rem
  stack-lg: 1.5rem
  section-gap: 2rem
---

## Brand & Style

The design system for this product is rooted in a **High-Contrast / Modern** aesthetic, specifically tailored for a premium, gamified athletic experience. The brand personality is energetic, competitive, and prestigious. It utilizes a deep "Obsidian" foundation to allow high-energy neon accents to "pop," simulating the feel of a high-end sports car dashboard or a futuristic training simulator.

The goal is to evoke a sense of focused intensity and digital craftsmanship. By pairing a dark, sophisticated backdrop with sharp, vibrant highlights, the UI motivates the user through visual prestige and clear hierarchy. The style is unapologetically "dark mode only," ensuring that the brand identity remains consistent and impactful regardless of the environment.

## Colors

The palette is dominated by **Obsidian (#25252C)** and **Ink (#19191D)**, providing a layered dark environment that reduces eye strain and emphasizes content. The primary driver of action is **Volt (#B7FF00)**, a high-visibility neon green used exclusively for primary CTAs, active states, and critical progress indicators.

A dedicated **Mission Tier** palette is established to denote achievement:
- **Bronze:** A warm, earthy copper for entry-level goals.
- **Silver:** A neutral, metallic gray for intermediate milestones.
- **Gold:** A brilliant, high-saturation yellow for peak performance achievements.

Secondary text and borders utilize low-saturation grays to maintain a clean, uncluttered interface while ensuring accessibility and structural clarity.

## Typography

This design system employs a dual-font strategy. **Outfit** is used for headings and massive performance statistics to provide a geometric, modern, and high-energy feel. **Inter** is used for body text and labels to ensure maximum legibility and functional clarity.

Performance stats (distance, time, pace) should utilize the **Display-Stat** level to dominate the visual field during active runs. All headlines use a tight letter-spacing to appear more cohesive and aggressive. Labels are often set in uppercase to differentiate them from functional body text.

## Layout & Spacing

The layout follows a **fluid grid** model optimized for mobile performance. A standard 16px (1rem) margin is maintained on the edges of the screen to ensure content does not feel cramped. 

A vertical rhythm is established using a base-8 scale:
- **Small components (chips, badges):** Use 8px gaps.
- **Related elements within a card:** Use 16px gaps.
- **Section headers and content blocks:** Use 24px-32px gaps to provide breathing room and visual separation.

On the Home Page, the layout transitions into a single-column scroll, where cards span the full width of the available safe area. The Run Tracking screens prioritize a split-view model: the top 50% for the map (dynamic) and the bottom 50% for statistical data (fixed grid).

## Elevation & Depth

Depth in this system is achieved through **Tonal Layers** rather than heavy shadows. 
- **Level 0 (Base):** The Primary Background (#25252C) acts as the canvas.
- **Level 1 (Surface):** Cards and navigation bars use the Surface Background (#19191D) to appear slightly recessed or "carved out" of the primary surface.
- **Accents:** Neon elements appear as if they are "self-lit" or glowing. To enhance this, use subtle `0px 4px 20px` shadows with 20% opacity of the neon green color for active-state buttons.

Borders are used sparingly at 1px width with the `border-muted` color to define boundaries without adding visual weight.

## Shapes

The design system utilizes a **Rounded (16px)** shape language. This softens the high-contrast color palette, making the app feel premium and approachable rather than overly technical or harsh.

- **Standard Cards & Buttons:** 16px (rounded-lg).
- **Secondary Items (Inputs/Chips):** 12px (rounded-md).
- **Small elements (badges, tags):** 8px (rounded-default).
- **Avatars:** Circular (full rounding).
- **Active Tracking Buttons:** Circular (full rounding) to provide a distinct "target" for physical interaction during exercise.

## Components

### Buttons
- **Primary:** Background: Neon Accent (#B7FF00), Text: Primary BG (#25252C), Weight: Bold.
- **Secondary:** Border: Neon Accent (#B7FF00), Background: Transparent, Text: Neon Accent.
- **Tertiary/Ghost:** Text: Text Secondary (#A0A0A8).

### Cards
All cards use the Surface/Card BG (#19191D). Content within cards should have a minimum of 16px internal padding. Mission cards should include a left-aligned vertical "accent stripe" or icon colored according to their specific tier (Bronze, Silver, Gold).

### Inputs
Text fields are dark-filled (#19191D) with a subtle border (#3A3A42). On focus, the border transitions to Neon Accent (#B7FF00).

### Progress Bars
- **Track:** #3A3A42 (Dark Gray).
- **Fill:** Neon Accent (#B7FF00) for general progress, or Tiered colors (Bronze/Silver/Gold) for specific mission progress.

### Chips
Horizontal scrollable pills for filtering (e.g., Leaderboard categories). Inactive: Surface BG with Gray text. Active: Neon Accent BG with Dark text.

### Navigation
The Bottom Nav bar is fixed with a #19191D background and a top-border of 1px (#3A3A42). Active icons must glow slightly with a neon tint.