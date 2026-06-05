# Jeff Kit's Homebrew Tap

Homebrew formulae for Jeff Kit's open source tools.

## Install

```bash
brew tap jeffkit/tap
brew install ilink-hub
```

## Formulae

| Formula | Description |
|---------|-------------|
| `ilink-hub` | iLink-compatible multiplexer hub for WeChat ClawBot |

## Usage after install

```bash
# Login (scan QR code)
ilink-hub login

# Start Hub
ilink-hub serve --addr 0.0.0.0:8765

# Register a client
ilink-hub register --hub-url http://localhost:8765 --name my-ai

# View documentation
open https://jeffkit.github.io/ilink-hub/
```
