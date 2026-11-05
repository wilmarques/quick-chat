# AGENTS.md

## Verification

- The Flutter SDK version is pinned by `env.FLUTTER_VERSION` in `.github/workflows/deploy-web.yml`; keep it accurate.
- `.github/workflows/deploy-web.yml` runs `flutter pub get --enforce-lockfile`, `flutter analyze --no-pub`, `flutter test --no-pub`, and `flutter build web --release --no-pub --base-href /quick-chat/` on every push/PR to `main`. Let CI run these checks; do not compile the web app locally.
- Deployment to GitHub Pages goes through GitHub Actions only: `deploy-web.yml` deploys on every push to `main` (or a manual `workflow_dispatch` on `main`).
- For a local preview of the built web app, use the `serve-on-devin-cloud` skill, which builds on a Devin Cloud VM and forwards it to `http://localhost:8080`.
- The site is served under the `/quick-chat/` base href and is an installed PWA; `web/manifest.json` `id`/`start_url` and the `--base-href /quick-chat/` must remain stable.
