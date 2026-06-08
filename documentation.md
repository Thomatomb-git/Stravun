# Stravun — Project Documentation

> **Stravun** = Strava + Fun. A gamified running tracker that makes fitness engaging through missions, points, and community interaction.

---

## Table of Contents

1. [Project Overview](#1-project-overview)
2. [Tech Stack](#2-tech-stack)
3. [Design System](#3-design-system)
4. [App Architecture](#4-app-architecture)
5. [Navigation Structure](#5-navigation-structure)
6. [Feature Specifications](#6-feature-specifications)
   - [6.1 Authentication](#61-authentication)
   - [6.2 Home Page](#62-home-page)
   - [6.3 Run Page](#63-run-page)
   - [6.4 Community Page](#64-community-page)
   - [6.5 Profile Page](#65-profile-page)
7. [Points & Gamification System](#7-points--gamification-system)
8. [Daily Mission System](#8-daily-mission-system)
9. [Leaderboard System](#9-leaderboard-system)
10. [Firebase Data Models](#10-firebase-data-models)
11. [Development Priorities](#11-development-priorities)
12. [Constraints & Rules](#12-constraints--rules)

---

## ⚠️ Important Notes for AI Coding Agent

1. **This document (`documentation.md`) is the single source of truth** for all feature specs, data values, and business logic. If any mockup or design file contradicts this document, follow this document.
2. **Design references** are located in the `design/` folder:
   - `design/DESIGN.md` — Full design system (color tokens, typography, spacing, elevation, shapes, component specs). **Read this before coding any UI.**
   - `design/home.png` — Home page mockup (visual layout reference)
   - `design/leaderboard.png` — Leaderboard tab mockup
   - `design/forum.png` — Forum feed mockup
   - `design/new post.png` — Create post screen mockup
3. **Mockup images are AI-generated** — some values (e.g., point amounts, units like miles) in the mockups may not match this document. Always use the values defined in this document (e.g., metric km, Bronze=1 pt, Silver=3 pts, Gold=5 pts).
4. **Current development scope**: Only **Home page** and **Community page** (leaderboard + forum). Other pages (Run, Profile) are handled by other team members. A **minimal auth flow** (login/register) will be built as a prerequisite for testing, but the full auth feature is not the focus.

---

## 1. Project Overview

| Field             | Detail                                              |
| ----------------- | --------------------------------------------------- |
| **App Name**      | Stravun                                             |
| **Concept**       | Gamified running tracker — run, earn points, compete |
| **Platform**      | Android only                                        |
| **Min Android**   | Android 8.0 (API level 26)                          |
| **Language**      | English (full app in English)                       |
| **Units**         | Metric (km, kcal)                                   |
| **Project Type**  | University / Software Engineering course project    |
| **Current Focus** | Home page & Community (leaderboard + forum)         |

### Core Philosophy

Stravun differentiates itself from typical running apps by making fitness **fun**. Users don't just track runs — they complete tiered daily missions (Bronze, Silver, Gold) to earn points, climb leaderboards, and engage with a social community. The gamification layer is the heart of the app.

---

## 2. Tech Stack

### Framework & Language

| Component            | Version / Detail                              |
| -------------------- | --------------------------------------------- |
| **Flutter**          | 3.44.0 (stable channel)                      |
| **Dart**             | 3.12.0                                       |
| **DevTools**         | 2.57.0                                       |
| **State Management** | Provider (official Flutter recommendation)    |
| **Local Storage**    | SharedPreferences (for small settings/prefs)  |

### Backend — Firebase

| Service               | Purpose                                         |
| ---------------------- | ----------------------------------------------- |
| **Firebase Auth**      | Email/password authentication                   |
| **Cloud Firestore**    | Primary database (users, runs, posts, missions) |
| **Firebase Storage**   | Image & video uploads (forum posts, profile pic) |

> **Note:** Firestore has built-in offline persistence, so the app works offline for cached data.

### Map & Location

| Component          | Detail                                              |
| ------------------ | --------------------------------------------------- |
| **Map Provider**   | OpenStreetMap (free, no API key required)            |
| **Map Package**    | `flutter_map` + `latlong2`                          |
| **Location**       | `geolocator` package for GPS tracking               |
| **Tracking**       | GPS-based only — no background tracking              |
| **Step Estimation** | Estimated from GPS distance (~1,300 steps per km)   |

### Key Flutter Packages (Recommended)

| Package                | Purpose                              |
| ---------------------- | ------------------------------------ |
| `provider`             | State management                     |
| `firebase_core`        | Firebase initialization              |
| `firebase_auth`        | Authentication                       |
| `cloud_firestore`      | Database                             |
| `firebase_storage`     | File uploads                         |
| `flutter_map`          | OpenStreetMap map widget             |
| `latlong2`             | Latitude/longitude utilities         |
| `geolocator`           | GPS location tracking                |
| `shared_preferences`   | Local key-value storage              |
| `image_picker`         | Pick images/videos for forum posts   |
| `intl`                 | Date/time formatting                 |
| `fl_chart`             | Charts (weekly stats bar chart)      |
| `cached_network_image` | Efficient image loading & caching    |
| `google_fonts`         | Outfit & Inter font families         |
| `uuid`                 | Generate unique IDs                  |
| `timeago`              | Relative timestamps ("2h ago")       |
| `video_player`         | Play videos in forum posts           |

---

## 3. Design System

### Color Palette

| Name            | Hex Code    | Usage                                         |
| --------------- | ----------- | --------------------------------------------- |
| **Dark BG**     | `#25252C`   | Primary background                            |
| **Darker BG**   | `#19191D`   | Cards, bottom nav, secondary surfaces         |
| **Neon Green**  | `#B7FF00`   | Primary accent — buttons, highlights, active states |
| **White**       | `#FFFFFF`   | Primary text, icons                           |
| **Light Gray**  | `#A0A0A8`   | Secondary/muted text                          |
| **Dark Gray**   | `#3A3A42`   | Borders, dividers, inactive elements          |
| **Error Red**   | `#FF4C4C`   | Error states, delete actions                  |
| **Bronze**      | `#CD7F32`   | Bronze tier missions                          |
| **Silver**      | `#C0C0C0`   | Silver tier missions                          |
| **Gold**        | `#FFD700`   | Gold tier missions                            |

### Design Principles

- **Dark theme only** — The app uses a dark UI throughout
- **Neon green accent** — `#B7FF00` is the signature color, used for CTAs, highlights, and active states
- **Modern & premium feel** — Smooth animations, rounded cards, subtle gradients
- **Minimalist** — Clean layouts, no clutter, generous whitespace
- **Typography** — Use a modern sans-serif font (e.g., Inter or Outfit from Google Fonts)

---

## 4. App Architecture

### Folder Structure (Recommended)

```
lib/
├── main.dart                    # App entry point
├── app.dart                     # MaterialApp configuration
├── firebase_options.dart        # Firebase config (generated)
│
├── config/
│   ├── theme.dart               # ThemeData, colors, text styles
│   └── routes.dart              # Route definitions
│
├── models/
│   ├── user_model.dart          # User data model
│   ├── run_model.dart           # Run/activity data model
│   ├── post_model.dart          # Forum post data model
│   ├── comment_model.dart       # Comment data model
│   └── mission_model.dart       # Daily mission data model
│
├── services/
│   ├── auth_service.dart        # Firebase Auth operations
│   ├── firestore_service.dart   # Firestore CRUD operations
│   ├── storage_service.dart     # Firebase Storage uploads
│   ├── location_service.dart    # GPS tracking logic
│   └── mission_service.dart     # Mission generation & validation
│
├── providers/
│   ├── auth_provider.dart       # Auth state
│   ├── home_provider.dart       # Home page data (user stats, missions, weekly stats)
│   └── community_provider.dart  # Forum & leaderboard state
│
├── screens/
│   ├── auth/
│   │   ├── login_screen.dart
│   │   └── register_screen.dart
│   ├── home/
│   │   └── home_screen.dart
│   ├── run/
│   │   ├── run_screen.dart          # Live tracking screen
│   │   └── run_summary_screen.dart  # Post-run summary
│   ├── community/
│   │   ├── community_screen.dart    # Tab container
│   │   ├── leaderboard_tab.dart     # Leaderboard view
│   │   ├── forum_tab.dart           # Forum feed
│   │   ├── create_post_screen.dart  # New post screen
│   │   └── post_detail_screen.dart  # Post + comments
│   └── profile/
│       ├── profile_screen.dart
│       └── edit_profile_screen.dart
│
├── widgets/
│   ├── common/                  # Shared widgets (buttons, cards, etc.)
│   ├── home/                    # Home-specific widgets
│   ├── run/                     # Run-specific widgets
│   ├── community/               # Community-specific widgets
│   └── profile/                 # Profile-specific widgets
│
└── utils/
    ├── constants.dart           # App-wide constants
    ├── helpers.dart             # Utility functions
    └── validators.dart          # Form validation
```

---

## 5. Navigation Structure

### Bottom Navigation Bar — 4 Tabs

| Index | Label       | Icon              | Screen           |
| ----- | ----------- | ----------------- | ---------------- |
| 0     | **Home**    | Home icon         | `HomeScreen`     |
| 1     | **Run**     | Running/play icon | `RunScreen`      |
| 2     | **Community** | People/group icon | `CommunityScreen` |
| 3     | **Profile** | Person icon       | `ProfileScreen`  |

- Bottom nav bar uses **Darker BG** (`#19191D`) background
- Active tab icon/label uses **Neon Green** (`#B7FF00`)
- Inactive tab icon/label uses **Light Gray** (`#A0A0A8`)

---

## 6. Feature Specifications

### 6.1 Authentication

#### Login Screen
- Email input field
- Password input field
- "Login" button (Neon Green)
- "Don't have an account? Register" link
- Form validation (valid email format, password min 6 chars)

#### Register Screen
- Username input field
- Email input field
- Password input field
- Confirm password input field
- "Register" button (Neon Green)
- "Already have an account? Login" link
- On successful registration: create user document in Firestore

#### Auth Flow
- On app launch: check if user is already logged in (Firebase Auth state)
- If logged in → navigate to Home
- If not → navigate to Login
- Logout available from Profile page

---

### 6.2 Home Page

The home page is the app's dashboard — showing the user's stats, progress, missions, and ranking at a glance.

#### Layout (Top to Bottom)

1. **Header / Greeting**
   - "Hi, [username]" text
   - App branding / "Stravun" logo or text

2. **Points Display** (most prominent element)
   - Large point number with a distinctive icon
   - This is the user's total accumulated points
   - Should be visually the most eye-catching element on the page

3. **Login Streak**
   - Lightning bolt icon ⚡ + streak number (e.g., "128")
   - Shows consecutive days the user has logged into the app
   - Resets to 0 if user misses a day

4. **Global Ranking**
   - Display user's rank number (e.g., "8th")
   - Subtitle: "Just X points away from Yth place!" (motivational)
   - Ranking is based on **total points** (primary leaderboard)

5. **Last Run**
   - Shows stats from the user's most recent run:
     - Distance (km)
     - Duration (minutes)
     - Calories burned (kcal)
     - Pace (min/km)
   - If no runs yet, show a CTA: "Start your first run!"

6. **Weekly Stats** (Bar Chart)
   - Bar chart showing distance/steps per day (Mon–Sun)
   - Based on tracked runs only (not background pedometer)
   - Uses `fl_chart` package
   - Bars colored with Neon Green

7. **Daily Mission** (see [Section 8](#8-daily-mission-system) for full details)
   - Show 3 mission tiers: Bronze 🥉, Silver 🥈, Gold 🥇
   - Each with a progress bar and completion status
   - Missions reset every 3 days

---

### 6.3 Run Page

> **Note:** This page is NOT the current development focus, but is documented for completeness and future implementation.

#### Pre-Run State
- Map centered on user's current location
- Large "Start Run" button (Neon Green, prominent)
- Brief stats from last run (optional)

#### Active Tracking State
When user taps "Start Run":
- **Live map** showing real-time route being drawn on the map
- **Real-time stats overlay:**
  - Distance so far (km)
  - Duration / Timer
  - Current pace (min/km)
  - Estimated calories burned so far
- **Controls:**
  - Pause button — pauses tracking, timer, and GPS recording
  - Resume button — continues from where paused
  - Stop button — ends the run

#### Tracking Behavior
- GPS tracking ONLY runs when user explicitly starts a run
- No background tracking whatsoever
- App should request location permission (fine location)
- Track GPS coordinates at regular intervals to draw the route
- Steps are estimated from distance (~1,300 steps/km)

#### Post-Run Summary Screen
After user taps "Stop":
- **Route map** — full route drawn on the map
- **Summary stats:**
  - Total distance (km)
  - Total duration
  - Average pace (min/km)
  - Estimated calories burned
  - Estimated steps
- **Actions:**
  - "Share to Community" button → opens create post screen with run data attached
  - "Save" button → saves run to history
  - "Discard" button → discards the run

#### Run Data Saved
Each completed run saves to Firestore:
- `userId` — user reference
- `distance` — in km
- `duration` — in seconds
- `pace` — average pace in min/km
- `calories` — estimated kcal
- `steps` — estimated steps
- `route` — list of LatLng coordinates
- `timestamp` — when the run started
- `createdAt` — Firestore server timestamp

---

### 6.4 Community Page

The community page has **two tabs**: Leaderboard and Forum.

#### 6.4.1 Leaderboard Tab

See [Section 9: Leaderboard System](#9-leaderboard-system) for full details.

- Multiple leaderboard categories displayed as horizontally scrollable chips or tabs:
  - **Total Points** (primary)
  - **Login Streak**
  - **Weekly Distance** (total km this week)
- Each leaderboard shows a ranked list of users:
  - Rank number
  - Profile picture (small avatar)
  - Username
  - Relevant stat value (points / streak days / km)
- Top 3 users get special visual treatment (podium style, larger cards, gold/silver/bronze accents)
- Current user's rank is highlighted wherever they appear
- All users are shown (global, public — no friend system in v1)

#### 6.4.2 Forum Tab

X/Twitter-inspired social feed. All posts are public.

##### Forum Feed
- Scrollable list of posts, newest first
- Each post card shows:
  - Author profile picture (avatar)
  - Author username
  - Post timestamp (relative: "2h ago", "1d ago")
  - Post text content
  - Attached media (images/videos) if any
  - Like button + like count
  - Comment button + comment count
  - If post is by the current user: edit & delete options (via menu/kebab icon)

##### Create Post Screen
- Text input field (max **500 characters**, show character counter)
- "Add Image" button — opens image picker
- "Add Video" button — opens video picker
  - Max video duration: **30 seconds**
  - Max video file size: **50 MB**
- Option to attach run data (if sharing from a run summary)
  - Displays run stats card within the post (distance, duration, pace, map thumbnail)
- "Post" button to publish

##### Post Detail Screen
- Full post content (text + media)
- Comments section below:
  - Each comment shows: avatar, username, text, timestamp
  - Input field at bottom to add a new comment
- Like button

##### Forum Rules
- No repost/retweet functionality
- Users can **edit** their own posts
- Users can **delete** their own posts
- All posts are public (visible to all users)
- No follow/friend system in v1

---

### 6.5 Profile Page

> **Note:** This page is NOT the current development focus, but is documented for completeness.

#### Profile Display
- **Profile picture** (tappable to view larger)
- **Username**
- **Email**
- **Stats cards:**
  - Total distance (all-time, in km)
  - Total runs (count)
  - Login streak (days)
  - Total points
  - Highest pace in a single run (min/km — the fastest)

#### Run History
- List of the **last 20 runs** (most recent first)
- Each item shows: date, distance, duration, pace
- Tappable → opens run detail view (route map + full stats)
- If fewer than 20 runs, show all

#### Edit Profile
- Accessible via an edit/gear icon on the profile page
- Editable fields:
  - Username
  - Email
  - Password (requires current password confirmation)
  - Profile picture (pick from gallery)

#### Logout
- Logout button at bottom of profile page
- Confirmation dialog before logging out

---

## 7. Points & Gamification System

### Overview

Points are the core gamification currency. They represent a user's engagement and achievement in the app.

### How Points Are Earned

Currently (v1), points are earned **exclusively through Daily Missions**:

| Mission Tier | Points Awarded |
| ------------ | -------------- |
| 🥉 Bronze    | **1 point**    |
| 🥈 Silver    | **3 points**   |
| 🥇 Gold      | **5 points**   |

> **Maximum points per 3-day cycle:** 1 + 3 + 5 = **9 points**

### Points Usage (v1)

- Displayed as a score on **Home page** (most prominent) and **Profile page**
- Used for **Total Points leaderboard** ranking
- No spending/redemption mechanism in v1 (future expansion possible)

### Points Display

- Home page: Large, prominent display with a distinctive icon
- Profile page: Shown as one of the stat cards
- Leaderboard: "Total Points" category

---

## 8. Daily Mission System

### Overview

Daily missions are the primary gamification mechanic. They give users goals to work toward and reward them with points.

### Tier Structure

| Tier      | Difficulty | Point Reward | Color     | Example Missions                        |
| --------- | ---------- | ------------ | --------- | --------------------------------------- |
| 🥉 Bronze | Easy       | 1 point      | `#CD7F32` | Run 1 km, Burn 100 kcal, Run for 10 min |
| 🥈 Silver | Medium     | 3 points     | `#C0C0C0` | Run 3 km, Post in forum, Burn 300 kcal, Run for 20 min |
| 🥇 Gold   | Hard       | 5 points     | `#FFD700` | Run 5 km, Run 30 min non-stop, Burn 500 kcal |

### Mission Rotation

- All 3 tier missions are **randomized every 3 days**
- The rotation timestamp should be stored and consistent for all users (server-side or based on a fixed epoch calculation)
- On each rotation: 1 random Bronze mission + 1 random Silver mission + 1 random Gold mission are selected

### Mission Pool (Predefined List)

#### Bronze Missions (Easy)
1. Run 1 km
2. Burn 100 kcal
3. Run for 10 minutes
4. Complete 1 run
5. Walk/run 1,300 steps (≈1 km)

#### Silver Missions (Medium)
1. Run 3 km
2. Burn 300 kcal
3. Run for 20 minutes
4. Post in the community forum
5. Complete 2 runs in one day
6. Run at a pace under 7:00 min/km

#### Gold Missions (Hard)
1. Run 5 km
2. Burn 500 kcal
3. Run for 30 minutes non-stop
4. Run 7 km
5. Complete 3 runs in one day
6. Run at a pace under 6:00 min/km

### Mission Progress Tracking

- Each mission has a **progress bar** showing current vs target
- Progress updates in real-time as user completes runs or forum actions
- Once a mission is completed, mark it with a checkmark and award points
- Completed missions cannot be un-completed
- If a user completes the target mid-run, the mission is marked complete after the run ends

### Display on Home Page

- Show all 3 missions in a card/section on the home page
- Each mission shows:
  - Tier icon/badge (Bronze/Silver/Gold with corresponding color)
  - Mission description text
  - Progress bar (current / target)
  - Point reward label
  - Completion status (checkmark if done)
- Show countdown or date for next rotation: "Missions reset in X days"

---

## 9. Leaderboard System

### Categories

| Category            | Ranked By                    | Scope           |
| ------------------- | ---------------------------- | --------------- |
| **Total Points**    | Accumulated points (all-time) | Global (all users) |
| **Login Streak**    | Consecutive login days        | Global (all users) |
| **Weekly Distance** | Total km ran this week (Mon–Sun) | Global (all users) |

### Leaderboard UI

- Category selector at top (horizontally scrollable chips or segmented tabs)
- Ranked list below:
  - **Top 3**: Special podium-style display with larger cards, rank medals (🥇🥈🥉)
  - **Rank 4+**: Standard list items
- Each list item:
  - Rank number
  - User avatar (profile picture)
  - Username
  - Stat value (depends on category)
- **Current user** is always highlighted (different background color or border)
- If the current user is not in the visible range, show a sticky footer with their rank

### Data Refresh

- Leaderboard data should be fetched from Firestore
- Consider using Firestore queries with `orderBy` and `limit` for efficiency
- Weekly Distance leaderboard resets every Monday at 00:00

---

## 10. Firebase Data Models

### Collection: `users`

```
users/{userId}
├── username: String
├── email: String
├── profilePicUrl: String (Firebase Storage URL)
├── totalPoints: Number
├── loginStreak: Number
├── lastLoginDate: Timestamp
├── totalDistance: Number (km, all-time)
├── totalRuns: Number
├── highestPace: Number (min/km — lowest value = fastest)
├── weeklyDistance: Number (km, resets weekly)
├── weeklyDistanceResetDate: Timestamp
├── createdAt: Timestamp
└── updatedAt: Timestamp
```

### Collection: `runs`

```
runs/{runId}
├── userId: String (reference to user)
├── distance: Number (km)
├── duration: Number (seconds)
├── pace: Number (average pace, min/km)
├── calories: Number (kcal)
├── steps: Number (estimated)
├── route: Array of GeoPoints [{lat, lng}, ...]
├── startedAt: Timestamp (when the run started)
├── createdAt: Timestamp (Firestore server write timestamp)
```

> **Note:** Only the last 20 runs are displayed on the profile, but all runs are stored for stat calculations.

### Collection: `posts`

```
posts/{postId}
├── userId: String
├── username: String (denormalized for display)
├── userProfilePicUrl: String (denormalized)
├── content: String (max 500 chars)
├── mediaUrls: Array of Strings (image/video URLs)
├── mediaTypes: Array of Strings ("image" | "video")
├── attachedRunId: String? (optional, if sharing a run)
├── likeCount: Number
├── commentCount: Number
├── createdAt: Timestamp
├── updatedAt: Timestamp
│
├── likes/ (subcollection)
│   └── {userId}
│       └── createdAt: Timestamp
│
└── comments/ (subcollection)
    └── {commentId}
        ├── userId: String
        ├── username: String (denormalized)
        ├── userProfilePicUrl: String (denormalized)
        ├── content: String
        └── createdAt: Timestamp
```

### Collection: `missions`

```
missions/{missionCycleId}
├── cycleStartDate: Timestamp
├── cycleEndDate: Timestamp (3 days after start)
├── bronzeMission: Map
│   ├── type: String (e.g., "run_distance", "burn_calories", "run_duration")
│   ├── description: String
│   ├── targetValue: Number
│   └── unit: String (e.g., "km", "kcal", "min")
├── silverMission: Map
│   ├── type: String
│   ├── description: String
│   ├── targetValue: Number
│   └── unit: String
├── goldMission: Map
│   ├── type: String
│   ├── description: String
│   ├── targetValue: Number
│   └── unit: String
```

### Collection: `userMissions` (per-user mission progress)

```
userMissions/{userId}_{missionCycleId}
├── userId: String
├── missionCycleId: String
├── bronzeProgress: Number
├── bronzeCompleted: Boolean
├── bronzeClaimedPoints: Boolean
├── silverProgress: Number
├── silverCompleted: Boolean
├── silverClaimedPoints: Boolean
├── goldProgress: Number
├── goldCompleted: Boolean
├── goldClaimedPoints: Boolean
```

---

## 11. Development Priorities

### Phase 1 — Current Focus 🎯

These are the features actively being developed:

1. **Home Page**
   - Points display (prominent)
   - Login streak
   - Global ranking (by points)
   - Last run stats
   - Weekly stats bar chart
   - Daily mission section (with 3 tiers)

2. **Community Page**
   - Leaderboard (3 categories: points, streak, weekly distance)
   - Forum feed (create, view, like, comment, edit, delete posts)
   - Image & video uploads in posts

### Phase 2 — Future

3. **Run Page** — Live GPS tracking, route drawing, summary screen
4. **Profile Page** — Stats display, run history, edit profile
5. **Authentication** — Login, register, auth flow

> **Note:** Auth may need to be implemented first as a prerequisite for other features. Consider building a minimal auth flow before Phase 1 features.

---

## 12. Constraints & Rules

### Technical Constraints
- Android only (no iOS)
- Minimum Android 8.0 (API level 26)
- Flutter 3.44.0 / Dart 3.12.0
- Firebase backend only (no custom server)
- GPS tracking only when user explicitly starts a run (no background tracking)
- Metric units only (km, kcal)

### Content Constraints
- Forum post text: max **500 characters**
- Video upload: max **30 seconds** duration, max **50 MB** file size
- Run history on profile: max **20 recent runs** displayed
- All content is public (no private posts, no friend system in v1)

### Design Constraints
- Dark theme only
- Primary accent: Neon Green (`#B7FF00`)
- Primary backgrounds: `#25252C` and `#19191D`
- Modern, premium aesthetic with smooth animations
- Full English language

### Social Constraints (v1)
- No follow/friend system
- No repost/retweet
- No private messaging
- No "Active Today" section (skipped for v1)
- Global leaderboards (all users)

---

## Appendix: Quick Reference Card

```
┌──────────────────────────────────────────┐
│           STRAVUN QUICK REF              │
├──────────────────────────────────────────┤
│ Platform:     Android 8+ only            │
│ Framework:    Flutter 3.44.0             │
│ Backend:      Firebase                   │
│ State:        Provider                   │
│ Map:          OpenStreetMap + flutter_map │
│ Auth:         Email/Password             │
│ Units:        Metric (km, kcal)          │
│ Language:     English                    │
│ Theme:        Dark only                  │
│ Accent:       #B7FF00 (Neon Green)       │
│                                          │
│ Nav Tabs:     Home | Run | Community |   │
│               Profile                    │
│                                          │
│ Points:       Bronze=1, Silver=3, Gold=5 │
│ Missions:     Rotate every 3 days        │
│ Leaderboards: Points, Streak, Weekly Dist│
│ Forum:        500 char, img+vid, no RT   │
│ Video:        30s max, 50MB max          │
│ Run History:  Last 20 runs               │
│                                          │
│ Current Focus: Home + Community          │
└──────────────────────────────────────────┘
```

---

*Last updated: June 8, 2026*
*Document version: 1.0*
