---
name: serve-on-devin-cloud
description: Build the Flutter web app on a Devin Cloud VM (not locally) and serve it at http://localhost:8080 via devin forward
argument-hint: "[session-id-or-url]"
---

Build the Quick Chat web app on a Devin Cloud session's VM and expose it as `http://localhost:8080` on this machine.

Rules from the user:
- Do NOT run `flutter build` locally. All compiling happens on the VM.
- Only use the cloud session to build and serve the app. Don't change anything else on the VM.
- Local changes reach the VM through git (push a branch, clone/pull it on the VM), never by copying build output.

## 1. Push the code

1. `git status` in the repo. If there are uncommitted changes the user wants on the VM, commit them.
2. Push to a branch, not `main`. Past work in this repo went through PRs. If on `main`, create a branch first (for example `git checkout -b chore/<topic>`).
3. `git push -u origin <branch>`. Remember the branch name. The remote is public, so the VM can clone it over https without credentials.

## 2. Get a cloud session

- If the user gave a session ID or URL (`devin-<32 hex>` or `app.devin.ai/sessions/...`), use it.
- Otherwise create one: `devin --cloud -p "Reply with the single word ready. Do not run any commands or change anything."` (run from a scratch dir such as `/tmp/cloudsess`, in the background, because it takes about a minute). It prints only "ready", NOT the session ID, and no repo is cloned onto the VM.
- To find the ID, run `devin ssh` with no argument in a TTY shell (`tty: true`). The picker lists the newest session first, with its `devin-<id>`. Press Ctrl-C or kill the shell afterwards. `devin list` and the CLI logs do not show cloud session IDs.

## 3. SSH in

- `devin ssh <session>` needs a real TTY. Run it with the exec tool's `tty: true` and send commands with `write_to_process`. Piping stdin or passing a remote command fails with `Error: No such device or address (os error 6)`.
- The first connection asks to trust the `ssh.devin.ai` host key (the docs publish no fingerprint). Answer `yes` and tell the user the fingerprint you accepted.
- The connection can drop with "Session has ended". Just reconnect, since the VM and its files persist.
- Start long commands with `nohup ... > /tmp/log 2>&1 &` so a dropped SSH connection doesn't kill them.

## 4. Build on the VM

The VM is Ubuntu 22.04 with git and python3. `~/repos` holds other projects and `quick-chat` is not cloned. `flutter` is not on PATH by default, and an older Flutter (it was 3.47.6) may sit in `~/flutter`.

Use the Flutter version pinned in `.devcontainer/Dockerfile` (`FLUTTER_VERSION`). Install it next to the existing one instead of modifying `~/flutter`:

```bash
git clone -b <branch> https://github.com/wilmarques/quick-chat.git ~/repos/quick-chat   # if it exists already: cd ~/repos/quick-chat && git fetch && git checkout <branch> && git pull
[ -d ~/flutter-<ver> ] || git clone --depth 1 -b <ver> https://github.com/flutter/flutter.git ~/flutter-<ver>
export PATH=$HOME/flutter-<ver>/bin:$PATH
cd ~/repos/quick-chat
nohup sh -c 'flutter config --enable-web --no-analytics && flutter pub get && flutter build web --release --base-href / && echo BUILD_OK' > /tmp/qc-build.log 2>&1 &
```

- Use `--base-href /` so the app loads at the root of `localhost:8080`. (`deploy-to-ghpages.sh` uses `/quick-chat/` for GitHub Pages, which would not work at the root.)
- The build takes about 1.5 minutes (including the first `flutter pub get` and engine download). Wait for `BUILD_OK` in `/tmp/qc-build.log` with `tail`. Don't poll in a tight loop. Use `sleep 60; tail -3 /tmp/qc-build.log`.

## 5. Serve on the VM

```bash
nohup python3 -m http.server 8080 --directory ~/repos/quick-chat/build/web > /tmp/qc-serve.log 2>&1 &
sleep 2; curl -s -o /dev/null -w "%{http_code}\n" http://localhost:8080/    # expect 200
```

If port 8080 is taken (a previous server), `pkill -f "http.server 8080"` first, and re-serve after every rebuild only if the server isn't already running (it serves the directory live).

## 6. Forward to localhost

On this machine, in a background shell with `timeout: 0`:

```bash
devin forward <session-id> 8080          # http://localhost:8080  ->  VM :8080
```

It runs until Ctrl-C, so leave it running. Pick a different local port if 8080 is busy here (`devin forward <session> 8081:8080`).

Verify with `curl -s -o /dev/null -w "%{http_code}\n" http://localhost:8080/`, then call `browser_preview` for `http://localhost:8080` so the user can open it.

## 7. Report

Tell the user: the branch pushed, the session ID, the Flutter version used on the VM, the URL, and that the forward and the VM server keep running until stopped (Ctrl-C the forward, or `close_browser_preview` and `kill_shell` the forward shell). Mention that the cloud session itself keeps existing and can be archived with `/archive` from `devin --cloud -r <id>`.

## Redeploying after more changes

Commit and push, then in the SSH shell: `cd ~/repos/quick-chat && git pull`, re-run the build command from step 4 (same PATH), and reload the page. The server and forward are still up.
