# Stravun — UI Design Prompt

## App Identity
- **App Name:** Stravun
- **Concept:** A gamified running tracker mobile app — users track runs, complete tiered daily missions, earn points, climb leaderboards, and interact in a social community forum.
- **Platform:** Android mobile app
- **Language:** English
- **Theme:** Dark mode only

---

## Color Palette

| Role             | Hex       | Usage                                            |
| ---------------- | --------- | ------------------------------------------------ |
| Primary BG       | `#25252C` | Main screen background                           |
| Surface/Card BG  | `#19191D` | Cards, bottom nav bar, input fields, secondary surfaces |
| Accent           | `#B7FF00` | Primary buttons, active nav, highlights, progress bars, CTAs |
| Text Primary     | `#FFFFFF` | Headings, body text, icons                       |
| Text Secondary   | `#A0A0A8` | Muted/subtitle text, timestamps, placeholders    |
| Divider/Border   | `#3A3A42` | Borders, separators, inactive elements           |
| Error            | `#FF4C4C` | Error states, delete buttons                     |
| Bronze Tier      | `#CD7F32` | Bronze mission badge/icon                        |
| Silver Tier      | `#C0C0C0` | Silver mission badge/icon                        |
| Gold Tier        | `#FFD700` | Gold mission badge/icon                          |

---

## Typography
- Font: Inter or Outfit (Google Fonts), clean modern sans-serif
- Large numbers/stats: Bold, extra-large sizing
- Body text: Regular weight, comfortable reading size
- Muted/secondary: Lighter weight, smaller size, `#A0A0A8` color

---

## Design Style
- Dark, sleek, modern, premium aesthetic
- Rounded corners on all cards and buttons (12–16px radius)
- Subtle background pattern or radial gradient on home page hero area
- Smooth micro-animations and transitions
- Clean spacing, no clutter, generous padding
- Neon green (`#B7FF00`) as the signature pop of color against the dark UI

---

## Bottom Navigation Bar
- 4 tabs, fixed at bottom
- Background: `#19191D`
- Active tab: Neon green icon + label (`#B7FF00`)
- Inactive tab: Gray icon + label (`#A0A0A8`)

| Tab         | Icon Suggestion      |
| ----------- | -------------------- |
| Home        | House / home icon    |
| Run         | Running person icon  |
| Community   | People / group icon  |
| Profile     | Person / avatar icon |

---

## Screens to Design

### Screen 1: Home Page

The main dashboard. Scrollable, single-column layout.

**Section 1 — Hero / Header**
- Top-left: "Hi, [Username]" greeting in white
- Center: "Stravun" app name or logo, large and prominent
- Background: subtle radial gradient or concentric circle pattern emanating from center, using dark tones

**Section 2 — Points Display (Most Prominent)**
- A large, bold number showing total points (e.g., "247")
- Accompanied by a distinctive icon (star, gem, or custom point icon) in neon green
- This should be the most visually dominant element — big font, neon green accent

**Section 3 — Login Streak**
- Lightning bolt ⚡ icon in neon green + streak number (e.g., "128 days")
- Slightly smaller than points, but still prominent
- Positioned near points display

**Section 4 — Global Ranking**
- Large rank number (e.g., "8th") in bold white
- Motivational subtitle: "Just 52 points away from 7th place!" in gray text

**Section 5 — Last Run**
- Card with `#19191D` background
- Title: "Last Run" or "Last Activity"
- 3–4 stat items in a row or grid:
  - 🏃 Distance: "3.2 km"
  - ⏱ Duration: "28 min"
  - 🔥 Calories: "245 kcal"
  - ⚡ Pace: "8:45 min/km"
- Each stat has a small colored icon, value in bold white, label in gray

**Section 6 — Weekly Stats Bar Chart**
- Title: "This Week"
- Horizontal bar chart or vertical bars for Mon–Sun
- Bars colored in neon green (`#B7FF00`)
- X-axis: Mon, Tue, Wed, Thu, Fri, Sat, Sun
- Y-axis: Distance in km
- Dark card background (`#19191D`)

**Section 7 — Daily Missions**
- Title: "Daily Missions"
- Subtitle: "Resets in X days" in gray
- 3 stacked mission cards, one per tier:

  **Bronze Mission Card:**
  - Left: Bronze medal icon 🥉 in `#CD7F32`
  - Middle: Mission text (e.g., "Run 1 km") + progress bar (current/target)
  - Progress bar fill: `#CD7F32`
  - Right: "+1 pt" label
  - Checkbox/checkmark if completed

  **Silver Mission Card:**
  - Same layout, Silver icon 🥈 in `#C0C0C0`
  - Progress bar fill: `#C0C0C0`
  - Right: "+3 pts"

  **Gold Mission Card:**
  - Same layout, Gold icon 🥇 in `#FFD700`
  - Progress bar fill: `#FFD700`
  - Right: "+5 pts"

---

### Screen 2: Run Page (Pre-Run State)

- Full-screen map (OpenStreetMap, dark map style if possible)
- Map centered on user's current GPS location
- Location marker/pin on the map
- Large, circular "Start Run" button at the bottom center
  - Neon green (`#B7FF00`) background, dark text/icon
  - Running person icon or play icon inside
  - Prominent, impossible to miss

---

### Screen 3: Run Page (Active Tracking State)

- **Top half:** Live map showing the route being drawn in real-time
  - Route line: Neon green (`#B7FF00`), 4-5px width
  - Current position: Glowing dot or marker
- **Bottom half:** Dark overlay panel with real-time stats in a 2x2 grid:
  - Distance: "2.4 km" (large bold number)
  - Duration: "18:32" (timer format)
  - Pace: "7:43 min/km"
  - Calories: "186 kcal"
- **Bottom controls:**
  - Pause button (circle, outlined)
  - Stop button (circle, red `#FF4C4C` or outlined)
  - Buttons should be large and easy to tap while running

---

### Screen 4: Run Summary (Post-Run)

- **Top section:** Map showing the complete route drawn on it
  - Route line: Neon green
- **Stats section:** Card below the map with summary stats:
  - Total Distance, Duration, Average Pace, Calories, Steps
  - Arranged in a clean grid or list
- **Action buttons at bottom:**
  - "Share to Community" — Neon green filled button (primary)
  - "Save" — Outlined/secondary button
  - "Discard" — Text button in red/gray

---

### Screen 5: Community Page — Leaderboard Tab

- **Tab selector at top:** Two tabs — "Leaderboard" (active) and "Forum"
  - Active tab: Neon green underline + white text
  - Inactive tab: Gray text

- **Category selector:** Horizontally scrollable chips/pills below the tabs
  - Options: "Total Points", "Login Streak", "Weekly Distance"
  - Active chip: Neon green background with dark text
  - Inactive chip: `#3A3A42` background with gray text

- **Top 3 Podium Section:**
  - Special display for rank 1, 2, 3
  - Rank 1 (center, largest): Gold accent (`#FFD700`), large avatar, username, stat value
  - Rank 2 (left): Silver accent (`#C0C0C0`)
  - Rank 3 (right): Bronze accent (`#CD7F32`)
  - Crown or medal icon on rank 1

- **Ranked List (Rank 4+):**
  - Each row: rank number, small avatar, username, stat value (right-aligned)
  - Current user's row: highlighted with neon green border or subtle green background tint
  - If current user is far down, show a sticky bar at the bottom with their rank

---

### Screen 6: Community Page — Forum Tab

- **Tab selector at top:** "Leaderboard" and "Forum" (Forum is active)

- **Floating Action Button (FAB):** Bottom-right corner
  - Neon green circle with "+" icon
  - Opens the create post screen

- **Post Feed:** Scrollable list of post cards, newest first
  - Each post card (`#19191D` background, rounded corners):
    - **Header row:** Avatar (circle, small) | Username (bold white) | Timestamp (gray, right-aligned, e.g., "2h ago")
    - **Body:** Post text content in white
    - **Media:** If attached, show image(s) or video thumbnail below text (rounded corners)
    - **Run attachment:** If sharing a run, show a compact run stats card (mini map, distance, pace) with neon green accent
    - **Footer row:** ❤️ Like icon + count | 💬 Comment icon + count
    - **Kebab menu (⋮):** Only on own posts — options: Edit, Delete
  - Cards separated by subtle spacing

---

### Screen 7: Create Post Screen

- **Top bar:** "Create Post" title, "X" close button (left), "Post" button (right, neon green)
- **User info:** Avatar + username at top
- **Text area:** Large text input, placeholder "What's on your mind?", white text on dark bg
- **Character counter:** "0/500" in gray, bottom-right of text area, turns red near limit
- **Media attachment bar:** Below text area
  - 📷 "Photo" button — icon + label
  - 🎥 "Video" button — icon + label
  - If media attached, show thumbnail preview with an "X" remove button
- **Run attachment:** If opened from run summary, show attached run card (non-removable or with remove option)

---

### Screen 8: Post Detail Screen

- **Full post content:** Same layout as feed card but expanded
  - Avatar, username, timestamp
  - Full text
  - Full-size media (images/videos)
  - Like button + count, comment count
- **Comments section below:**
  - Section title: "Comments"
  - List of comments, each with:
    - Avatar (small) | Username (bold) | Timestamp (gray)
    - Comment text below
  - Separated by thin dividers
- **Comment input bar:** Fixed at bottom
  - Text input field with placeholder "Write a comment..."
  - Send button (neon green arrow icon)

---

### Screen 9: Login Screen

- Dark background (`#25252C`)
- **Center logo/title:** "Stravun" large text or logo, with neon green accent
- **Subtitle:** "Track. Run. Have Fun." or similar tagline in gray
- **Email field:** Outlined input, rounded corners, dark surface bg
- **Password field:** Same style, with show/hide toggle icon
- **"Login" button:** Full-width, neon green background, dark bold text, rounded
- **Bottom text:** "Don't have an account? Register" — "Register" in neon green (tappable)

---

### Screen 10: Register Screen

- Same style as login
- **Fields:** Username, Email, Password, Confirm Password
- **"Register" button:** Full-width, neon green
- **Bottom text:** "Already have an account? Login" — "Login" in neon green

---

### Screen 11: Profile Page

- **Header section:**
  - Large profile picture (circle, centered or left-aligned)
  - Username (large, bold, white)
  - Email (gray, below username)
  - Edit icon/button (top-right, pen icon)

- **Stats Grid:** 2-column or 3-column grid of stat cards (`#19191D` bg):
  - Total Distance: "XX.X km"
  - Total Runs: "XX"
  - Login Streak: "XX days" ⚡
  - Total Points: "XXX" ⭐
  - Best Pace: "X:XX min/km" 🏆

- **Run History Section:**
  - Title: "Recent Runs"
  - List of up to 20 run items:
    - Each item: Date (left) | Distance + Duration (center) | Pace (right)
    - Tappable → goes to run detail
  - If no runs: "No runs yet. Start your first run!" with CTA

- **Logout Button:** At bottom, outlined or text style, red tint or gray
