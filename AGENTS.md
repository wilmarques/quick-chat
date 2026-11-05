# AGENTS.md

## Verification

- The Flutter SDK version is pinned by `env.FLUTTER_VERSION` in `.github/workflows/deploy.yml`; keep it accurate.
- `.github/workflows/deploy.yml` runs `flutter pub get --enforce-lockfile`, `flutter analyze --no-pub`, `flutter test --no-pub`, and `flutter build web --release --no-pub --base-href /quick-chat/` on every push/PR to `main`. Let CI run these checks; do not compile the web app locally.
- Versioning follows SemVer via Release Please and Conventional Commits: `feat` bumps minor, `fix` bumps patch, `feat!`/`BREAKING CHANGE` bumps major; `chore`, `ci`, `docs`, etc. never release. Release Please keeps a release PR open that bumps `version` in `pubspec.yaml` (incrementing the `+build` number), `CHANGELOG.md` and `.release-please-manifest.json`. Never bump the version by hand.
- Deployment to GitHub Pages goes through GitHub Actions only, and only when a release is created (the release PR is merged). Ordinary pushes to `main` never deploy.
- Release Please authenticates as a GitHub App (repo variable `RELEASE_APP_CLIENT_ID`, secret `RELEASE_APP_PRIVATE_KEY`) so CI runs on its release PRs without manual approval; without them it falls back to `GITHUB_TOKEN`.
- For a local preview of the built web app, use the `serve-on-devin-cloud` skill, which builds on a Devin Cloud VM and forwards it to `http://localhost:8080`.
- The site is served under the `/quick-chat/` base href and is an installed PWA; `web/manifest.json` `id`/`start_url` and the `--base-href /quick-chat/` must remain stable.
- The `build-android` job in `.github/workflows/deploy.yml` shares the Web Flutter pin, triggers and Release Please job. It runs locked dependency installation, analysis, tests, and release AAB/APK builds on every push/PR to `main`; keystore configuration and the `android-release` artifact upload run only when `release_created == 'true'`. CI writes `android/key.properties` from `ANDROID_KEYSTORE_BASE64`, `ANDROID_KEYSTORE_PASSWORD`, `ANDROID_KEY_ALIAS` and `ANDROID_KEY_PASSWORD`. Without a keystore, builds use the debug key, which Google Play rejects. There is no Play Store deployment.
- The Android Gradle files follow the Kotlin DSL template of the pinned Flutter version (`flutter create --platforms android`); compile/target/min SDK come from the Flutter Gradle plugin (`flutter.*SdkVersion`).
