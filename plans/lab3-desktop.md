# Complete the desktop Home Pantry laboratory

This is a living ExecPlan maintained according to the repository root PLANS.md. Progress, discoveries, decisions and outcomes must be updated as work continues.

## Purpose / Big Picture


Deliver a Flutter web application whose desktop interface implements the supplied Home Pantry screens. A user must be able to open registration and recovery from login, enter the dashboard, switch to inventory and profile, open and dismiss the product dialog, and sign out. Laboratory 3 requires interface construction without server integration, reusable widgets, a remote repository, actual application screenshots and a formatted report. Mobile adaptation is a later phase and is not an acceptance requirement for this desktop milestone.

## Progress


- [x] (2026-10-05) Read the assignment pages 18–19 and extract seven desktop reference screens from the previous report.
- [x] (2026-10-05) Implement login, registration, recovery, dashboard, inventory, profile and product dialog in lib/ with demonstration data.
- [x] (2026-10-05) Add navigation tests in test/widget_test.dart and reusable widgets in lib/core/widgets/pantry_widgets.dart.
- [x] (2026-10-05) Preserve the original main.dart and widget_test.dart in the chat workspace work/pantry-backup/.
- [x] (2026-10-05) Obtain permission to write the project and Flutter caches and download required components.
- [x] (2026-10-05) User confirmed Flutter 3.47.6 works in their own PowerShell; the runtime error is specific to agent execution.
- [x] (2026-10-05) Configure VS Code SDK path, initialize local Git, and prepare scripts/Check-Lab3.ps1; PowerShell syntax check passed.
- [x] (2026-10-05) Prepare a Markdown report draft with code examples and explicit missing-evidence markers.
- [x] (2026-10-05) Read verification logs, fix text overflow and ListTile Material issues, and confirm the rerun passed.
- [x] (2026-10-05) Formatting completed; analysis reports No issues found; all three navigation tests passed.
- [x] (2026-10-05) Release web build completed and produced build/web/.
- [ ] Start the built web app, compare with Figma, and capture the five required screens plus project structure.
- [ ] Prepare and visually review the Word report with actual screenshots and code excerpts.
- [ ] Connect a GitHub repository after the user supplies the account or repository details.

## Surprises & Discoveries


The project package configuration refers to C:/src/flutter, which is absent. The installed SDK at C:/Users/Yarema/flutter reports Flutter 3.47.6 and Dart 3.13.5 in its version file but lacks cached engine artifacts. A second SDK directory exists inside the application at flutter/ and must not be treated as application source.

The installed dart.exe can print its version but cannot launch its tools in the current execution environment. The Flutter launcher produces the following output before dependency downloads:

    Empty value for option resolved_executable_name
    Setting VM flags failed: Unrecognized flags: resolved_executable_name

Direct dartvm execution also fails to canonicalize the snapshot path with OS error 5. Network and filesystem write permission did not remove this failure. The user has been asked to try the version command in their own PowerShell to distinguish a tool environment restriction from a broken installation. No successful tests or build may be claimed from the current state.

## Decision Log


Decision: implement desktop first at 1440 × 1025. Rationale: the user explicitly requested that phase first, the reference images are 1440 × 1024 and the assignment does not explicitly require responsive layout. Date/author: 2026-10-05, Codex.

Decision: retain demonstration data and route changes instead of backend logic. Rationale: assignment items 3–4 explicitly permit static data and a login button that opens the home screen. Date/author: 2026-10-05, Codex.

Decision: do not fabricate screenshots or claim password recovery delivery. Rationale: screenshots must demonstrate the actual application; no mail provider or backend exists. Date/author: 2026-10-05, Codex.

Decision: copy the user supplied execution plan specification into PLANS.md. Rationale: AGENTS.md explicitly references that document, which was missing. Date/author: 2026-10-05, Codex.

## Outcomes & Retrospective


The first implementation and navigation tests are saved. Analysis, all three tests and release web compilation are now confirmed. Visual verification and the remote repository remain incomplete. Environment repair must precede claims that the laboratory is finished. A report draft can be prepared independently, but missing evidence must remain explicitly marked until real application screenshots are captured.

## Context and Orientation


The application root is C:/Users/Yarema/pantry. lib/main.dart launches MyApp and registers /login, /register, /reset and /home routes. lib/screens/auth_screen.dart contains AuthScreen and the AuthMode enum. lib/screens/home_screen.dart contains HomeScreen, DashboardContent, PantryContent and the product dialog. lib/core/widgets/pantry_widgets.dart contains PantryColors, PantryField, PantryButton and PantryCard. test/widget_test.dart exercises screen transitions at a desktop viewport size.

The assignment PDF is C:/Users/Yarema/Downloads/Лабораторна 3.docx (1).pdf. Its requirements are on pages 18–19. The prior report is C:/Users/Yarema/Desktop/КПП/Берник_Лаб2_КПП.docx. Seven embedded reference images were extracted to C:/Users/Yarema/Documents/Codex/2026-10-05/g/work/lab2-images/. Images 2 through 8 are registration, login, recovery, dashboard, inventory, product dialog and profile in that order. Final chat deliverables belong in C:/Users/Yarema/Documents/Codex/2026-10-05/g/outputs/.

## Plan of Work


First obtain a functioning invocation of the existing SDK. Do not replace generated configuration by hand; use flutter pub get to regenerate it once Flutter runs. Set dart.flutterSdkPath in .vscode/settings.json to the verified installed SDK if needed, preserving the existing CMake setting. Keep SDK repairs separate from interface source.

Next run formatting, analysis and the three tests. Make fixes in the named application files rather than changing dependency versions or suppressing diagnostics. Compare actual desktop output with the seven reference screens. The visual scope includes cream backgrounds, terracotta buttons, a 260-pixel sidebar, rounded cards, centered authentication forms and readable profile fields. Use actual widgets for every interactive control.

Then build the web release, start a local server and capture each required screen. Assemble a Word report using the previous report for student identity and the PDF formatting requirements. The report must include a repository URL only after a repository actually exists. Until then use an explicit outstanding-item marker. Ask for GitHub access or an existing URL rather than guessing an account.

## Concrete Steps


In PowerShell at C:/Users/Yarema/pantry, use the verified Flutter installation. The commands below assume its bin directory is available in PATH:

    flutter --version
    flutter pub get
    dart format lib test
    flutter analyze lib test
    flutter test
    flutter build web --release
    flutter run -d web-server --web-port 8080

Successful analysis should report no issues. Successful tests should report three passed navigation tests. A successful release build should produce build/web/. Visiting the server in a browser should show The Pantry login form, not the old photograph-only application.

The user environment probe is:

    & 'C:\Users\Yarema\flutter\bin\flutter.bat' --version

## Validation and Acceptance


At 1440 × 1025 the login form must be centered and both password-related links visible. Registration must show user name, email, password and confirmation fields. Recovery must show an email field and a return link; pressing Send reset link must explain that the demonstration has no mail connection.

Press Come on in and observe Welcome, Yarema, three statistics cards and recent activity. Select Profile and observe masked current and new password fields. Sign Out must return to login. Select Pantry and observe the static product rows. Add Product must open the form and Cancel must dismiss it. No tested screen may report a Flutter layout overflow.

Report acceptance requires A4 portrait pages with 2 cm margins, 14 pt body text, 1.25 line spacing, 1 cm first-line indentation, justified body paragraphs, centered bold headings and page numbers hidden on the title page. Include topic, purpose, assignment, results and conclusions, plus actual screenshots and code excerpts for login, home and reusable widgets.

## Idempotence and Recovery


Formatting and tests can be repeated safely. Do not delete or move the SDK directories. Preserve the user's existing settings, assets and source changes. Dependency installation may be retried after environment or network repair. The old two source files were backed up, but restoring them would remove the new screens and must not happen without a reason. Do not use flutter clean as a speculative fix.

## Artifacts and Notes


AGENTS.md records project rules and PLANS.md contains the user supplied planning specification. This file records the ongoing implementation state. Keep evidence of failures distinct from completed checks. The report must not use Figma reference images as if they were implementation screenshots.

## Interfaces and Dependencies


Keep MaterialApp route registration in MyApp.build. AuthScreen takes a required AuthMode mode. HomeScreen owns the currently selected navigation destination. Shared PantryField accepts label, hint and secret parameters; PantryButton accepts label and onPressed; PantryCard accepts child and padding. The only application libraries remain Flutter and cupertino_icons; testing uses flutter_test and linting uses flutter_lints.

Revision note 2026-10-05: created the living plan after reading the user supplied PLANS specification and recording the reproducible runtime failure. The implementation already existed, so progress distinguishes saved source from unverified behavior.

Revision note 2026-10-05: the user confirmed the existing SDK is healthy in their PowerShell. Added a verification script so actual tests can run there without reinstalling the SDK. The repository is initialized locally; no remote has been created or published.

Revision note 2026-10-05: user ran the verification script. Formatting and analysis passed (No issues found); all three tests failed due to horizontal text overflows and a ListTile Material assertion. Wrapped long inline labels and health status, constrained the sidebar brand, and gave each ListTile its own Material ancestor. Verification must be rerun after these corrections. Web build was not reached. Context7 HTTP initialization succeeded (server 4.1.1); Playwright MCP 0.0.83 downloaded and configured in the user Codex configuration. Current chat tools have not refreshed.

Revision note 2026-10-05: the second user-run verification passed analysis and all three tests and produced build/web/. The Wasm dry-run message was informational; exit code was successful. Registered Figma MCP and started OAuth login, pending account authorization. Suggested the available GitHub integration, also pending user connection. Next milestones are Figma comparison, browser screenshots, remote repository and a verified Word report; responsive design remains a separate later phase.
