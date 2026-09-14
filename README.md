# dotfiles

Personal development environment bootstrap and cross-device Pi session sync.

## What this repo does

- Installs the universal `pi-cloud` command.
- Installs `rclone` when missing.
- Installs Pi coding agent when missing.
- Uses the current Git repository name as the project name automatically.
- Syncs Pi sessions through Google Drive under:

  `AI-Agent-Sessions/<project-name>/pi`

- Keeps each project's sessions separate.
- Supports local Linux/WSL and GitHub Codespaces.

## Daily usage

Inside any Git repository:

```bash
pi-cloud
```

If cloud sessions already exist, `pi-cloud` opens Pi's resume picker. If the project has no sessions yet, it starts a new session.

To force a brand-new session:

```bash
pi-cloud new
```

Example:

```bash
cd /workspaces/FPV-Drone-Trainer
pi-cloud
```

This maps automatically to:

```text
gdrive:AI-Agent-Sessions/FPV-Drone-Trainer/pi
```

Another repo such as:

```bash
cd /workspaces/Family-Tree
pi-cloud
```

maps automatically to:

```text
gdrive:AI-Agent-Sessions/Family-Tree/pi
```

## Google Drive / rclone requirement

The rclone remote is expected to be named `gdrive` by default.

Local Linux/WSL uses the normal rclone configuration, typically:

```text
~/.config/rclone/rclone.conf
```

For GitHub Codespaces, create a Codespaces secret named:

```text
RCLONE_CONFIG_B64
```

Its value should be the base64-encoded contents of a working `rclone.conf`.

`install.sh` restores it to:

```text
/workspaces/.private/rclone/rclone.conf
```

Do not commit `rclone.conf`, OAuth tokens, or Pi `auth.json` to this repository.

## Install manually

```bash
git clone https://github.com/daluoter/dotfiles.git ~/dotfiles
cd ~/dotfiles
./install.sh
source ~/.bashrc
```

## GitHub Codespaces dotfiles

In GitHub account settings, enable Codespaces dotfiles and select this repository. New Codespaces can then run `install.sh` automatically.

You still need to grant the `RCLONE_CONFIG_B64` Codespaces secret access to every repository whose Codespace should use Google Drive session sync.

## Storage layout

Google Drive:

```text
AI-Agent-Sessions/
├── FPV-Drone-Trainer/
│   └── pi/
├── Family-Tree/
│   └── pi/
└── Other-Project/
    └── pi/
```

Local Linux/WSL:

```text
~/.pi-sync/<project-name>/
```

GitHub Codespaces:

```text
/workspaces/.pi-sync/<project-name>/
/workspaces/.private/pi-agent/
/workspaces/.private/rclone/rclone.conf
```

## Safety rule

Do not actively continue the same Pi session on two machines at the same time. Finish on one machine, let `pi-cloud` upload the session, then start `pi-cloud` on the next machine.

## Optional overrides

You can change defaults with environment variables:

```text
PI_CLOUD_REMOTE        default: gdrive
PI_CLOUD_ROOT          default: AI-Agent-Sessions
PI_CLOUD_PROJECT_NAME  override detected repository name
PI_CLOUD_SESSION_ROOT  local Linux/WSL session root
```
