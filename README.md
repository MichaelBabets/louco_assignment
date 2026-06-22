# Louco – Ask AI Event Discovery

A Flutter implementation of the Ask AI event discovery feature, built as a technical assignment.

## Features

- **Home Page** – Featured event hero with horizontal scroll of today's events
- **Discover Page** – Search bar with filter chips and an **Ask AI** button
- **AI Chat Bottom Sheet** – Conversational interface with suggested prompts, typing indicator, and event results grid
- **Event Details Page** – Full-screen event detail view with hero image and ticket CTA
- **Event Card** – Reusable card component with image, time badge, category badge, and favourite toggle

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
│   ├── models/       # Shared data models (Event)
│   ├── theme/        # AppColors + AppTheme
│   └── widgets/      # Shared EventCard widget
├── features/
│   ├── home/         # Home page with featured event
│   ├── discover/     # Search + filter + Ask AI entry point
│   ├── ai_chat/      # BLoC + bottom sheet + widgets
│   └── event_details/ # Event detail page
├── app.dart          # MaterialApp + bottom nav shell
└── main.dart         # Entry point
```

**State management:** `flutter_bloc` (BLoC pattern)
- `AiChatBloc` manages the full conversation lifecycle: initial greeting → user message → loading → AI response with events

**Navigation:** `Navigator.push` from within the bottom nav shell; the bottom sheet dismisses itself before navigating to event details.

**API:** Mocked via `AiChatRepository` with a simulated 1.2-second delay. The repository applies keyword matching to return contextually relevant events (e.g. "free", "pop", "tonight"). Swapping in a real endpoint means only changing `sendMessage()`.

## Assumptions

- No backend was provided, so API responses are mocked locally.
- The Figma file shows a dark-mode-only design; no light-mode variant was implemented.
- The Event Details page from the design was recreated (not reused from production code).
- Profile tab is a placeholder — out of scope per the assignment.
- Images use Unsplash URLs as stand-ins for real event images.

## Trade-offs

| Decision | Rationale |
|---|---|
| `flutter_bloc` over Riverpod | More explicit event/state contract; easier to audit state transitions in an assignment context |
| Mocked repository as a plain class | Keeps the architecture honest (real repo interface) without needing a DI framework |
| `Navigator.push` instead of go_router | Simpler for a 3-screen app; go_router dependency retained for future deep-linking |
| Unsplash images via network | Avoids bundling assets; real implementation would use a CDN or cached image loader |

## Future Improvements

- **Real API integration** – Replace `AiChatRepository` with an HTTP client hitting the Louco AI endpoint; add retry + exponential backoff.
- **Streaming responses** – Stream AI text token-by-token for a more fluid UX.
- **Voice input** – Wire up the microphone button to speech-to-text.
- **Offline / cache** – Cache event results with `hive` or `drift` for offline viewing.
- **Deep linking** – Use `go_router` for proper URL-based navigation to event details.
- **Accessibility** – Add `Semantics` labels to all interactive elements.
- **Tests** – Unit tests for `AiChatBloc`, widget tests for the bottom sheet states (empty, loading, results, error).
- **Analytics** – Track prompt selections and event card taps to improve AI suggestions.
