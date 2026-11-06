# talos-messaging/

`signal.json` is the document the Talos Messaging phone app fetches to find the
relay that introduces it to its agent:

- `websocket` — the relay's socket template (`clud.bot/talos-messaging/signal`),
  room = `sha256(install_key)[:32]`, one `agent` seat and one `phone` seat.
- `agent_command` — what the machine runs to hold the agent seat.

This directory is staged into the Render static site's `_site/` by the service's
build command, so the file is served at
`https://talosbot.ai/talos-messaging/signal.json`. It is a static site: the
WebSocket terminates on the host named in `websocket`, not here.

Deploys: this repo is served by the Render static site `talosbot`, which
watches `main` — a push is a deploy.
