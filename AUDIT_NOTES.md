# Bus Track Mobile audit notes

## Architecture

- Flutter application using Provider for application state and GetX for parts
  of navigation/network binding.
- Dio and `http` provide backend and route-service access.
- Shared preferences store the signed-in user, permissions, token, and account
  type.
- Driver operations remain in `DriverProvider`; no API endpoint, request body,
  response model, or production base URL was changed.

## Driver UI changes

- Added a dedicated driver shell with bottom navigation in this order:
  Payments, Students, Trips, Schools, Profile.
- Added a shared yellow, navy, white, and light-gray Material theme.
- Added an active-trip student manifest view and an assigned-school view using
  the existing driver provider methods.
- Preserved trip creation, active-trip map/dispatch, student pickup/drop-off,
  payment history, school assignment, profile, and logout flows.

## Runtime fixes

- Corrected the malformed primary color value.
- Initialized driver student collections and their loading status to prevent
  late-initialization crashes.
- Corrected driver trip and school fetches that previously set the state to
  `Error` in `finally`, including after a successful response.
- Made driver action methods return `false` on request failure instead of
  throwing on a null assertion.
- Moved payment-history loading out of `build()` to prevent repeated requests.
- Removed profile preference loading from `build()` to prevent rebuild loops.
- Corrected the stored account-type key used when restoring a session.
- Awaited user restoration before choosing the next screen.
- Limited the parent active-trip lookup to parent sessions.
- Made the dispatch list load its own data and safely dispose its controllers.

## Verification

- `flutter analyze`: no compile errors (legacy warnings/deprecations remain).
- `flutter test`: all focused tests pass.
- `flutter build apk --debug`: succeeds.

## Intentionally unchanged

- The production API base URL and all backend endpoints/contracts.
- Existing business rules, permission checks, provider ownership, and response
  models.
- The existing certificate override and embedded service keys. These should be
  reviewed before a production release, but changing them safely requires the
  backend and deployment configuration.
- Broad legacy deprecation cleanup. The remaining warnings are non-blocking;
  replacing older map, URL-launcher, notification, and Dio APIs should be done
  as a separately tested dependency-migration task.

Live authenticated backend flows and iOS compilation were not exercised in
this environment. Android source compilation, tests, and a debug APK build were
completed successfully.
