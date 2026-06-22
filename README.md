# Louco – Ask AI Event Discovery

A Flutter implementation of the Ask AI event discovery feature, built as a technical assignment.

## Features

- **Home Page** – Featured event hero with horizontal scroll of today's events
- **Discover Page** – Search bar with filter chips and an **Ask AI** button
- **AI Chat Bottom Sheet** – Conversational interface with suggested prompts, typing indicator, and
  event results grid
- **Event Details Page** – Full-screen event detail view with hero image and ticket CTA
- **Event Card** – Reusable card component with image, time badge, category badge, and favourite
  toggle

## Setup

**Requirements:** Flutter 3.x, Dart 3.x

```bash
# Install dependencies
flutter pub get

# Run on a connected device or simulator
flutter run

# Build debug APK
flutter build apk --debug
```

## Architecture

```
lib/
├── core/
│   ├── data/         # EventsRepository + EventsDataSource (shared, mocked)
│   ├── extensions/   # BuildContext extensions (l10n shorthand)
│   ├── models/       # Shared data models (Event)
│   ├── theme/        # AppColors + AppTheme
│   ├── utils/        # DateTimeFormatter
│   └── widgets/      # Shared EventCard widget
├── features/
│   ├── home/
│   │   ├── bloc/               # HomeCubit + HomeState
│   │   └── presentation/
│   │       ├── pages/          # HomePage
│   │       └── widgets/        # FeaturedSection, TodaySection
│   ├── discover/
│   │   ├── bloc/               # DiscoverCubit + DiscoverState
│   │   └── presentation/
│   │       ├── pages/          # DiscoverPage
│   │       └── widgets/        # SearchBar, FilterRow, SortRow, EventGrid, …
│   ├── ai_chat/
│   │   ├── bloc/               # AiChatBloc + events + states
│   │   ├── data/               # AiChatRepository + AiChatDataSource
│   │   └── presentation/
│   │       ├── pages/          # AiChatBottomSheet
│   │       └── widgets/        # ChatBubble, ChatInput, MessageList, …
│   └── event_details/          # No BLoC — static display only
│       └── presentation/
│           ├── pages/          # EventDetailsPage
│           └── widgets/        # EventHeroAppBar, EventDetailsBody, …
├── l10n/             # Localisation (AppLocalizations, English ARB)
├── app.dart          # MaterialApp + bottom nav shell
└── main.dart         # Entry point
```

**State management:** `flutter_bloc` (BLoC pattern)

- `HomeCubit` — loads the featured event and today's events in parallel; emits `HomeLoading` →
  `HomeLoaded` / `HomeError`.
- `DiscoverCubit` — loads the discover event list; emits `DiscoverLoading` → `DiscoverLoaded` /
  `DiscoverError`.
- `AiChatBloc` — manages the full conversation lifecycle: initial greeting → user message (status:
  `sending`) → typing indicator → AI response with events (status: `sent` / `failed` / empty). There
  is no separate loading state — the user message appears in the list immediately with a `sending`
  status, and a typing indicator is shown while the response is in flight. If the API returns an
  empty response, a retry button is shown in place of the AI bubble; tapping it removes the
  placeholder and re-sends the original message.

**Navigation:** `Navigator.push` from within the bottom nav shell; the bottom sheet dismisses itself
before navigating to event details.

**API:** All data is mocked locally — there is no real backend.

- `EventsDataSource` returns hardcoded event lists for the Home and Discover screens.
- `AiChatDataSource` simulates a 1.2-second response delay and applies keyword matching to return
  contextually relevant events (e.g. "free", "pop", "tonight"). The mock cycles through fixed
  behaviours to demonstrate all UI states:
    - **1st call** — success with events
    - **2nd call** — throws, to demonstrate the error state and tap-to-retry on the user bubble
    - **3rd call** — success again
    - **4th call** — returns an empty response, to demonstrate the empty-response retry button in
      place of the AI bubble
    - **5th+ calls** — success

  Swapping in a real endpoint means only changing `sendMessage()`.

## What Was Added

- [x] Theme
- [x] Localization, with extension for more convenient usage
- [x] Feature-first clean architecture
- [x] Tests for business logic — all BLoCs, Cubits, and utilities are covered (40 tests across 5
  files: `AiChatBloc`, `MockAiChatDataSource`, `HomeCubit`, `DiscoverCubit`, `DateTimeFormatter`)
- [x] Linter rules for code formatting
- [x] BLoC as a state management
- [x] Home screen, with search moved to the second tab
- [x] The Chat bottom sheet expands to full screen when the keyboard is opened for better UX —
  achieved by replacing `DraggableScrollableSheet` with a custom implementation

## Improvements to Consider

- [ ] Add Widget tests and integration tests
- [ ] Handle chat responses via WebSockets for a more fluid, streaming UX
- [ ] Some icons are in PNG format because they didn't work directly in Flutter — properly optimised
  SVG files from designers would be needed to use SVG for all icons
- [ ] Pagination for lists, so only the visible items are loaded and the next page is fetched as the
  user scrolls
- [ ] Display AI-generated suggestions after each response based on conversation context, to reduce
  the need for manual typing
- [ ] Real API integration — replace `MockAiChatDataSource` with an HTTP client
- [ ] Voice input — wire up the microphone button to speech-to-text
- [ ] Offline / cache — cache event results with `hive` or `drift` for offline viewing
- [ ] Deep linking — use `go_router` for URL-based navigation to event details
- [ ] Accessibility — add `Semantics` labels to all interactive elements
- [ ] Analytics — track prompt selections and event card taps to improve AI suggestions

## Trade-offs

| Decision                              | Rationale                                                                                      |
|---------------------------------------|------------------------------------------------------------------------------------------------|
| `flutter_bloc` over Riverpod          | More explicit event/state contract; easier to audit state transitions in an assignment context |
| Mocked repository as a plain class    | Keeps the architecture honest (real repo interface) without needing a DI framework             |
| `Navigator.push` instead of go_router | Simpler for a 3-screen app; go_router dependency retained for future deep-linking              |
| Unsplash images via network           | Avoids bundling assets; real implementation would use a CDN or cached image loader             |

- **Not pixel-perfect** — polishing to the exact spec doesn't add much value in a test project. In a
  production project, pixel-perfect components make sense because they can be reused and don't need
  per-screen adjustment.
- **`BackdropFilter` for blur on the Discover page** — used to create the blur effect when the Chat
  is open, but `BackdropFilter` is relatively heavy in Flutter and can cause small frame drops on
  older devices. A simpler box with a semi-transparent overlay would be more performant.
- **Timestamp and error message rendered outside the chat bubble** — looks cleaner visually; can be
  moved inside the bubble if the designer prefers.
- **Like button positioned at the top** — the category label can be longer than the date, so placing
  the like button at the top avoids layout conflicts.
- **No sliver app bar on the Discover screen** — a `SliverAppBar` would allow the search bar,
  filters, and sorting row to collapse while scrolling the event list, improving the browsing
  experience.

## Assumptions

- The Figma file shows a dark-mode-only design; no light-mode variant was implemented.
- The Event Details page from the design was recreated (not reused from production code).
- Profile tab is a placeholder — out of scope per the assignment.
- Images use Unsplash URLs as stand-ins for real event images.
