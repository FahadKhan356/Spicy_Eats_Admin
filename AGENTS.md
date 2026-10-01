# Spicy Eats Admin — working notes for agents

## Project

Flutter **web** partner portal (restaurant owner side of Spicy Eats), not the
customer app. The customer app lives in the sibling repo `Spicy-Eats`.

- State: Riverpod (`StateProvider` / `Provider`, `flutter_riverpod`).
- Navigation: `go_router` (`lib/config/router.dart`, shell in
  `lib/Dashboard/widgets/admin_shell.dart`).
- Backend: Supabase (`lib/config/supabaseconfig.dart`, migrations in `supabase/`).

## Git workflow (required)

After **every** file change: verify, then `git add` only the files you touched,
`git commit`, and `git push origin master`. Never leave work uncommitted at the
end of a task — commit and push alongside the work, not at the very end.

- Remote: `https://github.com/FahadKhan356/Spicy_Eats_Admin.git`, branch `master`.
- Commit messages follow Conventional Commits, stay lowercase and descriptive,
  e.g. `feat(orders): ...`, `fix(menu): ...`, `chore(lint): ...`.
- Never stage build output or generated noise: `build/`, `.dart_tool/`,
  `macos/Pods/**`, `ios/Pods/**`, `*.g.dart` output you did not author.
- Never commit secrets. Keep Supabase keys out of new files; the anon key in
  `lib/config/supabaseconfig.dart` is the public client key and is intentionally
  overridable through `--dart-define=SUPABASE_URL/SUPABASE_ANON_KEY`.

## Before finishing a change

```
flutter analyze
flutter test
flutter build web --release   # the app ships as web, keep it compiling
```

`flutter analyze` must report 0 errors (the existing `file_names` /
`non_constant_identifier_names` infos are known noise and are not a reason to
rename files). Add or update a test in `test/` for any behaviour you fix.

## Known pitfalls

- **Never update a Riverpod provider from `initState`/`build`.**
  `MenuManagerRepo.fetchCategories` used to flip `loadingProvider` synchronously,
  so opening the Menu Manager threw *"Tried to modify a provider while the widget
  tree was building"* and blew the screen up. Load data from a post-frame
  callback, and `await` once inside a repo method before touching a provider so
  it is safe no matter who calls it. Guarded by
  `test/menu_manager_loading_test.dart`.
- **Initialise the binding inside the guarded zone.** `main()` runs the app in
  `runZonedGuarded`, so `WidgetsFlutterBinding.ensureInitialized()` must be the
  first statement *inside* that zone. Calling it in the root zone makes Flutter
  log a `Zone mismatch` error and breaks zone-scoped error handling.
- **`ErrorWidget.builder` output is mounted above `MaterialApp`** whenever the
  failure happens during the first build, so a custom error view must supply its
  own `Directionality`/`Material` or it throws and Flutter falls back to its raw
  red error screen.
