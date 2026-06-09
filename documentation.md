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
11. [Constraints & Rules](#12-constraints--rules)

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

### Core Philosophy

Stravun differentiates itself from typical running apps by making fitness **fun**. Users don't just track runs — they complete tiered daily missions (Bronze, Silver, Gold) to earn points, climb leaderboards, and engage with a social community. The gamification layer is the heart of the app.

---

## 2. Tech Stack

### Framework & Language

| Component            | Version / Detail                              |
| -------------------- | --------------------------------------------- |
| **Flutter**          | 3.44.0 (stable channel)                      |
| **Dart**             | 3.12.0                                       |
| **State Management** | Provider (official Flutter recommendation)    |

### Backend — Firebase

| Service               | Purpose                                         |
| ---------------------- | ----------------------------------------------- |
| **Firebase Auth**      | Email/password authentication                   |
| **Cloud Firestore**    | Primary database (users, runs, posts, missions) |
| **Firebase Storage**   | Image & video uploads (forum posts)             |

> **Note:** Firestore has built-in offline persistence, so the app works offline for cached data.

### Map & Location

| Component          | Detail                                              |
| ------------------ | --------------------------------------------------- |
| **Map Provider**   | OpenStreetMap (free, no API key required)            |
| **Map Package**    | `flutter_map` + `latlong2`                          |
| **Location**       | `geolocator` package for GPS tracking               |
| **Tracking**       | GPS-based only — no background tracking              |
| **Step Estimation** | Estimated from GPS distance (~1,300 steps per km)   |

### Key Flutter Packages

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
| **Darker BG**   | `#19191D`   | Cards, secondary surfaces                     |
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
- **Typography** — Outfit (headings/display) and Inter (body/labels) from Google Fonts

---

## 4. App Architecture

### Folder Structure

```
lib/
├── main.dart                    # App entry point
├── app.dart                     # MaterialApp, AuthGate, MainNavigation, CustomPlanetIcon
├── firebase_options.dart        # Firebase config (generated)
│
├── config/
│   └── theme.dart               # AppColors, AppTextStyles, AppTheme
│
├── models/
│   ├── user_model.dart          # User data model
│   ├── run_model.dart           # Run/activity data model
│   ├── post_model.dart          # Forum post data model
│   ├── comment_model.dart       # Comment data model
│   └── mission_model.dart       # MissionDefinition, MissionCycle, UserMissionProgress
│
├── services/
│   ├── auth_service.dart        # Firebase Auth operations
│   ├── firestore_service.dart   # Firestore CRUD operations
│   ├── storage_service.dart     # Firebase Storage uploads (images & videos)
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
│   │   ├── run_map_screen.dart      # Live GPS tracking screen
│   │   └── run_summary_screen.dart  # Post-run summary
│   ├── community/
│   │   ├── community_screen.dart    # Tab container (Leaderboard + Forum)
│   │   ├── leaderboard_tab.dart     # Leaderboard view
│   │   ├── forum_tab.dart           # Forum feed
│   │   ├── create_post_screen.dart  # New post screen
│   │   └── post_detail_screen.dart  # Post + comments
│   └── profile/
│       ├── profile_screen.dart
│       └── profile_edit_screen.dart # Edit username
│
├── widgets/
│   ├── common/
│   │   ├── progress_bar.dart    # Reusable progress bar
│   │   ├── section_header.dart  # Section header with title & optional action
│   │   ├── stat_card.dart       # Stat display card
│   │   └── user_avatar.dart     # User avatar widget
│   ├── home/
│   │   ├── daily_missions_section.dart
│   │   ├── home_header.dart
│   │   ├── last_run_card.dart
│   │   ├── mission_card.dart
│   │   ├── points_display.dart
│   │   ├── streak_rank_row.dart
│   │   └── weekly_stats_chart.dart
│   └── community/
│       ├── leaderboard_category_chips.dart
│       ├── leaderboard_current_user_bar.dart
│       ├── leaderboard_list_item.dart
│       ├── leaderboard_podium.dart
│       └── post_card.dart
│
└── utils/
    └── constants.dart           # App-wide constants (spacing, radii, mission config)
```

### State Management

- **AuthProvider** — Manages Firebase Auth state, listens to `authStateChanges`, handles login streak update on sign-in, self-heals missing Firestore user documents.
- **HomeProvider** — Proxy-depends on AuthProvider. Fetches user stats, last run, weekly stats, missions, and user rank. Provides pull-to-refresh via `refreshHomeData()`.
- **CommunityProvider** — Proxy-depends on AuthProvider. Manages leaderboard data (3 categories), forum posts (CRUD, likes), and comments.
- **Profile page** uses `StreamBuilder<DocumentSnapshot>` directly (no dedicated provider).

### Navigation

All navigation is imperative using `Navigator.push()`, `Navigator.pop()`, and `Navigator.pushReplacement()` with `MaterialPageRoute`. There is no named route configuration.

---

## 5. Navigation Structure

### Bottom Navigation Bar — 4 Tabs

| Index | Label         | Icon                            | Screen             |
| ----- | ------------- | ------------------------------- | ------------------ |
| 0     | **Home**      | `home_outlined`                 | `HomeScreen`       |
| 1     | **Map**       | `map_outlined`                  | `RunMapScreen`     |
| 2     | **Community** | Custom planet icon (circle + diagonal ring) | `CommunityScreen` |
| 3     | **User**      | `person_outline`                | `ProfileScreen`    |

- Bottom nav bar uses **Dark BG** (`#25252C`) background
- Active tab icon/label uses **Neon Green** (`#B7FF00`)
- Inactive tab icon/label uses **White** (`#FFFFFF`)
- Active and inactive icons are identical (only color changes)

---

## 6. Feature Specifications

### 6.1 Authentication

#### Login Screen
- Email input field
- Password input field (obscured)
- "Login" button (Neon Green)
- "Register" text button (navigates to Register screen)
- Form validation (email must contain `@` and `.`, password min 6 chars)
- Firebase error handling with user-friendly SnackBar messages

#### Register Screen
- Full Name input field (min 3 characters)
- Email input field
- Password input field (min 6 characters)
- "Register" button (Neon Green)
- Back arrow button (pops to Login)
- On successful registration: creates Firebase Auth user, sets display name, creates user document in Firestore with default values

#### Auth Flow
- On app launch: `AuthGate` widget listens to Firebase Auth state
- If loading → shows loading spinner
- If logged in → navigates to `MainNavigation`
- If not → navigates to `LoginScreen`
- On login: updates login streak and self-heals missing Firestore fields
- Logout available from Profile page (no confirmation dialog)

---

### 6.2 Home Page

The home page is the app's dashboard — showing the user's stats, progress, missions, and ranking at a glance. Supports pull-to-refresh.

#### Layout (Top to Bottom)

1. **Header / Greeting**
   - "Hi, [username]" text

2. **Points Display** (most prominent element)
   - Large point number with a distinctive icon
   - This is the user's total accumulated points
   - Visually the most eye-catching element on the page

3. **Streak & Rank Row**
   - **Login Streak** — Lightning bolt icon ⚡ + streak number (e.g., "128")
     - Shows consecutive days the user has logged into the app
     - Resets to 1 if user misses a day
   - **Global Ranking** — Display user's rank number (e.g., "8th")
     - Subtitle: "Just X points away from Yth place!" (motivational)
     - Ranking is based on **total points**

4. **Daily Missions** (see [Section 8](#8-daily-mission-system) for full details)
   - Show 3 mission tiers: Bronze 🥉, Silver 🥈, Gold 🥇
   - Each with a progress bar and completion status
   - Missions reset every 3 days

5. **Last Run**
   - Section header with title "Last Run"
   - Shows stats from the user's most recent run:
     - Mini route map (non-interactive FlutterMap with polyline)
     - Distance (km)
     - Duration (minutes)
     - Calories burned (kcal)
   - If no runs yet, show empty state: "Start your first run! 🏃"

6. **Weekly Stats** (Bar Chart)
   - Bar chart showing distance per day (Mon–Sun)
   - Based on tracked runs only
   - Uses `fl_chart` package
   - Bars colored with Neon Green
   - Background bars show track in Dark BG color
   - Header shows "This Week" with total km

---

### 6.3 Run Page

#### Pre-Run State
- Full-screen map centered on user's current GPS location (fallback: Jakarta coordinates)
- Status text: "Ready to Run"
- Bottom panel showing stats (Time: 00:00, Pace: 0.0, km: 0.00)
- Large green play circle button to start

#### Active Tracking State
When user taps the play button:
- Status text: "Recording"
- **Live map** showing real-time route being drawn as a neon green polyline
- Blue dot marker for current position
- Auto-centers map on each GPS update
- **Real-time stats in bottom panel:**
  - Time (duration, formatted MM:SS or HH:MM:SS)
  - Pace (min/km)
  - Distance (km)
- **Controls:**
  - Pause button (outlined circle with neon green border)

#### Paused State
- Status text: "Paused"
- Two buttons side by side:
  - **Stop** (red circle) — ends the run
  - **Resume** (green circle) — continues tracking

#### Tracking Behavior
- GPS tracking ONLY runs when user explicitly starts a run
- No background tracking whatsoever
- App requests location permission (fine location) via `geolocator`
- GPS stream with `distanceFilter: 2` meters and `LocationAccuracy.high`
- Distance calculated using `latlong2` Distance utility
- Steps estimated from distance (~1,300 steps/km)
- Calories estimated (~60 kcal/km)
- Pace calculated as `(seconds / 60) / distance`

#### Post-Run Summary Screen
After user taps "Stop":
- **Route map** — full route drawn on non-interactive map with start marker (green play icon) and end marker (red stop icon)
- **Summary stats:**
  - Primary row: Distance (km), Time, Avg Pace (min/km)
  - Secondary row: Calories (kcal), Steps
- **Actions:**
  - "Discard" button (red outlined) → goes back without saving
  - "Save" button → saves run to Firestore, refreshes home data, goes back
  - "Share to Community" button (Neon Green, full width) → saves run then navigates to Create Post screen with run data attached

#### Run Data Saved
Each completed run saves to Firestore and automatically:
- Updates user stats (totalDistance, totalRuns, weeklyDistance, highestPace)
- Evaluates mission progress

---

### 6.4 Community Page

The community page has **two tabs**: Leaderboard and Forum.

#### 6.4.1 Leaderboard Tab

See [Section 9: Leaderboard System](#9-leaderboard-system) for full details.

- Multiple leaderboard categories displayed as horizontally scrollable chips:
  - **Total Points** (default)
  - **Login Streak**
  - **Weekly Distance** (total km this week)
- Top 3 users displayed in a podium-style layout
- Remaining users in a ranked list with:
  - Rank number
  - User avatar
  - Username
  - Relevant stat value
- Current user's rank shown in a sticky bar at the bottom

#### 6.4.2 Forum Tab

Social feed. All posts are public.

##### Forum Feed
- Scrollable list of posts, newest first
- Each post card shows:
  - Author avatar
  - Author username
  - Post timestamp (relative: "2h ago", "1d ago" via `timeago` package)
  - Post text content
  - Attached media (images/videos) if any
  - Like button + like count
  - Comment button + comment count
  - If post is by the current user: kebab menu with edit & delete options
- Floating action button (`+` icon) to create new post
- Pull-to-refresh support

##### Create Post Screen
- User avatar and username shown at top
- Text input field (max **500 characters**, with character counter)
- Bottom toolbar with image/video picker icons:
  - Image picker → selects from gallery
  - Video picker → selects from gallery (max 30 seconds, max 50 MB)
- Shows attached media thumbnails with remove button
- If created from a run share: shows "Run Attached" badge and run stats preview
- "Post" button in AppBar to publish
- Media uploaded to Firebase Storage (`posts/{postId}/media_{index}`)

##### Post Detail Screen
- Full post content via PostCard widget
- Comments section below:
  - Each comment shows: avatar, username, text, relative timestamp
  - Input field at bottom to add a new comment
- Like button with toggle functionality
- If post belongs to current user: popup menu with "Edit" and "Delete" options
  - Edit: opens a dialog to modify post content
  - Delete: confirmation dialog, then deletes post and all subcollections

##### Forum Rules
- No repost/retweet functionality
- Users can **edit** their own posts (content only)
- Users can **delete** their own posts
- All posts are public (visible to all users)
- No follow/friend system

---

### 6.5 Profile Page

#### Profile Display
- **Header section** (surface background):
  - CircleAvatar with person icon (default, no profile picture upload)
  - Username (bold, large)
  - Email (gray, smaller)
  - "edit" button → navigates to Profile Edit screen
- **Stats section** ("YOUR STATS"):
  - Best Pace (min/km — the fastest, lowest value)
  - Total Points
  - KM Total Distance (all-time)
  - Day Streak (login streak)
  - Total Runs (count)

#### Edit Profile
- Header with CircleAvatar and email display
- Editable field: **Username only**
- "Cancel" button (pops back) and "Save" button (neon green, saves to Firestore)

#### Logout
- Logout button at bottom of profile page (red outlined button)
- Directly logs out (no confirmation dialog)

---

## 7. Points & Gamification System

### Overview

Points are the core gamification currency. They represent a user's engagement and achievement in the app.

### How Points Are Earned

Points are earned **exclusively through Daily Missions** and are **automatically awarded** upon mission completion:

| Mission Tier | Points Awarded |
| ------------ | -------------- |
| 🥉 Bronze    | **1 point**    |
| 🥈 Silver    | **3 points**   |
| 🥇 Gold      | **5 points**   |

> **Maximum points per 3-day cycle:** 1 + 3 + 5 = **9 points**

### Points Auto-Claim

When `evaluateMissions` detects that a mission target has been reached, it immediately calls `claimMissionPoints` to add points to the user's `totalPoints`. There is no manual "claim" step — points are awarded automatically.

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
- The rotation uses a deterministic seed based on the cycle start date, ensuring the same missions are selected for all users within a cycle
- Cycle start date is calculated from a fixed epoch using `AppConstants.missionRotationDays` (3 days)
- On each rotation: 1 random Bronze mission + 1 random Silver mission + 1 random Gold mission are selected

### Mission Pool (Predefined List)

#### Bronze Missions (Easy)
1. Run 1 km (`run_distance`, target: 1.0 km)
2. Burn 100 kcal (`burn_calories`, target: 100 kcal)
3. Run for 10 minutes (`run_duration`, target: 10 min)
4. Complete 1 run (`run_count`, target: 1 run)
5. Walk/run 1,300 steps (`run_steps`, target: 1300 steps)

#### Silver Missions (Medium)
1. Run 3 km (`run_distance`, target: 3.0 km)
2. Burn 300 kcal (`burn_calories`, target: 300 kcal)
3. Run for 20 minutes (`run_duration`, target: 20 min)
4. Post in the community forum (`forum_post`, target: 1 post)
5. Complete 2 runs (`run_count`, target: 2 runs)
6. Run at a pace under 7:00 min/km (`run_pace`, target: 7.0 min/km)

#### Gold Missions (Hard)
1. Run 5 km (`run_distance`, target: 5.0 km)
2. Burn 500 kcal (`burn_calories`, target: 500 kcal)
3. Run for 30 minutes non-stop (`run_duration`, target: 30 min)
4. Run 7 km (`run_distance`, target: 7.0 km)
5. Complete 3 runs (`run_count`, target: 3 runs)
6. Run at a pace under 6:00 min/km (`run_pace`, target: 6.0 min/km)

### Mission Progress Tracking

- Each mission has a **progress bar** showing current vs target
- Progress updates automatically when user completes runs or forum actions
- Mission evaluation happens in `evaluateMissions()` which is called by:
  - `saveRun()` — evaluates run-based missions (distance, calories, duration, count, steps, pace)
  - `createPost()` — evaluates `forum_post` missions
- Once a mission is completed, points are automatically awarded
- Completed missions cannot be un-completed

### Display on Home Page

- Show all 3 missions in the Daily Missions section
- Each mission shows:
  - Tier icon/badge (Bronze/Silver/Gold with corresponding color)
  - Mission description text
  - Progress bar (current / target)
  - Point reward label
  - Completion status (checkmark if done)

---

## 9. Leaderboard System

### Categories

| Category            | Ranked By                    | Field Used       | Scope           |
| ------------------- | ---------------------------- | ---------------- | --------------- |
| **Total Points**    | Accumulated points (all-time) | `totalPoints`   | Global (all users) |
| **Login Streak**    | Consecutive login days        | `loginStreak`   | Global (all users) |
| **Weekly Distance** | Total km ran this week (Mon–Sun) | `weeklyDistance` | Global (all users) |

### Leaderboard UI

- **Category selector** at top: horizontally scrollable chips (default: Total Points)
- **Top 3**: Podium-style display with special visual treatment
- **Rank 4+**: Standard list items with rank number, avatar, username, stat value
- **Current user**: Sticky bottom bar showing their current rank
- Rank calculated using Firestore aggregate `count()` query (counts users with higher value)

### Data Source

- Leaderboard fetches top 50 users via `getLeaderboard(field, limit: 50)` with Firestore `orderBy` descending
- Current user rank fetched separately via `getUserRank(uid, field)`

---

## 10. Firebase Data Models

### Collection: `users`

```
users/{userId}
├── username: String
├── email: String
├── profilePicUrl: String (Firebase Storage URL, default: '')
├── totalPoints: Number (default: 0)
├── loginStreak: Number (default: 0)
├── lastLoginDate: Timestamp
├── totalDistance: Number (km, all-time, default: 0)
├── totalRuns: Number (default: 0)
├── highestPace: Number (min/km — lowest value = fastest, default: 0)
├── weeklyDistance: Number (km, resets weekly, default: 0)
├── weeklyDistanceResetDate: Timestamp
├── createdAt: Timestamp
└── updatedAt: Timestamp
```

> **Note:** `uid` is the document ID and is NOT stored as a field within the document.

### Collection: `runs`

```
runs/{runId}
├── userId: String (reference to user)
├── distance: Number (km)
├── duration: Number (seconds)
├── pace: Number (average pace, min/km)
├── calories: Number (kcal, estimated ~60 kcal/km)
├── steps: Number (estimated ~1,300 steps/km)
├── route: Array of GeoPoints [{latitude, longitude}, ...]
├── startedAt: Timestamp (when the run started)
└── createdAt: Timestamp (when the run was saved)
```

> **Note:** `id` is the document ID (UUID generated client-side) and is NOT stored as a field.

### Collection: `posts`

```
posts/{postId}
├── userId: String
├── username: String (denormalized for display)
├── userProfilePicUrl: String (denormalized)
├── content: String (max 500 chars)
├── mediaUrls: Array of Strings (image/video download URLs from Firebase Storage)
├── mediaTypes: Array of Strings ("image" | "video")
├── attachedRunId: String? (optional, if sharing a run)
├── likeCount: Number (default: 0)
├── commentCount: Number (default: 0)
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
│   ├── type: String (e.g., "run_distance", "burn_calories", "run_duration", "run_count", "run_steps")
│   ├── description: String
│   ├── targetValue: Number
│   └── unit: String (e.g., "km", "kcal", "min", "runs", "steps")
├── silverMission: Map
│   ├── type: String (includes "forum_post", "run_pace" in addition to bronze types)
│   ├── description: String
│   ├── targetValue: Number
│   └── unit: String (e.g., "km", "kcal", "min", "posts", "runs", "min/km")
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
├── bronzeProgress: Number (default: 0)
├── bronzeCompleted: Boolean (default: false)
├── bronzeClaimedPoints: Boolean (default: false)
├── silverProgress: Number (default: 0)
├── silverCompleted: Boolean (default: false)
├── silverClaimedPoints: Boolean (default: false)
├── goldProgress: Number (default: 0)
├── goldCompleted: Boolean (default: false)
├── goldClaimedPoints: Boolean (default: false)
```

> **Note:** Document ID is a composite key: `{userId}_{missionCycleId}`.

---

## 11. Constraints & Rules

### Technical Constraints
- Android only (no iOS)
- Minimum Android 8.0 (API level 26)
- Flutter 3.44.0 / Dart 3.12.0
- Firebase backend only (no custom server)
- GPS tracking only when user explicitly starts a run (no background tracking)
- Metric units only (km, kcal)
- No Firestore composite indexes used — queries with multiple filters are filtered locally

### Content Constraints
- Forum post text: max **500 characters**
- Video upload: max **30 seconds** duration, max **50 MB** file size
- All content is public (no private posts, no friend system)

### Design Constraints
- Dark theme only
- Primary accent: Neon Green (`#B7FF00`)
- Primary backgrounds: `#25252C` and `#19191D`
- Modern, premium aesthetic with smooth animations
- Full English language
- Typography: Outfit (headings) + Inter (body) via Google Fonts

### Social Constraints
- No follow/friend system
- No repost/retweet
- No private messaging
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
│ Nav Tabs:     Home | Map | Community |   │
│               User                       │
│                                          │
│ Points:       Bronze=1, Silver=3, Gold=5 │
│ Missions:     Rotate every 3 days        │
│ Leaderboards: Points, Streak, Weekly Dist│
│ Forum:        500 char, img+vid, no RT   │
│ Video:        30s max, 50MB max          │
│                                          │
│ Profile Edit: Username only              │
│ Logout:       No confirmation dialog     │
│ Points:       Auto-claimed on completion │
└──────────────────────────────────────────┘
```

---

*Last updated: June 9, 2026*
*Document version: 2.0 — Finalized to match implemented codebase*
