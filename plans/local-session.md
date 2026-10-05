# Add local user and pantry interactions

This ExecPlan follows PLANS.md in the application root and must remain current.

## Purpose / Big Picture


The user can enter a name at login or registration, see it on Dashboard and Profile, add products through the existing dialog, change quantities and delete products. All data lives in the HomeScreen state and resets when signing out or restarting. No server, storage or real authentication is introduced.

## Progress


- [x] (2026-10-05) Inspect existing authentication, shared fields, home page and navigation tests.
- [x] (2026-10-05) Add optional field controller and pass trimmed login/registration name to HomeScreen.
- [x] (2026-10-05) Add immutable product model, validated dialog, quantity changes and deletion by stable IDs.
- [x] (2026-10-05) Derive search, filters, statistics, stock freshness and recent activity from local state.
- [x] (2026-10-05) Add five tests for identity, CRUD, filtering, invalid inputs, cancellation and session reset.
- [ ] Run eight tests, formatting, analysis and web build in the user environment; a new verification was requested.
- [ ] Record actual verification results and tell the user how to reload the running app.

## Surprises & Discoveries


The current shared input has no controller. The home page uses fixed names, statistics and product tuples. Flutter runs in the user's PowerShell; previous direct agent execution failed before tools launched. The previous desktop source passed three navigation tests and a release web build.

## Decision Log


Decision: use HomeScreen-owned state and plain Dart models rather than a persistence library. Rationale: the requested behavior lasts one session and laboratory 3 does not require a backend. Date: 2026-10-05.

Decision: an empty login name keeps the existing Yarema demonstration default. Names are trimmed; passwords retain the existing demonstration behavior. Rationale: preserve current navigation tests and avoid implying real authentication. Date: 2026-10-05.

Decision: validate product name, positive finite quantity, selected category/unit and a real calendar expiry date. Quantity buttons change by one selected unit and never go below zero. Dashboard Total Items counts product records rather than adding incompatible units. Date: 2026-10-05.

## Outcomes & Retrospective


Implementation is saved. Validation of the new source is pending. The earlier passing build is not evidence for these new changes.

## Context and Orientation


The project is C:/Users/Yarema/pantry. lib/screens/auth_screen.dart currently builds three forms from AuthMode. lib/main.dart registers /home. lib/core/widgets/pantry_widgets.dart defines PantryField. lib/screens/home_screen.dart owns navigation and the current demonstration product dialog. test/widget_test.dart contains three navigation tests.

## Plan of Work


First make AuthScreen stateful to own and dispose the user-name controller. Pass its trimmed value as the /home route argument and construct HomeScreen with it. Add an optional TextEditingController to PantryField without changing existing call sites.

Next introduce an immutable PantryProduct with an ID, name, category, numeric quantity, unit and expiry date, plus a quantity-copy method. HomeScreen owns a seeded list, a monotonic ID counter, filters and recent activity. Move the dialog into AddProductDialog, a stateful form that returns validated data on Save and null on cancellation. Dispose every controller. Search and category filters operate on that same list. Use stable product IDs for button keys and deletion so filtering never changes which record is edited.

Finally update Dashboard counts from the list and render recent local actions. Add tests for user identity, registration identity, add/change/delete, invalid input, cancel, filter and session isolation. Preserve desktop visual structure; mobile adaptation remains separate.

## Concrete Steps


From C:/Users/Yarema/pantry run:

    dart format lib test
    flutter analyze lib test
    flutter test
    flutter build web --release

The existing scripts/Check-Lab3.ps1 also runs these checks and writes verification logs. In the running Flutter terminal press r to reload or R to restart after code changes.

## Validation and Acceptance


Enter Olena and observe Welcome, Olena and Olena in Profile. Add Rice with category Pantry, quantity 2, unit kg and a valid date; observe the new row and increased total record count. Increase and decrease quantity, delete the row and verify it disappears. Filter and search before deleting to prove actions target the correct ID. Empty name, invalid quantity and an impossible date keep the dialog open with useful field errors. Cancel leaves the list unchanged. Sign Out and log in again to observe the seeded inventory and the newly entered identity.

## Idempotence and Recovery


Do not change SDKs, dependency versions or generated files. Preserve an intermediate backup of edited application files in the chat's work directory. Repeated app runs create independent sessions. If agent execution is blocked, report that and ask the user to run the existing check script, then read its actual results.

## Artifacts and Notes


No public APIs, server endpoints, persistent database or credentials are added. The report must later describe this as an optional local demonstration feature.

## Interfaces and Dependencies


PantryField gets TextEditingController? controller. HomeScreen gets String userName with the default Yarema. PantryProduct exposes copyWithQuantity(double). AddProductDialog returns a PantryProduct via Navigator.pop. The application continues using only existing Flutter dependencies.

Revision note 2026-10-05: created before implementation to document the user-authorized local interactions and acceptance scenarios.

Revision note 2026-10-05: implementation and five additional tests are saved. Agent-side Dart formatting and analysis remain blocked by the existing resolvedExecutable runtime error. Requested the user-run verification script, whose stderr is now converted to plain text to avoid alarming PowerShell formatting for informational Flutter warnings. No new successful test or build result is claimed.
