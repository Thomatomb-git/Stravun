# Stravun — AI Coding Task Breakdown

> **Scope:** Home page + Community page (Leaderboard & Forum) only.
> **Source of truth:** `documentation.md` (feature specs & data models), `design/DESIGN.md` (visual design system), `design/*.png` (mockup references).

---

## How to Use This File

- Complete tasks **in order** — each task depends on previous tasks being done.
- Each task has a **clear deliverable** — what files to create/modify.
- Mark tasks as `[x]` when completed.
- Do **NOT** skip ahead. Foundation tasks (Phase 1-3) MUST be done before UI tasks (Phase 4-6).
- When in doubt, refer to `documentation.md` as the source of truth.

---

## Phase 1: Project Setup & Dependencies

> Goal: Get the Flutter project configured with all required packages and Firebase initialized.

### Task 1.1 — Update `pubspec.yaml` with required dependencies

Add the following packages to `pubspec.yaml`:

```yaml
dependencies:
  flutter:
    sdk: flutter
  provider: ^6.0.0
  firebase_core: ^latest
  firebase_auth: ^latest
  cloud_firestore: ^latest
  firebase_storage: ^latest
  flutter_map: ^latest
  latlong2: ^latest
  geolocator: ^latest
  shared_preferences: ^latest
  image_picker: ^latest
  intl: ^latest
  fl_chart: ^latest
  cached_network_image: ^latest
  uuid: ^latest
  timeago: ^latest
  video_player: ^latest
```

- [ ] Add all dependencies to `pubspec.yaml`
- [ ] Run `flutter pub get` to install

**Deliverable:** `pubspec.yaml` updated, `flutter pub get` runs without errors.

---

### Task 1.2 — Configure Firebase

- [ ] Ensure `firebase_options.dart` exists (generated via `flutterfire configure`)
- [ ] Initialize Firebase in `main.dart`:
  ```dart
  void main() async {
    WidgetsFlutterBinding.ensureInitialized();
    await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
    runApp(const StravunApp());
  }
  ```

**Deliverable:** App launches without Firebase errors.

---

### Task 1.3 — Set up folder structure

Create the following empty folder structure under `lib/`:

```
lib/
├── config/
├── models/
├── services/
├── providers/
├── screens/
│   ├── home/
│   └── community/
├── widgets/
│   ├── common/
│   ├── home/
│   └── community/
└── utils/
```

- [ ] Create all directories

**Deliverable:** Folder structure exists.

---

## Phase 2: Theme & Config

> Goal: Define the app's visual identity in code — colors, typography, and ThemeData. This ensures ALL subsequent UI code uses consistent, centralized styles.

### Task 2.1 — Create `lib/config/theme.dart`

Refer to `design/DESIGN.md` for the full design system. Implement:

1. **App Colors class** — static constants for all colors:
   - `backgroundPrimary` = `#25252C` (Obsidian)
   - `backgroundSurface` = `#19191D` (Ink — for cards, nav, inputs)
   - `accentNeon` = `#B7FF00` (Volt — primary CTA)
   - `textPrimary` = `#FFFFFF`
   - `textSecondary` = `#A0A0A8`
   - `borderMuted` = `#3A3A42`
   - `error` = `#FF4C4C`
   - `tierBronze` = `#CD7F32`
   - `tierSilver` = `#C0C0C0`
   - `tierGold` = `#FFD700`
   - Also include ALL Material Design color tokens from `DESIGN.md` `colors:` section (surface, on-surface, primary-container, etc.)

2. **App Text Styles** — using Google Fonts (Outfit for headings, Inter for body):
   - `displayStat`: Outfit, 48px, bold 700, tight letter-spacing (-0.02em)
   - `headlineLg`: Outfit, 32px, bold 700
   - `headlineMd`: Outfit, 24px, semibold 600
   - `bodyLg`: Inter, 18px, regular 400
   - `bodyMd`: Inter, 16px, regular 400
   - `labelMd`: Inter, 14px, semibold 600, letter-spacing 0.01em
   - `labelSm`: Inter, 12px, medium 500

3. **ThemeData** — dark theme using above colors and text styles:
   - `scaffoldBackgroundColor`: backgroundPrimary
   - `cardColor`: backgroundSurface
   - `colorScheme`: dark scheme with neon green as primary
   - `appBarTheme`: transparent/dark, no elevation
   - `bottomNavigationBarTheme`: backgroundSurface bg, neon green selected
   - `inputDecorationTheme`: dark fill, muted border, neon green focus border
   - `elevatedButtonTheme`: neon green bg, dark text

- [ ] Create `lib/config/theme.dart` with all of the above
- [ ] Add Google Fonts to `pubspec.yaml` if not already (`google_fonts` package)

**Deliverable:** `AppTheme.darkTheme` returns a complete `ThemeData`.

---

### Task 2.2 — Create `lib/utils/constants.dart`

Define app-wide constants:

```dart
class AppConstants {
  // Mission System
  static const int missionRotationDays = 3;
  static const int bronzePoints = 1;
  static const int silverPoints = 3;
  static const int goldPoints = 5;

  // Forum
  static const int maxPostCharacters = 500;
  static const int maxVideoDurationSeconds = 30;
  static const int maxVideoSizeMB = 50;

  // Profile
  static const int maxRunHistoryDisplay = 20;

  // Steps estimation
  static const double stepsPerKm = 1300;

  // Spacing (from DESIGN.md)
  static const double containerMargin = 16.0;
  static const double gutter = 16.0;
  static const double stackSm = 8.0;
  static const double stackMd = 16.0;
  static const double stackLg = 24.0;
  static const double sectionGap = 32.0;

  // Border radius (from DESIGN.md)
  static const double radiusSm = 4.0;
  static const double radiusMd = 12.0;
  static const double radiusLg = 16.0;
  static const double radiusXl = 24.0;
}
```

- [ ] Create `lib/utils/constants.dart`

**Deliverable:** Constants file with all hardcoded values centralized.

---

### Task 2.3 — Create `lib/app.dart` (MaterialApp shell)

Set up the root `MaterialApp` with:
- ThemeData from `AppTheme.darkTheme`
- A main scaffold with `BottomNavigationBar` (4 tabs: Home, Run, Community, Profile)
- Home and Community tabs should navigate to their respective screens (to be built later)
- **Run and Profile tabs**: Show a simple centered `Text("Coming Soon")` placeholder — these are NOT our scope
- Wrap with `MultiProvider` for state management (providers to be added later)

- [ ] Create `lib/app.dart`
- [ ] Update `main.dart` to use `StravunApp` from `app.dart`

**Deliverable:** App launches with bottom nav bar (4 tabs), correct theme applied, dark background, neon green active tab.

---

## Phase 3: Data Layer (Models, Services, Providers)

> Goal: Build the entire data foundation BEFORE any UI screens. This includes Firestore models, services for CRUD operations, and providers for state management.

### Task 3.1 — Create data models

Create all model classes with `fromMap`, `toMap`, and `copyWith` methods.

#### `lib/models/user_model.dart`
Fields (from `documentation.md` Section 10 — `users` collection):
- `uid` (String)
- `username` (String)
- `email` (String)
- `profilePicUrl` (String, default empty)
- `totalPoints` (int, default 0)
- `loginStreak` (int, default 0)
- `lastLoginDate` (DateTime)
- `totalDistance` (double, km, default 0)
- `totalRuns` (int, default 0)
- `highestPace` (double, min/km, default 0)
- `weeklyDistance` (double, km, default 0)
- `weeklyDistanceResetDate` (DateTime)
- `createdAt` (DateTime)
- `updatedAt` (DateTime)

#### `lib/models/run_model.dart`
Fields (from `documentation.md` — `runs` collection):
- `id` (String)
- `userId` (String)
- `distance` (double, km)
- `duration` (int, seconds)
- `pace` (double, min/km)
- `calories` (int, kcal)
- `steps` (int, estimated)
- `route` (List of LatLng)
- `startedAt` (DateTime — when the run started)
- `createdAt` (DateTime — Firestore write timestamp)

#### `lib/models/post_model.dart`
Fields (from `documentation.md` — `posts` collection):
- `id` (String)
- `userId` (String)
- `username` (String)
- `userProfilePicUrl` (String)
- `content` (String, max 500 chars)
- `mediaUrls` (List<String>)
- `mediaTypes` (List<String> — "image" or "video")
- `attachedRunId` (String?, optional)
- `likeCount` (int, default 0)
- `commentCount` (int, default 0)
- `createdAt` (DateTime)
- `updatedAt` (DateTime)

#### `lib/models/comment_model.dart`
Fields:
- `id` (String)
- `userId` (String)
- `username` (String)
- `userProfilePicUrl` (String)
- `content` (String)
- `createdAt` (DateTime)

#### `lib/models/mission_model.dart`
Two classes needed:

**MissionDefinition** — a single mission template:
- `type` (String — e.g., "run_distance", "burn_calories", "run_duration", "forum_post", "run_count", "run_pace")
- `description` (String — e.g., "Run 1 km")
- `targetValue` (double)
- `unit` (String — "km", "kcal", "min", "posts", "runs", "min/km")

**MissionCycle** — the active 3-day mission set:
- `id` (String)
- `cycleStartDate` (DateTime)
- `cycleEndDate` (DateTime)
- `bronzeMission` (MissionDefinition)
- `silverMission` (MissionDefinition)
- `goldMission` (MissionDefinition)

**UserMissionProgress** — per-user progress:
- `userId` (String)
- `missionCycleId` (String)
- `bronzeProgress` (double)
- `bronzeCompleted` (bool)
- `bronzeClaimedPoints` (bool)
- `silverProgress` (double)
- `silverCompleted` (bool)
- `silverClaimedPoints` (bool)
- `goldProgress` (double)
- `goldCompleted` (bool)
- `goldClaimedPoints` (bool)

- [ ] Create `user_model.dart`
- [ ] Create `run_model.dart`
- [ ] Create `post_model.dart`
- [ ] Create `comment_model.dart`
- [ ] Create `mission_model.dart`

**Deliverable:** All 5 model files with `fromMap`/`toMap`/`copyWith`, no compile errors.

---

### Task 3.2 — Create Firebase services

#### `lib/services/auth_service.dart`
Basic auth operations only (needed as prerequisite):
- `signInWithEmail(email, password)` → returns User
- `registerWithEmail(username, email, password)` → creates user doc in Firestore + returns User
- `signOut()`
- `getCurrentUser()` → returns current Firebase User or null
- `authStateChanges` → Stream

#### `lib/services/firestore_service.dart`
CRUD operations for all collections:

**User operations:**
- `createUser(UserModel)` → writes to `users/{uid}`
- `getUser(uid)` → returns UserModel
- `updateUser(uid, Map<String, dynamic> data)` → partial update
- `updateLoginStreak(uid)` → check lastLoginDate, increment or reset streak
- `addPoints(uid, int points)` → increment totalPoints
- `getLeaderboard(String field, {int limit = 50})` → returns List<UserModel> ordered by field descending
- `getUserRank(uid, String field)` → returns user's rank number for a given field

**Run operations:**
- `saveRun(RunModel)` → writes to `runs/` and updates user stats (totalDistance, totalRuns, weeklyDistance, highestPace)
- `getRecentRuns(uid, {int limit = 20})` → returns List<RunModel>
- `getLastRun(uid)` → returns most recent RunModel or null
- `getWeeklyRunStats(uid)` → returns daily distance for current week (Mon-Sun) as Map<int, double>

**Post operations:**
- `createPost(PostModel)` → writes to `posts/`
- `getPosts({int limit = 20, DocumentSnapshot? startAfter})` → paginated feed, newest first
- `getPostById(postId)` → returns PostModel
- `updatePost(postId, content)` → update post content
- `deletePost(postId)` → deletes post + subcollections
- `toggleLike(postId, userId)` → add/remove like in subcollection, update likeCount
- `isPostLikedByUser(postId, userId)` → returns bool
- `getComments(postId)` → returns List<CommentModel>
- `addComment(postId, CommentModel)` → writes to subcollection, increment commentCount

**Mission operations:**
- `getCurrentMissionCycle()` → returns current MissionCycle (create new one if expired)
- `getUserMissionProgress(userId, missionCycleId)` → returns UserMissionProgress
- `updateMissionProgress(UserMissionProgress)` → writes progress
- `claimMissionPoints(userId, tier)` → add points + mark as claimed

#### `lib/services/storage_service.dart`
- `uploadImage(File file, String path)` → returns download URL
- `uploadVideo(File file, String path)` → returns download URL (validate 30s / 50MB)
- `deleteFile(String url)` → deletes from storage

#### `lib/services/mission_service.dart`
Mission generation logic (NOT Firebase, pure Dart logic):
- Contains the predefined mission pools (Bronze, Silver, Gold lists from `documentation.md` Section 8)
- `generateMissionCycle(DateTime startDate)` → randomly picks 1 Bronze + 1 Silver + 1 Gold mission, returns MissionCycle
- `calculateCycleStartDate(DateTime now)` → determines current 3-day cycle start date (based on a fixed epoch, e.g., app launch date, so all users get same missions)
- `isCycleExpired(MissionCycle cycle)` → returns bool

- [ ] Create `auth_service.dart`
- [ ] Create `firestore_service.dart`
- [ ] Create `storage_service.dart`
- [ ] Create `mission_service.dart`

**Deliverable:** All 4 service files, compile without errors (even if Firebase isn't fully configured yet).

---

### Task 3.3 — Create providers

#### `lib/providers/auth_provider.dart`
- Wraps `AuthService`
- Holds current `User` and `UserModel`
- Exposes: `isLoggedIn`, `currentUser`, `userModel`
- On login/register: fetch user data, update login streak
- `notifyListeners()` on auth state changes

#### `lib/providers/home_provider.dart`
- Fetches and holds data for the home page:
  - `userModel` (points, streak, rank)
  - `lastRun` (RunModel?)
  - `weeklyStats` (Map<int, double> — day of week → distance)
  - `currentMissions` (MissionCycle)
  - `missionProgress` (UserMissionProgress)
  - `userRank` (int)
  - `pointsToNextRank` (int)
- `refreshHomeData()` method to reload all data
- Expose loading states

#### `lib/providers/community_provider.dart`
- **Leaderboard state:**
  - `selectedCategory` (enum: totalPoints, loginStreak, weeklyDistance)
  - `leaderboardUsers` (List<UserModel>)
  - `currentUserRank` (int)
  - `fetchLeaderboard(category)` method
- **Forum state:**
  - `posts` (List<PostModel>)
  - `fetchPosts()` — load posts, paginated
  - `loadMorePosts()` — pagination
  - `createPost(content, mediaFiles, attachedRunId?)`
  - `deletePost(postId)`
  - `updatePost(postId, content)`
  - `toggleLike(postId)`
  - `likedPostIds` (Set<String>) — track which posts current user has liked
- Expose loading states for both leaderboard and forum

- [ ] Create `auth_provider.dart`
- [ ] Create `home_provider.dart`
- [ ] Create `community_provider.dart`

**Deliverable:** All 3 provider files, registered in `MultiProvider` in `app.dart`.

---

## Phase 4: Shared Widgets

> Goal: Build reusable UI components before assembling screens. Refer to `design/DESIGN.md` "Components" section for styling specs.

### Task 4.1 — Common widgets

#### `lib/widgets/common/stat_card.dart`
A small card displaying a single stat (used in Last Run, Profile stats).
- Props: `icon` (IconData or Widget), `value` (String), `label` (String), `valueColor` (Color, optional)
- Style: `#19191D` bg, rounded 16px, icon + bold value + gray label

#### `lib/widgets/common/section_header.dart`
A row with section title (left) and optional action text (right).
- Props: `title` (String), `actionText` (String?), `onAction` (VoidCallback?)
- Style: White bold title, Neon green action text

#### `lib/widgets/common/progress_bar.dart`
A progress bar with customizable fill color.
- Props: `progress` (double 0.0-1.0), `fillColor` (Color), `label` (String?), `height` (double)
- Style: `#3A3A42` track, colored fill, rounded ends

#### `lib/widgets/common/user_avatar.dart`
Circular avatar with fallback to initials.
- Props: `imageUrl` (String?), `username` (String), `size` (double)
- Style: Circle, cached network image, fallback = first letter of username on colored bg

- [ ] Create `stat_card.dart`
- [ ] Create `section_header.dart`
- [ ] Create `progress_bar.dart`
- [ ] Create `user_avatar.dart`

**Deliverable:** 4 reusable widget files.

---

## Phase 5: Home Page

> Goal: Build the full Home screen. Refer to `design/home.png` for layout and `documentation.md` Section 6.2 for specs.

### Task 5.1 — Home screen skeleton

Create `lib/screens/home/home_screen.dart`:
- A `Scaffold` with scrollable body (`SingleChildScrollView` or `ListView`)
- Use `Consumer<HomeProvider>` to access data
- Show loading indicator while data is being fetched
- Call `homeProvider.refreshHomeData()` on init
- Skeleton layout with placeholder sections (to be filled in subsequent tasks):
  1. Header
  2. Points display
  3. Streak + Rank row
  4. Last Run card
  5. Weekly Stats chart
  6. Daily Missions section

- [ ] Create `home_screen.dart` with scrollable skeleton

**Deliverable:** Home screen renders with section placeholders, data loads from provider.

---

### Task 5.2 — Home: Header + Points + Streak + Rank

Create home-specific widgets in `lib/widgets/home/`:

#### `home_header.dart`
- "Hi, [username]" greeting
- "STRAVUN" branding text or logo
- Optional settings icon (top right)
- Background: subtle radial gradient or pattern (see mockup)

#### `points_display.dart`
- Large bold point number (use `displayStat` text style)
- Star/gem icon in neon green
- Most visually dominant element
- Subtle glow or accent effect

#### `streak_rank_row.dart`
- Two cards side by side (Row):
  - Left: ⚡ Streak — lightning bolt icon + number + "days" label
  - Right: 🏆 Global Rank — rank number (e.g., "8th") + "Just X points away from Yth!" subtitle
- Cards use `#19191D` bg, rounded 16px

- [ ] Create `home_header.dart`
- [ ] Create `points_display.dart`
- [ ] Create `streak_rank_row.dart`
- [ ] Integrate into `home_screen.dart`

**Deliverable:** Top section of home page matches mockup layout.

---

### Task 5.3 — Home: Last Run card

Create `lib/widgets/home/last_run_card.dart`:
- Section header: "Last Run" with "VIEW HISTORY" action (action does nothing for now)
- If no runs: show CTA text "Start your first run! 🏃"
- If has last run, show a card with:
  - Small map preview (optional — can be a dark placeholder with route icon)
  - 4 stats in a row: Distance (km), Duration (min), Calories (kcal), Pace (min/km)
  - Use `StatCard`-style display for each stat
  - Each stat has a small icon, bold value, gray label
- Card bg: `#19191D`, rounded 16px

- [ ] Create `last_run_card.dart`
- [ ] Integrate into `home_screen.dart`

**Deliverable:** Last Run section renders with real data from provider (or empty state).

---

### Task 5.4 — Home: Weekly Stats bar chart

Create `lib/widgets/home/weekly_stats_chart.dart`:
- Section header: "This Week" with total km label on the right
- Bar chart using `fl_chart` package (`BarChart`)
- X-axis: M, T, W, T, F, S, S (Mon–Sun)
- Y-axis: Distance in km
- Bar color: Neon Green (`#B7FF00`)
- Background: `#19191D` card, rounded 16px
- If no data for a day, show empty/zero bar
- Data source: `homeProvider.weeklyStats` (Map<int, double>)

- [ ] Create `weekly_stats_chart.dart`
- [ ] Integrate into `home_screen.dart`

**Deliverable:** Bar chart renders with weekly run data.

---

### Task 5.5 — Home: Daily Missions section

Create `lib/widgets/home/`:

#### `mission_card.dart`
A single mission card:
- Left: Tier icon/badge with tier color (Bronze `#CD7F32`, Silver `#C0C0C0`, Gold `#FFD700`)
- Center: Mission description text + progress bar (current/target)
- Right: Point reward label ("+1 pt", "+3 pts", "+5 pts")
- If completed: checkmark overlay, slightly different style
- Progress bar fill color = tier color
- Card bg: `#19191D`, rounded 16px
- Left accent stripe in tier color (see DESIGN.md "Cards" section)

#### `daily_missions_section.dart`
- Section header: "Daily Missions" with "Resets in X days" subtitle (gray, right-aligned)
- 3 stacked `MissionCard` widgets: Bronze, Silver, Gold
- Calculate reset countdown from `missionCycle.cycleEndDate`
- Data source: `homeProvider.currentMissions` + `homeProvider.missionProgress`

- [ ] Create `mission_card.dart`
- [ ] Create `daily_missions_section.dart`
- [ ] Integrate into `home_screen.dart`

**Deliverable:** All 3 mission tiers render with progress bars, correct tier colors, and point labels.

---

### Task 5.6 — Home: Final polish & integration test

- [ ] Verify all home sections render correctly together
- [ ] Ensure smooth scrolling
- [ ] Check spacing between sections matches DESIGN.md (`section-gap: 32px`)
- [ ] Test loading state (show shimmer or spinner while data loads)
- [ ] Test empty states (no runs, no missions yet)
- [ ] Ensure colors and typography match `design/DESIGN.md` exactly

**Deliverable:** Complete Home page that closely matches `design/home.png`.

---

## Phase 6: Community Page

> Goal: Build the Community screen with two tabs — Leaderboard and Forum. Refer to `design/leaderboard.png`, `design/forum.png`, `design/new post.png` for layout.

### Task 6.1 — Community screen shell with tabs

Create `lib/screens/community/community_screen.dart`:
- `DefaultTabController` with 2 tabs: "Leaderboard" and "Forum"
- Tab bar at top: Active tab = neon green underline + white text. Inactive = gray text
- Header with "STRAVUN" branding (same as home)
- `TabBarView` with two children (placeholder containers for now)

- [ ] Create `community_screen.dart` with tab structure

**Deliverable:** Community page with two working tabs.

---

### Task 6.2 — Leaderboard: Category chips + Top 3 podium

Create widgets in `lib/widgets/community/`:

#### `leaderboard_category_chips.dart`
- Horizontally scrollable row of chips/pills:
  - "Total Points" (default selected)
  - "Login Streak"
  - "Weekly Distance"
- Active chip: Neon green bg + dark text
- Inactive chip: `#3A3A42` bg + gray text
- On tap: update `communityProvider.selectedCategory` → re-fetch leaderboard

#### `leaderboard_podium.dart`
- Display top 3 users in podium layout (see `design/leaderboard.png`):
  - Center (Rank 1): Largest avatar, gold accent `#FFD700`, crown icon, username, stat value
  - Left (Rank 2): Medium avatar, silver accent `#C0C0C0`
  - Right (Rank 3): Medium avatar, bronze accent `#CD7F32`
- Avatars have colored ring/border matching their rank accent

- [ ] Create `leaderboard_category_chips.dart`
- [ ] Create `leaderboard_podium.dart`

**Deliverable:** Category selector and podium rendering.

---

### Task 6.3 — Leaderboard: Ranked list + current user highlight

Create `lib/widgets/community/`:

#### `leaderboard_list_item.dart`
- A single row: rank number | avatar | username | stat value (right-aligned)
- Standard item for rank 4+
- Background: transparent or subtle `#19191D`

#### `leaderboard_current_user_bar.dart`
- Sticky bar at bottom showing current user's rank
- Neon green border/outline, highlighted background
- Same layout as list item but visually distinct

Create `lib/screens/community/leaderboard_tab.dart`:
- Assembles: Category chips → Podium (top 3) → Ranked list (4+) → Current user bar
- Uses `Consumer<CommunityProvider>`
- Shows loading indicator while fetching
- Fetch leaderboard on init and on category change

- [ ] Create `leaderboard_list_item.dart`
- [ ] Create `leaderboard_current_user_bar.dart`
- [ ] Create `leaderboard_tab.dart`
- [ ] Integrate into `community_screen.dart`

**Deliverable:** Full leaderboard tab with podium, ranked list, and user highlight. Matches `design/leaderboard.png`.

---

### Task 6.4 — Forum: Post card widget

Create `lib/widgets/community/`:

#### `post_card.dart`
A single forum post card (see `design/forum.png`):
- **Header row:** User avatar (circle) | Username (bold white) | Timestamp ("2h ago", use `timeago` package) | Kebab menu (⋮) — only visible if post is by current user
- **Body:** Post text content (white, `bodyMd` style)
- **Media:** If `mediaUrls` is not empty, display image(s) or video thumbnail(s) below text. Rounded corners, tappable to fullscreen
- **Run attachment:** If `attachedRunId` is not null, show a compact run stats card with dark bg, neon green accents, showing distance/pace/time (see forum.png Sarah Chen's post)
- **Footer row:** ❤️ Like icon + count | 💬 Comment icon + count
  - Like icon: filled red if liked by current user, outlined if not
  - Tappable to toggle like
- **Kebab menu options** (only for own posts): "Edit", "Delete"
  - Delete: show confirmation dialog → call `communityProvider.deletePost()`
  - Edit: open edit dialog/screen
- Card bg: `#19191D`, rounded 16px, separated by spacing

- [ ] Create `post_card.dart`

**Deliverable:** Post card widget with all interactive elements.

---

### Task 6.5 — Forum: Feed + Create Post FAB

Create `lib/screens/community/forum_tab.dart`:
- Scrollable list of `PostCard` widgets
- Uses `Consumer<CommunityProvider>`
- Pull-to-refresh to reload posts
- Infinite scroll / "Load more" for pagination
- Empty state: "No posts yet. Be the first to share!" with illustration/icon
- Loading state: spinner or shimmer placeholders

FAB (Floating Action Button):
- Bottom-right corner
- Neon green circle with "+" icon
- On tap: navigate to Create Post screen

- [ ] Create `forum_tab.dart` with feed + FAB
- [ ] Integrate into `community_screen.dart`

**Deliverable:** Forum feed renders posts, FAB visible.

---

### Task 6.6 — Create Post screen

Create `lib/screens/community/create_post_screen.dart`:
Refer to `design/new post.png` for layout.

- **App bar:** "Create Post" title | "X" close button (left) | "Post" button (right, neon green, disabled when empty)
- **User info:** Current user avatar + username
- **Text input:** Large multi-line `TextField`
  - Placeholder: "What's on your mind?"
  - Max 500 characters
  - White text on dark bg
- **Character counter:** "0/500" below text area (gray, turns red when > 450)
- **Media section:**
  - Row of icon buttons: 📷 Photo | 🎥 Video
  - On tap photo: open `ImagePicker` for images
  - On tap video: open `ImagePicker` for videos
    - Validate: max 30 seconds duration, max 50 MB
    - Show error if exceeds limits
  - If media selected, show thumbnail previews with "X" remove button
- **Run attachment:** If navigated from run summary (via parameter), show run stats card (non-removable)
- **Post button action:**
  1. Validate: content not empty OR media attached
  2. Show loading indicator
  3. Upload media files to Firebase Storage
  4. Create post document in Firestore
  5. Navigate back to forum, new post appears at top

- [ ] Create `create_post_screen.dart`

**Deliverable:** Fully functional create post screen with text, media, and character counter.

---

### Task 6.7 — Post Detail screen (comments)

Create `lib/screens/community/post_detail_screen.dart`:

- **Full post content** at top (same layout as `PostCard` but expanded, full-width media)
- **Comments section:**
  - Header: "Comments" with count
  - List of comments, each with:
    - Avatar (small circle) | Username (bold) | Timestamp (gray)
    - Comment text below
    - Thin divider between comments
  - Empty state: "No comments yet"
- **Comment input bar:** Fixed at bottom
  - Text field with placeholder "Write a comment..."
  - Send button (neon green arrow icon)
  - On submit: add comment to Firestore subcollection, increment commentCount, refresh list
- Navigate here when user taps comment icon on a `PostCard`

- [ ] Create `post_detail_screen.dart`

**Deliverable:** Post detail with comment list and input. Comments save to Firestore.

---

### Task 6.8 — Forum: Edit post functionality

When user taps "Edit" from kebab menu on their own post:
- Open a dialog or bottom sheet with:
  - Pre-filled text content
  - "Save" and "Cancel" buttons
  - Character counter (same as create post)
- On save: update post content in Firestore via `communityProvider.updatePost()`
- Note: media editing is NOT required for v1 — only text content can be edited

- `[x]` Implement edit post functionality (dialog or bottom sheet)

**Deliverable:** Users can edit their own post text content.

---

### Task 6.9 — Community: Final polish & integration test

- `[x]` Verify tab switching works smoothly (Leaderboard ↔ Forum)
- `[x]` Verify leaderboard category switching fetches new data
- `[x]` Verify like toggle works (instant UI update + Firestore sync)
- `[x]` Verify create post → post appears in feed
- `[x]` Verify delete post → post disappears from feed
- `[x]` Verify edit post → post content updates
- `[x]` Verify comments load and submit correctly
- `[x]` Check all spacing, colors, and typography match `design/DESIGN.md`
- [ ] Test loading and empty states for both tabs

**Deliverable:** Complete Community page (both tabs) matching mockups.

---

## Phase 7: Auth Flow (Minimal — prerequisite)

> Goal: A simple login/register flow so the app can be tested with real users. Keep it minimal — auth UI is NOT our scope but is needed for testing.

### Task 7.1 — Simple login & register screens

Create minimal `lib/screens/auth/login_screen.dart` and `register_screen.dart`:
- Dark theme, centered layout
- "Stravun" branding at top
- Email + password fields (+ username and confirm password for register)
- Submit button (neon green)
- Toggle between login and register
- Use `AuthProvider` for logic
- On success: navigate to main app (bottom nav)
- On error: show snackbar with error message

- `[x]` Create `login_screen.dart`
- `[x]` Create `register_screen.dart`
- `[x]` Update `app.dart` to check auth state and show login or main app

**Deliverable:** Users can register, login, and access the main app.

---

## Phase 8: Final Integration & Testing

### Task 8.1 — End-to-end testing

- [ ] Register a new user → verify user doc created in Firestore
- [ ] Login → verify streak updates
- [ ] Home page loads all sections with real data
- [ ] Daily missions display correctly with progress
- [ ] Leaderboard shows users ranked correctly for all 3 categories
- [ ] Create a forum post with text → appears in feed
- [ ] Create a forum post with image → image displays correctly
- [ ] Like a post → like count updates
- [ ] Comment on a post → comment appears
- [ ] Edit own post → content updates
- [ ] Delete own post → post removed
- [ ] Verify all UI matches design mockups and DESIGN.md specs

### Task 8.2 — Bug fixes & polish

- [ ] Fix any visual inconsistencies
- [ ] Ensure smooth animations and transitions
- [ ] Handle edge cases (network errors, empty data, etc.)
- [ ] Performance optimization (lazy loading, caching)

**Deliverable:** Fully functional Home + Community pages, tested and polished.

---

## Summary of All Files to Create

```
lib/
├── main.dart                              (modify)
├── app.dart                               (create)
├── config/
│   └── theme.dart                         (create)
├── models/
│   ├── user_model.dart                    (create)
│   ├── run_model.dart                     (create)
│   ├── post_model.dart                    (create)
│   ├── comment_model.dart                 (create)
│   └── mission_model.dart                 (create)
├── services/
│   ├── auth_service.dart                  (create)
│   ├── firestore_service.dart             (create)
│   ├── storage_service.dart               (create)
│   └── mission_service.dart               (create)
├── providers/
│   ├── auth_provider.dart                 (create)
│   ├── home_provider.dart                 (create)
│   └── community_provider.dart            (create)
├── screens/
│   ├── auth/
│   │   ├── login_screen.dart              (create)
│   │   └── register_screen.dart           (create)
│   ├── home/
│   │   └── home_screen.dart               (create)
│   └── community/
│       ├── community_screen.dart          (create)
│       ├── leaderboard_tab.dart           (create)
│       ├── forum_tab.dart                 (create)
│       ├── create_post_screen.dart        (create)
│       └── post_detail_screen.dart        (create)
├── widgets/
│   ├── common/
│   │   ├── stat_card.dart                 (create)
│   │   ├── section_header.dart            (create)
│   │   ├── progress_bar.dart              (create)
│   │   └── user_avatar.dart               (create)
│   ├── home/
│   │   ├── home_header.dart               (create)
│   │   ├── points_display.dart            (create)
│   │   ├── streak_rank_row.dart           (create)
│   │   ├── last_run_card.dart             (create)
│   │   ├── weekly_stats_chart.dart        (create)
│   │   ├── mission_card.dart              (create)
│   │   └── daily_missions_section.dart    (create)
│   └── community/
│       ├── leaderboard_category_chips.dart (create)
│       ├── leaderboard_podium.dart        (create)
│       ├── leaderboard_list_item.dart     (create)
│       ├── leaderboard_current_user_bar.dart (create)
│       └── post_card.dart                 (create)
└── utils/
    └── constants.dart                     (create)
```

**Total: ~35 files to create/modify**

---

*Task document created: June 8, 2026*
*For use with: documentation.md + design/DESIGN.md + design/*.png*
